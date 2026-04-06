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

#define MARKET_RATIO_MIN	0.001
#define MARKET_RATIO_MAX	1000.0
#define MARKET_RATIO_EQULIBRIUM	1.0
#define MARKET_REVERSION_RATE	0.15
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

new gBlackMarketItems[MAX_MARKET_ITEMS][BlackMarketItem];

new gBlackMarketItemOffer[MAX_PLAYERS][BlackMarketItem];

new Float: gBlackMarketRatio = 1.0;

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

new 
	gDrugPickups[MAX_DRUG_PICKUPS][DrugPickup];

new 
	gDrugz[MAX_DRUG_TYPES][Drug];

forward UpdateBlackMarketRatio();

public UpdateBlackMarketRatio()
{
	new
		// Symmetric step: -0.20 to +0.20 of current ratio
		Float: step = floatdiv(float(random(MARKET_STEP_PERCENT * 2 + 1) - MARKET_STEP_PERCENT), 100.0),
		// Mean reversion: pull toward equilibrium proportional to distance
		Float: reversion = floatmul(MARKET_REVERSION_RATE, MARKET_RATIO_EQULIBRIUM - gBlackMarketRatio);

	// Update raw value of the market ratio
	gBlackMarketRatio = gBlackMarketRatio + step + reversion;

	// Hard clamps
	if (gBlackMarketRatio < MARKET_RATIO_MIN)
	{
		gBlackMarketRatio = MARKET_RATIO_MIN;
	}

	if (gBlackMarketRatio > MARKET_RATIO_MAX)
	{
		gBlackMarketRatio = MARKET_RATIO_MAX;
	}
	
	// Ratio update message broadcasting
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		new msg[64];
		GetLocalizedString(i, I18N_BLACK_MARKET_RATIO_UPDATE, msg, sizeof(msg));

		format(msg, sizeof(msg), msg,
				gBlackMarketRatio
			);

		SendClientMessage(i, COLOR_ORANGE, msg);
	}
}

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
	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT type, x, y, z FROM drug_coords");
	if (!result) 
	{
		print("Database error: cannot fetch drug coords!");
		return;
	}

	new i = 0;

	do
	{
		new DrugType: type = DrugType: DB_GetFieldIntByName(result, "type"),
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

