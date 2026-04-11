/*
 *   
 *    .d8888b.                                    8888888b.                            888      d8b  .d888          .d8888b.  
 *    d88P  Y88b                                   888   Y88b                           888      Y8P d88P"          d88P  Y88b 
 *    888    888                                   888    888                           888          888                   888 
 *    888        888d888 8888b.  88888888 888  888 888   d88P  8888b.   .d8888b .d88b.  888      888 888888 .d88b.       .d88P 
 *    888        888P"      "88b    d88P  888  888 8888888P"      "88b d88P"   d8P  Y8b 888      888 888   d8P  Y8b  .od888P"  
 *    888    888 888    .d888888   d88P   888  888 888 T88b   .d888888 888     88888888 888      888 888   88888888 d88P"      
 *    Y88b  d88P 888    888  888  d88P    Y88b 888 888  T88b  888  888 Y88b.   Y8b.     888      888 888   Y8b.     888"       
 *     "Y8888P"  888    "Y888888 88888888  "Y88888 888   T88b "Y888888  "Y8888P "Y8888  88888888 888 888    "Y8888  888888888  
 *                                             888                                                                             
 *                                        Y8b d88P                                                                             
 *                                         "Y88P"                                                                              

 *  GameMode CRL2

 *  Created: 	Jan 2025 (Extends legacy GameMode CRL (2008-2010))
 *  Credits: 	krusty, kompry, DRaGsTeR, amdulka, cranyy, tack
 *  Language: 	EN, CZ
 *  Version: 	0.10.z
 *
 */


#include <open.mp>

#include "support/includes.pwn"

main()
{
	PrintAsciiLogoToLogs();
	printf(" ");
	printf(" * Starting up...");
}

public OnGameModeInit()
{
	SetGameModeText(GAMEMODE_NAME);

	AllowAdminTeleport(true);
	AllowInteriorWeapons(true);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(true);  
	EnableZoneNames(true);
	ShowNameTags(true);
	ShowPlayerMarkers(t_PLAYER_MARKERS_MODE: true); 
	UsePlayerPedAnims();

	//
	// Create pickups, static objects and static vehicles + DrawTexts.
	//

	InitDB();
	InitPoliceBribePickups();
	InitBankLocations();
	InitDrugValues();
	InitDrugPickups();

	InitTeams();

	InitRealEstateProperties();
	InitRaces();
	InitHighScores();
	InitTrucking();

	InitPickups();
	InitObjects();
	InitVehicles();
	InitTexts();
	InitTimers();

	return 1;
}

public OnGameModeExit()
{
	PrintAsciiLogoToLogs();
	printf(" ");
	printf(" * Shutting down...");

	KillTimers();

	if (DB_Close(gDbConnectionHandle))
	{
		gDbConnectionHandle = DB: 0;
	}

	return 1;
}

public OnPlayerConnect(playerid)
{
	new 
		playerNameRaw[MAX_PLAYER_NAME], 
		playerName[MAX_PLAYER_NAME], 
		stringToPrint[128];

	ResetPlayerState(playerid);

	// Text inits.
	AddTexts(playerid);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerNameRaw, sizeof(playerNameRaw));
	SanitizeString(playerNameRaw, playerName, MAX_PLAYER_NAME);
	gPlayers[playerid][Name] = playerName;

	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		SpawnPlayer(playerid);
		return 1;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, I18N_PLAYER_CONNECTED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName);
		SendClientMessage(i, COLOR_GREY, stringToPrint);
	}

	SendMessageToWebhook(playerid, "connected", -1);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, COLOR_INVISIBLE, "");
	SendClientMessageLocalized(playerid, I18N_WELCOME_MESSAGE);
	//GetLocalizedString(playerid, I18N_WELCOME_MESSAGE_VERSION_FMT, stringToPrint, sizeof(stringToPrint));

	format(stringToPrint, sizeof(stringToPrint), "%s",
			"{FFD700}CrazyRaceLife2{FFFFFF} (CRL2)"
	      );
	SendClientMessage(playerid, COLOR_GREY, stringToPrint);
	format(stringToPrint, sizeof(stringToPrint), "%s%s",
			"Credits: {00FF00}",
			GAMEMODE_CREDITS
	      );
	SendClientMessage(playerid, COLOR_GREY, stringToPrint);
	format(stringToPrint, sizeof(stringToPrint), "%s%d.%d.%d (%s)",
			"Version: {FFD700}",
		       	CRAZY_RACE_LIFE_2_VERSION_MAJOR,
			CRAZY_RACE_LIFE_2_VERSION_MINOR,
			CRAZY_RACE_LIFE_2_VERSION_PATCH,
			SAMPCTL_BUILD_COMMIT_SHORT
	      );
	SendClientMessage(playerid, COLOR_GREY, stringToPrint);
	SendClientMessage(playerid, COLOR_INVISIBLE, "");

	if (!IsPlayerUsingOmp(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "[ CLIENT ] You don't seem to be using the openMP launcher, some game features may not be available for you. Please visit https://open.mp to get it.");
	}

	// Ask the user to login/register.
	gPlayers[playerid][LoginAttempts] = 0;

	if (IsPlayerConnected(playerid)) 
	{
		//ShowAuthDialog(playerid);
		gPlayers[playerid][LoginTimer] = Timer: SetTimerEx("ShowAuthDialog", 2500, false, "i", playerid);
	}

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		return 1;
	}

	StopAudioStreamForPlayer(playerid);
	gPlayers[playerid][Listening] = false;
	gPlayers[playerid][AFK] = false;

	// Hide the vehicle velocity game text.
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	KillTimer(_: gPlayers[playerid][LoginTimer]);
	KillTimer(_: gPlayerRaceTimer[playerid]);
	KillTimer(_: gPlayerMissions[playerid][TimerElapsed]);
	KillTimer(_: gPlayerMissions[playerid][TimerAttachedCheck]);

	AbortTruckingMission(playerid);
	AbortTowMission(playerid);
	AbortPlayerTaxiMission(playerid);
	AbortCombatMission(playerid, false);

	// Save player's data and set such player to unauthorized.
	if (reason == 1 || reason == 2)
	{
		SavePlayerData(playerid);
	}

	gPlayers[playerid][IsLogged] = false;

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 201);

	SendMessageToWebhook(playerid, "disconnected", reason);

	new 
		stringToPrint[128];

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		// Hotfix for the i18n message enum
		if (reason < 0 || reason > 2)
		{
			reason = 3;
		}

		GetLocalizedString(i, I18N_PLAYER_DISCONNECT_CRASH + reason, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gPlayers[playerid][Name]);
		SendClientMessage(i, COLOR_GREY, stringToPrint);
	}

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
#pragma unused classid
	//SetPlayerPos(playerid, 2323.73, 1283.18, 97.60);
	/*SetPlayerPos(playerid, 1966.1, 1936.1, 127.5);
	SetPlayerCameraPos(playerid, 1871.3, 1933.6, 127.5);
	SetPlayerCameraLookAt(playerid, 1966.1, 1936.1, 127.5);*/

	if (!gPlayers[playerid][IsLogged])
	{
		return 0;
	}

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if (!gPlayers[playerid][IsLogged])
	{
		return 0;
	}

	printf("Player %d requested spawn!", playerid);
	SpawnPlayer(playerid);

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		NPC_SetSkin(playerid, 89);
		NPC_SetInvulnerable(playerid, false);

		// Hide the marker for others
		SetPlayerColor(playerid, 0xFFFFFF00);

		return 1;
	}

	if (!gPlayers[playerid][IsLogged])
	{
		return 1;
	}

	SetPlayerSkin(playerid, gPlayers[playerid][Skin]);

	// Set the player back to the deathmatch area if is set in game.
	if (gDeathmatch[playerid][InGame])
	{
		ResetPlayerDeathmatchState(playerid);
		return 1;
	}

	if (gPlayers[playerid][TeamID])
	{
		new 
			teamid = _: (gPlayers[playerid][TeamID] - PLAYER_TEAM: 1);

		SetPlayerColor(playerid, gTeams[teamid][Color]);

		ResetPlayerWeapons(playerid);

		for (new i = 0; i < MAX_TEAM_WEAPONS; i++)
		{
			KillTimer(_: gPlayers[playerid][OnDeathGunsTimer][i]);

			if (gTeams[teamid][Weapons][i] && gTeams[teamid][Ammo][i])
			{
       				gPlayers[playerid][OnDeathGunsTimer][i] = Timer: SetTimerEx("GivePlayerWeaponEx", 2000, false, "i,i,i,i", playerid, i, gTeams[teamid][Weapons][i], gTeams[teamid][Ammo][i]);
			}
		}
	}

	if (gPlayers[playerid][InsideProperty])
	{
		DestroyPropertyInterior(playerid);
		gPlayers[playerid][InsideProperty] = false;
	}

	// Respawn at player(s house.
	if (gPlayers[playerid][SpawnPoint])
	{
		if (SpawnPlayerAtProperty(playerid))
		{
			return 1;
		}
	}

	// Default location to spawrn a player (LV pyramid).
	//SetPlayerPos(playerid, 2323.73, 1283.18, 97.60);
	SetPlayerPos(playerid, 2248.22, 1239.58, 10.82);

	return 1;
}

public OnNPCDeath(npcid, killerid, WEAPON:reason)
{
	NPC_Destroy(npcid);

	AbortPlayerTaxiMission(killerid);

	return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	SendDeathMessage(killerid, playerid, reason);

	// Hide velocity meters.
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	if (gDeathmatch[playerid][InGame] && playerid != killerid && killerid != INVALID_PLAYER_ID)
	{
		// Increment the killer's score.
		gDeathmatch[killerid][Score]++;

		return ResetPlayerDeathmatchState(playerid);
	}

	if (gCombatMission[playerid][Active])
	{
		gCombatMission[playerid][Dead] = true;
		AbortCombatMission(playerid, false);
	}

	AbortTruckingMission(playerid);
	AbortTowMission(playerid);
	AbortPlayerTaxiMission(playerid);
	//AbortCombatMission(playerid, false);

	new 
		raceid = CheckPlayerRaceState(playerid);

	if (raceid)
	{
		ResetPlayerRaceState(playerid, raceid, false);
	}

	CreateDeathMoneyPickup(playerid);

	if (killerid != INVALID_PLAYER_ID && IsPlayerConnected(killerid) && killerid != playerid) 
	{
		HandleCarKill(playerid, killerid, reason);
	}

	SetPlayerHealth(playerid, 100.0);

	SetTimerEx("SpawnPlayerDelayed", 250, false, "i", playerid);

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (gProperties[i][Vehicle][ID] != vehicleid)
		{
			continue;
		}

		if (gProperties[i][Vehicle][Colours][0])
		{
			ChangeVehicleColours(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Colours][0], gProperties[i][Vehicle][Colours][1]);
		}

		for (new j = 0; j < 16; j++)
		{
			if (gProperties[i][Vehicle][Components][j])
			{
				AddVehicleComponent(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Components][j]);
			}
		}

		ChangeVehiclePaintjob(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Paintjob]);

		// Lock the vehicle for everyone
		SetVehicleParamsEx(vehicleid, false, false, false, true, false, false, false);
	}

	SetVehicleNumberPlate(vehicleid, VEHICLE_PLATE);

	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if (!IsPlayerConnected(killerid))
	{
		return 1;
	}

	if (gTrucking[killerid])
	{
		if (vehicleid == gPlayerMissions[killerid][VehicleID] || vehicleid == gPlayerMissions[killerid][TrailerID])
		{
			return AbortTruckingMission(killerid);
		}
	}

	if (gTaxiMission[killerid][Active] && vehicleid == gTaxiMission[killerid][VehicleID])
	{
		return AbortPlayerTaxiMission(killerid);
	}

	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][Vehicle][ID] != vehicleid)
		{
			continue;
		}

		new t_CARMODTYPE: componentType = GetVehicleComponentType(componentid);

		if (componentType == CARMODTYPE_NONE)
		{
			break;
		}

		gProperties[i][Vehicle][Components][componentType] = componentid;
		SendClientMessageLocalized(playerid, I18N_REAL_VEHICLE_MOD_SAVED);
	}

	return 1;
}

public OnPlayerText(playerid, text[])
{
	if (strlen(text) > 1 && text[0] == '!' && gPlayers[playerid][TeamID])
	{
		new 
			stringToPrint[256];

		text[0] = ' ';
		format(stringToPrint, sizeof(stringToPrint), "%s [Team Chat]:%s", gPlayers[playerid][Name], text);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i) && gPlayers[i][TeamID] == gPlayers[playerid][TeamID])
			{
				SendClientMessage(i, gTeams[ _: gPlayers[i][TeamID] - 1 ][Color], stringToPrint);
			}
		}

		return 0;
	}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source)
{
	if (gPlayers[playerid][AdminLevel] < 1)
	{
		return 1;
	}

	return ShowPlayerClickedDialog(playerid, clickedplayerid);
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if (gPlayers[playerid][AdminLevel] < 3)
	{
		return 0;
	}

	SetPlayerPosFindZ(playerid, fX, fY, fZ);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (!gPlayers[playerid][IsLogged])
	{
		return 1;
	}

	// See src/support/dcmd.pwn
	return LoadDcmdAll(playerid, cmdtext);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		return 1;
	}

	if (gTrucking[playerid] && vehicleid == gPlayerMissions[playerid][VehicleID])
	{
		SetVehicleParamsForPlayer(vehicleid, playerid, false, false);
	}

	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	// Hide velocity meters.
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	if (gTrucking[playerid])
	{
		SetVehicleParamsForPlayer(vehicleid, playerid, true, false);
		SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] You cannot complete the mission on foot, go back into the truck");
		return 1;
	}

	return 1;
}

public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);
		return 1;
	}

	// Hide the velocity meter on vehicle exit.
	if ((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && newstate == PLAYER_STATE_ONFOOT)
	{
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);
	}

	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		TextDrawShowForPlayer(playerid, gVehicleStatesText[playerid]);
	}

	/*if (newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == gAdminAuto)
	{
		if (!IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] This vehicle is reserved and will be destroyed!");
			GameTextForPlayer(playerid, "~r~Only for ~b~RCON ~g~admins", 5000, 5);
			SetVehicleHealth(GetPlayerVehicleID(playerid), 100.0);
		}
		else
		{
			SendClientMessage(playerid, COLOR_CYAN, "[ ADMIN CAR ] Armoured mode enabled");
			SetVehicleHealth(GetPlayerVehicleID(playerid), 99999 * 1000);
		}
	}*/

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return HandleDialogResponse(playerid, dialogid, response, listitem, inputtext);
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if (CheckRaceCheckpoint(playerid))
	{
		return 1;
	}

	if (CheckTowMissionCheckpoint(playerid))
	{
		return 1;
	}
	
	if (CheckTruckingCheckpoint(playerid))
	{
		return 1;
	}

	if (CheckTaxiMissionCheckpoint(playerid))
	{
		return 1;
	}

	if (CheckCombatCheckpoint(playerid))
	{
		return 1;
	}

	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	// Hotfix due to the logic of EnsurePickupCreated(...) function
	if (!pickupid)
	{
		return 1;
	}

	//
	//  Banking
	//

	for (new i = 0; i < MAX_ATM_PICKUPS; i++)
	{
		if (gBankPickups[i] != pickupid)
		{
			continue;
		}

		if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
		{
			break;
		}

		/*if (gPlayers[playerid][DialogShown])
		{
			continue;
		}*/

		return ShowBankOptionsDialog(playerid);
	}

	//
	//  Various jobs/teams pickups.
	//

	for (new i = 0; i < MAX_TEAMS; i++)
	{
		for (new j = 0; j < MAX_TEAM_PICKUPS; j++)
		{
			if (pickupid == _: gTeams[i][Pickups][j])
			{
				return ShowMenuForPlayer(Menu:gTeams[i][Menus][0], playerid);
			}
		}
	}

	//
	//  Combat pickups
	//

	if (CheckCombatPickup(playerid, pickupid))
	{
		return 1;
	}

	if (CheckDeathmatchPickups(playerid, pickupid))
	{
		return 1;
	}

	//
	//  Real Estate pickups.
	//

	if (CheckRealEstatePickup(playerid, pickupid))
	{
		return 1;
	}

	//
	//  Drugz.
	//

	if (CheckDrugzPickup(playerid, pickupid))
	{
		return 1;
	}

	if (CheckBlackMarketPickup(playerid, pickupid))
	{
		return 1;
	}

	//
	//  Other pickups --- entries, baggies etc.
	//

	if (CheckGenericPickup(playerid, pickupid))
	{
		return 1;
	}

	if (CheckPoliceBribePickup(playerid, pickupid))
	{
		return 1;
	}

	//
	//  Death pickups.
	//

	if (CheckDeathMoneyPickup(playerid, pickupid))
	{
		return 1;
	}

	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new 
		Menu: currentMenu = GetPlayerMenu(playerid), 
		stringToPrint[256];

	if (row == 2)
	{
		return 1;
	}

	if (row == 1)
	{
		ResetPlayerWeapons(playerid);
		gPlayers[playerid][TeamID] = TEAM_NONE;

		SendClientMessage(playerid, COLOR_GREY, "[ TEAM ] You left the team!");
		SetPlayerTeam(playerid, 0);

		return 1;
	}

	for (new i = 0; i < MAX_TEAMS; i++)
	{
		if (currentMenu == gTeams[i][Menus][0])
		{
			for (new j = 0; j < MAX_TEAM_WEAPONS; j++)
			{
				if (gTeams[i][Weapons][j])
				{
					GivePlayerWeapon(playerid, WEAPON: gTeams[i][Weapons][j], gTeams[i][Ammo][j]);
				}
			}

			SetPlayerColor(playerid, gTeams[i][Color]);
			SetPlayerSkin(playerid, gTeams[i][Skins][0]);
			SetPlayerTeam(playerid, gTeams[i][ID]);

			gPlayers[playerid][TeamID] = PLAYER_TEAM: gTeams[i][ID];

			format(stringToPrint, sizeof(stringToPrint), "[ TEAM ] Player %s joined the %s team!", gPlayers[playerid][Name], gTeams[i][TeamName]);
			SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
			break;
		}
	}

	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
	return HandlePlayerKeyStateChange(playerid, newkeys, oldkeys);
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
	if (enterexit == 0) // If enterexit is 0, this means they are exiting
	{
		UpdatePropertyVehicle(playerid);
	}

	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	UpdatePropertyVehiclePaintjob(playerid, vehicleid, paintjobid);
	return 1;
}

// TODO: This does not work properly in game: deattached trailer is not recognized or this playback is not called at all..
public OnTrailerUpdate(playerid, vehicleid)
{
	if (!gTrucking[playerid])
	{
		return 1;
	}

	/*if (vehicleid != gPlayerMissions[playerid][TrailerID])
	  {
	  return 1;
	  }*/

	/*if (IsTrailerAttachedToVehicle(gPlayerMissions[playerid][VehicleID]))
	  {
	  SetVehicleParamsForPlayer(vehicleid, playerid, false, false);
	  return 1;
	  }

	  SetVehicleParamsForPlayer(vehicleid, playerid, true, false);
	  SendClientMessage(playerid, COLOR_ORANGE, "[ TRUCK ] The trailer has just detached from the cab, reatach it to continue the mission");*/

	return 1;
}

enum AO
{
	Float: X,
	Float: Y,
	Float: Z,
	Float: rX,
	Float: rY,
	Float: rZ,
	Float: sX,
	Float: sY,
	Float: sZ
}

new gPlayerAO[MAX_PLAYERS][AO];

public OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	switch (response)
	{
		case EDIT_RESPONSE_FINAL:
			{
				gPlayerAO[playerid][X] = fOffsetX;
				gPlayerAO[playerid][Y] = fOffsetY;
				gPlayerAO[playerid][Z] = fOffsetZ;
				gPlayerAO[playerid][rX] = fRotX;
				gPlayerAO[playerid][rY] = fRotY;
				gPlayerAO[playerid][rZ] = fRotZ;
				gPlayerAO[playerid][sX] = fScaleX;
				gPlayerAO[playerid][sY] = fScaleY;
				gPlayerAO[playerid][sZ] = fScaleZ;
			}
		case EDIT_RESPONSE_CANCEL:
			{
				SetPlayerAttachedObject(playerid, index, modelid, boneid, gPlayerAO[playerid][X], gPlayerAO[playerid][Y], gPlayerAO[playerid][Z], gPlayerAO[playerid][rX], gPlayerAO[playerid][rY], gPlayerAO[playerid][rZ], gPlayerAO[playerid][sX], gPlayerAO[playerid][sY], gPlayerAO[playerid][sZ]);

				new 
					stringToPrint[512];
				format(stringToPrint, sizeof(stringToPrint), "AO: X: %.2f, Y: %.2f, Z: %.2f, rX: %.2f, rY: %.2f, rZ: %.2f, sX: %.2f, sY: %.2f, sZ: %.2f", 
						gPlayerAO[playerid][X],
						gPlayerAO[playerid][Y],
						gPlayerAO[playerid][Z],
						gPlayerAO[playerid][rX],
						gPlayerAO[playerid][rY],
						gPlayerAO[playerid][rZ],
						gPlayerAO[playerid][sX],
						gPlayerAO[playerid][sY],
						gPlayerAO[playerid][sZ]
				      );

				SendClientMessage(playerid, COLOR_GREY, stringToPrint);
				ClearAnimations(playerid);
			}
	}

	return 1;
}

public OnPlayerLeavePlayerGangZone(playerid, zoneid)
{
	if (zoneid == gDeathmatchGangZone[playerid])
	{
		new 
			stringToPrint[64];
		format(stringToPrint, sizeof(stringToPrint), "[ DEATHMATCH ] Get back to the arena!");
		SendClientMessage(playerid, COLOR_RED, stringToPrint);
	}

	return 1;
}

/*

 *       ______                       ____                  __    _ ____    ___ 
 *      / ____/________ _____  __  __/ __ \____ _________  / /   (_) __/__ |__ \
 *     / /   / ___/ __ `/_  / / / / / /_/ / __ `/ ___/ _ \/ /   / / /_/ _ \__/ /
 *    / /___/ /  / /_/ / / /_/ /_/ / _, _/ /_/ / /__/  __/ /___/ / __/  __/ __/ 
 *    \____/_/   \__,_/ /___/\__, /_/ |_|\__,_/\___/\___/_____/_/_/  \___/____/ 
 *                          /____/                                              

 *  GameMode CRL2 
 *  Credits: krusty, kompry, DRaGsTeR, amdulka, cranyy, tack
 *  Jan 2025

 */

