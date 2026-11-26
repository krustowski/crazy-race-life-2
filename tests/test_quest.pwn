//
//  test_quest.pwn
//

stock EnsureQuestsLoaded()
{
	if (!gQuestCount)
	{
		InitQuests();
	}

	return 1;
}

// The id of the active quest for <event> with <target>, or 0. The tests look
// quests up by what they are rather than by their row ids.
stock FindTestQuest(QuestEvent: event, target)
{
	for (new i = 1; i < MAX_QUESTS; i++)
	{
		if (gQuests[i][ID] && gQuests[i][Event] == event && gQuests[i][Target] == target)
		{
			return i;
		}
	}

	printf("[FAIL] No quest for event %d with target %d", _: event, target);
	gCurrentTestFailed = true;

	return 0;
}

// The quests row of <userid> for <questid>: its progress, and whether it is
// completed. Returns 0 when there is no row.
stock GetSavedQuest(userid, questid, &progress, &bool: completed)
{
	new
		query[160];

	format(query, sizeof(query), "SELECT progress, IFNULL(completed_at, 0) AS completed_at FROM quests WHERE user_id = %d AND quest_type = %d", userid, questid);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		return 0;
	}

	progress = DB_GetFieldIntByName(result, "progress");
	completed = (DB_GetFieldIntByName(result, "completed_at") > 0);

	DB_FreeResultSet(result);
	return 1;
}

stock DeleteTestQuests(userid)
{
	new
		query[64];

	format(query, sizeof(query), "DELETE FROM quests WHERE user_id = %d", userid);
	return ExecDBStatement(query);
}

Test: QuestsLoadFromDB()
{
	TEST_START("QuestsLoadFromDB");

	EnsureQuestsLoaded();

	new
		active = QueryTestInt("SELECT COUNT(*) FROM quest_types WHERE active = 1 AND id IN (SELECT quest_type FROM quest_labels)");

	ASSERT_TRUE(gQuestCount > 0);
	ASSERT_EQ(gQuestCount, active);

	// One label per locale for every quest, read into its own slot
	new
		questid = FindTestQuest(QUEST_EVT_PROPERTY_ROBBED, 5);

	if (questid)
	{
		ASSERT_TRUE(strlen(gQuestLabels[questid][LOCALE_EN]) > 0);
		ASSERT_TRUE(strlen(gQuestLabels[questid][LOCALE_CZ]) > 0);
		ASSERT_TRUE(strlen(gQuestLabels[questid][LOCALE_BS]) > 0);
		ASSERT_TRUE(gQuests[questid][Reward] > 0);
	}

	TEST_END("QuestsLoadFromDB");
}

Test: QuestCountedProgress()
{
	TEST_START("QuestCountedProgress");

	EnsureQuestsLoaded();

	new
		playerid = CreateTestPlayer(),
		userid = InsertTestUser("quest_tester"),
		first = FindTestQuest(QUEST_EVT_PROPERTY_ROBBED, 5),
		second = FindTestQuest(QUEST_EVT_PROPERTY_ROBBED, 50),
		progress,
		bool: completed;

	gPlayers[playerid][OrmID] = userid;
	DeleteTestQuests(userid);
	ResetPlayerQuests(playerid);

	if (!first || !second)
	{
		DestroyTestPlayer(playerid);
		return;
	}

	new
		money = GetPlayerMoney(playerid),
		reward = gQuests[first][Reward];

	// Four of five: saved as progress, nothing paid yet
	for (new i = 0; i < 4; i++)
	{
		FireQuestEvent(playerid, QUEST_EVT_PROPERTY_ROBBED);
	}

	ASSERT_EQ(gPlayerQuests[playerid][first][Progress], 4);
	ASSERT_FALSE(gPlayerQuests[playerid][first][Completed]);
	ASSERT_EQ(GetPlayerMoney(playerid), money);

	ASSERT_TRUE(GetSavedQuest(userid, first, progress, completed));
	ASSERT_EQ(progress, 4);
	ASSERT_FALSE(completed);

	// The fifth completes it and pays the reward, once
	FireQuestEvent(playerid, QUEST_EVT_PROPERTY_ROBBED);

	ASSERT_TRUE(gPlayerQuests[playerid][first][Completed]);
	ASSERT_EQ(GetPlayerMoney(playerid), money + reward);

	ASSERT_TRUE(GetSavedQuest(userid, first, progress, completed));
	ASSERT_EQ(progress, 5);
	ASSERT_TRUE(completed);

	FireQuestEvent(playerid, QUEST_EVT_PROPERTY_ROBBED);

	ASSERT_EQ(gPlayerQuests[playerid][first][Progress], 5);
	ASSERT_EQ(GetPlayerMoney(playerid), money + reward);

	// The bigger quest on the same event kept counting all along
	ASSERT_EQ(gPlayerQuests[playerid][second][Progress], 6);
	ASSERT_FALSE(gPlayerQuests[playerid][second][Completed]);

	// Other events leave both alone
	FireQuestEvent(playerid, QUEST_EVT_PM_SENT, 0);
	ASSERT_EQ(gPlayerQuests[playerid][second][Progress], 6);

	// Back from the DB on the next login
	ResetPlayerQuests(playerid);
	ASSERT_FALSE(gPlayerQuests[playerid][first][Completed]);

	LoadPlayerQuests(playerid);
	ASSERT_TRUE(gPlayerQuests[playerid][first][Completed]);
	ASSERT_EQ(gPlayerQuests[playerid][first][Progress], 5);
	ASSERT_EQ(gPlayerQuests[playerid][second][Progress], 6);
	ASSERT_FALSE(gPlayerQuests[playerid][second][Completed]);

	DeleteTestQuests(userid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(playerid);

	TEST_END("QuestCountedProgress");
}

Test: QuestAmountIsCapped()
{
	TEST_START("QuestAmountIsCapped");

	EnsureQuestsLoaded();

	new
		playerid = CreateTestPlayer(),
		userid = InsertTestUser("quest_tester"),
		any = FindTestQuest(QUEST_EVT_FUEL_BOUGHT, 1),
		lots = FindTestQuest(QUEST_EVT_FUEL_BOUGHT, 1000),
		progress,
		bool: completed;

	gPlayers[playerid][OrmID] = userid;
	DeleteTestQuests(userid);
	ResetPlayerQuests(playerid);

	if (!any || !lots)
	{
		DestroyTestPlayer(playerid);
		return;
	}

	// 60 litres in one go: the "buy any fuel" quest is done at 1 / 1, the
	// 1000 litre one counts all 60
	FireQuestEvent(playerid, QUEST_EVT_FUEL_BOUGHT, 60);

	ASSERT_TRUE(gPlayerQuests[playerid][any][Completed]);
	ASSERT_EQ(gPlayerQuests[playerid][any][Progress], 1);
	ASSERT_EQ(gPlayerQuests[playerid][lots][Progress], 60);

	ASSERT_TRUE(GetSavedQuest(userid, any, progress, completed));
	ASSERT_EQ(progress, 1);

	// Way over the target still stops at it
	FireQuestEvent(playerid, QUEST_EVT_FUEL_BOUGHT, 5000);

	ASSERT_TRUE(gPlayerQuests[playerid][lots][Completed]);
	ASSERT_EQ(gPlayerQuests[playerid][lots][Progress], 1000);

	DeleteTestQuests(userid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(playerid);

	TEST_END("QuestAmountIsCapped");
}

Test: QuestLevelProgress()
{
	TEST_START("QuestLevelProgress");

	EnsureQuestsLoaded();

	new
		playerid = CreateTestPlayer(),
		userid = InsertTestUser("quest_tester"),
		questid = FindTestQuest(QUEST_EVT_COMMERCIAL_SHARE, 100),
		progress,
		bool: completed;

	gPlayers[playerid][OrmID] = userid;
	DeleteTestQuests(userid);
	ResetPlayerQuests(playerid);

	if (!questid)
	{
		DestroyTestPlayer(playerid);
		return;
	}

	new
		money = GetPlayerMoney(playerid);

	// A level is the highest one reported, not a running sum
	FireQuestLevelEvent(playerid, QUEST_EVT_COMMERCIAL_SHARE, 40);
	ASSERT_EQ(gPlayerQuests[playerid][questid][Progress], 40);

	FireQuestLevelEvent(playerid, QUEST_EVT_COMMERCIAL_SHARE, 60);
	ASSERT_EQ(gPlayerQuests[playerid][questid][Progress], 60);

	// Losing some of it later does not set the quest back
	FireQuestLevelEvent(playerid, QUEST_EVT_COMMERCIAL_SHARE, 25);
	ASSERT_EQ(gPlayerQuests[playerid][questid][Progress], 60);

	ASSERT_TRUE(GetSavedQuest(userid, questid, progress, completed));
	ASSERT_EQ(progress, 60);
	ASSERT_FALSE(completed);
	ASSERT_EQ(GetPlayerMoney(playerid), money);

	FireQuestLevelEvent(playerid, QUEST_EVT_COMMERCIAL_SHARE, 100);

	ASSERT_TRUE(gPlayerQuests[playerid][questid][Completed]);
	ASSERT_EQ(GetPlayerMoney(playerid), money + gQuests[questid][Reward]);

	DeleteTestQuests(userid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(playerid);

	TEST_END("QuestLevelProgress");
}

// Quest rows the loader has to refuse: quest id 0 (the "not loaded" value of
// gQuests[][ID]), ids past the gQuests[] table, and locales PlayerLocale has
// no slot for. Indexing with any of them is a run time error, which would
// abort InitQuests() and, on the server, OnGameModeInit with every Init*
// after it.
#define QUEST_TEST_GOOD_ID	(MAX_QUESTS - 2)

stock DeleteBadTestQuests()
{
	new
		query[160];

	format(query, sizeof(query), "DELETE FROM quest_labels WHERE quest_type IN (0, %d, %d, %d)", QUEST_TEST_GOOD_ID, MAX_QUESTS, MAX_QUESTS + 36);
	ExecDBStatement(query);

	format(query, sizeof(query), "DELETE FROM quest_types WHERE id IN (0, %d, %d, %d)", QUEST_TEST_GOOD_ID, MAX_QUESTS, MAX_QUESTS + 36);
	return ExecDBStatement(query);
}

Test: QuestsSkipBadRows()
{
	TEST_START("QuestsSkipBadRows");

	EnsureQuestsLoaded();

	new
		count = gQuestCount,
		good = QUEST_TEST_GOOD_ID,
		query[512];

	// The seeded quests must leave this id free
	ASSERT_FALSE(gQuests[good][ID]);

	DeleteBadTestQuests();

	// PM_SENT with a target nobody reaches, so no other test can complete it
	format(query, sizeof(query), "INSERT INTO quest_types (id, event, target, reward) VALUES (0, %d, 9999, 1), (%d, %d, 9999, 1), (%d, %d, 9999, 1), (%d, %d, 9999, 1)",
			_: QUEST_EVT_PM_SENT,
			good, _: QUEST_EVT_PM_SENT,
			MAX_QUESTS, _: QUEST_EVT_PM_SENT,
			MAX_QUESTS + 36, _: QUEST_EVT_PM_SENT
		);
	ASSERT_TRUE(ExecDBStatement(query));

	format(query, sizeof(query), "INSERT INTO quest_labels (quest_type, locale, label, desc) VALUES (%d, 0, 'Test quest', 'd'), (%d, %d, 'Bad locale', 'd'), (%d, -1, 'Bad locale', 'd'), (0, 0, 'Quest zero', 'd'), (%d, 0, 'Past the table', 'd'), (%d, 0, 'Way past it', 'd')",
			good,
			good, _: PlayerLocale,
			good,
			MAX_QUESTS,
			MAX_QUESTS + 36
		);
	ASSERT_TRUE(ExecDBStatement(query));

	new
		loaded = InitQuests();

	ASSERT_EQ(loaded, 1);

	// Only the good quest is new, with its one good label
	ASSERT_EQ(gQuestCount, count + 1);
	ASSERT_EQ(gQuests[good][ID], good);
	ASSERT_EQ(gQuests[good][Target], 9999);

	new
		same = !strcmp(gQuestLabels[good][LOCALE_EN], "Test quest");

	ASSERT_TRUE(same);
	ASSERT_FALSE(gQuests[0][ID]);

	// Back to the seeded quests only
	DeleteBadTestQuests();

	gQuests[good][ID] = 0;
	gQuests[good][Event] = QUEST_EVT_NONE;
	gQuests[good][Target] = 0;
	gQuests[good][Reward] = 0;

	for (new l = 0; l < _: PlayerLocale; l++)
	{
		gQuestLabels[good][PlayerLocale: l][0] = EOS;
		gQuestDesc[good][PlayerLocale: l][0] = EOS;
	}

	gQuestCount = count;

	TEST_END("QuestsSkipBadRows");
}
