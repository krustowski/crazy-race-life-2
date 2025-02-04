// 
//  Real Estate stuff.
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	5
#define SPAWN_PICKUP_COUNT	4

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

enum Property
{
	ID,
	Label[64],
	Cost,

	LocationOffer[Coords],
	LocationEntrance[Coords],
	LocationVehicle[Coords],

	VehicleID,
	Vehicle,

	bool:Occupied,

	Objects[5],
	Menu[5],
	Pickups[6]
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

//
//
//

new gPropertySF0101[Property] =
{
	10101,
	"SF The Very First House for Sell",
	1500000,
	{-2685.81, 201.33, 4.33, 0.0},
	{-2688.66, 198.50, 7.15, 0.0},
	{-2691.9761, 204.5431, 3.9995, 0.1673},
	560,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},

// El Quebrados
gPropertyDE0101[Property] = 
{
	20101,
	"El Quebrados prop no. 1",
	750000,
	{-1469.00, 2686.69, 55.83, 0.0},
	{-1466.22, 2693.31, 56.26, 0.0},
	{-1470.55, 2692.82, 55.83, 179.92},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0102[Property] = 
{
	20102,
	"El Quebrados prop no. 2",
	650000,
	{-1482.20, 2698.43, 55.83, 0.0},
	{-1482.59, 2702.20, 56.25, 0.0},
	{-1486.32, 2697.17, 55.83, 183.70},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0103[Property] = 
{
	20103,
	"El Quebrados prop no. 3",
	600000,
	{-1491.39, 2685.03, 55.85, 0.0},
	{-1491.39, 2685.03, 55.85, 0.0},
	{-1502.57, 2689.98, 55.83, 179.70},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0104[Property] = 
{
	20104,
	"El Quebrados prop no. 4",
	600000,
	{-1554.95, 2692.75, 55.84, 0.0},
	{-1550.51, 2699.88, 56.26, 0.0},
	{-1555.55, 2700.95, 55.83, 175.10},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0105[Property] = 
{
	20105,
	"El Quebrados prop no. 5",
	750000,
	{-1600.46, 2679.16, 55.10, 0.0},
	{-1603.47, 2689.46, 55.28, 0.0},
	{-1597.83, 2696.68, 55.07, 180.89},
	560,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	// Trailer park btw LS/SF
	gPropertyOT0101[Property] = 
{
	50101,
	"Trailer park no. 1",
	900000,
	{755.21, 378.67, 23.17, 0.0},
	{758.40, 375.05, 23.19, 0.0},
	{745.17, 374.02, 23.21, 20.16},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0102[Property] = 
{
	50102,
	"Trailer park no. 2",
	900000,
	{800.38, 360.85, 19.39, 0.0},
	{804.85, 359.52, 19.76, 0.0},
	{509.70, 363.27, 19.34, 90.41},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0103[Property] = 
{
	501003,
	"Trailer park no. 3",
	900000,
	{767.57, 346.78, 19.99, 0.0},
	{771.79, 347.46, 20.15, 0.0},
	{778.72, 351.01, 19.63, 14.67},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0104[Property] = 
{
	50104,
	"Trailer park no. 4",
	900000,
	{751.35, 270.73, 27.12, 0.0},
	{748.03, 277.72, 27.22, 0.0},
	{754.29, 278.50, 27.51, 191.54},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0105[Property] = 
{
	50105,
	"El Quebrados prop no. 5",
	900000,
	{752.73, 261.89, 27.08, 0.0},
	{748.40, 257.87, 27.08, 0.0},
	{739.71, 250.67, 27.21, 15.21},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	// LS
	gPropertyLS0101[Property] = 
{
	40101,
	"LS Vinewood Ville",
	2000000,
	{},
	{},
	{0.0, 0.0, 0.0, 0.0},
	0,
	INVALID_VEHICLE_ID,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
};

//

new gProperties[MAX_PROPERTIES][Property];

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

		if (gProperties[i][VehicleID] && gProperties[i][VehicleID] >= 400 && gProperties[i][VehicleID] <= 611)
		{
			gProperties[i][Vehicle] = CreateVehicle(gProperties[i][VehicleID], Float:gProperties[i][LocationVehicle][CoordX], Float:gProperties[i][LocationVehicle][CoordY], Float:gProperties[i][LocationVehicle][CoordZ], Float:gProperties[i][LocationVehicle][CoordR], 0, 0, -1);
		}
	}

	return 1;
}

public IsPlayerOwner(playerid, propertyId)
{
	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (gPlayers[playerid][Properties][i] == propertyId)
			return true;
	}

	return false;
}

public SaveRealEstateData()
{
	new fileName[64] = "_data_RealEstateProperties", stringName[8], stringNames[256] = "0";

	writecfg(fileName, "", "properties", "xxx");

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (!gProperties[i][ID])
			continue;

		format(stringName, sizeof(stringName), "%d", gProperties[i][ID]);
		format(stringNames, sizeof(stringNames), "%s,%d", stringNames, gProperties[i][ID]);

		writecfgvalue(fileName, stringName, "id", gProperties[i][ID]);
		writecfg(fileName, stringName, "label", gProperties[i][Label]);
		writecfgvalue(fileName, stringName, "cost", gProperties[i][Cost]);

		new coordStringOffer[256], coordStringEntrance[256], coordStringVehicle[256];
		new locationOffer = gProperties[i][LocationOffer];

		for (new j = 0; j < 4; j++)
		{
			if (!strcmp(coordStringOffer, ""))
			{
				format(coordStringOffer, sizeof(coordStringOffer), "%.2f", gProperties[i][LocationOffer][j]);
				format(coordStringEntrance, sizeof(coordStringEntrance), "%.2f", gProperties[i][LocationEntrance][j]);
				format(coordStringVehicle, sizeof(coordStringVehicle), "%.2f", gProperties[i][LocationVehicle][j]);
				continue;
			}

			format(coordStringOffer, sizeof(coordStringOffer), "%s,%.2f", coordStringOffer, gProperties[i][LocationOffer][j]);
			format(coordStringEntrance, sizeof(coordStringEntrance), "%s,%.2f", coordStringEntrance, gProperties[i][LocationEntrance][j]);
			format(coordStringVehicle, sizeof(coordStringVehicle), "%s,%.2f", coordStringVehicle, gProperties[i][LocationVehicle][j]);
		}

		writecfg(fileName, stringName, "locationOffer", coordStringOffer);
		writecfg(fileName, stringName, "locationEntrance", coordStringEntrance);
		writecfg(fileName, stringName, "locationVehicle", coordStringVehicle);

		writecfgvalue(fileName, stringName, "vehicleID", gProperties[i][VehicleID]);
		writecfgvalue(fileName, stringName, "occupied", gProperties[i][Occupied]);
	}

	writecfg(fileName, "", "properties", stringNames);

	return 1;
}

public LoadRealEstateData()
{
	new fileName[64] = "_data_RealEstateProperties", i = 0, properties[256], token1[256], token2[256];

	readcfg(fileName, "", "properties", properties); 

	do {
		SplitIntoTwo(properties, token1, token2, sizeof(token1), ",");

		if (!IsNumeric(token1) || !strval(token1))
		{
			strcopy(properties, token2);
			continue;
		}

		printf("LoadRealEstateData: loading %s", token1);

		//
		//  Extract the values (ints and strings).
		//

		gProperties[i][ID] = readcfgvalue(fileName, token1, "id");
		gProperties[i][Cost] = readcfgvalue(fileName, token1, "cost");
		gProperties[i][VehicleID] = readcfgvalue(fileName, token1, "vehicleID");
		gProperties[i][Occupied] = readcfgvalue(fileName, token1, "occupied");

		readcfg(fileName, token1, "label", gProperties[i][Label]); 

		//
		//  Extract the floats.
		//

		new 
			locationOffer[Coords], locationOfferString[64], 
			locationEntrance[Coords], locationEntranceString[64], 
			locationVehicle[Coords], locationVehicleString[64];

		readcfg(fileName, token1, "locationOffer", locationOfferString); 
		readcfg(fileName, token1, "locationEntrance", locationEntranceString); 
		readcfg(fileName, token1, "locationVehicle", locationVehicleString); 

		ExtractCoordsFromString(locationOfferString, locationOffer);
		ExtractCoordsFromString(locationEntranceString, locationEntrance);
		ExtractCoordsFromString(locationVehicleString, locationVehicle);

		gProperties[i][LocationOffer] = locationOffer;
		gProperties[i][LocationEntrance] = locationEntrance;
		gProperties[i][LocationVehicle] = locationVehicle;

		// Prepare vars for the next run.
		strcopy(properties, token2);
		i++;

		if (i > MAX_PROPERTIES)
			break;
	} while (strcmp(token2, ""));

	return 1;
}

stock ExtractCoordsFromString(input[], coords[Coords])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		coords[i] = floatstr(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return coords;
}

stock SpawnPropertyInterior(playerid, arrayID)
{
	gPlayerInteriors[playerid][PropertyArrayID] = arrayID;

	new i = 0, Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);

	Z += 1500;

	// The very room object.
	gPlayerInteriors[playerid][Objects][0] = CreatePlayerObject(playerid, 14859, Float:X, Float:Y, Float:Z, 0.0, 0.0, 0.0, 0,0);

	// Exit, Health, Pills, Info pickups.
	new pickupIds[4] = {1239, 1240, 1241, 1318};
	new pickupCoords[4][3];

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
		gPlayerInteriors[playerid][Pickups][i] = EnsurePickupCreated(pickupIds[i], 1, Float:pickupCoords[i][0], Float:pickupCoords[i][1], Float:pickupCoords[i][2], -1);

		if (!gPlayerInteriors[playerid][Pickups][i] || gPlayerInteriors[playerid][Pickups][i] == -1)
		{
			printf("SpawnPropertyInterior: pickup creation error: pickup no. %d, value: %d", i, gPlayerInteriors[playerid][Pickups][i]);
			SendClientMessage(playerid, COLOR_CERVENA, "[ ERROR ] Nebylo mozne vygenerovat vsechny pickupy v dome!");
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

		SetPlayerPos(playerid, Float:gProperties[i][LocationOffer][0], FLoat:gProperties[i][LocationOffer][1], Float:gProperties[i][LocationOffer][2]);

		return 1;
	}

	return 0;
}

stock BuyPlayerProperty(playerid, propertyID)
{
	new freeSlot = -1, success = false;

	// Check if there is a free slot for such player.
	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (!gPlayers[playerid][Properties][i])
		{
			freeSlot = i;
			break;
		}
	}

	if (freeSlot < 0)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Jiz vlastnis limitni pocet nemocitosti, je treba nejakou prodat, abys mohl nakoupit novou.");

	for (new j = 0; j < sizeof(gProperties); j++)
	{
		if (!gProperties[j][Occupied] && gProperties[j][ID] == propertyID)
		{
			if (!IsPlayerInSphere(playerid, Float:gProperties[j][LocationOffer][CoordX], Float:gProperties[j][LocationOffer][CoordY], Float:gProperties[j][LocationOffer][CoordZ], 15))
				return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Je treba byt v okoli puvodniho pickupu (rotujici zeleny domek).");

			if (GetPlayerMoney(playerid) < gProperties[j][Cost])
				return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Na danou transakci nemas dostatek hotovosti!");

			gProperties[j][Occupied] = true;
			gPlayers[playerid][Properties][freeSlot] = propertyID;

			DestroyPickup(gProperties[j][Pickups][PICKUP_OFFER]);
			gProperties[j][Pickups][PICKUP_OFFER];

			gProperties[j][Pickups][PICKUP_OFFER] = EnsurePickupCreated(19522, 1, Float:gProperties[j][LocationOffer][CoordX], Float:gProperties[j][LocationOffer][CoordY], Float:gProperties[j][LocationOffer][CoordZ]);
			gProperties[j][Pickups][PICKUP_ENTRANCE] = EnsurePickupCreated(1318, 1, Float:gProperties[j][LocationEntrance][CoordX], Float:gProperties[j][LocationEntrance][CoordY], Float:gProperties[j][LocationEntrance][CoordZ]);

			GivePlayerMoney(playerid, -gProperties[j][Cost]);
			success = true;

			break;
		}
	}

	if (!success) 
		return SendClientMessage(playerid, COLOR_CERVENA, "{ REAL } Transakce se nezdarila, zkus znovu pozdeji.");

	return SendClientMessage(playerid, COLOR_SVZEL, "[ REAL ] Nemovitost uspesne zakoupena!");
}

stock SellPlayerProperty(playerid, propertyID)
{
	new success = false;

	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][ID] != propertyID)
			continue;

		if (!IsPlayerInSphere(playerid, Float:gProperties[i][LocationOffer][CoordX], Float:gProperties[i][LocationOffer][CoordY], Float:gProperties[i][LocationOffer][CoordZ], 15))
			return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Je treba byt v okoli puvodniho pickupu (nyni rotujici cerveny domek).");

		if (!gProperties[i][Occupied])
			return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Nelze prodat nemovitost, ktera neni prodana/obsazena.");

		if (!IsPlayerOwner(playerid, propertyID))
			return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Dana nemovitost ti nepatri!");

		//
		//  Ok, sell the property.
		//

		if (gPlayers[playerid][SpawnPoint] == propertyID)
			gPlayers[playerid][SpawnPoint] = 0;

		for (new j = 0; j < MAX_PLAYER_PROPERTIES; j++)
		{
			if (gPlayers[playerid][Properties][j] == propertyID)
			{
				gPlayers[playerid][Properties][j] = 0;
				break;
			}
		}

		gProperties[i][Occupied] = false;

		DestroyPickup(gProperties[i][Pickups][PICKUP_OFFER]);
		gProperties[i][Pickups][PICKUP_OFFER];

		DestroyPickup(gProperties[i][Pickups][PICKUP_ENTRANCE]);
		gProperties[i][Pickups][PICKUP_ENTRANCE];

		gProperties[i][Pickups][PICKUP_OFFER] = EnsurePickupCreated(1273, 1, Float:gProperties[i][LocationOffer][CoordX], Float:gProperties[i][LocationOffer][CoordY], Float:gProperties[i][LocationOffer][CoordZ]);

		GivePlayerMoney(playerid, floatround(float(gProperties[i][Cost]) * 0.9));

		success = true;
		break;
	}

	if (!success)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Transkace se nezdarila, zkus znovu pozdeji.");

	return SendClientMessage(playerid, COLOR_SVZEL, "[ REAL ] Nemovitost byla uspesne prodana!");
}
