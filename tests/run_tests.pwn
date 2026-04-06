#define _CRL2_TEST_BUILD

//
//  run_tests.pwn
//  Compile and run tests
//

#define RUNNING_TESTS
#define FILTERSCRIPT

#include <open.mp>

#include "includes/mock_samp.pwn"
#include "support/includes.pwn"

#include "includes/test_helpers.pwn"

#include "test_memory.pwn"
#include "test_pickup.pwn"
#include "test_player.pwn"
//#include "test_vehicle.pwn"
//#include "test_business.pwn"

//public OnGameModeInit()
main()
{
	print("\n=== Starting SA-MP Pawn Tests ===\n");

	// Run all tests
	RUN_TEST(MemoryInit);
	
	RUN_TEST(PickupCreate);
    
	RUN_TEST(PlayerConnect);
	RUN_TEST(PlayerRegistration);
	RUN_TEST(PlayerDealConfirmation);
	//RUN_TEST(PlayerInventory);
	//RUN_TEST(VehicleCreation);
	//RUN_TEST(PlayerVehicleInteraction);
	//RUN_TEST(BankingSystem);
    
	// Print summary
	printf("\n\n=== Test Summary ===\n");
	printf("Total Tests: %d", gTotalTests);
	printf("Passed: %d", gTestsPassed);
	printf("Failed: %d", gTestsFailed);
	printf("Success Rate: %.1f%%\n\n", (float(gTestsPassed) / float(gTotalTests)) * 100.0);
    
	// Exit server after tests
	SetTimer("ExitAfterTests", 1000, false);
	return 1;
}

