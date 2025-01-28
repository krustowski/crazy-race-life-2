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
 [ Credits: 	krusty, kompry, DRaGsTeR ]
 [ Language: 	CZ, EN ]
 [ Version: 	0.1.Z ]

 *****************************************************************************************************************************************/

//
//  Generic includes.
//

#include <a_samp>
#include <core>
#include <float>
#include <dini>
/*#include <a_objects>*/
#include <y_objects>
#include <string>

//
//  Registration
//

#include <dutils>		
#include <dudb>	

//
//  Basic definitions.
//

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

#pragma tabsize 0

#define STATS_FILE 	"stats.cfg"

#define BUG_SYSTEM 	true

#define SOUND_MUSIC10
#define SOUND_OFF

#define SECOND_MS	1000

//
//  Common colour definitions.
//

#define GREEN           0x21DD00FF
#define ORANGE          0xF97804FF
#define RED             0xE60000FF
#define MODRA      	0x0000BBAA
#define MODRA2      	0x4682B4AA
#define MODRA3      	0x4169FFAA
#define COLOR_ZELENA 	0x008000AA
#define COLOR_CYAN 	0x00FFFFAA
#define COLOR_ZELZLUT	0xADFF2FAA
#define COLOR_TMAVACYAN	0x008B8BAA
#define COLOR_BILA	0xFFFFFFAA
#define COLOR_ZLUTA 	0xFFFF00AA
#define COLOR_LEMON 	0xFFFF00AA
#define COLOR_HNEDA 	0xA52A2AAA
#define COLOR_HNEDA2	0xBC8F8FAA
#define COLOR_CERVENA	0xFF0000AA
#define COLOR_SEDA 	0x808080AA
#define COLOR_RUZOVA	0xFFC0CBAA
#define COLOR_CHARTR	0x7FFF00AA
#define COLOR_SYSTEM    0xEFEFF7AA
#define COLOR_ORANZCERV 0xFF4500AA
#define COLOR_ORANZOVA	0xFF8C00AA
#define COLOR_NEVIDITEL 0x4682B400
#define COLOR_SVZEL     0x29FF06AA
#define bezova          0xFFF8DC

new const GAMEMODE_NAME[] = "CrazyRaceLife2";
new const GAMEMODE_CREDITS[] = "krusty, kompry, DRaGsTeR";

new const MINIMAP_TEXT[] = "~g~Crazy~r~Race~b~Life~y~2";
new const VEHICLE_PLATE[] = "-CRL-2-";

forward SplitIntoTwo(input[], token1[], token2[], tokenSize);
forward StartServerReset();

//
//  Advertisement.
//

forward ShowAdvert();

#include "advert.pwn"

//
//  Anticheating.
//

forward AntiCheatWeapon();
forward AntiFlood();
forward AntiJetPack();

#include "anticheat.pwn"

//
//  Clock text (re)drawing.
//

forward DrawClockText();

#include "clock.pwn"

//
//  Racing subsystem.
//

forward CheckRaceCheckpoint(playerid);
forward SetRaceForUser(playerid, raceId);
forward StartRace();

#include "race.pwn"

//
//  Deathmatch minigame.
//

forward StartPaintball();
forward GetPaintballScoreboard();
forward EndPaintball();

#include "paintball.pwn"

//
//  Player data management + team management.
//

forward BatchSavePlayerData();
forward LoadPlayerData(playerid);
forward SavePlayerData(playerid);
forward SendPlayerSalary();
forward UpdatePlayerScore();

#include "player.pwn"

//
//  Radar + Vehicle velocity/props.
//

forward OnRadarCheckpoint();
forward OffRadarCheckpoint(playerid);

#include "radar.pwn"

#include "helpers.pwn"

//
//  Banking.
//

forward CheckPlayerBankLocation(playerid);

#include "bank.pwn"

//
//  Pickups, Objects, Vehicles, Texts, Mapicons.
//

forward InitPickups();
forward InitObjects();
forward InitVehicles();
forward InitTexts();
forward AddTexts(playerid);
forward AddMapicons(playerid);

#include "pickups.pwn"
#include "objects.pwn"
#include "vehicles.pwn"
#include "texts.pwn"
#include "mapicons.pwn"

//
//  DCMDs = command set definitions.
//

#include "dcmd.pwn"

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
	printf(" [ ********* %s ********* ]", GAMEMODE_NAME);
	printf(" [ Credits: %s ]", GAMEMODE_CREDITS);
}

public OnGameModeInit()
{
	// YSI object contructor.
	Object_Object();

	SetGameModeText(GAMEMODE_NAME);

	ShowNameTags(1);
	ShowPlayerMarkers(1); 
	UsePlayerPedAnims(1);
	AllowInteriorWeapons(0);
	EnableStuntBonusForAll(1);  

	// Set the unique Vehlicle Plate for all vehicles possible.
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		SetVehicleNumberPlate(i, VEHICLE_PLATE);
	}

	//
	// Start various timers.
	//

	SetTimer("AntiCheatWeapon", 30 * SECOND_MS, 1);
	SetTimer("AntiFlood", 1 * SECOND_MS, 1);

	SetTimer("OnRadarCheckpoint", 300, 1);

	SetTimer("BatchSavePlayerData", 200 * SECOND_MS, 1);
	SetTimer("UpdatePlayerScore", 1 * SECOND_MS, 1);
	SetTimer("SendPlayerSalary", 300 * SECOND_MS, 1);

	SetTimer("DrawClockText", 30 * SECOND_MS, 1);

	SetTimer("ShowAdvert", 120 * SECOND_MS, 1);

	//
	// Create pickups, static objects and static vehicles + DrawTexts.
	//

	InitPickups();
	InitObjects();
	InitVehicles();
	InitTexts();

	if (!dini_Exists(STATS_FILE))
	{
		dini_Create(STATS_FILE);
	}

	AddPlayerClass(155, 2323.74, 1283.19, 97.60, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(230, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 0, 0);
	AddPlayerClass(121, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(29, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(45, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(169, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);

	return 1;
}

public OnGameModeExit()
{
	print("\n +-----------------------------+");
	printf(" | Mode %s is Shuting Down |", GAMEMODE_NAME);
	print(" +-----------------------------+ \n");

	KillTimer(SetTimer("ShowAdvert", 1000 * 60 * 2, true));

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1966.1, 1936.1, 127.5);
	SetPlayerCameraPos(playerid, 1871.3, 1933.6, 127.5);
	SetPlayerCameraLookAt(playerid, 1966.1, 1936.1, 127.5);

	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if (!gPlayerAuth[playerid])
	{
		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playerName, sizeof(playerName));

		if (udb_Exists(playerName))
		{
			GameTextForPlayer(playerid, "~w~Prihlas se!", 5000, 5);
			SendClientMessage(playerid, COLOR_SVZEL, "Nejsi prihlasen --> /login heslo");
		}
		else
		{
			GameTextForPlayer(playerid, "~r~Registruj se!", 5000, 5);
			SendClientMessage(playerid, COLOR_SVZEL, "Nejsi registrovan --> /register heslo");
		}

		return 0;
	}

	SpawnPlayer(playerid);

	return 1;
}

public OnPlayerConnect(playerid)
{
	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	// Reset the auth status for a new player.
	gPlayerAuth[playerid] = false;

	// Reset the paintball states.
	gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
	gPaintball[playerid][E_PAINTBALL_SCORE] = 0;

	// Draw mapicons for the user.
	AddMapicons(playerid);

	// Text inits.
	AddTexts(playerid);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s se prave pripojil ke hre!", playerName);

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, COLOR_NEVIDITEL, "");
	SendClientMessage(playerid, GREEN, "Vitej v modu CrazyRaceLife2! :) /cmd /help /rules");
	SendClientMessage(playerid, COLOR_NEVIDITEL, "");

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);

	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	Object_OnPlayerDisconnect(playerid, reason);

	// Hide the vehicle velocity game text.
	//TextDrawHideForPlayer(playerid, KPH[playerid]);
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	// Save player's data and set such player to unauthorized.
	SavePlayerData(playerid);
	gPlayerAuth[playerid] = false;

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 201);

	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	// Fetch player's name to print a statement for other online players.
	GetPlayerName(playerid, playerName, sizeof(playerName));

	// Prepare the statement for others.
	switch (reason)
	{
		case 0: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s odpojen(a) [spadla hra].", playerName);
			}
		case 1: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s odpojen(a) [odchod].", playerName); 
			}
		case 2: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s odpojen(a) [kick/ban].", playerName);
			}
		default: 
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s odpojen(a) [neznamy duvod].", playerName);
			}
	}

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return 0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, gPlayerData[playerid][E_PLAYER_DATA_CLASS]);

	// Set the player back to the paintball area if is set in game.
	if (gPaintball[playerid][E_PAINTBALL_INGAME])
	{
		SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
		GivePlayerWeapon(playerid, 29, 999);
	}

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new stringToPrint[256];

	SendDeathMessage(killerid, playerid, reason);

	new X, Y, Z;

	GetPlayerPos(playerid, X, Y, Z);
	AddPlayerDeathPickups(playerid, Float:X, Float:Y, Float:Z);

	ResetPlayerMoney(playerid);

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

	new killerState = GetPlayerState(killerid);

	if (IsPlayerInAnyVehicle(killerid) && !IsPlayerInAnyVehicle(playerid) && killerState == PLAYER_STATE_DRIVER && reason != WEAPON_VEHICLE)
	{
		new killerName[MAX_PLAYER_NAME], stringToPrint[256]; 

		GetPlayerName(killerid, killerName, MAX_PLAYER_NAME);

		// Hide velocity meters.
		//TextDrawHideForPlayer(playerid, KPH[playerid]);
		//TextDrawHideForPlayer(playerid, KPHR[playerid]);
		TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s [ID: %d] porusil pravidla serveru! [Car kill]", killerName, killerid);
		SendClientMessageToAll(COLOR_CERVENA, stringToPrint);

		SpawnPlayer(killerid);
		PlayerPlaySound(killerid, 1056, 0, 0, 0);
	}

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if (strlen(text) > 1 && text[0] == '!')
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[256];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		text[0] == '\0';
		format(stringToPrint, sizeof(stringToPrint), "%s [Team Chat]: %s", playerName, text);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i) && gPlayerData[i][E_PLAYER_DATA_TEAM] == gPlayerData[playerid][E_PLAYER_DATA_TEAM])
				SendClientMessage(i, GetPlayerColor(playerid), stringToPrint);
		}

		return 0;
	}

	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	//--------------[ COMMON COMMANDS ]-------------|

	dcmd(admins, 6, cmdtext);         //all
	dcmd(afk, 3, cmdtext);            //all
	dcmd(bank, 4, cmdtext);		  //all
	dcmd(cmd, 3, cmdtext);            //all
	dcmd(dance, 5, cmdtext);	  //all
	dcmd(deathmatch, 10, cmdtext);	  //all
	dcmd(dwarp, 5, cmdtext); 	  //all
	dcmd(fix, 3, cmdtext); 		  //all
	dcmd(givecash, 8, cmdtext);       //all
	dcmd(help, 4, cmdtext);           //all
	dcmd(hide, 4, cmdtext); 	  //all
	dcmd(kill, 4, cmdtext); 	  //all
	dcmd(lay, 3, cmdtext);		  //all
	dcmd(locate, 6, cmdtext); 	  //all
	dcmd(lock, 4, cmdtext);           //all
	dcmd(login, 5, cmdtext);          //all
	dcmd(pm, 2, cmdtext);		  //all
	dcmd(port, 4, cmdtext); 	  //all
	dcmd(race, 4, cmdtext);		  //all
	dcmd(register, 8, cmdtext);       //all
	dcmd(rules, 5, cmdtext); 	  //all
	dcmd(skydive, 7, cmdtext);        //all
	dcmd(soska, 5, cmdtext); 	  //all
	dcmd(text, 4, cmdtext);           //all
	dcmd(ucet, 4, cmdtext);           //all
	dcmd(unlock, 6, cmdtext);         //all
	dcmd(wanted, 6, cmdtext);	  //all

	//--------------[ ADMIN COMMANDS ]-------------|

	dcmd(acmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(admincol, 8, cmdtext);       //rcon +
	dcmd(ban, 3, cmdtext);            //rcon + lvl 4
	dcmd(cam, 3, cmdtext); 		  //rcon + 
	dcmd(ccmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(elevator, 8, cmdtext);	  //rcon + lvl 4
	dcmd(fakechat, 8, cmdtext);       //rcon + lvl 2
	dcmd(flip, 4, cmdtext);           //rcon + 
	dcmd(get, 3, cmdtext);            //rcon + lvl 3
	dcmd(goto, 4, cmdtext);           //rcon + lvl 3
	dcmd(hp, 2, cmdtext); 		  //rcon + 
	dcmd(kick, 4, cmdtext);           //rcon +
	dcmd(lvl, 3, cmdtext);            //rcon + lvl 4
	dcmd(nitro, 5, cmdtext);          //rcon + lvl 3
	dcmd(odpocet, 7, cmdtext);        //rcon + 
	dcmd(reset, 5, cmdtext);	  //rcon + lvl 4
	dcmd(smazat, 6, cmdtext);         //rcon +
	dcmd(spectate, 8, cmdtext);	  //rcon + lvl 2
	dcmd(zbrane, 6, cmdtext); 	  //rcon + lvl 3

	return InvalidCommand(playerid);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	// Hide velocity meters.
	//TextDrawHideForPlayer(playerid, KPH[playerid]);
	//TextDrawHideForPlayer(playerid, KPHR[playerid]);
	TextDrawHideForPlayer(playerid, gVehicleStatesText[playerid]);

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
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
		gVehicleStatesText[playerid] = TextDrawCreate(256, 410, "~w~Stav:______%3d_%%~n~~w~Rychlost:_%3d");

		TextDrawLetterSize(gVehicleStatesText[playerid], 0.5, 1.5);
		TextDrawFont(gVehicleStatesText[playerid], 3);
		TextDrawSetOutline(gVehicleStatesText[playerid], 1);

		/*KPH[playerid] = TextDrawCreate(256, 425, "Rychlost:");

		  TextDrawAlignment(KPH[playerid], 0);
		//TextDrawBackgroundColor(KPH[playerid], 0x000000ff);
		TextDrawFont(KPH[playerid], 3);
		TextDrawLetterSize(KPH[playerid], 0.5, 1.5);
		//TextDrawColor(KPH[playerid], 0xff0000cc);
		TextDrawSetOutline(KPH[playerid], 1);
		//TextDrawSetProportional(KPH[playerid], 1);
		//TextDrawSetShadow(KPH[playerid], 1);

		KPHR[playerid] = TextDrawCreate(350, 425, "0");

		TextDrawAlignment(KPHR[playerid], 0);
		//TextDrawBackgroundColor(KPHR[playerid], 0x000000ff);
		TextDrawFont(KPHR[playerid], 3);
		TextDrawLetterSize(KPHR[playerid], 0.5, 1.5);
		//TextDrawColor(KPHR[playerid], 0x00ff00cc);
		TextDrawSetOutline(KPHR[playerid], 1);
		//TextDrawSetProportional(KPHR[playerid], 1);
		//TextDrawSetShadow(KPHR[playerid], 1);

		//TextDrawShowForPlayer(playerid, KPHR[playerid]);
		//TextDrawShowForPlayer(playerid, KPH[playerid]);*/
		TextDrawShowForPlayer(playerid, gVehicleStatesText[playerid]);
	}

	if (newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == gAdminAuto)
	{
		if (!IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Vozidlo bude zniceno, protoze nemas opravneni ho ridit!");
			GameTextForPlayer(playerid, "~r~Toto auto je jen pro ~b~rcon ~g~adminy", 5000, 5);
			SetVehicleHealth(GetPlayerVehicleID(playerid), 100.0);
		}
		else
		{
			SendClientMessage(playerid, COLOR_CYAN, "Jsi admin, auto bylo opancerovano");
			SetVehicleHealth(GetPlayerVehicleID(playerid), 99999 * 1000);
		}
	}

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
	//
	//  Various joobs/teams pickups.
	//

	if (pickupid == gTeamPickup[E_PLAYER_TEAM_LAME])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_LAME], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_ADMINZ])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_ADMINZ], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_POLICE])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_POLICE], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_GASMAN])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_GASMAN], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_DRAGSTER])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_DRAGSTER], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_GARBAGE])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_GARBAGE], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_PIZZABOY])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_PIZZABOY], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_HACKER])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_HACKER], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_CAR_REPAIR])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR], playerid);
	}
	else if (pickupid == gTeamPickup[E_PLAYER_TEAM_PYRO])
	{
		ShowMenuForPlayer(Menu:gTeamMenu[E_PLAYER_TEAM_PYRO], playerid);
	}

	//
	//  Other pickups --- entries,  baggies etc.
	//

	else if (pickupid == gAdminRoomHealth)
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
		if (!IsPlayerConnected(i) || gPlayerMoneyPickup[i] == -1)
			continue;

		DestroyPickup(gPlayerMoneyPickup[i]);
		GivePlayerMoney(playerid, gPlayerMoneyPickupAmount[i]);

		gPlayerMoneyPickupAmount[i] = 0;
	}

	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:currentMenu = GetPlayerMenu(playerid), playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (row == 1)
	{
		ResetPlayerWeapons(playerid);
		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_NONE;

		SendClientMessage(playerid, COLOR_SEDA, "[ i ] Opustil jsi team: jsi nezarazen/nezamestnan.");

		return 1;
	}

	if (currentMenu == gTeamMenu[E_PLAYER_TEAM_LAME])
	{
		GivePlayerWeapon(playerid, 5, 1);
		SetPlayerColor(playerid, COLOR_ZLUTA);
		SetPlayerSkin(playerid, 200);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_LAME;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Lamek!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_ADMINZ])
	{
		GivePlayerWeapon(playerid, 32, 1000);
		SetPlayerColor(playerid, COLOR_SVZEL);
		SetPlayerSkin(playerid, 29);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_ADMINZ;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Admin borcu!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_POLICE])
	{
		GivePlayerWeapon(playerid, 30, 100);
		GivePlayerWeapon(playerid, 31, 100);
		GivePlayerWeapon(playerid, 32, 111);
		SetPlayerColor(playerid, MODRA);
		SetPlayerSkin(playerid, 285);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_POLICE;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Policajtu!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_GASMAN])
	{
		GivePlayerWeapon(playerid, 32, 1);
		SetPlayerColor(playerid, COLOR_CERVENA);
		SetPlayerSkin(playerid, 50);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_GASMAN;
		format(stringToPrint, sizeof(stringToPrint), " [ ! ] Hrac %s se pripojil k tymu Pumparu/Benzinaku!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_DRAGSTER])
	{
		GivePlayerWeapon(playerid, 5, 1);
		GivePlayerWeapon(playerid, 30, 100);
		GivePlayerWeapon(playerid, 31, 1000);
		SetPlayerColor(playerid, COLOR_ORANZOVA);
		SetPlayerSkin(playerid, 107);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_DRAGSTER;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu DRaGsTeRù!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_GARBAGE])
	{
		GivePlayerWeapon(playerid, 4, 1);
		GivePlayerWeapon(playerid, 32, 1);
		SetPlayerColor(playerid, COLOR_SVZEL);
		SetPlayerSkin(playerid, 230); // alternatively ID 137

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_GARBAGE; 
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Tulaku!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_PIZZABOY])
	{
		GivePlayerWeapon(playerid, 4, 1);
		GivePlayerWeapon(playerid, 24, 111);
		SetPlayerColor(playerid, COLOR_ZELZLUT);
		SetPlayerSkin(playerid, 250);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_PIZZABOY;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Pizzaboyz!", playerName); 
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_HACKER])
	{
		GivePlayerWeapon(playerid, 4, 100);
		GivePlayerWeapon(playerid, 24, 100);
		SetPlayerColor(playerid, COLOR_BILA);
		SetPlayerSkin(playerid, 170);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_HACKER;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Hackeru!", playerName); 
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR])
	{
		GivePlayerWeapon(playerid, 4, 100);
		GivePlayerWeapon(playerid, 24, 100);
		SetPlayerColor(playerid, COLOR_SEDA);
		SetPlayerSkin(playerid, 50);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_CAR_REPAIR;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Automechaniku!", playerName);
	}
	else if (currentMenu == gTeamMenu[E_PLAYER_TEAM_PYRO])
	{
		GivePlayerWeapon(playerid, 4, 100);
		GivePlayerWeapon(playerid, 24, 100);
		SetPlayerColor(playerid, COLOR_SEDA);
		SetPlayerSkin(playerid, 230);

		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_PYRO;
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s se pripojil k tymu Pyrotechniku!", playerName);
	}

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
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

