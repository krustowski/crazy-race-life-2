#if defined _CRL2_FUEL
	#endinput
#endif
#define _CRL2_FUEL

//
//  fuel.pwn
//  Petrol stations: NPC tankers top their tanks up, players buy fuel from them.
//  A prototype for vehicles having to refuel, nothing consumes fuel yet.
//

// Prints why a truck NPC does or does not pump into a station, every second.
#define FUEL_DEBUG				false

#define MAX_GAS_STATIONS		32

// How close to a station's delivery checkpoint or info pickup a tanker or a
// buyer has to be.
#define GAS_STATION_RANGE		60.0

// Seeds a station that has no gas_stations row yet (see InitGasStations()).
#define GAS_STATION_DEFAULT_CAPACITY	10000
#define GAS_STATION_DEFAULT_PRICE		5

// A tanker standing still at a station pumps base + up to volatile litres
// per second, so a 30s stop (TRUCK_UNLOAD_MS) delivers about 2400 L.
#define TANKER_PUMP_RATE_BASE		40
#define TANKER_PUMP_RATE_VOLATILE	80

// A truck that moved less than this since the last tick counts as standing.
#define TANKER_STILL_DISTANCE		1.0

// One /fuel sells this much, until vehicles track a fuel level of their own.
#define FUEL_FILL_UP_LITRES			60

enum GasStation
{
	// trucking_points.id
	TruckingID,
	Name[64],
	Location[Coords],

	// The info pickup; the checkpoint again when the station has none
	InfoLocation[Coords],

	// Litres
	Fuel,
	Capacity,

	// Per litre
	Price,

	// The stock changed since the last save
	bool: Dirty,

	Text3D: Label
}

new
	gGasStations[MAX_GAS_STATIONS][GasStation],
	gGasStationCount = 0,
	Float: gTankerLastPos[MAX_TRUCK_DRIVERS][3],

	// The gas_stations table could be read, so the stock can be saved to it
	bool: gGasStationStockLoaded = false;

forward UpdateGasStations();
forward bool: IsTankerHitchedToTruck(vehicleid);

// The 1s tick: every truck NPC standing still at a station with its tanker
// hitched pumps a random amount into the station's tank.
public UpdateGasStations()
{
	for (new i = 0; i < MAX_TRUCK_DRIVERS; i++)
	{
		new
			npcid = gTruckDriverNPC[i];

		if (!NPC_IsValid(npcid))
		{
			continue;
		}

		new
			Float: X,
			Float: Y,
			Float: Z;

		NPC_GetPos(npcid, X, Y, Z);

		new
			Float: moved = VectorSize(X - gTankerLastPos[i][0], Y - gTankerLastPos[i][1], Z - gTankerLastPos[i][2]);

		gTankerLastPos[i][0] = X;
		gTankerLastPos[i][1] = Y;
		gTankerLastPos[i][2] = Z;

		new
			stationid = GetGasStationInRange(X, Y, Z),
			bool: hasTanker = IsTankerHitchedToTruck(gTruckVehicle[i]);

#if FUEL_DEBUG
		printf("[fuel] truck %d station=%d moved=%.2f tanker=%d", i, stationid, moved, _: hasTanker);
#endif

		if (stationid == -1 || moved > TANKER_STILL_DISTANCE || !hasTanker)
		{
			continue;
		}

		PumpFuelIntoGasStation(stationid, TANKER_PUMP_RATE_BASE + random(TANKER_PUMP_RATE_VOLATILE + 1));
	}

	return 1;
}

stock bool: IsTankerHitchedToTruck(vehicleid)
{
	return (IsTrailerAttachedToVehicle(vehicleid) && GetVehicleModel(GetVehicleTrailer(vehicleid)) == PETROL_VEHICLE_ID);
}

// Returns the nearest station within GAS_STATION_RANGE of its checkpoint or
// its info pickup, or -1.
stock GetGasStationInRange(Float: X, Float: Y, Float: Z)
{
	new
		stationid = -1,
		Float: nearest = GAS_STATION_RANGE;

	for (new i = 0; i < gGasStationCount; i++)
	{
		new
			Float: distance = VectorSize(
				X - gGasStations[i][Location][CoordX],
				Y - gGasStations[i][Location][CoordY],
				Z - gGasStations[i][Location][CoordZ]
			),
			Float: infoDistance = VectorSize(
				X - gGasStations[i][InfoLocation][CoordX],
				Y - gGasStations[i][InfoLocation][CoordY],
				Z - gGasStations[i][InfoLocation][CoordZ]
			);

		if (infoDistance < distance)
		{
			distance = infoDistance;
		}

		if (distance <= nearest)
		{
			stationid = i;
			nearest = distance;
		}
	}

	return stationid;
}

// Litres the station's tank can still take.
stock GetGasStationRoom(stationid)
{
	return gGasStations[stationid][Capacity] - gGasStations[stationid][Fuel];
}

stock PumpFuelIntoGasStation(stationid, litres)
{
	litres = min(litres, GetGasStationRoom(stationid));

	if (litres <= 0)
	{
		return 0;
	}

	gGasStations[stationid][Fuel] += litres;
	gGasStations[stationid][Dirty] = true;

	UpdateGasStationLabel(stationid);

	return litres;
}

// The info pickup's name label, with the tank and the price added under it.
stock UpdateGasStationLabel(stationid)
{
	new
		fuel = gGasStations[stationid][Fuel],
		capacity = gGasStations[stationid][Capacity],
		labelText[192];

	format(labelText, sizeof(labelText), "%s\n{FFFFFF}Tank: %d / %d L (%d%%)\n$%d / L  {FFD700}/fuel",
			gGasStations[stationid][Name],
			fuel,
			capacity,
			fuel * 100 / capacity,
			gGasStations[stationid][Price]
		);

	// Through "%s": the text holds a literal % now
	return Update3DTextLabelText(gGasStations[stationid][Label], COLOR_ORANGE, "%s", labelText);
}

// Sells a fill-up from the station's stock, or as much of one as the
// station has and the player can pay for.
stock BuyFuel(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessageLocalized(playerid, I18N_FUEL_NOT_DRIVER);
	}

	new
		Float: X,
		Float: Y,
		Float: Z;

	GetPlayerPos(playerid, X, Y, Z);

	new
		stationid = GetGasStationInRange(X, Y, Z);

	if (stationid == -1)
	{
		return SendClientMessageLocalized(playerid, I18N_FUEL_NO_STATION);
	}

	new
		price = gGasStations[stationid][Price],
		litres = min(FUEL_FILL_UP_LITRES, gGasStations[stationid][Fuel]),
		stringToPrint[128];

	if (litres <= 0)
	{
		GetLocalizedString(playerid, I18N_FUEL_STATION_EMPTY_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gGasStations[stationid][Name]);

		return SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}

	litres = min(litres, GetPlayerMoney(playerid) / price);

	if (litres <= 0)
	{
		GetLocalizedString(playerid, I18N_FUEL_NO_MONEY_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, price);

		return SendClientMessage(playerid, COLOR_RED, stringToPrint);
	}

	new
		cost = litres * price;

	GivePlayerMoney(playerid, -cost);

	gGasStations[stationid][Fuel] -= litres;
	gGasStations[stationid][Dirty] = true;

	UpdateGasStationLabel(stationid);

	GetLocalizedString(playerid, I18N_FUEL_BOUGHT_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, litres, gGasStations[stationid][Name], cost);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	// Counts litres: any purchase completes a target of 1
	FireQuestEvent(playerid, QUEST_EVT_FUEL_BOUGHT, litres);

	return 1;
}

// Every GAS_STATION trucking point is a petrol station, at its delivery
// checkpoint, with its tank shown on its info pickup's label. The stations
// come from the trucking tables alone, so they work even when their stock
// cannot be read (see LoadGasStationStock()).
stock InitGasStations()
{
	new
		query[640];

	format(query, sizeof(query), "SELECT p.id, p.name, c.x, c.y, c.z, IFNULL(i.x, c.x) AS info_x, IFNULL(i.y, c.y) AS info_y, IFNULL(i.z, c.z) AS info_z FROM trucking_points AS p JOIN trucking_coords AS c ON c.trucking_id = p.id AND c.type = %d LEFT JOIN trucking_coords AS i ON i.trucking_id = p.id AND i.type = %d WHERE p.type = %d GROUP BY p.id ORDER BY p.id",
			CT_CHECKPOINT,
			CT_INFO_PICKUP,
			FT_GAS_STATION
		);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		print("Database error: cannot read gas stations data");
		print(query);

		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		print("Database warning: no gas stations to load");

		DB_FreeResultSet(result);
		return 0;
	}

	gGasStationCount = 0;

	do
	{
		if (gGasStationCount >= MAX_GAS_STATIONS)
		{
			print("Gas stations: MAX_GAS_STATIONS reached, the rest is not loaded");
			break;
		}

		new
			i = gGasStationCount,
			name[64];

		DB_GetFieldStringByName(result, "name", name, sizeof(name));

		gGasStations[i][TruckingID] = DB_GetFieldIntByName(result, "id");
		gGasStations[i][Name] = name;

		gGasStations[i][Location][CoordX] = DB_GetFieldFloatByName(result, "x");
		gGasStations[i][Location][CoordY] = DB_GetFieldFloatByName(result, "y");
		gGasStations[i][Location][CoordZ] = DB_GetFieldFloatByName(result, "z");

		gGasStations[i][InfoLocation][CoordX] = DB_GetFieldFloatByName(result, "info_x");
		gGasStations[i][InfoLocation][CoordY] = DB_GetFieldFloatByName(result, "info_y");
		gGasStations[i][InfoLocation][CoordZ] = DB_GetFieldFloatByName(result, "info_z");

		gGasStations[i][Fuel] = GAS_STATION_DEFAULT_CAPACITY / 2;
		gGasStations[i][Capacity] = GAS_STATION_DEFAULT_CAPACITY;
		gGasStations[i][Price] = GAS_STATION_DEFAULT_PRICE;
		gGasStations[i][Dirty] = false;

		gGasStationCount++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	LoadGasStationStock();

	for (new i = 0; i < gGasStationCount; i++)
	{
		// InitTrucking() made the info pickup's name label. A station without
		// an info pickup gets a label of its own at the checkpoint instead.
		new
			Text3D: label = gTruckingPoints[gGasStations[i][TruckingID]][InfoLabel];

		if (label == INVALID_3DTEXT_ID)
		{
			label = Create3DTextLabel("%s", COLOR_ORANGE,
					gGasStations[i][Location][CoordX],
					gGasStations[i][Location][CoordY],
					gGasStations[i][Location][CoordZ],
					15.0, -1, false, gGasStations[i][Name]
				);
		}

		gGasStations[i][Label] = label;

		UpdateGasStationLabel(i);
	}

	printf("Gas stations initialized: %d", gGasStationCount);

	return 1;
}

// Fills the stations' stock in from gas_stations. A station without a row
// there (e.g. made with the trucking editor) keeps the defaults, half full,
// and gets its row on the first save after its stock changes. Without the
// table itself, the stations run on the defaults and nothing is saved.
stock LoadGasStationStock()
{
	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT trucking_id, fuel, capacity, price FROM gas_stations");

	if (!result)
	{
		print("Database error: cannot read gas_stations (is migration 000018 applied to this database?), the stations run on defaults and their stock is not saved");

		return 0;
	}

	gGasStationStockLoaded = true;

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		return 1;
	}

	do
	{
		new
			stationid = GetGasStationByTruckingID(DB_GetFieldIntByName(result, "trucking_id"));

		if (stationid == -1)
		{
			continue;
		}

		// The label divides by the capacity, BuyFuel() by the price
		gGasStations[stationid][Capacity] = max(DB_GetFieldIntByName(result, "capacity"), 1);
		gGasStations[stationid][Fuel] = clamp(DB_GetFieldIntByName(result, "fuel"), 0, gGasStations[stationid][Capacity]);
		gGasStations[stationid][Price] = max(DB_GetFieldIntByName(result, "price"), 1);
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	return 1;
}

stock GetGasStationByTruckingID(truckingid)
{
	for (new i = 0; i < gGasStationCount; i++)
	{
		if (gGasStations[i][TruckingID] == truckingid)
		{
			return i;
		}
	}

	return -1;
}

stock SaveGasStationData()
{
	// Nowhere to save to, see LoadGasStationStock()
	if (!gGasStationStockLoaded)
	{
		return 0;
	}

	new
		query[256],
		bool: ownTransaction = BeginDBTransaction(),
		bool: saved[MAX_GAS_STATIONS];

	for (new i = 0; i < gGasStationCount; i++)
	{
		if (!gGasStations[i][Dirty])
		{
			continue;
		}

		format(query, sizeof(query), "INSERT INTO gas_stations (trucking_id, fuel, capacity, price) VALUES (%d, %d, %d, %d) ON CONFLICT(trucking_id) DO UPDATE SET fuel = excluded.fuel",
				gGasStations[i][TruckingID],
				gGasStations[i][Fuel],
				gGasStations[i][Capacity],
				gGasStations[i][Price]
			);

		new
			DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

		if (!result)
		{
			printf("Database error: cannot write gas station data (trucking ID: %d)!", gGasStations[i][TruckingID]);
			print(query);

			continue;
		}

		DB_FreeResultSet(result);

		gGasStations[i][Dirty] = false;
		saved[i] = true;
	}

	// Inside a transaction a row is only on disk once the commit goes through,
	// so a failed commit leaves the stations dirty for the next save.
	if (ownTransaction && !CommitDBTransaction())
	{
		print("Database error: gas station save was not committed, it will be retried on the next save!");

		for (new i = 0; i < gGasStationCount; i++)
		{
			if (saved[i])
			{
				gGasStations[i][Dirty] = true;
			}
		}
	}

	return 1;
}
