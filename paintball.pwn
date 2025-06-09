enum E_PAINTBALL
{
	E_PAINTBALL_INGAME,
	E_PAINTBALL_SCORE
}

new gPaintball[MAX_PLAYERS][E_PAINTBALL];

public StartPaintball()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			ResetPlayerWeapons(i);
			GivePlayerWeapon(i, t_WEAPON: 29, 999);
			TogglePlayerControllable(i, true);

			SendClientMessageLocalized(i, I18N_DEATHMATCH_STARTED);

			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);//xD
			SetTimer("konecpaint", 240000, false);
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
		if (IsPlayerConnected(i) && gPaintball[i][E_PAINTBALL_INGAME]) 
		{
			new playerName[MAX_PLAYER_NAME], stringToPrint[128];

			GetPlayerName(i, playerName, sizeof(playerName));
			format(stringToPrint, sizeof(stringToPrint), "%2d (%20s): %3d points\n", i, playerName, gPaintball[i][E_PAINTBALL_SCORE]);

			SendClientMessage(i, COLOR_GREY, stringToPrint);
		}
	}

	return 1;
}
