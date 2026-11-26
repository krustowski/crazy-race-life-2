//
//  test_prizes.pwn
//

#define PRIZE_TEST_TIKI_ID		9001
#define PRIZE_TEST_PUMPKIN_ID	9002

stock GetSavedPrizeHidden(id)
{
	new
		query[80];

	format(query, sizeof(query), "SELECT hidden FROM prize_coords WHERE id = %d", id);
	return QueryTestInt(query);
}

stock ClearTestPrizes()
{
	for (new i = 0; i < gPrizeCount; i++)
	{
		DestroyPrizePickup(i);
	}

	gPrizeCount = 0;

	new
		query[96];

	format(query, sizeof(query), "DELETE FROM prize_coords WHERE id IN (%d, %d)", PRIZE_TEST_TIKI_ID, PRIZE_TEST_PUMPKIN_ID);
	return ExecDBStatement(query);
}

Test: PrizesLoadAndPayOut()
{
	TEST_START("PrizesLoadAndPayOut");

	new
		query[160];

	ClearTestPrizes();

	// A tiki out in the world, a pumpkin hidden away
	format(query, sizeof(query), "INSERT INTO prize_coords (id, type, name, x, y, z, hidden) VALUES (%d, %d, 'test tiki', 10.5, 20.5, 3.0, 0)", PRIZE_TEST_TIKI_ID, _: PRIZE_TIKI);
	ExecDBStatement(query);
	format(query, sizeof(query), "INSERT INTO prize_coords (id, type, name, x, y, z, hidden) VALUES (%d, %d, '', 30.0, 40.0, 3.0, 1)", PRIZE_TEST_PUMPKIN_ID, _: PRIZE_PUMPKIN);
	ExecDBStatement(query);

	ASSERT_TRUE(InitPrizes());
	ASSERT_EQ(gPrizeCount, 2);

	// ORDER BY id: the tiki first
	new
		tikiID = gPrizes[0][ID],
		pumpkinID = gPrizes[1][ID],
		tikiPickup = _: gPrizes[0][Pickup];

	ASSERT_EQ(tikiID, PRIZE_TEST_TIKI_ID);
	ASSERT_EQ(pumpkinID, PRIZE_TEST_PUMPKIN_ID);
	ASSERT_FLOAT_EQ(gPrizes[0][Point][CoordX], 10.5);
	ASSERT_FALSE(gPrizes[0][Hidden]);
	ASSERT_TRUE(gPrizes[1][Hidden]);

	// Only the visible one is in the world
	ASSERT_TRUE(tikiPickup > 0);
	ASSERT_TRUE(IsValidPickup(tikiPickup));
	ASSERT_TRUE(gPrizes[1][Pickup] == PICKUP: 0);

	new
		playerid = CreateTestPlayer(),
		money = GetPlayerMoney(playerid);

	// Not a prize pickup
	ASSERT_EQ(CheckPrizePickup(playerid, tikiPickup + 1000), 0);
	ASSERT_EQ(GetPlayerMoney(playerid), money);

	// Found: paid, and gone for good
	ASSERT_EQ(CheckPrizePickup(playerid, tikiPickup), 1);
	ASSERT_EQ(GetPlayerMoney(playerid), money + GetPrizeReward(PRIZE_TIKI));
	ASSERT_TRUE(gPrizes[0][Hidden]);
	ASSERT_TRUE(gPrizes[0][Pickup] == PICKUP: 0);
	ASSERT_FALSE(IsValidPickup(tikiPickup));
	ASSERT_EQ(GetSavedPrizeHidden(PRIZE_TEST_TIKI_ID), 1);

	// A second walk-in on the same (now destroyed) pickup pays nothing
	ASSERT_EQ(CheckPrizePickup(playerid, tikiPickup), 0);
	ASSERT_EQ(GetPlayerMoney(playerid), money + GetPrizeReward(PRIZE_TIKI));

	// The editor shows the pumpkin: the pickup and the DB row follow
	ASSERT_TRUE(TogglePrizeHidden(1));
	ASSERT_FALSE(gPrizes[1][Hidden]);
	ASSERT_TRUE(gPrizes[1][Pickup] != PICKUP: 0);
	ASSERT_EQ(GetSavedPrizeHidden(PRIZE_TEST_PUMPKIN_ID), 0);

	// A reload comes back to the same state from the DB
	ASSERT_TRUE(ReloadPrizes());
	ASSERT_EQ(gPrizeCount, 2);
	ASSERT_TRUE(gPrizes[0][Hidden]);
	ASSERT_TRUE(gPrizes[0][Pickup] == PICKUP: 0);
	ASSERT_FALSE(gPrizes[1][Hidden]);
	ASSERT_TRUE(gPrizes[1][Pickup] != PICKUP: 0);

	// Out of range ids are refused
	ASSERT_EQ(SetPrizeHidden(-1, true), 0);
	ASSERT_EQ(TogglePrizeHidden(gPrizeCount), 0);

	ClearTestPrizes();
	DestroyTestPlayer(playerid);

	TEST_END("PrizesLoadAndPayOut");
}

Test: PrizeTypes()
{
	TEST_START("PrizeTypes");

	new
		name[16],
		expectTiki[] = "Tiki",
		expectNone[] = "None";

	ASSERT_EQ(GetPrizeModel(PRIZE_TIKI), PICKUP_TIKI);
	ASSERT_EQ(GetPrizeModel(PRIZE_PUMPKIN), PICKUP_PUMPKIN);
	ASSERT_EQ(GetPrizeModel(PRIZE_NONE), 0);

	ASSERT_EQ(GetPrizeReward(PRIZE_TIKI), 10000000);
	ASSERT_EQ(GetPrizeReward(PRIZE_PUMPKIN), 1500000);
	ASSERT_EQ(GetPrizeReward(PRIZE_NONE), 0);

	GetPrizeTypeName(PRIZE_TIKI, name, sizeof(name));
	ASSERT_STREQ(name, expectTiki);
	GetPrizeTypeName(PRIZE_NONE, name, sizeof(name));
	ASSERT_STREQ(name, expectNone);

	TEST_END("PrizeTypes");
}
