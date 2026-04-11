//
//  test_drugz.pwn
//

#define MAX_RATIO_VALUES 	2048

Test: BlackMarketRatioTrend()
{
	TEST_START("BlackMarketRatioTrend");

	new
		File: handle = fopen("ratio_trend.txt", io_write),
		stringToWrite[32];

	ASSERT_TRUE(handle != 0);

	if (!handle)
	{
		return;
	}

	for (new i = 0; i < MAX_RATIO_VALUES; i++)
	{
		CallRemoteFunction("UpdateBlackMarketRatio");
		
		format(stringToWrite, sizeof(stringToWrite), "%d %.3f\n", i, gBlackMarketRatio);
		fwrite(handle, stringToWrite);
	}

	fclose(handle);

	TEST_END("BlackMarketRatioTrend");
}


