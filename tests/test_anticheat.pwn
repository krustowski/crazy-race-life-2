//
//  test_anticheat.pwn
//

// Plain ids: the ASSERT macros don't take a tag override like _: inside.
#define AC_TEST_KNIFE		4
#define AC_TEST_TEC9		32
#define AC_TEST_AK47		30
#define AC_TEST_M4			31
#define AC_TEST_MINIGUN		38
#define AC_TEST_DETONATOR	40
#define AC_TEST_PARACHUTE	46

Test: AntiCheatLedger()
{
	TEST_START("AntiCheatLedger");

	new
		playerid = CreateTestPlayer();

	// Through the hooked natives, as every module calls them.
	GivePlayerWeapon(playerid, WEAPON_AK47, 100);
	GivePlayerWeapon(playerid, WEAPON_M4, 500);

	ASSERT_TRUE(IsWeaponGranted(playerid, AC_TEST_AK47));
	ASSERT_TRUE(IsWeaponGranted(playerid, AC_TEST_M4));
	ASSERT_FALSE(IsWeaponGranted(playerid, AC_TEST_MINIGUN));

	// AK and M4 share the assault rifle slot, and so may their ammo.
	ASSERT_EQ(GetGrantedSlotAmmo(playerid, 5), 600);
	ASSERT_TRUE(IsWeaponLedgerSettling(playerid, AC_WEAPON_GRACE_MS));

	SetPlayerAmmo(playerid, WEAPON_M4, 50);
	ASSERT_EQ(GetGrantedSlotAmmo(playerid, 5), 50);

	ResetPlayerWeapons(playerid);

	ASSERT_FALSE(IsWeaponGranted(playerid, AC_TEST_AK47));
	ASSERT_FALSE(IsWeaponGranted(playerid, AC_TEST_M4));
	ASSERT_EQ(GetGrantedSlotAmmo(playerid, 5), 0);

	ASSERT_EQ(GetWeaponSlotIndex(AC_TEST_TEC9), 4);
	ASSERT_EQ(GetWeaponSlotIndex(AC_TEST_DETONATOR), 12);
	ASSERT_EQ(GetWeaponSlotIndex(AC_TEST_PARACHUTE), 11);
	ASSERT_EQ(GetWeaponSlotIndex(20), -1);

	DestroyTestPlayer(playerid);

	TEST_END("AntiCheatLedger");
}

Test: AntiCheatJudgeWeapons()
{
	TEST_START("AntiCheatJudgeWeapons");

	new
		playerid = CreateTestPlayer();

	// Teamless outside any minigame: nothing was ever handed out.
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_M4, 1), AC_VIOLATION_WEAPON);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_KNIFE, 1), AC_VIOLATION_WEAPON);

	// Spent, game-given or not a weapon GTA knows at all.
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_M4, 0), AC_VIOLATION_NONE);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_PARACHUTE, 1), AC_VIOLATION_NONE);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_DETONATOR, 1), AC_VIOLATION_NONE);
	ASSERT_EQ(JudgeReportedWeapon(playerid, 20, 1), AC_VIOLATION_NONE);

	GivePlayerWeapon(playerid, WEAPON_M4, 500);

	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_M4, 500), AC_VIOLATION_NONE);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_M4, 9999), AC_VIOLATION_AMMO);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_MINIGUN, 500), AC_VIOLATION_WEAPON);
	ASSERT_TRUE(IsBannedHeavyWeapon(AC_TEST_MINIGUN));

	// A minigun the server handed out (admin, rampage) is fine, ammo unchecked.
	GivePlayerWeapon(playerid, WEAPON_MINIGUN, 100);
	ASSERT_EQ(JudgeReportedWeapon(playerid, AC_TEST_MINIGUN, 9999), AC_VIOLATION_NONE);

	DestroyTestPlayer(playerid);

	TEST_END("AntiCheatJudgeWeapons");
}
