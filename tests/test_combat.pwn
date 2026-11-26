//
//  test_combat.pwn
//
//  One full run of the outdoor Rockshore mission. Each run creates its two
//  dozen gunmen for real, and a destroyed NPC only leaves on a later tick, so
//  more runs would bring the suite near the server's NPC limit (maxnpc).
//

#define COMBAT_TEST_MISSION_ID	4
#define COMBAT_TEST_NO_MISSION	99

stock CountCombatPickups(CombatPickupType: type)
{
	new
		count = 0;

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		if (gCombatPickups[i][Type] == type && (type == TYPE_CP || IsValidPickup(gCombatPickups[i][Pickup])))
		{
			count++;
		}
	}

	return count;
}

stock CountCombatNPCs()
{
	new
		count = 0;

	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		if (gCombatNPC[i] != INVALID_NPC_ID && NPC_IsValid(gCombatNPC[i]))
		{
			count++;
		}
	}

	return count;
}

stock CountCombatRows(missionid, const types[])
{
	new
		query[160];

	format(query, sizeof(query), "SELECT COUNT(*) FROM combat_coords WHERE mission_id = %d AND type IN (%s)", missionid, types);
	return QueryTestInt(query);
}

// The gunman standing on the mission's NPC_MAN point: the briefcase man
stock FindBriefcaseMan(missionid)
{
	new
		query[192];

	format(query, sizeof(query), "SELECT CAST(ROUND(x * 100) AS INTEGER) FROM combat_coords WHERE mission_id = %d AND type = %d", missionid, COMBAT_COORD_NPC_MAN);
	new Float: mX = QueryTestCoord(query);
	format(query, sizeof(query), "SELECT CAST(ROUND(y * 100) AS INTEGER) FROM combat_coords WHERE mission_id = %d AND type = %d", missionid, COMBAT_COORD_NPC_MAN);
	new Float: mY = QueryTestCoord(query);

	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		if (gCombatNPC[i] == INVALID_NPC_ID)
		{
			continue;
		}

		new
			Float: X,
			Float: Y,
			Float: Z;

		GetPlayerPos(gCombatNPC[i], X, Y, Z);

		if (floatabs(X - mX) < 0.5 && floatabs(Y - mY) < 0.5)
		{
			return gCombatNPC[i];
		}
	}

	return INVALID_NPC_ID;
}

Test: CombatMissionRun()
{
	TEST_START("CombatMissionRun");

	new
		mission = COMBAT_TEST_MISSION_ID,
		playerid = CreateTestPlayer(),
		rival = CreateTestPlayer(),
		userid = InsertTestUser("combat_tester"),
		query[160];

	gPlayers[playerid][OrmID] = userid;
	gCombatOccupant = INVALID_PLAYER_ID;
	ResetPlayerMoney(playerid);

	// A mission with no layout does not start, and holds nothing
	SetCombatMission(playerid, COMBAT_TEST_NO_MISSION);

	ASSERT_FALSE(gCombatMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gCombatOccupant, INVALID_PLAYER_ID);

	// The real one: armed, with its gunmen, briefcases, health and helicopter
	SetCombatMission(playerid, mission);

	ASSERT_TRUE(gCombatMission[playerid][Active]);
	ASSERT_TRUE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gCombatOccupant, playerid);
	ASSERT_EQ(gCombatMission[playerid][MissionID], mission);
	ASSERT_EQ(gCombatMission[playerid][BriefcaseCount], 0);
	ASSERT_TRUE(IsWeaponGranted(playerid, 26));
	ASSERT_TRUE(IsWeaponGranted(playerid, 31));

	new
		timerUpdate = _: gCombatMission[playerid][TimerUpdate],
		timerMan = _: gCombatMission[playerid][TimerBriefcaseMan];

	ASSERT_TRUE(IsValidTimer(timerUpdate));
	ASSERT_TRUE(IsValidTimer(timerMan));

	// (ASSERT takes no string literals, hence the counts up front)
	new
		gunmenRows = CountCombatRows(mission, "2, 8"),
		briefcaseRows = CountCombatRows(mission, "1"),
		healthRows = CountCombatRows(mission, "3"),
		checkpointRows = CountCombatRows(mission, "7"),
		gunmen = CountCombatNPCs(),
		briefcasePickups = CountCombatPickups(TYPE_BRIEFCASE),
		healthPickups = CountCombatPickups(CombatPickupType: TYPE_HEALTH),
		checkpoints = CountCombatPickups(TYPE_CP);

	ASSERT_EQ(gunmen, gunmenRows);
	ASSERT_EQ(briefcasePickups, briefcaseRows);
	ASSERT_EQ(healthPickups, healthRows);
	ASSERT_EQ(checkpoints, checkpointRows);

	new
		heli = gCombatVehicles[0];

	ASSERT_TRUE(IsValidVehicle(heli));
	ASSERT_EQ(GetVehicleModel(heli), 487);

	// One mission at a time: the arrays are shared by the whole server
	SetCombatMission(rival, mission);

	ASSERT_FALSE(gCombatMission[rival][Active]);
	ASSERT_EQ(gCombatOccupant, playerid);

	// Every briefcase counts once
	new
		briefcases = briefcaseRows;

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		if (gCombatPickups[i][Type] == TYPE_BRIEFCASE)
		{
			CheckCombatPickup(playerid, gCombatPickups[i][Pickup]);
		}
	}

	ASSERT_EQ(gCombatMission[playerid][BriefcaseCount], briefcases);

	// Not a mission pickup at all
	ASSERT_EQ(CheckCombatPickup(playerid, -5), 0);

	// Outdoors there is no exit pickup: taking the helicopter shows the way
	ASSERT_FALSE(gCombatMission[playerid][CheckpointShown]);
	CheckCombatVehicle(playerid, heli);
	ASSERT_TRUE(gCombatMission[playerid][CheckpointShown]);

	// Handing the briefcases over: $50000 each, and the mission is done
	new
		man = FindBriefcaseMan(mission),
		bool: foundMan = (man != INVALID_NPC_ID);

	ASSERT_TRUE(foundMan);

	if (man != INVALID_NPC_ID)
	{
		new
			Float: X,
			Float: Y,
			Float: Z;

		GetPlayerPos(man, X, Y, Z);
		PlaceTestPlayer(playerid, X + 1.0, Y, Z);
		SetPlayerInterior(playerid, 0);

		CheckBriefcaseManProximity(playerid, man);
	}

	ASSERT_EQ(GetPlayerMoney(playerid), briefcases * COMBAT_BRIEFCASE_DOLLARS);
	ASSERT_FALSE(gCombatMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gCombatOccupant, INVALID_PLAYER_ID);

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 5 AND spec_id = %d AND value = %d AND user_id = %d", mission, briefcases, userid);
	ASSERT_EQ(QueryTestInt(query), 1);

	// Everything it made is gone, and nothing of it is remembered
	ASSERT_FALSE(IsValidTimer(timerUpdate));
	ASSERT_FALSE(IsValidTimer(timerMan));
	ASSERT_FALSE(IsValidVehicle(heli));
	ASSERT_EQ(CountCombatNPCs(), 0);

	new
		left = 0;

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		if (gCombatPickups[i][Pickup] != INVALID_PICKUP || gCombatPickups[i][Type] != CombatPickupType: TYPE_NONE)
		{
			left++;
		}
	}

	ASSERT_EQ(left, 0);

	// Ending a mission that is not running does nothing
	ASSERT_EQ(AbortCombatMission(playerid, true), 1);
	ASSERT_EQ(GetPlayerMoney(playerid), briefcases * COMBAT_BRIEFCASE_DOLLARS);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 5 AND user_id = %d", userid);
	ExecDBStatement(query);

	gCombatMission[playerid][Dead] = false;
	gCombatMission[rival][Dead] = false;

	ResetPlayerMoney(playerid);
	ResetPlayerWeapons(playerid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(rival);
	DestroyTestPlayer(playerid);

	TEST_END("CombatMissionRun");
}
