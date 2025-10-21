#if defined _CRL2_MAPICONS
	#endinput
#endif
#define _CRL2_MAPICONS

#include "modules/race.pwn"

enum
{
	E_MAPICON_ID_SQUARE_DYNAMIC,
	E_MAPICON_ID_SQUARE,
	E_MAPICON_ID_PLAYER_POSITION,
	E_MAPICON_ID_PLAYER,
	E_MAPICON_ID_NORTH,
	E_MAPICON_ID_AIRYARD,
	E_MAPICON_ID_AMMU_NATION,
	E_MAPICON_ID_BARBER,
	E_MAPICON_ID_BIG_SMOKE,
	E_MAPICON_ID_BOAT_YARD,
	E_MAPICON_ID_BURGER_SHOT,
	E_MAPICON_ID_QUARRY,
	E_MAPICON_ID_CATALINA,
	E_MAPICON_ID_CESAR,
	E_MAPICON_ID_CLUCKIN_BELL,
	E_MAPICON_ID_CARL_JOHNSON,
	E_MAPICON_ID_CRASH,
	E_MAPICON_ID_DINER,
	E_MAPICON_ID_EMMET,
	E_MAPICON_ID_ENEMY_ATTACK,
	E_MAPICON_ID_FIRE,
	E_MAPICON_ID_GIRLFRIEND,
	E_MAPICON_ID_HOSPITAL,
	E_MAPICON_ID_LOCO,
	E_MAPICON_ID_MADD_DOGG,
	E_MAPICON_ID_CALIGULA,
	E_MAPICON_ID_MC_STRAP,
	E_MAPICON_ID_MOD_GARAGE,
	E_MAPICON_ID_OG_LOC,
	E_MAPICON_ID_PIZZA,
	E_MAPICON_ID_POLICE,
	E_MAPICON_ID_PROP_FOR_SALE,
	E_MAPICON_ID_PROP_NOT_FOR_SALE,
	E_MAPICON_ID_RACE,
	E_MAPICON_ID_RYDER,
	E_MAPICON_ID_SAVE_HOUSE,
	E_MAPICON_ID_SCHOOL,
	E_MAPICON_ID_MYSTERY,
	E_MAPICON_ID_SWEET,
	E_MAPICON_ID_TATTOO,
	E_MAPICON_ID_TRUTH,
	E_MAPICON_ID_WAYPOINT,
	E_MAPICON_ID_TORENO_RANCH,
	E_MAPICON_ID_TRIADS,
	E_MAPICON_ID_TRIADS_CASINO,
	E_MAPICON_ID_CLOTHES,
	E_MAPICON_ID_WOOZIE,
	E_MAPICON_ID_ZERO,
	E_MAPICON_ID_DISCO,
	E_MAPICON_ID_DRINK,
	E_MAPICON_ID_RESTAURANT,
	E_MAPICON_ID_TRUCKING,
	E_MAPICON_ID_ROBBERY,
	E_MAPICON_ID_RACE_TOURNAMENT,
	E_MAPICON_ID_GYM,
	E_MAPICON_ID_CAR_IMPOUND,
	E_MAPICON_ID_LIGHT,
	E_MAPICON_ID_AIR_STRIP,
	E_MAPICON_ID_VARRIOS_LOS_AZTEC,
	E_MAPICON_ID_BALLAS,
	E_MAPICON_ID_LOS_SANTOS_VAGOS,
	E_MAPICON_ID_SA_FIERRO_RIFA,
	E_MAPICON_ID_GROVE_STREET,
	E_MAPICON_ID_PAY_N_SPRAY
}

forward AddMapicons(playerid);

public AddMapicons(playerid)
{
	new mapiconid = 0;

	// The very global spawn point in LV.
	SetPlayerMapIcon(playerid, mapiconid++, 2323.73, 1283.18, 97.60, E_MAPICON_ID_ENEMY_ATTACK, 0, MAPICON_LOCAL);

	// ATMs.
	for (new i = 0; i < sizeof(gBankLocation); i++)
	{
		SetPlayerMapIcon(playerid, mapiconid++, Float:gBankLocation[i][0], Float:gBankLocation[i][1], Float:gBankLocation[i][2], E_MAPICON_ID_ROBBERY, 0, MAPICON_LOCAL);
	}

	// Race start points.
	for (new i = 1; i < MAX_RACE_COUNT; i++)
	{
		if (!strcmp(gRaces[i][Name], ""))
			continue;

		new 
			Float: pX = gRaces[i][Start][E_RACE_COORD_X],
			Float: pY = gRaces[i][Start][E_RACE_COORD_Y],
			Float: pZ = gRaces[i][Start][E_RACE_COORD_Z];

		SetPlayerMapIcon(playerid, mapiconid++, pX, pY, pZ, E_MAPICON_ID_RACE_TOURNAMENT, 0, MAPICON_LOCAL);
	}

	// Housing.

	// Las Barrancas
	SetPlayerMapIcon(playerid, mapiconid++, -846.13, 1567.15, 24.63, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);

	// Octane Springs
	SetPlayerMapIcon(playerid, mapiconid++, 776.62, 1986.97, 5.33, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);

	SetPlayerMapIcon(playerid, mapiconid++, -2686.03, 205.63, 3.96, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, -1497.76, 2671.87, 55.25, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, 756.10, 332.78, 19.99, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, 730.69, -538.99, 16.33, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, -2803.74, -127.57, 6.84, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, 248.99, -294.65, 1.34, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);
	SetPlayerMapIcon(playerid, mapiconid++, -210.51, 2751.34, 62.20, E_MAPICON_ID_PROP_FOR_SALE, 0, MAPICON_LOCAL);

	// Jobs.

	new query[256];

	format(query, sizeof(query), "SELECT c.team_id, c.x, c.y, c.z FROM team_coords AS c JOIN teams AS t ON t.id = c.team_id ORDER BY c.team_id ASC");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot list team coords");
		print(query);

		return 0;
	}

	do
	{
		new Float: X, Float: Y, Float: Z, team_id;

		X = DB_GetFieldFloatByName(result, "x");
		Y = DB_GetFieldFloatByName(result, "y");
		Z = DB_GetFieldFloatByName(result, "z");
		team_id = DB_GetFieldIntByName(result, "team_id");

		switch (team_id)
		{
			case TEAM_MECHANICS:
				{
					SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_PAY_N_SPRAY, 0, MAPICON_LOCAL);
				}
			case TEAM_POLICE:
				{
					SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_POLICE, 0, MAPICON_LOCAL);
				}
			case TEAM_TAXIMEN:
				{
					SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_CAR_IMPOUND, 0, MAPICON_LOCAL);
				}
			case TEAM_PIZZAGUYS:
				{
					SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_PIZZA, 0, MAPICON_LOCAL);
				}
			case TEAM_DEALERS:
				{
					SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_MADD_DOGG, 0, MAPICON_LOCAL);
				}
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	// Trucking.

	format(query, sizeof(query), "SELECT x, y, z FROM trucking_coords WHERE type = 2");

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		printf("Database error: cannot list trucking points for mapicons!");
		print(query);

		return 0;
	}

	do 
	{
		new Float: X, Float: Y, Float: Z;

		X = DB_GetFieldFloatByName(result, "x");
		Y = DB_GetFieldFloatByName(result, "y");
		Z = DB_GetFieldFloatByName(result, "z");

		SetPlayerMapIcon(playerid, mapiconid++, X, Y, Z, E_MAPICON_ID_TRUCKING, 0, MAPICON_LOCAL);
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	/*SetPlayerMapIcon(playerid, 40, 970.7, 2155.0, 10.8, E_MAPICON_ID_TRUCKING, 0, MAPICON_LOCAL);
	  SetPlayerMapIcon(playerid, 41, 2287.1, 2426.7, 10.8, E_MAPICON_ID_POLICE, 0, MAPICON_LOCAL);
	  SetPlayerMapIcon(playerid, 42, -91.76, -305.44, 1.42, E_MAPICON_ID_TRUCKING, 0, MAPICON_LOCAL);
	  SetPlayerMapIcon(playerid, 43, -81.32, -1135.79, 0.91, E_MAPICON_ID_TRUCKING, 0, MAPICON_LOCAL);*/

	// Airports.
	//SetPlayerMapIcon(playerid, 60, 414.3, 2528.1, 16.6, E_MAPICON_ID_AIRYARD, 0, MAPICON_LOCAL);

	return 1;
}
