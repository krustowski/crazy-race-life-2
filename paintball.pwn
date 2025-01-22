public StartPaintball()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			ResetPlayerWeapons(i);
			GivePlayerWeapon(i, 29, 999);
			TogglePlayerControllable(i, 1);
			SendClientMessage(i, COLOR_ZLUTA, "[ ! ] Paintball zaèal, 4 minuty do konce.");
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);//xD
			SetTimer("konecpaint", 240000, 0);
		}
	}
	return 1;
}

public EndPaintball()
{
	return 1;

}

public GetPaintballScoreboard()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		printf("\n--- Paintball výsledky ---\n");

		if (IsPlayerConnected(i) && gPaintball[i][E_PAINTBALL_INGAME]) 
		{
			new playerName[MAX_PLAYER_NAME];
			GetPlayerName(i, playerName, sizeof(playerName));

			SendClientMessage(i, COLOR_SEDA, "%2d (%20s): %3d bodů\n", i, playerName, gPaintball[i][E_PAINTBALL_SCORE]);
		}
	}

	return 1;
}
