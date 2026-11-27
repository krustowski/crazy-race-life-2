//
//  test_rob.pwn
//  Robbing needs the robber on foot, and an NPC only gets there a few server
//  ticks after it spawns, while the suite runs inside main(). So these tests
//  drive StartRobbery() and StopRobbery() directly rather than the keys and
//  the 1s loot tick.
//

// gProperties[] is not loaded in the tests: the last slot is free for a shop.
// (A const, not a parenthesised macro, which the ASSERT macros would cut at)
const ROB_TEST_SLOT = MAX_PROPERTIES - 1;

#define ROB_TEST_PROPERTY_ID	99001
#define ROB_TEST_OWNER_ID		424242
#define ROB_TEST_COST			64000

#define ROB_TEST_X				1000.0
#define ROB_TEST_Y				1000.0
#define ROB_TEST_Z				10.0

stock SetUpRobTestProperty()
{
	gProperties[ROB_TEST_SLOT][ID] = ROB_TEST_PROPERTY_ID;
	gProperties[ROB_TEST_SLOT][Type] = PROPERTY_TYPE_COMMERCIAL;
	gProperties[ROB_TEST_SLOT][Cost] = ROB_TEST_COST;
	gProperties[ROB_TEST_SLOT][Occupied] = true;
	gProperties[ROB_TEST_SLOT][UserID] = ROB_TEST_OWNER_ID;
	format(gProperties[ROB_TEST_SLOT][Label], 64, "Test Shop");

	gPropertyCoords[ROB_TEST_SLOT][0][PickupType] = OFFER_POINT;
	gPropertyCoords[ROB_TEST_SLOT][0][Primary][CoordX] = ROB_TEST_X;
	gPropertyCoords[ROB_TEST_SLOT][0][Primary][CoordY] = ROB_TEST_Y;
	gPropertyCoords[ROB_TEST_SLOT][0][Primary][CoordZ] = ROB_TEST_Z;

	gRobPropertyLockedUntil[ROB_TEST_SLOT] = 0;
	gPropertyCommissionBlockedUntil[ROB_TEST_SLOT] = 0;

	return 1;
}

stock TearDownRobTestProperty()
{
	gProperties[ROB_TEST_SLOT][ID] = 0;
	gProperties[ROB_TEST_SLOT][Type] = PROPERTY_TYPE_NONE;
	gProperties[ROB_TEST_SLOT][Cost] = 0;
	gProperties[ROB_TEST_SLOT][Occupied] = false;
	gProperties[ROB_TEST_SLOT][UserID] = 0;
	gProperties[ROB_TEST_SLOT][Label][0] = '\0';

	gPropertyCoords[ROB_TEST_SLOT][0][PickupType] = NULL_POINT;

	gRobPropertyLockedUntil[ROB_TEST_SLOT] = 0;
	gPropertyCommissionBlockedUntil[ROB_TEST_SLOT] = 0;

	return 1;
}

Test: RobPropertyRangeAndRate()
{
	TEST_START("RobPropertyRangeAndRate");

	SetUpRobTestProperty();

	new
		playerid = CreateTestPlayer();

	// By the offer pickup, and too far off it
	PlaceTestPlayer(playerid, ROB_TEST_X + 2.0, ROB_TEST_Y, ROB_TEST_Z);
	ASSERT_TRUE(IsPlayerAtRobbableProperty(playerid, ROB_TEST_SLOT));
	ASSERT_EQ(GetRobbablePropertyInRange(playerid), ROB_TEST_SLOT);

	PlaceTestPlayer(playerid, ROB_TEST_X + ROB_PROPERTY_RANGE + 1.0, ROB_TEST_Y, ROB_TEST_Z);
	ASSERT_FALSE(IsPlayerAtRobbableProperty(playerid, ROB_TEST_SLOT));
	ASSERT_EQ(GetRobbablePropertyInRange(playerid), INVALID_PROPERTY_ID);

	// A personal property is not a shop
	PlaceTestPlayer(playerid, ROB_TEST_X, ROB_TEST_Y, ROB_TEST_Z);
	gProperties[ROB_TEST_SLOT][Type] = PROPERTY_TYPE_PERSONAL;
	ASSERT_FALSE(IsPlayerAtRobbableProperty(playerid, ROB_TEST_SLOT));
	gProperties[ROB_TEST_SLOT][Type] = PROPERTY_TYPE_COMMERCIAL;

	ASSERT_FALSE(IsPlayerAtRobbableProperty(playerid, -1));
	ASSERT_FALSE(IsPlayerAtRobbableProperty(playerid, MAX_PROPERTIES));

	// cost / 80 plus up to cost / 160 a second
	new
		lowest = cellmax,
		highest = 0;

	for (new i = 0; i < 500; i++)
	{
		new
			rate = GetRobberyRate(ROB_TEST_SLOT);

		lowest = min(lowest, rate);
		highest = max(highest, rate);
	}

	ASSERT_TRUE(lowest >= ROB_TEST_COST / ROB_RATE_BASE_DIVISOR);
	ASSERT_TRUE(highest < ROB_TEST_COST / ROB_RATE_BASE_DIVISOR + ROB_TEST_COST / ROB_RATE_VOLATILE_DIVISOR);
	ASSERT_TRUE(highest > lowest);

	DestroyTestPlayer(playerid);
	TearDownRobTestProperty();

	TEST_END("RobPropertyRangeAndRate");
}

Test: RobberyLifecycle()
{
	TEST_START("RobberyLifecycle");

	EnsureTeamsLoaded();
	SetUpRobTestProperty();

	new
		robberid = CreateTestPlayer(),
		otherid = CreateTestPlayer(),
		userid = InsertTestUser("rob_tester");

	gPlayers[robberid][TeamID] = TEAM_ROBBERS;
	gPlayers[robberid][OrmID] = userid;
	gPlayers[robberid][WantedLevel] = 0;
	SetPlayerWantedLevel(robberid, 0);

	gPlayers[otherid][TeamID] = TEAM_ROBBERS;

	ASSERT_FALSE(IsPropertyBeingRobbed(ROB_TEST_SLOT));

	// The first robbery starts the mission
	StartRobbery(robberid, ROB_TEST_SLOT);

	ASSERT_TRUE(gRobMission[robberid][Active]);
	ASSERT_TRUE(gRobMission[robberid][Robbing]);
	ASSERT_TRUE(gPlayers[robberid][InMinigame]);
	ASSERT_EQ(gRobMission[robberid][PropertyArrayID], ROB_TEST_SLOT);
	ASSERT_EQ(gRobMission[robberid][TimeLeft], ROB_MISSION_COUNTDOWN_MS);
	ASSERT_TRUE(IsPropertyBeingRobbed(ROB_TEST_SLOT));

	// One robber at a time per shop
	StartRobbery(otherid, ROB_TEST_SLOT);
	ASSERT_FALSE(gRobMission[otherid][Robbing]);
	ASSERT_FALSE(gRobMission[otherid][Active]);

	// What UpdateRobbery() would have paid out over a couple of ticks
	gRobMission[robberid][Loot] = 1800;
	gRobMission[robberid][Earned] = 1800;
	gRobMission[robberid][TimeLeft] = 1000;

	new
		now = gettime();

	StopRobbery(robberid);

	ASSERT_FALSE(gRobMission[robberid][Robbing]);
	ASSERT_TRUE(gRobMission[robberid][Active]);
	ASSERT_EQ(gRobMission[robberid][RobbedCount], 1);
	ASSERT_EQ(gRobMission[robberid][PropertyArrayID], INVALID_PROPERTY_ID);
	ASSERT_FALSE(IsPropertyBeingRobbed(ROB_TEST_SLOT));

	// A successful robbery: wanted, the countdown starts over, and the shop
	// is locked and pays its tenant nothing for a while
	ASSERT_EQ(gPlayers[robberid][WantedLevel], 1);
	ASSERT_EQ(GetPlayerWantedLevel(robberid), 1);
	ASSERT_EQ(gRobMission[robberid][TimeLeft], ROB_MISSION_COUNTDOWN_MS);
	ASSERT_TRUE(gRobPropertyLockedUntil[ROB_TEST_SLOT] >= now + ROB_PROPERTY_LOCK_SECONDS);
	ASSERT_TRUE(gPropertyCommissionBlockedUntil[ROB_TEST_SLOT] >= now + ROB_COMMISSION_BLOCK_SECONDS);

	// Locked: nobody gets to rob it again right away
	StartRobbery(robberid, ROB_TEST_SLOT);
	ASSERT_FALSE(gRobMission[robberid][Robbing]);

	// Stopping with nothing taken still locks the shop, but counts for nothing
	gRobPropertyLockedUntil[ROB_TEST_SLOT] = 0;
	StartRobbery(robberid, ROB_TEST_SLOT);
	ASSERT_TRUE(gRobMission[robberid][Robbing]);

	StopRobbery(robberid);
	ASSERT_EQ(gRobMission[robberid][RobbedCount], 1);
	ASSERT_EQ(gPlayers[robberid][WantedLevel], 1);
	ASSERT_TRUE(gRobPropertyLockedUntil[ROB_TEST_SLOT] > now);

	// The run ends: saved as a high score, the minigame flag cleared
	new
		query[128];

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = %d AND user_id = %d AND value = 1800 AND spec_id = 1", TYPE_MISSION_ROB, userid);

	AbortRobMission(robberid);

	ASSERT_FALSE(gRobMission[robberid][Active]);
	ASSERT_FALSE(gPlayers[robberid][InMinigame]);
	ASSERT_EQ(gRobMission[robberid][Earned], 0);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE user_id = %d", userid);
	ExecDBStatement(query);
	DeleteTestUserByID(userid);

	DestroyTestPlayer(otherid);
	DestroyTestPlayer(robberid);
	TearDownRobTestProperty();

	TEST_END("RobberyLifecycle");
}

Test: RobberyRefusals()
{
	TEST_START("RobberyRefusals");

	EnsureTeamsLoaded();
	SetUpRobTestProperty();

	new
		playerid = CreateTestPlayer();

	// The tenant cannot rob their own shop
	gPlayers[playerid][TeamID] = TEAM_ROBBERS;
	gPlayers[playerid][OrmID] = ROB_TEST_OWNER_ID;

	StartRobbery(playerid, ROB_TEST_SLOT);
	ASSERT_FALSE(gRobMission[playerid][Robbing]);
	ASSERT_FALSE(gRobMission[playerid][Active]);

	// Busy with another minigame
	gPlayers[playerid][OrmID] = 0;
	gPlayers[playerid][InMinigame] = true;

	StartRobbery(playerid, ROB_TEST_SLOT);
	ASSERT_FALSE(gRobMission[playerid][Robbing]);
	ASSERT_FALSE(gRobMission[playerid][Active]);

	gPlayers[playerid][InMinigame] = false;

	// Keys other than the rob keys, or a rob key held down from before, are
	// left to the other key handlers. (Pressing one needs the robber on foot,
	// see the top of this file.)
	PlaceTestPlayer(playerid, ROB_TEST_X, ROB_TEST_Y, ROB_TEST_Z);
	gPlayers[playerid][TeamID] = TEAM_ROBBERS;

	new
		handled = HandleRobberyKeys(playerid, KEY_FIRE, KEY_NONE);

	ASSERT_EQ(handled, 0);

	handled = HandleRobberyKeys(playerid, KEY_WALK, KEY_WALK);
	ASSERT_EQ(handled, 0);
	ASSERT_FALSE(gRobMission[playerid][Robbing]);

	// Letting go of the key mid robbery stops it
	StartRobbery(playerid, ROB_TEST_SLOT);
	ASSERT_TRUE(gRobMission[playerid][Robbing]);

	handled = HandleRobberyKeys(playerid, KEY_NONE, KEY_JUMP);
	ASSERT_EQ(handled, 1);
	ASSERT_FALSE(gRobMission[playerid][Robbing]);

	// Leaving the Robberz ends the run on its next tick
	gPlayers[playerid][TeamID] = TEAM_NONE;
	UpdateRobMissionInfoText(playerid);
	ASSERT_FALSE(gRobMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);

	DestroyTestPlayer(playerid);
	TearDownRobTestProperty();

	TEST_END("RobberyRefusals");
}
