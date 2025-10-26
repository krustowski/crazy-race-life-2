#if defined _CRL2_DEATHMATCH
	#endinput
#endif
#define _CRL2_DEATHMATCH

//
//  deathmatch.pwn
//

#define DEATHMATCH_TIME_SECONDS 240

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

new gDeathmatch[MAX_PLAYERS][Deathmatch];
new gDeathmatchTimers[DeathmatchTimers];
new Text: gDeathmatchText[MAX_PLAYERS];

new gDeathmatchGangZone[MAX_PLAYERS];

forward StartDeathmatch();
forward UpdateDeathmatchScoreboard();
forward EndDeathmatch();

public StartDeathmatch()
{
	KillTimer(_: gDeathmatchTimers[Start]);
	gDeathmatchTimers[Start] = Timer: 0;

	new totalPlayers;

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
	}
	else
	{
		SendClientMessageToAll(COLOR_GREY, "[ DEATHMATCH ] No players registered, resetting the minigame.");
		EndDeathmatch();
	}

	return 1;
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

	KillTimer(_: gDeathmatchTimers[Elapsed]);
	KillTimer(_: gDeathmatchTimers[Game]);

	gDeathmatchTimers[Elapsed] = Timer: 0;
	gDeathmatchTimers[Game] = Timer: 0;

	return 1;
}

public UpdateDeathmatchScoreboard()
{
	new stringToPrint[256], topPlayer, topPlayerName[MAX_PLAYER_NAME], topScore, totalPlayers;

	gDeathmatchTimers[TimeElapsed] -= 1000;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		if (!gDeathmatch[i][InGame])
			continue;

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

		format(stringToPrint, sizeof(stringToPrint), "~w~Players:_~g~%d~n~~w~Leader:__~y~%s:_~g~%2d~n~~w~Time:____~b~%d~y~:~b~%2d", totalPlayers, topPlayerName, topScore, floatround(floatround(gDeathmatchTimers[TimeElapsed] / 1000) / 60), floatround(gDeathmatchTimers[TimeElapsed] / 1000) % 60);

		TextDrawSetString(gDeathmatchText[i], stringToPrint);
		TextDrawShowForPlayer(i, gDeathmatchText[i]);
	}

	if (!totalPlayers)
	{
		KillTimer(_: gDeathmatchTimers[Elapsed]);
		KillTimer(_: gDeathmatchTimers[Game]);

		if (gDeathmatchTimers[TimeElapsed])
			SendClientMessageToAll(COLOR_GREY, "[ DEATHMATCH ] No players in game, resetting the minigame.");
	}

	return 1;
}

stock SaveScores()
{
	new topScore = 0, topPlayerID;

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

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
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
		return SendClientMessage(playerid, COLOR_GREY, "[ DEATHMATCH ] The game already started, try again later!");
	}

	gDeathmatch[playerid][Score] = 0;
	gDeathmatch[playerid][IsRegistered] = true;

	SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
	TogglePlayerControllable(playerid, false);

	if (!gDeathmatchTimers[Start])
	{
		SendClientMessageToAll(COLOR_YELLOW, "[ DEATHMATCH ] Deathmatch starts in 45 seconds! Join /deathmatch!");
		gDeathmatchTimers[Start] = Timer: SetTimer("StartDeathmatch", 45 * 1000, false);
	}

	GameTextForPlayer(playerid, "~w~Waiting for others to join", 45000, 3); 

	return 1;
}

stock LeaveDeathmatch(playerid)
{
	if (gDeathmatch[playerid][InGame] || gDeathmatch[playerid][IsRegistered])
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "[ DEATHMATCH ] Player %s left the /deathmatch!", playerName);
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

		PlayerGangZoneHide(playerid, gDeathmatchGangZone[playerid]);
		UsePlayerGangZoneCheck(playerid, gDeathmatchGangZone[playerid], false);
		PlayerGangZoneDestroy(playerid, gDeathmatchGangZone[playerid]);

		TextDrawHideForPlayer(playerid, gDeathmatchText[playerid]);
		HideGameTextForPlayer(playerid, 3);

		gDeathmatch[playerid][IsRegistered] = false;
		gDeathmatch[playerid][InGame] = false;

		TogglePlayerControllable(playerid, true);
		ResetPlayerWeapons(playerid);

		SpawnPlayer(playerid);
	}

	return 1;
}
