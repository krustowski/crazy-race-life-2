//
//  test_pickup.pwn
//

Test: PickupCreate()
{
	TEST_START("PickupCreate");
	
	new 
		id = EnsurePickupCreated(1272, 1, 0.0, 0.0, 0.0);

	ASSERT_TRUE(id > 0);

	DestroyPickup(id);

	TEST_END("PickupCreate");
}


Test: DeathMoneyPickups()
{
	TEST_START("DeathMoneyPickups");

	InitDeathMoneyPickups();
	gDeathMoneyPickupsPointer = 0;

	// (The ASSERT macros cut their argument at a parenthesised macro)
	new
		invalidPickup = INVALID_PICKUP,
		Text3D: noLabel = INVALID_3DTEXT_ID,
		victimid = CreateTestPlayer(),
		finderid = CreateTestPlayer();

	ResetPlayerMoney(victimid);
	ResetPlayerMoney(finderid);
	PlaceTestPlayer(victimid, 500.0, 500.0, 10.0);

	// Broke: no bag
	CreateDeathMoneyPickup(victimid);
	ASSERT_EQ(gDeathMoneyPickupsPointer, 0);
	ASSERT_EQ(gDeathMoneyPickups[0][PickupID], invalidPickup);

	// The money drops into a bag where the victim died
	GivePlayerMoney(victimid, 1234);
	CreateDeathMoneyPickup(victimid);

	new
		bagid = gDeathMoneyPickups[0][PickupID];

	ASSERT_EQ(gDeathMoneyPickupsPointer, 1);
	ASSERT_EQ(GetPlayerMoney(victimid), 0);
	ASSERT_EQ(gDeathMoneyPickups[0][Amount], 1234);
	ASSERT_TRUE(IsValidPickup(bagid));
	ASSERT_TRUE(gDeathMoneyPickups[0][Text] != noLabel);

	// Anyone walking into it takes all of it, once
	ASSERT_EQ(CheckDeathMoneyPickup(finderid, bagid), 1);
	ASSERT_EQ(GetPlayerMoney(finderid), 1234);
	ASSERT_FALSE(IsValidPickup(bagid));
	ASSERT_EQ(gDeathMoneyPickups[0][PickupID], invalidPickup);
	ASSERT_EQ(gDeathMoneyPickups[0][Amount], 0);

	ASSERT_EQ(CheckDeathMoneyPickup(finderid, bagid), 0);
	ASSERT_EQ(GetPlayerMoney(finderid), 1234);

	// The ring buffer wraps onto the oldest bag nobody collected, which goes
	GivePlayerMoney(victimid, 100);
	gDeathMoneyPickupsPointer = 0;
	CreateDeathMoneyPickup(victimid);

	new
		oldBagid = gDeathMoneyPickups[0][PickupID];

	GivePlayerMoney(victimid, 200);
	gDeathMoneyPickupsPointer = MAX_DEATH_MONEY_PICKUPS;
	CreateDeathMoneyPickup(victimid);

	ASSERT_EQ(gDeathMoneyPickupsPointer, 1);
	ASSERT_EQ(gDeathMoneyPickups[0][Amount], 200);
	ASSERT_TRUE(IsValidPickup(gDeathMoneyPickups[0][PickupID]));
	ASSERT_TRUE(oldBagid == gDeathMoneyPickups[0][PickupID] || !IsValidPickup(oldBagid));

	DestroyDeathMoneyPickup(0);
	gDeathMoneyPickupsPointer = 0;

	DestroyTestPlayer(finderid);
	DestroyTestPlayer(victimid);

	TEST_END("DeathMoneyPickups");
}
