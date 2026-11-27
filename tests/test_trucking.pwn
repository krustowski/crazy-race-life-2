//
//  test_trucking.pwn
//
//  CheckPlayerForTruckingMission() wants a driver with a trailer, which a
//  test NPC cannot be inside main(); these drive the mission from there on.
//

stock EnsureTruckingLoaded()
{
	if (!gTruckingPoints[1][ID])
	{
		InitTrucking();
	}

	return 1;
}

// The id of the first gas station that has a delivery checkpoint, or 0
stock FirstTestGasStation()
{
	new
		query[160];

	format(query, sizeof(query), "SELECT IFNULL(MIN(p.id), 0) FROM trucking_points AS p JOIN trucking_coords AS c ON c.trucking_id = p.id AND c.type = %d WHERE p.type = %d", CT_CHECKPOINT, FT_GAS_STATION);
	return QueryTestInt(query);
}

stock bool: CloseTo(Float: a, Float: b)
{
	return (floatabs(a - b) < 0.01);
}

stock ResetTestTruckingMission(playerid)
{
	gTrucking[playerid] = false;
	gPlayers[playerid][InMinigame] = false;

	gPlayerMissions[playerid][Type] = MT_NONE;
	gPlayerMissions[playerid][DoneCount] = 0;
	gPlayerMissions[playerid][Earned] = 0;
	gPlayerMissions[playerid][TimeElapsed] = 0;
	gPlayerMissions[playerid][CommissionBonusWeight] = 0.0;
	gPlayerMissions[playerid][Checkpoint][CoordX] = 0.0;
	gPlayerMissions[playerid][Checkpoint][CoordY] = 0.0;
	gPlayerMissions[playerid][Checkpoint][CoordZ] = 0.0;
	gPlayerMissions[playerid][TimerElapsed] = 0;
	gPlayerMissions[playerid][TimerAttachedCheck] = 0;

	return 1;
}

Test: TruckingPointsLoadFromDB()
{
	TEST_START("TruckingPointsLoadFromDB");

	EnsureTruckingLoaded();

	new
		query[256],
		points = 0,
		badName = 0,
		badType = 0,
		badCheckpoint = 0,
		badInfo = 0;

	for (new id = 1; id < MAX_TRUCKING_POINTS; id++)
	{
		format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_points WHERE id = %d", id);

		if (!QueryTestInt(query))
		{
			continue;
		}

		points++;

		// Each point is stored under its own id...
		format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_points WHERE id = %d AND name = '%q'", id, gTruckingPoints[id][Name]);

		if (gTruckingPoints[id][ID] != id || QueryTestInt(query) != 1)
		{
			printf("[trucking] point %d: wrong id or name (%d, '%s')", id, gTruckingPoints[id][ID], gTruckingPoints[id][Name]);
			badName++;
		}

		// ...with its facility type...
		format(query, sizeof(query), "SELECT type FROM trucking_points WHERE id = %d", id);

		if (gTruckingPoints[id][Type] != QueryTestInt(query))
		{
			printf("[trucking] point %d: type %d, the DB says %d", id, gTruckingPoints[id][Type], QueryTestInt(query));
			badType++;
		}

		// ...its own delivery checkpoint...
		new
			hasCheckpoint;

		format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_coords WHERE trucking_id = %d AND type = %d", id, CT_CHECKPOINT);
		hasCheckpoint = QueryTestInt(query);

		if (hasCheckpoint)
		{
			format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_coords WHERE trucking_id = %d AND type = %d AND ABS(x - %f) < 0.01 AND ABS(y - %f) < 0.01 AND ABS(z - %f) < 0.01",
					id, CT_CHECKPOINT,
					gTruckingPoints[id][LocationCheckpoint][CoordX],
					gTruckingPoints[id][LocationCheckpoint][CoordY],
					gTruckingPoints[id][LocationCheckpoint][CoordZ]
				);

			if (QueryTestInt(query) != 1)
			{
				printf("[trucking] point %d: checkpoint %.2f, %.2f is not its own", id, gTruckingPoints[id][LocationCheckpoint][CoordX], gTruckingPoints[id][LocationCheckpoint][CoordY]);
				badCheckpoint++;
			}
		}

		// ...and its own info pickup with the name label over it
		format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_coords WHERE trucking_id = %d AND type = %d", id, CT_INFO_PICKUP);

		if (QueryTestInt(query))
		{
			new
				Float: pX,
				Float: pY,
				Float: pZ;

			GetPickupPos(gTruckingPoints[id][InfoPickup], pX, pY, pZ);
			format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_coords WHERE trucking_id = %d AND type = %d AND ABS(x - %f) < 0.01 AND ABS(y - %f) < 0.01", id, CT_INFO_PICKUP, pX, pY);

			if (!IsValidPickup(gTruckingPoints[id][InfoPickup]) || QueryTestInt(query) != 1 || !IsValid3DTextLabel(gTruckingPoints[id][InfoLabel]))
			{
				printf("[trucking] point %d: info pickup %d / label %d missing", id, gTruckingPoints[id][InfoPickup], _: gTruckingPoints[id][InfoLabel]);
				badInfo++;
			}
		}
	}

	ASSERT_TRUE(points > 0);
	ASSERT_EQ(badName, 0);
	ASSERT_EQ(badType, 0);
	ASSERT_EQ(badCheckpoint, 0);
	ASSERT_EQ(badInfo, 0);

	// The stub row 0 is not a point
	ASSERT_EQ(gTruckingPoints[0][ID], 0);
	ASSERT_EQ(gTruckingPoints[0][Type], 0);

	TEST_END("TruckingPointsLoadFromDB");
}

Test: TruckingNextDestination()
{
	TEST_START("TruckingNextDestination");

	EnsureTruckingLoaded();

	new
		station = FirstTestGasStation(),
		playerid = CreateTestPlayer(),
		query[320];

	ASSERT_TRUE(station > 0);

	if (!station)
	{
		DestroyTestPlayer(playerid);
		return;
	}

	new
		Float: X = gTruckingPoints[station][LocationCheckpoint][CoordX],
		Float: Y = gTruckingPoints[station][LocationCheckpoint][CoordY],
		Float: Z = gTruckingPoints[station][LocationCheckpoint][CoordZ];

	ResetTestTruckingMission(playerid);
	PlaceTestPlayer(playerid, X, Y, Z);

	new
		farEnough = 0,
		isStation = 0,
		rightWeight = 0;

	// The destination is random: a few draws, each a station other than this one
	for (new draw = 0; draw < 8; draw++)
	{
		ASSERT_EQ(SetPlayerTruckingMission(playerid, MT_PETROL), 1);

		new
			Float: cX = gPlayerMissions[playerid][Checkpoint][CoordX],
			Float: cY = gPlayerMissions[playerid][Checkpoint][CoordY],
			Float: cZ = gPlayerMissions[playerid][Checkpoint][CoordZ];

		format(query, sizeof(query), "SELECT COUNT(*) FROM trucking_coords AS c JOIN trucking_points AS p ON p.id = c.trucking_id WHERE c.type = %d AND p.type = %d AND ABS(c.x - %f) < 0.01 AND ABS(c.y - %f) < 0.01",
				CT_CHECKPOINT, FT_GAS_STATION, cX, cY);

		if (QueryTestInt(query) >= 1)
		{
			isStation++;
		}

		if (VectorSize(cX - X, cY - Y, cZ - Z) >= TRUCKING_POINT_MIN_DIST)
		{
			farEnough++;
		}

		// The longer the haul, the bigger the bonus
		if (_FloatEq(gPlayerMissions[playerid][CommissionBonusWeight], (floatabs(X - cX) / 3000 + floatabs(Y - cY) / 3000) / 2))
		{
			rightWeight++;
		}
	}

	ASSERT_EQ(isStation, 8);
	ASSERT_EQ(farEnough, 8);
	ASSERT_EQ(rightWeight, 8);

	// A mission type with no points: refused, the last destination kept
	new
		Float: keptX = gPlayerMissions[playerid][Checkpoint][CoordX];

	ASSERT_EQ(SetPlayerTruckingMission(playerid, MissionType: 99), 0);
	ASSERT_TRUE(CloseTo(gPlayerMissions[playerid][Checkpoint][CoordX], keptX));

	ResetTestTruckingMission(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("TruckingNextDestination");
}

Test: TruckingDeliveryPays()
{
	TEST_START("TruckingDeliveryPays");

	EnsureTruckingLoaded();

	new
		station = FirstTestGasStation(),
		playerid = CreateTestPlayer();

	if (!station)
	{
		DestroyTestPlayer(playerid);
		return;
	}

	ResetTestTruckingMission(playerid);
	PlaceTestPlayer(playerid,
			gTruckingPoints[station][LocationCheckpoint][CoordX],
			gTruckingPoints[station][LocationCheckpoint][CoordY],
			gTruckingPoints[station][LocationCheckpoint][CoordZ]
		);
	ResetPlayerMoney(playerid);

	// No mission, no pay
	ASSERT_EQ(CheckTruckingCheckpoint(playerid), 0);
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	gTrucking[playerid] = true;
	gPlayerMissions[playerid][Type] = MT_PETROL;
	gPlayerMissions[playerid][TimeElapsed] = 5000;
	gPlayerMissions[playerid][CommissionBonusWeight] = 0.5;

	// First delivery: $10000 plus the weighted bonus, once
	ASSERT_EQ(CheckTruckingCheckpoint(playerid), 1);
	ASSERT_EQ(GetPlayerMoney(playerid), 12500);
	ASSERT_EQ(gPlayerMissions[playerid][Earned], 12500);
	ASSERT_EQ(gPlayerMissions[playerid][DoneCount], 1);
	ASSERT_EQ(gPlayerMissions[playerid][TimeElapsed], 0);

	// The second: random(1) + 1 is always 1, so the bonus counts once again,
	// with the weight of the haul just set
	new
		Float: weight = gPlayerMissions[playerid][CommissionBonusWeight],
		pay = 10000 + floatround(weight * 1 * 5000);

	ASSERT_EQ(CheckTruckingCheckpoint(playerid), 1);
	ASSERT_EQ(GetPlayerMoney(playerid), 12500 + pay);
	ASSERT_EQ(gPlayerMissions[playerid][Earned], 12500 + pay);

	// The third: once or twice
	new
		before = GetPlayerMoney(playerid);

	weight = gPlayerMissions[playerid][CommissionBonusWeight];
	CheckTruckingCheckpoint(playerid);

	new
		paid = GetPlayerMoney(playerid) - before,
		once = 10000 + floatround(weight * 1 * 5000),
		twice = 10000 + floatround(weight * 2 * 5000);

	ASSERT_TRUE(paid == once || paid == twice);
	ASSERT_EQ(gPlayerMissions[playerid][DoneCount], 3);

	ResetTestTruckingMission(playerid);
	ResetPlayerMoney(playerid);
	DestroyTestPlayer(playerid);

	TEST_END("TruckingDeliveryPays");
}

Test: TruckingAbortSavesScore()
{
	TEST_START("TruckingAbortSavesScore");

	new
		playerid = CreateTestPlayer(),
		userid = InsertTestUser("trucker_tester"),
		query[128];

	gPlayers[playerid][OrmID] = userid;
	ResetTestTruckingMission(playerid);

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 4 AND user_id = %d", userid);

	// Not on a mission: nothing to abort
	ASSERT_EQ(AbortTruckingMission(playerid), 1);
	ASSERT_EQ(QueryTestInt(query), 0);

	// Three deliveries done: the mission ends and the count is a high score
	gTrucking[playerid] = true;
	gPlayers[playerid][InMinigame] = true;
	gPlayerMissions[playerid][DoneCount] = 3;

	AbortTruckingMission(playerid);

	ASSERT_FALSE(gTrucking[playerid]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "SELECT value FROM high_scores WHERE type = 4 AND user_id = %d", userid);
	ASSERT_EQ(QueryTestInt(query), 3);

	// Nothing delivered: no score
	gTrucking[playerid] = true;
	gPlayerMissions[playerid][DoneCount] = 0;

	AbortTruckingMission(playerid);

	format(query, sizeof(query), "SELECT COUNT(*) FROM high_scores WHERE type = 4 AND user_id = %d", userid);
	ASSERT_EQ(QueryTestInt(query), 1);

	format(query, sizeof(query), "DELETE FROM high_scores WHERE type = 4 AND user_id = %d", userid);
	ExecDBStatement(query);

	ResetTestTruckingMission(playerid);
	DeleteTestUserByID(userid);
	DestroyTestPlayer(playerid);

	TEST_END("TruckingAbortSavesScore");
}
