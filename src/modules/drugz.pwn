#if defined _CRL2_DRUGZ
	#endinput
#endif
#define _CRL2_DRUGZ

//
//  drugz.pwn
//

#define MAX_DRUG_TYPES		10
#define MAX_DRUG_PICKUPS	64
#define MAX_MARKET_ITEMS	128
#define MAX_DRUGGERY_POINTS	16

#define MARKET_RATIO_MIN	0.01
#define MARKET_RATIO_MAX	100.0
#define MARKET_RATIO_EQULIBRIUM	1.0
#define MARKET_REVERSION_RATE	0.005
#define MARKET_STEP_PERCENT	20

#include "support/helpers.pwn"
#include "support/pickups.pwn"

enum BlackMarketItem
{
	OrmID,
	SettlerID,
	Float: Amount,
	Value,
	DrugType: Type
};

new 
	gBlackMarketItems[MAX_MARKET_ITEMS][BlackMarketItem],
	gBlackMarketItemOffer[MAX_PLAYERS][BlackMarketItem],
	Float: gBlackMarketRatio = 1.0;

enum
{
	ZAZA,
	TOBACCO,
	PAPER,
	JOINT,
	LIGHTER,
	COCAINE,
	HEROIN,
	METH,
	FENT,
	PCP
}

enum DrugType
{
	TYPE_NONE,
	TYPE_ZAZA,
	TYPE_TOBACCO,
	TYPE_PAPER,
	TYPE_JOINT,
	TYPE_LIGHTER,
	TYPE_COCAINE,
	TYPE_HEROIN,
	TYPE_METH,
	TYPE_FENT,
	TYPE_PCP
}

enum Drug
{
	DrugName[64],
	DrugIniName[64],
	DrugAmount,
	DrugPrice
}

enum DrugPickup
{
	Pickup,
	DrugType: Type,
	Point[Coords]
}

enum DrugMission
{
	bool: Active,

	Count,
	TimeElapsed,

	TimerElapsed,

	Text: InfoText
}

enum DruggeryPoint
{
	ID,
	Pickup,
	PointCoords[Coords]
}

new
	gDruggeryPoints[MAX_DRUGGERY_POINTS][DruggeryPoint];

new 
	gDrugMission[MAX_PLAYERS][DrugMission],
	gDrugPickups[MAX_DRUG_PICKUPS][DrugPickup],
	gDrugz[MAX_DRUG_TYPES][Drug];

stock InitDrugValues()
{
	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT name, name_alt, price FROM drug_prices ORDER BY id ASC");
	if (!result) 
	{
		print("Database error: cannot fetch drug prices!");
		return;
	}

	if (!DB_GetRowCount(result))
	{
		print("Database error: drug_prices table is empty!");
		DB_FreeResultSet(result);
		return;
	}

	new
		i = 1,
		name[64], 
		name_alt[64], 
		price;

	DB_GetFieldStringByName(result, "name", name, sizeof(name));
	DB_GetFieldStringByName(result, "name_alt", name_alt, sizeof(name_alt));
	price = DB_GetFieldIntByName(result, "price");

	gDrugz[0][DrugName] = name_alt;
	gDrugz[0][DrugIniName] = name;
	gDrugz[0][DrugAmount] = 0;
	gDrugz[0][DrugPrice] = price;

	while (DB_SelectNextRow(result))
	{
		DB_GetFieldStringByName(result, "name", name, sizeof(name));
		DB_GetFieldStringByName(result, "name_alt", name_alt, sizeof(name_alt));
		price = DB_GetFieldIntByName(result, "price");

		gDrugz[i][DrugName] = name_alt;
		gDrugz[i][DrugIniName] = name;
		gDrugz[i][DrugAmount] = 0;
		gDrugz[i][DrugPrice] = price;

		i++;
	}

	print("Drug prices initialized!");
	DB_FreeResultSet(result);
}

stock InitDrugPickups()
{
	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT type, x, y, z FROM drug_coords");
	if (!result) 
	{
		print("Database error: cannot fetch drug coords!");
		return;
	}

	new 
		i = 0;

	do
	{
		new 
			DrugType: type = DrugType: DB_GetFieldIntByName(result, "type"),
			Float: X,
			Float: Y,
			Float: Z;

		X = DB_GetFieldFloatByName(result, "x");
		Y = DB_GetFieldFloatByName(result, "y");
		Z = DB_GetFieldFloatByName(result, "z");

		gDrugPickups[i][Type] = DrugType: type;
		gDrugPickups[i][Point][CoordX] = X;
		gDrugPickups[i][Point][CoordY] = Y;
		gDrugPickups[i][Point][CoordZ] = Z;

		switch (type)
		{
			case TYPE_ZAZA:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_GREEN, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_COCAINE:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_WHITE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_HEROIN:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_YELLOW, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_METH:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_BLUE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_FENT:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_RED, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_PCP:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_ORANGE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
		}

		i++;
	}
	while(DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("Drug pickups initialized!");
}

stock InitDruggeryPoints()
{
	new
		query[] = "SELECT id, x, y, z FROM druggery_points";

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		return 1;
	}

	new
		i = 0;

	do
	{
		new
			id = DB_GetFieldIntByName(result, "id"),
			Float: X = DB_GetFieldFloatByName(result, "x"),
			Float: Y = DB_GetFieldFloatByName(result, "y"),
			Float: Z = DB_GetFieldFloatByName(result, "z");

		gDruggeryPoints[i][ID] = id;
		gDruggeryPoints[i][Pickup] = EnsurePickupCreated(PICKUP_SKULL, 1, X, Y, Z);

		gDruggeryPoints[i][PointCoords][CoordX] = X;
		gDruggeryPoints[i][PointCoords][CoordY] = Y;
		gDruggeryPoints[i][PointCoords][CoordZ] = Z;

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("Druggery points initialized!");

	return 1;
}

stock CheckDruggeryPointPickup(playerid, pickupid)
{
	for (new i = 0; i < MAX_DRUGGERY_POINTS; i++)
	{
		if (gDruggeryPoints[i][Pickup] != pickupid)
		{
			continue;
		}

		if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
		{
			return 0;
		}

		return ShowBlackMarketMainDialog(playerid);
	}

	return 0;
}