//
//  test_bribe.pwn
//

stock UnloadTestPoliceBribePickups()
{
	for (new i = 0; i < MAX_BRIBE_COUNT; i++)
	{
		DestroyTestPickup(gPoliceBribeStars[i][PickupID]);

		if (gPoliceBribeStars[i][HiddenTimer])
		{
			KillTimer(_: gPoliceBribeStars[i][HiddenTimer]);
		}

		gPoliceBribeStars[i][PickupID] = 0;
		gPoliceBribeStars[i][OrmID] = 0;
		gPoliceBribeStars[i][HiddenTimer] = Timer: 0;
	}

	gPoliceBribeStarCount = 0;
	gPoliceBribeStarLastOrmID = 0;

	return 1;
}

Test: PoliceBribePickups()
{
	TEST_START("PoliceBribePickups");

	new
		rows = QueryTestInt("SELECT COUNT(*) FROM police_bribe_coords"),
		lastid = QueryTestInt("SELECT MAX(id) FROM police_bribe_coords");

	UnloadTestPoliceBribePickups();

	ASSERT_TRUE(InitPoliceBribePickups());
	ASSERT_EQ(gPoliceBribeStarCount, rows);
	ASSERT_EQ(gPoliceBribeStarLastOrmID, lastid);

	new
		starid = gPoliceBribeStars[0][PickupID],
		playerid = CreateTestPlayer();

	ASSERT_TRUE(IsValidPickup(starid));

	// Nobody is after the player: the star stays
	gPlayers[playerid][WantedLevel] = 0;
	CheckPoliceBribePickup(playerid, starid);

	ASSERT_TRUE(IsValidPickup(starid));
	ASSERT_EQ(gPoliceBribeStars[0][PickupID], starid);

	// Wanted: one star off, and the pickup is gone until its timer
	gPlayers[playerid][WantedLevel] = 2;
	SetPlayerWantedLevel(playerid, 2);
	CheckPoliceBribePickup(playerid, starid);

	ASSERT_EQ(gPlayers[playerid][WantedLevel], 1);
	ASSERT_EQ(GetPlayerWantedLevel(playerid), 1);
	ASSERT_FALSE(IsValidPickup(starid));
	ASSERT_EQ(gPoliceBribeStars[0][PickupID], 0);
	ASSERT_TRUE(IsValidTimer(_: gPoliceBribeStars[0][HiddenTimer]));

	// The timer puts it back where the DB has it
	new
		timerid = _: gPoliceBribeStars[0][HiddenTimer];

	HidePoliceBribeTimer(0);

	ASSERT_TRUE(IsValidPickup(gPoliceBribeStars[0][PickupID]));
	ASSERT_FALSE(IsValidTimer(timerid));
	ASSERT_TRUE(gPoliceBribeStars[0][HiddenTimer] == Timer: 0);

	// Walking into it again takes the last star
	CheckPoliceBribePickup(playerid, gPoliceBribeStars[0][PickupID]);
	ASSERT_EQ(gPlayers[playerid][WantedLevel], 0);

	UnloadTestPoliceBribePickups();
	DestroyTestPlayer(playerid);

	TEST_END("PoliceBribePickups");
}
