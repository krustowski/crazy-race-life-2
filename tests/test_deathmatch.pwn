//
//  test_deathmatch.pwn
//

stock ResetTestDeathmatchTimers()
{
	if (gDeathmatchTimers[Start])
	{
		KillTimer(_: gDeathmatchTimers[Start]);
	}

	if (gDeathmatchTimers[Game])
	{
		KillTimer(_: gDeathmatchTimers[Game]);
	}

	gDeathmatchTimers[Start] = Timer: 0;
	gDeathmatchTimers[Game] = Timer: 0;

	return 1;
}

forward DeathmatchTestNoop();
public DeathmatchTestNoop()
{
	return 1;
}

Test: DeathmatchRegistration()
{
	TEST_START("DeathmatchRegistration");

	ResetTestDeathmatchTimers();

	new
		playerid = CreateTestPlayer(),
		busyid = CreateTestPlayer();

	gDeathmatch[playerid][Score] = 7;

	// The first one in starts the countdown to the round
	RegisterToDeathmatch(playerid);

	ASSERT_TRUE(gDeathmatch[playerid][IsRegistered]);
	ASSERT_FALSE(gDeathmatch[playerid][InGame]);
	ASSERT_EQ(gDeathmatch[playerid][Score], 0);
	ASSERT_TRUE(gPlayers[playerid][InMinigame]);
	ASSERT_TRUE(IsValidTimer(_: gDeathmatchTimers[Start]));

	// Busy with another minigame
	gPlayers[busyid][InMinigame] = true;
	RegisterToDeathmatch(busyid);
	ASSERT_FALSE(gDeathmatch[busyid][IsRegistered]);

	// Leaving gives the player back
	LeaveDeathmatch(playerid);
	ASSERT_FALSE(gDeathmatch[playerid][IsRegistered]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);

	// Not in the deathmatch: leaving does not end the other minigame
	LeaveDeathmatch(busyid);
	ASSERT_TRUE(gPlayers[busyid][InMinigame]);

	// A round in progress takes nobody new
	gPlayers[busyid][InMinigame] = false;
	gDeathmatchTimers[Game] = Timer: SetTimer("DeathmatchTestNoop", 60 * 1000, false);

	RegisterToDeathmatch(busyid);
	ASSERT_FALSE(gDeathmatch[busyid][IsRegistered]);
	ASSERT_FALSE(gPlayers[busyid][InMinigame]);

	ResetTestDeathmatchTimers();

	DestroyTestPlayer(busyid);
	DestroyTestPlayer(playerid);

	TEST_END("DeathmatchRegistration");
}

Test: WantedLevelOnKill()
{
	TEST_START("WantedLevelOnKill");

	new
		victimid = CreateTestPlayer(),
		killerid = CreateTestPlayer();

	gPlayers[killerid][WantedLevel] = 0;

	// Suicide, an unknown killer, and an NPC killer (every test player is an
	// NPC) never raise a wanted level
	ASSERT_EQ(RaisePlayerWantedLevel(victimid, victimid), 0);
	ASSERT_EQ(RaisePlayerWantedLevel(victimid, INVALID_PLAYER_ID), 0);
	ASSERT_EQ(RaisePlayerWantedLevel(victimid, killerid), 0);
	ASSERT_EQ(gPlayers[killerid][WantedLevel], 0);

	DestroyTestPlayer(killerid);
	DestroyTestPlayer(victimid);

	TEST_END("WantedLevelOnKill");
}
