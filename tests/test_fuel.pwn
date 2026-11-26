//
//  test_fuel.pwn
//

// InitGasStations() labels each station on its trucking info pickup, which
// InitTrucking() makes. Without it every station makes a label of its own.
stock LoadTestGasStations()
{
	for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	{
		gTruckingPoints[i][InfoLabel] = INVALID_3DTEXT_ID;
	}

	return InitGasStations();
}

stock UnloadTestGasStations()
{
	for (new i = 0; i < gGasStationCount; i++)
	{
		Delete3DTextLabel(gGasStations[i][Label]);
		gGasStations[i][Label] = INVALID_3DTEXT_ID;
	}

	gGasStationCount = 0;
	gGasStationStockLoaded = false;

	return 1;
}

stock GetSavedGasStationFuel(truckingid)
{
	new
		query[80];

	format(query, sizeof(query), "SELECT fuel FROM gas_stations WHERE trucking_id = %d", truckingid);
	return QueryTestInt(query);
}

Test: GasStationsLoadFromDB()
{
	TEST_START("GasStationsLoadFromDB");

	new
		query[256];

	format(query, sizeof(query), "SELECT COUNT(DISTINCT p.id) FROM trucking_points AS p JOIN trucking_coords AS c ON c.trucking_id = p.id AND c.type = %d WHERE p.type = %d",
			CT_CHECKPOINT, FT_GAS_STATION);

	new
		expected = QueryTestInt(query);

	ASSERT_TRUE(LoadTestGasStations());
	ASSERT_TRUE(gGasStationCount > 0);
	ASSERT_EQ(gGasStationCount, min(expected, MAX_GAS_STATIONS));
	ASSERT_TRUE(gGasStationStockLoaded);

	// Every station got its stock row and a label, and nothing is dirty yet
	new
		mismatched = 0,
		unlabelled = 0,
		dirty = 0;

	for (new i = 0; i < gGasStationCount; i++)
	{
		format(query, sizeof(query), "SELECT COUNT(*) FROM gas_stations WHERE trucking_id = %d AND fuel = %d AND capacity = %d AND price = %d",
				gGasStations[i][TruckingID], gGasStations[i][Fuel], gGasStations[i][Capacity], gGasStations[i][Price]);

		if (QueryTestInt(query) != 1)
		{
			mismatched++;
		}

		if (gGasStations[i][Label] == INVALID_3DTEXT_ID)
		{
			unlabelled++;
		}

		if (gGasStations[i][Dirty])
		{
			dirty++;
		}
	}

	ASSERT_EQ(mismatched, 0);
	ASSERT_EQ(unlabelled, 0);
	ASSERT_EQ(dirty, 0);

	ASSERT_EQ(GetGasStationByTruckingID(gGasStations[0][TruckingID]), 0);
	ASSERT_EQ(GetGasStationByTruckingID(-5), -1);

	UnloadTestGasStations();

	TEST_END("GasStationsLoadFromDB");
}

Test: GasStationRangeAndPumping()
{
	TEST_START("GasStationRangeAndPumping");

	ASSERT_TRUE(LoadTestGasStations());

	if (!gGasStationCount)
	{
		return;
	}

	new
		Float: X = gGasStations[0][Location][CoordX],
		Float: Y = gGasStations[0][Location][CoordY],
		Float: Z = gGasStations[0][Location][CoordZ];

	// At the checkpoint, and nowhere near any station
	ASSERT_EQ(GetGasStationInRange(X, Y, Z), 0);
	ASSERT_EQ(GetGasStationInRange(X, Y, Z + 2.0 * GAS_STATION_RANGE + 1000.0), -1);

	// Topping up stops at the brim
	new
		room = GetGasStationRoom(0);

	ASSERT_TRUE(room > 0);
	ASSERT_EQ(PumpFuelIntoGasStation(0, room + 100), room);
	ASSERT_EQ(gGasStations[0][Fuel], gGasStations[0][Capacity]);
	ASSERT_TRUE(gGasStations[0][Dirty]);
	ASSERT_EQ(PumpFuelIntoGasStation(0, 10), 0);
	ASSERT_EQ(GetGasStationRoom(0), 0);

	UnloadTestGasStations();

	TEST_END("GasStationRangeAndPumping");
}

Test: GasStationStockRoundTrip()
{
	TEST_START("GasStationStockRoundTrip");

	ASSERT_TRUE(LoadTestGasStations());

	if (gGasStationCount < 2)
	{
		ASSERT_TRUE(gGasStationCount >= 2);
		return;
	}

	new
		truckingid = gGasStations[0][TruckingID],
		otherid = gGasStations[1][TruckingID],
		savedFuel = gGasStations[0][Fuel],
		savedCapacity = gGasStations[0][Capacity],
		savedPrice = gGasStations[0][Price],
		otherFuel = gGasStations[1][Fuel],
		query[160];

	// Only the dirty station is written
	gGasStations[0][Fuel] = 1234;
	gGasStations[0][Dirty] = true;
	gGasStations[1][Fuel] = 4321;

	ASSERT_TRUE(SaveGasStationData());
	ASSERT_FALSE(gGasStations[0][Dirty]);
	ASSERT_EQ(GetSavedGasStationFuel(truckingid), 1234);
	ASSERT_EQ(GetSavedGasStationFuel(otherid), otherFuel);

	// And read back
	gGasStations[0][Fuel] = 0;
	ASSERT_TRUE(LoadGasStationStock());
	ASSERT_EQ(gGasStations[0][Fuel], 1234);

	// A broken row cannot zero the capacity or the price (the label and
	// BuyFuel() divide by them) or overfill the tank
	format(query, sizeof(query), "UPDATE gas_stations SET fuel = 99999, capacity = 0, price = 0 WHERE trucking_id = %d", truckingid);
	ExecDBStatement(query);

	ASSERT_TRUE(LoadGasStationStock());
	ASSERT_EQ(gGasStations[0][Capacity], 1);
	ASSERT_EQ(gGasStations[0][Price], 1);
	ASSERT_EQ(gGasStations[0][Fuel], 1);

	format(query, sizeof(query), "UPDATE gas_stations SET fuel = -50, capacity = %d, price = %d WHERE trucking_id = %d", savedCapacity, savedPrice, truckingid);
	ExecDBStatement(query);

	ASSERT_TRUE(LoadGasStationStock());
	ASSERT_EQ(gGasStations[0][Fuel], 0);

	// Put the seeded stock back for whatever runs next
	format(query, sizeof(query), "UPDATE gas_stations SET fuel = %d WHERE trucking_id = %d", savedFuel, truckingid);
	ExecDBStatement(query);

	UnloadTestGasStations();

	TEST_END("GasStationStockRoundTrip");
}
