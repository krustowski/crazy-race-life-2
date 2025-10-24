/*****************************************************************************************************************************************
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

 [ *** GameMode CRL2 *** ] 

 [ Created: 	Jan 2025 (Extends legacy GameMode CRL (2008-2010)) ]
 [ Credits: 	krusty, kompry, DRaGsTeR, amdulka ]
 [ Language: 	CZ, EN ]
 [ Version: 	0.8.z ]

 *****************************************************************************************************************************************/

//
//  Generic includes.
//

#include <open.mp>
#include <a_mysql>
#include <core>
#include <float>
#include <file>
#include <string>
#include "npc/omp_npcs.inc"

#pragma tabsize 8

//
//  Basic definitions.
//

#define BUG_SYSTEM 	true
#define SECOND_MS	1000

#define SOUND_MUSIC10
#define SOUND_OFF

#include "db/sql.pwn"
#include "support/i18n.pwn" 
#include "support/net.pwn" 
#include "support/http.pwn" 

new const GAMEMODE_NAME[] = "CrazyRaceLife2";

new const MINIMAP_TEXT[] = "~g~Crazy~r~Race~b~Life~y~2";

//
//  Advertisement.
//

#include "support/advert.pwn"

//
//  Anticheating.
//

#include "modules/anticheat.pwn"

//
//  Clock text (re)drawing.
//

#include "support/clock.pwn"

//
//  Racing subsystem.
//

#include "modules/race.pwn"

//
//  Deathmatch minigame.
//

#include "modules/deathmatch.pwn"

//
//  Player data management + team management.
//

#include "modules/player.pwn"
#include "modules/drugz.pwn"
#include "modules/team.pwn"
#include "modules/auth.pwn"
#include "modules/real.pwn"
#include "modules/taxi.pwn"
#include "modules/combat.pwn"


//
//  Trucking subsystem.
//

#include "modules/trucking.pwn"

//
//  Radar + Vehicle velocity/props.
//

#include "modules/radar.pwn"
#include "support/helpers.pwn"

//
//  Banking.
//

#include "modules/bank.pwn"

//
//  Pickups, Objects, Vehicles, Texts, Mapicons...
//

#include "support/pickups.pwn"
#include "support/objects.pwn"
#include "support/vehicles.pwn"
#include "support/texts.pwn"
#include "support/mapicons.pwn"
#include "support/dialogs.pwn"

//
//  DCMDs = command set definitions.
//

#include "support/dcmd.pwn"

/*************************************************************************************
 *
 *       ______                       ____                  __    _ ____    ___ 
 *      / ____/________ _____  __  __/ __ \____ _________  / /   (_) __/__ |__ \
 *     / /   / ___/ __ `/_  / / / / / /_/ / __ `/ ___/ _ \/ /   / / /_/ _ \__/ /
 *    / /___/ /  / /_/ / / /_/ /_/ / _, _/ /_/ / /__/  __/ /___/ / __/  __/ __/ 
 *    \____/_/   \__,_/ /___/\__, /_/ |_|\__,_/\___/\___/_____/_/_/  \___/____/ 
 *                          /____/                                              

 *** GameMode CRL2 
 *** Credits: krusty, kompry, DRaGsTeR 
 *** Jan 2025

 *************************************************************************************/

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

	//
	// Start various timers.
	//

	SetTimer("AntiCheatWeapon", 30 * SECOND_MS, true);
	SetTimer("AntiFlood", 1 * SECOND_MS, true);

	SetTimer("OnRadarCheckpoint", 300, true);

	SetTimer("AutosaveData", 200 * SECOND_MS, true);
	SetTimer("UpdatePlayerScore", 1 * SECOND_MS, true);

	SetTimer("SendPlayerSalary", 5 * 60 * SECOND_MS, true);
	SetTimer("SendRealEstateCommission", 5 * 60 * SECOND_MS, true);

	SetTimer("DrawClockText", 10 * SECOND_MS, true);

	SetTimer("ShowAdvert", 120 * SECOND_MS, true);

	return 1;
}

public OnGameModeExit()
{
	PrintAsciiLogoToLogs();
	printf(" ");
	printf(" * Shutting down...");

	if (DB_Close(gDbConnectionHandle))
	{
		gDbConnectionHandle = DB: 0;
	}

	KillTimer(SetTimer("ShowAdvert", 1000 * 60 * 2, true));

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	//SetPlayerPos(playerid, 2323.73, 1283.18, 97.60);
	/*SetPlayerPos(playerid, 1966.1, 1936.1, 127.5);
	SetPlayerCameraPos(playerid, 1871.3, 1933.6, 127.5);
	SetPlayerCameraLookAt(playerid, 1966.1, 1936.1, 127.5);*/

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if (!gPlayers[playerid][IsLogged])
		return 0;

	SpawnPlayer(playerid);

	return 1;
}

public OnPlayerConnect(playerid)
{
	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	//LoadPlayerDataDB(playerid);

	// Reset the auth status for a new player.
	gPlayers[playerid][IsLogged] = false;
	gPlayers[playerid][TeamID] = 0;

	// Reset the deathmatch states.
	gDeathmatch[playerid][IsRegistered] = false;
	gDeathmatch[playerid][InGame] = false;
	gDeathmatch[playerid][Score] = 0;

	// Reset trucking
	gTrucking[playerid] = false;
	gPlayerMissions[playerid][TimeElapsed] = 0;
	gPlayerMissions[playerid][Earned] = 0;
	gPlayerMissions[playerid][DoneCount] = 0;
	TextDrawHideForPlayer(playerid, gMissionInfoText[playerid]);

	// Reset racing
	gPlayerRaceTimer[playerid] = Timer: 0;
	gPlayerRaceTime[playerid] = 0;
	TextDrawHideForPlayer(playerid, gRaceInfoText[playerid]);

	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		gPlayerRace[playerid][i] = 0;
	}

	// Combat mission
	gCombatMission[playerid][Active] = false;

	// Draw mapicons for the user.
	AddMapicons(playerid);

	// Text inits.
	AddTexts(playerid);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	gPlayers[playerid][Name] = playerName;

	if (IsPlayerNPC(playerid))
	{
		SpawnPlayer(playerid);
		return 1;
	}

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s joined the game!", playerName);
	SendClientMessageToAll(COLOR_GREY, stringToPrint);

	SendMessageToWebhook(playerid, "connected", -1);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, COLOR_INVISIBLE, "");
	SendClientMessageLocalized(playerid, I18N_WELCOME_MESSAGE);
	SendClientMessage(playerid, COLOR_INVISIBLE, "");

	if (!IsPlayerUsingOmp(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "[ CLIENT ] You don't seem to use the openMP launcher, some game features may not be available for you. Please visit https://open.mp to get it.");
	}

	// Ask the user to login/register.
	gPlayers[playerid][LoginAttempts] = 0;
	ShowAuthDialog(playerid);

	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	if (IsPlayerNPC(playerid))
	{
		return 1;
	}

	StopAudioStreamForPlayer(playerid);
	gPlayers[playerid][Listening] = false;
	gPlayers[playerid][AFK] = false;

	// Hide the vehicle velocity game text.
	//TextDrawHideForPlayer(playerid, KPH[playerid]);
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	KillTimer(_: gPlayerRaceTimer[playerid]);
	KillTimer(_: gPlayerMissions[playerid][TimerElapsed]);
	KillTimer(_: gPlayerMissions[playerid][TimerAttachedCheck]);

	AbortPlayerTaxiMission(playerid);

	// Save player's data and set such player to unauthorized.
	if (reason == 1)
		SavePlayerData(playerid);

	gPlayers[playerid][IsLogged] = false;

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 201);

	SendMessageToWebhook(playerid, "disconnected", reason);

	new stringToPrint[128];

	// Prepare the statement for others.
	switch (reason)
	{
		case 0: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s disconnected [crash].", gPlayers[playerid][Name]);
			}
		case 1: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s disconnected [left].", gPlayers[playerid][Name]); 
			}
		case 2: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s disconnected [kick/ban].", gPlayers[playerid][Name]);
			}
		default: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s disconnected [unknown].", gPlayers[playerid][Name]);
			}
	}

	SendClientMessageToAll(COLOR_GREY, stringToPrint);

	return 0;
}

public OnPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid))
	{
		NPC_SetSkin(playerid, 89);
		NPC_SetInvulnerable(playerid, false);

		// Hide the marker for others
		SetPlayerColor(playerid, 0xFFFFFF00);

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
		new teamid = gPlayers[playerid][TeamID] - 1;

		SetPlayerColor(playerid, gTeams[teamid][Color]);

		for (new i = 0; i < MAX_TEAM_WEAPONS; i++)
		{
			if (!gTeams[teamid][Weapons][i])
			{
				continue;
			}

			GivePlayerWeapon(playerid, t_WEAPON: gTeams[teamid][Weapons][i], gTeams[teamid][Ammu][i]);
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
			return 1;
	}

	// Default location to spawrn a player (LV pyramid).
	SetPlayerPos(playerid, 2323.73, 1283.18, 97.60);

	return 1;
}

public OnNPCDeath(npcid, killerid, reason)
{
	NPC_Destroy(npcid);

	AbortPlayerTaxiMission(killerid);

	return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	new stringToPrint[256];

	SendDeathMessage(killerid, playerid, reason);

	// Hide velocity meters.
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	if (gDeathmatch[playerid][InGame] && playerid != killerid)
	{
		// Increment the killer's score.
		gDeathmatch[killerid][Score]++;

		return ResetPlayerDeathmatchState(playerid);
	}

	if (gCombatMission[playerid][Active])
	{
		return AbortCombatMission(playerid, false);
	}

	if (gTrucking[playerid])
	{
		AbortTruckingMission(playerid);
	}

	new raceid = CheckPlayerRaceState(playerid);

	if (raceid)
	{
		ResetPlayerRaceState(playerid, raceid, false);
	}

	// Drop all money at the spot of death
	if (GetPlayerMoney(playerid) > 0)
	{
		new Float: X, Float: Y, Float: Z;

		GetPlayerPos(playerid, X, Y, Z);
		AddPlayerDeathPickups(playerid, Float:X, Float:Y, Float:Z);

		ResetPlayerMoney(playerid);
	}

	// Adjust the wanted level
	gPlayers[killerid][WantedLevel]++;
	SetPlayerWantedLevel(killerid, gPlayers[killerid][WantedLevel]);

	new t_PLAYER_STATE:killerState = GetPlayerState(killerid);

	if (IsPlayerInAnyVehicle(killerid) && !IsPlayerInAnyVehicle(playerid) && killerState == PLAYER_STATE_DRIVER && reason != WEAPON_VEHICLE)
	{
		new killerName[MAX_PLAYER_NAME]; 

		GetPlayerName(killerid, killerName, MAX_PLAYER_NAME);

		// Hide velocity meters.
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

		format(stringToPrint, sizeof(stringToPrint), "[ CARKILL ] Player %s [ID: %d] has just broken the server rules", killerName, killerid);
		SendClientMessageToAll(COLOR_RED, stringToPrint);

		SpawnPlayer(killerid);
		PlayerPlaySound(killerid, 1056, 0, 0, 0);
	}

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][Vehicle][ID] != vehicleid)
			continue;

		if (gProperties[i][Vehicle][Colours][0])
			ChangeVehicleColours(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Colours][0], gProperties[i][Vehicle][Colours][1]);

		for (new j = 0; j < 16; j++)
		{
			if (gProperties[i][Vehicle][Components][j])
				AddVehicleComponent(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Components][j]);
		}

		ChangeVehiclePaintjob(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Paintjob]);
	}

	SetVehicleNumberPlate(vehicleid, VEHICLE_PLATE);

	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if (gTrucking[killerid])
	{
		if (vehicleid == gPlayerMissions[killerid][VehicleID] || vehicleid == gPlayerMissions[killerid][TrailerID])
		{
			return AbortTruckingMission(killerid);
		}
	}

	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	for (new i = 0; i < sizeof(gProperties); i++)
	{
		if (gProperties[i][Vehicle][ID] != vehicleid)
			continue;

		new t_CARMODTYPE: componentType = GetVehicleComponentType(componentid);

		if (componentType == CARMODTYPE_NONE)
			break;

		gProperties[i][Vehicle][Components][componentType] = componentid;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ REAL ] Vehicle mod saved");
	}

	return 1;
}

public OnPlayerText(playerid, text[])
{
	if (strlen(text) > 1 && text[0] == '!')
	{
		new stringToPrint[256];

		text[0] = ' ';
		format(stringToPrint, sizeof(stringToPrint), "%s [Team Chat]:%s", gPlayers[playerid][Name], text);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i) && gPlayers[i][TeamID] == gPlayers[playerid][TeamID])
			{
				SendClientMessage(i, gTeams[ gPlayers[i][TeamID] - 1 ][Color], stringToPrint);
			}
		}

		return 0;
	}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source)
{
	if (gPlayers[playerid][AdminLevel] < 1)
		return 1;

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
	// See src/support/dcmd.pwn
	return LoadDcmdAll(playerid, cmdtext);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (IsPlayerNPC(playerid))
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
	// Hide the velocity meter on vehicle exit.
	if ((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && newstate == PLAYER_STATE_ONFOOT)
	{
		//TextDrawHideForPlayer(playerid, KPH[playerid]);
		//TextDrawHideForPlayer(playerid, KPHR[playerid]);
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);
	}

	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		gVehicleStatesText[playerid] = TextDrawCreate(256, 410, "~w~Health:____%3d_%%~n~~w~Velocity:_%3d");

		TextDrawLetterSize(gVehicleStatesText[playerid], 0.5, 1.5);
		TextDrawFont(Text: gVehicleStatesText[playerid], t_TEXT_DRAW_FONT: 3);
		TextDrawSetOutline(gVehicleStatesText[playerid], 1);

		TextDrawShowForPlayer(playerid, gVehicleStatesText[playerid]);
	}

	if (IsPlayerNPC(playerid) || NPC_IsValid(playerid))
	{
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);
		return 1;
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
	switch (dialogid)
	{
		case DIALOG_UNUSED: 
			return 1; // Useful for dialogs that contain only information and we do nothing depending on whether they responded or not

		case DIALOG_LOGIN:
			{
				if (!response) 
					return Kick(playerid);

				if (SetPlayerAccountLogin(playerid, inputtext))
					return 1;
				//return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "Logged in successfully!", "Ok", "");

				gPlayers[playerid][LoginAttempts]++;

				if (gPlayers[playerid][LoginAttempts] >= 3)
				{
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "Failed to enter the password (3 times).", "Ok", "");
					Kick(playerid);
				}
				else 
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nEnter a valid password please!", "Login", "Cancel");
			}
		case DIALOG_REGISTER:
			{
				if (!response) 
					return Kick(playerid);

				if (strlen(inputtext) <= 5) 
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Enter a password longer than 5 characters!", "Register", "Cancel");

				if (SetPlayerAccountRegistration(playerid, inputtext))
					return 1;
			}
		case DIALOG_PROPERTY_BUY:
			{
				if (!response)
					return 1;

				BuyPlayerProperty(playerid, strval(inputtext));

				return 1;
			}
		case DIALOG_PROPERTY_RENT:
			{
				if (!response)
					return 1;

				return RentProperty(playerid, strval(inputtext));
			}
		case DIALOG_PROPERTY_SELL:
			{
				if (!response)
					return 1;

				SellPlayerProperty(playerid, strval(inputtext));

				return 1;
			}
		case DIALOG_PROPERTY_DRUGZ:
			{
				if (!response)
					return 1;

				if (!strlen(inputtext))
					return SendClientMessage(playerid, COLOR_RED, "[ DRUGZ ] Invalid option.");

				// Save to the temporary user's var.
				gPlayers[playerid][Temp] = listitem;

				ShowPlayerDialog(playerid, DIALOG_PROPERTY_DRUGZ_TRANS, DIALOG_STYLE_LIST, "Drugz", "Deposit at home\nWithdraw the whole amount", "Confirm", "Cancel");

				return 1;
			}
		case DIALOG_PROPERTY_DRUGZ_TRANS:
			{
				if (!response)
					return 1;

				new drugID = gPlayers[playerid][Temp], propertyID = gPlayerInteriors[playerid][PropertyArrayID];

				switch (listitem)
				{
					case 0:
						{
							// Save all at home
							gProperties[propertyID][Drugs][drugID] += gPlayers[playerid][Drugs][drugID];
							gPlayers[playerid][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Saved at home");
						}
					case 1:
						{
							// Withdraw all to pockets
							gPlayers[playerid][Drugs][drugID] += gProperties[propertyID][Drugs][drugID];
							gProperties[propertyID][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Saved to your pockets");
						}
				}

				return 1;
			}
		case DIALOG_PROPERTY_EDIT_MAIN:
			{
				if (!response)
				{
					gPropertyEdit[playerid] = gNullProperty;
					gPlayers[playerid][EditingMode] = false;

					SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Property edit cancelled.");
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Name
						{
							ShowPropertyEditDialogName(playerid);
						}
					case 1:
						// Type
						{
							ShowPropertyEditDialogType(playerid);
						}
					case 2:
						// Cost
						{
							ShowPropertyEditDialogCost(playerid);
						}
					case 3:
						// Spawn point coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_SPAWN_POINT;
							SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record spawn coords using the KEY_NO (N) key.");
						}
					case 4:
						// Entrance pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_ENTRANCE_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record entrance coords using the KEY_NO (N) key.");
						}
					case 5:
						// Offer pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_OFFER_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record offer coords using the KEY_NO (N) key.");
						}
					case 6:
						// Money pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_MONEY_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record money coords using the KEY_NO (N) key.");
						}
					case 7:
						// Shirt pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_SHIRT_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record shirt coords using the KEY_NO (N) key.");
						}
					case 8:
						// Vehicle coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_VEHICLE_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record vehicle coords using the KEY_NO (N) key.");
						}
					case 9:
						// Occupied state
						{
							gPropertyEdit[playerid][Occupied] = !gPropertyEdit[playerid][Occupied];
							SendClientMessage(playerid, COLOR_GREEN, "[ EDIT ] Occupied state of the property toggled");

							ShowPropertyEditDialogMain(playerid);
						}
					case 10:
						// Custom interior state
						{
							gPropertyEdit[playerid][CustomInterior] = !gPropertyEdit[playerid][CustomInterior];
							SendClientMessage(playerid, COLOR_GREEN, "[ EDIT ] Custom interior state of the property toggled");

							ShowPropertyEditDialogMain(playerid);
						}
					case 11:
						// Save property
						{
							EditProperty(playerid);
						}
				}

				return 1;
			}
		case DIALOG_PROPERTY_EDIT_NAME:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				new label[64];
				format(label, sizeof(label), "%s", inputtext);

				gPropertyEdit[playerid][Label] = label;
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property name changed!");

				ShowPropertyEditDialogMain(playerid);
				return 1;
			}
		case DIALOG_PROPERTY_EDIT_TYPE:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				switch (listitem)
				{
					case 0:
						// Personal
						{
							gPropertyEdit[playerid][Type] = PROPERTY_TYPE_PERSONAL;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property type set to personal!");
						}
					case 1:
						// Commercial
						{
							gPropertyEdit[playerid][Type] = PROPERTY_TYPE_COMMERCIAL;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property type set to commercial!");
						}
				}

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_EDIT_COST:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				if (!IsNumeric(inputtext))
				{
					SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Invalid value!");

					ShowPropertyEditDialogMain(playerid);
					return 1;
				}

				gPropertyEdit[playerid][Cost] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property cost changed!");

				ShowPropertyEditDialogMain(playerid);
				return 1;
			}
		case DIALOG_PROPERTY_EDITOR_LIST_PER:
			{
				if (!response)
				{
					return 1;
				}

				gPlayers[playerid][EditingMode] = true;
				gPropertyEdit[playerid][ID] = gProperties[listitem][ID];
				gPropertyEdit[playerid][Type] = PROPERTY_TYPE_PERSONAL;

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_EDITOR_LIST_COM:
			{
				if (!response)
				{
					return 1;
				}

				gPlayers[playerid][EditingMode] = true;
				gPropertyEdit[playerid][ID] = gProperties[listitem][ID];
				gPropertyEdit[playerid][Type] = PROPERTY_TYPE_COMMERCIAL;

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_LIST:
			{
				if (!response)
					return 1;

				new propertyid = gPlayers[playerid][Properties][listitem];

				if (!propertyid)
					return 1;

				gPlayers[playerid][Temp] = propertyid;

				ShowPropertyOptionsDialog(playerid);

				return 1;
			}
		case DIALOG_PROPERTY_OPTIONS:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new propertyid = gPlayers[playerid][Temp];

				switch (listitem)
				{
					// Spawn point setup
					case 0:
						{
							SetSpawnPointAtProperty(playerid, propertyid);
						}
						// New vehicle attachment
					case 1:
						{
							AttachVehicleToProperty(playerid, propertyid);
						}
						// Property selling
					case 2: 
						{
							SellPlayerProperty(playerid, propertyid);
						}
				}

				return 1;
			}
		case DIALOG_BANK_OPTIONS:
			{
				if (!response)
					return 1;

				switch (listitem)
				{
					// Deposit
					case 0:
						{
							gPlayers[playerid][DialogShown] = true;
							return ShowBankDepositDialog(playerid);
						}
					case 1:
						{
							gPlayers[playerid][DialogShown] = true;
							return ShowBankWithdrawDialog(playerid);
						}
					case 2: 
						{
							new stringToPrint[256];

							format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Account balance: $%d!", gPlayers[playerid][Bank]);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

							gPlayers[playerid][DialogShown] = false;
							return 1;
						}
				}
			}
		case DIALOG_BANK_DEPOSIT:
			{
				if (!response || !IsNumeric(inputtext) || !strval(inputtext))
				{
					gPlayers[playerid][DialogShown] = false;
					return 1;
				}

				DepositMoneyToBankAccount(playerid, strval(inputtext));
				gPlayers[playerid][DialogShown] = false;

				return 1;

			}
		case DIALOG_BANK_WITHDRAW:
			{
				if (!response || !IsNumeric(inputtext) || !strval(inputtext))
				{
					gPlayers[playerid][DialogShown] = false;
					return 1;
				}

				WithdrawMoneyFromBankAccount(playerid, strval(inputtext));
				gPlayers[playerid][DialogShown] = false;

				return 1;

			}
		case DIALOG_RACE_LIST:
			{
				if (!response)
					return 1;

				SetPlayerRaceState(playerid, listitem + 1);

				if (!gPlayerRace[playerid][listitem + 1])
					return 1;

				/*if (!CheckPlayerRaceState(playerid))
				  return 1;*/

				if (SetPlayerRaceStartPos(playerid))
					return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RACE ] Warp near the race start used successfully");

				return 1;
			}
		case DIALOG_RACE_OPTIONS:
			{
				if (!response)
					return 1;

				switch (listitem)
				{
					case 0:
						{
							ResetPlayerRaceState(playerid, 0, false);
						}
				}

				return 1;
			}
		case DIALOG_PORT_LIST: 
			{
				if (!response)
					return 1;

				if (IsPlayerInAnyVehicle(playerid))
					RemovePlayerFromVehicle(playerid);

				switch (listitem)
				{
					case 0:
						{
							SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Las Venturas Escalators");
						}
					case 1:
						{
							SetPlayerPos(playerid, -1951.58, 296.77, 41.04);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] San Fierro WangCars");
						}
					case 2:
						{
							SetPlayerPos(playerid, 1896.13, -2393.53, 13.11);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Los Santos Airport");
						}
				}

				return 1;
			}
		case DIALOG_GET_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return MovePlayerToPlayer(playerid, listitem, true);
			}
		case DIALOG_GOTO_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return MovePlayerToPlayer(playerid, listitem, false);
			}
		case DIALOG_PLAYER_CLICKED_LIST:
			{
				if (!response)
					return 1;

				new clickedplayerid = gPlayers[playerid][Temp];

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				switch (listitem)
				{
					case 0:
						// Set HP
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							SetPlayerHealth(clickedplayerid, 100.0);
							SetPlayerArmour(clickedplayerid, 100.0);

							SendClientMessage(clickedplayerid, COLOR_LIGHTGREEN, "[ HP ] Health: 100.0, Armour: 100.0");
						}
					case 1:
						// Install nitro
						{
							SetPlayerVehicleNitro(playerid, clickedplayerid);
						}
					case 2:
						// Get the player (port)
						{
							MovePlayerToPlayer(playerid, clickedplayerid, true);
						}
					case 3:
						// Goto player (port)
						{
							MovePlayerToPlayer(playerid, clickedplayerid, false);
						}
					case 4:
						// Set skin ID
						{
							ShowPlayerSkinIDSetDialog(playerid);
						}
					case 5:
						// Set drunk drunk level
						{
							ShowPlayerDrunkLevelSetDialog(playerid);
						}
					case 6:
						// Kick from server
						{
							new adminName[MAX_PLAYER_NAME], kickedName[MAX_PLAYER_NAME], stringToPrint[128];

							GetPlayerName(playerid, adminName, sizeof(adminName));
							GetPlayerName(clickedplayerid, kickedName, sizeof(kickedName));

							format(stringToPrint, sizeof(stringToPrint), "[ KICK ] Admin %s [ID: %d] kicked player %s [ID: %d] from server! ", adminName, playerid, kickedName, clickedplayerid);

							SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
							Kick(clickedplayerid);
						}
					case 7:
						// Packet loss
						{
							new 
								Float: loss = 0.0, 
								stringToPrint[128];

							GetPlayerPacketLoss(clickedplayerid, loss);

							format(stringToPrint, sizeof(stringToPrint), "[ NET ] Player ID: %d, packet loss: %.2f %%", clickedplayerid, loss);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
						}
					case 8:
						// Reset cach money
						{
							ResetPlayerMoney(clickedplayerid);
						}
					case 9:
						// Spectate
						{
							if (gPlayers[playerid][Spectating])
							{
								TogglePlayerSpectating(playerid, false);

								gPlayers[playerid][Spectating] = false;
								return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode disabled!");
							}

							if (playerid == clickedplayerid)
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid player!");

							TogglePlayerSpectating(playerid, true);
							PlayerSpectatePlayer(playerid, clickedplayerid);

							gPlayers[playerid][Spectating] = true;
							return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode enabled!");
						}
					case 10:
						// Give weapons
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							GivePlayerWeapon(clickedplayerid, t_WEAPON: 26, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 28, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 31, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 43, 1);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 46, 1);

							SendClientMessage(clickedplayerid, COLOR_ORANGE, "[ WEAPON ] Received a weapons pack");
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Weapons sent");
						}
					case 11:
						// Give a specific weapon
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							ShowPlayerGiveWeaponDialog(playerid);
						}
					case 12:
						// Ban
						{
							new adminName[MAX_PLAYER_NAME], bannedName[MAX_PLAYER_NAME], stringToPrint[128];

							GetPlayerName(playerid, adminName, sizeof(adminName));
							GetPlayerName(clickedplayerid, bannedName, sizeof(bannedName));

							format(stringToPrint, sizeof(stringToPrint), "[ BAN ] Admin %s [ID: %d] banned player %s [ID: %d] from server!", adminName, playerid, bannedName, clickedplayerid);
							SendClientMessageToAll(COLOR_CYAN, stringToPrint);

							Ban(clickedplayerid);
						}
					case 13:
						// Send fakechat
						{
							ShowPlayerFakechatDialog(playerid);
						}
					case 14:
						// Set admin level
						{
							ShowPlayerAdminLevelSetDialog(playerid);
						}
				}

				return 1;
			}
		case DIALOG_PLAYER_SKIN_ID_SET:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][Temp];
				gPlayers[playerid][Temp] = 0;

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				new skinid = strval(inputtext);

				if (!IsNumeric(inputtext) || skinid < 0 || skinid > 311)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Skin ID must be between 0 and 311!");
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Skin ID changed");

				gPlayers[clickedplayerid][Skin] = skinid;
				return SetPlayerSkin(clickedplayerid, skinid);
			}
		case DIALOG_PLAYER_DRUNK_LEVEL_SET:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][Temp];
				gPlayers[playerid][Temp] = 0;

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				new level = strval(inputtext);

				if (!IsNumeric(inputtext) || level < 0 || level > 50000)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Drunk level must be between 0 and 50000!");
				}

				SendClientMessage(clickedplayerid, COLOR_ORANGE, "[ DRUGZ ] Drunk level changed");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Drunk level changed");

				return SetPlayerDrunkLevel(clickedplayerid, level);
			}
		case DIALOG_PLAYER_WEAPON_SET:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][Temp];
				gPlayers[playerid][Temp] = 0;

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				new weaponid = strval(inputtext);

				if (!IsNumeric(inputtext) || weaponid < 0 || weaponid > 46)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Weapon Model ID must be between 0 and 46!");
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Weapon sent");
				return GivePlayerWeapon(clickedplayerid, t_WEAPON: weaponid, 1000);
			}
		case DIALOG_PLAYER_FAKECHAT:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][Temp];
				gPlayers[playerid][Temp] = 0;

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				SendPlayerMessageToAll(clickedplayerid, inputtext);

				return SendClientMessage(playerid, COLOR_WHITE, "[ FAKE ] Fake client message sent!");
			}
		case DIALOG_PLAYER_ADMIN_LEVEL_SET:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = 0;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][Temp];
				gPlayers[playerid][Temp] = 0;

				if (!IsPlayerConnected(clickedplayerid))
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");

				new level = strval(inputtext);

				if (!IsNumeric(inputtext) || level < 0 || level > 5)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Admin level must between 0 and 5!");
				}

				if (gPlayers[playerid][AdminLevel] > level || gPlayers[playerid][AdminLevel] < gPlayers[clickedplayerid][AdminLevel])
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIM ] Admin level must be lower or equal to one you possess yourself!");
				}

				new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], stringToPrint[128];

				GetPlayerName(playerid, adminName, sizeof(adminName));
				GetPlayerName(clickedplayerid, playerName, sizeof(playerName));

				format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s set player %s [ ID: %d ] an Admin (level %d)!", adminName, playerName, clickedplayerid, level);

				gPlayers[clickedplayerid][AdminLevel] = level;
				SavePlayerData(clickedplayerid);

				return SendClientMessageToAll(COLOR_GREY, stringToPrint);
			}
		case DIALOG_DEATHMATCH_OPTIONS:
			{
				if (!response)
					return 1;

				switch (listitem)
				{
					case 0:
						{
							if (gDeathmatch[playerid][IsRegistered] || gDeathmatch[playerid][InGame])
							{
								LeaveDeathmatch(playerid);
							}
							else
							{
								RegisterToDeathmatch(playerid);
							}
						}
				}

				return 1;
			}
		case DIALOG_PHONE_OPTIONS:
			{
				if (!response)
				{
					ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
					//ClearAnimations(playerid);
					RemovePlayerAttachedObject(playerid, 3);
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Account balance
						{
							new stringToPrint[256];

							format(stringToPrint, sizeof(stringToPrint), "[ PHONE ] Account balance: $%d!", gPlayers[playerid][Bank]);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

							return ShowPhoneOptionsDialog(playerid);
						}
					case 1:
						// PM to player
						{
							return ShowPhonePMPlayerListDialog(playerid);
						}
					case 2:
						// Taxi
						{
							if (!CheckTaxiDriversOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Taxi drivers online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
					case 3:
						// Car mechanic
						{
							if (!CheckCarMechanicsOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Car mechanics online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
					case 4:
						// Pizza delivery
						{
							if (!CheckPizzaguysOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Pizzaguys online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
				}

				ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
				//ClearAnimations(playerid);
				RemovePlayerAttachedObject(playerid, 3);
				return 1;
			}
		case DIALOG_PHONE_PM_PLAYER_LIST:
			{
				if (!response)
				{
					ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
					//ClearAnimations(playerid);
					RemovePlayerAttachedObject(playerid, 3);
					return 1;
				}

				return ShowPhonePMTextDialog(playerid, listitem);
			}
		case DIALOG_PHONE_PM_TEXT:
			{
				if (!response || !strlen(inputtext))
				{
					return ShowPhoneOptionsDialog(playerid);
				}

				OnPlayerPrivMsg(playerid, gPlayers[playerid][Temp], inputtext);
				gPlayers[playerid][Temp] = 0;

				return ShowPhoneOptionsDialog(playerid);
			}
		case DIALOG_HELP_LIST:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							return ShowCommonCommandsDialog(playerid);
						}
					case 1:
						{
							return ShowAdminCommandsDialog(playerid);
						}
					case 2:
						{
							return ShowServerRulesDialog(playerid);
						}
					case 3:
						{
							return ShowCreditsDialog(playerid);
						}
					case 4:
						{
							return ShowTaxiHelpDialog(playerid);
						}
					case 5:
						{
							return ShowTruckingHelpDialog(playerid);
						}
					case 6:
						{
							return ShowCombatHelpDialog(playerid);
						}
					case 7:
						{
							return ShowPropertyHelpDialog(playerid);
						}
					case 8:
						{
							return ShowRaceHelpDialog(playerid);
						}
					case 9:
						{
							return ShowPrizesInfoDialog(playerid);
						}
				}
			}
		case DIALOG_EDITOR_LIST:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							return ShowPropertyEditorMainDialog(playerid);
						}
					case 1:
						{
							return ShowTruckingEditorMainDialog(playerid);
						}
					case 2:
						{
							return ShowRaceEditorMainDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Draft new property
						{
							return ShowPropertyEditorNewIDDialog(playerid);
						}
					case 1:
						// List existing properties (personal)
						{
							return ShowPropertyEditorListPerDialog(playerid);
						}
					case 2:
						// List existing properties (commercial)
						{
							return ShowPropertyEditorListComDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_EDITOR_NEW_ID:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return 1;
				}

				if (GetPropertyArrayIDfromID(strval(inputtext)) != -1)
				{
					// Existing property
					return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] The entered property ID already exists!");
				}

				new propertyid = strval(inputtext);

				if (propertyid < 10101 || propertyid > 59999)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Invalid property ID (10101-59999)!");
				}

				gPlayers[playerid][EditingMode] = true;

				gPropertyEdit[playerid] = gNullProperty;
				gPropertyEdit[playerid][ID] = propertyid;

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property edit enabled.");

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_RACE_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Draft new race
						{
							new newraceid = -1;
							for (new i = 1; i < MAX_RACE_COUNT; i++)
							{
								if (!strcmp(gRaces[i][Name], ""))
								{
									newraceid = i;
									break;
								}
							}

							if (newraceid == -1)
							{
								return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Max race count reached!");
							}

							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Editting mode enabled");
							gPlayers[playerid][EditingMode] = true;
							gPlayers[playerid][Temp] = newraceid;

							gPlayerRaceEdit[playerid][ID] = newraceid;

							return ShowRaceEditorOptionsDialog(playerid, gPlayers[playerid][Temp]);
						}
					case 1:
						// List existing races
						{
							return ShowRaceEditorListDialog(playerid);
						}
				}
			}
		case DIALOG_RACE_EDITOR_LIST:
			{
				if (!response)
				{
					return 1;
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Editting mode enabled");
				gPlayers[playerid][EditingMode] = true;
				gPlayers[playerid][Temp] = gRaces[listitem + 1][ID];

				return ShowRaceEditorOptionsDialog(playerid, gPlayers[playerid][Temp]);
			}
		case DIALOG_RACE_EDITOR_OPTIONS:
			{
				if (!response)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Editting mode disabled");
					gPlayers[playerid][EditingMode] = false;
					gPlayers[playerid][Temp] = -1;

					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Change Name
						{
							return ShowRaceEditorNameChangeDialog(playerid);
						}
					case 1:
						// Change Cost in Dollars
						{
							return ShowRaceEditorCostChangeDialog(playerid);
						}
					case 2:
						// Change Prize in Dollars
						{
							return ShowRaceEditorPrizeChangeDialog(playerid);
						}
					case 3:
						// Change Start Coords
						{
							gPlayerRaceEdit[playerid][EditType] = RACE_EDITOR_START_COORDS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record start coords using the KEY_NO (N)");
						}
					case 4:
						// Record New Race Track/Path
						{
							gPlayerRaceEdit[playerid][EditType] = RACE_EDITOR_TRACK_COORDS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record track coords using the KEY_NO (N)");
						}
					case 5:
						// Save race
						{
							return SaveRaceData(playerid);
						}

				}

				return 1;
			}
		case DIALOG_RACE_EDITOR_NAME:
			{
				if (!response)
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				format(gPlayerRaceEdit[playerid][Name], 64, "%s", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race name changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_RACE_EDITOR_COST:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				gPlayerRaceEdit[playerid][CostDollars] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race cost in dollars changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_RACE_EDITOR_PRIZE:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				gPlayerRaceEdit[playerid][PrizeDollars] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race prize in dollars changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_TRUCKING_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// New trucking point
						{
							new truckingid = -1;
							for (new i = 1; i < MAX_TRUCKING_POINTS; i++)
							{
								if (!strcmp(gTruckingPoints[i][Name], ""))
								{
									truckingid = i;
									break;
								}
							}

							if (truckingid == -1)
							{
								return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Max trucking point count reached!");
							}

							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point editor mode enabled!");
							gPlayers[playerid][EditingMode] = true;
							gTruckingEdit[playerid][ID] = truckingid;
							gTruckingVehiclesIndex = 0;

							return ShowTruckingEditorOptionsDialog(playerid);
						}
					case 1:
						// List existing trucking points
						{
							return ShowTruckingPointListDialog(playerid);
						}
				}
			}
		case DIALOG_TRUCKING_POINT_LIST:
			{
				if (!response)
				{
					return 1;
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point editor enabled!");
				gPlayers[playerid][EditingMode] = true;
				gTruckingEdit[playerid][ID] = listitem + 1;
				gTruckingVehiclesIndex = 0;

				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_TRUCKING_EDITOR_OPTIONS:
			{
				if (!response)
				{
					gTruckingEdit[playerid][ID] = -1;
					gPlayers[playerid][EditingMode] = false;
					gTruckingVehiclesIndex = 0;
					return SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Trucking editor mode disabled!");
				}

				switch (listitem)
				{
					case 0:
						// Name
						{
							return ShowTruckingEditorNameDialog(playerid);
						}
					case 1:
						// Type
						{
							return ShowTruckingEditorTypeDialog(playerid);
						}
					case 2:
						// Checkpoint
						{
							gTruckingEdit[playerid][EditType] = TREDIT_CHECKPOINT;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new checkpoint coords using the KEY_NO (N) key.");
						}
					case 3:
						// Info pickup
						{
							gTruckingEdit[playerid][EditType] = TREDIT_INFO_PICKUP;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new info pickup coords using the KEY_NO (N) key.");
						}
					case 4:
						// Truck
						{
							gTruckingEdit[playerid][EditType] = TREDIT_TRUCK;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new truck coords using the KEY_NO (N) key.");
						}
					case 5:
						// Gas
						{
							gTruckingEdit[playerid][EditType] = TREDIT_GAS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new gas trailer coords using the KEY_NO (N) key.");
						}
					case 6:
						// Freight
						{
							gTruckingEdit[playerid][EditType] = TREDIT_FREIGHT;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new freight trailer coords using the KEY_NO (N) key.");
						}
					case 7:
						// Save
						{
							if (SetTruckingPoint(playerid))
								return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point and vehicles saved successfully!");

							return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Database error occured while saving trucking data!");
						}
				}

				return 1;
			}
		case DIALOG_TRUCKING_EDITOR_NAME:
			{
				if (!response || !strlen(inputtext))
				{
					return ShowTruckingEditorOptionsDialog(playerid);
				}

				format(gTruckingEdit[playerid][Name], 64, "%s", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point name changed!");
				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_TRUCKING_EDITOR_TYPE:
			{
				if (!response)
				{
					return ShowTruckingEditorOptionsDialog(playerid);
				}

				switch (listitem)
				{
					case 0:
						// Petrol station
						{
							gTruckingEdit[playerid][Type] = FT_GAS_STATION;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point type set to petrol station!");
						}
					case 1:
						{
							gTruckingEdit[playerid][Type] = FT_FREIGHT;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point type set to freight point!");
						}
				}

				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_PROPERTY_SKIN_MAIN:
			{
				if (!response)
				{
					gPlayers[playerid][SkinOp] = SKIN_OP_NONE;
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Save new skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_NEW;
							return SavePropertySkin(playerid);
						}
					case 1:
						// Select skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_SELECT;
							return ShowPropertySkinListDialog(playerid);
						}
					case 2:
						// Delete skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_DELETE;
							return ShowPropertySkinListDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_SKIN_LIST:
			{
				if (!response)
				{
					gPlayers[playerid][SkinOp] = SKIN_OP_NONE;
					return 1;
				}

				switch (gPlayers[playerid][SkinOp])
				{
					case SKIN_OP_SELECT:
						{
							return SelectPropertySkin(playerid, listitem);
						}
					case SKIN_OP_DELETE:
						{
							return DeletePropertySkin(playerid, listitem);
						}
					default:
						{
							return 1;
						}
				}
			}
		case DIALOG_HIGH_SCORES_MAIN:
			{
				if (!response)
				{
					gPlayers[playerid][Temp] = -1;
					return 1;
				}

				if (gPlayers[playerid][Temp] > 9)
				{
					gPlayers[playerid][Temp] += 10;
				}
				else
				{
					gPlayers[playerid][Temp] = 10;
				}

				return ShowHighScoresDialog(playerid, gPlayers[playerid][Temp]);
			}

		default: 
			return 0; // dialog ID was not found, search in other scripts
	}

	ShowAuthDialog(playerid);

	return 1;
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
	CheckRaceCheckpoint(playerid);
	CheckTruckingCheckpoint(playerid);
	CheckTaxiMissionCheckpoint(playerid);
	CheckCombatCheckpoint(playerid);

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
	// hotfix due to the logic of EnsurePickupCreated(...) function
	if (!pickupid)
		return 1;

	//
	//  Banking
	//

	for (new i = 0; i < MAX_ATM_PICKUPS; i++)
	{
		if (gBankPickups[i] != pickupid)
			continue;

		if (gPlayers[playerid][DialogShown])
			continue;

		ShowBankOptionsDialog(playerid);
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

	CheckCombatPickup(playerid, pickupid);

	//
	//  Trucking pickups.
	//

	/*for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	  {
	  if (pickupid == gTruckingPoints[i][InfoPickup])
	  {
	  format(stringToPrint, sizeof(stringToPrint), "Info Point\n\n%s\n", gTruckingPoints[i][Name]);
	  return ShowPlayerDialog(playerid, DIALOG_TRUCKING_INFO, DIALOG_STYLE_MSGBOX, "Trucking Point", stringToPrint, "Close", "");
	  }
	  }*/

	//
	//  Real Estate pickups.
	//

	CheckRealEstatePickup(playerid, pickupid);

	//
	//  Drugz.
	//

	CheckDrugzPickup(playerid, pickupid);

	//
	//  Other pickups --- entries,  baggies etc.
	//

	if (pickupid == gDruggeryEntrance)
	{
		new Float: dX, Float: dY, Float: dZ;
		GetObjectPos(gDruggery, dX, dY, dZ);
		SetPlayerPos(playerid, dX, dY, dZ);
	}

	for (new i = 0; i < MAX_PRIZES; i++)
	{
		if (PICKUP: pickupid == gPrizes[i][Pickup])
		{
			UpdatePrize(playerid, i);
			break;
		}
	}

	if (pickupid == gPickupSFCentrumEnter)
	{
		SetPlayerPos(playerid, -1898.89, 486.52, 21.93); 
		return 1;
	}
	else if (pickupid == gPickupSFCentrumExit)
	{
		SetPlayerPos(playerid, -1902.57, 486.75, 35.17);
		return 1;
	}
	else if (pickupid == gPickupBankLSEnter)
	{
		SetPlayerPos(playerid, 1483.94, -1783.11, 6.70);
		return 1;
	}
	else if (pickupid == gPickupBankLSExit)
	{
		SetPlayerPos(playerid, 1481.15, -1765.18, 18.79);
		return 1;
	}

	if (pickupid == gAdminRoomHealth)
	{
		SetPlayerHealth(playerid, 100.0);
	}
	else if (pickupid == gHackerzInteriorEntrance)
	{
		SetPlayerPos(playerid, 2845.28, -2125.33, 0.19);
	}
	else if (pickupid == gHackerzInteriorExit)
	{
		SetPlayerPos(playerid, 2881.27, -2123.99, 4.32);
	}
	else if (pickupid == gHackerzMoneyBag)
	{
		GivePlayerMoney(playerid, 10000);
		DestroyPickup(gHackerzMoneyBag);
		gHackerzMoneyBag = 0;
	}
	else if (pickupid == gAdminDoorDown)
	{
		SetPlayerPos(playerid, 1007.98, -1164.11, 50.95);
	}
	else if (pickupid == gAdminDoorUp)
	{
		SetPlayerPos(playerid, 981.84, -1158.15, 23.86);
	}

	//
	//  Death pickups.
	//

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		/*if (!IsPlayerConnected(i) || gPlayerMoneyPickup[i] == -1)
		  continue;*/

		if (pickupid != gPlayerMoneyPickup[i])
			continue;

		DestroyPickup(gPlayerMoneyPickup[i]);
		gPlayerMoneyPickup[i] = -1;

		GivePlayerMoney(playerid, gPlayerMoneyPickupAmount[i]);
		gPlayerMoneyPickupAmount[i] = 0;
	}

	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:currentMenu = GetPlayerMenu(playerid), stringToPrint[256];

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
					GivePlayerWeapon(playerid, t_WEAPON: gTeams[i][Weapons][j], gTeams[i][Ammu][j]);
				}
			}

			SetPlayerColor(playerid, gTeams[i][Color]);
			SetPlayerSkin(playerid, gTeams[i][Skins][0]);
			SetPlayerTeam(playerid, gTeams[i][ID]);

			gPlayers[playerid][TeamID] = gTeams[i][ID];

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

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
	switch (newkeys)
	{
		case KEY_SECONDARY_ATTACK:
			{
				if (!IsPlayerInAnyVehicle(playerid))
				{
					new Float:x, Float:y, Float:z, vehicle;
					GetPlayerPos(playerid, x, y, z);
					GetVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);
					if (IsVehicleRcTram(vehicle))
					{
						PutPlayerInVehicle(playerid, vehicle, 0);
					}
				}
				else
				{
					new vehicleID = GetPlayerVehicleID(playerid);
					if (IsVehicleRcTram(vehicleID) || GetVehicleModel(vehicleID) == RC_CAM)
					{
						if (GetVehicleModel(vehicleID) != D_TRAM)
						{
							new Float:x, Float:y, Float:z;
							GetPlayerPos(playerid, x, y, z);
							SetPlayerPos(playerid, x + 0.5, y, z + 1.0);
						}
					}
				}
			}
		case KEY_YES:
			{
				ApplyAnimation(playerid, "ped", "phone_in", 4.1, false, false, false, true, 0);
				SetPlayerAttachedObject(playerid, 3, 330, 6, 0.00, 0.00, 0.05, 59.59, 60.19, -30.50, 1.02, 1.00, 1.00);

				ShowPhoneOptionsDialog(playerid);
			}
		case KEY_NO:
			{
				if (gPlayers[playerid][AdminLevel] < 4)
				{
					return 1;
				}

				if (!gPlayers[playerid][EditingMode])
				{
					return 1;
				}

				if (gPlayerRaceEdit[playerid][ID])
				{
					switch (gPlayerRaceEdit[playerid][EditType])
					{
						case RACE_EDITOR_START_COORDS:
							{
								new Float: X, Float: Y, Float: Z;
								GetPlayerPos(playerid, X, Y, Z);

								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_X] = X;
								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_Y] = Y;
								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_Z] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Start coords recorded!");
								return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
							}
						case RACE_EDITOR_TRACK_COORDS:
							{
								new Float: X, Float: Y, Float: Z;
								GetPlayerPos(playerid, X, Y, Z);

								new coord_no = gPlayerRaceEdit[playerid][EditTrackCoordNo];

								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_X] = X;
								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_Y] = Y;
								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_Z] = Z;

								gPlayerRaceEdit[playerid][EditTrackCoordNo]++;

								new stringToPrint[128];
								format(stringToPrint, sizeof(stringToPrint), "[ EDIT ] Track coords no. %d recorded!", coord_no);
								SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

								return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
							}
					}
				}

				if (gPropertyEdit[playerid][ID])
				{
					new Float: X, Float: Y, Float: Z, Float: R;
					GetPlayerPos(playerid, X, Y, Z);

					switch (gPropertyEdit[playerid][EditingMode])
					{
						case PREDIT_SPAWN_POINT:
							{
								gPropertyEdit[playerid][CoordsSpawn][CoordX] = X;
								gPropertyEdit[playerid][CoordsSpawn][CoordY] = Y;
								gPropertyEdit[playerid][CoordsSpawn][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Spawn coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_ENTRANCE_POINT:
							{
								gPropertyEdit[playerid][CoordsEntrance][CoordX] = X;
								gPropertyEdit[playerid][CoordsEntrance][CoordY] = Y;
								gPropertyEdit[playerid][CoordsEntrance][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Entrance coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_OFFER_POINT:
							{
								gPropertyEdit[playerid][CoordsOffer][CoordX] = X;
								gPropertyEdit[playerid][CoordsOffer][CoordY] = Y;
								gPropertyEdit[playerid][CoordsOffer][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Offer coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_MONEY_POINT:
							{
								gPropertyEdit[playerid][CoordsMoney][CoordX] = X;
								gPropertyEdit[playerid][CoordsMoney][CoordY] = Y;
								gPropertyEdit[playerid][CoordsMoney][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Money coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_SHIRT_POINT:
							{
								if (!gPropertyEdit[playerid][CustomInterior])
								{
									SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Shirt coords are automatic when the property has no custom interior!");
									return ShowPropertyEditDialogMain(playerid);
								}

								gPropertyEdit[playerid][CoordsShirt][CoordX] = X;
								gPropertyEdit[playerid][CoordsShirt][CoordY] = Y;
								gPropertyEdit[playerid][CoordsShirt][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Shirt coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_VEHICLE_POINT:
							{
								GetPlayerFacingAngle(playerid, R);

								gPropertyEdit[playerid][CoordsVehicle][CoordX] = X;
								gPropertyEdit[playerid][CoordsVehicle][CoordY] = Y;
								gPropertyEdit[playerid][CoordsVehicle][CoordZ] = Z;
								gPropertyEdit[playerid][CoordsVehicle][CoordR] = R;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						default:
							{
								return 1;
							}
					}
				}

				if (gTruckingEdit[playerid][ID])
				{
					new Float: X, Float: Y, Float: Z, Float: R;
					GetPlayerPos(playerid, X, Y, Z);

					switch (gTruckingEdit[playerid][EditType])
					{
						case TREDIT_CHECKPOINT:
							{
								gTruckingEdit[playerid][LocationCheckpoint][CoordX] = X;
								gTruckingEdit[playerid][LocationCheckpoint][CoordY] = Y;
								gTruckingEdit[playerid][LocationCheckpoint][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Checkpoint coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_INFO_PICKUP:
							{
								gTruckingEdit[playerid][LocationInfoPickup][CoordX] = X;
								gTruckingEdit[playerid][LocationInfoPickup][CoordY] = Y;
								gTruckingEdit[playerid][LocationInfoPickup][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Info pickup coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_TRUCK:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Truck;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Truck vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_GAS:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Gas;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Gas trailer vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_FREIGHT:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Freight;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Freight trailer vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						default:
							{
								return 1;
							}
					}
				}
			}
	}

	return 1;
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

				new stringToPrint[512];
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
		new stringToPrint[64];
		format(stringToPrint, sizeof(stringToPrint), "[ DEATHMATCH ] Get back to the arena!");
		SendClientMessage(playerid, COLOR_RED, stringToPrint);
	}

	return 1;
}

/*************************************************************************************
 *
 *       ______                       ____                  __    _ ____    ___ 
 *      / ____/________ _____  __  __/ __ \____ _________  / /   (_) __/__ |__ \
 *     / /   / ___/ __ `/_  / / / / / /_/ / __ `/ ___/ _ \/ /   / / /_/ _ \__/ /
 *    / /___/ /  / /_/ / / /_/ /_/ / _, _/ /_/ / /__/  __/ /___/ / __/  __/ __/ 
 *    \____/_/   \__,_/ /___/\__, /_/ |_|\__,_/\___/\___/_____/_/_/  \___/____/ 
 *                          /____/                                              

 *** GameMode CRL2 
 *** Credits: krusty, kompry, DRaGsTeR 
 *** Jan 2025

 *************************************************************************************/

