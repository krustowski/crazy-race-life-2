public AntiJetPack()
{
	new wang[MAX_PLAYER_NAME], string[256];
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i) && !IsPlayerAdmin(i))
		{
			if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			{
				GetPlayerName(i, wang, MAX_PLAYER_NAME);
				format(string, sizeof(string), "[ ! ] Hráè %s byl vyhozen za poruení pravidel. [Jet Pack]", wang);
				SendClientMessageToAll(COLOR_CERVENA, string);
				PlayerPlaySound(i, 1056, 0, 0, 0);
				Kick(i);
			}
		}
	}
	return 1;
}

public AntiCheatWeapon()
{
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (!IsPlayerAdmin(i))
		{
			new WeData[13][2];
			GetPlayerWeaponData(i, 7, WeData[7][0], WeData[7][1]);
			if (WeData[7][0] == 38 || WeData[7][0] == 37 || WeData[7][0] == 36)
			{
				new wang[MAX_PLAYERS], string[256];
				GetPlayerName(i, wang, MAX_PLAYER_NAME);
				format(string, sizeof(string), "Hráè %s byl vyhozen za weapon cheat", wang);
				SendClientMessageToAll(COLOR_CERVENA, string);
				Kick(i);
			}
		}
	}
	return 1;
}

