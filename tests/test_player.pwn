//
//  test_player.pwn
//

Test: PlayerConnect()
{
	TEST_START("PlayerConnect");
	
	new 
		Float: health,
		name[MAX_PLAYER_NAME],
		playerid = CreateTestPlayer();
    
	// Test registration system
	GetPlayerName(playerid, name, sizeof(name));
	ASSERT_TRUE(strlen(name) > 0);
    
	// Test default values
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	GetPlayerHealth(playerid, health);
	ASSERT_FLOAT_EQ(health, 0.0);
    
	DestroyTestPlayer();

	TEST_END("PlayerConnect");
}

Test: PlayerRegistration()
{
	TEST_START("PlayerRegistration");
	
	new 
		playerid = CreateTestPlayer(),
		reg;

	InitDB();

	format(gPlayers[playerid][Name], MAX_PLAYER_NAME, "tester");

	reg = SetPlayerAccountRegistration(playerid, "test1234");
	ASSERT_TRUE(reg == 1);

	reg = SetPlayerAccountRegistration(playerid, "test1234");
	ASSERT_TRUE(reg == 0);

	DestroyTestPlayer();

	TEST_END("PlayerRegistration");
}

Test: PlayerDealConfirmation()
{
	TEST_START("PlayerDealConfirmation");

	new
		deal,
		testAmount = 0,
		playerid = CreateTestPlayer(),
		dealerid = CreateTestPlayer();

	//printf("playerid: %d (%d), dealerid: %d (%d)", playerid, IsPlayerConnected(playerid), dealerid, IsPlayerConnected(dealerid));

	MockPlayerDealState(playerid, dealerid);

	// Not enough money
	deal = ProcessDealOffer(playerid);
	ASSERT_TRUE(deal == 0);

	// Test the deal amount received
	testAmount = gPlayers[playerid][Drugs][_: TYPE_ZAZA];
	ASSERT_EQ(testAmount, 0);

	MockPlayerDealState(playerid, dealerid);
	GivePlayerMoney(playerid, 10000);

	// Successful deal
	deal = ProcessDealOffer(playerid);
	ASSERT_TRUE(deal == 1);

	// Test the deal amount received
	testAmount = gPlayers[playerid][Drugs][_: TYPE_ZAZA];
	ASSERT_EQ(testAmount, 100);

	DestroyTestPlayer();
	DestroyTestPlayer();

	TEST_END("PlayerDealConfirmation");
}
