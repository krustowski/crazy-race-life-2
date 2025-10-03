#define MAX_RACE_NAME		64
#define MAX_RACE_CP		99
#define MAX_RACE_COORD		3
#define MAX_RACE_COUNT		64

enum E_RACE_COORD
{
Float: E_RACE_COORD_X,
       Float: E_RACE_COORD_Y,
       Float: E_RACE_COORD_Z
}

enum E_RACE_EDIT_TYPE
{
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
	Start[E_RACE_COORD],
	Float: Time,
	CheckPointCount,

	E_RACE_EDIT_TYPE: EditType,
	EditTrackCoordNo
}

new gRaces[MAX_RACE_COUNT][Race];

// gPlayerRace hold a reference to the state of a player's registration to such race. Thus if registered, a value for such RACE_ID should return true (1).
new gPlayerRace[MAX_PLAYERS][MAX_RACE_COUNT];

new gPlayerRaceEdit[MAX_PLAYERS][Race];
new gPlayerRaceEditTrackCoords[MAX_PLAYERS][MAX_RACE_CP][E_RACE_COORD];

new Timer:gPlayerRaceTimer[MAX_PLAYERS];

new Text:gRaceInfoText[MAX_PLAYERS];

new gPlayerRaceTime[MAX_PLAYERS];

//
//  Race-related functions.
//

forward InitRaces();
forward CheckRaceCheckpoint(playerid);
forward SetRaceForUser(playerid, raceId);
forward StartRace();
forward UpdateRaceInfoText(playerid);

public InitRaces() 
{
	new i = 1, query[512];

	format(query, sizeof(query), "SELECT id, name, type, cost_dollars, prize_dollars, start_x, start_y, start_z FROM races");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch race data!");
		return 0;
	}

	while (DB_SelectNextRow(result))
	{
		new name[MAX_RACE_NAME];
		DB_GetFieldStringByName(result, "name", name, sizeof(name));
		gRaces[i][Name] = name;

		gRaces[i][ID] = DB_GetFieldIntByName(result, "id");
		gRaces[i][Type] = DB_GetFieldIntByName(result, "type");
		gRaces[i][CostDollars] = DB_GetFieldIntByName(result, "cost_dollars");
		gRaces[i][PrizeDollars] = DB_GetFieldIntByName(result, "prize_dollars");

		new 
			Float: pX,
			Float: pY,
			Float: pZ;

		pX = DB_GetFieldFloatByName(result, "start_x");
		pY = DB_GetFieldFloatByName(result, "start_y");
		pZ = DB_GetFieldFloatByName(result, "start_z");

		gRaces[i][Start][E_RACE_COORD_X] = pX;
		gRaces[i][Start][E_RACE_COORD_Y] = pY;
		gRaces[i][Start][E_RACE_COORD_Z] = pZ;

		EnsurePickupCreated(1314, 1, pX, pY, pZ);
		Create3DTextLabel("%s", COLOR_ORANGE, pX, pY, pZ, 15.0, -1, false, name);

		i++;
	}

	DB_FreeResultSet(result);
	print("Race props initialized!");

	return 1;
}

stock SetPlayerRaceSingle(playerid, raceId, const Float:coords[][E_RACE_COORD], len)
{
	// Fetch the relative position in such race (position of checkpoints).
	new lastCpNo = len - 1, raceCpPosition = gPlayerRace[playerid][raceId] - 1, raceType = gRaces[raceId][Type];

	// Prepare the coords to show a race checkpoint.
	new Float: x0, Float: y0, Float: z0, Float: x1, Float: y1, Float: z1, t_CP_TYPE: cpType;

	switch (raceType) 
	{
		case 1:
			cpType = CP_TYPE_GROUND_NORMAL;
		case 2:
			cpType = CP_TYPE_AIR_NORMAL;
	}

	// End the race.
	if (raceCpPosition > lastCpNo)
	{
		ResetPlayerRaceState(playerid, raceId, true);
		return 1;
	}

	x0 = coords[raceCpPosition][E_RACE_COORD_X];
	y0 = coords[raceCpPosition][E_RACE_COORD_Y];
	z0 = coords[raceCpPosition][E_RACE_COORD_Z];

	if (raceCpPosition + 1 <= lastCpNo)
	{
		x1 = coords[raceCpPosition+1][E_RACE_COORD_X];
		y1 = coords[raceCpPosition+1][E_RACE_COORD_Y];
		z1 = coords[raceCpPosition+1][E_RACE_COORD_Z];
	} else {
		switch (raceType)
		{
			case 1:
				cpType = CP_TYPE_GROUND_FINISH;
			case 2:
				cpType = CP_TYPE_AIR_FINISH;
		}
	}

	// Set the next checkpoint to reach.
	SetPlayerRaceCheckpoint(playerid, cpType, Float:x0, Float:y0, Float:z0, Float:x1, Float:y1, Float:z1, 10.0);

	return 1;
}

stock UpdateRaceCoords(raceId)
{
	new query[512];

	format(query, sizeof(query), "");

	return 1;
}

stock SetPlayerRace(playerid, raceId)
{
	// Check if player has joined such race
	if (!IsPlayerConnected(playerid) || raceId == 0 || !gPlayerRace[playerid][raceId])
		return 0;

	new Float: coords[MAX_RACE_CP][E_RACE_COORD];

	new len = 0, query[512];

	format(query, sizeof(query), "SELECT seq_no, x, y, z, rot FROM race_coords WHERE race_id = %d", raceId);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch race coords data!");
		return 0;
	}

	coords[0][E_RACE_COORD_X] = DB_GetFieldFloatByName(result, "x");
	coords[0][E_RACE_COORD_Y] = DB_GetFieldFloatByName(result, "y");
	coords[0][E_RACE_COORD_Z] = DB_GetFieldFloatByName(result, "z");

	len++;

	while (DB_SelectNextRow(result))
	{
		new seq_no = DB_GetFieldIntByName(result, "seq_no");

		coords[seq_no - 1][E_RACE_COORD_X] = DB_GetFieldFloatByName(result, "x");
		coords[seq_no - 1][E_RACE_COORD_Y] = DB_GetFieldFloatByName(result, "y");
		coords[seq_no - 1][E_RACE_COORD_Z] = DB_GetFieldFloatByName(result, "z");

		len++;
	}

	DB_FreeResultSet(result);

	gRaces[raceId][CheckPointCount] = len;

	SetPlayerRaceSingle(playerid, raceId, Float: coords, len);

	return 1;
}

stock SetPlayerRaceState(playerid, raceId)
{
	new stringToPrint[256];

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);

	// Check if already joined such race.
	if (gPlayerRace[playerid][raceId])
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_JOINED);

	if (CheckPlayerRaceState(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_JOINED);
	//return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Jiz jsi prihlasen v jinem zavode! Pred prihlasenim je treba predchozi zavod dokoncit!");

	if (raceId == 0)
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_SUCH_RACE);

	if (GetPlayerMoney(playerid) < gRaces[raceId][CostDollars])
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_MONEY);

	//
	//  Ok, register the player with given raceId.
	//

	gPlayerRace[playerid][raceId] = 1;
	GivePlayerMoney(playerid, -gRaces[raceId][CostDollars]);

	switch (gPlayers[playerid][Locale])
	{
		case LOCALE_CZ:
			format(stringToPrint, sizeof(stringToPrint), "[ ZAVOD ] Uspesne prihlasen do zavodu '%s' (prihlaska $%d). Projed prvnim checkpointem pro spusteni casomiry.", gRaces[raceId][Name], gRaces[raceId][CostDollars]);

		default:
			format(stringToPrint, sizeof(stringToPrint), "[ RACE ] Joined the '%s' race (cost $%d). Use the first checkpoint to start the race!", gRaces[raceId][Name], gRaces[raceId][CostDollars]);
	}

	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);
	SetPlayerRace(playerid, raceId);

	return 1;
}

stock ResetPlayerRaceState(playerid, raceId, finishedSuccessfully)
{
	if (!CheckPlayerRaceState(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_RACE);

	DisablePlayerRaceCheckpoint(playerid);
	TextDrawHideForPlayer(playerid, gRaceInfoText[playerid]);
	KillTimer(_: gPlayerRaceTimer[playerid]);
	gPlayerRaceTimer[playerid] = Timer: 0;

	if (finishedSuccessfully)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_SUCCESSFULLY);

		new playerName[MAX_PLAYER_NAME], stringToPrint[256];

		GetPlayerName(playerid, playerName, sizeof(playerName));
		GivePlayerMoney(playerid, gRaces[raceId][PrizeDollars]);

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s just finished the '%s' race, and received a price of $%d!", playerName, gRaces[raceId][Name], gRaces[raceId][PrizeDollars]);
		SendClientMessageToAll(COLOR_LIGHTGREEN, stringToPrint);

		GameTextForPlayer(playerid, "~w~Race ~g~Finished", 3000, 3); 

		SaveNewScore(raceId, playerid, gPlayerRaceTime[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	}

	gPlayerRaceTime[playerid] = 0;

	if (!finishedSuccessfully && CheckPlayerRaceState(playerid))
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_PREMATURELY);

		GameTextForPlayer(playerid, "~w~Race ~r~Aborted", 3000, 3); 
	}

	// Reset all race states to be sure not to interfere with others.
	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		gPlayerRace[playerid][i] = 0;
	}

	return 1;
}

// This number should be aither 0, or 1 at max! This means the player must be in just one race at the time!
stock CheckPlayerRaceState(playerid)
{
	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (gPlayerRace[playerid][i])
		{
			// The player is racing at the moment!
			return i;
		}
	}

	// The player does not seem to be in any race now.
	return 0;
}

stock SetPlayerRaceStartPos(playerid)
{
	new raceId = CheckPlayerRaceState(playerid);

	if (!raceId)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_RACE);
		return 0;
	}

	if (gPlayerRace[playerid][raceId] > 1)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_WARP_AFTER_START);
		return 0;
	}

	if (!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);
		return 0;
	}

	SetVehiclePos(GetPlayerVehicleID(playerid), Float:gRaces[raceId][Start][E_RACE_COORD_X], Float:gRaces[raceId][Start][E_RACE_COORD_Y], Float:gRaces[raceId][Start][E_RACE_COORD_Z] + 2.00);

	return 1;
}

public UpdateRaceInfoText(playerid)
{
	new 
		cpCount,  
		raceId = CheckPlayerRaceState(playerid), 
		stringToPrint[128];

	cpCount = gRaces[raceId][CheckPointCount];

	gPlayerRaceTime[playerid] += 1000;

	switch (gPlayers[playerid][Locale]) 
	{
		case LOCALE_CZ:
			format(stringToPrint, sizeof(stringToPrint), "~w~Zavod:_________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Cas:_______~b~%4d~y~:~b~%2d", float:raceId, gPlayerRace[playerid][raceId]-1, cpCount, floatround(floatround(gPlayerRaceTime[playerid] / 1000) / 60), floatround(gPlayerRaceTime[playerid] / 1000) % 60);

		default:
			format(stringToPrint, sizeof(stringToPrint), "~w~Race:__________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Time:______~b~%4d~y~:~b~%2d", float:raceId, gPlayerRace[playerid][raceId]-1, cpCount, floatround(floatround(gPlayerRaceTime[playerid] / 1000) / 60), floatround(gPlayerRaceTime[playerid] / 1000) % 60);
	}

	// Redraw the player's current velocity.
	TextDrawSetString(gRaceInfoText[playerid], stringToPrint);
	TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);

	return 1;
}

stock CheckRaceCheckpoint(playerid)
{
	if (!CheckPlayerRaceState(playerid))
		return 0;

	if (!gPlayerRaceTimer[playerid])
	{
		gPlayerRaceTimer[playerid] = Timer: SetTimerEx("UpdateRaceInfoText", 1 * SECOND_MS, true, "i", playerid);
		TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);

		GameTextForPlayer(playerid, "~w~Race ~g~Started", 3000, 3); 
	}

	DisablePlayerRaceCheckpoint(playerid);

	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (gPlayerRace[playerid][i])
		{
			gPlayerRace[playerid][i]++;
			SetPlayerRace(playerid, i);
			break;
		}
	}

	return 1;
}

enum HighScores
{
	Nickname1[64],
	Nickname2[64],
	Nickname3[64],
	Time[3],
	VehicleModel[3]
};

new gHighScores[MAX_RACE_COUNT][HighScores];

stock InitHighScores()
{
	new query[512];

	format(query, sizeof(query), "select race_id, nickname, time, car_model from ( select race_id, nickname, time, car_model, row_number() over ( PARTITION by race_id ORDER by time ASC ) as rank from high_scores ) ranked where rank <= 3 order by race_id, rank;");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch high scores data!");
		return 0;
	}

	new raceIds[MAX_RACE_COUNT];

	do
	{
		new raceId = DB_GetFieldIntByName(result, "race_id");

		new i = raceIds[raceId];

		new name[64];
		DB_GetFieldStringByName(result, "nickname", name, sizeof(name));

		switch (i)
		{
			case 0:
				gHighScores[raceId][Nickname1] = name;
			case 1:
				gHighScores[raceId][Nickname2] = name;
			case 2:
				gHighScores[raceId][Nickname3] = name;
		}

		gHighScores[raceId][Time][i] = DB_GetFieldIntByName(result, "time");
		gHighScores[raceId][VehicleModel][i] = DB_GetFieldIntByName(result, "car_model");

		raceIds[raceId]++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("High scores initialized!");

	return 1;
}

stock SaveNewScore(raceId, playerid, time, vehicleModel)
{
	new nickname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nickname);

	new query[256];
	format(query, sizeof(query), "INSERT INTO high_scores (race_id, nickname, time, car_model) VALUES (%d, '%s', %d, %d)", raceId, nickname, time, vehicleModel);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		SendClientMessage(playerid, COLOR_RED, "[ RACE ] Database error!");
		printf("Database error: cannot write high score data (race_id: %d, nickname: %s)!", raceId, nickname);

		return 0;
	}

	DB_FreeResultSet(result);

	InitHighScores();

	return 1;
}
