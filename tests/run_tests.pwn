/*
 *  run_tests.pwn - Compile and run tests
 */

#define RUNNING_TESTS
#define FILTERSCRIPT

#include <open.mp>
#include "includes/test_helpers.pwn"

#include "test_player.pwn"
//#include "test_vehicle.pwn"
//#include "test_business.pwn"

public OnGameModeInit()
{
	print("\n=== Starting SA-MP Pawn Tests ===\n");
    
	// Run all tests
	RUN_TEST(PlayerConnect);
	RUN_TEST(PlayerRegistration);
	//RUN_TEST(PlayerInventory);
	//RUN_TEST(VehicleCreation);
	//RUN_TEST(PlayerVehicleInteraction);
	//RUN_TEST(BankingSystem);
    
	// Print summary
	printf("\n=== Test Summary ===");
	printf("Total Tests: %d", gTotalTests);
	printf("Passed: %d", gTestsPassed);
	printf("Failed: %d", gTestsFailed);
	printf("Success Rate: %.1f%%\n\n", (float(gTestsPassed) / float(gTotalTests)) * 100.0);
    
	// Exit server after tests
	SetTimer("ExitAfterTests", 1000, false);
	return 1;
}

forward ExitAfterTests();
public ExitAfterTests()
{
	return SendRconCommand("exit");
}
