// 
//  Real Estate stuff.
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	5
#define SPAWN_PICKUP_COUNT	4
#define INVALID_PROPERTY_ID	-1
#define CARMODTYPE_NONE		-1

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
	Label[64],
	Cost,

	LocationOffer[Coords],
	LocationEntrance[Coords],
	LocationVehicle[Coords],

	Vehicle[VehicleProps],

	bool:Occupied,

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
	new fileName[64] = "_data_RealEstateProperties", stringName[20], stringNames[256] = "0";

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

		writecfgvalue(fileName, stringName, "occupied", gProperties[i][Occupied]);

		//
		// Vehicle props.
		//

		new componentsString[128], stringCopy[20];
		strcopy(stringCopy, stringName);
		strcat(stringCopy, "_vehicle");

		writecfgvalue(fileName, stringCopy, "model", gProperties[i][Vehicle][Model]);
		writecfgvalue(fileName, stringCopy, "colour1", gProperties[i][Vehicle][Colours][0]);
		writecfgvalue(fileName, stringCopy, "colour2", gProperties[i][Vehicle][Colours][1]);

		for (new j = 0; j < 16; j++)
		{
			if (!strcmp(componentsString, ""))
			{
				format(componentsString, sizeof(componentsString), "%d", gProperties[i][Vehicle][Components][j]);
				continue;
			}

			format(componentsString, sizeof(componentsString), "%s,%d", componentsString, gProperties[i][Vehicle][Components][j]);
		}

		writecfg(fileName, stringCopy, "components", componentsString);

		//
		// Drugz.
		//

		new label[7] = "_drugz";
		strcopy(stringCopy, stringName);
		strcat(stringCopy, label);

		for (new j = 0; j < MAX_DRUGS; j++)
		{
			writecfgvalue(fileName, stringCopy, gDrugz[j][DrugIniName], gProperties[i][Drugs][j]);
		}
	}

	writecfg(fileName, "", "properties", stringNames);

	return 1;
}

stock ExtractIntsFromString(input[], ints[16])
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

		// VehicleProps
		new componentsString[256], components[16], token1Copy[256];
		strcopy(token1Copy, token1);
		strcat(token1Copy, "_vehicle");

		readcfg(fileName, token1Copy, "components", componentsString);

		ExtractIntsFromString(componentsString, components);
		gProperties[i][Vehicle][Components] = components;

		gProperties[i][Vehicle][Model] = readcfgvalue(fileName, token1Copy, "model");
		gProperties[i][Vehicle][Colours][0] = readcfgvalue(fileName, token1Copy, "colour1"); 
		gProperties[i][Vehicle][Colours][1] = readcfgvalue(fileName, token1Copy, "colour2"); 

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
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Neplatny kod nemovitosti!");

	if (freeSlot < 0)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Jiz vlastnis limitni pocet nemocitosti, je treba nejakou prodat, abys mohl nakoupit novou.");

	if (gProperties[arrayID][Occupied])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Tato nemovitost je jiz obsazena. Neplatna akce!");

	if (!IsPlayerInSphere(playerid, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ], 15))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Je treba byt v okoli puvodniho pickupu (rotujici zeleny domek).");

	if (GetPlayerMoney(playerid) < gProperties[arrayID][Cost])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Na danou transakci nemas dostatek hotovosti!");

	//
	//  Ok, proceed with the transaction.
	//

	gProperties[arrayID][Occupied] = true;
	gPlayers[playerid][Properties][freeSlot] = propertyID;

	DestroyPickup(gProperties[arrayID][Pickups][PICKUP_OFFER]);
	gProperties[arrayID][Pickups][PICKUP_OFFER];

	gProperties[arrayID][Pickups][PICKUP_OFFER] = EnsurePickupCreated(19522, 1, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ]);
	gProperties[arrayID][Pickups][PICKUP_ENTRANCE] = EnsurePickupCreated(1318, 1, Float:gProperties[arrayID][LocationEntrance][CoordX], Float:gProperties[arrayID][LocationEntrance][CoordY], Float:gProperties[arrayID][LocationEntrance][CoordZ]);

	GivePlayerMoney(playerid, -gProperties[arrayID][Cost]);

	return SendClientMessage(playerid, COLOR_SVZEL, "[ REAL ] Nemovitost uspesne zakoupena!");
}

stock SellPlayerProperty(playerid, propertyID)
{
	new arrayID;

	arrayID = GetPropertyArrayIDfromID(propertyID);

	if (arrayID == INVALID_PROPERTY_ID || !propertyID)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Neplatny kod nemovitosti!");

	if (!IsPlayerInSphere(playerid, Float:gProperties[arrayID][LocationOffer][CoordX], Float:gProperties[arrayID][LocationOffer][CoordY], Float:gProperties[arrayID][LocationOffer][CoordZ], 15))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Je treba byt v okoli puvodniho pickupu (nyni rotujici cerveny domek).");

	if (!gProperties[arrayID][Occupied])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Nelze prodat nemovitost, ktera neni prodana/obsazena.");

	if (!IsPlayerOwner(playerid, propertyID))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ REAL ] Dana nemovitost ti nepatri!");

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

	return SendClientMessage(playerid, COLOR_SVZEL, "[ REAL ] Nemovitost byla uspesne prodana!");
}

stock UpdatePropertyVehicle(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid))
		return 0;

	new arrayID, colour1, colour2, bool:modelMatch = false, vehicleID;

	vehicleID = GetPlayerVehicleID(playerid);

	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		new propertyID = gPlayers[playerid][Properties][i];

		if (!propertyID)
			continue;

		arrayID = GetPropertyArrayIDfromID(playerid, propertyID);

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

	GetVehicleColor(GetPlayerVehicleID(playerid), colour1, colour2);

	gProperties[arrayID][Vehicle][Colours][0] = colour1;
	gProperties[arrayID][Vehicle][Colours][1] = colour2;

	for (new i = 0; i < 16; i++)
	{
		gProperties[arrayID][Vehicle][Components][i] = GetVehicleComponentInSlot(vehicleID, i);
	}

	SendClientMessage(playerid, COLOR_SVZEL, "[ REAL ] Modifikace auta ulozeny k zaparkovanemu autu.");

	return 1;
}

