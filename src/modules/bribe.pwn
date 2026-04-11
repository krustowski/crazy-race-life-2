#if defined _CRL2_BRIBE
	#endinput
#endif
#define _CRL2_BRIBE

//
//  Police bribes.
//

#define MAX_BRIBE_COUNT 	128

enum BreditType
{
	BREDIT_NONE,
	BREDIT_NEW,
	BREDIT_DELETE
}

enum BribeEdit 
{
	BreditType: Type,
	Float: CoordX,
	Float: CoordY,
	Float: CoordZ,
	Note[64]
}

enum BribePickup
{
	OrmID,
	PickupID,
	Timer: HiddenTimer
}

new 
	gBribeEdit[MAX_PLAYERS][BribeEdit];

new 
	gPoliceBribeStars[MAX_BRIBE_COUNT][BribePickup],
	gPoliceBribeStarCount = 0,
	gPoliceBribeStarLastOrmID = 0;

forward HidePoliceBribeTimer(bribeid);
public HidePoliceBribeTimer(bribeid)
{
	new 
		ormid = gPoliceBribeStars[bribeid][OrmID],
		query[64];

	format(query, sizeof(query), "SELECT x, y, z FROM police_bribe_coords WHERE id = %d", ormid);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot read hidden police bribe (OrmID: %d)", ormid);
		return 0;
	}

	new 
		Float: X = DB_GetFieldFloatByName(result, "x"),
		Float: Y = DB_GetFieldFloatByName(result, "y"),
		Float: Z = DB_GetFieldFloatByName(result, "z");

	gPoliceBribeStars[bribeid][PickupID] = EnsurePickupCreated(PICKUP_STAR, 19, X, Y, Z);

	KillTimer(_: gPoliceBribeStars[bribeid][HiddenTimer]);
	gPoliceBribeStars[bribeid][HiddenTimer] = Timer: 0;

	DB_FreeResultSet(result);

	return 1;
}

stock InitPoliceBribePickups()
{
	new 
		query[64] = "SELECT id, x, y, z FROM police_bribe_coords";

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		print("Database error: cannot load police bribe pickups");
		return 0;
	}

	do 
	{
		new 
			ormid = DB_GetFieldIntByName(result, "id"),
			Float: X = DB_GetFieldFloatByName(result, "x"),
			Float: Y = DB_GetFieldFloatByName(result, "y"),
			Float: Z = DB_GetFieldFloatByName(result, "z");

		gPoliceBribeStars[gPoliceBribeStarCount][PickupID] = EnsurePickupCreated(PICKUP_STAR, 19, X, Y, Z);
		gPoliceBribeStars[gPoliceBribeStarCount++][OrmID] = ormid;
		gPoliceBribeStarLastOrmID = ormid;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	return 1;
}

stock SaveNewPoliceBribePickup(playerid)
{
	new 
		query[256];

	format(query, sizeof(query), "INSERT INTO police_bribe_coords (x, y, z, note) VALUES (%.2f, %.2f, %.2f, '%s')", 
			gBribeEdit[playerid][CoordX],
			gBribeEdit[playerid][CoordY],
			gBribeEdit[playerid][CoordZ],
			gBribeEdit[playerid][Note]
		);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot write new police bribe (user_id: %d)", playerid);
		return 0;
	}

	DB_FreeResultSet(result);

	gPoliceBribeStars[++gPoliceBribeStarCount][PickupID] = EnsurePickupCreated(PICKUP_STAR, 19, gBribeEdit[playerid][CoordX], gBribeEdit[playerid][CoordY], gBribeEdit[playerid][CoordZ]);
	gPoliceBribeStars[gPoliceBribeStarCount][OrmID] = ++gPoliceBribeStarLastOrmID;

	gBribeEdit[playerid][Type] = BREDIT_NONE;
	gPlayers[playerid][EditingMode] = false;

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] New police bribe pickup saved!");

	return 1;
}

stock CheckPoliceBribePickup(playerid, pickupid)
{
	for (new i = 0; i < MAX_BRIBE_COUNT; i++)
	{
		if (gPoliceBribeStars[i][PickupID] != pickupid)
		{
			continue;
		}

		if (!gPlayers[playerid][WantedLevel])
		{
			break;
		}

		gPoliceBribeStars[i][HiddenTimer] = Timer: SetTimerEx("HidePoliceBribeTimer", 60 * 1000, false, "i", i);

		HidePickupForPlayer(playerid, pickupid);
		DestroyPickup(pickupid);
		gPoliceBribeStars[i][PickupID] = 0;

		SetPlayerWantedLevel(playerid, --gPlayers[playerid][WantedLevel]);
		return SendClientMessage(playerid, COLOR_YELLOW, "[ BRIBE ] Your wanted level lowered by 1!");
	}

	return 0;
}
