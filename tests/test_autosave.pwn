//
//  test_autosave.pwn
//
//  The batch saves AutosaveData() runs every few minutes, each inside one
//  transaction (BeginDBTransaction/CommitDBTransaction in db/sqlite.pwn).
//

// gProperties[] is not loaded in the tests. test_real.pwn borrows the last
// slots, so these sit just before them.
#define AUTOSAVE_TEST_FIRST_SLOT	(MAX_PROPERTIES - 12)
#define AUTOSAVE_TEST_COUNT			2
#define AUTOSAVE_TEST_FIRST_ID		99301

stock ClearAutosaveTestProperties()
{
	new
		query[192];

	format(query, sizeof(query), "DELETE FROM properties WHERE id BETWEEN %d AND %d", AUTOSAVE_TEST_FIRST_ID, AUTOSAVE_TEST_FIRST_ID + AUTOSAVE_TEST_COUNT - 1);
	ExecDBStatement(query);

	format(query, sizeof(query), "DELETE FROM vehicles WHERE id BETWEEN %d AND %d", AUTOSAVE_TEST_FIRST_ID, AUTOSAVE_TEST_FIRST_ID + AUTOSAVE_TEST_COUNT - 1);
	ExecDBStatement(query);

	format(query, sizeof(query), "DELETE FROM drugz WHERE owner_type = 2 AND owner_id BETWEEN %d AND %d", AUTOSAVE_TEST_FIRST_ID, AUTOSAVE_TEST_FIRST_ID + AUTOSAVE_TEST_COUNT - 1);
	ExecDBStatement(query);

	for (new i = 0; i < AUTOSAVE_TEST_COUNT; i++)
	{
		new
			slot = AUTOSAVE_TEST_FIRST_SLOT + i;

		gProperties[slot][ID] = 0;
		gProperties[slot][UserID] = 0;
		gProperties[slot][Label][0] = EOS;
		gProperties[slot][Cost] = 0;
		gProperties[slot][Type] = PROPERTY_TYPE_NONE;
		gProperties[slot][Occupied] = false;
		gProperties[slot][CustomInterior] = false;
		gProperties[slot][LockedUntilTime] = 0;
		gProperties[slot][Vehicle][Model] = 0;
		gProperties[slot][Vehicle][Paintjob] = 0;
		gProperties[slot][Vehicle][Colours][0] = 0;
		gProperties[slot][Vehicle][Colours][1] = 0;

		for (new c = 0; c < 16; c++)
		{
			gProperties[slot][Vehicle][Components][c] = CARMODTYPE: 0;
		}

		for (new d = 0; d < MAX_DRUG_TYPES; d++)
		{
			gProperties[slot][Drugs][d] = 0;
		}
	}

	return 1;
}

// A test that fails half way must not leave a transaction open for the
// tests after it.
stock CloseTestTransaction()
{
	if (gDbInTransaction)
	{
		ExecDBStatement("ROLLBACK");
		gDbInTransaction = false;
	}

	return 1;
}

Test: RealEstateAutosave()
{
	TEST_START("RealEstateAutosave");

	ClearAutosaveTestProperties();

	new
		owner = InsertTestUser("autosave_owner"),
		house = AUTOSAVE_TEST_FIRST_SLOT,
		shop = AUTOSAVE_TEST_FIRST_SLOT + 1,
		houseid = AUTOSAVE_TEST_FIRST_ID,
		shopid = AUTOSAVE_TEST_FIRST_ID + 1,
		query[320];

	// An owned house with a tuned car and a stash, and a free shop
	gProperties[house][ID] = houseid;
	gProperties[house][UserID] = owner;
	format(gProperties[house][Label], 64, "Joe's Place");
	gProperties[house][Cost] = 50000;
	gProperties[house][Type] = PROPERTY_TYPE_PERSONAL;
	gProperties[house][Occupied] = true;
	gProperties[house][CustomInterior] = true;
	gProperties[house][LockedUntilTime] = 1234567;
	gProperties[house][Vehicle][Model] = 411;
	gProperties[house][Vehicle][Colours][0] = 3;
	gProperties[house][Vehicle][Colours][1] = 6;
	gProperties[house][Vehicle][Paintjob] = 1;
	gProperties[house][Vehicle][Components][0] = CARMODTYPE: 1010;
	gProperties[house][Drugs][ZAZA] = 7;
	gProperties[house][Drugs][COCAINE] = 2;

	gProperties[shop][ID] = shopid;
	format(gProperties[shop][Label], 64, "Corner Shop");
	gProperties[shop][Cost] = 90000;
	gProperties[shop][Type] = PROPERTY_TYPE_COMMERCIAL;

	SaveRealEstateData();

	// The save opened its own transaction and closed it again
	ASSERT_FALSE(gDbInTransaction);

	// The apostrophe in the name is escaped, not cutting the INSERT short
	format(query, sizeof(query), "SELECT COUNT(*) FROM properties WHERE id = %d AND name = 'Joe''s Place' AND type = %d AND user_id = %d AND vehicle_id = %d AND cost = 50000 AND occupied = 1 AND custom_interior = 1 AND locked_until_timestamp = 1234567",
			houseid, _: PROPERTY_TYPE_PERSONAL, owner, houseid);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT COUNT(*) FROM vehicles WHERE id = %d AND model = 411 AND color1 = 3 AND color2 = 6 AND paintjob = 1 AND components LIKE '1010,0,%%'", houseid);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT zaza * 100 + cocaine FROM drugz WHERE owner_type = 2 AND owner_id = %d", houseid);
	ASSERT_EQ(QueryTestInt(query), 702);

	// No car, no vehicles row; an empty stash still gets its row
	format(query, sizeof(query), "SELECT COUNT(*) FROM properties WHERE id = %d AND vehicle_id = 0 AND occupied = 0 AND type = %d", shopid, _: PROPERTY_TYPE_COMMERCIAL);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT COUNT(*) FROM vehicles WHERE id = %d", shopid);
	ASSERT_EQ(QueryTestInt(query), 0);

	format(query, sizeof(query), "SELECT COUNT(*) FROM drugz WHERE owner_type = 2 AND owner_id = %d AND zaza = 0", shopid);
	ASSERT_EQ(QueryTestInt(query), 1);

	// Saving again updates the same rows rather than adding new ones
	gProperties[house][Occupied] = false;
	gProperties[house][Drugs][ZAZA] = 0;
	gProperties[shop][UserID] = owner;
	gProperties[shop][Occupied] = true;

	SaveRealEstateData();

	ASSERT_FALSE(gDbInTransaction);

	format(query, sizeof(query), "SELECT COUNT(*) FROM properties WHERE id IN (%d, %d)", houseid, shopid);
	ASSERT_EQ(QueryTestInt(query), 2);

	format(query, sizeof(query), "SELECT occupied FROM properties WHERE id = %d", houseid);
	ASSERT_EQ(QueryTestInt(query), 0);

	format(query, sizeof(query), "SELECT user_id FROM properties WHERE id = %d AND occupied = 1", shopid);
	ASSERT_EQ(QueryTestInt(query), owner);

	format(query, sizeof(query), "SELECT COUNT(*) FROM drugz WHERE owner_type = 2 AND owner_id = %d AND zaza = 0 AND cocaine = 2", houseid);
	ASSERT_EQ(QueryTestInt(query), 1);

	// Inside someone else's transaction the save joins it instead of
	// committing: rolling the outer one back undoes the save too
	new
		bool: outer = BeginDBTransaction();

	ASSERT_TRUE(outer);

	gProperties[house][Occupied] = true;
	SaveRealEstateData();

	ASSERT_TRUE(gDbInTransaction);

	ExecDBStatement("ROLLBACK");
	gDbInTransaction = false;

	format(query, sizeof(query), "SELECT occupied FROM properties WHERE id = %d", houseid);
	ASSERT_EQ(QueryTestInt(query), 0);

	CloseTestTransaction();
	ClearAutosaveTestProperties();
	DeleteTestUserByID(owner);

	TEST_END("RealEstateAutosave");
}

Test: PlayersAutosave()
{
	TEST_START("PlayersAutosave");

	new
		names[3][MAX_PLAYER_NAME] = {"autosave_a", "autosave_b", "autosave_c"},
		cash[3] = {111, 222, 333},
		players[3],
		users[3],
		query[160];

	for (new i = 0; i < 3; i++)
	{
		players[i] = CreateTestPlayer();
		users[i] = InsertTestUser(names[i]);

		format(gPlayers[players[i]][Name], MAX_PLAYER_NAME, "%s", names[i]);
		gPlayers[players[i]][OrmID] = users[i];

		ResetPlayerMoney(players[i]);
		GivePlayerMoney(players[i], cash[i]);
	}

	// The third one never logged in, so nothing of theirs is written
	gPlayers[players[0]][IsLogged] = true;
	gPlayers[players[1]][IsLogged] = true;
	gPlayers[players[2]][IsLogged] = false;

	BatchSavePlayerData();

	ASSERT_FALSE(gDbInTransaction);

	for (new i = 0; i < 3; i++)
	{
		format(query, sizeof(query), "SELECT cash FROM users WHERE id = %d", users[i]);

		new
			saved = QueryTestInt(query),
			expected = (i < 2) ? cash[i] : 0;

		ASSERT_EQ(saved, expected);
	}

	// Each logged in player's pockets got a drugz row
	format(query, sizeof(query), "SELECT COUNT(*) FROM drugz WHERE owner_type = 1 AND owner_id IN (%d, %d, %d)", users[0], users[1], users[2]);
	ASSERT_EQ(QueryTestInt(query), 2);

	CloseTestTransaction();

	format(query, sizeof(query), "DELETE FROM drugz WHERE owner_type = 1 AND owner_id IN (%d, %d, %d)", users[0], users[1], users[2]);
	ExecDBStatement(query);

	for (new i = 0; i < 3; i++)
	{
		DeleteTestUserByID(users[i]);
		ResetPlayerMoney(players[i]);
		DestroyTestPlayer(players[i]);
	}

	TEST_END("PlayersAutosave");
}
