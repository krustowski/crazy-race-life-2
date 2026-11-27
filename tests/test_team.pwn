//
//  test_team.pwn
//

Test: TeamsLoadFromDB()
{
	TEST_START("TeamsLoadFromDB");

	EnsureTeamsLoaded();

	new
		loaded = 0;

	for (new i = 0; i < MAX_TEAMS; i++)
	{
		if (gTeams[i][ID])
		{
			loaded++;
		}
	}

	// Ids 1-10: the "Blank team (stub)" row 0 is skipped, so gTeams[id - 1]
	// is team id (see InitTeams())
	ASSERT_EQ(loaded, MAX_TEAMS);

	new
		name[64],
		expectName[] = "Mechanics",
		mechanicsID = _: gTeams[0][ID],
		mechanicsColor = _: gTeams[0][Color],
		mechanicsSkin = _: gTeams[0][Skins][0];

	format(name, sizeof(name), "%s", gTeams[0][TeamName]);

	ASSERT_EQ(mechanicsID, 1);
	ASSERT_STREQ(name, expectName);
	ASSERT_EQ(mechanicsColor, 0x008B8BAA);
	ASSERT_EQ(mechanicsSkin, 50);

	// Police: three guns with their own ammo each
	new
		policeID = _: gTeams[_: TEAM_POLICE - 1][ID],
		policeWeapon0 = _: gTeams[_: TEAM_POLICE - 1][Weapons][0],
		policeWeapon2 = _: gTeams[_: TEAM_POLICE - 1][Weapons][2],
		policeWeapon3 = _: gTeams[_: TEAM_POLICE - 1][Weapons][3],
		policeAmmo0 = _: gTeams[_: TEAM_POLICE - 1][Ammo][0],
		policeAmmo2 = _: gTeams[_: TEAM_POLICE - 1][Ammo][2];

	ASSERT_EQ(policeID, _: TEAM_POLICE);
	ASSERT_EQ(policeWeapon0, 30);
	ASSERT_EQ(policeWeapon2, 32);
	ASSERT_EQ(policeWeapon3, 0);
	ASSERT_EQ(policeAmmo0, 500);
	ASSERT_EQ(policeAmmo2, 111);

	// The last team, which MAX_TEAMS has to make room for
	new
		robberzID = _: gTeams[_: TEAM_ROBBERS - 1][ID],
		robberzSkin = _: gTeams[_: TEAM_ROBBERS - 1][Skins][0],
		robberzWeapon3 = _: gTeams[_: TEAM_ROBBERS - 1][Weapons][3],
		robberzSalary = _: gTeams[_: TEAM_ROBBERS - 1][SalaryBase],
		robberzVolatile = _: gTeams[_: TEAM_ROBBERS - 1][SalaryVolatile];

	ASSERT_EQ(robberzID, _: TEAM_ROBBERS);
	ASSERT_EQ(robberzSkin, 271);
	ASSERT_EQ(robberzWeapon3, 28);
	ASSERT_EQ(robberzSalary, 1000);
	ASSERT_EQ(robberzVolatile, 500);

	TEST_END("TeamsLoadFromDB");
}

Test: TeamMembership()
{
	TEST_START("TeamMembership");

	EnsureTeamsLoaded();

	new
		playerid = CreateTestPlayer();

	// Teamless
	ASSERT_FALSE(IsPlayerInTeam(playerid, TEAM_ROBBERS));
	ASSERT_FALSE(IsPlayerInTeam(playerid, TEAM_NONE));

	gPlayers[playerid][TeamID] = TEAM_ROBBERS;
	ASSERT_TRUE(IsPlayerInTeam(playerid, TEAM_ROBBERS));
	ASSERT_FALSE(IsPlayerInTeam(playerid, TEAM_DEALERS));

	gPlayers[playerid][TeamID] = TEAM_MECHANICS;
	ASSERT_TRUE(IsPlayerInTeam(playerid, TEAM_MECHANICS));
	ASSERT_FALSE(IsPlayerInTeam(playerid, TEAM_ROBBERS));

	DestroyTestPlayer(playerid);

	TEST_END("TeamMembership");
}
