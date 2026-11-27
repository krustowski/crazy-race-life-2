//
//  test_taxistop.pwn
//  Where an ambient taxi is along its loop of recordings, and so when it pulls
//  up at its stops. A test NPC stands in for the taxi driver; the driver is
//  never really driving, the loop clock is all made up.
//

#define TAXI_TEST_IDX		0
#define TAXI_TEST_LOOP_MS	10000
// How far into the loop the taxi is when the test starts
#define TAXI_TEST_NOW_MS	3000
// The test itself takes a few ms of GetTickCount()
#define TAXI_TEST_SLACK_MS	250

stock SetUpTestTaxiStop(stopid, loopMs, duration, propertyid, Float: X, Float: Y)
{
	gTaxiStops[stopid][TaxiIdx] = TAXI_TEST_IDX;
	gTaxiStops[stopid][LoopMs] = loopMs;
	gTaxiStops[stopid][Duration] = duration;
	gTaxiStops[stopid][PropertyID] = propertyid;
	gTaxiStops[stopid][Curb][CoordX] = X;
	gTaxiStops[stopid][Curb][CoordY] = Y;
	gTaxiStops[stopid][Curb][CoordZ] = 10.0;

	return 1;
}

stock bool: IsNearMs(value, expected)
{
	return (value >= expected - TAXI_TEST_SLACK_MS && value <= expected + TAXI_TEST_SLACK_MS);
}

Test: TaxiStopSchedule()
{
	TEST_START("TaxiStopSchedule");

	new
		driverid = CreateTestPlayer();

	// Not driving yet: nowhere along its loop
	gTaxiDriverNPC[TAXI_TEST_IDX] = driverid;
	gTaxiLoopMs[TAXI_TEST_IDX] = TAXI_TEST_LOOP_MS;
	gTaxiPlaybackStarted[TAXI_TEST_IDX] = false;

	ASSERT_EQ(GetTaxiLoopTime(TAXI_TEST_IDX), -1);

	// The first segment has been playing for TAXI_TEST_NOW_MS
	gTaxiPlaybackStarted[TAXI_TEST_IDX] = true;
	gTaxiPlaybackNo[TAXI_TEST_IDX] = 1;
	gTaxiSegmentStart[TAXI_TEST_IDX][0] = 0;
	gTaxiPlaybackTick[TAXI_TEST_IDX] = GetTickCount() - TAXI_TEST_NOW_MS;

	// Three stops along the loop: one it stood at a second ago (and still
	// stands at), one ahead, and a third one at the same shop as the first
	SetUpTestTaxiStop(0, 2000, 5000, 1, 100.0, 100.0);
	SetUpTestTaxiStop(1, 6000, 1000, 2, 900.0, 900.0);
	SetUpTestTaxiStop(2, 8000, 1000, 1, 110.0, 100.0);

	gTaxiStopCount = 3;
	gTaxiFirstStop[TAXI_TEST_IDX] = 0;
	gTaxiStopTotal[TAXI_TEST_IDX] = 3;

	new
		now = GetTaxiLoopTime(TAXI_TEST_IDX);

	ASSERT_TRUE(IsNearMs(now, TAXI_TEST_NOW_MS));

	// Coming up next, and the ones behind it wrap round the loop
	ASSERT_EQ(GetTaxiNextStop(TAXI_TEST_IDX), 1);
	ASSERT_TRUE(IsNearMs(GetTaxiStopETA(1), 6000 - TAXI_TEST_NOW_MS));
	ASSERT_TRUE(IsNearMs(GetTaxiStopETA(0), TAXI_TEST_LOOP_MS + 2000 - TAXI_TEST_NOW_MS));

	// Stops 0 and 2 are one stop to a player: same shop, 10 m apart
	ASSERT_TRUE(IsSameTaxiStop(0, 2));
	ASSERT_FALSE(IsSameTaxiStop(0, 1));
	ASSERT_TRUE(IsNearMs(GetTaxiStopSoonestETA(0), 8000 - TAXI_TEST_NOW_MS));

	// The cab is still standing at stop 0, not at stop 1
	ASSERT_TRUE(IsTaxiStandingAtStop(0));
	ASSERT_FALSE(IsTaxiStandingAtStop(1));

	new
		Float: distance;

	ASSERT_EQ(GetNearestTaxiStop(880.0, 900.0, 10.0, distance), 1);
	ASSERT_FLOAT_EQ_EPS(distance, 20.0, 0.01);

	// Past the last stop, the loop starts over at the first
	gTaxiPlaybackTick[TAXI_TEST_IDX] = GetTickCount() - 9000;
	ASSERT_EQ(GetTaxiNextStop(TAXI_TEST_IDX), 0);

	// Without the driver the taxi cannot be followed at all
	gTaxiPlaybackStarted[TAXI_TEST_IDX] = false;
	ASSERT_EQ(GetTaxiNextStop(TAXI_TEST_IDX), -1);
	ASSERT_EQ(GetTaxiStopETA(1), -1);
	ASSERT_EQ(GetNearestTaxiStop(880.0, 900.0, 10.0, distance), -1);

	gTaxiStopCount = 0;
	gTaxiStopTotal[TAXI_TEST_IDX] = 0;
	gTaxiLoopMs[TAXI_TEST_IDX] = 0;
	gTaxiPlaybackNo[TAXI_TEST_IDX] = 0;
	gTaxiPlaybackTick[TAXI_TEST_IDX] = 0;
	gTaxiDriverNPC[TAXI_TEST_IDX] = 0;

	DestroyTestPlayer(driverid);

	TEST_END("TaxiStopSchedule");
}
