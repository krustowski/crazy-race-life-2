#if defined _CRL2_ANTICHEAT
	#endinput
#endif
#define _CRL2_ANTICHEAT

//
//  anticheat.pwn
//

forward AntiCheatWeapon();
forward AntiFlood();
forward AntiJetPack();

public AntiCheatWeapon()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}
		
		new 	
			weaponData[13][2];
	
		GetPlayerWeaponData(i, t_WEAPON_SLOT: 7, t_WEAPON: weaponData[7][0], weaponData[7][1]);

		if (weaponData[7][0] == 38 || weaponData[7][0] == 37 || weaponData[7][0] == 36)
		{	
			new 
				playerName[MAX_PLAYER_NAME], 	
				stringToPrint[128];
			
			GetPlayerName(i, playerName, MAX_PLAYER_NAME);

			for (new j = 0; j < MAX_PLAYERS; j++)
			{
				if (!IsPlayerConnected(j))
				{
					continue;
				}

				GetLocalizedString(j, I18N_WEAPON_CHEAT_VIOLATION_FMT, stringToPrint, sizeof(stringToPrint));
				format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName);
				SendClientMessage(j, COLOR_RED, stringToPrint);
			}

			if (!IsPlayerAdmin(i))
			{
				Kick(i);
			}
		}
	}

	return 1;
}

public AntiJetPack()
{
	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}
	
		if (GetPlayerSpecialAction(i) != SPECIAL_ACTION_USEJETPACK)
		{
			continue;
		}
			
		new 
			playerName[MAX_PLAYER_NAME], 
			stringToPrint[128];

		GetPlayerName(i, playerName, MAX_PLAYER_NAME);

		for (new j = 0; j < MAX_PLAYERS; j++)
		{
			if (!IsPlayerConnected(j))
			{
				continue;
			}

			GetLocalizedString(j, I18N_JETPACK_VIOLATION_FMT, stringToPrint, sizeof(stringToPrint));
			format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName);
			SendClientMessage(j, COLOR_RED, stringToPrint);
		}

		if (!IsPlayerAdmin(i))
		{
			PlayerPlaySound(i, 1056, 0, 0, 0);
			Kick(i);
		}
	}

	return 1;
}

public AntiFlood()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i)) 
		{
			continue;
		}

		if (GetPlayerPing(i) > 0) 
		{
			continue;
		}

		if (IsPlayerNPC(i) || NPC_IsValid(i))
		{
			continue;
		}
	
		new 
			ipAddress[128], 	
			stringToPrint[128];

		GetPlayerIp(i, ipAddress, sizeof(ipAddress));	

		for (new j = 0; j < MAX_PLAYERS; j++)
		{
			if (!IsPlayerConnected(j))
			{
				continue;
			}

			GetLocalizedString(j, I18N_IP_FLOOD_VIOLATION_FMT, stringToPrint, sizeof(stringToPrint));
			format(stringToPrint, sizeof(stringToPrint), stringToPrint, ipAddress);
			SendClientMessage(j, COLOR_RED, stringToPrint);
		}

		PlayerPlaySound(i, 1056, 0, 0, 0);
		Ban(i);

		// Log to the server's console log.
		print(stringToPrint);
	}

	return 1;
}

