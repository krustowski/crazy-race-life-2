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

/*enum E_CHECKPOINT
  {
  E_CHECKPOINT_COORDS[E_RACE_COORD]
  }

  enum E_RACE
  {
  E_RACE_NAME[MAX_RACE_NAME],
  E_RACE_CHECKPOINTS[MAX_RACE_CP]
  }*/

enum E_RACE_ID
{
	E_RACE_ID_NONE,
	E_RACE_ID_LV_PYRAMID,
	E_RACE_ID_STUNT_LV_1
}

// gPlayerRace hold a reference to the state of a player's registration to such race. Thus if registered, a value for such RACE_ID should return true (1).
new gPlayerRace[MAX_PLAYERS][E_RACE_ID];

// gRaceNames is an array to hold all race names referenced via E_RACE_ID.
new const gRaceNames[E_RACE_ID][] = 
{
	// E_RACE_ID_NONE
	"Blank Race (stub)",
	// E_RACE_ID_LV_PYRAMID
	"Las Venturas Pyramid Race",
	// E_RACE_STUNT_LV_1
	"Las Venturas Stunt Race No. 1"
};

// gRaceCoords is an array to hold all checkpoint coordinates for every race defined via E_RACE_ID.
new const gRaceCoords[E_RACE_ID][][E_RACE_COORD] = 
{
	// E_RACE_ID_NONE
	{
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0}
	},
	// E_RACE_ID_LV_PYRAMID
	{
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0}
	},
	// E_RACE_ID_STUNT_LV_1
	{
		{2605.1, 1193.9, 10.4},
		{2002.7, 1209.4, 17.6},
		{1971.5, 1248.1, 17.6},
		{1874.3, 1247.6, 17.6},
		{1897.2, 1138.4, 17.6},
		{1869.7, 935.8, 10.2}
	}
};

new gRaceCoordsLVStuntNo1[][E_RACE_COORD] =
{
	{2605.1, 1193.9, 10.4},
	{2393.16, 1192.98, 10.50},
	{2002.7, 1209.4, 17.6},
	{1971.5, 1248.1, 17.6},
	{1874.3, 1247.6, 17.6},
	{1910.1, 1152.5, 17.6},
	{1869.7, 935.8, 10.2},
	{2106.8, 955.2, 15.3},
	{2079.5, 1031.7, 10.3},
	{2175.8, 1134.2, 12.2},
	{2158.6, 1274.4, 17.3}
};

//
//
//

public StartRace()
{
	return 1;
}


public SetRaceForUser(playerid, raceId)
{
	if (!IsPlayerConnected(playerid))
		return 0;

	// 0 references E_RACE_ID_NONE, so nothing is to be prepared for the player.
	if (raceId == 0)
		return 0;

	switch (raceId)
	{
		case E_RACE_ID_STUNT_LV_1:
			{
				if (!gPlayerRace[playerid][raceId]) 
					return 1;

				// Fetch the relative position in such race (position of checkpoints).
				new raceCPPosition = gPlayerRace[playerid][raceId] - 1;

				new lastCPNo = sizeof(gRaceCoordsLVStuntNo1) - 1;

				if (raceCPPosition > lastCPNo)
				{
					DisablePlayerRaceCheckpoint(playerid);

					gPlayerRace[playerid][raceId] = 0;
					SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Dokoncil jsi zavod!");

					return 1;
				}

				new x0, y0, z0, x1, y1, z1, cpType = CP_TYPE_GROUND_NORMAL;

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

				SetPlayerRaceCheckpoint(playerid, cpType, Float:x0, Float:y0, Float:z0, Float:x1, Float:y1, Float:z0, 10.0);

				/*for (new i = 0; i <= sizeof(gRaceCoords[E_RACE_ID_STUNT_LV_1]); i++)
				{

				}*/

				//new x0 = gRaceCoords[E_RACE_ID_STUNT_LV_1][0][E_RACE_COORD_X], y0 = gRaceCoords[E_RACE_ID_STUNT_LV_1][0][E_RACE_COORD_Y], z0 = gRaceCoords[E_RACE_ID_STUNT_LV_1][0][E_RACE_COORD_Z];
				//new x1 = gRaceCoords[E_RACE_ID_STUNT_LV_1][1][E_RACE_COORD_X], y1 = gRaceCoords[E_RACE_ID_STUNT_LV_1][1][E_RACE_COORD_Y], z1 = gRaceCoords[E_RACE_ID_STUNT_LV_1][1][E_RACE_COORD_Z];

				//new stringToPrint[128];

				//format(stringToPrint, sizeof(stringToPrint), "[ ! ] Start CP: X: %.2f, Y: %.2f, Z: %.2f", x0, y0, z0);
				//SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

				//SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_NORMAL, Float:x0, Float:y0, Float:z0, Float:x1, Float:y1, Float:z0, 10.0);
				//SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_NORMAL, Float:x1, Float:y1, Float:z0, 0.0, 0.0, 0.0, 10.0);

				//SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_NORMAL, 2605.1, 1192.9, 10.4, 2002.7, 1209.4, 17.6, 10.0);
				//SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_NORMAL, Float:gRaceCoordsLVStunt[0][0], Float:gRaceCoordsLVStunt[0][1], Float:gRaceCoordsLVStunt[0][2], Float:gRaceCoordsLVStunt[1][0], Float:gRaceCoordsLVStunt[1][1], Float:gRaceCoordsLVStunt[1][2], 10.0);
			}
	}

	return 1;
}

public CheckRaceCheckpoint(playerid)
{
	//SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Jsi v zavodnim checkpointu!");
	DisablePlayerRaceCheckpoint(playerid);
	
	for (new i = 0; i <= sizeof(gRaceCoords); i++)
	{
		if (gPlayerRace[playerid][i])
		{
			gPlayerRace[playerid][i]++;
			SetRaceForUser(playerid, i);
			break;
		}
	}

	return 1;
}
