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

enum E_CHECKPOINT
{
	coords[E_RACE_COORD]
}

enum E_RACE
{
	name[MAX_RACE_NAME],
	checkpoints[E_CHECKPOINT]
}

enum E_RACE_ID
{
	E_RACE_ID_NONE,
	E_RACE_ID_LV_PYRAMID,
	E_RACE_STUNT_LV_1
}

// gRaceProps is an array that holds references to all races defined.
new E_RACE:gRaceProps[E_RACE_ID];

new gDragRace[MAX_PLAYERS][E_RACE_ID];

// Common multidimension array to store all coordinates for any given race/stunt.
/*new gDragRaceProps[E_RACE_ID][MAX_RACE_CP][E_RACE_COORD] = 
{
	{
		{2605.1, 1193.9, 10.4},
		{2002.7, 1209.4, 17.6}
	}
};*/

public StartDragRace()
{
	return 1;
}


public SetRaceForUser(playerid, dragRaceId)
{
	if (!IsPlayerConnected(playerid))
		return 0;

	switch (dragRaceId)
	{
		case E_RACE_STUNT_LV_1:
			{
				/*for (new i = 0; i <= sizeof(gDragRaceProps[dragRaceId]); i++)
				{}*/

				/*new coords[MAX_RACE_CP][E_RACE_COORD] = gDragRaceProps[E_RACE_STUNT_LV_1];

				// Set the starting point.
				SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_NORMAL, coords[0][E_RACE_COORD_X], coords[0][E_RACE_COORD_Y], coords[0][E_RACE_COORD_Z], coords[1][E_RACE_COORD_X], coords[1][E_RACE_COORD_Y], coords[1][E_RACE_COORD_Z], 10.0);*/
			}
	}

	return 1;
}
