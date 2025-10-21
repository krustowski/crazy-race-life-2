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

stock ResetPlayerDeathmatchState(playerid)
{
	ResetPlayerWeapons(playerid);
	SetPlayerPos(playerid, Float: -1365.1, Float: -2307.0, Float: 39.1);
	GivePlayerWeapon(playerid, t_WEAPON: 29, 999);

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

		TextDrawHideForPlayer(playerid, gDeathmatchText[playerid]);

		gDeathmatch[playerid][IsRegistered] = false;
		gDeathmatch[playerid][InGame] = false;

		TogglePlayerControllable(playerid, true);
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
	}

	return 1;
}
