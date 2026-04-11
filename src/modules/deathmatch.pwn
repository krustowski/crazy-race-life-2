#if defined _CRL2_DEATHMATCH
	#endinput
#endif
#define _CRL2_DEATHMATCH

//
//  deathmatch.pwn
//

#define DEATHMATCH_TIME_SECONDS 240
#define MAX_DEATHMATCH_PICKUPS	10

enum Deathmatch
{
	bool: InGame,
	bool: IsRegistered,
      	Score
}

enum DeathmatchTimers
{
	Timer: Start,
	Timer: Game,
	Timer: Elapsed,
	TimeElapsed
}

enum DeathmatchPickup
{
	DeathmatchPickupType: Type,
	Pickup
}

enum DeathmatchPickupType
{
	TYPE_NONE,
	TYPE_HEALTH,
	TYPE_ARMOUR
}

new 
	gDeathmatch[MAX_PLAYERS][Deathmatch],
	gDeathmatchTimers[DeathmatchTimers],
	gDeathmatchPickups[MAX_DEATHMATCH_PICKUPS][DeathmatchPickup],
	Text: gDeathmatchText[MAX_PLAYERS],
	gDeathmatchGangZone[MAX_PLAYERS];

new Float: deathmatchPickups[6][3] = {
        { -1380.62, -2346.69, 35.01 },
        { -1334.16, -2352.38, 36.00 },
        { -1307.00, -2308.74, 35.17 },
        { -1314.60, -2255.89, 31.37 },
        { -1361.84, -2235.61, 32.44 },
        { -1412.34, -2243.93, 34.35 }
};

forward StartDeathmatch();
forward UpdateDeathmatchScoreboard();
forward EndDeathmatch();

public StartDeathmatch()
{
	KillTimer(_: gDeathmatchTimers[Start]);
	gDeathmatchTimers[Start] = Timer: 0;

	new 
		totalPlayers;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || !gDeathmatch[i][IsRegistered])
		{
			continue;
		}

		totalPlayers++;

		gDeathmatch[i][IsRegistered] = false;
		gDeathmatch[i][InGame] = true;

		HideGameTextForPlayer(i, 3);

		gDeathmatchGangZone[i] = CreatePlayerGangZone(i, -1433, -2373, -1293, -2229);
		PlayerGangZoneShow(i, gDeathmatchGangZone[i], 0xFFD700FF);
		UsePlayerGangZoneCheck(i, gDeathmatchGangZone[i], true);

		ResetPlayerDeathmatchState(i);
		TogglePlayerControllable(i, true);

		SendClientMessageLocalized(i, I18N_DEATHMATCH_STARTED);

		PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		GameTextForPlayer(i, "~w~Deathmatch ~g~Started", 3000, 3); 
	}

	if (totalPlayers)
	{
		gDeathmatchTimers[Game] = Timer: SetTimer("EndDeathmatch", DEATHMATCH_TIME_SECONDS * 1000, false);
		gDeathmatchTimers[Elapsed] = Timer: SetTimer("UpdateDeathmatchScoreboard", 1000, true);
		gDeathmatchTimers[TimeElapsed] = DEATHMATCH_TIME_SECONDS * 1000;

		SetDeathmatchPickups();
	}
	else
	{
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			SendClientMessageLocalized(i, I18N_DEATHMATCH_NO_PLAYERS);
		}

		EndDeathmatch();
	}

	return 1;
}

stock SetDeathmatchPickups()
{
	for (new i = 0; i < sizeof(deathmatchPickups); i++)
	{
		if (i % 2)
		{
			gDeathmatchPickups[i][Pickup] = EnsurePickupCreated(PICKUP_HEART, PICKUP_TYPE_RESPAWN_30_SECONDS, deathmatchPickups[i][0], deathmatchPickups[i][1], deathmatchPickups[i][2]);
			gDeathmatchPickups[i][Type] = DeathmatchPickupType: TYPE_HEALTH;
		}
		else
		{
			gDeathmatchPickups[i][Pickup] = EnsurePickupCreated(PICKUP_ARMOUR, PICKUP_TYPE_RESPAWN_30_SECONDS, deathmatchPickups[i][0], deathmatchPickups[i][1], deathmatchPickups[i][2]);
			gDeathmatchPickups[i][Type] = DeathmatchPickupType: TYPE_ARMOUR;
		}
	}
}

stock CheckDeathmatchPickups(playerid, pickupid)
{
	for (new i = 0; i < MAX_DEATHMATCH_PICKUPS; i++)
	{
		if (gDeathmatchPickups[i][Pickup] != pickupid)
		{
			continue;
		}

		switch (gDeathmatchPickups[i][Type])
		{
			case (DeathmatchPickupType: TYPE_HEALTH):
			{
				return SetPlayerHealth(playerid, 100.0);
			}
			case TYPE_ARMOUR:
			{
				return SetPlayerArmour(playerid, 100.0);
			}
			default:
			{}
		}
	}

	return 0;
}

public EndDeathmatch()
{
	SaveScores();

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		if (gDeathmatch[i][InGame] || gDeathmatch[i][IsRegistered])
		{
			LeaveDeathmatch(i);
		}
	}

	for (new i = 0; i < MAX_DEATHMATCH_PICKUPS; i++)
	{
		if (gDeathmatchPickups[i][Pickup])
		{
			DestroyPickup(gDeathmatchPickups[i][Pickup]);
		}
	}

	KillTimer(_: gDeathmatchTimers[Elapsed]);
	KillTimer(_: gDeathmatchTimers[Game]);

	gDeathmatchTimers[Elapsed] = Timer: 0;
	gDeathmatchTimers[Game] = Timer: 0;

	return 1;
}

public UpdateDeathmatchScoreboard()
{
	new 
		stringToPrint[256], 
		topPlayer, 
		topPlayerName[MAX_PLAYER_NAME], 
		topScore, 
		totalPlayers;

	gDeathmatchTimers[TimeElapsed] -= 1000;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		if (!gDeathmatch[i][InGame])
		{
			continue;
		}

		totalPlayers++;

		if (topScore <= gDeathmatch[i][Score])
		{
			topScore = gDeathmatch[i][Score];
			topPlayer = i;
			GetPlayerName(topPlayer, topPlayerName, sizeof(topPlayerName));
		}
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || !gDeathmatch[i][InGame])
		{
			continue;
		}

		GetLocalizedString(i, I18N_DEATHMATCH_INFO_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, 
				totalPlayers, 
				topPlayerName, 
				topScore, 
				floatround(floatround(gDeathmatchTimers[TimeElapsed] / 1000) / 60), 
				floatround(gDeathmatchTimers[TimeElapsed] / 1000) % 60
			);

		TextDrawSetString(gDeathmatchText[i], stringToPrint);
		TextDrawShowForPlayer(i, gDeathmatchText[i]);
	}

	if (!totalPlayers)
	{
		KillTimer(_: gDeathmatchTimers[Elapsed]);
		KillTimer(_: gDeathmatchTimers[Game]);

		if (gDeathmatchTimers[TimeElapsed])
		{
			for (new i = 0; i < MAX_PLAYERS; i++)
			{
				if (!IsPlayerConnected(i))
				{
					continue;
				}

				SendClientMessageLocalized(i, I18N_DEATHMATCH_NO_PLAYERS);
			}
		}
	}

	return 1;
}

stock SaveScores()
{
	new 
		topScore = 0, 
		topPlayerID;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!gDeathmatch[i][InGame])
		{
			continue;
		}

		if (topScore <= gDeathmatch[i][Score])
		{
			topScore = gDeathmatch[i][Score];
			topPlayerID = gPlayers[i][OrmID];
		}
	}

	// Don't write nil scores
	if (!topScore)
	{
		return 1;
	}

	new query[256];

	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id) VALUES (%d, '%d', %d, %d)",
			2,
			1,
			topScore,
			topPlayerID
	      );

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data!");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

stock ResetPlayerDeathmatchState(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPlayerPos(playerid, Float: -1365.1, Float: -2307.0, Float: 39.1);

	GivePlayerWeapon(playerid, t_WEAPON: 30, 999);
	GivePlayerWeapon(playerid, t_WEAPON: 34, 999);

	return 1;
}

stock RegisterToDeathmatch(playerid)
{
	if (IsValidTimer(_: gDeathmatchTimers[Game]))
	{
		return SendClientMessageLocalized(playerid, I18N_DEATHMATCH_ALREADY_STARTED);
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_DEATHMATCH_IN_MINIGAME_BLOCK);
	}

	gDeathmatch[playerid][Score] = 0;
	gDeathmatch[playerid][IsRegistered] = true;

	gPlayers[playerid][InMinigame] = true;

	SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
	TogglePlayerControllable(playerid, false);

	if (!gDeathmatchTimers[Start])
	{
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			SendClientMessageLocalized(i, I18N_DEATHMATCH_PRESTARTED);
		}

		gDeathmatchTimers[Start] = Timer: SetTimer("StartDeathmatch", 45 * 1000, false);
	}

	new 
		gameText[64];

	GetLocalizedString(playerid, I18N_DEATHMATCH_WAITING_FOR_OTHERS, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 45000, 3); 

	return 1;
}

stock LeaveDeathmatch(playerid)
{
	if (gDeathmatch[playerid][InGame] || gDeathmatch[playerid][IsRegistered])
	{
		new 
			playerName[MAX_PLAYER_NAME], 
			stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			GetLocalizedString(i, I18N_DEATHMATCH_PLAYER_LEFT, stringToPrint, sizeof(stringToPrint));
			format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName);
		}

		PlayerGangZoneHide(playerid, gDeathmatchGangZone[playerid]);
		UsePlayerGangZoneCheck(playerid, gDeathmatchGangZone[playerid], false);
		PlayerGangZoneDestroy(playerid, gDeathmatchGangZone[playerid]);

		TextDrawHideForPlayer(playerid, gDeathmatchText[playerid]);
		HideGameTextForPlayer(playerid, 3);

		gDeathmatch[playerid][IsRegistered] = false;
		gDeathmatch[playerid][InGame] = false;

		gPlayers[playerid][InMinigame] = false;

		TogglePlayerControllable(playerid, true);
		ResetPlayerWeapons(playerid);

		SpawnPlayer(playerid);
	}

	return 1;
}
