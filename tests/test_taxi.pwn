//
//  test_taxi.pwn
//
//  SetPlayerTaxiMission() wants a Taximen driver in a cab, which a test NPC
//  cannot be inside main(); these drive the mission from there on.
//

// A coordinate the DB keeps to two decimals, back as a Float
stock Float: QueryTestCoord(const query[])
{
	return float(QueryTestInt(query)) / 100.0;
}

// Puts <playerid> on a random taxi point (an OFFER coord) of <prefix> ("LV:")
stock PlaceAtTaxiPoint(playerid, const prefix[])
{
	new
		query[320],
		id;

	format(query, sizeof(query), "SELECT c.id FROM property_coords AS c JOIN properties AS p ON c.property_id = p.id WHERE c.type = 8 AND p.name LIKE '%s%%' ORDER BY c.id LIMIT 1", prefix);
	id = QueryTestInt(query);

	format(query, sizeof(query), "SELECT CAST(ROUND(primary_x * 100) AS INTEGER) FROM property_coords WHERE id = %d", id);
	new Float: X = QueryTestCoord(query);
	format(query, sizeof(query), "SELECT CAST(ROUND(primary_y * 100) AS INTEGER) FROM property_coords WHERE id = %d", id);
	new Float: Y = QueryTestCoord(query);
	format(query, sizeof(query), "SELECT CAST(ROUND(primary_z * 100) AS INTEGER) FROM property_coords WHERE id = %d", id);
	new Float: Z = QueryTestCoord(query);

	PlaceTestPlayer(playerid, X, Y, Z);

	return id;
}

// Whether <X>, <Y> is a taxi point of a property named <prefix>... (any, for "")
stock bool: IsTaxiPoint(Float: X, Float: Y, const prefix[], const name[] = "")
{
	new
		query[400];

	if (name[0])
	{
		format(query, sizeof(query), "SELECT COUNT(*) FROM property_coords AS c JOIN properties AS p ON c.property_id = p.id WHERE c.type = 8 AND p.name LIKE '%s%%' AND p.name = '%q' AND ABS(c.primary_x - %f) < 0.01 AND ABS(c.primary_y - %f) < 0.01", prefix, name, X, Y);
	}
	else
	{
		format(query, sizeof(query), "SELECT COUNT(*) FROM property_coords AS c JOIN properties AS p ON c.property_id = p.id WHERE c.type = 8 AND p.name LIKE '%s%%' AND ABS(c.primary_x - %f) < 0.01 AND ABS(c.primary_y - %f) < 0.01", prefix, X, Y);
	}

	return (QueryTestInt(query) > 0);
}

stock ResetTestTaxiMission(playerid)
{
	gTaxiMission[playerid][Active] = false;
	gTaxiMission[playerid][NPCid] = -1;
	gTaxiMission[playerid][VehicleID] = -1;
	gTaxiMission[playerid][AreaID] = AREA_ALL;
	gTaxiMission[playerid][CommissionCoef] = 0.0;
	gTaxiMission[playerid][DoneCount] = 0;
	gTaxiMission[playerid][Earned] = 0;
	gTaxiMission[playerid][TimeElapsed] = 0;
	gTaxiMission[playerid][NextDestinationName][0] = EOS;
	gTaxiMission[playerid][Checkpoint][CoordX] = 0.0;
	gTaxiMission[playerid][Checkpoint][CoordY] = 0.0;
	gTaxiMission[playerid][Checkpoint][CoordZ] = 0.0;
	gTaxiMission[playerid][TimerNPCExit] = 0;
	gTaxiMission[playerid][TimerUpdate] = 0;
	gTaxiMission[playerid][TimerCheckNearNPC] = 0;
	gTaxiMission[playerid][TimerCheckNPCInVehicle] = 0;
	gTaxiMission[playerid][TimerCheckVehicle] = 0;

	gPlayers[playerid][InMinigame] = false;

	return 1;
}

Test: TaxiDestinations()
{
	TEST_START("TaxiDestinations");

	new
		playerid = CreateTestPlayer(),
		prefixes[4][4] = {"LV:", "SF:", "LS:", ""},
		areas[4] = {AREA_LV, AREA_SF, AREA_LS, AREA_ALL};

	ResetTestTaxiMission(playerid);

	for (new a = 0; a < 4; a++)
	{
		// From a point in the area itself (LV for the whole map), so there
		// are points far enough away to pick
		new
			from = (a < 3) ? a : 0;

		PlaceAtTaxiPoint(playerid, prefixes[from]);

		new
			Float: pX,
			Float: pY,
			Float: pZ;

		GetPlayerPos(playerid, pX, pY, pZ);

		gTaxiMission[playerid][AreaID] = areas[a];

		ASSERT_EQ(SetTaxiMissionCheckpoint(playerid), 1);

		new
			Float: X = gTaxiMission[playerid][Checkpoint][CoordX],
			Float: Y = gTaxiMission[playerid][Checkpoint][CoordY],
			Float: Z = gTaxiMission[playerid][Checkpoint][CoordZ];

		// (ASSERT takes no string literals or calls with commas, hence the bools)
		new
			bool: inArea = IsTaxiPoint(X, Y, prefixes[a], gTaxiMission[playerid][NextDestinationName]),
			bool: farEnough = (VectorSize(X - pX, Y - pY, Z - pZ) >= TAXI_DESTINATION_MIN_DIST),
			bool: rightCoef = _FloatEq(gTaxiMission[playerid][CommissionCoef], (floatabs(pX - X) / 3000 + floatabs(pY - Y) / 3000) / 2);

		// A taxi point of a property in that area, under that property's name,
		// far enough away to be worth a fare, which grows with the distance
		ASSERT_TRUE(inArea);
		ASSERT_TRUE(farEnough);
		ASSERT_TRUE(rightCoef);
	}

	ResetTestTaxiMission(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("TaxiDestinations");
}

Test: TaxiCustomerNearby()
{
	TEST_START("TaxiCustomerNearby");

	new
		playerid = CreateTestPlayer();

	ResetTestTaxiMission(playerid);
	PlaceAtTaxiPoint(playerid, "SF:");

	gTaxiMission[playerid][AreaID] = AREA_SF;

	// A customer NPC on a taxi point of the area, close to the cab
	ASSERT_EQ(SetTaxiMissionCustomer(playerid), 1);

	new
		npcid = gTaxiMission[playerid][NPCid];

	ASSERT_TRUE(npcid != -1 && NPC_IsValid(npcid));

	if (npcid != -1)
	{
		new
			Float: X,
			Float: Y,
			Float: Z,
			Float: pX,
			Float: pY,
			Float: pZ;

		GetPlayerPos(npcid, X, Y, Z);
		GetPlayerPos(playerid, pX, pY, pZ);

		new
			bool: onPoint = IsTaxiPoint(X, Y, "SF:"),
			bool: closeBy = (VectorSize(X - pX, Y - pY, Z - pZ) <= TAXI_CUSTOMER_MAX_DIST);

		ASSERT_TRUE(onPoint);
		ASSERT_TRUE(closeBy);
	}

	// The cab is watched for pulling up next to them
	ASSERT_TRUE(IsValidTimer(gTaxiMission[playerid][TimerCheckNearNPC]));

	// Giving up sends the customer away and stops the watching
	gTaxiMission[playerid][Active] = true;
	AbortPlayerTaxiMission(playerid);

	ASSERT_FALSE(gTaxiMission[playerid][Active]);
	ASSERT_EQ(gTaxiMission[playerid][NPCid], -1);
	ASSERT_FALSE(IsValidTimer(gTaxiMission[playerid][TimerCheckNearNPC]));

	ResetTestTaxiMission(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("TaxiCustomerNearby");
}

Test: TaxiDeliveryPays()
{
	TEST_START("TaxiDeliveryPays");

	new
		playerid = CreateTestPlayer(),
		customer = CreateTestPlayer();

	ResetTestTaxiMission(playerid);
	ResetPlayerMoney(playerid);

	// No mission, no fare
	ASSERT_EQ(CheckTaxiMissionCheckpoint(playerid), 0);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	gTaxiMission[playerid][Active] = true;
	gTaxiMission[playerid][NPCid] = customer;
	gTaxiMission[playerid][CommissionCoef] = 0.4;
	gTaxiMission[playerid][TimeElapsed] = 7000;
	gTaxiMission[playerid][Checkpoint][CoordX] = 100.0;

	// The first fare: $5000 plus the distance bonus once
	ASSERT_EQ(CheckTaxiMissionCheckpoint(playerid), 1);
	ASSERT_EQ(GetPlayerMoney(playerid), 6000);
	ASSERT_EQ(gTaxiMission[playerid][Earned], 6000);
	ASSERT_EQ(gTaxiMission[playerid][DoneCount], 1);
	ASSERT_EQ(gTaxiMission[playerid][TimeElapsed], 0);
	ASSERT_TRUE(gTaxiMission[playerid][Checkpoint][CoordX] == 0.0);

	// The customer gets out in a moment
	ASSERT_TRUE(IsValidTimer(gTaxiMission[playerid][TimerNPCExit]));
	KillTimer(gTaxiMission[playerid][TimerNPCExit]);

	// The second: the bonus once or twice
	CheckTaxiMissionCheckpoint(playerid);

	new
		paid = GetPlayerMoney(playerid) - 6000;

	ASSERT_TRUE(paid == 6000 || paid == 7000);
	ASSERT_EQ(gTaxiMission[playerid][DoneCount], 2);

	KillTimer(gTaxiMission[playerid][TimerNPCExit]);

	ResetTestTaxiMission(playerid);
	ResetPlayerMoney(playerid);
	DestroyTestPlayer(customer);
	DestroyTestPlayer(playerid);

	TEST_END("TaxiDeliveryPays");
}

Test: TaxiAbortStopsEverything()
{
	TEST_START("TaxiAbortStopsEverything");

	new
		playerid = CreateTestPlayer(),
		customer = CreateTestPlayer(),
		userid = InsertTestUser("taxi_tester"),
		query[128];

	ResetTestTaxiMission(playerid);
	gPlayers[playerid][OrmID] = userid;

	// Not driving anyone: refused, nothing starts
	gPlayers[playerid][InMinigame] = true;
	SetPlayerTaxiMission(playerid, AREA_LV);
	ASSERT_FALSE(gTaxiMission[playerid][Active]);

	gPlayers[playerid][InMinigame] = false;
	SetPlayerTaxiMission(playerid, AREA_LV);
	ASSERT_FALSE(gTaxiMission[playerid][Active]);

	// A mission two fares in, with a customer getting in and every one of its
	// timers running, as they are at that moment
	gTaxiMission[playerid][Active] = true;
	gTaxiMission[playerid][AreaID] = AREA_LV;
	gTaxiMission[playerid][NPCid] = customer;
	gTaxiMission[playerid][DoneCount] = 2;
	gPlayers[playerid][InMinigame] = true;

	gTaxiMission[playerid][TimerNPCExit] = SetTimerEx("TestIdleTimer", 60000, false, "i", playerid);
	gTaxiMission[playerid][TimerUpdate] = SetTimerEx("TestIdleTimer", 60000, true, "i", playerid);
	gTaxiMission[playerid][TimerCheckNearNPC] = SetTimerEx("TestIdleTimer", 60000, true, "i", playerid);
	gTaxiMission[playerid][TimerCheckNPCInVehicle] = SetTimerEx("TestIdleTimer", 60000, true, "i", playerid);
	gTaxiMission[playerid][TimerCheckVehicle] = SetTimerEx("TestIdleTimer", 60000, true, "i", playerid);

	new
		exitTimer = gTaxiMission[playerid][TimerNPCExit],
		boardingTimer = gTaxiMission[playerid][TimerCheckNPCInVehicle];

	AbortPlayerTaxiMission(playerid);

	ASSERT_FALSE(gTaxiMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gTaxiMission[playerid][DoneCount], 0);

	// None of the mission's timers may outlive it: a boarding check left
	// running would set a new destination every two seconds of the next one
	ASSERT_FALSE(IsValidTimer(gTaxiMission[playerid][TimerUpdate]));
	ASSERT_FALSE(IsValidTimer(gTaxiMission[playerid][TimerCheckNearNPC]));
	ASSERT_FALSE(IsValidTimer(gTaxiMission[playerid][TimerCheckVehicle]));
	ASSERT_FALSE(IsValidTimer(boardingTimer));
	ASSERT_FALSE(IsValidTimer(exitTimer));

	// The two fares are a high score for the area
	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 3 AND spec_id = %d AND value = 2 AND user_id = %d", AREA_LV, userid);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 3 AND user_id = %d", userid);
	ExecDBStatement(query);

	KillTimer(exitTimer);
	KillTimer(boardingTimer);

	ResetTestTaxiMission(playerid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(customer);
	DestroyTestPlayer(playerid);

	TEST_END("TaxiAbortStopsEverything");
}
