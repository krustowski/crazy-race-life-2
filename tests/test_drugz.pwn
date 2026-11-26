//
//  test_drugz.pwn
//

#define MAX_RATIO_VALUES 	2048

Test: BlackMarketRatioTrend()
{
	TEST_START("BlackMarketRatioTrend");

	new
		File: handle = fopen("ratio_trend.txt", io_write),
		stringToWrite[32];

	ASSERT_TRUE(handle);

	if (!handle)
	{
		return;
	}

	for (new i = 0; i < MAX_RATIO_VALUES; i++)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");
		
		format(stringToWrite, sizeof(stringToWrite), "%d %.3f\n", i, gBlackMarketRatio);
		fwrite(handle, stringToWrite);
	}

	fclose(handle);

	TEST_END("BlackMarketRatioTrend");
}


// Pins today's boom schedule, so only the test itself starts a boom
stock FreezeMarketBoomSchedule()
{
	gMarketBoomDay = getdate();
	gMarketBoomAt = -1;
	gMarketBoomPhase = BOOM_NONE;
	gMarketBoomTicks = 0;
}

Test: BlackMarketRatioBounds()
{
	TEST_START("BlackMarketRatioBounds");

	FreezeMarketBoomSchedule();
	gBlackMarketRatio = MARKET_RATIO_EQULIBRIUM;

	new
		outOfBounds = 0,
		Float: lowest = MARKET_RATIO_MAX,
		Float: highest = MARKET_RATIO_MIN;

	for (new i = 0; i < MAX_RATIO_VALUES; i++)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");

		if (gBlackMarketRatio < MARKET_RATIO_MIN || gBlackMarketRatio > MARKET_RATIO_MAX)
		{
			outOfBounds++;
		}

		if (gBlackMarketRatio < lowest)
		{
			lowest = gBlackMarketRatio;
		}

		if (gBlackMarketRatio > highest)
		{
			highest = gBlackMarketRatio;
		}
	}

	printf("[INFO] Ratio over %d ticks: %.3f .. %.3f", MAX_RATIO_VALUES, lowest, highest);

	ASSERT_EQ(outOfBounds, 0);

	// It swings both ways off equilibrium
	ASSERT_TRUE(highest > 2.0);
	ASSERT_TRUE(lowest < 0.5);

	TEST_END("BlackMarketRatioBounds");
}

Test: BlackMarketRatioBoom()
{
	TEST_START("BlackMarketRatioBoom");

	FreezeMarketBoomSchedule();
	gBlackMarketRatio = MARKET_RATIO_MIN;
	gMarketBoomPhase = BOOM_RISING;

	new
		ticks = 0;

	while (gMarketBoomPhase == BOOM_RISING && ticks <= MARKET_BOOM_MAX_TICKS)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");
		ticks++;
	}

	// Even from the very bottom it peaks, at exactly the max
	ASSERT_TRUE(gMarketBoomPhase == BOOM_PEAK);
	ASSERT_TRUE(ticks <= MARKET_BOOM_MAX_TICKS);
	ASSERT_TRUE(gBlackMarketRatio == MARKET_RATIO_MAX);

	// It holds there...
	for (new i = 0; i < MARKET_BOOM_HOLD_TICKS; i++)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");
		ASSERT_TRUE(gBlackMarketRatio == MARKET_RATIO_MAX);
	}

	ASSERT_TRUE(gMarketBoomPhase == BOOM_NONE);

	// ...and then reverts
	for (new i = 0; i < 10; i++)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");
	}

	ASSERT_TRUE(gBlackMarketRatio < MARKET_RATIO_MAX);

	TEST_END("BlackMarketRatioBoom");
}

Test: BlackMarketRatioBoomUnderSales()
{
	TEST_START("BlackMarketRatioBoomUnderSales");

	FreezeMarketBoomSchedule();
	gBlackMarketRatio = MARKET_RATIO_EQULIBRIUM;
	gMarketBoomPhase = BOOM_RISING;

	new
		ticks = 0;

	// Fence sales pushing harder than the boom climbs
	while (gMarketBoomPhase == BOOM_RISING && ticks <= MARKET_BOOM_MAX_TICKS)
	{
		PushBlackMarketRatioDown(200000);
		CallRemoteFunction("UpdateBlackMarketRatio");
		ticks++;
	}

	ASSERT_EQ(ticks, MARKET_BOOM_MAX_TICKS);
	ASSERT_TRUE(gMarketBoomPhase == BOOM_PEAK);
	ASSERT_TRUE(gBlackMarketRatio == MARKET_RATIO_MAX);

	FreezeMarketBoomSchedule();

	TEST_END("BlackMarketRatioBoomUnderSales");
}

Test: MarketBoomSchedule()
{
	TEST_START("MarketBoomSchedule");

	// The test macros cut arguments at the first ")", so no parenthesised macros in them
	new
		latest = MARKET_BOOM_LATEST_S,
		outOfRange = 0;

	ASSERT_EQ(PickMarketBoomTime(latest), -1);
	ASSERT_EQ(PickMarketBoomTime(latest + 60), -1);
	ASSERT_EQ(PickMarketBoomTime(latest - 1), latest - 1);

	for (new i = 0; i < 256; i++)
	{
		new
			at = PickMarketBoomTime(0);

		if (at < 0 || at >= latest)
		{
			outOfRange++;
		}
	}

	ASSERT_EQ(outOfRange, 0);

	// A boom whose time has come starts
	FreezeMarketBoomSchedule();
	gMarketBoomAt = 0;
	UpdateMarketBoomSchedule();

	ASSERT_TRUE(gMarketBoomPhase == BOOM_RISING);
	ASSERT_EQ(gMarketBoomAt, -1);

	// A new day gets a schedule of its own
	FreezeMarketBoomSchedule();
	gMarketBoomDay = getdate() - 1;
	UpdateMarketBoomSchedule();

	ASSERT_EQ(gMarketBoomDay, getdate());

	FreezeMarketBoomSchedule();

	TEST_END("MarketBoomSchedule");
}

Test: FenceSalePushesRatioDown()
{
	TEST_START("FenceSalePushesRatioDown");

	// $10000 of list-price value: 10^-0.05 of the ratio
	gBlackMarketRatio = 10.0;
	PushBlackMarketRatioDown(10000);
	ASSERT_FLOAT_EQ_EPS(gBlackMarketRatio, 8.9125, 0.001);

	gBlackMarketRatio = 3.0;
	PushBlackMarketRatioDown(0);
	ASSERT_FLOAT_EQ_EPS(gBlackMarketRatio, 3.0, 0.001);

	gBlackMarketRatio = MARKET_RATIO_MIN;
	PushBlackMarketRatioDown(1000000);
	ASSERT_TRUE(gBlackMarketRatio == MARKET_RATIO_MIN);

	gBlackMarketRatio = MARKET_RATIO_EQULIBRIUM;

	TEST_END("FenceSalePushesRatioDown");
}

Test: FencePricing()
{
	TEST_START("FencePricing");

	new
		price = gDrugz[FENT][DrugPrice];

	gDrugz[FENT][DrugPrice] = 400;

	gBlackMarketRatio = 1.0;
	ASSERT_FLOAT_EQ_EPS(GetFenceUnitPrice(FENT), 240.0, 0.001);

	gBlackMarketRatio = MARKET_RATIO_MAX;
	ASSERT_FLOAT_EQ_EPS(GetFenceUnitPrice(FENT), 24000.0, 0.01);

	// Low prices hit the unit limit, high ones the dollar limit
	ASSERT_EQ(GetFenceSellableUnits(100, 500, 100000, 240.0), 100);
	ASSERT_EQ(GetFenceSellableUnits(1000, 500, 100000, 30.0), 500);
	ASSERT_EQ(GetFenceSellableUnits(1000, 500, 100000, 240.0), 416);
	ASSERT_EQ(GetFenceSellableUnits(1000, 500, 100000, 24000.0), 4);
	ASSERT_EQ(GetFenceSellableUnits(10, 0, 100000, 240.0), 0);
	ASSERT_EQ(GetFenceSellableUnits(10, 500, 100, 240.0), 0);
	ASSERT_EQ(GetFenceSellableUnits(10, 500, 100000, 0.0), 0);

	gDrugz[FENT][DrugPrice] = price;
	gBlackMarketRatio = MARKET_RATIO_EQULIBRIUM;

	TEST_END("FencePricing");
}

Test: FenceRejectsAwayFromDruggery()
{
	TEST_START("FenceRejectsAwayFromDruggery");

	new
		playerid = CreateTestPlayer(),
		money = GetPlayerMoney(playerid);

	gPlayers[playerid][Drugs][ZAZA] = 50;
	gDrugz[ZAZA][DrugPrice] = 50;

	// Not a dealer
	ProcessFenceSale(playerid, TYPE_ZAZA, 10);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 50);
	ASSERT_EQ(GetPlayerMoney(playerid), money);

	// A dealer, but not at a druggery point
	gPlayers[playerid][TeamID] = TEAM_DEALERS;
	ProcessFenceSale(playerid, TYPE_ZAZA, 10);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 50);
	ASSERT_EQ(GetPlayerMoney(playerid), money);

	gPlayers[playerid][Drugs][ZAZA] = 0;
	DestroyTestPlayer(playerid);

	TEST_END("FenceRejectsAwayFromDruggery");
}

Test: FenceSaleWithinLimits()
{
	TEST_START("FenceSaleWithinLimits");

	new
		playerid = CreateTestPlayer(),
		userid = InsertTestUser("fence_tester"),
		price = gDrugz[ZAZA][DrugPrice],
		points = gDruggeryPointCount,
		Float: pointX = gDruggeryPoints[0][PointCoords][CoordX],
		Float: pointY = gDruggeryPoints[0][PointCoords][CoordY],
		Float: pointZ = gDruggeryPoints[0][PointCoords][CoordZ],
		query[256];

	format(query, sizeof(query), "DELETE FROM fence_sales WHERE user_id = %d", userid);
	ExecDBStatement(query);

	// A Dealer at a druggery point
	gPlayers[playerid][OrmID] = userid;
	gPlayers[playerid][TeamID] = TEAM_DEALERS;
	ResetPlayerMoney(playerid);

	gDruggeryPoints[0][PointCoords][CoordX] = 2000.0;
	gDruggeryPoints[0][PointCoords][CoordY] = 2000.0;
	gDruggeryPoints[0][PointCoords][CoordZ] = 10.0;
	gDruggeryPointCount = 1;
	PlaceTestPlayer(playerid, 2001.0, 2000.0, 10.0);

	// $30 a gram: 60% of the $50 list price at an even market
	gDrugz[ZAZA][DrugPrice] = 50;
	gBlackMarketRatio = 1.0;
	gPlayers[playerid][Drugs][ZAZA] = 100;

	// More than the player has, or nothing at all
	ProcessFenceSale(playerid, TYPE_ZAZA, 101);
	ProcessFenceSale(playerid, TYPE_ZAZA, 0);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 100);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	ProcessFenceSale(playerid, TYPE_ZAZA, 40);

	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 60);
	ASSERT_EQ(GetPlayerMoney(playerid), 1200);
	ASSERT_TRUE(gBlackMarketRatio < 1.0);

	format(query, sizeof(query), "SELECT COUNT(*) FROM fence_sales WHERE user_id = %d AND drug_type = %d AND amount = 40 AND value = 1200", userid, _: TYPE_ZAZA);
	ASSERT_EQ(QueryTestInt(query), 1);

	// 4990 units sold within the hour leave 10; a sale from two hours ago no
	// longer counts
	format(query, sizeof(query), "INSERT INTO fence_sales (user_id, drug_type, amount, value, ratio, sold_at) VALUES (%d, %d, 4950, 0, 1.0, %d), (%d, %d, 5000, 0, 1.0, %d)",
			userid, _: TYPE_ZAZA, gettime(),
			userid, _: TYPE_ZAZA, gettime() - 2 * FENCE_WINDOW_S);
	ExecDBStatement(query);

	gBlackMarketRatio = 1.0;
	ProcessFenceSale(playerid, TYPE_ZAZA, 40);

	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 50);
	ASSERT_EQ(GetPlayerMoney(playerid), 1500);

	// Nothing left this hour
	gBlackMarketRatio = 1.0;
	ProcessFenceSale(playerid, TYPE_ZAZA, 10);

	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 50);
	ASSERT_EQ(GetPlayerMoney(playerid), 1500);

	format(query, sizeof(query), "DELETE FROM fence_sales WHERE user_id = %d", userid);
	ExecDBStatement(query);
	DeleteTestUserByID(userid);

	gDruggeryPoints[0][PointCoords][CoordX] = pointX;
	gDruggeryPoints[0][PointCoords][CoordY] = pointY;
	gDruggeryPoints[0][PointCoords][CoordZ] = pointZ;
	gDruggeryPointCount = points;
	gDrugz[ZAZA][DrugPrice] = price;
	gBlackMarketRatio = MARKET_RATIO_EQULIBRIUM;

	gPlayers[playerid][Drugs][ZAZA] = 0;
	ResetPlayerMoney(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("FenceSaleWithinLimits");
}
