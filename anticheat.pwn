public AntiCheatWeapon()
{
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i) && !IsPlayerAdmin(i))
		{
			new weaponData[13][2];

			GetPlayerWeaponData(i, t_WEAPON_SLOT: 7, t_WEAPON: weaponData[7][0], weaponData[7][1]);

			if (weaponData[7][0] == 38 || weaponData[7][0] == 37 || weaponData[7][0] == 36)
			{
				new playerName[MAX_PLAYERS], stringToPrint[128];

				GetPlayerName(i, playerName, MAX_PLAYER_NAME);
				format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s byl(a) vyhozen(a) za weapon cheat!", playerName);
				SendClientMessageToAll(COLOR_CERVENA, stringToPrint);

				Kick(i);
			}
		}
	}

	return 1;
}

public AntiJetPack()
{
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i) && !IsPlayerAdmin(i))
		{
			if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			{
				new playerName[MAX_PLAYER_NAME], stringToPrint[128];

				GetPlayerName(i, playerName, MAX_PLAYER_NAME);
				format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s byl(a) vyhozen(a) za poruseni  pravidel. [JetPack]", playerName);
				SendClientMessageToAll(COLOR_CERVENA, stringToPrint);

				PlayerPlaySound(i, 1056, 0, 0, 0);
				Kick(i);
			}
		}
	}

	return 1;
}

public AntiFlood()
{
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i) && GetPlayerPing(i) == 0)
		{
			new ipAddress[128], stringToPrint[128];

			GetPlayerIp(i, ipAddress, 128);
			format(stringToPrint, 256, "IP: %s se pokousela floodovat server. Byl udelen ban.\n", ipAddress);

			PlayerPlaySound(i, 1056, 0, 0, 0);
			Ban(i);

			// Log to the server's console log.
			print(stringToPrint);
		}
	}

	return 1;
}

