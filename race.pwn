#define UNKNOWN_CP_TYPE 	-1
#define CP_TYPE_GROUND_NORMAL 	0
#define CP_TYPE_GROUND_FINISH 	1
#define CP_TYPE_GROUND_EMPTY 	2
#define CP_TYPE_AIR_NORMAL 	3
#define CP_TYPE_AIR_FINISH 	4
#define CP_TYPE_AIR_ROTATING 	5
#define CP_TYPE_AIR_STROBING 	6
#define CP_TYPE_AIR_SWINGING 	7
#define CP_TYPE_AIR_BOBBING 	8

#define MAX_RACE_NAME		64
#define MAX_RACE_CP		64
#define MAX_RACE_COORD		3

enum E_RACE_COORD
{
	E_RACE_COORD_X,
	E_RACE_COORD_Y,
	E_RACE_COORD_Z
}

enum E_RACE_FEE
{
	E_RACE_FEE_FEE,
	E_RACE_FEE_PRIZE
}

enum E_RACE_ID
{
	E_RACE_ID_NONE,
	E_RACE_ID_LV_PYRAMID,
	E_RACE_ID_STUNT_LV_1
}

// gPlayerRace hold a reference to the state of a player's registration to such race. Thus if registered, a value for such RACE_ID should return true (1).
new gPlayerRace[MAX_PLAYERS][E_RACE_ID];

//
//  Race props.
//

// gRaceNames is an array to hold all race names referenced via E_RACE_ID.
new const gRaceNames[E_RACE_ID][] = 
{
	// E_RACE_ID_NONE
	"Blank Race (stub)",
	// E_RACE_ID_LV_PYRAMID
	"Las Venturas Pyramid Race",
	// E_RACE_ID_STUNT_LV_1
	"Las Venturas Stunt Race No. 1"
};

new const gRaceFeePrize[E_RACE_ID][E_RACE_FEE] =
{
	// E_RACE_ID_NONE
	{0, 0},
	// E_RACE_ID_LV_PYRAMID
	{300, 5000},
	// E_RACE_ID_STUNT_LV_1
	{1500, 20000}
};

// E_RACE_ID_STUNT_LV_1
new gRaceCoordsLVStuntNo1[][E_RACE_COORD] =
{
	{2605.1, 1193.9, 10.4},
	{2393.16, 1192.98, 10.50},
	{2002.7, 1209.4, 17.6},
	{1971.5, 1248.1, 17.6},
	{1874.3, 1247.6, 17.6},
	{1871.15, 1151.11, 10.38},
	{1869.7, 935.8, 10.2},
	{2106.8, 955.2, 15.3},
	{2079.5, 1031.7, 10.3},
	{2175.8, 1134.2, 12.2},
	{2158.6, 1274.4, 17.3}
};

//
//  Race-related functions.
//

public StartRace()
{
	return 1;
}

public SetPlayerRace(playerid, raceId)
{
	// Check if player has joined such race.
	if (!IsPlayerConnected(playerid) || raceId == E_RACE_ID_NONE || !gPlayerRace[playerid][raceId])
		return 0;

	// Fetch the relative position in such race (position of checkpoints).
	new lastCPNo, raceCPPosition = gPlayerRace[playerid][raceId] - 1;

	// Prepare the coords to show a race checkpoint.
	new x0, y0, z0, x1, y1, z1, cpType = CP_TYPE_GROUND_NORMAL;

	switch (raceId)
	{
		case E_RACE_ID_STUNT_LV_1:
			{
				lastCPNo = sizeof(gRaceCoordsLVStuntNo1) - 1;

				// End the race.
				if (raceCPPosition > lastCPNo)
				{
					ResetPlayerRaceState(playerid, raceId, true);

					return 1;
				}

				x0 = gRaceCoordsLVStuntNo1[raceCPPosition][E_RACE_COORD_X];
				y0 = gRaceCoordsLVStuntNo1[raceCPPosition][E_RACE_COORD_Y];
				z0 = gRaceCoordsLVStuntNo1[raceCPPosition][E_RACE_COORD_Z];

				if (raceCPPosition + 1 <= lastCPNo)
				{
					x1 = gRaceCoordsLVStuntNo1[raceCPPosition+1][E_RACE_COORD_X];
					y1 = gRaceCoordsLVStuntNo1[raceCPPosition+1][E_RACE_COORD_Y];
					z1 = gRaceCoordsLVStuntNo1[raceCPPosition+1][E_RACE_COORD_Z];
				} else {
					cpType = CP_TYPE_GROUND_FINISH;
				}
			}
		default:
			{
				return 0;
			}
	}

	// Set the next checkpoint to reach.
	SetPlayerRaceCheckpoint(playerid, cpType, Float:x0, Float:y0, Float:z0, Float:x1, Float:y1, Float:z0, 10.0);

	return 1;
}

public SetPlayerRaceState(playerid, raceId)
{
	new stringToPrint[128];

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Pro prihlaseni do zavodu je treba byt v aute!");

	// Check if already joined such race.
	if (gPlayerRace[playerid][raceId])
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Do daneho zavodu jsi jiz prihlasen!");

	if (CheckPlayerRaceState(playerid))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Jiz jsi prihlasen v jinem zavode! Pred prihlasenim je treba predchozi zavod dokoncit!");

	if (raceId == E_RACE_ID_NONE)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Zavod s danym ID neni pripraven!");

	if (GetPlayerMoney(playerid) < gRaceFeePrize[raceId][E_RACE_FEE_FEE])
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Nemas dostatek hotovosti pro zaplaceni prihlasky do zavodu!");

	//
	//  Ok, register the player with given raceId.
	//

	gPlayerRace[playerid][raceId] = 1;
	GivePlayerMoney(playerid, -gRaceFeePrize[raceId][E_RACE_FEE_FEE]);

	format(stringToPrint, sizeof(stringToPrint), "[ ! ] Uspesne prihlasen do zavodu '%s' (prihlaska $%d). Projed prvnim checkpointem pro spusteni casomiry.", gRaceNames[raceId], gRaceFeePrize[raceId][E_RACE_FEE_FEE]);
	SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);

	SetPlayerRace(playerid, raceId);

	return 1;
}

public ResetPlayerRaceState(playerid, raceId, finishedSuccessfully)
{
	DisablePlayerRaceCheckpoint(playerid);

	if (!CheckPlayerRaceState(playerid))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Nejsi prihlasen v zadnem zavode.");

	if (finishedSuccessfully)
	{
		SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Dokoncil jsi zavod!");

		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));
		format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s prave uspesne dokoncil zavod '%s'!", playerName, gRaceNames[raceId]);

		SendClientMessageToAll(COLOR_SVZEL, stringToPrint);
	}

	if (!finishedSuccessfully && CheckPlayerRaceState(playerid))
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Zavod, ve kterem jsi byl prihlasen, byl predcasne ukoncen!");
	}

	// Reset all race states to be sure not to interfere with others.
	for (new i = 0; i < sizeof(gRaceNames); i++)
	{
		gPlayerRace[playerid][i] = 0;
	}

	return 1;
}

// This number should be aither 0, or 1 at max! This means the player must be in just one race at the time!
public CheckPlayerRaceState(playerid)
{
	for (new i = 0; i < sizeof(gRaceNames); i++)
	{
		if (gPlayerRace[playerid][i])
		{
			// The player is racing at the moment!
			return 1;
		}
	}

	// The player does not seem to be in any race now.
	return 0;
}

public CheckRaceCheckpoint(playerid)
{
	//SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Jsi v zavodnim checkpointu!");
	DisablePlayerRaceCheckpoint(playerid);

	for (new i = 0; i <= sizeof(gRaceNames); i++)
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
