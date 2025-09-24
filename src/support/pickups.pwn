// https://www.open.mp/docs/scripting/resources/pickuptypes
#define PICKUP_TYPE_NONE			0
#define PICKUP_TYPE_ALWAYS			1
#define PICKUP_TYPE_RESPAWN_30_SECONDS		2
#define PICKUP_TYPE_RESPAWN_AFTER_DEATH		3
#define PICKUP_TYPE_NO_RESPAWN			19 

#define MAX_TIKI_PRIZES 			5

#define PICKUP_INFO				1239
#define PICKUP_HEART				1240
#define PICKUP_PILL				1241
#define	PICKUP_HOUSE_GREEN			1273
#define PICUKP_TIKI				1276
#define PICKUP_ARROW				1318
#define PICKUP_DRUG_WHITE			1575
#define PICKUP_DRUG_ORANGE			1576
#define PICKUP_DRUG_YELLOW			1577
#define PICKUP_DRUG_GREEN			1578
#define PICKUP_DRUG_BLUE			1579
#define PICKUP_DRUG_RED				1580
#define PICKUP_CARD				1581
#define PICKUP_HOUSE_RED 			19522

#include "modules/bank.pwn"

//
//  Global static team objects.
//

new gAdminRoomHealth;

new gHackerzInteriorEntrance;
new gHackerzInteriorExit;
new gHackerzMoneyBag;

new gAdminDoorDown;
new gAdminDoorUp;

// Drugz
new gHeroinPackage[5];
new gCocainePackage[5];
new gMethPackage[6];
new gFentPackage[2];
new gPCPPackage;
new gTHCPackage[10];

new gDruggery;
new gDruggeryEntrance;
new gDruggeryExit;

new gPlayerMoneyPickup[MAX_PLAYERS];
new gPlayerMoneyPickupAmount[MAX_PLAYERS];

//new gPlayerWeaponPickup[MAX_PLAYERS];

enum Tiki
{
	ID,
	PICKUP: Pickup
}

new gTikiPrizes[MAX_TIKI_PRIZES][Tiki];

//
//
//

forward InitPickups();

public InitPickups()
{
	InitTikiPrizes();

	gAdminRoomHealth = EnsurePickupCreated(1240, 1, 2302.85, 1155.93, 85.94);

	gHackerzInteriorEntrance = EnsurePickupCreated(1318, 1, 2866.62, -2125.24, 5.72);
	gHackerzInteriorExit = EnsurePickupCreated(1318, 1, 2853.09, -2125.16, 0.19);
	gHackerzMoneyBag = EnsurePickupCreated(1550, 1, 2838.59, -2141.25, 0.19);

	// ???
	//picktunel = EnsurePickupCreated(1318, 1, 2263.41, -755.52, 38.04);

	//------------------------
	//CreatePickup(1274, 1,2029.54, 1320.78, 10.82);
	//	CreatePickup(362, 1,2017.58,1338.44,10.82);

	//CreatePickup(xxx, 1, -1669.09, 1009.93, 7.75);

	// ATMs.
	for (new i = 0; i < sizeof(gBankLocation); i++)
	{
		EnsurePickupCreated(1274, PICKUP_TYPE_ALWAYS, Float:gBankLocation[i][0], Float:gBankLocation[i][1], Float:gBankLocation[i][2]);
	}

	//
	//  Drugz. Mostly SF.
	//

	gCocainePackage[0] = EnsurePickupCreated(1575, PICKUP_TYPE_RESPAWN_30_SECONDS, -2117.20, 220.44, 35.22);
	gCocainePackage[1] = EnsurePickupCreated(1575, PICKUP_TYPE_RESPAWN_30_SECONDS, -2555.85, 23.78, 12.60);
	gCocainePackage[2] = EnsurePickupCreated(1575, PICKUP_TYPE_RESPAWN_30_SECONDS, -2040.96, 837.46, 55.10);
	gCocainePackage[3] = EnsurePickupCreated(1575, PICKUP_TYPE_RESPAWN_30_SECONDS, -1807.20, 1334.54, 7.18);
	gCocainePackage[4] = EnsurePickupCreated(1575, PICKUP_TYPE_RESPAWN_30_SECONDS, -2045.62, 975.51, 54.24);

	gHeroinPackage[0] = EnsurePickupCreated(1577, PICKUP_TYPE_RESPAWN_30_SECONDS, -1664.19, 1010.74, 7.49);
	gHeroinPackage[1] = EnsurePickupCreated(1577, PICKUP_TYPE_RESPAWN_30_SECONDS, -2457.18, -96.09, 25.99);
	gHeroinPackage[2] = EnsurePickupCreated(1577, PICKUP_TYPE_RESPAWN_30_SECONDS, -1955.88, 766.31, 55.72);
	gHeroinPackage[3] = EnsurePickupCreated(1577, PICKUP_TYPE_RESPAWN_30_SECONDS, -1725.84, 1243.85, 7.54);
	gHeroinPackage[4] = EnsurePickupCreated(1577, PICKUP_TYPE_RESPAWN_30_SECONDS, -2708.04, 1459.45, 6.68);

	gMethPackage[0] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, -97.97, -1587.09, 2.61);
	gMethPackage[1] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, -2515.70, 300.41, 28.97);
	gMethPackage[2] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, -2563.58, 324.83, 10.56);
	gMethPackage[3] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, -2186.31, 695.96, 53.89);
	gMethPackage[4] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, -2449.87, 968.84, 44.86);
	gMethPackage[5] = EnsurePickupCreated(1579, PICKUP_TYPE_RESPAWN_30_SECONDS, 1297.00, 352.67, 19.12);

	gFentPackage[0] = EnsurePickupCreated(1580, PICKUP_TYPE_RESPAWN_30_SECONDS, -2213.43, 109.71, 35.32);
	gFentPackage[1] = EnsurePickupCreated(1580, PICKUP_TYPE_RESPAWN_30_SECONDS, -2720.09, 75.78, 4.33);

	gPCPPackage = EnsurePickupCreated(1576, PICKUP_TYPE_RESPAWN_30_SECONDS, -2635.15, 957.42, 70.21);

	// Venkov (farmy a mala mesta)
	gTHCPackage[0] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -1110.3, -1678.59, 76.37);
	gTHCPackage[1] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -369.97, -1417.48, 25.72);
	gTHCPackage[2] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -80.83, -1212.65, 2.70);
	// Blueberry
	gTHCPackage[3] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, 203.83, 36.10, 2.57);
	// Palomino Creeks 
	gTHCPackage[4] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, 2317.25, -68.27, 26.48);
	gTHCPackage[5] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, 2243.21, -86.33, 26.49);
	gTHCPackage[6] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, 1355.74, 489.17, 20.21);
	gTHCPackage[7] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -753.29, -13.55, 65.82);
	gTHCPackage[8] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -2186.08, -2321.65, 30.62);
	gTHCPackage[9] = EnsurePickupCreated(1578, PICKUP_TYPE_RESPAWN_30_SECONDS, -253.64, -2187.54, 28.91);

	switch (random(2))
	{
		case 0:
			{
				// Dillimore
				gDruggeryEntrance = EnsurePickupCreated(1318, 1, 645.68, -510.51, 16.33);
				gDruggery = CreateObject(18056, 645.68, -510.51, 1500.00, 0.0, 0.0, 0.0, 0.0);
				gDruggeryExit = EnsurePickupCreated(1318, 1, 658.45, -507.50, 1500.00);
			}
		case 1:
			{
				// Montgomery
				gDruggeryEntrance = EnsurePickupCreated(1318, 1, 1280.85, 304.07, 19.55);
				gDruggery = CreateObject(18056, 1280.85, 304.07, 1500.00, 0.0, 0.0, 0.0, 0.0);
				gDruggeryExit = EnsurePickupCreated(1318, 1, 1293.66, 301.10, 1500.00);
			}
	}

	//
	//  Jobs/Teams.
	//

	new Float: teamPickups[][3] = 
	{
		{0.0, 0.0, 0.0},
		{2252.11, 1285.30, 19.17},
		{2304.43, 1151.95, 85.94},
		{2290.73, 2429.61, 10.82},
		{2637.36, 1127.04, 11.18},
		{2620.14, 1195.76, 10.81},
		{2892.8, -2127.9, 3.2},
		{2101.70, -1810.05, 13.55},
		{2838.10, -2130.26, 0.19},
		{2582.10, -956.28, 81.02}
	};

	for (new i = 0; i < MAX_TEAMS; i++)
	{
		gTeams[i][Pickups][0] = PICKUP: EnsurePickupCreated(1581, 1, Float:teamPickups[i][0], Float:teamPickups[i][1], Float:teamPickups[i][2]);
		gTeams[i][Menus][0] = CreateMenu(gTeams[i][TeamName], 1, 150.0, 100.0, 250.0, 150.0);

		new menuItem[64];

		format(menuItem, sizeof(menuItem), "%s", gTeams[i][TeamName]);

		AddMenuItem(gTeams[i][Menus][0], 0, menuItem);
		AddMenuItem(gTeams[i][Menus][0], 0, "Leave team");
	}

	/*NEMOVITOSTI*/

	//1.barak
	CreatePickup(1318,1,1498.13,-682.34,86.75);  //z baraku     //kompryho barak
	//CreatePickup(1273,1,1496.85,-689.98,94.75);  //do baraku
	CreatePickup(1254,1,1490.38,-667.30,88.21); //zdravi a naboje
	//2.barak
	CreatePickup(1318,1,1789.27,-2129.97,7.64);  //z baraku
	CreatePickup(1273,1,1782.20,-2125.62,14.07); //do baraku
	//CreatePickup(1254,1,); //zdravi a naboje
	//3.barak
	CreatePickup(1318,1,1801.60,-2125.57,10.9);  //z baraku
	CreatePickup(1273,1,1804.33,-2124.37,13.94); //do baraku
	//CreatePickup(1254,1,); //zdravi a naboje
	//4.barak
	CreatePickup(1318,1,1484.13,-1778.76,6.70);  //z baraku     //banka LS
	CreatePickup(1318,1,1481.20,-1770.62,18.80); //do baraku
 	CreatePickup(1274,1,1470.34,-1806.61,6.70); //bankomat
 	//5.barak
 	CreatePickup(1318,1,-1063.29,-1193.96,120.53); //z baraku   //farma
 	CreatePickup(1273,1,-1059.74,-1205.56,129.22); //do baraku
 	//6.barak
 	CreatePickup(1318,1,-1903.26,486.28,21.93); //z baraku      //centrum SF
 	CreatePickup(1318,1,-1899.01,486.52,35.17); //do baraku

	/*NEMOVITOSTI*/
}

//
//
//

stock InitTikiPrizes()
{
	new i = 0, query[256];

	format(query, sizeof(query), "SELECT id, coord_x, coord_y, coord_z FROM tiki_prizes WHERE hidden = 0");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot load tiki coords!");
		return 0;
	}

	new Float:X, Float:Y, Float:Z;

	do
	{
		X = DB_GetFieldFloatByName(result, "coord_x");
		Y = DB_GetFieldFloatByName(result, "coord_y");
		Z = DB_GetFieldFloatByName(result, "coord_z");

		gTikiPrizes[i][ID] = DB_GetFieldIntByName(result, "id");
		gTikiPrizes[i][Pickup] = PICKUP: EnsurePickupCreated(1276, PICKUP_TYPE_NO_RESPAWN, X, Y, Z);

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);
	print("Tiki prizes initialized!");

	return 1;
}

stock UpdateTikiPrize(playerid, tikiid)
{
	new query[128];

	format(query, sizeof(query), "UPDATE tiki_prizes SET hidden = 1 WHERE id = %d", gTikiPrizes[tikiid][ID]);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot write tiki update!");
		return 0;
	}

	DB_FreeResultSet(result);

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TIKI ] You have found the tiki prize ($10M)! Cg");
	GivePlayerMoney(playerid, 10000000);

	return 1;
}

stock AddPlayerDeathPickups(playerid, Float:X, Float:Y, Float:Z)
{
	if (GetPlayerMoney(playerid) > 0)
	{
		gPlayerMoneyPickup[playerid] = EnsurePickupCreated(1212, 19, Float:X, Float:Y, Float:Z);
		gPlayerMoneyPickupAmount[playerid] = GetPlayerMoney(playerid);

		SendClientMessageLocalized(playerid, I18N_DEATH_MONEY_LOCALITY);
	}

	return 1;
}

