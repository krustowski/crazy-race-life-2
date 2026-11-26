#define _CRL2_TEST_BUILD

//
//  run_tests.pwn
//  Compile and run tests
//

#define RUNNING_TESTS
#define FILTERSCRIPT

// No mocks: this runs on ./omp-server against the real open.mp natives, with
// NPCs standing in for players and a DB built from sql/migrations (see the
// `tests` target in the Makefile).

// includes.pwn pulls in open.mp itself, after setting MAX_PLAYERS & co.
#include "support/includes.pwn"

#include "includes/test_helpers.pwn"

#include "test_memory.pwn"
#include "test_pickup.pwn"
#include "test_player.pwn"
#include "test_drugz.pwn"
#include "test_anticheat.pwn"
#include "test_utils.pwn"
#include "test_team.pwn"
#include "test_quest.pwn"
#include "test_bank.pwn"
#include "test_prizes.pwn"
#include "test_fuel.pwn"
#include "test_rob.pwn"
#include "test_bribe.pwn"
#include "test_deathmatch.pwn"
#include "test_real.pwn"
#include "test_taxistop.pwn"
#include "test_tow.pwn"
#include "test_autosave.pwn"
#include "test_race.pwn"
#include "test_trucking.pwn"
#include "test_taxi.pwn"
#include "test_rampage.pwn"
#include "test_combat.pwn"
#include "test_admin.pwn"

//public OnGameModeInit()
main()
{
	print("\n=== Starting SA-MP Pawn Tests ===\n");

	InitDB();

	// Run all tests
	RUN_TEST(MemoryInit);
	
	RUN_TEST(PickupCreate);
	RUN_TEST(DeathMoneyPickups);
    
	RUN_TEST(PlayerConnect);
	RUN_TEST(PlayerRegistration);
	RUN_TEST(PlayerDealConfirmation);
	RUN_TEST(PlayerSaveAndLoad);

	RUN_TEST(BlackMarketRatioTrend);
	RUN_TEST(BlackMarketRatioBounds);
	RUN_TEST(BlackMarketRatioBoom);
	RUN_TEST(BlackMarketRatioBoomUnderSales);
	RUN_TEST(MarketBoomSchedule);
	RUN_TEST(FenceSalePushesRatioDown);
	RUN_TEST(FencePricing);
	RUN_TEST(FenceRejectsAwayFromDruggery);
	RUN_TEST(FenceSaleWithinLimits);

	RUN_TEST(AntiCheatLedger);
	RUN_TEST(AntiCheatJudgeWeapons);

	RUN_TEST(HelpersStrings);
	RUN_TEST(HelpersUnixToDateTime);
	RUN_TEST(HelpersWeaponModel);
	RUN_TEST(HelpersListParsing);

	RUN_TEST(TeamsLoadFromDB);
	RUN_TEST(TeamMembership);

	RUN_TEST(QuestsLoadFromDB);
	RUN_TEST(QuestCountedProgress);
	RUN_TEST(QuestAmountIsCapped);
	RUN_TEST(QuestLevelProgress);
	RUN_TEST(QuestsSkipBadRows);

	RUN_TEST(BankDepositAndWithdraw);
	RUN_TEST(BankATMLocations);

	RUN_TEST(PrizeTypes);
	RUN_TEST(PrizesLoadAndPayOut);

	RUN_TEST(GasStationsLoadFromDB);
	RUN_TEST(GasStationRangeAndPumping);
	RUN_TEST(GasStationStockRoundTrip);

	RUN_TEST(RobPropertyRangeAndRate);
	RUN_TEST(RobberyLifecycle);
	RUN_TEST(RobberyRefusals);

	RUN_TEST(PoliceBribePickups);

	RUN_TEST(DeathmatchRegistration);
	RUN_TEST(WantedLevelOnKill);

	RUN_TEST(RealEstateOwnership);
	RUN_TEST(TaxiStopSchedule);
	RUN_TEST(TowModelBonus);

	RUN_TEST(RealEstateAutosave);
	RUN_TEST(PlayersAutosave);

	RUN_TEST(RacesLoadFromDB);
	RUN_TEST(RacePositions);
	RUN_TEST(RaceCheckpointsToFinish);
	RUN_TEST(RaceSaveFromEditor);

	RUN_TEST(TruckingPointsLoadFromDB);
	RUN_TEST(TruckingNextDestination);
	RUN_TEST(TruckingDeliveryPays);
	RUN_TEST(TruckingAbortSavesScore);

	RUN_TEST(TaxiDestinations);
	RUN_TEST(TaxiCustomerNearby);
	RUN_TEST(TaxiDeliveryPays);
	RUN_TEST(TaxiAbortStopsEverything);

	RUN_TEST(RampageStartAndAbort);
	RUN_TEST(RampageTimeRunsOut);

	RUN_TEST(CombatMissionRun);

	RUN_TEST(AdminLevelByRconAdmin);
	RUN_TEST(AdminLevelByAdmin);
    
	// Print summary
	printf("\n\n=== Test Summary ===\n");
	printf("Total Tests: %d", gTotalTests);
	printf("Passed: %d", gTestsPassed);
	printf("Failed: %d", gTestsFailed);
	printf("Success Rate: %.1f%%\n\n", (float(gTestsPassed) / float(gTotalTests)) * 100.0);

	DB_Close(gDbConnectionHandle);

	// The server keeps running: omp-server ignores SendRconCommand("exit").
	// `make tests` stops it once the summary above is in log.txt.
	return 1;
}

