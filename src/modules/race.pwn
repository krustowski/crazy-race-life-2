#if defined _CRL2_RACE
	#endinput
#endif
#define _CRL2_RACE

//
//  race.pwn
//

#define MAX_RACE_NAME			64
#define MAX_RACE_CP				99
#define MAX_RACE_COUNT			64
#define MAX_RACE_PLAYERS		9

#define RACE_COUNTDOWN_SECONDS	20

enum RACE_EDIT_TYPE
{
	RACE_EDITOR_NONE,
	RACE_EDITOR_START_COORDS,
	RACE_EDITOR_TRACK_COORDS
}

enum Race
{
	ID,
	Name[MAX_RACE_NAME],
	Type,
	CostDollars,
	PrizeDollars,
	Start[Coords],
	CheckPointCount,

	bool: IsPrepared,

	// Race start line position helpers
	Float: AlphaAngle,
	Float: BetaAngle,

	// Indication for a started race
	bool: IsActive,

	TimeStarted,
	RegisteredCount,
	RegisteredPlayers[MAX_RACE_PLAYERS],

	Timer: StartRaceTimer,
	Timer: UpdateRaceInfoTimer,

	RACE_EDIT_TYPE: EditType,
	EditTrackCoordNo
}

enum PlayerRace
{
	RaceID,

	bool: IsRegistered,

	TimeElapsed,
	Position,
	CheckpointDoneCount,
	LastCheckpointTimestamp
}

new 
	gRaces[MAX_RACE_COUNT][Race],
	gRaceCoords[MAX_RACE_COUNT][MAX_RACE_CP][Coords],
	gPlayerRace[MAX_PLAYERS][PlayerRace],
	Text: gRaceInfoText[MAX_PLAYERS];

new
	gNullRace[Race],
	gPlayerRaceEdit[MAX_PLAYERS][Race],
	gPlayerRaceEditTrackCoords[MAX_PLAYERS][MAX_RACE_CP][Coords];

//
//  Race-related functions.
//

stock Race_Init()
{
	new 
		query[512];

	format(query, sizeof(query), "SELECT id, name, type, cost_dollars, prize_dollars, start_x, start_y, start_z FROM races ORDER BY id ASC");

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		print("Database error: cannot fetch race data!");
		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		
		print("No races to load!");
		return 1;
	}

	do
	{
		new
			id = DB_GetFieldIntByName(result, "id");

		if (id >= MAX_RACE_COUNT)
		{
			break;
		}

		new
			raceName[MAX_RACE_NAME];
		DB_GetFieldStringByName(result, "name", raceName, sizeof(raceName));
		gRaces[id][Name] = raceName;

		gRaces[id][ID] = id;
		gRaces[id][Type] = DB_GetFieldIntByName(result, "type");
		gRaces[id][CostDollars] = DB_GetFieldIntByName(result, "cost_dollars");
		gRaces[id][PrizeDollars] = DB_GetFieldIntByName(result, "prize_dollars");

		gRaces[id][UpdateRaceInfoTimer] = Timer: INVALID_TIMER;
		gRaces[id][StartRaceTimer] = Timer: INVALID_TIMER;

		new
			invalidPlayers[MAX_RACE_PLAYERS] = {INVALID_PLAYER_ID, ...};

		gRaces[id][RegisteredCount] = 0;
		gRaces[id][RegisteredPlayers] = invalidPlayers;

		new
			Float: pX,
			Float: pY,
			Float: pZ;

		pX = DB_GetFieldFloatByName(result, "start_x");
		pY = DB_GetFieldFloatByName(result, "start_y");
		pZ = DB_GetFieldFloatByName(result, "start_z");

		gRaces[id][Start][CoordX] = pX;
		gRaces[id][Start][CoordY] = pY;
		gRaces[id][Start][CoordZ] = pZ;

		EnsurePickupCreated(1314, 1, pX, pY, pZ);
		Create3DTextLabel("%s", COLOR_ORANGE, pX, pY, pZ, 15.0, -1, false, raceName);
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);
	print("Race props initialized!");

	return 1;
}

stock bool: Race_IsRaceActive(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return false;
	}

	return gRaces[raceid][IsActive];
}

stock Race_RegisterPlayer(playerid, raceid)
{
	if (!IsPlayerConnected(playerid))
	{
		return 0;
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_IN_MINIGAME_BLOCK);
	}

	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);
	}

	// Check if already joined any race
	if (gPlayerRace[playerid][IsRegistered])
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_JOINED);
	}

	if (Race_IsRaceActive(raceid))
	{
		// TODO: SendClientMessageLocalized: Already active
		return 0;
	}

	if (raceid == 0 || raceid >= MAX_RACE_COUNT)
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_SUCH_RACE);
	}

	if (GetPlayerMoney(playerid) < gRaces[raceid][CostDollars])
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_MONEY);
	}

	if (!gRaces[raceid][IsPrepared])
	{
		Race_PrepareRace(raceid);
	}

	//
	//  Ok, register the player with given raceid
	//

	gPlayers[playerid][InMinigame] = true;
	gPlayerRace[playerid][IsRegistered] = true;

	GivePlayerMoney(playerid, -gRaces[raceid][CostDollars]);

	gPlayerRace[playerid][RaceID] = raceid;
	gPlayerRace[playerid][TimeElapsed] = 0;
	gPlayerRace[playerid][CheckpointDoneCount] = 0;
	gPlayerRace[playerid][LastCheckpointTimestamp] = 0;

	gRaces[raceid][RegisteredPlayers][ gRaces[raceid][RegisteredCount] ] = playerid;
	gRaces[raceid][RegisteredCount]++;

	// Default position in race = registered position
	gPlayerRace[playerid][Position] = gRaces[raceid][RegisteredCount];

	if (!IsValidTimer(_: gRaces[raceid][StartRaceTimer]))
	{
		gRaces[raceid][StartRaceTimer] = Timer: SetTimerEx("Race_StartRace", RACE_COUNTDOWN_SECONDS * 1000, false, "i", raceid);
		// TODO: show countdown
	}

	new
		stringToPrint[256];

	GetLocalizedString(playerid, I18N_RACE_REGISTERED_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint,
			gRaces[raceid][Name], 
			gRaces[raceid][CostDollars]
		);

	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	Race_SetPlayerPos(playerid, raceid);
	SetCameraBehindPlayer(playerid);

	return 1;
}

stock Race_PrepareRace(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	Race_LoadRaceCheckpoints(raceid);

	// Calculate the raw alpha angle
	Race_GetStartFacingAngle(raceid);

	// Perpendicular to the direction of travel, used to line racers up side by side
	gRaces[raceid][BetaAngle] = floatadd(gRaces[raceid][AlphaAngle], 90.0);

	gRaces[raceid][IsPrepared] = true;

	return 1;
}

// Converts a standard math angle (0 deg = +X axis/east, CCW positive, as
// returned by atan2()) into a GTA Z-angle/heading. GTA headings are ALSO
// counter-clockwise: 0 = north, 90 = west, 180 = south, 270 = east -- so the
// conversion is angle - 90, not 90 - angle (that would be a mirror image,
// correct only for due-north/due-south directions).
stock Float: Race_HeadingFromAngle(Float: angle)
{
	new
		Float: heading = floatsub(angle, 90.0);

	if (heading < 0.0)
	{
		heading = floatadd(heading, 360.0);
	}

	return heading;
}

stock Race_GetStartFacingAngle(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	new
		Float: x1 = gRaces[raceid][Start][CoordX],
		Float: y1 = gRaces[raceid][Start][CoordY],
		Float: x2 = gRaceCoords[raceid][0][CoordX],
		Float: y2 = gRaceCoords[raceid][0][CoordY];

	new
		Float: diffX = floatsub(x2, x1),
		Float: diffY = floatsub(y2, y1);

	gRaces[raceid][AlphaAngle] = atan2(diffY, diffX);

	// printf("[race debug] id=%d start=(%.2f,%.2f) cp0=(%.2f,%.2f) diffX=%.2f diffY=%.2f AlphaAngle=%.2f heading=%.2f",
	// 		raceid, x1, y1, x2, y2, diffX, diffY, gRaces[raceid][AlphaAngle], Race_HeadingFromAngle(gRaces[raceid][AlphaAngle]));

	return 1;
}

stock Race_SetPlayerPos(playerid, raceid)
{
	// Decide where a registered racer should be put before a race start line
	//
	// ----- start -----            line no.:
	//   2     1     3              0
	//
	//   5-GAP-4     6              1
	//        
	//        ...

	new registeredPos = gRaces[raceid][RegisteredCount];

	// Beta angle used to calculate the relative gapped coords (perpendicular to the direction of travel)
	new Float: betaAngle = floatadd(gRaces[raceid][AlphaAngle], 90.0);

	// Gap between racers' vehicles
	new const Float: GAP = 5.0;

	// First line of vehicles perpendicular to the race direction (defined by the race start and the first CP)
	// Racer no. 1: [x0,y0],
	//       no. 2: [x1,y1],
	//       no. 3: [x2,y2], ...
	new
		Float: X[MAX_RACE_PLAYERS],
		Float: Y[MAX_RACE_PLAYERS];

	new
		lineNo = floatround( floatdiv(registeredPos, 3), floatround_ceil ) - 1,
		linePos = (registeredPos - 1) % 3,
		lineBasePos = (!lineNo) ? 0 : (lineNo * 3) - 1;

	if (lineNo + linePos >= MAX_RACE_PLAYERS)
	{
		return 0;
	}

	X[0] = gRaces[raceid][Start][CoordX];
	Y[0] = gRaces[raceid][Start][CoordY];

	switch (linePos)
	{
		// middle
		case 0:
			{
				// TODO: recalculate if lineNo > 0
			}
		// left
		case 1:
			{
				X[lineNo + linePos] = floatsub(X[lineBasePos], floatmul( GAP, floatcos(betaAngle, degrees) ));
				Y[lineNo + linePos] = floatsub(Y[lineBasePos], floatmul( GAP, floatsin(betaAngle, degrees) ));
			}
		// right
		case 2:
			{
				X[lineNo + linePos] = floatadd(X[lineBasePos], floatmul( GAP, floatcos(betaAngle, degrees) ));
				Y[lineNo + linePos] = floatadd(Y[lineBasePos], floatmul( GAP, floatsin(betaAngle, degrees) ));
			}
	}

	new
		vehicleid = GetPlayerVehicleID(playerid);

	// Freeze the driver first -- they're already PLAYER_STATE_DRIVER at this point
	// (required to register), so their client still owns the vehicle's physics sync.
	// Repositioning before this can race against that client's own updates, and any
	// speed/spin it was carrying survives the teleport otherwise.
	TogglePlayerControllable(playerid, false);

	SetVehicleZAngle(vehicleid, Race_HeadingFromAngle(gRaces[raceid][AlphaAngle]));
	SetVehiclePos(vehicleid, X[lineNo + linePos], Y[lineNo + linePos], gRaces[raceid][Start][CoordZ] + 2.00);
	SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);

	//SetPlayerPosFindZ(playerid, X[lineNo + linePos], Y[lineNo + linePos], 1000.0);

	return 1;
}

forward Race_StartRace(raceid);
public Race_StartRace(raceid)
{
	gRaces[raceid][IsActive] = true;
	gRaces[raceid][TimeStarted] = gettime();

	gRaces[raceid][UpdateRaceInfoTimer] = Timer: SetTimerEx("Race_UpdateRaceInfoText", 1 * SECOND_MS, true, "i", raceid);

	// Loop over registered players and unblock them (make controllable)
	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		if (gRaces[raceid][RegisteredPlayers][i] == INVALID_PLAYER_ID)
		{
			continue;
		}

		new
			gameText[32],
			playerid = gRaces[raceid][RegisteredPlayers][i];

		GetLocalizedString(playerid, I18N_RACE_STARTED_GAMETEXT, gameText, sizeof(gameText));
		GameTextForPlayer(playerid, gameText, 3000, 3);

		Race_SetNextCheckpoint(playerid, raceid);

		TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);

		TogglePlayerControllable(playerid, true);
	}

	return 1;
}

forward Race_UpdateRaceInfoText(raceid);
public Race_UpdateRaceInfoText(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	new 
		stringToPrint[128];

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		new
			playerid = gRaces[raceid][RegisteredPlayers][i];

		if (playerid == INVALID_PLAYER_ID)
		{
			continue;
		}

		gPlayerRace[playerid][TimeElapsed] += 1000;

		GetLocalizedString(playerid, I18N_RACE_INFO_TEXT_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint,
				raceid, 
				gPlayerRace[playerid][CheckpointDoneCount], 
				gRaces[raceid][CheckPointCount],
				gPlayerRace[playerid][Position],
				gRaces[raceid][RegisteredCount],
				floatround(floatround(gPlayerRace[playerid][TimeElapsed] / 1000) / 60), 
				floatround(gPlayerRace[playerid][TimeElapsed] / 1000) % 60
			);

		TextDrawSetString(gRaceInfoText[playerid], stringToPrint);
		TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);
	}

	return 1;
}

stock Race_CalculatePosition(raceid, playerid)
{
	if (raceid >= MAX_RACE_COUNT || !gRaces[raceid][RegisteredCount])
	{
		return 1;
	}

	if (!gPlayerRace[playerid][IsRegistered] || gPlayerRace[playerid][RaceID] != raceid)
	{
		return 1;
	}

	new
		playerCP = gPlayerRace[playerid][CheckpointDoneCount],
		playerTimestamp = gPlayerRace[playerid][LastCheckpointTimestamp];

	new
		position = 1;

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		new
			racerid = gRaces[raceid][RegisteredPlayers][i];

		if (racerid == INVALID_PLAYER_ID)
		{
			continue;
		}

		if (gPlayerRace[racerid][CheckpointDoneCount] > playerCP)
		{
			position++;
			continue;
		}

		if (gPlayerRace[racerid][CheckpointDoneCount] == playerCP)
		{
			if (gPlayerRace[racerid][LastCheckpointTimestamp] < playerTimestamp)
			{
				position++;
				continue;
			}
		}
	}
	
	gPlayerRace[playerid][Position] = position;

	return 1;	
}

stock Race_CheckCheckpoint(playerid)
{
	if (!gPlayerRace[playerid][IsRegistered])
	{
		return 0;
	}

	DisablePlayerRaceCheckpoint(playerid);

	gPlayerRace[playerid][LastCheckpointTimestamp] = gettime();
	gPlayerRace[playerid][CheckpointDoneCount]++;

	new
		raceid = gPlayerRace[playerid][RaceID];

	Race_SetNextCheckpoint(playerid, raceid);

	Race_CalculatePosition(raceid, playerid);

	return 1;
}

stock Race_LoadRaceCheckpoints(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	new 
		query[512];

	format(query, sizeof(query), "SELECT seq_no, x, y, z, rot FROM race_coords WHERE race_id = %d ORDER BY seq_no ASC", raceid);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		print("Database error: cannot fetch race coords data!");
		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);

		print("No race coords to load!");
		return 0;
	}

	new
		i = 0;

	do
	{
		gRaceCoords[raceid][i][CoordX] = DB_GetFieldFloatByName(result, "x");
		gRaceCoords[raceid][i][CoordY] = DB_GetFieldFloatByName(result, "y");
		gRaceCoords[raceid][i][CoordZ] = DB_GetFieldFloatByName(result, "z");

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	gRaces[raceid][CheckPointCount] = i;

	return 1;
}

stock Race_SetNextCheckpoint(playerid, raceid)
{
	if (!gPlayerRace[playerid][IsRegistered])
	{
		return 0;
	}

	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	// Fetch the relative position in such race (position of checkpoints)
	new 
		raceCpPosition = gPlayerRace[playerid][CheckpointDoneCount], 
		raceType = gRaces[raceid][Type];

	// Prepare the coords to show a race checkpoint
	new 
		Float: x0, 
		Float: y0, 
		Float: z0, 
		Float: x1, 
		Float: y1, 
		Float: z1, 
		CP_TYPE: cpType;

	switch (raceType) 
	{
		case 1:
			{
				cpType = CP_TYPE_GROUND_NORMAL;
			}
		case 2:
			{
				cpType = CP_TYPE_AIR_NORMAL;
			}
	}

	// End the race.
	if (raceCpPosition > gRaces[raceid][CheckPointCount])
	{
		Race_AbortMinigame(playerid, true);
		//ResetPlayerRaceState(playerid, raceId, true);
		return 1;
	}

	x0 = gRaceCoords[raceid][raceCpPosition][CoordX];
	y0 = gRaceCoords[raceid][raceCpPosition][CoordY];
	z0 = gRaceCoords[raceid][raceCpPosition][CoordZ];

	if (raceCpPosition + 1 <= gRaces[raceid][CheckPointCount])
	{
		x1 = gRaceCoords[raceid][raceCpPosition + 1][CoordX];
		y1 = gRaceCoords[raceid][raceCpPosition + 1][CoordY];
		z1 = gRaceCoords[raceid][raceCpPosition + 1][CoordZ];
	} 
	else
	{
		switch (raceType)
		{
			case 1:
				{
					cpType = CP_TYPE_GROUND_FINISH;
				}
			case 2:
				{
					cpType = CP_TYPE_AIR_FINISH;
				}
		}
	}

	// Set the next checkpoint to reach
	SetPlayerRaceCheckpoint(playerid, cpType, x0, y0, z0, x1, y1, z1, 10.0);

	return 1;
}

stock Race_AbortMinigame(playerid, success = false)
{
	if (!gPlayerRace[playerid][IsRegistered])
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_RACE);
	}

	DisablePlayerRaceCheckpoint(playerid);

	TextDrawHideForPlayer(playerid, gRaceInfoText[playerid]);
	//KillTimer(_: gPlayerRaceTimer[playerid]);
	//gPlayerRaceTimer[playerid] = Timer: 0;

	gPlayers[playerid][InMinigame] = false;
	gPlayerRace[playerid][IsRegistered] = false;

	new 
		gameText[32],
		raceid = gPlayerRace[playerid][RaceID];

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		if (gRaces[raceid][RegisteredPlayers][i] == playerid)
		{
			gRaces[raceid][RegisteredPlayers][i] = INVALID_PLAYER_ID;
			break;
		}
	}

	if (success)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_SUCCESSFULLY);

		new 
			playerName[MAX_PLAYER_NAME], 
			stringToPrint[256];

		GetPlayerName(playerid, playerName, sizeof(playerName));
		GivePlayerMoney(playerid, gRaces[raceid][PrizeDollars]);

		// Broadcast the localized message about a successful end of race
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			GetLocalizedString(i, I18N_RACE_FINISHED_FMT, stringToPrint, sizeof(stringToPrint));
			format(stringToPrint, sizeof(stringToPrint), stringToPrint,
					playerName, 
					gRaces[raceid][Name], 
					gRaces[raceid][PrizeDollars]
				);

			SendClientMessage(i, COLOR_LIGHTGREEN, stringToPrint);
		}

		GetLocalizedString(playerid, I18N_RACE_FINISHED_GAMETEXT, gameText, sizeof(gameText));
		GameTextForPlayer(playerid, gameText, 3000, 3);

		Race_SaveNewScore(raceid, playerid, gPlayerRace[playerid][TimeElapsed], GetVehicleModel(GetPlayerVehicleID(playerid)));
	}

	gPlayerRace[playerid][TimeElapsed] = 0;

	if (!success)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_PREMATURELY);

		GetLocalizedString(playerid, I18N_RACE_ABORTED_GAMETEXT, gameText, sizeof(gameText));
		GameTextForPlayer(playerid, gameText, 3000, 3); 
	}

	gPlayerRace[playerid][CheckpointDoneCount] = 0;

	return 1;
}

stock Race_SaveNewScore(raceid, playerid, time, vehicleModel)
{
	new 
		nickname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nickname);

	new 
		query[256];
	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, user_id, value, vehicle_model, time) VALUES (%d, %d, %d, %d, %d, %d)", 
			1,
			raceid, 
			gPlayers[playerid][OrmID], 
			time, 
			vehicleModel,
			time
		);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		SendClientMessageLocalized(playerid, I18N_RACE_DATABASE_ERROR);
		printf("Database error: cannot write high score data (race_id: %d, nickname: %s)!", raceid, nickname);

		return 0;
	}

	DB_FreeResultSet(result);

	InitHighScores();

	return 1;
}

// This number should be aither 0, or 1 at max! This means the player must be in just one race at the time!
// stock CheckPlayerRaceState(playerid)
// {
// 	for (new i = 0; i < MAX_RACE_COUNT; i++)
// 	{
// 		if (gPlayerRace[playerid][i])
// 		{
// 			// The player is racing at the moment!
// 			return i;
// 		}
// 	}

// 	// The player does not seem to be in any race now.
// 	return 0;
// }

// stock SetPlayerRaceStartPos(playerid)
// {
// 	new 
// 		raceId = CheckPlayerRaceState(playerid);

// 	if (!raceId)
// 	{
// 		SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_RACE);
// 		return 0;
// 	}

// 	if (gPlayerRace[playerid][raceId] > 1)
// 	{
// 		SendClientMessageLocalized(playerid, I18N_RACE_WARP_AFTER_START);
// 		return 0;
// 	}

// 	if (!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
// 	{
// 		SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);
// 		return 0;
// 	}

// 	SetVehiclePos(GetPlayerVehicleID(playerid), Float:gRaces[raceId][Start][E_RACE_COORD_X], Float:gRaces[raceId][Start][E_RACE_COORD_Y], Float:gRaces[raceId][Start][E_RACE_COORD_Z] + 2.00);

// 	return 1;
// }

//
//
//

enum HighScores
{
	Nickname1[64],
	Nickname2[64],
	Nickname3[64],
	Time[3],
	VehicleModel[3]
};

new 
	gHighScores[MAX_RACE_COUNT][HighScores];

stock InitHighScores()
{
	new 
		query[512];

	format(query, sizeof(query), "select spec_id, nickname, value, vehicle_model from ( select spec_id, u.nickname, value, vehicle_model, row_number() over ( PARTITION by spec_id ORDER by value ASC ) as rank from high_scores join users as u on u.id = user_id where type = 1 ) ranked where rank <= 3 order by spec_id, rank;");

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		print("Database error: cannot fetch high scores data!");
		return 0;
	}

	new 
		raceIds[MAX_RACE_COUNT];

	do
	{
		new 
			raceId = DB_GetFieldIntByName(result, "spec_id"),
			i = raceIds[raceId],
			name[64];

		DB_GetFieldStringByName(result, "nickname", name, sizeof(name));

		switch (i)
		{
			case 0:
				{
					gHighScores[raceId][Nickname1] = name;
				}
			case 1:
				{
					gHighScores[raceId][Nickname2] = name;
				}
			case 2:
				{
					gHighScores[raceId][Nickname3] = name;
				}
		}

		gHighScores[raceId][Time][i] = DB_GetFieldIntByName(result, "value");
		gHighScores[raceId][VehicleModel][i] = DB_GetFieldIntByName(result, "vehicle_model");

		raceIds[raceId]++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("High scores initialized!");

	return 1;
}

//
//
//

stock SaveRaceData(playerid)
{
	new 
		raceid = gPlayerRaceEdit[playerid][ID];

	if (raceid == -1)
	{
		return 1;
	}

	new 
		query[2048];
	format(query, sizeof(query), "INSERT INTO races (id, name, type, cost_dollars, prize_dollars, start_x, start_y, start_z) VALUES (%d, '%s', %d, %d, %d, %.2f, %.2f, %.2f)",
			gPlayerRaceEdit[playerid][ID],
			gPlayerRaceEdit[playerid][Name],
			1,
			gPlayerRaceEdit[playerid][CostDollars],
			gPlayerRaceEdit[playerid][PrizeDollars],
			gPlayerRaceEdit[playerid][Start][CoordX],
			gPlayerRaceEdit[playerid][Start][CoordY],
			gPlayerRaceEdit[playerid][Start][CoordZ]
		);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		SendClientMessageLocalized(playerid, I18N_RACE_DATABASE_ERROR);
		printf("Database error: cannot write new race data (race_id: %d)!", raceid);

		return 0;
	}

	DB_FreeResultSet(result);

	//

	format(query, sizeof(query), "INSERT INTO race_coords (race_id, seq_no, x, y, z, rot) VALUES (%d, %d, %.2f, %.2f, %.2f, %.2f)",
			gPlayerRaceEdit[playerid][ID],
			1,
			gPlayerRaceEditTrackCoords[playerid][0][CoordX],
			gPlayerRaceEditTrackCoords[playerid][0][CoordY],
			gPlayerRaceEditTrackCoords[playerid][0][CoordZ],
			0.0
		);

	for (new i = 1; i < gPlayerRaceEdit[playerid][EditTrackCoordNo]; i++)
	{
		format(query, sizeof(query), "%s ,(%d, %d, %.2f, %.2f, %.2f, %.2f)",
				query,
				gPlayerRaceEdit[playerid][ID],
				i + 1,
				gPlayerRaceEditTrackCoords[playerid][i][CoordX],
				gPlayerRaceEditTrackCoords[playerid][i][CoordY],
				gPlayerRaceEditTrackCoords[playerid][i][CoordZ],
				0.0
		      );
	}

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		SendClientMessageLocalized(playerid, I18N_RACE_DATABASE_ERROR);
		printf("Database error: cannot write new race coord data (race_id: %d)!", raceid);

		return 0;
	}

	DB_FreeResultSet(result);

	Race_Init();

	return 1;
}

