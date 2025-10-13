//
//  drugz.pwn
//

#define MAX_DRUG_TYPES		10
#define MAX_DRUG_PICKUPS	64

#include "support/helpers.pwn"
#include "support/pickups.pwn"

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

new gDrugPickups[MAX_DRUG_PICKUPS][DrugPickup];

new gDrugz[MAX_DRUG_TYPES][Drug];

stock InitDrugValues()
{
	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT name, name_alt, price FROM drug_prices ORDER BY id ASC");
	if (!result) {
		print("Database error: cannot fetch drug prices!");
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
	if (!result) {
		print("Database error: cannot fetch drug coords!");
		return;
	}

	new i = 0;

	do
	{
		new type = DB_GetFieldIntByName(result, "type"),
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
}
