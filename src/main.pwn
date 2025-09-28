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
 [ Version: 	0.6.0 ]

 *****************************************************************************************************************************************/

//
//  Generic includes.
//

//#include <a_samp>
#include <open.mp>
#include <a_mysql>
#include <core>
#include <float>
#include <file>
#include <string>

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
new const GAMEMODE_CREDITS[] = "krusty, kompry, DRaGsTeR, amdulka";

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

 [ *** GameMode CRL2 *** Credits: krusty, kompry, DRaGsTeR *** Jan 2025 *** ]

 *************************************************************************************/

main()
{
	PrintAsciiLogoToLogs();
	printf(" ");
	printf(" * Starting up...");
}

public OnGameModeInit()
{
	InitDB();
	InitDrugValues();
	InitTeams();

	SetGameModeText(GAMEMODE_NAME);

	AllowAdminTeleport(true);
	AllowInteriorWeapons(false);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(true);  
	EnableZoneNames(true);
	ShowNameTags(true);
	ShowPlayerMarkers(t_PLAYER_MARKERS_MODE: true); 
	UsePlayerPedAnims();

	//
	// Start various timers.
	//

	SetTimer("AntiCheatWeapon", 30 * SECOND_MS, true);
	SetTimer("AntiFlood", 1 * SECOND_MS, true);

	SetTimer("OnRadarCheckpoint", 300, true);

	SetTimer("AutosaveData", 200 * SECOND_MS, true);
	SetTimer("UpdatePlayerScore", 1 * SECOND_MS, true);
	SetTimer("SendPlayerSalary", 5 * 60 * SECOND_MS, true);

	SetTimer("DrawClockText", 10 * SECOND_MS, true);

	SetTimer("ShowAdvert", 120 * SECOND_MS, true);

	//
	// Create pickups, static objects and static vehicles + DrawTexts.
	//

	InitRealEstateProperties();
	InitRaces();
	InitHighScores();
	InitTrucking();

	InitPickups();
	InitObjects();
	InitVehicles();
	InitTexts();

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
	SetPlayerPos(playerid, 2323.73, 1283.18, 97.60);
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

	// Reset the paintball states.
	gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
	gPaintball[playerid][E_PAINTBALL_SCORE] = 0;

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

	// Draw mapicons for the user.
	AddMapicons(playerid);

	// Text inits.
	AddTexts(playerid);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s joined the game!", playerName);

	gPlayers[playerid][Name] = playerName;
	SendClientMessageToAll(COLOR_GREY, stringToPrint);

	SendMessageToWebhook(playerid, "connected");

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, COLOR_INVISIBLE, "");
	SendClientMessageLocalized(playerid, I18N_WELCOME_MESSAGE);
	SendClientMessage(playerid, COLOR_INVISIBLE, "");

	// Ask the user to login/register.
	gPlayers[playerid][LoginAttempts] = 0;
	ShowAuthDialog(playerid);

	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	// Hide the vehicle velocity game text.
	//TextDrawHideForPlayer(playerid, KPH[playerid]);
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	KillTimer(_: gPlayerRaceTimer[playerid]);
	KillTimer(_: gPlayerMissions[playerid][TimerElapsed]);
	KillTimer(_: gPlayerMissions[playerid][TimerAttachedCheck]);

	// Save player's data and set such player to unauthorized.
	if (reason == 1)
		SavePlayerData(playerid);

	gPlayers[playerid][IsLogged] = false;

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 201);

	SendMessageToWebhook(playerid, "disconnected");

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
	SetPlayerSkin(playerid, gPlayers[playerid][Skin]);

	if (gPlayers[playerid][TeamID])
	{
		SetPlayerColor(playerid, gTeams[ gPlayers[playerid][TeamID] ][Color]);
	}

	if (gPlayers[playerid][InsideProperty])
	{
		DestroyPropertyInterior(playerid);
		gPlayers[playerid][InsideProperty] = false;
	}

	// Set the player back to the paintball area if is set in game.
	if (gPaintball[playerid][E_PAINTBALL_INGAME])
	{
		SetPlayerPos(playerid, Float: -1365.1, Float: -2307.0, Float: 39.1);
		GivePlayerWeapon(playerid, t_WEAPON: 29, 999);

		return 1;
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

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	new stringToPrint[256];

	SendDeathMessage(killerid, playerid, reason);

	// Hide velocity meters.
	//TextDrawHideForPlayer(playerid, KPH[playerid]);
	//TextDrawHideForPlayer(playerid, KPHR[playerid]);
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	if (gPaintball[playerid][E_PAINTBALL_INGAME])
	{
		// Increment the killer's score.
		gPaintball[killerid][E_PAINTBALL_SCORE]++;

		GetPaintballScoreboard();

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

	// Drop all money at the spot of death
	if (GetPlayerMoney(playerid) > 0)
	{
		new Float: X, Float: Y, Float: Z;

		GetPlayerPos(playerid, X, Y, Z);
		AddPlayerDeathPickups(playerid, Float:X, Float:Y, Float:Z);

		ResetPlayerMoney(playerid);
	}

	new t_PLAYER_STATE:killerState = GetPlayerState(killerid);

	if (IsPlayerInAnyVehicle(killerid) && !IsPlayerInAnyVehicle(playerid) && killerState == PLAYER_STATE_DRIVER && reason != WEAPON_VEHICLE)
	{
		new killerName[MAX_PLAYER_NAME]; 

		GetPlayerName(killerid, killerName, MAX_PLAYER_NAME);

		// Hide velocity meters.
		//TextDrawHideForPlayer(playerid, KPH[playerid]);
		//TextDrawHideForPlayer(playerid, KPHR[playerid]);
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
	}

	SetVehicleNumberPlate(vehicleid, VEHICLE_PLATE);

	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
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

		text[0] = '\0';
		format(stringToPrint, sizeof(stringToPrint), "%s [Team Chat]: %s", gPlayers[playerid][Name], text);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i) && gPlayers[i][TeamID] == gPlayers[playerid][TeamID])
				SendClientMessage(i, gTeams[ gPlayers[i][TeamID] ][Color], stringToPrint);
		}

		return 0;
	}

	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if (gPlayers[playerid][AdminLevel] < 3)
	{
		return 1;
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

	if (newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == gAdminAuto)
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
	}

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
							// "Ulozit vse doma"
							gProperties[propertyID][Drugs][drugID] += gPlayers[playerid][Drugs][drugID];
							gPlayers[playerid][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Saved at home");
						}
					case 1:
						{
							// "Vybrat vse z domu"
							gPlayers[playerid][Drugs][drugID] += gProperties[propertyID][Drugs][drugID];
							gProperties[propertyID][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Save to your pockets");
						}
				}

				return 1;
			}
		case DIALOG_PROPERTY_EDIT_MAIN:
			{
				if (!response)
				{
					gPropertyEdit[playerid] = gNullProperty;

					SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Property edit cancelled.");
					return 1;
				}

				switch (listitem)
				{
					// Name
					case 0:
						{
							ShowPropertyEditDialogName(playerid);
						}
						// Cost
					case 1:
						{
							ShowPropertyEditDialogCost(playerid);
						}
						// Entrance pickup coords
					case 2:
						{
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Go to a spot to record the Entrance pickup coords and type /predit entrance");
						}
						// Offer pickup coords
					case 3:
						{
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Go to a spot to record the Offer pickup coords and type /predit offer");
						}
						// Vehicle coords
					case 4:
						{
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Go to a spot to record the Vehicle coords and type /predit vehicle");
						}
						// Occupied state
					case 5:
						{
							gPropertyEdit[playerid][Occupied] = !gPropertyEdit[playerid][Occupied];
							SendClientMessage(playerid, COLOR_GREEN, "[ EDIT ] Occupied state of the property toggled");

							ShowPropertyEditDialogMain(playerid);
						}
						// Save property
					case 6:
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
					ShowPropertyEditDialogMain(playerid);
					return 1;
				}

				new label[64];
				format(label, sizeof(label), "%s", inputtext);

				gPropertyEdit[playerid][Label] = label;
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property name changed!");

				ShowPropertyEditDialogMain(playerid);
				return 1;
			}
		case DIALOG_PROPERTY_EDIT_COST:
			{
				if (!response)
				{
					ShowPropertyEditDialogMain(playerid);
					return 1;
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
				}

				return 1;
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
	new stringToPrint[256];

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
	//  Various joobs/teams pickups.
	//

	for (new i = 0; i < sizeof(gTeams); i++)
	{
		if (pickupid == _: gTeams[i][Pickups][0])
		{
			ShowMenuForPlayer(Menu:gTeams[i][Menus][0], playerid);
		}
	}

	//
	//  Trucking pickups.
	//

	for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	{
		if (pickupid == gTruckingPoints[i][InfoPickup])
		{
			format(stringToPrint, sizeof(stringToPrint), "Info Point\n\n%s\n", gTruckingPoints[i][Name]);
			return ShowPlayerDialog(playerid, DIALOG_TRUCKING_INFO, DIALOG_STYLE_MSGBOX, "Trucking Point", stringToPrint, "Close", "");
		}
	}

	//
	//  Real Estate pickups.
	//

	CheckRealEstatePickup(playerid, pickupid);

	//
	//  Other pickups --- entries,  baggies etc.
	//

	if (pickupid == gDruggeryEntrance)
	{
		new Float: dX, Float: dY, Float: dZ;
		GetObjectPos(gDruggery, dX, dY, dZ);
		SetPlayerPos(playerid, dX, dY, dZ);
	}

	for (new i = 0; i < MAX_TIKI_PRIZES; i++)
	{
		if (PICKUP: pickupid == gTikiPrizes[i][Pickup])
		{
			UpdateTikiPrize(playerid, i);
			break;
		}
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
	//  Drugz.
	//

	else if (pickupid == gCocainePackage[0] || pickupid == gCocainePackage[1] || pickupid == gCocainePackage[2] || pickupid == gCocainePackage[3] || pickupid == gCocainePackage[4])
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][COCAINE] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of cocaine.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}
	else if (pickupid == gHeroinPackage[0] || pickupid == gHeroinPackage[1] || pickupid == gHeroinPackage[2] || pickupid == gHeroinPackage[3] || pickupid == gHeroinPackage[4])
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][HEROIN] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of heroin.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}
	else if (pickupid == gMethPackage[0] || pickupid == gMethPackage[1] || pickupid == gMethPackage[2] || pickupid == gMethPackage[3] || pickupid == gMethPackage[4] || pickupid == gMethPackage[5])
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][METH] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of methamphetamine.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}
	else if (pickupid == gFentPackage[0] || pickupid == gFentPackage[1])
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][FENT] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of fentanyl.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}
	else if (pickupid == gPCPPackage)
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][PCP] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of PCP.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}
	else if (pickupid == gTHCPackage[0] || pickupid == gTHCPackage[1] || pickupid == gTHCPackage[2] || pickupid == gTHCPackage[3] || pickupid == gTHCPackage[4] || pickupid == gTHCPackage[5] || pickupid == gTHCPackage[6] || pickupid == gTHCPackage[7] || pickupid == gTHCPackage[8] || pickupid == gTHCPackage[9])
	{
		new amount = random(10);

		gPlayers[playerid][Drugs][ZAZA] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of THC.", amount);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}

	//
	//  Death pickups.
	//

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || gPlayerMoneyPickup[i] == -1)
			continue;

		DestroyPickup(gPlayerMoneyPickup[i]);
		gPlayerMoneyPickup[i] = 0;

		GivePlayerMoney(playerid, gPlayerMoneyPickupAmount[i]);
		gPlayerMoneyPickupAmount[i] = 0;
	}

	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:currentMenu = GetPlayerMenu(playerid), stringToPrint[256];

	if (row == 1)
	{
		ResetPlayerWeapons(playerid);
		gPlayers[playerid][TeamID] = TEAM_NONE;

		SendClientMessage(playerid, COLOR_GREY, "[ TEAM ] You left the team!");
		SetPlayerTeam(playerid, 0);

		return 1;
	}

	for (new i = 0; i < sizeof(gTeams); i++)
	{
		if (currentMenu == gTeams[i][Menus][0])
		{
			GivePlayerWeapon(playerid, t_WEAPON: gTeams[i][Weapons][0], gTeams[i][Ammu][0]);
			SetPlayerColor(playerid, gTeams[i][Color]);
			SetPlayerSkin(playerid, gTeams[i][Skins][0]);
			SetPlayerTeam(playerid, gTeams[i][ID]);

			gPlayers[playerid][TeamID] = gTeams[i][ID];

			format(stringToPrint, sizeof(stringToPrint), "[ TEAM ] Player %s joined the %s team!", gPlayers[playerid][Name], gTeams[i][TeamName]);
			SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
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
	if (newkeys == KEY_SECONDARY_ATTACK)
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
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
	if (enterexit == 0) // If enterexit is 0, this means they are exiting
	{
		UpdatePropertyVehicle(playerid);
	}

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

/*************************************************************************************
 *
 *       ______                       ____                  __    _ ____    ___ 
 *      / ____/________ _____  __  __/ __ \____ _________  / /   (_) __/__ |__ \
 *     / /   / ___/ __ `/_  / / / / / /_/ / __ `/ ___/ _ \/ /   / / /_/ _ \__/ /
 *    / /___/ /  / /_/ / / /_/ /_/ / _, _/ /_/ / /__/  __/ /___/ / __/  __/ __/ 
 *    \____/_/   \__,_/ /___/\__, /_/ |_|\__,_/\___/\___/_____/_/_/  \___/____/ 
 *                          /____/                                              

 [ *** GameMode CRL2 *** Credits: krusty, kompry, DRaGsTeR *** Jan 2025 *** ]

 *************************************************************************************/

