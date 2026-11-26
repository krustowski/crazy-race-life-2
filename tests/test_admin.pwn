//
//  test_admin.pwn
//
//  /lvl (dcmd_lvl) and SetPlayerAdminLevel(). An RCON admin may set any level
//  to anyone, themselves included, so the first admins can be appointed
//  in-game on a fresh DB where nobody has an admin level yet.
//

// A logged-in test player with an account row, and the given admin level
stock CreateAdminTestPlayer(const nickname[], &userid, level = 0)
{
	new
		playerid = CreateTestPlayer();

	userid = InsertTestUser(nickname);

	format(gPlayers[playerid][Name], MAX_PLAYER_NAME, "%s", nickname);
	gPlayers[playerid][OrmID] = userid;
	gPlayers[playerid][IsLogged] = true;
	gPlayers[playerid][AdminLevel] = level;

	return playerid;
}

stock DestroyAdminTestPlayer(playerid, userid)
{
	new
		query[96];

	// SavePlayerData() writes the pockets too
	format(query, sizeof(query), "DELETE FROM drugz WHERE owner_type = 1 AND owner_id = %d", userid);
	ExecDBStatement(query);

	DeleteTestUserByID(userid);

	gPlayers[playerid][AdminLevel] = 0;
	DestroyTestPlayer(playerid);

	return 1;
}

stock SavedAdminLevel(userid)
{
	new
		query[96];

	format(query, sizeof(query), "SELECT adminlvl FROM users WHERE id = %d", userid);
	return QueryTestInt(query);
}

// Runs /lvl <targetid> <level> as <playerid>
stock RunLvlCommand(playerid, targetid, level)
{
	new
		params[24];

	format(params, sizeof(params), "%d %d", targetid, level);
	return dcmd_lvl(playerid, params);
}

Test: AdminLevelByRconAdmin()
{
	TEST_START("AdminLevelByRconAdmin");

	new
		rconUser,
		targetUser,
		rcon = CreateAdminTestPlayer("lvl_rcon", rconUser),
		target = CreateAdminTestPlayer("lvl_target", targetUser);

	// Without the RCON login a level 0 account gets nowhere
	ASSERT_FALSE(IsPlayerAdmin(rcon));
	ASSERT_EQ(RunLvlCommand(rcon, target, 5), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 0);

	SetPlayerAdmin(rcon, true);
	ASSERT_TRUE(IsPlayerAdmin(rcon));

	// Any level to anyone, saved to their account straight away
	ASSERT_EQ(RunLvlCommand(rcon, target, 5), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 5);
	ASSERT_EQ(SavedAdminLevel(targetUser), 5);

	// And down again, though the target now outranks the RCON admin's account
	ASSERT_EQ(SetPlayerAdminLevel(rcon, target, 2), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 2);
	ASSERT_EQ(SavedAdminLevel(targetUser), 2);

	// Themselves too
	ASSERT_EQ(SetPlayerAdminLevel(rcon, rcon, 5), 1);
	ASSERT_EQ(gPlayers[rcon][AdminLevel], 5);
	ASSERT_EQ(SavedAdminLevel(rconUser), 5);

	// Not the level they have already, nor one out of range
	ASSERT_EQ(SetPlayerAdminLevel(rcon, target, 2), 0);
	ASSERT_EQ(SetPlayerAdminLevel(rcon, target, 6), 0);
	ASSERT_EQ(SetPlayerAdminLevel(rcon, target, -1), 0);
	ASSERT_EQ(RunLvlCommand(rcon, target, 6), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 2);

	// Nor a player who has not logged in: nothing would be saved
	gPlayers[target][IsLogged] = false;
	ASSERT_EQ(SetPlayerAdminLevel(rcon, target, 4), 0);
	ASSERT_EQ(gPlayers[target][AdminLevel], 2);
	ASSERT_EQ(SavedAdminLevel(targetUser), 2);
	gPlayers[target][IsLogged] = true;

	// Nor a malformed command (ASSERT stringifies its argument, so no string
	// literals inside it)
	new
		handled,
		params[24];

	handled = dcmd_lvl(rcon, "");
	ASSERT_EQ(handled, 1);
	handled = dcmd_lvl(rcon, "x 3");
	ASSERT_EQ(handled, 1);

	format(params, sizeof(params), "%d ", target);
	ASSERT_EQ(dcmd_lvl(rcon, params), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 2);

	SetPlayerAdmin(rcon, false);

	DestroyAdminTestPlayer(target, targetUser);
	DestroyAdminTestPlayer(rcon, rconUser);

	TEST_END("AdminLevelByRconAdmin");
}

Test: AdminLevelByAdmin()
{
	TEST_START("AdminLevelByAdmin");

	new
		adminUser,
		peerUser,
		targetUser,
		admin = CreateAdminTestPlayer("lvl_admin", adminUser, 4),
		peer = CreateAdminTestPlayer("lvl_peer", peerUser, 4),
		target = CreateAdminTestPlayer("lvl_player", targetUser);

	ASSERT_FALSE(IsPlayerAdmin(admin));

	// Up to their own level
	ASSERT_EQ(RunLvlCommand(admin, target, 3), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 3);
	ASSERT_EQ(SavedAdminLevel(targetUser), 3);

	ASSERT_EQ(SetPlayerAdminLevel(admin, target, 4), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 4);

	ASSERT_EQ(SetPlayerAdminLevel(admin, target, 0), 0);
	ASSERT_EQ(gPlayers[target][AdminLevel], 4);

	gPlayers[target][AdminLevel] = 0;

	// But not above it
	ASSERT_EQ(SetPlayerAdminLevel(admin, target, 5), 0);
	ASSERT_EQ(gPlayers[target][AdminLevel], 0);

	// Nor of someone at their own level, nor their own
	ASSERT_EQ(SetPlayerAdminLevel(admin, peer, 0), 0);
	ASSERT_EQ(gPlayers[peer][AdminLevel], 4);
	ASSERT_EQ(SetPlayerAdminLevel(admin, admin, 3), 0);
	ASSERT_EQ(gPlayers[admin][AdminLevel], 4);

	// Below level 4 the command is off limits
	gPlayers[peer][AdminLevel] = 3;
	ASSERT_EQ(RunLvlCommand(peer, target, 1), 1);
	ASSERT_EQ(gPlayers[target][AdminLevel], 0);
	ASSERT_EQ(SetPlayerAdminLevel(peer, target, 1), 0);
	ASSERT_EQ(gPlayers[target][AdminLevel], 0);

	DestroyAdminTestPlayer(target, targetUser);
	DestroyAdminTestPlayer(peer, peerUser);
	DestroyAdminTestPlayer(admin, adminUser);

	TEST_END("AdminLevelByAdmin");
}
