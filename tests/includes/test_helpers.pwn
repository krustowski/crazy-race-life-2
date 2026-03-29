/*
 *  test_helpers.inc
 */

#define ASSERT(%1) \
    if (!(%1)) \
        printf("[FAIL] Test: %s, File: %s, Line: %d", #%1, __file, __line)

#define ASSERT_EQ(%1,%2) ASSERT((%1) == (%2))
#define ASSERT_NE(%1,%2) ASSERT((%1) != (%2))
#define ASSERT_TRUE(%1) ASSERT(%1)
#define ASSERT_FALSE(%1) ASSERT(!(%1))

#define TEST_START(%1) printf("\n=== Starting test: %s ===", %1)
#define TEST_END(%1) printf("=== Finished test: %s ===\n", %1)

// Mock player for testing
static gTestPlayer = INVALID_PLAYER_ID;

stock CreateTestPlayer()
{
	// Simulate player connection
	gTestPlayer = 0; // Use player 0 as test player
	CallLocalFunction("OnPlayerConnect", "d", gTestPlayer);
    
	return gTestPlayer;
}

stock DestroyTestPlayer()
{
	if (gTestPlayer != INVALID_PLAYER_ID)
	{
		CallLocalFunction("OnPlayerDisconnect", "dd", gTestPlayer, 0);
		gTestPlayer = INVALID_PLAYER_ID;
	}
}

SetupTest()
{
    	// Reset global state
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		g_PlayerLoggedIn[i] = false;
	}

    	// Clear test data
	ClearProperties();
    	ClearVehicles();
}

TeardownTest()
{
	// Clean up any created objects
	// Reset mock data
}
