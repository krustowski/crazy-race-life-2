//
//  test_race.pwn
//
//  Race_RegisterPlayer() wants a driver, and a test NPC cannot drive inside
//  main(), so racers are signed up the way it would: RegisterTestRacer().
//

// The seeded races are ids 1-15; these slots are free.
#define RACE_TEST_FINISH_ID		60
#define RACE_TEST_RANKING_ID	61
#define RACE_TEST_EDITOR_ID		62
#define RACE_TEST_SEEDED_ID		4

stock EnsureRacesLoaded()
{
	if (!gRaces[1][ID])
	{
		Race_Init();
	}

	return 1;
}

stock ResetTestRace(raceid)
{
	gRaces[raceid] = gNullRace;

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		gRaces[raceid][RegisteredPlayers][i] = INVALID_PLAYER_ID;
	}

	gRaces[raceid][CountdownTimer] = Timer: INVALID_TIMER;
	gRaces[raceid][StartRaceTimer] = Timer: INVALID_TIMER;
	gRaces[raceid][UpdateRaceInfoTimer] = Timer: INVALID_TIMER;

	return 1;
}

// What Race_RegisterPlayer() records for a racer on grid <slot>
stock RegisterTestRacer(playerid, raceid, slot)
{
	gPlayers[playerid][InMinigame] = true;

	gPlayerRace[playerid][IsRegistered] = true;
	gPlayerRace[playerid][RaceID] = raceid;
	gPlayerRace[playerid][TimeElapsed] = 0;
	gPlayerRace[playerid][CheckpointDoneCount] = 0;
	gPlayerRace[playerid][LastCheckpointTimestamp] = 0;

	gRaces[raceid][RegisteredPlayers][slot] = playerid;
	gRaces[raceid][RegisteredCount]++;

	return 1;
}

stock UnregisterTestRacer(playerid)
{
	gPlayers[playerid][InMinigame] = false;

	gPlayerRace[playerid][IsRegistered] = false;
	gPlayerRace[playerid][RaceID] = 0;
	gPlayerRace[playerid][TimeElapsed] = 0;
	gPlayerRace[playerid][CheckpointDoneCount] = 0;
	gPlayerRace[playerid][LastCheckpointTimestamp] = 0;
	gPlayerRace[playerid][Position] = 0;

	return 1;
}

// <value> against a coordinate column, to a hundredth (the DB keeps two decimals)
stock bool: CoordMatchesDB(Float: value, const query[])
{
	new
		diff = floatround(value * 100.0) - QueryTestInt(query);

	return (diff >= -1 && diff <= 1);
}

Test: RacesLoadFromDB()
{
	TEST_START("RacesLoadFromDB");

	EnsureRacesLoaded();

	new
		raceid = RACE_TEST_SEEDED_ID,
		loaded = 0,
		query[192];

	for (new i = 1; i < MAX_RACE_COUNT; i++)
	{
		if (gRaces[i][ID] == i)
		{
			loaded++;
		}
	}

	format(query, sizeof(query), "SELECT COUNT(*) FROM races WHERE id > 0 AND id < %d", MAX_RACE_COUNT);
	ASSERT_EQ(loaded, QueryTestInt(query));

	format(query, sizeof(query), "SELECT COUNT(*) FROM races WHERE id = %d AND name = '%q' AND type = %d AND cost_dollars = %d AND prize_dollars = %d",
			raceid, gRaces[raceid][Name], gRaces[raceid][Type], gRaces[raceid][CostDollars], gRaces[raceid][PrizeDollars]);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT CAST(ROUND(start_x * 100) AS INTEGER) FROM races WHERE id = %d", raceid);
	ASSERT_TRUE(CoordMatchesDB(gRaces[raceid][Start][CoordX], query));

	// Nobody signed up, nothing running
	ASSERT_EQ(gRaces[raceid][RegisteredCount], 0);
	ASSERT_FALSE(gRaces[raceid][IsActive]);

	new
		free = 0;

	for (new i = 0; i < MAX_RACE_PLAYERS; i++)
	{
		if (gRaces[raceid][RegisteredPlayers][i] == INVALID_PLAYER_ID)
		{
			free++;
		}
	}

	ASSERT_EQ(free, MAX_RACE_PLAYERS);

	// The track, in seq_no order
	ASSERT_EQ(Race_LoadRaceCheckpoints(raceid), 1);

	format(query, sizeof(query), "SELECT COUNT(*) FROM race_coords WHERE race_id = %d", raceid);
	ASSERT_EQ(gRaces[raceid][CheckPointCount], QueryTestInt(query));

	format(query, sizeof(query), "SELECT CAST(ROUND(x * 100) AS INTEGER) FROM race_coords WHERE race_id = %d ORDER BY seq_no ASC LIMIT 1", raceid);
	ASSERT_TRUE(CoordMatchesDB(gRaceCoords[raceid][0][CoordX], query));

	format(query, sizeof(query), "SELECT CAST(ROUND(y * 100) AS INTEGER) FROM race_coords WHERE race_id = %d ORDER BY seq_no DESC LIMIT 1", raceid);
	ASSERT_TRUE(CoordMatchesDB(gRaceCoords[raceid][gRaces[raceid][CheckPointCount] - 1][CoordY], query));

	// A race without a track has nothing to load
	ResetTestRace(RACE_TEST_FINISH_ID);
	ASSERT_EQ(Race_LoadRaceCheckpoints(RACE_TEST_FINISH_ID), 0);
	ASSERT_EQ(gRaces[RACE_TEST_FINISH_ID][CheckPointCount], 0);

	TEST_END("RacesLoadFromDB");
}

Test: RacePositions()
{
	TEST_START("RacePositions");

	new
		raceid = RACE_TEST_RANKING_ID,
		leader = CreateTestPlayer(),
		second = CreateTestPlayer(),
		third = CreateTestPlayer(),
		outsider = CreateTestPlayer();

	ResetTestRace(raceid);
	gRaces[raceid][ID] = raceid;

	RegisterTestRacer(second, raceid, 0);
	RegisterTestRacer(third, raceid, 1);
	RegisterTestRacer(leader, raceid, 2);

	// More checkpoints is ahead; on the same checkpoint, whoever got there first
	gPlayerRace[leader][CheckpointDoneCount] = 5;
	gPlayerRace[leader][LastCheckpointTimestamp] = 90;
	gPlayerRace[second][CheckpointDoneCount] = 5;
	gPlayerRace[second][LastCheckpointTimestamp] = 100;
	gPlayerRace[third][CheckpointDoneCount] = 3;
	gPlayerRace[third][LastCheckpointTimestamp] = 50;

	Race_CalculatePosition(raceid, leader);
	Race_CalculatePosition(raceid, second);
	Race_CalculatePosition(raceid, third);

	ASSERT_EQ(gPlayerRace[leader][Position], 1);
	ASSERT_EQ(gPlayerRace[second][Position], 2);
	ASSERT_EQ(gPlayerRace[third][Position], 3);

	// The third racer overtakes both
	gPlayerRace[third][CheckpointDoneCount] = 6;
	gPlayerRace[third][LastCheckpointTimestamp] = 110;

	Race_CalculatePosition(raceid, leader);
	Race_CalculatePosition(raceid, second);
	Race_CalculatePosition(raceid, third);

	ASSERT_EQ(gPlayerRace[third][Position], 1);
	ASSERT_EQ(gPlayerRace[leader][Position], 2);
	ASSERT_EQ(gPlayerRace[second][Position], 3);

	// Someone not in this race is left alone
	UnregisterTestRacer(outsider);
	gPlayerRace[outsider][Position] = 7;
	Race_CalculatePosition(raceid, outsider);

	ASSERT_EQ(gPlayerRace[outsider][Position], 7);

	UnregisterTestRacer(leader);
	UnregisterTestRacer(second);
	UnregisterTestRacer(third);
	UnregisterTestRacer(outsider);
	ResetTestRace(raceid);

	DestroyTestPlayer(outsider);
	DestroyTestPlayer(third);
	DestroyTestPlayer(second);
	DestroyTestPlayer(leader);

	TEST_END("RacePositions");
}

Test: RaceCheckpointsToFinish()
{
	TEST_START("RaceCheckpointsToFinish");

	new
		raceid = RACE_TEST_FINISH_ID,
		playerid = CreateTestPlayer(),
		quitter = CreateTestPlayer(),
		userid = InsertTestUser("race_tester"),
		quitterid = InsertTestUser("race_quitter"),
		query[192];

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 1 AND spec_id = %d", raceid);
	ExecDBStatement(query);

	// A two-checkpoint ground race with a $5000 prize, under way
	ResetTestRace(raceid);
	gRaces[raceid][ID] = raceid;
	format(gRaces[raceid][Name], MAX_RACE_NAME, "Finish test");
	gRaces[raceid][Type] = 1;
	gRaces[raceid][PrizeDollars] = 5000;
	gRaces[raceid][CheckPointCount] = 2;
	gRaces[raceid][IsActive] = true;

	gRaceCoords[raceid][0][CoordX] = 100.0;
	gRaceCoords[raceid][0][CoordY] = 100.0;
	gRaceCoords[raceid][0][CoordZ] = 10.0;
	gRaceCoords[raceid][1][CoordX] = 200.0;
	gRaceCoords[raceid][1][CoordY] = 100.0;
	gRaceCoords[raceid][1][CoordZ] = 10.0;

	gPlayers[playerid][OrmID] = userid;
	gPlayers[quitter][OrmID] = quitterid;

	ResetPlayerMoney(playerid);
	ResetPlayerMoney(quitter);

	RegisterTestRacer(playerid, raceid, 0);
	gPlayerRace[playerid][TimeElapsed] = 42000;

	// First checkpoint: on the way, nothing paid yet
	ASSERT_EQ(Race_CheckCheckpoint(playerid), 1);
	ASSERT_EQ(gPlayerRace[playerid][CheckpointDoneCount], 1);
	ASSERT_TRUE(gPlayerRace[playerid][LastCheckpointTimestamp] > 0);
	ASSERT_TRUE(gPlayerRace[playerid][IsRegistered]);
	ASSERT_EQ(gPlayerRace[playerid][Position], 1);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	// The last one: the prize, a high score, and the race is over
	Race_CheckCheckpoint(playerid);

	ASSERT_FALSE(gPlayerRace[playerid][IsRegistered]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(gPlayerRace[playerid][CheckpointDoneCount], 0);
	ASSERT_EQ(GetPlayerMoney(playerid), 5000);
	ASSERT_EQ(gRaces[raceid][RegisteredCount], 0);
	ASSERT_EQ(gRaces[raceid][RegisteredPlayers][0], INVALID_PLAYER_ID);
	ASSERT_FALSE(gRaces[raceid][IsActive]);

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 1 AND spec_id = %d AND user_id = %d AND value = 42000", raceid, userid);
	ASSERT_EQ(QueryTestInt(query), 1);

	// ...which tops this race's leaderboard
	new
		same = !strcmp(gHighScores[raceid][Nickname1], "race_tester");

	ASSERT_TRUE(same);
	ASSERT_EQ(gHighScores[raceid][Time][0], 42000);

	// Past the finish there is nothing left to check
	ASSERT_EQ(Race_CheckCheckpoint(playerid), 0);

	// Giving up pays nothing and records nothing
	gRaces[raceid][IsActive] = true;
	RegisterTestRacer(quitter, raceid, 1);
	Race_CheckCheckpoint(quitter);
	Race_AbortMinigame(quitter, false);

	ASSERT_FALSE(gPlayerRace[quitter][IsRegistered]);
	ASSERT_EQ(GetPlayerMoney(quitter), 0);
	ASSERT_FALSE(gRaces[raceid][IsActive]);

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE user_id = %d", quitterid);
	ASSERT_EQ(QueryTestInt(query), 0);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 1 AND spec_id = %d", raceid);
	ExecDBStatement(query);

	gHighScores[raceid][Nickname1][0] = EOS;
	gHighScores[raceid][Time][0] = 0;
	gHighScores[raceid][VehicleModel][0] = 0;

	UnregisterTestRacer(playerid);
	UnregisterTestRacer(quitter);
	ResetTestRace(raceid);

	ResetPlayerMoney(playerid);
	ResetPlayerMoney(quitter);
	DeleteTestUserByID(userid);
	DeleteTestUserByID(quitterid);
	DestroyTestPlayer(quitter);
	DestroyTestPlayer(playerid);

	TEST_END("RaceCheckpointsToFinish");
}

stock DeleteEditorTestRace()
{
	new
		query[96];

	format(query, sizeof(query), "DELETE FROM race_coords WHERE race_id = %d", RACE_TEST_EDITOR_ID);
	ExecDBStatement(query);

	format(query, sizeof(query), "DELETE FROM races WHERE id = %d", RACE_TEST_EDITOR_ID);
	return ExecDBStatement(query);
}

Test: RaceSaveFromEditor()
{
	TEST_START("RaceSaveFromEditor");

	EnsureRacesLoaded();
	DeleteEditorTestRace();

	new
		raceid = RACE_TEST_EDITOR_ID,
		running = RACE_TEST_SEEDED_ID,
		admin = CreateTestPlayer(),
		racer = CreateTestPlayer(),
		query[256];

	ResetTestRace(raceid);

	// Another race is under way while the admin saves a new one
	gRaces[running][IsActive] = true;
	RegisterTestRacer(racer, running, 0);

	gPlayerRaceEdit[admin] = gNullRace;
	gPlayerRaceEdit[admin][ID] = raceid;
	format(gPlayerRaceEdit[admin][Name], MAX_RACE_NAME, "Joe's Sprint");
	gPlayerRaceEdit[admin][CostDollars] = 100;
	gPlayerRaceEdit[admin][PrizeDollars] = 900;
	gPlayerRaceEdit[admin][Start][CoordX] = 1000.0;
	gPlayerRaceEdit[admin][Start][CoordY] = 1000.0;
	gPlayerRaceEdit[admin][Start][CoordZ] = 10.0;
	gPlayerRaceEdit[admin][EditTrackCoordNo] = 3;

	for (new i = 0; i < 3; i++)
	{
		gPlayerRaceEditTrackCoords[admin][i][CoordX] = 1000.0 + 100.0 * float(i + 1);
		gPlayerRaceEditTrackCoords[admin][i][CoordY] = 1000.0;
		gPlayerRaceEditTrackCoords[admin][i][CoordZ] = 10.0;
	}

	new
		saved = SaveRaceData(admin);

	ASSERT_EQ(saved, 1);

	// The race and its whole track, the apostrophe in its name escaped
	format(query, sizeof(query), "SELECT COUNT(*) FROM races WHERE id = %d AND name = 'Joe''s Sprint' AND cost_dollars = 100 AND prize_dollars = 900", raceid);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT COUNT(*) * 100 + MIN(seq_no) * 10 + MAX(seq_no) FROM race_coords WHERE race_id = %d", raceid);
	ASSERT_EQ(QueryTestInt(query), 313);

	// ...and in play straight away
	ASSERT_EQ(gRaces[raceid][ID], raceid);
	ASSERT_EQ(gRaces[raceid][CostDollars], 100);
	ASSERT_EQ(gRaces[raceid][PrizeDollars], 900);

	// The race under way still knows its racer
	ASSERT_TRUE(gRaces[running][IsActive]);
	ASSERT_EQ(gRaces[running][RegisteredCount], 1);
	ASSERT_EQ(gRaces[running][RegisteredPlayers][0], racer);

	// The same id again: the INSERT fails and nothing of it is kept
	saved = SaveRaceData(admin);
	ASSERT_EQ(saved, 0);

	format(query, sizeof(query), "SELECT COUNT(*) FROM race_coords WHERE race_id = %d", raceid);
	ASSERT_EQ(QueryTestInt(query), 3);

	// ...and the connection is not left inside a transaction
	new
		bool: opened = BeginDBTransaction();

	ASSERT_TRUE(opened);

	if (opened)
	{
		CommitDBTransaction();
	}

	DeleteEditorTestRace();
	ResetTestRace(raceid);

	UnregisterTestRacer(racer);
	gRaces[running][IsActive] = false;
	gRaces[running][RegisteredCount] = 0;
	gRaces[running][RegisteredPlayers][0] = INVALID_PLAYER_ID;

	gPlayerRaceEdit[admin] = gNullRace;

	DestroyTestPlayer(racer);
	DestroyTestPlayer(admin);

	TEST_END("RaceSaveFromEditor");
}
