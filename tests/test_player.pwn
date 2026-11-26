//
//  test_player.pwn
//

Test: PlayerConnect()
{
	TEST_START("PlayerConnect");

	new
		name[MAX_PLAYER_NAME],
		playerid = CreateTestPlayer();

	ASSERT_TRUE(IsPlayerConnected(playerid));

	GetPlayerName(playerid, name, sizeof(name));
	ASSERT_STREQ(name, gPlayers[playerid][Name]);

	// A fresh connection has no money and is not logged in yet
	ASSERT_EQ(GetPlayerMoney(playerid), 0);
	ASSERT_FALSE(gPlayers[playerid][IsLogged]);

	// (No IsPlayerConnected() check after this: an NPC leaves on a later tick)
	DestroyTestPlayer(playerid);

	TEST_END("PlayerConnect");
}

stock DeleteTestUser(const nickname[])
{
	new
		query[128];

	format(query, sizeof(query), "DELETE FROM users WHERE nickname = '%q'", nickname);
	ExecDBStatement(query);
}

stock CountTestUsers(const nickname[])
{
	new
		query[128];

	format(query, sizeof(query), "SELECT id FROM users WHERE nickname = '%q'", nickname);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		return -1;
	}

	new
		count = DB_GetRowCount(result);

	DB_FreeResultSet(result);
	return count;
}

Test: PlayerRegistration()
{
	TEST_START("PlayerRegistration");

	new
		playerid = CreateTestPlayer(),
		reg,
		users;

	// So that the test also passes on a DB an earlier run left behind
	DeleteTestUser("tester");

	format(gPlayers[playerid][Name], MAX_PLAYER_NAME, "tester");

	reg = SetPlayerAccountRegistration(playerid, "test1234");
	ASSERT_TRUE(reg == 1);

	// (ASSERT stringifies its argument, so no string literals inside it)
	users = CountTestUsers("tester");
	ASSERT_EQ(users, 1);
	ASSERT_TRUE(gPlayers[playerid][IsLogged]);
	ASSERT_TRUE(gPlayers[playerid][OrmID] > 0);

	// The nickname is taken now
	reg = SetPlayerAccountRegistration(playerid, "test1234");
	ASSERT_TRUE(reg == 0);
	users = CountTestUsers("tester");
	ASSERT_EQ(users, 1);

	// And the password works for logging in, a wrong one does not
	gPlayers[playerid][IsLogged] = false;
	reg = SetPlayerAccountLogin(playerid, "wrong-password");
	ASSERT_EQ(reg, 0);
	ASSERT_FALSE(gPlayers[playerid][IsLogged]);
	reg = SetPlayerAccountLogin(playerid, "test1234");
	ASSERT_EQ(reg, 1);
	ASSERT_TRUE(gPlayers[playerid][IsLogged]);

	DeleteTestUser("tester");
	DestroyTestPlayer(playerid);

	TEST_END("PlayerRegistration");
}

Test: PlayerDealConfirmation()
{
	TEST_START("PlayerDealConfirmation");

	new
		deal,
		playerid = CreateTestPlayer(),
		dealerid = CreateTestPlayer();

	gPlayers[playerid][Drugs][ZAZA] = 0;
	gPlayers[dealerid][Drugs][ZAZA] = 100;

	// Not enough money: nothing changes hands
	SetUpDealOffer(playerid, dealerid);

	deal = ProcessDealOffer(playerid);
	ASSERT_TRUE(deal == 0);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 0);
	ASSERT_EQ(gPlayers[dealerid][Drugs][ZAZA], 100);

	// The dealer got rid of the drugs after making the offer: the deal is off,
	// rather than the buyer getting drugs the dealer no longer has
	GivePlayerMoney(playerid, 10000);
	gPlayers[dealerid][Drugs][ZAZA] = 0;
	SetUpDealOffer(playerid, dealerid);

	deal = ProcessDealOffer(playerid);
	ASSERT_TRUE(deal == 0);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 0);
	ASSERT_EQ(gPlayers[dealerid][Drugs][ZAZA], 0);
	ASSERT_EQ(GetPlayerMoney(playerid), 10000);
	ASSERT_EQ(GetPlayerMoney(dealerid), 0);

	// Successful deal: 100 g at $100 a gram
	gPlayers[dealerid][Drugs][ZAZA] = 100;
	SetUpDealOffer(playerid, dealerid);

	deal = ProcessDealOffer(playerid);
	ASSERT_TRUE(deal == 1);
	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 100);
	ASSERT_EQ(gPlayers[dealerid][Drugs][ZAZA], 0);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);
	ASSERT_EQ(GetPlayerMoney(dealerid), 10000);

	gPlayers[playerid][Drugs][ZAZA] = 0;

	DestroyTestPlayer(dealerid);
	DestroyTestPlayer(playerid);

	TEST_END("PlayerDealConfirmation");
}

Test: PlayerSaveAndLoad()
{
	TEST_START("PlayerSaveAndLoad");

	new
		playerid = CreateTestPlayer(),
		password[] = "test1234",
		nickname[] = "save_tester";

	DeleteTestUser(nickname);
	format(gPlayers[playerid][Name], MAX_PLAYER_NAME, "%s", nickname);

	ASSERT_EQ(SetPlayerAccountRegistration(playerid, password), 1);

	// A new account starts with $10000 and no drugz row
	ASSERT_EQ(GetPlayerMoney(playerid), 10000);
	ASSERT_EQ(gPlayers[playerid][Bank], 0);

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 4321);
	SetPlayerWantedLevel(playerid, 3);
	SetPlayerSkin(playerid, 250);

	gPlayers[playerid][Bank] = 98765;
	gPlayers[playerid][TeamID] = TEAM_TRUCKERS;
	gPlayers[playerid][SpawnPoint] = 0;
	gPlayers[playerid][Locale] = LOCALE_CZ;
	gPlayers[playerid][PlayTime] = 123000;
	gPlayers[playerid][HDVersion] = true;

	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		gPlayers[playerid][Properties][i] = 0;
	}

	gPlayers[playerid][Properties][0] = 11;
	gPlayers[playerid][Properties][2] = 22;

	for (new i = 0; i < MAX_DRUG_TYPES; i++)
	{
		gPlayers[playerid][Drugs][i] = 0;
	}

	gPlayers[playerid][Drugs][ZAZA] = 12;
	gPlayers[playerid][Drugs][COCAINE] = 3;
	gPlayers[playerid][Drugs][JOINT] = 1;

	ASSERT_EQ(SavePlayerData(playerid), 1);

	new
		query[128];

	format(query, sizeof(query), "SELECT cash FROM users WHERE nickname = '%q'", nickname);
	ASSERT_EQ(QueryTestInt(query), 4321);

	format(query, sizeof(query), "SELECT zaza FROM drugz WHERE owner_id = %d AND owner_type = 1", gPlayers[playerid][OrmID]);
	ASSERT_EQ(QueryTestInt(query), 12);

	// Everything wiped, as on a fresh connection, then loaded back
	ResetPlayerMoney(playerid);
	SetPlayerWantedLevel(playerid, 0);

	gPlayers[playerid][Bank] = 0;
	gPlayers[playerid][WantedLevel] = 0;
	gPlayers[playerid][TeamID] = TEAM_NONE;
	gPlayers[playerid][Skin] = 0;
	gPlayers[playerid][Locale] = LOCALE_EN;
	gPlayers[playerid][PlayTime] = 0;
	gPlayers[playerid][HDVersion] = false;
	gPlayers[playerid][Properties][0] = 0;
	gPlayers[playerid][Properties][2] = 0;
	gPlayers[playerid][Drugs][ZAZA] = 0;
	gPlayers[playerid][Drugs][COCAINE] = 0;
	gPlayers[playerid][Drugs][JOINT] = 0;

	ASSERT_EQ(LoadPlayerData(playerid), 1);

	ASSERT_EQ(GetPlayerMoney(playerid), 4321);
	ASSERT_EQ(gPlayers[playerid][Bank], 98765);
	ASSERT_EQ(gPlayers[playerid][WantedLevel], 3);
	ASSERT_EQ(GetPlayerWantedLevel(playerid), 3);
	ASSERT_TRUE(gPlayers[playerid][TeamID] == TEAM_TRUCKERS);
	ASSERT_EQ(gPlayers[playerid][Skin], 250);
	ASSERT_TRUE(gPlayers[playerid][Locale] == LOCALE_CZ);
	ASSERT_EQ(gPlayers[playerid][PlayTime], 123000);
	ASSERT_TRUE(gPlayers[playerid][HDVersion]);

	ASSERT_EQ(gPlayers[playerid][Properties][0], 11);
	ASSERT_EQ(gPlayers[playerid][Properties][1], 0);
	ASSERT_EQ(gPlayers[playerid][Properties][2], 22);

	ASSERT_EQ(gPlayers[playerid][Drugs][ZAZA], 12);
	ASSERT_EQ(gPlayers[playerid][Drugs][COCAINE], 3);
	ASSERT_EQ(gPlayers[playerid][Drugs][JOINT], 1);
	ASSERT_EQ(gPlayers[playerid][Drugs][FENT], 0);

	// Not logged in: nothing is written or read
	gPlayers[playerid][IsLogged] = false;
	GivePlayerMoney(playerid, 1);

	ASSERT_EQ(LoadPlayerData(playerid), 0);
	SavePlayerData(playerid);

	format(query, sizeof(query), "SELECT cash FROM users WHERE nickname = '%q'", nickname);
	ASSERT_EQ(QueryTestInt(query), 4321);

	format(query, sizeof(query), "DELETE FROM drugz WHERE owner_id = %d AND owner_type = 1", gPlayers[playerid][OrmID]);
	ExecDBStatement(query);
	DeleteTestUser(nickname);

	for (new i = 0; i < MAX_DRUG_TYPES; i++)
	{
		gPlayers[playerid][Drugs][i] = 0;
	}

	gPlayers[playerid][Bank] = 0;
	gPlayers[playerid][WantedLevel] = 0;
	ResetPlayerMoney(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("PlayerSaveAndLoad");
}
