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

new bool:gCurrentTestFailed = false;

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

#define ASSERT(%1) \
	if (!(%1)) \
        printf("[FAIL] Test: %s, File: %s, Line: %d", #%1, __file, __line); \
	if (!(%1)) \
	gCurrentTestFailed = true

#define ASSERT_EQ(%1,%2) 	ASSERT((%1)==(%2))
#define ASSERT_NE(%1,%2) 	ASSERT((%1)!=(%2))
#define ASSERT_TRUE(%1)  	ASSERT(%1)
#define ASSERT_FALSE(%1) 	ASSERT(!(%1))
#define ASSERT_STREQ(%1,%2)  	ASSERT(!strcmp(%1, %2))

// Configurable epsilon for float comparisons
#if !defined FLOAT_EQ_EPSILON
	#define FLOAT_EQ_EPSILON (0.0001)
#endif

stock bool:_FloatEq(Float:a, Float:b, Float:epsilon = FLOAT_EQ_EPSILON) {
	return (floatabs(a - b) < epsilon);
}

#define ASSERT_FLOAT_EQ(%1,%2)      	ASSERT(_FloatEq(Float:%1, Float:%2))
#define ASSERT_FLOAT_EQ_EPS(%1,%2,%3) 	ASSERT(_FloatEq(Float:%1, Float:%2, Float:%3))

//
//  Public
//

forward ExitAfterTests();
public ExitAfterTests()
{
	return SendRconCommand("exit");
}

//
//  Stock helpers
// 

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

	return 1;
}

SetupTest()
{
    	// Reset global state
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		gPlayerLoggedIn[i] = false;
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
