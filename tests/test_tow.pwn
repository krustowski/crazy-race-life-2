//
//  test_tow.pwn
//

Test: TowModelBonus()
{
	TEST_START("TowModelBonus");

	new
		playerid = CreateTestPlayer();

	for (new i = 0; i < MAX_VEHICLE_MODELS; i++)
	{
		gTowMission[playerid][Models][i] = false;
	}

	gTowMission[playerid][ModelCount] = 0;

	// A model's first tow earns the bonus, later ones of the same model don't
	ASSERT_EQ(CheckVehicleModelTowed(playerid, 411), 1);
	ASSERT_EQ(gTowMission[playerid][ModelCount], 1);
	ASSERT_EQ(CheckVehicleModelTowed(playerid, 411), 0);
	ASSERT_EQ(gTowMission[playerid][ModelCount], 1);

	ASSERT_EQ(CheckVehicleModelTowed(playerid, 400), 1);
	ASSERT_EQ(CheckVehicleModelTowed(playerid, 400 + MAX_VEHICLE_MODELS - 1), 1);
	ASSERT_EQ(gTowMission[playerid][ModelCount], 3);

	// Past the model table
	ASSERT_EQ(CheckVehicleModelTowed(playerid, 400 + MAX_VEHICLE_MODELS), 0);
	ASSERT_EQ(gTowMission[playerid][ModelCount], 3);

	// Only from the driver's seat of a tow truck, and not mid minigame
	gPlayers[playerid][InMinigame] = true;
	ToggleTowMission(playerid);
	ASSERT_FALSE(gTowMission[playerid][Active]);

	gPlayers[playerid][InMinigame] = false;
	ToggleTowMission(playerid);
	ASSERT_FALSE(gTowMission[playerid][Active]);
	ASSERT_FALSE(gPlayers[playerid][InMinigame]);

	DestroyTestPlayer(playerid);

	TEST_END("TowModelBonus");
}
