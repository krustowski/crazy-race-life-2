// 
//  real.pwn
//  Real Estate stuff
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	5
#define MAX_PROPERTY_PICKUPS	32
#define SPAWN_PICKUP_COUNT	4
#define INVALID_PROPERTY_ID	-1

#include "db/sql.pwn"
#include "support/dialogs.pwn"
#include "support/pickups.pwn"

// Exterior pickups
enum 
{
	PICKUP_TYPE_OFFER,
	PICKUP_TYPE_ENTRANCE
}

// Interior pickups
enum
{
	PICKUP_TYPE_INFO,
	PICKUP_TYPE_HEALTH,
	PICKUP_TYPE_PILLS,
	PICKUP_TYPE_EXIT
}

enum PropertyPoint
{
	NULL_POINT,
	SPAWN_POINT,
	HEALTH_POINT,
	DRUGZ_POINT,
	INFO_POINT,
	EXIT_POINT,
	ENTRANCE_POINT,
	VEHICLE_POINT,
	OFFER_POINT
}

// Helper enum for the real estate data field parsing.
enum 
{
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
	FIELD_OCCUPIED,
	FIELD_CUSTOM_INTERIOR
}

enum 
{
	FIELD_VEHICLE_MODEL,
	FIELD_VEHICLE_COLOR1,
	FIELD_VEHICLE_COLOR2,
	FIELD_VEHICLE_COMPONENTS
}

enum Coords
{
       	Float: CoordX,
       	Float: CoordY,
       	Float: CoordZ,
        Float: CoordR
}

enum PropertyPickup
{
	PickupType[PropertyPoint],
	Pickup,
	Primary[Coords],
	Secondary[Coords]
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
	bool: CustomInterior,

	Objects[5],
	Menu[5],
	Pickups[MAX_PROPERTY_PICKUPS],

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

new gPropertyCoords[MAX_PROPERTIES][MAX_PROPERTY_PICKUPS][PropertyPickup];

// Utilized by lvl5 admins when editing a property.
new gPropertyEdit[MAX_PLAYERS][Property];

// Used to flush gPropertyEdit entry when editing is done.
new gNullProperty[Property] = 
{
	0,
	0,
	"",
	0,
	{0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0},
	{0.0, 0.0, 0.0, 0.0},
	0,
	false,
	false,
	{0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
};

//
//
//

forward InitRealEstateProperties();

public InitRealEstateProperties()
{
	printf("public InitRealEstateProperties()");

	LoadRealEstateData();

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		printf("public InitRealEstateProperties(): i = %d", i);

		if (!gProperties[i][ID])
			continue;
		
		SpawnProperty(i);
	}

	return 1;
}

stock SpawnPlayerEntrancePickups(playerid)
{
	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][UserID] == gPlayers[playerid][OrmID])
		{
			// Create entrance pickups exclusive to the player
			new
				Float: X = gProperties[i][LocationEntrance][CoordX],
				Float: Y = gProperties[i][LocationEntrance][CoordY],
				Float: Z = gProperties[i][LocationEntrance][CoordZ];
				
			gProperties[i][Pickups][1] = EnsurePickupCreated(1318, 1, X, Y, Z);

			continue;
		}

		// Hide other entrance pickups
		HidePickupForPlayer(playerid, gProperties[i][Pickups][1]);
	}

	return 1;
}

stock SpawnProperty(propertyId)
{
	new query[256];

	format(query, sizeof(query), "SELECT type,primary_x,primary_y,primary_z,primary_rot,secondary_x,secondary_y,secondary_z,secondary_rot FROM property_coords WHERE property_id = %d", 
			gProperties[propertyId][ID]
	);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot list property coords (ID: %d: %d)!", propertyId, gProperties[propertyId][ID]);
		print(query);

		return 0;
	}

	new i = 0;

	do 
	{
		new type = DB_GetFieldIntByName(result, "type");

		new 
			Float: pX = DB_GetFieldFloatByName(result, "primary_x"),
			Float: pY = DB_GetFieldFloatByName(result, "primary_y"),
			Float: pZ = DB_GetFieldFloatByName(result, "primary_z"),
			Float: pR = DB_GetFieldFloatByName(result, "primary_rot"),
			Float: sX = DB_GetFieldFloatByName(result, "secondary_x"),
			Float: sY = DB_GetFieldFloatByName(result, "secondary_y"),
			Float: sZ = DB_GetFieldFloatByName(result, "secondary_z"),
			Float: sR = DB_GetFieldFloatByName(result, "secondary_rot");

		gPropertyCoords[propertyId][i][PickupType] = type;

		printf("stock SpawnProperty(): i = %d\n", i);

		switch (type)
		{
			case SPAWN_POINT:
				{
					gPropertyCoords[propertyId][i][Primary][CoordX] = pX;
					gPropertyCoords[propertyId][i][Primary][CoordY] = pY;
					gPropertyCoords[propertyId][i][Primary][CoordZ] = pZ;
					gPropertyCoords[propertyId][i][Primary][CoordR] = pR;
				}
			case HEALTH_POINT:
				{
					gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_HEART, 1, pX, pY, pZ);
				}
			case DRUGZ_POINT:
				{
					gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_PILL, 1, pX, pY, pZ);
				}
			case INFO_POINT:
				{
					gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_INFO, 1, pX, pY, pZ);
				}
			case EXIT_POINT:
				{
					gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_ARROW, 1, pX, pY, pZ);
					gPropertyCoords[propertyId][i][Secondary][CoordX] = sX;
					gPropertyCoords[propertyId][i][Secondary][CoordY] = sY;
					gPropertyCoords[propertyId][i][Secondary][CoordZ] = sZ;
					gPropertyCoords[propertyId][i][Secondary][CoordR] = sR;
				}
			case ENTRANCE_POINT:
				{
					if (gProperties[propertyId][Occupied])
						gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_ARROW, 1, pX, pY, pZ);

					gPropertyCoords[propertyId][i][Primary][CoordX] = pX;
					gPropertyCoords[propertyId][i][Primary][CoordY] = pY;
					gPropertyCoords[propertyId][i][Primary][CoordZ] = pZ;
					gPropertyCoords[propertyId][i][Primary][CoordR] = pR;

					gPropertyCoords[propertyId][i][Secondary][CoordX] = sX;
					gPropertyCoords[propertyId][i][Secondary][CoordY] = sY;
					gPropertyCoords[propertyId][i][Secondary][CoordZ] = sZ;
					gPropertyCoords[propertyId][i][Secondary][CoordR] = sR;
				}
			case VEHICLE_POINT:
				{
					if (gProperties[propertyId][Vehicle][Model] && gProperties[propertyId][Vehicle][Model] >= 400 && gProperties[propertyId][Vehicle][Model] <= 611)
					{
						gProperties[propertyId][Vehicle][ID] = CreateVehicle(gProperties[propertyId][Vehicle][Model], pX, pY, pZ, pR, gProperties[propertyId][Vehicle][Colours][0], gProperties[propertyId][Vehicle][Colours][1], -1);

						for (new j = 0; j < 16; j++)
						{
							if (gProperties[propertyId][Vehicle][Components][j])
								AddVehicleComponent(gProperties[propertyId][Vehicle][ID], gProperties[propertyId][Vehicle][Components][j]);
						}
					}
				}
			case OFFER_POINT:
				{
					if (!gProperties[propertyId][Occupied])
						gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_HOUSE_GREEN, 1, pX, pY, pZ);
					else
					{
						gPropertyCoords[propertyId][i][Pickup] = EnsurePickupCreated(PICKUP_HOUSE_RED, 1, pX, pY, pZ);

						new playerName[MAX_PLAYER_NAME];
						GetOwnerName(gProperties[propertyId][UserID], playerName);
						Create3DTextLabel("%s owns this property", COLOR_ORANGE, pX, pY, pZ, 15.0, -1, false, playerName);
					}
				}
		}

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	return 1;
}

stock GetOwnerName(userId, playerName[MAX_PLAYER_NAME])
{
	new query[256];

	format(query, sizeof(query), "SELECT nickname FROM users WHERE id = %d", 
			userId
	      );

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot fetch user nickname (userID: %d)!", userId);
		print(query);

		return 0;
	}

	DB_GetFieldStringByName(result, "nickname", playerName, sizeof(playerName));

	DB_FreeResultSet(result);

	return 1;
}

stock LoadPlayerProperties(playerid)
{
	new query[256];

	format(query, sizeof(query), "SELECT id FROM properties WHERE user_id = %d AND occupied = 1", 
			gPlayers[playerid][OrmID]
	      );

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot list player's properties (ID: %d)!", playerid);
		print(query);

		return 0;
	}

	new i = 0;

	do
	{
		gPlayers[playerid][Properties][i] = DB_GetFieldIntByName(result, "id");

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	SpawnPlayerEntrancePickups(playerid);

	return 1;
}

stock IsPlayerOwner(playerid, propertyId)
{
	/*new query[256];

	  format(query, sizeof(query), "SELECT vehicle_id FROM properties WHERE user_id = %d AND occupied = 1 AND id = %d", 
	  gPlayers[playerid][OrmID], 
	  propertyId
	  );

	  new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	  if (!result) 
	  {
	  printf("Database error: cannot verify property ownership (ID: %d)!", propertyId);
	  return false;
	  }

	  if (DB_GetRowCount(result))
	  {
	  DB_FreeResultSet(result);
	  return true;
	  }

	  DB_FreeResultSet(result);*/

	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (gPlayers[playerid][Properties][i] == propertyId)
			return true;
	}

	return false;
}

stock SaveRealEstateData()
{
	new query[1024];

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

		format(query, sizeof(query), "INSERT INTO properties (id,user_id,vehicle_id,name,cost,location_offer_x,location_offer_y,location_offer_z,location_offer_rot,location_entrance_x,location_entrance_y,location_entrance_z,location_entrance_rot,location_vehicle_x,location_vehicle_y,location_vehicle_z,location_vehicle_rot,occupied,custom_interior) VALUES (%d, %d, %d, '%s', %d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %d, %d) ON CONFLICT(id) DO UPDATE SET occupied = excluded.occupied, user_id = excluded.user_id, custom_interior = excluded.custom_interior",
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
				gProperties[i][Occupied],
				gProperties[i][CustomInterior]
		      );

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			printf("Database error: cannot write property data (ID: %d)!", gProperties[i][ID]);
		}

		DB_FreeResultSet(result);

		//
		//
		//

		format(query, sizeof(query), "INSERT INTO drugz (owner_type, owner_id, cocaine, heroin, meth, fent, zaza, tobacco, pcp, paper, lighter, joint) VALUES (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d) ON CONFLICT(owner_id) DO UPDATE SET cocaine = excluded.cocaine, heroin = excluded.heroin, meth = excluded.meth, fent = excluded.fent, zaza = excluded.zaza, tobacco = excluded.tobacco, pcp = excluded.pcp, paper = excluded.paper, lighter = excluded.lighter, joint = excluded.joint",
				2,
				gProperties[i][ID],
				gProperties[i][Drugs][COCAINE],
				gProperties[i][Drugs][HEROIN],
				gProperties[i][Drugs][METH],
				gProperties[i][Drugs][FENT],
				gProperties[i][Drugs][ZAZA],
				gProperties[i][Drugs][TOBACCO],
				gProperties[i][Drugs][PCP],
				gProperties[i][Drugs][PAPER],
				gProperties[i][Drugs][LIGHTER],
				gProperties[i][Drugs][JOINT]
		      );

		new DBResult: result_drugz = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_drugz) {
			printf("Database error: cannot write property data (drugz, ID: %d)!", gProperties[i][ID]);
		}

		DB_FreeResultSet(result_drugz);
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

stock LoadRealEstateData()
{
	new i = 0, query[512];

	format(query, sizeof(query), "SELECT id,user_id,vehicle_id,name,cost,location_offer_x,location_offer_y,location_offer_z,location_offer_rot,location_entrance_x,location_entrance_y,location_entrance_z,location_entrance_rot,location_vehicle_x,location_vehicle_y,location_vehicle_z,location_vehicle_rot,occupied,custom_interior FROM properties");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch property data!");
		return 0;
	}

	do
	{
		printf("stock LoadRealEstateData(): i = %d", i);

		new name[64];

		gProperties[i][ID] = DB_GetFieldIntByName(result, "id");
		gProperties[i][UserID] = DB_GetFieldIntByName(result, "user_id");
		gProperties[i][Cost] = DB_GetFieldIntByName(result, "cost");
		gProperties[i][Occupied] = bool: DB_GetFieldIntByName(result, "occupied");
		gProperties[i][CustomInterior] = bool: DB_GetFieldIntByName(result, "custom_interior");

		DB_GetFieldStringByName(result, "name", name, sizeof(name));

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

		//
		//   Drugz
		//

		format(query, sizeof(query), "SELECT cocaine, heroin, meth, fent, zaza, tobacco, pcp, paper, lighter, joint FROM drugz WHERE owner_id = %d AND owner_type = 2", gProperties[i][ID]);

		new DBResult: result_drugz = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_drugz) {
			print("Database error: cannot fetch property data (drugz)!");

			i++;
			continue;
		}

		gProperties[i][Drugs][COCAINE] = DB_GetFieldIntByName(result_drugz, "cocaine");
		gProperties[i][Drugs][HEROIN] = DB_GetFieldIntByName(result_drugz, "heroin");
		gProperties[i][Drugs][METH] = DB_GetFieldIntByName(result_drugz, "meth");
		gProperties[i][Drugs][FENT] = DB_GetFieldIntByName(result_drugz, "fent");
		gProperties[i][Drugs][ZAZA] = DB_GetFieldIntByName(result_drugz, "zaza");
		gProperties[i][Drugs][TOBACCO] = DB_GetFieldIntByName(result_drugz, "tobacco");
		gProperties[i][Drugs][PCP] = DB_GetFieldIntByName(result_drugz, "pcp");
		gProperties[i][Drugs][PAPER] = DB_GetFieldIntByName(result_drugz, "paper");
		gProperties[i][Drugs][LIGHTER] = DB_GetFieldIntByName(result_drugz, "lighter");
		gProperties[i][Drugs][JOINT] = DB_GetFieldIntByName(result_drugz, "joint");

		DB_FreeResultSet(result_drugz);

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

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
	if (gPlayers[playerid][InsideProperty])
		return 0;

	if (gProperties[arrayID][CustomInterior])
		return 1;

	gPlayerInteriors[playerid][PropertyArrayID] = arrayID;

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);

	Z += 1500;

	// The very room object.
	gPlayerInteriors[playerid][Objects][0] = CreatePlayerObject(playerid, 14859, Float:X, Float:Y, Float:Z, 0.0, 0.0, 0.0, 0.0);

	new pickupIds[4] = {PICKUP_INFO, PICKUP_HEART, PICKUP_PILL, PICKUP_ARROW};
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

	gPlayers[playerid][InsideProperty] = true;

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

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		for (new j = 0; j < MAX_PROPERTY_PICKUPS; j++)
		{
			if (gPropertyCoords[i][j][PickupType] != 1)
				continue;

			if (gProperties[i][ID] != gPlayers[playerid][SpawnPoint])
				continue;

			SetPlayerPos(playerid, gPropertyCoords[i][j][Primary][CoordX], gPropertyCoords[i][j][Primary][CoordY], gPropertyCoords[i][j][Primary][CoordZ]);
		}
	}

	return 1;
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

	if (GetPlayerMoney(playerid) < gProperties[arrayID][Cost])
		return SendClientMessageLocalized(playerid, I18N_REAL_NO_MONEY);

	//
	//  Ok, proceed with the transaction.
	//

	gProperties[arrayID][Occupied] = true;
	gProperties[arrayID][UserID] = gPlayers[playerid][OrmID];
	gPlayers[playerid][Properties][freeSlot] = propertyID;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER]);
	//gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER];

	gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER] = EnsurePickupCreated(19522, 1, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ]);
	gProperties[arrayID][Pickups][PICKUP_TYPE_ENTRANCE] = EnsurePickupCreated(1318, 1, Float:gProperties[arrayID][LocationEntrance][CoordX], Float:gProperties[arrayID][LocationEntrance][CoordY], Float:gProperties[arrayID][LocationEntrance][CoordZ]);

	GivePlayerMoney(playerid, -gProperties[arrayID][Cost]);

	// Play property bought theme sound
	PlayerPlaySound(playerid, 183, 0.0, 0.0, 0.0);

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

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER]);
	gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER] = 0;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_TYPE_ENTRANCE]);
	gProperties[arrayID][Pickups][PICKUP_TYPE_ENTRANCE] = 0;

	gProperties[arrayID][Pickups][PICKUP_TYPE_OFFER] = EnsurePickupCreated(1273, 1, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ]);

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

//
//
//

stock EditProperty(playerid)
{
	new propertyid = gPropertyEdit[playerid][ID];

	if (!propertyid || propertyid < 10101)
	{
		SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Invalid property number");
		return 0;
	}	

	new arrayid = GetPropertyArrayIDfromID(propertyid), bool: existingRecord = false;

	if (arrayid >= 0) 
	{
		//gProperties[arrayid] = gPropertyEdit[playerid];
		existingRecord = true;
	}

	new propertyPoolSize = 0;

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (gProperties[i][ID])
			propertyPoolSize++;
	}

	if (propertyPoolSize == MAX_PROPERTIES)
	{
		SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Max properties limit reached, cancelling the transaction");

		return 1;
	}

	new query[2048];

	format(query, sizeof(query), "INSERT INTO properties (id, user_id, name, cost, location_offer_x, location_offer_y, location_offer_z, location_offer_rot, location_entrance_x, location_entrance_y, location_entrance_z, location_entrance_rot, location_vehicle_x, location_vehicle_y, location_vehicle_z, location_vehicle_rot, occupied, custom_interior) VALUES (%d, %d, '%s', %d, %.2f, %.2f, %.2f, 0.0, %.2f, %.2f, %.2f, 0.0, %.2f, %.2f, %.2f, %.2f, %d, %d) ON CONFLICT(id) DO UPDATE SET user_id = excluded.user_id, name = excluded.name, cost = excluded.cost, location_offer_x = excluded.location_offer_x, location_offer_y = excluded.location_offer_y, location_offer_z = excluded.location_offer_z, location_entrance_x = excluded.location_entrance_x, location_entrance_y = excluded.location_entrance_y, location_entrance_z = excluded.location_entrance_z, location_vehicle_x = excluded.location_vehicle_x, location_vehicle_y = excluded.location_vehicle_y, location_vehicle_z = excluded.location_vehicle_z, location_vehicle_rot = excluded.location_vehicle_rot, occupied = excluded.occupied, custom_interior = excluded.custom_interior",
			gPropertyEdit[playerid][ID],
			gPropertyEdit[playerid][UserID],
			gPropertyEdit[playerid][Label],
			gPropertyEdit[playerid][Cost],
			gPropertyEdit[playerid][LocationOffer][CoordX],
			gPropertyEdit[playerid][LocationOffer][CoordY],
			gPropertyEdit[playerid][LocationOffer][CoordZ],
			gPropertyEdit[playerid][LocationEntrance][CoordX],
			gPropertyEdit[playerid][LocationEntrance][CoordY],
			gPropertyEdit[playerid][LocationEntrance][CoordZ],
			gPropertyEdit[playerid][LocationVehicle][CoordX],
			gPropertyEdit[playerid][LocationVehicle][CoordY],
			gPropertyEdit[playerid][LocationVehicle][CoordZ],
			gPropertyEdit[playerid][LocationVehicle][CoordR],
			gPropertyEdit[playerid][Occupied],
			gPropertyEdit[playerid][CustomInterior]
	      );

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Database error!");
		printf("Database error: cannot write property data (ID: %d)!", propertyid);
		return 0;
	}

	DB_FreeResultSet(result);

	// Update the server memory
	if (existingRecord)
	{
		gProperties[arrayid] = gPropertyEdit[playerid];
	} 
	else
	{
		gProperties[propertyPoolSize] = gPropertyEdit[playerid];
	}

	SpawnProperty( GetPropertyArrayIDfromID( gPropertyEdit[playerid][ID] ) );

	gPropertyEdit[playerid] = gNullProperty;
	gPlayers[playerid][EditingMode] = false;

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property saved successfully!");

	return 1;
}

stock CheckRealEstatePickup(playerid, pickupid)
{
	new stringToPrint[256];

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		for (new j = 0; j < MAX_PROPERTY_PICKUPS; j++)
		{
			// Continue on zero/invalid pickup ID
			if (!gPropertyCoords[i][j][Pickup])
				continue;

			if (pickupid != gPropertyCoords[i][j][Pickup])
				continue;

			switch (gPropertyCoords[i][j][PickupType])
			{
				case INFO_POINT:
					{
						//
						return 1;
					}
				case HEALTH_POINT:
					{
						SetPlayerHealth(playerid, 100.0);
						SetPlayerArmour(playerid, 100.0);
						SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ HP ] Health: 100.0, Armour: 100.0");
						return 1;
					}
				case DRUGZ_POINT:
					{
						if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
							break;

						ShowPlayerDrugzDialog(playerid);
						return 1;
					}
				case EXIT_POINT:
					{
						// Make the player exit the property interior, which is then destroyed
						SetPlayerPos(playerid, gPropertyCoords[i][j][Secondary][CoordX], gPropertyCoords[i][j][Secondary][CoordY], gPropertyCoords[i][j][Secondary][CoordZ]);

						if (!gProperties[i][CustomInterior])
							DestroyPropertyInterior(playerid);

						gPlayers[playerid][InsideProperty] = false;
						return 1;
					}
				case ENTRANCE_POINT:
					{
						if (!IsPlayerOwner(playerid, gProperties[i][ID]))
							return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Cannot enter the private property!");

						// Spawn the room.
						if (!gProperties[i][CustomInterior])
						{
							SpawnPropertyInterior(playerid, i);
						}
						else 
						{
							SetPlayerPos(playerid, gPropertyCoords[i][j][Secondary][CoordX], gPropertyCoords[i][j][Secondary][CoordY], gPropertyCoords[i][j][Secondary][CoordZ]);
						}

						return 1;
					}
				case OFFER_POINT:
					{
						if (!gProperties[i][Occupied])
						{
							if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
								return 1;

							format(stringToPrint, sizeof(stringToPrint), "Property '%s' for sell.\n\n\tCost: $%d (%.2f mio)\n\n\nProperty code: %d\n\nTo buy this property, enter its code below:", gProperties[i][Label], gProperties[i][Cost], float(gProperties[i][Cost]) / 1000000, gProperties[i][ID]);
							return ShowPlayerDialog(playerid, DIALOG_PROPERTY_BUY, DIALOG_STYLE_INPUT, "Real Estate", stringToPrint, "Buy", "Cancel");
						} 

						if (!IsPlayerOwner(playerid, gProperties[i][ID]))
							return SendClientMessage(playerid, COLOR_RED, "[ REAL ] This property has been already sold.");

						if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
							return 1;

						format(stringToPrint, sizeof(stringToPrint), "Property '%s' is owned by you.\n\nCurrent value: $%d (%.2f mio)\n\n\nProperty code: %d\n\nThe selling fee is set to 10% of the property value.\nEnter its code to sell this property:", gProperties[i][Label], gProperties[i][Cost], float(gProperties[i][Cost]) / 1000000, gProperties[i][ID]);
						return ShowPlayerDialog(playerid, DIALOG_PROPERTY_SELL, DIALOG_STYLE_INPUT, "Real Estate", stringToPrint, "Sell", "Cancel");
					}
			}
		}
	}

	for (new i = 0; i < SPAWN_PICKUP_COUNT; i++)
	{
		if (pickupid != gPlayerInteriors[playerid][Pickups][i])
			continue;

		switch (i) 
		{
			case PICKUP_TYPE_INFO:
				{
					return 1;
				}
			case PICKUP_TYPE_HEALTH:
				{
					SetPlayerHealth(playerid, 100.0);
					SetPlayerArmour(playerid, 100.0);
					SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ HP ] Health: 100.0, Armour: 100.0");
					return 1;
				}
			case PICKUP_TYPE_PILLS:
				{
					if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
						break;

					ShowPlayerDrugzDialog(playerid);
					return 1;
				}
			case PICKUP_TYPE_EXIT:
				{
					new query[256];

					format(query, sizeof(query), "SELECT primary_x,primary_y,primary_z FROM property_coords WHERE property_id = %d AND type = 1", 
							gProperties[ gPlayerInteriors[playerid][PropertyArrayID] ][ID]
					      );

					new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
					if (!result) 
					{
						printf("Database error: cannot fetch spawn point (property ID: %d)!", gProperties[ gPlayerInteriors[playerid][PropertyArrayID] ]);
						print(query);

						return 0;
					}

					new 
						Float: pX = DB_GetFieldFloatByName(result, "primary_x"), 
						Float: pY = DB_GetFieldFloatByName(result, "primary_y"),
						Float: pZ = DB_GetFieldFloatByName(result, "primary_z");

					DB_FreeResultSet(result);

					SetPlayerPos(playerid, pX, pY, pZ);

					DestroyPropertyInterior(playerid);
					gPlayers[playerid][InsideProperty] = false;
				}
		}
	}

	return 1;
}

stock AttachVehicleToProperty(playerid, propertyid)
{
	if (!IsPlayerOwner(playerid, propertyid))
		return SendClientMessage(playerid, COLOR_RED, "[ REAL ] You do not own such property!");

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][ID] != propertyid || !gProperties[i][Occupied])
			continue;

		if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid, COLOR_RED, "[ REAL ] You must be driving/riding a vehicle!");

		new vehicleId = GetPlayerVehicleID(playerid);
		new modelId = GetVehicleModel(vehicleId);

		if (gProperties[i][Vehicle][Model] == modelId)
			return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Such vehicle model has been already attached to such property!");

		gProperties[i][Vehicle][Model] = modelId;

		new colour1, colour2;

		GetVehicleColours(vehicleId, colour1, colour2);

		gProperties[i][Vehicle][Colours][0] = colour1;
		gProperties[i][Vehicle][Colours][1] = colour2;

		for (new j = 0; j < 16; j++)
		{
			gProperties[i][Vehicle][Components][j] = GetVehicleComponentInSlot(vehicleId, t_CARMODTYPE: j);
		}

		if (gProperties[i][Vehicle][ID])
			DestroyVehicle(gProperties[i][Vehicle]);

		gProperties[i][Vehicle][ID] = CreateVehicle(gProperties[i][Vehicle][Model], Float:gProperties[i][LocationVehicle][CoordX], Float:gProperties[i][LocationVehicle][CoordY], Float:gProperties[i][LocationVehicle][CoordZ], Float:gProperties[i][LocationVehicle][CoordR], colour1, colour2, -1);

		for (new j = 0; j < 16; j++)
		{
			if (gProperties[i][Vehicle][Components][j])
				AddVehicleComponent(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Components][j]);
		}

		return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ REAL ] This vehicle has been attached to your property successfully");
	}

	return 1;
}

stock SetSpawnPointAtProperty(playerid, propertyid)
{
	if (!IsPlayerOwner(playerid, propertyid))
		return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Such property must be owned first!");

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][ID] != propertyid || !gProperties[i][Occupied])
			continue;

		gPlayers[playerid][SpawnPoint] = propertyid;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ REAL ] Spawn point changed successfully");

		break;
	}

	return 1;
}

//
//
//

stock ShowPropertyEditDialogMain(playerid)
{
	new propertyid = gPropertyEdit[playerid][ID], stringToPrint[128], title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);
	format(stringToPrint, sizeof(stringToPrint), "Name\nCost in dollars\nEntrance pickup coords\nOffer pickup coords\nVehicle coords\nOccupied state\nSave property");

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_MAIN, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
}

stock ShowPropertyEditDialogName(playerid)
{
	new propertyid = gPropertyEdit[playerid][ID], title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_NAME, DIALOG_STYLE_INPUT, title, "Enter a new property name:", "Enter", "Cancel");
}

stock ShowPropertyEditDialogCost(playerid)
{
	new propertyid = gPropertyEdit[playerid][ID], title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_COST, DIALOG_STYLE_INPUT, title, "Enter a new property cost in dollars:", "Enter", "Cancel");
}

stock ShowPlayerDrugzDialog(playerid)
{
	new stringToPrint[512] = "Substance/stuff\tIn pockets\tAt home";

	for (new i = 0; i < MAX_DRUGS; i++)
	{
		new partial[64], propertyID = gPlayerInteriors[playerid][PropertyArrayID];

		format(partial, sizeof(partial), "\n%s\t%d\t%d", gDrugz[i][DrugName], gPlayers[playerid][Drugs][i], gProperties[propertyID][Drugs][i]);
		strcat(stringToPrint, partial, sizeof(stringToPrint));
	}

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_DRUGZ, DIALOG_STYLE_TABLIST_HEADERS, "Drugz", stringToPrint, "Transfer", "Cancel");
}

