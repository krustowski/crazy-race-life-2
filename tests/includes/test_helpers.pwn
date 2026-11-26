#if defined _CRL2_TEST_HELPERS
	#endinput
#endif
#define _CRL2_TEST_HELPERS

//
//  test_helpers.pwn
//

// Test statistics
new gTestsPassed = 0;
new gTestsFailed = 0;
new gTotalTests = 0;

new bool: gCurrentTestFailed = false;

//
//  Macros
//

#define TEST_START(%1) printf("\n=== Starting test: %s ===", %1)
#define TEST_END(%1) printf("=== Finished test: %s ===\n", %1)

#define RUN_TEST(%1) \
	gTotalTests++; \
	printf("\n[TEST %03d] Running: %s", gTotalTests, #%1); \
	%1(); \
	printf("[TEST %03d] Result: %s", gTotalTests, (gCurrentTestFailed) ? ("FAILED") : ("PASSED")); \
	if (gCurrentTestFailed) gTestsFailed++; else gTestsPassed++; \
	gCurrentTestFailed = false

stock _AssertFailed(const expression[], const file[], line)
{
	printf("[FAIL] Test: %s, File: %s, Line: %d", expression, file, line);
	gCurrentTestFailed = true;

	return 1;
}

// Evaluates its argument once, so asserting on a call with side effects
// (ASSERT_TRUE(TogglePrizeHidden(i)), ASSERT_EQ(LoadPlayerData(p), 1)) does
// not run it a second time.
#define ASSERT(%1) \
	if (!(%1)) \
		_AssertFailed(#%1, __file, __line)

#define ASSERT_EQ(%1,%2) 		ASSERT((%1)==(%2))
#define ASSERT_NE(%1,%2) 		ASSERT((%1)!=(%2))
#define ASSERT_TRUE(%1)  		ASSERT(%1)
#define ASSERT_FALSE(%1) 		ASSERT(!(%1))
#define ASSERT_STREQ(%1,%2)  	ASSERT(!strcmp(%1, %2))

// Configurable epsilon for float comparisons
#if !defined FLOAT_EQ_EPSILON
	#define FLOAT_EQ_EPSILON (0.0001)
#endif

stock bool: _FloatEq(Float: a, Float: b, Float: epsilon = FLOAT_EQ_EPSILON)
{
	return (floatabs(a - b) < epsilon);
}

#define ASSERT_FLOAT_EQ(%1,%2)      	ASSERT(_FloatEq(Float:%1, Float:%2))
#define ASSERT_FLOAT_EQ_EPS(%1,%2,%3) 	ASSERT(_FloatEq(Float:%1, Float:%2, Float:%3))

//
//  Stock helpers
// 

// Unique names: two players cannot share one, and a pooled NPC is renamed
// each time it is handed out.
static gTestPlayerSeq = 0;

// Test players are pooled. NPC_Destroy() only takes effect on a later server
// tick, and the whole suite runs inside main(), so every destroyed test NPC
// would keep its slot, and count towards the server's NPC limit (maxnpc), to
// the end of the run. DestroyTestPlayer() puts it back in the pool instead and
// CreateTestPlayer() hands it out again, looking like a fresh connection.
// (NPCs the code under test creates, such as taxi customers or rampage
// gunmen, come and go for real.)
#define MAX_TEST_PLAYERS	24

static
	gTestPlayerPool[MAX_TEST_PLAYERS] = {INVALID_PLAYER_ID, ...},
	bool: gTestPlayerInUse[MAX_TEST_PLAYERS];

// What a fresh connection looks like to the natives the tests read
stock ResetTestPlayerNatives(playerid)
{
	ResetPlayerMoney(playerid);
	ResetPlayerWeapons(playerid);
	SetPlayerWantedLevel(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerScore(playerid, 0);
	DisablePlayerRaceCheckpoint(playerid);
	DisablePlayerCheckpoint(playerid);
	SetPlayerAdmin(playerid, false);

	return 1;
}

// A test player is an open.mp NPC, i.e. a real connected player slot, so the
// code under test runs against the server's own money, health, weapon and
// connection state. Player ids are reused between tests and gPlayers[] (or a
// module's per-player arrays) is not wiped by ResetPlayerState(), so a test
// sets up any state it relies on.
stock CreateTestPlayer()
{
	new
		name[MAX_PLAYER_NAME],
		playerid = INVALID_PLAYER_ID;

	format(name, sizeof(name), "TestPlayer%d", gTestPlayerSeq++);

	for (new i = 0; i < MAX_TEST_PLAYERS && playerid == INVALID_PLAYER_ID; i++)
	{
		if (gTestPlayerPool[i] == INVALID_PLAYER_ID || gTestPlayerInUse[i])
		{
			continue;
		}

		// The code under test may have destroyed it (a taxi customer, say)
		if (!NPC_IsValid(gTestPlayerPool[i]))
		{
			gTestPlayerPool[i] = INVALID_PLAYER_ID;
			continue;
		}

		playerid = gTestPlayerPool[i];
		gTestPlayerInUse[i] = true;

		SetPlayerName(playerid, name);
	}

	if (playerid == INVALID_PLAYER_ID)
	{
		playerid = NPC_Create(name);

		if (playerid == INVALID_PLAYER_ID)
		{
			printf("[FAIL] Cannot create the NPC test player %s", name);
			gCurrentTestFailed = true;

			return INVALID_PLAYER_ID;
		}

		for (new i = 0; i < MAX_TEST_PLAYERS; i++)
		{
			if (gTestPlayerPool[i] == INVALID_PLAYER_ID)
			{
				gTestPlayerPool[i] = playerid;
				gTestPlayerInUse[i] = true;
				break;
			}
		}
	}

	ResetTestPlayerNatives(playerid);
	ResetPlayerState(playerid);
	format(gPlayers[playerid][Name], MAX_PLAYER_NAME, "%s", name);

	// Once a test has loaded the quests, anything that fires a quest event
	// could pay a reward and throw off the money a test counts. A test player
	// starts with every quest done; the quest tests call ResetPlayerQuests().
	for (new i = 0; i < MAX_QUESTS; i++)
	{
		gPlayerQuests[playerid][i][Completed] = true;
	}

	return playerid;
}

// Puts a test player at a point. NPC_SetPos() does nothing to an NPC that has
// not spawned yet, so this spawns it first.
stock PlaceTestPlayer(playerid, Float: X, Float: Y, Float: Z)
{
	if (!NPC_IsSpawned(playerid))
	{
		NPC_Spawn(playerid);
	}

	return NPC_SetPos(playerid, X, Y, Z);
}

stock DestroyTestPlayer(playerid)
{
	if (playerid == INVALID_PLAYER_ID)
	{
		return 0;
	}

	ResetPlayerState(playerid);

	for (new i = 0; i < MAX_TEST_PLAYERS; i++)
	{
		if (gTestPlayerPool[i] == playerid)
		{
			gTestPlayerInUse[i] = false;
			return 1;
		}
	}

	return NPC_Destroy(playerid);
}

// A timer callback that does nothing: for a test that needs a mission timer
// running, to see that the code under test stops it.
forward TestIdleTimer(playerid);
public TestIdleTimer(playerid)
{
#pragma unused playerid
	return 1;
}

// The state the deal dialogs leave behind once <dealerid> has offered
// <playerid> 100 g of zaza at $100 a gram and <playerid> has accepted.
stock SetUpDealOffer(playerid, dealerid)
{
	gPlayers[playerid][AcceptedDeal] = true;

	gPlayers[playerid][SelectedDrugAmount] = 100;
	gPlayers[dealerid][SelectedDrugAmount] = 100;
	gPlayers[playerid][SelectedDrugValue] = 100;
	gPlayers[dealerid][SelectedDrugValue] = 100;
	gPlayers[playerid][SelectedDrugID] = TYPE_ZAZA;
	gPlayers[dealerid][SelectedDrugID] = TYPE_ZAZA;
	gPlayers[playerid][DealPlayerTargetID] = dealerid;
	gPlayers[dealerid][DealPlayerTargetID] = playerid;

	return 1;
}

// Runs a query that returns a single number (COUNT(*), a column of one row)
// and returns it, or -1 when the query fails.
stock QueryTestInt(const query[])
{
	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		printf("[FAIL] Query failed: %s", query);
		gCurrentTestFailed = true;

		return -1;
	}

	new
		value = DB_GetFieldInt(result, 0);

	DB_FreeResultSet(result);
	return value;
}

// A users row for <nickname> (any earlier one is replaced), for tests that
// need an OrmID the DB writes can refer to. Returns the new users.id.
stock InsertTestUser(const nickname[])
{
	new
		query[256];

	format(query, sizeof(query), "DELETE FROM users WHERE nickname = '%q'", nickname);
	ExecDBStatement(query);

	format(query, sizeof(query), "INSERT INTO users (nickname, pwdhash, salt, cash, bank, team, class, health, armour, spawn, properties) VALUES ('%q', '', '', 0, 0, 0, 0, 100, 0, 0, '0,0,0,0,0,0,0')", nickname);
	ExecDBStatement(query);

	format(query, sizeof(query), "SELECT id FROM users WHERE nickname = '%q'", nickname);
	return QueryTestInt(query);
}

stock DeleteTestUserByID(userid)
{
	new
		query[96];

	format(query, sizeof(query), "DELETE FROM users WHERE id = %d", userid);
	return ExecDBStatement(query);
}

// InitTeams() fills gTeams[] from the teams table once; IsPlayerInTeam() and
// anything else that maps a TeamID through gTeams[] needs it.
stock EnsureTeamsLoaded()
{
	if (!gTeams[0][ID])
	{
		InitTeams();
	}

	return 1;
}

// Pickups the code under test leaves behind are gone after this; a test that
// expects a pickup to be destroyed asserts !IsValidPickup() instead.
stock DestroyTestPickup(pickupid)
{
	if (pickupid > 0 && IsValidPickup(pickupid))
	{
		DestroyPickup(pickupid);
	}

	return 1;
}
