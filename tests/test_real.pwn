//
//  test_real.pwn
//

// gProperties[] is not loaded in the tests, so the tail end of it is free for
// a handful of made-up properties.
#define REAL_TEST_FIRST_SLOT		(MAX_PROPERTIES - 6)
#define REAL_TEST_COUNT				5
#define REAL_TEST_FIRST_ID			99101
#define REAL_TEST_USER_ID			777001

stock SetUpRealTestProperty(slot, id, PropertyType: type, userid, bool: occupied)
{
	gProperties[slot][ID] = id;
	gProperties[slot][Type] = type;
	gProperties[slot][UserID] = userid;
	gProperties[slot][Occupied] = occupied;

	return 1;
}

stock TearDownRealTestProperties()
{
	for (new i = 0; i < REAL_TEST_COUNT; i++)
	{
		SetUpRealTestProperty(REAL_TEST_FIRST_SLOT + i, 0, PROPERTY_TYPE_NONE, 0, false);
	}

	return 1;
}

Test: RealEstateOwnership()
{
	TEST_START("RealEstateOwnership");

	new
		playerid = CreateTestPlayer(),
		s = REAL_TEST_FIRST_SLOT;

	gPlayers[playerid][OrmID] = REAL_TEST_USER_ID;

	// No commercial properties at all
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 0);

	// Four shops: one rented by the player, one by someone else, one the
	// player used to rent (UserID left behind, no longer occupied), one free.
	// Plus the player's own house, which is not a shop.
	SetUpRealTestProperty(s + 0, REAL_TEST_FIRST_ID + 0, PROPERTY_TYPE_COMMERCIAL, REAL_TEST_USER_ID, true);
	SetUpRealTestProperty(s + 1, REAL_TEST_FIRST_ID + 1, PROPERTY_TYPE_COMMERCIAL, REAL_TEST_USER_ID + 1, true);
	SetUpRealTestProperty(s + 2, REAL_TEST_FIRST_ID + 2, PROPERTY_TYPE_COMMERCIAL, REAL_TEST_USER_ID, false);
	SetUpRealTestProperty(s + 3, REAL_TEST_FIRST_ID + 3, PROPERTY_TYPE_COMMERCIAL, 0, false);
	SetUpRealTestProperty(s + 4, REAL_TEST_FIRST_ID + 4, PROPERTY_TYPE_PERSONAL, REAL_TEST_USER_ID, true);

	ASSERT_EQ(GetPropertyArrayIDfromID(REAL_TEST_FIRST_ID + 2), s + 2);
	ASSERT_EQ(GetPropertyArrayIDfromID(REAL_TEST_FIRST_ID + 50), -1);

	ASSERT_TRUE(IsPlayerOwnerOfArrayID(playerid, s + 0));
	ASSERT_FALSE(IsPlayerOwnerOfArrayID(playerid, s + 1));
	ASSERT_FALSE(IsPlayerOwnerOfArrayID(playerid, s + 2));
	ASSERT_FALSE(IsPlayerOwnerOfArrayID(playerid, s + 3));
	ASSERT_TRUE(IsPlayerOwnerOfArrayID(playerid, s + 4));
	ASSERT_FALSE(IsPlayerOwnerOfArrayID(playerid, -1));
	ASSERT_FALSE(IsPlayerOwnerOfArrayID(playerid, MAX_PROPERTIES));

	ASSERT_TRUE(IsPlayerOwner(playerid, REAL_TEST_FIRST_ID + 0));
	ASSERT_FALSE(IsPlayerOwner(playerid, REAL_TEST_FIRST_ID + 1));
	ASSERT_FALSE(IsPlayerOwner(playerid, REAL_TEST_FIRST_ID + 50));

	// One shop of four, rounded down
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 25);

	gProperties[s + 3][UserID] = REAL_TEST_USER_ID;
	gProperties[s + 3][Occupied] = true;
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 50);

	gProperties[s + 1][UserID] = REAL_TEST_USER_ID;
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 75);

	gProperties[s + 2][Occupied] = true;
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 100);

	// Someone else entirely
	gPlayers[playerid][OrmID] = REAL_TEST_USER_ID + 5;
	ASSERT_EQ(GetPlayerCommercialShare(playerid), 0);

	TearDownRealTestProperties();
	DestroyTestPlayer(playerid);

	TEST_END("RealEstateOwnership");
}
