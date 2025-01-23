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
new const Float:gRaceCoords[E_RACE_ID][][E_RACE_COORD] = 
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
				new stringToPrint[128];

				format(stringToPrint, sizeof(stringToPrint), "[ ! ] race coords: X: %.2f, Y: %.2f, Z: %.2f", gRaceCoords[raceId][0][E_RACE_COORD_X], gRaceCoords[raceId][0][E_RACE_COORD_Y], gRaceCoords[raceId][0][E_RACE_COORD_Z]);
				SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

				SetPlayerRaceCheckpoint(playerid, CP_TYPE_AIR_NORMAL, gRaceCoords[raceId][0][E_RACE_COORD_X], gRaceCoords[raceId][0][E_RACE_COORD_Y], gRaceCoords[raceId][0][E_RACE_COORD_Z]);
			}
	}

	return 1;
}
