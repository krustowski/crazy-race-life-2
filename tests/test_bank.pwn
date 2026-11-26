//
//  test_bank.pwn
//

Test: BankDepositAndWithdraw()
{
	TEST_START("BankDepositAndWithdraw");

	new
		playerid = CreateTestPlayer();

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 5000);
	gPlayers[playerid][Bank] = 0;

	DepositMoneyToBankAccount(playerid, 3000);
	ASSERT_EQ(gPlayers[playerid][Bank], 3000);
	ASSERT_EQ(GetPlayerMoney(playerid), 2000);

	// More than in the pocket
	DepositMoneyToBankAccount(playerid, 2001);
	ASSERT_EQ(gPlayers[playerid][Bank], 3000);
	ASSERT_EQ(GetPlayerMoney(playerid), 2000);

	// All of it
	DepositMoneyToBankAccount(playerid, 2000);
	ASSERT_EQ(gPlayers[playerid][Bank], 5000);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	// More than in the account
	WithdrawMoneyFromBankAccount(playerid, 5001);
	ASSERT_EQ(gPlayers[playerid][Bank], 5000);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	WithdrawMoneyFromBankAccount(playerid, 1500);
	ASSERT_EQ(gPlayers[playerid][Bank], 3500);
	ASSERT_EQ(GetPlayerMoney(playerid), 1500);

	ResetPlayerMoney(playerid);
	gPlayers[playerid][Bank] = 0;
	DestroyTestPlayer(playerid);

	TEST_END("BankDepositAndWithdraw");
}

Test: BankATMLocations()
{
	TEST_START("BankATMLocations");

	new
		rows = QueryTestInt("SELECT COUNT(*) FROM atm_coords");

	ASSERT_TRUE(InitBankLocations());

	new
		loaded = 0;

	for (new i = 0; i < MAX_ATM_PICKUPS; i++)
	{
		if (gBankLocation[i][3] > 0.0)
		{
			loaded++;
		}
	}

	ASSERT_EQ(loaded, min(rows, MAX_ATM_PICKUPS));

	new
		playerid = CreateTestPlayer();

	// By the first ATM, and a few metres off it
	PlaceTestPlayer(playerid, gBankLocation[0][0], gBankLocation[0][1], gBankLocation[0][2]);
	ASSERT_TRUE(CheckPlayerBankLocation(playerid));

	PlaceTestPlayer(playerid, gBankLocation[0][0] + 5.0, gBankLocation[0][1], gBankLocation[0][2]);
	ASSERT_TRUE(CheckPlayerBankLocation(playerid));

	// Up in the sky over it
	PlaceTestPlayer(playerid, gBankLocation[0][0], gBankLocation[0][1], gBankLocation[0][2] + 500.0);
	ASSERT_FALSE(CheckPlayerBankLocation(playerid));

	DestroyTestPlayer(playerid);

	TEST_END("BankATMLocations");
}
