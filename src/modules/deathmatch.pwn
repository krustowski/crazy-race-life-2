//
//  deathmatch.pwn
//

enum Deathmatch
{
	bool: InGame,
	bool: IsRegistered,
      	Score
}

enum DeathmatchTimers
{
	Timer: Start,
	Timer: Game
}

new gDeathmatch[MAX_PLAYERS][Deathmatch];
new gDeathmatchTimers[DeathmatchTimers];

forward StartDeathmatch();
forward UpdateDeathmatchScoreboard();
forward EndDeathmatch();

public StartDeathmatch()
{
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
	}

	if (totalPlayers)
	{
		gDeathmatchTimers[Game] = Timer: SetTimer("EndDeathmatch", 4 * 60 * 1000, false);
	}
	else
	{
		SendClientMessageToAll(COLOR_GREY, "[ DEATHMATCH ] No players registered, resetting the minigame.");
	}

	return 1;
}

public EndDeathmatch()
{
	return 1;

}

public UpdateDeathmatchScoreboard()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		if (!gDeathmatch[i][InGame])
			continue;

		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(i, playerName, sizeof(playerName));
		format(stringToPrint, sizeof(stringToPrint), "%20s [ID %2d]: %3d points\n", playerName, i, gDeathmatch[i][Score]);

		SendClientMessage(i, COLOR_GREY, stringToPrint);
	}

	/*if (gPaintball[killerid] > vytezgPaintball)
	  {
	  new killer[MAX_PLAYER_NAME];

	  vytez = killerid;
	  vytezgPaintball = gPaintball[killerid];
	  GetPlayerName(killerid, killer, sizeof(killer));
	  for (new i = 0; i < MAX_PLAYERS; i++)
	  {
	  format(text, sizeof(text), "[ i ] %s je ve vedení ! [ Score: %d ].", killer, vytezgPaintball); //text kdo je ve vedeni podle gPaintball :)
	  SendClientMessage(playerid, COLOR_BILA, text);
	  }
	  }*/

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
	gDeathmatch[playerid][IsRegistered] = true;

	SendClientMessageToAll(COLOR_YELLOW, "[ DEATHMATCH ] Deathmatch starts in 45 seconds! /deathmatch");

	SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
	TogglePlayerControllable(playerid, false);

	new totalPlayers;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && gDeathmatch[i][IsRegistered])
			totalPlayers++;
	}

	if (!totalPlayers)
		SetTimer("StartPaintball", 45 * 1000, false);

	return 1;
}

stock LeaveDeathmatch(playerid)
{
	if (gDeathmatch[playerid][InGame])
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "[ DEATHMATCH ] Player %s left the /deathmatch!", playerName);
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

		gDeathmatch[playerid][InGame] = false;
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
	}

	return 1;
}
