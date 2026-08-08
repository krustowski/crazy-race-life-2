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

	Float: StartingCoordX[MAX_RACE_PLAYERS],
	Float: StartingCoordY[MAX_RACE_PLAYERS],

	bool: IsPrepared,

	// Race start line position helpers
	Float: AlphaAngle,
	Float: BetaAngle,

	// Indication for a started race
	bool: IsActive,
	CountdownRemaining,

	TimeStarted,
	RegisteredCount,
	RegisteredPlayers[MAX_RACE_PLAYERS],

	Timer: StartRaceTimer,
	Timer: CountdownTimer,
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
		gRaces[id][CountdownTimer] = Timer: INVALID_TIMER;

		// Invalidate any cached precalculations
		gRaces[id][IsPrepared] = false;

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

	if (raceid == 0 || raceid >= MAX_RACE_COUNT)
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_SUCH_RACE);
	}

	if (Race_IsRaceActive(raceid))
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_RUNNING);
	}

	if (GetPlayerMoney(playerid) < gRaces[raceid][CostDollars])
	{
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_MONEY);
	}

	// Find a free start-grid slot
	new
		slot = -1;

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		if (gRaces[raceid][RegisteredPlayers][i] == INVALID_PLAYER_ID)
		{
			slot = i;
			break;
		}
	}

	if (slot == -1)
	{
		// TODO: localize this
		return SendClientMessage(playerid, COLOR_RED, "[ RACE ] This race is already full!");
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

	gRaces[raceid][RegisteredPlayers][slot] = playerid;
	gRaces[raceid][RegisteredCount]++;

	// Default position in race = registered position (or just use slot???)
	gPlayerRace[playerid][Position] = gRaces[raceid][RegisteredCount];

	if (!gRaces[raceid][CountdownRemaining])
	{
		gRaces[raceid][CountdownRemaining] = RACE_COUNTDOWN_SECONDS;
		gRaces[raceid][CountdownTimer] = Timer: SetTimerEx("Race_CountdownHelper", 1000, false, "i", raceid);
		gRaces[raceid][StartRaceTimer] = Timer: SetTimerEx("Race_StartRace", RACE_COUNTDOWN_SECONDS * 1000, false, "i", raceid);
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

static Race_PrepareRace(raceid)
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

	Race_CalculateStartingCoords(raceid);

	gRaces[raceid][IsPrepared] = true;

	return 1;
}

// Converts a standard math angle (0 deg = +X axis/east, CCW positive, as
// returned by atan2()) into a GTA Z-angle/heading. GTA headings are ALSO
// counter-clockwise: 0 = north, 90 = west, 180 = south, 270 = east -- so the
// conversion is angle - 90, not 90 - angle (that would be a mirror image,
// correct only for due-north/due-south directions).
static Float: Race_HeadingFromAngle(Float: angle)
{
	new
		Float: heading = floatsub(angle, 90.0);

	if (heading < 0.0)
	{
		heading = floatadd(heading, 360.0);
	}

	return heading;
}

static Race_GetStartFacingAngle(raceid)
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

	return 1;
}

static Race_CalculateStartingCoords(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	// Beta angle used to calculate the relative gapped coords (perpendicular to the direction of travel)
	new
		Float: alphaAngle = gRaces[raceid][AlphaAngle],
		Float: betaAngle = gRaces[raceid][BetaAngle];

	// Gap between racers' vehicles
	new
		const Float: GAP = 5.0;

	// First line of vehicles perpendicular to the race direction (defined by the race start and the first CP)
	// Racer no. 1: [x0,y0],
	//       no. 2: [x1,y1],
	//       no. 3: [x2,y2], ...
	new
		Float: X[MAX_RACE_PLAYERS],
		Float: Y[MAX_RACE_PLAYERS];

	X[0] = gRaces[raceid][Start][CoordX];
	Y[0] = gRaces[raceid][Start][CoordY];

	new
		Float: gapCosA = floatmul( GAP, floatcos(alphaAngle, degrees) ),
		Float: gapSinA = floatmul( GAP, floatsin(alphaAngle, degrees) ),
		Float: gapCosB = floatmul( GAP, floatcos(betaAngle, degrees) ),
		Float: gapSinB = floatmul( GAP, floatsin(betaAngle, degrees) );

	// i = the 1-based registration position; position 1 is the seeded start
	// coordinate itself, so the loop fills positions 2..MAX_RACE_PLAYERS.
	for (new i = 2; i <= MAX_RACE_PLAYERS; i++)
	{
		new
			// Line number starting from 0 (first), 1 (second), ...
			lineNo = floatround( floatdiv(i, 3), floatround_ceil ) - 1,
			// Position within the same line
			linePos = (i - 1) % 3,
			// The middle position of such line (array ID)
			lineBasePos = (!lineNo) ? 0 : lineNo * 3;

		new
			arrayPos = lineBasePos + linePos;

		if (arrayPos >= MAX_RACE_PLAYERS)
		{
			break;
		}

		switch (linePos)
		{
			// Middle
			case 0:
				{
					if (lineNo > 0)
					{
						X[arrayPos] = floatsub(X[lineBasePos - 3], gapCosA);
						Y[arrayPos] = floatsub(Y[lineBasePos - 3], gapSinA);
					}
				}
			// Right
			case 1:
				{
					X[arrayPos] = floatsub(X[lineBasePos], gapCosB);
					Y[arrayPos] = floatsub(Y[lineBasePos], gapSinB);
				}
			// Left
			case 2:
				{
					X[arrayPos] = floatadd(X[lineBasePos], gapCosB);
					Y[arrayPos] = floatadd(Y[lineBasePos], gapSinB);
				}
		}
	}

	gRaces[raceid][StartingCoordX] = X;
	gRaces[raceid][StartingCoordY] = Y;

	return 1;
}

static Race_SetPlayerPos(playerid, raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	if (!gPlayerRace[playerid][IsRegistered])
	{
		return 1;
	}

	// Decide where a registered racer should be put before a race start line
	//
	// ----- start -----            lineNo.:
	//   3     1     2              0
	//
	//   6-GAP-4     5              1
	//        
	//        ...
	new
		vehicleid = GetPlayerVehicleID(playerid);

	new
		arrayPos = -1;

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		if (gRaces[raceid][RegisteredPlayers][i] == playerid)
		{
			arrayPos = i;
			break;
		}
	}

	if (arrayPos == -1)
	{
		return 1;
	}

	TogglePlayerControllable(playerid, false);

	SetVehicleZAngle(vehicleid, Race_HeadingFromAngle(gRaces[raceid][AlphaAngle]));
	SetVehiclePos(vehicleid, gRaces[raceid][StartingCoordX][arrayPos], gRaces[raceid][StartingCoordY][arrayPos], gRaces[raceid][Start][CoordZ] + 2.00);
	SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
	SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);

	return 1;
}

forward Race_CountdownHelper(raceid);
public Race_CountdownHelper(raceid)
{
	if (raceid >= MAX_RACE_COUNT)
	{
		return 1;
	}

	new
		remaining = --gRaces[raceid][CountdownRemaining];

	if (!remaining || !gRaces[raceid][RegisteredCount])
	{
		return 1;
	}

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		new
			playerid = gRaces[raceid][RegisteredPlayers][i];

		if (playerid == INVALID_PLAYER_ID)
		{
			continue;
		}

		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~%d", 1000, 4, remaining);
	}

	gRaces[raceid][CountdownRemaining] = remaining;
	gRaces[raceid][CountdownTimer] = Timer: SetTimerEx("Race_CountdownHelper", 1000, false, "i", raceid);

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

	// End the race
	if (raceCpPosition >= gRaces[raceid][CheckPointCount])
	{
		Race_AbortMinigame(playerid, true);

		return 1;
	}

	x0 = gRaceCoords[raceid][raceCpPosition][CoordX];
	y0 = gRaceCoords[raceid][raceCpPosition][CoordY];
	z0 = gRaceCoords[raceid][raceCpPosition][CoordZ];

	if (raceCpPosition + 1 < gRaces[raceid][CheckPointCount])
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

stock Race_AbortMinigame(playerid, bool: success = false)
{
	if (!gPlayerRace[playerid][IsRegistered])
	{
		return 1;
	}

	DisablePlayerRaceCheckpoint(playerid);
	TogglePlayerControllable(playerid, true);

	TextDrawHideForPlayer(playerid, gRaceInfoText[playerid]);

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
			gRaces[raceid][RegisteredCount]--;
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

	// End the race completely if no one is left registered in
	if (!gRaces[raceid][RegisteredCount])
	{
		gRaces[raceid][IsActive] = false;
		gRaces[raceid][CountdownRemaining] = 0;

		KillTimer(_: gRaces[raceid][CountdownTimer]);
		KillTimer(_: gRaces[raceid][StartRaceTimer]);
		KillTimer(_: gRaces[raceid][UpdateRaceInfoTimer]);

		gRaces[raceid][CountdownTimer] = Timer: INVALID_TIMER;
		gRaces[raceid][StartRaceTimer] = Timer: INVALID_TIMER;
		gRaces[raceid][UpdateRaceInfoTimer] = Timer: INVALID_TIMER;
	}

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

