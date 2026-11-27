//
//  test_rampage.pwn
//

// Grove Street (8 gunmen, 4 weapon and 4 health pickups) and Las Colinas
#define RAMPAGE_TEST_ID			2
#define RAMPAGE_TEST_OTHER_ID	1

static bool: gRampageTestLoaded = false;

stock EnsureRampagesLoaded()
{
	if (!gRampageTestLoaded)
	{
		InitRampageSlots();
		InitRampagePickups();

		gRampageTestLoaded = true;
	}

	return 1;
}

stock CountRampageNPCs(missionid)
{
	new
		count = 0;

	for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
	{
		if (gRampageNPCs[missionid][i][ID] != INVALID_NPC_ID)
		{
			count++;
		}
	}

	return count;
}

stock ResetTestRampage(playerid)
{
	gRampageMission[playerid][Active] = false;
	gRampageMission[playerid][ID] = 0;
	gRampageMission[playerid][KilledCount] = 0;
	gRampageMission[playerid][TimeElapsed] = 0;
	gPlayers[playerid][InMinigame] = false;

	return 1;
}

Test: RampageStartAndAbort()
{
	TEST_START("RampageStartAndAbort");

	EnsureRampagesLoaded();

	new
		mission = RAMPAGE_TEST_ID,
		playerid = CreateTestPlayer(),
		rival = CreateTestPlayer(),
		userid = InsertTestUser("rampage_tester"),
		start = gRampagePickups[RAMPAGE_TEST_ID][0][PickupID],
		otherStart = gRampagePickups[RAMPAGE_TEST_OTHER_ID][0][PickupID],
		query[160];

	ResetTestRampage(playerid);
	ResetTestRampage(rival);
	gPlayers[playerid][OrmID] = userid;

	ASSERT_TRUE(IsValidPickup(start));

	// Walking onto the start pickup starts the rampage
	ASSERT_TRUE(CheckRampagePickup(playerid, start));
	ASSERT_TRUE(gRampageMission[playerid][Active]);
	ASSERT_EQ(gRampageMission[playerid][ID], mission);
	ASSERT_TRUE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gRampageMission[playerid][TimeElapsed], 300000);
	ASSERT_TRUE(IsValidTimer(gRampageMission[playerid][TimerElapsed]));

	// One gunman per NPC row, and its weapon and health pickups
	format(query, sizeof(query), "SELECT COUNT(*) FROM rampage_coords WHERE rampage_id = %d AND type = 2", mission);
	ASSERT_EQ(CountRampageNPCs(mission), QueryTestInt(query));

	new
		gunmen[MAX_RAMPAGE_NPC_COUNT],
		weaponSlot = -1,
		healthSlot = -1,
		pickups = 0;

	for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
	{
		gunmen[i] = gRampageNPCs[mission][i][ID];
	}

	for (new k = 1; k < 3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT; k++)
	{
		if (gRampagePickups[mission][k][PickupID] == INVALID_PICKUP || !IsValidPickup(gRampagePickups[mission][k][PickupID]))
		{
			continue;
		}

		pickups++;

		if (gRampagePickups[mission][k][PickupType] == RMPT_WEAPON && weaponSlot == -1)
		{
			weaponSlot = k;
		}

		if (gRampagePickups[mission][k][PickupType] == RMPT_HEALTH && healthSlot == -1)
		{
			healthSlot = k;
		}
	}

	format(query, sizeof(query), "SELECT COUNT(*) FROM rampage_coords WHERE rampage_id = %d AND type IN (4, 5)", mission);
	ASSERT_EQ(pickups, QueryTestInt(query));
	ASSERT_TRUE(weaponSlot != -1 && healthSlot != -1);

	// Crossing another rampage's start pickup mid-run changes nothing: this
	// run keeps its id, so the abort later cleans up the right gunmen
	CheckRampagePickup(playerid, otherStart);

	ASSERT_EQ(gRampageMission[playerid][ID], mission);
	ASSERT_TRUE(gRampageMission[playerid][Active]);

	// Nobody else can join this rampage while it runs: the gunmen and
	// pickups are one set per rampage, and a second run would overwrite them
	CheckRampagePickup(rival, start);

	ASSERT_FALSE(gRampageMission[rival][Active]);
	ASSERT_FALSE(gPlayers[rival][InMinigame]);

	new
		untouched = 0;

	for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
	{
		if (gRampageNPCs[mission][i][ID] == gunmen[i])
		{
			untouched++;
		}
	}

	ASSERT_EQ(untouched, MAX_RAMPAGE_NPC_COUNT);

	// A weapon pickup: the gun, and the pickup is used up for good
	new
		noPickup = INVALID_PICKUP,
		weaponPickup = gRampagePickups[mission][weaponSlot][PickupID],
		weaponid = gRampagePickups[mission][weaponSlot][WeaponID],
		healthPickup = gRampagePickups[mission][healthSlot][PickupID];

	ASSERT_TRUE(CheckRampagePickup(playerid, weaponPickup));
	ASSERT_TRUE(IsWeaponGranted(playerid, weaponid));
	ASSERT_FALSE(IsValidPickup(weaponPickup));
	ASSERT_EQ(gRampagePickups[mission][weaponSlot][PickupID], noPickup);

	ASSERT_TRUE(CheckRampagePickup(playerid, healthPickup));
	ASSERT_FALSE(IsValidPickup(healthPickup));
	ASSERT_EQ(gRampagePickups[mission][healthSlot][PickupID], noPickup);

	// The server hands a freed pickup id to the next pickup. That one, an
	// unrelated pickup, is no rampage weapon, and the abort leaves it alone
	new
		unrelated = CreatePickup(1239, 1, 0.0, 0.0, -50.0);

	printf("[rampage] used pickup %d, the next one got %d", weaponPickup, unrelated);

	ASSERT_FALSE(CheckRampagePickup(playerid, unrelated));

	// Ending it with three kills: a high score, and everything torn down
	gRampageMission[playerid][KilledCount] = 3;

	new
		timer = gRampageMission[playerid][TimerElapsed];

	AbortRampageMission(playerid);

	ASSERT_FALSE(gRampageMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_FALSE(IsValidTimer(timer));
	ASSERT_EQ(CountRampageNPCs(mission), 0);
	ASSERT_TRUE(IsValidPickup(unrelated));

	new
		left = 0;

	for (new k = 1; k < 3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT; k++)
	{
		if (gRampagePickups[mission][k][PickupID] != INVALID_PICKUP)
		{
			left++;
		}
	}

	ASSERT_EQ(left, 0);

	// The start pickup stays for the next run
	ASSERT_TRUE(IsValidPickup(start));

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 7 AND spec_id = %d AND value = 3 AND user_id = %d", mission, userid);
	ASSERT_EQ(QueryTestInt(query), 1);

	// ...after which the rival may go
	CheckRampagePickup(rival, start);
	ASSERT_TRUE(gRampageMission[rival][Active]);

	AbortRampageMission(rival);
	ASSERT_EQ(CountRampageNPCs(mission), 0);

	DestroyTestPickup(unrelated);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 7 AND user_id = %d", userid);
	ExecDBStatement(query);

	ResetTestRampage(playerid);
	ResetTestRampage(rival);
	ResetPlayerWeapons(playerid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(rival);
	DestroyTestPlayer(playerid);

	TEST_END("RampageStartAndAbort");
}

Test: RampageTimeRunsOut()
{
	TEST_START("RampageTimeRunsOut");

	EnsureRampagesLoaded();

	new
		playerid = CreateTestPlayer();

	ResetTestRampage(playerid);

	// A run in progress, without spawning its gunmen: each test NPC stays
	// until the run is over, and the suite has the server's maxnpc to share
	gRampageMission[playerid][ID] = RAMPAGE_TEST_ID;
	gRampageMission[playerid][Active] = true;
	gRampageMission[playerid][TimerElapsed] = SetTimerEx("TestIdleTimer", 60000, true, "i", playerid);
	gPlayers[playerid][InMinigame] = true;

	new
		timer = gRampageMission[playerid][TimerElapsed];

	// The clock counts down a second a tick, and the rampage ends at zero
	gRampageMission[playerid][TimeElapsed] = 1500;

	UpdateRampageMissionInfoText(playerid);
	ASSERT_EQ(gRampageMission[playerid][TimeElapsed], 500);
	ASSERT_TRUE(gRampageMission[playerid][Active]);

	UpdateRampageMissionInfoText(playerid);
	ASSERT_FALSE(gRampageMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_FALSE(IsValidTimer(timer));

	ResetTestRampage(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("RampageTimeRunsOut");
}
