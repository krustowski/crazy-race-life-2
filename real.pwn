// 
//  Real Estate stuff.
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	5
#define SPAWN_PICKUP_COUNT	4
#define INVALID_PROPERTY_ID	-1

#include "sql.pwn"

enum 
{
	PICKUP_OFFER,
	PICKUP_ENTRANCE
}

enum
{
	PICKUP_INFO,
	PICKUP_HEALTH,
	PICKUP_PILLS,
	PICKUP_EXIT
}

enum Coords
{
       	Float: CoordX,
       	Float: CoordY,
       	Float: CoordZ,
        Float: CoordR
}

enum VehicleProps
{
	ID,
	Model,
	Colours[2],
	Components[16]
}

enum Property
{
	ID,
	UserID,
	Label[64],
	Cost,

	Float: LocationOffer[Coords],
	Float: LocationEntrance[Coords],
	Float: LocationVehicle[Coords],

	Vehicle[VehicleProps],

	bool: Occupied,

	Objects[5],
	Menu[5],
	Pickups[6],

	Drugs[MAX_DRUGS]
}

// The structure of the object+pickups system shown to a player when entering a house.
// Those references are set for the elements to be destroyed afterwards (when player leaves).
enum PlayerPropertyObject
{
	PropertyArrayID,
	Objects[2],
	Pickups[SPAWN_PICKUP_COUNT]
}

new gPlayerInteriors[MAX_PLAYERS][PlayerPropertyObject];

new gProperties[MAX_PROPERTIES][Property];

//
//
//

public InitRealEstateProperties()
{
	LoadRealEstateData();

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (!gProperties[i][ID])
			continue;

		if (!gProperties[i][Occupied])
			gProperties[i][Pickups][0] = EnsurePickupCreated(1273, 1, Float:gProperties[i][LocationOffer][CoordX], Float:gProperties[i][LocationOffer][CoordY], Float:gProperties[i][LocationOffer][CoordZ]);
		else
		{
			gProperties[i][Pickups][0] = EnsurePickupCreated(19522, 1, Float:gProperties[i][LocationOffer][CoordX], Float:gProperties[i][LocationOffer][CoordY], Float:gProperties[i][LocationOffer][CoordZ]);
			gProperties[i][Pickups][1] = EnsurePickupCreated(1318, 1, Float:gProperties[i][LocationEntrance][CoordX], Float:gProperties[i][LocationEntrance][CoordY], Float:gProperties[i][LocationEntrance][CoordZ]);
		}

		if (gProperties[i][Vehicle][Model] && gProperties[i][Vehicle][Model] >= 400 && gProperties[i][Vehicle][Model] <= 611)
		{
			gProperties[i][Vehicle][ID] = CreateVehicle(gProperties[i][Vehicle][Model], Float:gProperties[i][LocationVehicle][CoordX], Float:gProperties[i][LocationVehicle][CoordY], Float:gProperties[i][LocationVehicle][CoordZ], Float:gProperties[i][LocationVehicle][CoordR], gProperties[i][Vehicle][Colours][0], gProperties[i][Vehicle][Colours][1], -1);

			for (new j = 0; j < 16; j++)
			{
				if (gProperties[i][Vehicle][Components][j])
					AddVehicleComponent(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Components][j]);
			}
		}
	}

	return 1;
}

stock IsPlayerOwner(playerid, propertyId)
{
	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (gPlayers[playerid][Properties][i] == propertyId)
			return true;
	}

	return false;
}

stock SaveRealEstateData()
{
	new query[720];

	new vehicle_id = 0;

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (!gProperties[i][ID])
			continue;

		if (gProperties[i][Vehicle][Model]) {
			vehicle_id = gPlayers[i][ID];

			new componentsString[128];

			for (new j = 0; j < 16; j++)
			{
				if (!strcmp(componentsString, ""))
				{
					format(componentsString, sizeof(componentsString), "%d", gProperties[i][Vehicle][Components][j]);
					continue;
				}

				format(componentsString, sizeof(componentsString), "%s,%d", componentsString, gProperties[i][Vehicle][Components][j]);
			}

			format(query, sizeof(query), "INSERT INTO vehicles (id, model, color1, color2, components) VALUES (%d, %d, %d, %d, \"%s\") ON CONFLICT(id) DO UPDATE SET model = excluded.model, color1 = excluded.color1, color2 = excluded.color2, components = excluded.components",
					gProperties[i][ID],
					gProperties[i][Vehicle][Model],
					gProperties[i][Vehicle][Colours][0],
					gProperties[i][Vehicle][Colours][1],
					componentsString
			      );

			new DBResult: result_vehicle = DB_ExecuteQuery(gDbConnectionHandle, query);
			if (!result_vehicle) {
				printf("Database error: cannot write property data (vehicle, ID: %d)!", gProperties[i][ID]);
			}

			DB_FreeResultSet(result_vehicle);
		}

		format(query, sizeof(query), "INSERT INTO properties (id,user_id,vehicle_id,name,cost,location_offer_x,location_offer_y,location_offer_z,location_offer_rot,location_entrance_x,location_entrance_y,location_entrance_z,location_entrance_rot,location_vehicle_x,location_vehicle_y,location_vehicle_z,location_vehicle_rot,occupied) VALUES (%d, %d, %d, '%s', %d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %d) ON CONFLICT(id) DO UPDATE SET occupied = excluded.occupied, user_id = excluded.user_id",
				gProperties[i][ID],
				gProperties[i][UserID],
				vehicle_id,
				gProperties[i][Label],
				gProperties[i][Cost],
				gProperties[i][LocationOffer][CoordX],
				gProperties[i][LocationOffer][CoordY],
				gProperties[i][LocationOffer][CoordZ],
				gProperties[i][LocationOffer][CoordR],
				gProperties[i][LocationEntrance][CoordX],
				gProperties[i][LocationEntrance][CoordY],
				gProperties[i][LocationEntrance][CoordZ],
				gProperties[i][LocationEntrance][CoordR],
				gProperties[i][LocationVehicle][CoordX],
				gProperties[i][LocationVehicle][CoordY],
				gProperties[i][LocationVehicle][CoordZ],
				gProperties[i][LocationVehicle][CoordR],
				gProperties[i][Occupied]
		      );

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			printf("Database error: cannot write property data (ID: %d)!", gProperties[i][ID]);
		}

		DB_FreeResultSet(result);

		//
		//
		//

		//
		// Drugz.
		//

		/*new label[7] = "_drugz";
		  strcopy(stringCopy, stringName);
		  strcat(stringCopy, label);

		  for (new j = 0; j < MAX_DRUGS; j++)
		  {
		  writecfgvalue(fileName, stringCopy, gDrugz[j][DrugIniName], gProperties[i][Drugs][j]);
		  }*/
	}

	return 1;
}

stock ExtractIntsFromString(const input[], ints[16])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		ints[i] = strval(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return ints;
}

// Helper enum for the real estate data field parsing.
enum {
	FIELD_ID,
	FIELD_USER_ID,
	FIELD_VEHICLE_ID,
	FIELD_NAME,
	FIELD_COST,
	FIELD_LOCATION_OFFER_X,
	FIELD_LOCATION_OFFER_Y,
	FIELD_LOCATION_OFFER_Z,
	FIELD_LOCATION_OFFER_ROT,
	FIELD_LOCATION_ENTRANCE_X,
	FIELD_LOCATION_ENTRANCE_Y,
	FIELD_LOCATION_ENTRANCE_Z,
	FIELD_LOCATION_ENTRANCE_ROT,
	FIELD_LOCATION_VEHICLE_X,
	FIELD_LOCATION_VEHICLE_Y,
	FIELD_LOCATION_VEHICLE_Z,
	FIELD_LOCATION_VEHICLE_ROT,
	FIELD_OCCUPIED
}

enum {
	FIELD_VEHICLE_MODEL,
	FIELD_VEHICLE_COLOR1,
	FIELD_VEHICLE_COLOR2,
	FIELD_VEHICLE_COMPONENTS
}

stock LoadRealEstateData()
{
	new i = 0, query[512];

	format(query, sizeof(query), "SELECT id,user_id,vehicle_id,name,cost,location_offer_x,location_offer_y,location_offer_z,location_offer_rot,location_entrance_x,location_entrance_y,location_entrance_z,location_entrance_rot,location_vehicle_x,location_vehicle_y,location_vehicle_z,location_vehicle_rot,occupied FROM properties");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch property data!");
		return 0;
	}

	while (DB_SelectNextRow(result))
	{
		new name[64];

		gProperties[i][ID] = DB_GetFieldInt(result, FIELD_ID);
		gProperties[i][UserID] = bool: DB_GetFieldInt(result, FIELD_USER_ID);
		gProperties[i][Cost] = DB_GetFieldInt(result, FIELD_COST);
		gProperties[i][Occupied] = bool: DB_GetFieldInt(result, FIELD_OCCUPIED);

		// Offer/Sell pickup coords
		gProperties[i][LocationOffer][CoordX] = DB_GetFieldInt(result, FIELD_LOCATION_OFFER_X);
		gProperties[i][LocationOffer][CoordY] = DB_GetFieldInt(result, FIELD_LOCATION_OFFER_Y);
		gProperties[i][LocationOffer][CoordZ] = DB_GetFieldInt(result, FIELD_LOCATION_OFFER_Z);
		gProperties[i][LocationOffer][CoordR] = DB_GetFieldInt(result, FIELD_LOCATION_OFFER_ROT);

		// Entrance pickup coords
		gProperties[i][LocationEntrance][CoordX] = DB_GetFieldInt(result, FIELD_LOCATION_ENTRANCE_X);
		gProperties[i][LocationEntrance][CoordY] = DB_GetFieldInt(result, FIELD_LOCATION_ENTRANCE_Y);
		gProperties[i][LocationEntrance][CoordZ] = DB_GetFieldInt(result, FIELD_LOCATION_ENTRANCE_Z);
		gProperties[i][LocationEntrance][CoordR] = DB_GetFieldInt(result, FIELD_LOCATION_ENTRANCE_ROT);

		// Vehicle pickup coords
		gProperties[i][LocationVehicle][CoordX] = DB_GetFieldInt(result, FIELD_LOCATION_VEHICLE_X);
		gProperties[i][LocationVehicle][CoordY] = DB_GetFieldInt(result, FIELD_LOCATION_VEHICLE_Y);
		gProperties[i][LocationVehicle][CoordZ] = DB_GetFieldInt(result, FIELD_LOCATION_VEHICLE_Z);
		gProperties[i][LocationVehicle][CoordR] = DB_GetFieldInt(result, FIELD_LOCATION_VEHICLE_ROT);

		DB_GetFieldString(result, FIELD_NAME, name, sizeof(name));

		gProperties[i][Label] = name;

		//
		//  Vehicle props extraction
		//

		new vehicle_id;

		vehicle_id = DB_GetFieldInt(result, FIELD_VEHICLE_ID);

		if (!vehicle_id) {
			i++;
			continue;
		}

		format(query, sizeof(query), "SELECT model,color1,color2,components FROM vehicles WHERE id = %d", vehicle_id);

		new DBResult: result_vehicle = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_vehicle) {
			print("Database error: cannot fetch property data (vehicle)!");

			i++;
			continue;
		}

		new componentsString[256], components[16];

		DB_GetFieldString(result_vehicle, FIELD_VEHICLE_COMPONENTS, componentsString, sizeof(componentsString));

		ExtractIntsFromString(componentsString, components);
		gProperties[i][Vehicle][Components] = components;

		gProperties[i][Vehicle][Model] = DB_GetFieldInt(result_vehicle, FIELD_VEHICLE_MODEL);
		gProperties[i][Vehicle][Colours][0] = DB_GetFieldInt(result_vehicle, FIELD_VEHICLE_COLOR1);
		gProperties[i][Vehicle][Colours][1] = DB_GetFieldInt(result_vehicle, FIELD_VEHICLE_COLOR2);

		DB_FreeResultSet(result_vehicle);

		i++;
	}

	DB_FreeResultSet(result);

	/*do {
	// Drugz.
	new label[7] = "_drugz";
	strcat(token1, label);

	for (new j = 0; j < MAX_DRUGS; j++)
	{
	gProperties[i][Drugs][j] = readcfgvalue(fileName, token1, gDrugz[j][DrugIniName]);
	}

	// Prepare vars for the next run.
	strcopy(properties, token2);
	i++;

	if (i > MAX_PROPERTIES)
	break;
	} while (strcmp(token2, ""));*/

	return 1;
}

stock ExtractCoordsFromString(const input[], Float: coords[Coords])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		coords[Coords: i] = floatstr(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return 1;
}

stock SpawnPropertyInterior(playerid, arrayID)
{
	gPlayerInteriors[playerid][PropertyArrayID] = arrayID;

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);

	Z += 1500;

	// The very room object.
	gPlayerInteriors[playerid][Objects][0] = CreatePlayerObject(playerid, 14859, Float:X, Float:Y, Float:Z, 0.0, 0.0, 0.0, 0.0);

	// Exit, Health, Pills, Info pickups.
	new pickupIds[4] = {1239, 1240, 1241, 1318};
	new Float: pickupCoords[4][3];

	// Info pickup.
	pickupCoords[0][0] = X+2.50; pickupCoords[0][1] = Y+2.20; pickupCoords[0][2] = Z-1.0;
	// Health pickup.
	pickupCoords[1][0] = X-2.20; pickupCoords[1][1] = Y-2.50; pickupCoords[1][2] = Z-1.0;
	// Pills/drugz pickup.
	pickupCoords[2][0] = X+2.50; pickupCoords[2][1] = Y-2.50; pickupCoords[2][2] = Z-1.0;
	// Exit pickup.
	pickupCoords[3][0] = X-2.42; pickupCoords[3][1] = Y+1.25; pickupCoords[3][2] = Z-1.0;

	for (new i = 0; i < SPAWN_PICKUP_COUNT; i++)
	{
		gPlayerInteriors[playerid][Pickups][i] = EnsurePickupCreated(pickupIds[i], 1, Float:pickupCoords[i][0], Float:pickupCoords[i][1], Float:pickupCoords[i][2]);

		if (!gPlayerInteriors[playerid][Pickups][i] || gPlayerInteriors[playerid][Pickups][i] == -1)
		{
			printf("SpawnPropertyInterior: pickup creation error: pickup no. %d, value: %d", i, gPlayerInteriors[playerid][Pickups][i]);

			SendClientMessageLocalized(playerid, I18N_REAL_INTERIOR_GEN_FAIL);

			DestroyPropertyInterior(playerid);

			return 0;
		}

		//printf("SpawnPropertyInterior: pickup no. %d: %d", i, gPlayerInteriors[playerid][Pickups][i]);
		//ShowPickupForPlayer(playerid, gPlayerInteriors[playerid][Pickups][i]);
	}

	SetPlayerPos(playerid, Float:X, Float:Y, Float:(Z-1.0));
	SetPlayerFacingAngle(playerid, 0.0);

	return 1;
}

stock DestroyPropertyInterior(playerid)
{
	DestroyPlayerObject(playerid, gPlayerInteriors[playerid][Objects][0]);

	gPlayerInteriors[playerid][PropertyArrayID] = -1;

	for (new j = 0; j < SPAWN_PICKUP_COUNT; j++)
	{
		if (!DestroyPickup(gPlayerInteriors[playerid][Pickups][j]))
			printf("DestroyPropertyInterior: failed to delete pickup no. %d!", j);

		gPlayerInteriors[playerid][Pickups][j] = 0;
	}

	return 1;
}

stock SpawnPlayerAtProperty(playerid)
{
	if (!IsPlayerOwner(playerid, gPlayers[playerid][SpawnPoint]))
		return 0;

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (!gProperties[i][ID] || !gProperties[i][Occupied])
			continue;

		if (gProperties[i][ID] != gPlayers[playerid][SpawnPoint])
			continue;

		SetPlayerPos(playerid, Float:gProperties[i][LocationOffer][Coords: 0], Float:gProperties[i][LocationOffer][Coords: 1], Float:gProperties[i][LocationOffer][Coords: 2]);

		return 1;
	}

	return 0;
}

stock GetPropertyArrayIDfromID(propertyID)
{
	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][ID] == propertyID)
			return i;
	}

	return -1;
}

stock BuyPlayerProperty(playerid, propertyID)
{
	new arrayID, freeSlot = -1;

	arrayID = GetPropertyArrayIDfromID(propertyID);

	// Check if there is a free slot for such player.
	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (!gPlayers[playerid][Properties][i])
		{
			freeSlot = i;
			break;
		}
	}

	//
	//  Validations.
	//

	if (arrayID == INVALID_PROPERTY_ID || !propertyID)
		return SendClientMessageLocalized(playerid, I18N_REAL_INVALID_CODE);

	if (freeSlot < 0)
		return SendClientMessageLocalized(playerid, I18N_REAL_NO_FREE_SLOT);

	if (gProperties[arrayID][Occupied])
		return SendClientMessageLocalized(playerid, I18N_REAL_ALREADY_OCCUPIED);

	if (!IsPlayerInSphere(playerid, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ], 15))
		return SendClientMessageLocalized(playerid, I18N_REAL_SELL_PICKUP_MISLOC);
		//return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Je treba byt v okoli puvodniho pickupu (rotujici zeleny domek).");

	if (GetPlayerMoney(playerid) < gProperties[arrayID][Cost])
		return SendClientMessageLocalized(playerid, I18N_REAL_NO_MONEY);

	//
	//  Ok, proceed with the transaction.
	//

	gProperties[arrayID][Occupied] = true;
	gPlayers[playerid][Properties][freeSlot] = propertyID;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_OFFER]);
	//gProperties[arrayID][Pickups][PICKUP_OFFER];

	gProperties[arrayID][Pickups][PICKUP_OFFER] = EnsurePickupCreated(19522, 1, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ]);
	gProperties[arrayID][Pickups][PICKUP_ENTRANCE] = EnsurePickupCreated(1318, 1, Float:gProperties[arrayID][LocationEntrance][CoordX], Float:gProperties[arrayID][LocationEntrance][CoordY], Float:gProperties[arrayID][LocationEntrance][CoordZ]);

	GivePlayerMoney(playerid, -gProperties[arrayID][Cost]);

	return SendClientMessageLocalized(playerid, I18N_REAL_PROPERTY_ACQ);
}

stock SellPlayerProperty(playerid, propertyID)
{
	new arrayID;

	arrayID = GetPropertyArrayIDfromID(propertyID);

	if (arrayID == INVALID_PROPERTY_ID || !propertyID)
		return SendClientMessageLocalized(playerid, I18N_REAL_INVALID_CODE);

	if (!IsPlayerInSphere(playerid, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ], 15))
		return SendClientMessageLocalized(playerid, I18N_REAL_SELL_PICKUP_MISLOC);

	if (!gProperties[arrayID][Occupied])
		return SendClientMessageLocalized(playerid, I18N_REAL_SELL_NOT_OCCUPIED);

	if (!IsPlayerOwner(playerid, propertyID))
		return SendClientMessageLocalized(playerid, I18N_REAL_SELL_NOT_OWNED);

	//
	//  Ok, sell the property.
	//

	if (gPlayers[playerid][SpawnPoint] == propertyID)
		gPlayers[playerid][SpawnPoint] = 0;

	// Free the property slot.
	for (new j = 0; j < MAX_PLAYER_PROPERTIES; j++)
	{
		if (gPlayers[playerid][Properties][j] == propertyID)
		{
			gPlayers[playerid][Properties][j] = 0;
			break;
		}
	}

	gProperties[arrayID][Occupied] = false;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_OFFER]);
	gProperties[arrayID][Pickups][PICKUP_OFFER] = 0;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_ENTRANCE]);
	gProperties[arrayID][Pickups][PICKUP_ENTRANCE] = 0;

	gProperties[arrayID][Pickups][PICKUP_OFFER] = EnsurePickupCreated(1273, 1, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ]);

	GivePlayerMoney(playerid, floatround(float(gProperties[arrayID][Cost]) * 0.9));

	return SendClientMessageLocalized(playerid, I18N_REAL_SELL_SUCCESS);
}

stock UpdatePropertyVehicle(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid))
		return 0;

	new arrayID, bool: modelMatch = false, vehicleID;

	vehicleID = GetPlayerVehicleID(playerid);

	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		new propertyID = gPlayers[playerid][Properties][i];

		if (!propertyID)
			continue;

		arrayID = GetPropertyArrayIDfromID(propertyID);

		if (arrayID == -1)
			continue;

		if (GetVehicleModel(vehicleID) == gProperties[arrayID][Vehicle][Model] && vehicleID == gProperties[arrayID][Vehicle][ID])
		{
			modelMatch = true;
			break;
		}
	}

	if (!modelMatch)
		return 0;

	new colour1, colour2;

	GetVehicleColours(vehicleID, colour1, colour2);

	gProperties[arrayID][Vehicle][Colours][0] = colour1;
	gProperties[arrayID][Vehicle][Colours][1] = colour2;

	for (new i = 0; i < 16; i++)
	{
		gProperties[arrayID][Vehicle][Components][i] = GetVehicleComponentInSlot(vehicleID, t_CARMODTYPE: i);
	}

	SendClientMessageLocalized(playerid, I18N_REAL_VEHMOD_SAVED);

	return 1;
}

