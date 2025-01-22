/*==========================================================================================================================================||
  ||==========================================================================================================================================||
  ||                                                                                                                                          ||
  ||      CCCCCCCCCCCCCCCCC   RRRRRRRRRRRRRRRRRR   LLLL                                                                                       ||
  ||      CCCCCCCCCCCCCCCCC   RRRRRRRRRRRRRRRRRR   LLLL                    IIII                                                               ||
  ||      CCCC                RRRR          RRRR   LLLL                    IIII                                                               ||
  ||      CCCC                RRRR          RRRR   LLLL                                                                                       ||
  ||      CCCC                RRRR          RRRR   LLLL                                                                                       ||
  ||      CCCC                RRRR          RRRR   LLLL                                                                                       ||
  ||      CCCC                RRRR          RRRR   LLLL                    IIII      VVVV                   VVVV        EEEEEEEEEEEEEE        ||
  ||      CCCC                RRRRRRRRRRRRRRRRRR   LLLL                    IIII      VVVV                  VVVV        EEEEEEEEEEEEEEE        ||
  ||      CCCC                RRRRRRRRRRRRRRRRRR   LLLL                IIIIIIII       VVVV                VVVV        EEEE        EEEE        ||
  ||      CCCC                RRRR RRRR            LLLL                IIIIIIII        VVVV              VVVV        EEEE         EEEE        ||
  ||      CCCC                RRRR  RRRR           LLLL                    IIII         VVVV            VVVV        EEEEEEEEEEEEEEEEEE        ||
  ||      CCCC                RRRR   RRRR          LLLL                    IIII          VVVV          VVVV        EEEEEEEEEEEEEEEEEEE        ||
  ||      CCCC                RRRR    RRRR         LLLL                    IIII           VVVV        VVVV        EEEE                        ||
  ||      CCCC                RRRR     RRRR        LLLL                    IIII            VVVV      VVVV        EEEE                         ||
  ||      CCCC                RRRR      RRRR       LLLL                    IIII             VVVV    VVVV        EEEE                          ||
  ||      CCCC                RRRR       RRRR      LLLL                    IIII              VVVV  VVVV         EEEE                          ||
  ||      CCCCCCCCCCCCCCCCCC  RRRR        RRRR     LLLLLLLLLLLLLLLLLL   IIIIIIIIII            VVVVVVVV          EEEEEEEEEEEEEEEEEEEEE         ||
  ||      CCCCCCCCCCCCCCCCCC  RRRR         RRRR    LLLLLLLLLLLLLLLLLL   IIIIIIIIII             VVVVVV            EEEEEEEEEEEEEEEEEEEE         ||
  ||                                                                                                                                          ||
  ||                                                                                                                                          ||
  ||                           ** CRLive ** by kRySpiNCzE ©* copy kRySpiNCzE & kompry 2008-2010 ©**                                           ||
  ||==========================================================================================================================================||
  ||==========================================================================================================================================||
  ||==========================================================================================================================================||

  [ MODE CRLive ]

  <<  Zákaz íøení módu bez vìdomí autorù < ©copyright kRySpiN[CzE & kompry > !  >>

  [ Autor : _Dk]kRySpiN[CzE  [ pawno ]  &&  kompry [ MTA ] ]
  [ Thanks : Pawno.cz > Uèíme se pawno kadý den , RLM]DRaGsTeR[CzE © - special thanks ]
  [ Website : http://kyrspa.wz.cz [ kRySpiNCzE ]	[ Create Mode : From 15.11.2008 ]
  [ Game Mode : Crazy & Race Live (No RealLive Style) ]
  [ Mode Language : Czech ]
  [ Version: 1.30i ]
  [ Cars: 17 ]
  [ Jobs: 8 ] !
  [ Adminscript: YES [ inside ] ]
  [ -- ]

  -------------------------------


  [ Commands ]

  [ Commands for player ]

  [ /register /login /cmd /help /rules /balicek /kill /afk /vybrat /ulozit /stav ]
  [ /smazat /lock /unlock /nitro || /nos /mp3 /mp3s /zel /opr /alist /dwarp /drag ]
  [ /skydrive /otrhat /sklenik /tabak /hulit /ubalit /buypapir  ]

  --------------------------------

  [ AdminScript ]

  [ /prachy /ccmd /cam1 /cam2 /cam3 /camoff /acmd /vup /vdown /ban /kick /lvl /flip /vybava /hp /vstop ]

  --------------------------------

  [ Povolani ] [ gPlayerData[playerid][E_PLAYER_DATA_TEAM] ]

  [ 0 ] Nezamìstnaný
  [ 1 ] Lamy [ LV ]
  [ 2 ] Admin - borci [ LV ]
  [ 3 ] Polii [ LV - )LS( ] - LS este neni
  [ 4 ] Benzinák [ LV ]
  [ 5 ] Dragster [ LV ]
  [ 6 ] Tulaci [ LS ]
[ 7 ] Pizzaboy [ LS ]
[ 8 ] Hackri [ LS ]
[ 9 ] Technik [ ? ] - neni pripravuju ..
[ 10 ] Pyrotechnik [ ? ]
[ ? ] ? [ ? ]
[ -- ]

-------------------------------- >[ 0-vyp | 1-zap xD ]<
ShowNameTags(1); 					//meno 1-zapnute 0-vypnute
ShowPlayerMarkers(1); 				//zobrazenie na mape 1-zapnute 0-vypnute
UsePlayerPedAnims(); 				//zrychli na sprintovanie hraca  singl...
AllowInteriorWeapons(1); 			//zbrane v interieru
EnableStuntBonusForAll(0);  		//vypne stunt bonusy aspon mylsim:)

//-----------------------[ DEKLERAÈNÍ ÈÁST MÓDU]------------------------------//
//---------------------[ INCLUDY DEFINICE PARAGMY ]---------------------------*/
#include <a_samp>
#include <core>
#include <float>
#include <dini>
/*#include <a_objects>*/
#include <y_objects>
#include <string>
#include <dutils>		//kregistraci
#include <dudb>			//k registraci

#define Text_Under_Minimap "~g~CrAzY ~r~& ~r~RaCe ~b~LiVe"
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

#pragma tabsize 0

#define statistika 	"statistika.cfg"
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

#define SCM             SendClientMessage
#define nebo            ||
#define hrac            playerid
#define BUG_SYSTEM 	true

#define SOUND_MUSIC10
#define SOUND_OFF

#define RC_BANDIT   	441
#define RC_BARON    	464
#define RC_GOBLIN  	501
#define RC_RAIDER  	465
#define D_TRAM     	449
#define RC_TANK    	564
#define RC_CAM      	594

new const GAMEMODE_NAME[] = "CrazyRaceLife2";
new const VEHICLE_PLATE[] = "-CRL-2-";

forward SplitIntoTwo(input[], token1[], token2[], tokenSize);
forward StartServerReset();

//
// Advertisement.
//

forward ShowAdvert();

#include "advert.pwn"

//
// Anticheating.
//

forward AntiCheatWeapon();
forward AntiFlood();
forward AntiJetPack();

#include "anticheat.pwn"

//
// Clock text (re)drawing.
//

forward DrawClockText();

#include "clock.pwn"

//
// Drag race.
//

forward StartDragRace();

#include "drag.pwn"
//
// Paintball minigame.
//

forward StartPaintball();
forward GetPaintballScoreboard();
forward EndPaintball();

#include "paintball.pwn"

//
// Player data management.
//

forward BatchSavePlayerData();
forward LoadPlayerData(playerid);
forward SavePlayerData(playerid);
forward SendPlayerSalary();
forward UpdatePlayerScore();

#include "player.pwn"

//
// Radar + Vehicle velocity.
//

forward OnRadarCheckpoint();
forward OffRadarCheckpoint(playerid);

#include "radar.pwn"

//
//
//

//forward RESET();

//
// Global static objects.
//

new gAdminAuto;
new gAdminElevator;

//
// Global static team objects.
//

new gAdminRoomHealth;

new gHackerzInteriorEntrance;
new gHackerzInteriorExit;
new gHackerzMoneyBag;

new gAdminDoorDown;
new gAdminDoorUp;

new picktunel;

//
//
//

new gTeamPickupLame, gTeamPickupAdminz, gTeamPickupPolice, gTeamPickupGasman, gTeamPickupDragster, gTeamPickupGarbage, gTeamPickupHacker, gTeamPickupPizzaboy, gTeamPickupCarRepair, gTeamPickupPyro;

//
//
//

new gVehicleName[][] = {
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Pereniel",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Mr Whoopee",
	"BF Injection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RC Bandit",
	"Romero",
	"Packer",
	"Monster Truck",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley's RC Van",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RC Baron",
	"RC Raider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"News Chopper",
	"Rancher",
	"FBI Rancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"Blista Compact",
	"Police Maverick",
	"Boxville",
	"Benson",
	"Mesa",
	"RC Goblin",
	"Hotring Racer",
	"Hotring Racer",
	"Bloodring Banger",
	"Rancher",
	"Super GT",
	"Elegant",
	"Journey",
	"Bike",
	"Mountain Bike",
	"Beagle",
	"Cropdust",
	"Stunt",
	"Tanker",
	"RoadTrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"Hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"Cement Truck",
	"Tow Truck",
	"Fortune",
	"Cadrona",
	"FBI Truck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster Truck",
	"Monster Truck",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RC Tiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"Freight",
	"Trailer",
	"Kart",
	"Mower",
	"Duneride",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"Newsvan",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"Trailer",
	"Trailer",
	"Andromada",
	"Dodo",
	"RC Cam",
	"Launch",
	"Police Car (LSPD)",
	"Police Car (SFPD)",
	"Police Car (LVPD)",
	"Police Ranger",
	"Picador",
	"S.W.A.T. Van",
	"Alpha",
	"Phoenix",
	"Glendale",
	"Sadler",
	"Luggage Trailer",
	"Luggage Trailer",
	"Stair Trailer",
	"Boxville",
	"Farm Plow",
	"Utility Trailer"
};

new VehStats[200];

stock chrfind(n, h[], s = 0)
{
	new l = strlen(h);
	while (s < l)
	{
		if (h[s] == n) return s;
		s++;
	}
	return -1;
}

stock BanAll()
{
	for (new i; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			Ban(i);
		}
	}
}

stock KickAll()
{
	for (new i; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			Kick(i);
		}
	}
}

stock SystemMsg(playerid, msg[])
{
	if (IsPlayerConnected(playerid) && strlen(msg) > 0)
	{
		SendClientMessage(playerid, COLOR_SVZEL, msg);
	}

	return 1;
}

stock IsNumeric(input[])
{
	for (new i = 0, j = strlen(input); i < j; i++) 
	{
		if (input[i] > '9' || input[i] < '0') 
			return 0;
	}

	return 1;
}

//
//  DCMDs
//

dcmd_lock(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute, nebo nejsi ridicem!");
		return 1;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i != playerid)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
		}
	}

	SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Vozidlo zamceno! :)");

	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	PlayerPlaySound(playerid, 1056, pX, pY, pZ);

	return 1;
}

dcmd_unlock(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute, nebo nejsi ridicem!");
		return 1;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i != playerid)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
		}
	}

	SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Vozidlo odemceno! :)");

	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	PlayerPlaySound(playerid, 1056, pX, pY, pZ);

	return 1;
}

dcmd_register(playerid, params[])
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (gPlayerAuth[playerid])
		return SystemMsg(playerid, "[SERVER] Registrace herniho uctu probehla uspesne! --> /login *heslo*");

	if (udb_Exists(playerName))
		return SystemMsg(playerid, "[SERVER] Neni treba se znovu registrovat --> /login *heslo*.");

	if (strlen(params) == 0)
		return SystemMsg(playerid, "[SERVER] Registrace je povinna --> /register *heslo*");

	if (udb_Create(playerName, params))
		return SystemMsg(playerid, "[SERVER] Herni ucet uspesne vytvoren --> /login *heslo*.");

	return 1;
}

dcmd_login(playerid, params[])
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (gPlayerAuth[playerid]) 
		return SystemMsg(playerid, "[SERVER] Uz jsi prihlasen.");

	if (!udb_Exists(playerName)) 
		return SystemMsg(playerid, "[SERVER] Data pro dany nickname nenalezena --> /register *heslo*");

	if (strlen(params) == 0) 
		return SystemMsg(playerid, "[SERVER] Je treba se prihlasit --> /login *heslo*");

	if (udb_CheckLogin(playerName, params))
	{
		gPlayerAuth[playerid] = true;
		LoadPlayerData(playerid);

		return SystemMsg(playerid, "[SERVER] Hrac prihlasen, pokracujte pomoci Spawn.");
	}

	return SystemMsg(playerid, "[SERVER] Prihlaseni se nezdarilo --> /login *heslo*");
}


dcmd_smazat(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	for (new c = 0; c < 45; c++) 
		SendClientMessageToAll(COLOR_NEVIDITEL, " ");

	new adminName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s promazal(a) chat.", adminName);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_text(playerid, params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /text [ID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[256], targetName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	format(stringToPrint, sizeof(stringToPrint), "Hrac %s rika hraci %s, ze: %s", playerName, targetName, token2);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_afk(playerid, params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (!gPlayerData[playerid][E_PLAYER_DATA_AFK])
	{
		format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s (ID: %d) na chvili odesel od PC (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

		// Lock the player's animations.
		TogglePlayerControllable(playerid, false);

		gPlayerData[playerid][E_PLAYER_DATA_AFK] = 1;
	}
	else
	{
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s (ID: %d) se vratil do hry (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_SVZEL, stringToPrint);

		// Re-enable player's animations.
		TogglePlayerControllable(playerid, true);

		gPlayerData[playerid][E_PLAYER_DATA_AFK] = 0;
	}

	return true;
}

dcmd_ulozit(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ulozit [castka]");

	new amount = strval(params);

	if (amount > GetPlayerMoney(playerid))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	gPlayerData[playerid][E_PLAYER_DATA_BANK] += amount;
	GivePlayerMoney(playerid, -amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Ulozil jsi castku: $%d! Zustatek na uctu: $%d!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_vybrat(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /vybrat [castka]");

	new amount = strval(params);

	if (amount > gPlayerData[playerid][E_PLAYER_DATA_BANK])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	gPlayerData[playerid][E_PLAYER_DATA_BANK] -= amount;
	GivePlayerMoney(playerid, amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Vybral jsi castku: $%d! Zustatek na uctu: $%d!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_stav(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Bezny zustatek na bankovnim uctu: $%d!", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_ccmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	SendClientMessage(playerid, COLOR_ZELZLUT, "[ i ][CAM] KAMERY: /cam1 (pyramida dole), /cam2 (banka atd), /camoff");

	return 1;
}

dcmd_acmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	SendClientMessage(playerid, COLOR_ZELZLUT, "[ i ] /smazat /prachy /ccmd /acmd /vup /vdown /kick /ban /lvl /hp ");
	SendClientMessage(playerid, COLOR_ZELZLUT, "[ i ] /fakechat /admincol /get /goto ");

	return 1;
}

dcmd_help(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_ZLUTA, "[ NAPOVEDA/POMOC: ]");
	SendClientMessage(playerid, COLOR_ZLUTA, "[ Prikazy : /cmd || Pravidla /rules ]");
	SendClientMessage(playerid, COLOR_ZLUTA, "[ Made by krusty & kompry  ]");

	return 1;
}

dcmd_skydive(playerid, params[])
{
#pragma unused params
	// Give such user a parachute.
	GivePlayerWeapon(playerid, 46, 1);

	// Set their position high above the LV pyramide.
	SetPlayerPos(playerid, 2247.61, 1260.14, 1313.40);

	SendClientMessage(playerid, COLOR_CYAN, "[ i ] Skocil jsi z letadla! Uzij si skydive!");

	return 1;
}

dcmd_odpocet(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params) || !strval(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /odpocet [sekundy]");

	//new stringToPrint[256];

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~odpocet", strval(params) * 1000, 4);

	//format(stringToPrint, sizeof(stringToPrint), "~n~~n~~n~~n~~n~~n~%d", strval(params));
	//GameTextForPlayer(playerid, stringToPrint, 2000, 3);

	return 1;
}

dcmd_fakechat(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /fakechat [playerID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac se zadanym ID neni pritomen na serveru!.");

	SendPlayerMessageToAll(targetId, token2);

	SendClientMessage(playerid, COLOR_BILA, "[ i ] Falesna zprava byla uspesne odeslana!");

	return 1;
}

dcmd_ban(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ban [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToBan = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[256];

	if (!IsPlayerConnected(playerIdToBan))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni na serveru!");

	// Get participated nicknames.
	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToBan, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s [ID: %d] zabanoval hrace %s [ID: %d] !!!", adminName, playerid, playerName, playerIdToBan);
	SendClientMessageToAll(COLOR_CYAN, stringToPrint);

	Ban(playerIdToBan);

	return 1;
}

dcmd_admins(playerid, params[])
#pragma unused params
{
	SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Administratori online:");

	new adminCount;

	for (new i = 0; i < GetMaxPlayers(); i++) 
	{
		// IsPlayerAdmin(i) == RCON admin
		if (IsPlayerConnected(i) && (gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] > 0 || IsPlayerAdmin(i)))
		{
			adminCount++;

			new adminName[MAX_PLAYER_NAME], stringToPrint[128];

			// Omit RCON admin(s) in the output for now...
			if (gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] > 0) 
			{
				GetPlayerName(i, adminName, sizeof(adminName));
				format(stringToPrint, sizeof(stringToPrint), "[ %s [ID: %2d] LVL: %d]", adminName, i, gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL]);
				SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);
			}
		}
	}

	if (!adminCount) 
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Zadny admin neni pritomen na serveru!");
		return 0;
	}

	return 1;
}

//----------------------------------------
dcmd_kick(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /kick [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToKick = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!IsPlayerConnected(playerIdToKick)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToKick, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s vyhodil(a) hrace %s ze serveru !!! ", adminName, playerName);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	Kick(playerIdToKick);

	return 1;
}

dcmd_lvl(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /lvl [playerID] [adminLvl]");

	new targetId = strval(token1), targetLvl = strval(token2);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] <= gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nemuzes menit level adminum stejneho nebo vyssiho levelu nez mas sam!");

	if (targetId == playerid) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nemuzes menit level sam sobe!");

	if (targetLvl < 0 || targetLvl > 4)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Rozsah levelu je pouze 0-4!");

	if (targetLvl == gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Dany hrac jiz vlastni dany admin level!");

	new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(targetId, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s nastavil hraci %s [ ID: %d ] Admin-Level %d!", adminName, playerName, targetId, targetLvl);

	gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL] = targetLvl;
	SavePlayerData(targetId);

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return 1;
}

dcmd_goto(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /goto [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Neni mozne teleportovat se k sobe samemu!");

	// Fetch the coordinates of the targetId player.
	GetPlayerPos(targetId, x, y, z);

	new playerState = GetPlayerState(playerid), vehicleId = GetPlayerVehicleID(playerid);

	// Ensure the player is outside.
	SetPlayerInterior(playerid, 0);

	switch (playerState) 
	{
		case PLAYER_STATE_DRIVER:
			{
				SetVehiclePos(vehicleId, x, y, z);
			}
		default:
			{
				SetPlayerPos(playerid, x, y, z);
			}
	}

	return 1;
}

dcmd_get(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /get [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Neni mozne teleportovat sebe sama!");

	GetPlayerPos(playerid, x, y, z);

	new targetPlayerState = GetPlayerState(targetId), targetVehicleId = GetPlayerVehicleID(targetId);

	SetPlayerInterior(targetId, 0);

	switch (targetPlayerState)
	{
		case PLAYER_STATE_DRIVER:
			{
				SetVehiclePos(targetVehicleId, x, y, z);
			}
		default:
			{
				SetPlayerPos(targetId, x, y, z);
			}
	}

	return 1;
}

dcmd_givecash(playerid, params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /givecash [playerID] [castka]");

	new targetId = strval(token1), targetAmount = strval(token2);

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Takovy financni prevod je bezpredmetny!");

	if (targetAmount > GetPlayerMoney(playerid) || targetAmount < 0)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128], targetName[MAX_PLAYER_NAME];

	// Fetch players' names.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	// Send an informative statement to the receiving player.
	format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s [ID: %d] ti poslal castku %d €!", playerName, playerid, targetAmount);
	SendClientMessage(targetId, COLOR_SVZEL, stringToPrint);

	// Transfer money.
	GivePlayerMoney(targetId, targetAmount);
	GivePlayerMoney(playerid, -targetAmount);

	// Send an informative statement to the sending player.
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Castka %s € uspesne zaslana hraci %s [ID: %d]!");
	SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);

	return 1;
}

dcmd_nitro(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /nitro [ID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new targetPlayerState = GetPlayerState(targetId), targetVehicleId = GetPlayerVehicleID(targetId);

	if (!IsPlayerInVehicle(targetId))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac se nenachazi ve vozidle!");

	if (targetPlayerState != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac je sice v aute, ale neni ridicem!");

	if (!IsPlayerInValidNosVehicle(targetId, targetVehicleId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Do auta hrace nejde nainstalovat nitro !");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));

	// Add the NoS component to such vehicleId.
	AddVehicleComponent(targetVehicleId, 1010);

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s ti do auta nainstaloval nitro!", adminName);

	SendClientMessage(playerid, COLOR_SEDA, "[ i ] Nitro nainstalováno do auta hrace s danym ID!");
	SendClientMessage(targetId, COLOR_SVZEL, stringToPrint);

	return 1;
}

dcmd_admincol(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouzití: /admincol [1-5]");

	new adminColToSet = strval(params);

	switch (adminColToSet)
	{
		case 1:
			{
				SetPlayerColor(playerid, COLOR_SVZEL);
				SendClientMessage(playerid, COLOR_SVZEL, "[ ! ] Barva nicku nastavena na svetle zelenou!");
			}
		case 2:
			{
				SetPlayerColor(playerid, MODRA);
				SendClientMessage(playerid, MODRA, "[ i ] Barva nicku nastavena na modrou!");
			}
		case 3:
			{
				SetPlayerColor(playerid, COLOR_CERVENA);
				SendClientMessage(playerid, COLOR_CERVENA, "[ i ] Barva nicku nastavena na cervenou!");
			}
		case 4:
			{
				SetPlayerColor(playerid, COLOR_ORANZOVA);
				SendClientMessage(playerid, COLOR_ORANZOVA, "[ i ] Barva nicku nastavena na oranzovou!");
			}
		case 5:
			{
				SetPlayerColor(playerid, COLOR_BILA);
				SendClientMessage(playerid, COLOR_BILA, "[ i ] Barva nicku nastavena na bilou!");
			}
		default:
			{
				return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Barvy pouze 1-5!");
			}
	}

	return 1;
}

dcmd_ucet(playerid, params[])
{
#pragma unused params
	new lineToPrint1[256], lineToPrint2[256], lineToPrint3[265];

	format(lineToPrint1, sizeof(lineToPrint1), "[ INFO ] [ VYPIS HERNIHO UCTU ] ***");
	format(lineToPrint2, sizeof(lineToPrint2), "[ INFO ] [ Penize | $%d ], [ Banka | $%d ], [ Wanted level | %d ], [ Skin | %d ], [ Tym | %d ]", GetPlayerMoney(playerid), gPlayerData[playerid][E_PLAYER_DATA_BANK], GetPlayerWantedLevel(playerid), GetPlayerSkin(playerid), gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
	format(lineToPrint3, sizeof(lineToPrint3), "[ INFO ] [ Admin level | %d ], [ Joint | %d ks ], [ Zapik | %d ks ], [ Marihuana | %d g ], [ Tabak | %d ks ]", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL], gPlayerHulo[playerid][E_PLAYER_HULO_JOINT], gPlayerHulo[playerid][E_PLAYER_HULO_LIGHTER], gPlayerHulo[playerid][E_PLAYER_HULO_ZAZA], gPlayerHulo[playerid][E_PLAYER_HULO_TOBACCO]);

	SendClientMessage(playerid, COLOR_ZLUTA, lineToPrint1);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint2);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint3);

	return 1;
}

dcmd_flip(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /flip [ID]!");

	new targetId = strval(params), Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (!IsPlayerInAnyVehicle(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID se nenachazi v aute!");

	if (GetPlayerState(targetId) != PLAYER_STATE_DRIVER) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID se sice nachazi v aute, ale neni ridicem!");

	// Flip player's vehicle.
	GetVehicleZAngle(GetPlayerVehicleID(targetId), z);
	SetVehicleZAngle(GetPlayerVehicleID(targetId), z);

	return 1;
}

dcmd_djoin(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /djoin [ID zavodu]");

	new dragRaceId = strval(params), stringToPrint[128];

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Pro prihlaseni do dragu je treba byt v aute!");

	// Check if already joined such race.
	if (gDragRace[playerid][dragRaceId])
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Do daneho zavodu jsi jiz prihlasen!");

	switch (dragRaceId)
	{
		case E_DRAG_RACE_ID_LV_PYRAMID:
			{
				gDragRace[playerid][dragRaceId] = true;	
				GivePlayerMoney(playerid, -300);

				SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Uspesne prihlasen do daneho zavodu (prihlaska $300)!");
			}
		default:
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Drag zavod s danym ID neni pripraven!");
				return SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);
			}
	}

	return 1;
}

dcmd_dance(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nelze byt v aute pro zapnuti animace!");
		return 1;
	}

	switch (strval(params)) 
	{
		case 1:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
			}
		case 2:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
			}
		case 3:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
			}
		case 4:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
			}
		default:
			{
				SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /dance [1-4]");
			}
	}

	return 1;
}

dcmd_cam(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	switch (strval(params))
	{
		case 1:
			{
				SetPlayerCameraPos(playerid, 2219.87, 1266.13, 12.53);
				SetPlayerCameraLookAt(playerid, 2219.89, 1266.13, 12.53);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 1 zap. [/ccmd][/camoff]");
			}
		case 2:
			{
				SetPlayerCameraPos(playerid, 2035.62, 1303.53, 10.41);
				SetPlayerCameraLookAt(playerid, 2056.07, 1318.53, 10.41);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 2 zap. [/ccmd][/camoff]");
			}
		case 3: 
			{
				SetPlayerCameraPos(playerid, 2254.22, 1207.01, 10.38);
				SetPlayerCameraLookAt(playerid, 2254.22, 1207.01, 10.38);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 3 zap. [/ccmd][/camoff]");
			}
		default:
			{
				SetCameraBehindPlayer(playerid);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera vypnuta [/ccmd]");
			}
	}

	return 1;
}

dcmd_lay(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nelze byt v aute pro zapnuti animace!");
		return 1;
	}

	ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 0, 1, 1, 1, 1);

	return 1;
}

dcmd_cmd(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_SVZEL, "[ PRIKAZY: ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /cmd /rules /help /balicek /kill /afk  /lock /unlock ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /register /login /mp3 /mp3s /djoin(jeste neni hotovo) /dwarp /skydrive ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /admins /paintball /locate /wanted ]");

	return 1;
}

dcmd_elevator(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3)
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	switch (params)
	{
		case "up":
			{
				MoveObject(gAdminElevator, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);
				GetPlayerName(playerid, adminName, sizeof(adminName));

				format(stringToPrint, sizeof(stringToPrint), "[ AV ] Admin %s rozjel vytah nahoru!", adminName);
				SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
			}
		case "stop":
			{
				StopObject(gAdminElevator);

				format(stringToPrint, sizeof(stringToPrint), "[ ! ] Výtah se zasekl! Kontaktujte technika!");
				SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
			}
		case "down":
			{
				MoveObject(gAdminElevator, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);
				GetPlayerName(playerid, adminName, sizeof(adminName));

				format(stringToPrint, sizeof(stringToPrint), "[ AV ] Admin %s poslal vytah dolu", adminName);
				SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
			}
		default:
			{
				SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /elevator [up/down/stop]");
			}
	}

	return 1;
}

dcmd_paintball(playerid, params[])
{
	switch (params)
	{
		case "join":
			{
				SendClientMessageToAll(COLOR_ZLUTA, "[ ! ] Paintball zacne za 45 sekund! Pripojte se pomoci /paintball join");
				SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);

				SetTimer("StartPaintball", 45000, 0);

				gPaintball[playerid][E_PAINTBALL_INGAME] = 1;
			}
		case "exit":
			{
				new playerName[MAX_PLAYER_NAME], stringToPrint[128];

				GetPlayerName(playerid, playerName, sizeof(playerName));

				if (gPaintball[playerid][E_PAINTBALL_INGAME])
				{
					format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s opousti paintball (/paintball exit)!", playerName);
					SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

					SetPlayerHealth(playerid, 0.0);
					gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
				}
			}
		default:
			{
				SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /paintball [join/exit]")
			}
	}

	return 1;
}

dcmd_zbrane(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3)
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /zbrane [playerID]!");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		//return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");
		targetId = playerid;

	GivePlayerWeapon(targetId, 26, 400);
	GivePlayerWeapon(targetId, 28, 400);
	GivePlayerWeapon(targetId, 31, 400);
	GivePlayerWeapon(targetId, 43, 1);
	GivePlayerWeapon(targetId, 46, 1);

	return 1;
}

dcmd_reset(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4)
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new stringToPrint[128];

	format(stringToPrint, sizeof(stringToPrint), "[ ! ][ SERVER ] Za 60 sekund dojde k automatickemu restartu serveru!");
	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	SetTimer("StartServerReset", 60000, true);
	
	return 1;
}

dcmd_locate(playerid, params[])
{
#pragma unused params
		new stringToPrint[256], interior = GetPlayerInterior(playerid), Float:X, Float:Y, Float:Z, Float:Angle;

		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Nachazite se se v interieru No. %d na souradnicich: X[%.1f], Y[%.1f], Z[%.1f], Rotace[%.1f].", interior, X, Y, Z, Angle);
		SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);

		return 1;
	}

dcmd_wanted(playerid, params[]) 
{
#pragma unused params
	if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_POLICE && !IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Tuhle pravomoc maji pouze clenove tymu Policajtu!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (GetPlayerWantedLevel(i) == 0)
			continue;

		GetPlayerName(i, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "%s [ID: %d] --- WANTED level %d", playerName, i, GetPlayerWantedLevel(i));
		SendClientMessage(playerid, COLOR_BILA, stringToPrint);
	}

	return 1;
}

dcmd_hp(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /hp [playerID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	SetPlayerHealth(targetId, 100.0);
	SetPlayerArmour(targetId, 100.0);

	SendClientMessage(targetId, COLOR_SEDA, "[ ! ] Zdravi: 100.0, Vesta: 100.0");

	return 1;
}

dcmd_port(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		RemovePlayerFromVehicle(playerid);
	}

	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Portl ses do LV nad schodiste.");

	return 1;
}

dcmd_hide(playerid, params[]) 
{
#pragma unused params
	if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_ADMINZ)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Tento prikaz je urcen pouze pro tym Admin-borcu!");

	if (!gPlayerData[playerid][E_PLAYER_DATA_HIDE])
	{
		SetPlayerColor(playerid, COLOR_NEVIDITEL);
		SendClientMessage(playerid, COLOR_SVZEL, "[ HIDE ] Nyni jsi na herni mape neviditelny!");
	} else {
		SetPlayerColor(playerid, COLOR_SVZEL);
		SendClientMessage(playerid, COLOR_SVZEL, "[ HIDE ] Nyni jsi na opet viditelny na herni mape!");
	}

	return 1;
}

//
//
//

stock SendMessageToAdmins(colorId, const messageString[])
{
	for (new i = 0; i <= MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] >= 3))
		{
			SendClientMessage(i, colorId, messageString);
		}
	}

	return 1;
}

//---------------------------------[ DCMD ]-----------------------------------///
//-----------------------[ KONEC DEKLEREÈNÍ ÈÁSTÍ ]---------------------------///

/////////////////////////////////////////////////////////////////////////////////
/*///////////////////////////////////////////////////////////////////////////////
  /     CCCCCCCCC   RRRRRRRRR     LL             II                               /
  /     CC          RR     RR     LL                                              /
  /     CC          RR     RR     LL             II    VV      VV     EEEEEEEE    /
  /     CC          RRRRRRRRR     LL           IIII     VV    VV     EE     EE    /
  /     CC          RR    RR      LL             II      VV  VV     EEEEEEEEEE    /
  /     CC          RR     RR     LL             II       VVVV     EE             /
  /     CCCCCCCCC   RR      RR    LLLLLLLLL   IIIIIIII     VV       EEEEEEEEEE    /
  /                                                                               /
  / C&RLIVE BY ** kRySpiNCzE & kompry * COPY kRySpiNCzE & kompry 2008 - 2010  */
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

main()
{
	print("\n--------------------------------"); //vypis do console a log serveru
	print(" [ ***** CrAzY RaCe Life ***** ]     ");
	print(" [ StUnTs, RaCeS aNd DrIvIng ! ]  ");
	print(" [ Made by krusty and kompry!  ] ");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	// YSI object contructor.
	Object_Object();

	SetGameModeText(GAMEMODE_NAME);

	//
	// Start various timers.
	//

	SetTimer("AntiCheatWeapon", 30000, 1);
	SetTimer("AntiFlood", 1000, 1);

	SetTimer("OnRadarCheckpoint", 300, 1);

	SetTimer("BatchSavePlayerData", 200000, 1);
	SetTimer("UpdatePlayerScore", 1000, 1);
	SetTimer("SendPlayerSalary", 300000, 1);

	//
	// Create pickups, static objects and static vehicles.
	//

	gTeamPickup[E_PLAYER_TEAM_LAME] = CreatePickup(1239, 1, 2252.11, 1285.30, 19.17);
	gTeamMenu[E_PLAYER_TEAM_LAME] = CreateMenu("Lamerz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_LAME], 0, "Lamka");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_LAME], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_ADMINZ] = CreatePickup(1239, 1, 2304.43, 1151.95, 85.94);
	gTeamMenu[E_PLAYER_TEAM_ADMINZ] = CreateMenu("Adminz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_ADMINZ], 0, "Admin borec");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_ADMINZ], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_POLICE] = CreatePickup(1239, 1, 2171.22, 1397.11, 11.06);
	gTeamMenu[E_PLAYER_TEAM_POLICE] = CreateMenu("Police LV", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_POLICE], 0, "Policajt");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_POLICE], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_GASMAN] = CreatePickup(1239, 1, 2637.36, 1127.04, 11.18);
	gTeamMenu[E_PLAYER_TEAM_GASMAN] = CreateMenu("Benzina", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GASMAN], 0, "Benzinak");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GASMAN], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_DRAGSTER] = CreatePickup(1239, 1, 2620.14, 1195.76, 10.81);
	gTeamMenu[E_PLAYER_TEAM_DRAGSTER] = CreateMenu("Dragsterz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_DRAGSTER], 0, "DRaGsTeR");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_DRAGSTER], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_GARBAGE] = CreatePickup(1581, 1, 2892.8, -2127.9, 3.2);
	gTeamMenu[E_PLAYER_TEAM_GARBAGE] = CreateMenu("Garbage men", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GARBAGE], 0, "Tulak");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GARBAGE], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_PIZZABOY] = CreatePickup(1581, 1, 2101.70, -1810.05, 13.55);
	gTeamMenu[E_PLAYER_TEAM_PIZZABOY] = CreateMenu("Pizzaboyz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PIZZABOY], 0, "Pizza boy");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PIZZABOY], 1, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_HACKER] = CreatePickup(1581, 1, 2838.10, -2130.26, 0.19);
	gTeamMenu[E_PLAYER_TEAM_HACKER] = CreateMenu("Hackerz",  1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_HACKER], 0, "Hacker");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_HACKER], 1, "Opustit tym");

	//gTeamPickup[E_PLAYER_TEAM_CAR_REPAIR] = CreatePickup(1581,1, );
	gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR] = CreateMenu("Servicemen", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR], 0, "Technik");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR], 1, "Opustit tym");

	//gTeamPickup[E_PLAYER_TEAM_PYRO] = CreatePickup(1581,1, );
	gTeamMenu[E_PLAYER_TEAM_PYRO] = CreateMenu("Pyroz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PYRO], 0, "Pyrotechnik");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PYRO], 1, "Opustit tym");

#include "pickups.pwn"
#include "objects.pwn"
#include "vehicles.pwn"

	//------------------------
	if (!dini_Exists(statistika))
	{
		dini_Create(statistika);
	}
	//------------------------
	AddPlayerClass(155, 2323.74, 1283.19, 97.60, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(230, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 0, 0);
	AddPlayerClass(121, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(29, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(45, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	AddPlayerClass(169, 2323.74, 1283.19, 97.60, 0, 0, 0, 24, 300, 4, 0);
	//------------------------

	//
	// Clock initialization.
	//

	gClockText = TextDrawCreate(547.0, 24.0, "nacitani");

	TextDrawLetterSize(gClockText, 0.6, 1.8);
	TextDrawFont(gClockText, 3);
	TextDrawSetOutline(gClockText, 1);

	SetTimer("DrawClockText", 60000, 1);

	SetTimer("ShowAdvert", 1000 * 60 * 2, true);

	// Set the unique Vehlicle Plate for all vehicles possible.
	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		SetVehicleNumberPlate(i, VEHICLE_PLATE);
	}

	return 1;
}

//--------------------------[ MAIN GAMEMODE INIT ]----------------------------//

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

	return 1;
}

public OnPlayerConnect(playerid)
{
	new playerName[MAX_PLAYER_NAME];
	new stringToPrint[128];

	// Reset the auth status for a new player.
	gPlayerAuth[playerid] = false;

	// Reset the paintball states.
	gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
	gPaintball[playerid][E_PAINTBALL_SCORE] = 0;

	// Draw mapicons for the user.
#include "mapicons.pwn"

	// Show the game clock.
	TextDrawShowForPlayer(playerid, gClockText);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, GREEN, "Cus, vitej v modu CrazyRaceLife2! :) /cmd /help /rules");

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s se prave pripojil ke hre!", playerName);

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	Object_OnPlayerDisconnect(playerid, reason);

	// Hide the vehicle velocity game text.
	TextDrawHideForPlayer(playerid, KPH[playerid]);

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

	// Hide the velocite meter on death.
	TextDrawHideForPlayer(playerid, KPH[playerid]);

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
		TextDrawHideForPlayer(playerid, KPH[playerid]);
		TextDrawHideForPlayer(playerid, KPHR[playerid]);

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

public OnPlayerPrivMsg(playerid, receiverid, text[])
{
	if (GetPlayerMoney(playerid) < 10) 
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] K odeslani soukrome zpravy potrebujes alespon $10!");
		return 0;
	}

	if (!IsPlayerConnected(receiverid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Prijemce soukrome zpravy neni pritomen na serveru!");
		return 0;
	}

	new senderName[MAX_PLAYER_NAME], receiverName[MAX_PLAYER_NAME], stringForReceiver[256], stringForSender[256]; 

	// Get both counterparts' nicknames.
	GetPlayerName(playerid, senderName, sizeof(senderName)); 
	GetPlayerName(receiverid, receiverName, sizeof(receiverName)); 

	format(stringForReceiver, sizeof(stringForReceiver), "[PM] od %s (ID: %d): %s", senderName, playerid, text);
	format(stringForSender, sizeof(stringForSender), "[PM] pro %s (ID: %d): %s", receiverName, receiverid, text);

	SendClientMessage(receiverid, GREEN, stringForReceiver);
	SendClientMessage(playerid, GREEN, stringForSender);

	// Play direct message tones.
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); 
	PlayerPlaySound(receiverid, 1057, 0.0, 0.0, 0.0);

	GameTextForPlayer(playerid, "~w~PM ~r~Odeslana~w~.", 3000, 3); 
	GameTextForPlayer(receiverid, "~w~PM ~r~Prijata~w~.", 3000, 3);

	GivePlayerMoney(playerid, -10); 

	/*if (!IsPlayerAdmin(recieverid) && !IsPlayerAdmin(playerid))
	  {
	  SendMessageToAdmins(COLOR_BILA, stringForSender);
	  SendMessageToAdmins(COLOR_BILA, stringForReceiver);
	  }*/

	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	//--------------[ COMMON COMMANDS ]-------------|

	dcmd(admins, 6, cmdtext);         //all
	dcmd(afk, 3, cmdtext);            //all
	dcmd(cmd, 3, cmdtext);            //all
	dcmd(dance, 5, cmdtext);	  //all
	dcmd(djoin, 5, cmdtext);          //all
	dcmd(flip, 4, cmdtext);           //all
	dcmd(givecash, 8, cmdtext);       //all
	dcmd(help, 4, cmdtext);           //all
	dcmd(hide, 4, cmdtext); 	  //all
	dcmd(lay, 3, cmdtext);		  //all
	dcmd(locate, 6, cmdtext); 	  //all
	dcmd(lock, 4, cmdtext);           //all
	dcmd(login, 5, cmdtext);          //all
	dcmd(odpocet, 7, cmdtext);        //all
	dcmd(paintball, 9, cmdtext);	  //all
	dcmd(register, 8, cmdtext);       //all
	dcmd(skydive, 8, cmdtext);        //all
	dcmd(stav, 4, cmdtext);           //all
	dcmd(text, 4, cmdtext);           //all
	dcmd(ucet, 4, cmdtext);           //all
	dcmd(ulozit, 6, cmdtext);         //all
	dcmd(unlock, 6, cmdtext);         //all
	dcmd(vybrat, 6, cmdtext);         //all
	dcmd(wanted, 6, cmdtext);	  //all

	//--------------[ ADMIN COMMANDS ]-------------|

	dcmd(acmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(admincol, 8, cmdtext);       //rcon +
	dcmd(ban, 3, cmdtext);            //rcon + lvl 4
	dcmd(cam, 3, cmdtext);
	dcmd(ccmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(elevator, 8, cmdtext);	  //rcon + lvl 4
	dcmd(fakechat, 8, cmdtext);       //rcon + lvl 2
	dcmd(get, 3, cmdtext);            //rcon + lvl 3
	dcmd(goto, 4, cmdtext);           //rcon + lvl 3
	dcmd(kick, 4, cmdtext);           //rcon +
	dcmd(lvl, 3, cmdtext);            //rcon + lvl 4
	dcmd(nitro, 5, cmdtext);          //rcon + lvl 3
	dcmd(reset, 5, cmdtext);	  //rcon + lvl 4
	dcmd(smazat, 6, cmdtext);         //rcon +
	dcmd(zbrane, 6, cmdtext); 	  //rcon + lvl 3

	//
	//
	//

	//----------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/mp3", true) == 0)
	{
		SCM(playerid, GREEN, "[ i ] [ MP3 ] zapnuto.");
		PlayerPlaySound(playerid, 1185, 0, 0, 1);
		PlayerPlaySound(playerid, 1084, 0, 0, 0);
		SCM(playerid, GREEN, "[ i ] [ MP3 ] prehrano :).");
		return 1;
	}
	if (strcmp(cmdtext, "/mp3s", true) == 0)
	{
		SCM(playerid, COLOR_CERVENA, "[ i ] [ MP3 ] vypnuto");
		PlayerPlaySound(playerid, 1186, 0, 0, 0);
		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/rules", true) == 0)
	{
		SCM(playerid, COLOR_ORANZCERV, "[ PRAVIDLA SERVER/MODU: ]");
		SCM(playerid, COLOR_ORANZCERV, "[ JE ZAKAZANY CARKILL,HELKILL, BIKEKILL, JETPACK, CHEATY ! ]");
		SCM(playerid, COLOR_ORANZCERV, "[ NA HRACE KTERI BUDOU IGNOROVAT TYTO PRAVIDLA CEKA /KICK POZDEJI /BAN ! ]");
		SCM(playerid, COLOR_ORANZCERV, "[ V MODU JE ZABUDOVAN ANTI-JETPACK I ANTI-CHEAT !]");
		SCM(playerid, COLOR_ORANZCERV, "[ VSECHNA PRAVIDLA VYHRAZENA ! ]");
		return 1;
	}
	//----------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/kill", true) == 0)
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[256];
		GetPlayerName(playerid, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrace %s uz to nebavilo a spachal sebevrazdu (/kill)!", playerName);
		SendClientMessageToAll(COLOR_CERVENA, stringToPrint);

		SetPlayerHealth(playerid, 0);

		return 1;
	}

	//----------------------------------------
	if (strcmp(cmdtext, "/opr", true) == 0)
	{
		//if(GetPlayerVehicleID(playerid) == gAdminAuto && !IsPlayerAdmin(playerid)) return SCM(playerid, COLOR_CERVENA, "Nelze opravit");
		if (!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi v autì !");
		{
			SCM(playerid, COLOR_ZLUTA, "[ i ] Opravil sis auto");
			SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
			//RepairVehicle(GetPlayerVedicleID(playerid));
		}
		return 1;
	}
	//---------------------------------------------
	//---------------------------------------------

	//----------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/dwarp", true) == 0)
	{
		new string[256];
		new sendername[MAX_PLAYER_NAME];
		new typauta = GetPlayerVehicleID(playerid);
		new State = GetPlayerState(playerid);
		SetPlayerInterior(playerid, 0);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		format(string, sizeof(string), "Hrac %s hodil warp na drag [ /dwarp ]", sendername);
		SendClientMessageToAll(COLOR_ZLUTA, string);
		if (State != PLAYER_STATE_DRIVER)
		{
			SetPlayerPos(playerid, 2601.22, 1196.54, 10.48);
		}
		if (IsPlayerInVehicle(playerid, typauta) == 1)
		{
			SetVehiclePos(typauta, 2601.22, 1196.54, 10.48);
		}
		else
		{
			SetPlayerPos(playerid, 2601.22, 1196.54, 10.48);
		}
		return 1;
	}

	//----------------------------------------
	if (strcmp("/soska", cmdtext, true) == 0)
	{
		SendClientMessage(playerid, COLOR_SVZEL, "[ ----- SOSKY ----- ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ Sosky se nachazeji v LS a okoli ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ Sosek je zatim celkem 5 ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ ----- ODMENA ------ ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ $10 000 000 na ruku ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ Pozitivnejsi prihlizeni k ziskani admin-lvl ]");
		SendClientMessage(playerid, COLOR_SVZEL, "[ TAK HLEDEJTE! :) :D ]");

		return 1;
	}
	//----------------------------------------
	/*if (strcmp(cmdtext, "/buypapir", true) == 0)
	  {
	  if (papirek[playerid] == 0)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Koupil sis papirek 1/5");
	  papirek[playerid] = 1;
	  }
	  else
	  {
	  if (papirek[playerid] == 1)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Koupil sis papirek 2/5");
	  papirek[playerid] = 2;
	  }
	  else
	  {
	  if (papirek[playerid] == 2)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Koupil sis papirek 3/5");
	  papirek[playerid] = 3;
	  }
	  else
	  {
	  if (papirek[playerid] == 3)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Koupil sis papirek 4/5");
	  papirek[playerid] = 4;
	  }
	  else
	  {
	  if (papirek[playerid] == 4)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Koupil sis papirek 5/5");
	  papirek[playerid] = 5;
	  }
	  else
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "[ ! ]U má max 5 papírkù");
	  }
	  }
	  }
	  }
	  }
	  return 1;
	  }

	  if (strcmp(cmdtext, "/hulit", true) == 0)
	  {
	  if (joint[playerid] == 0)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nemá adného jointa /ubalit ");
	  }
	  else
	  {
	  if (joint[playerid] == 1)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Zùstal ti 0/5 jointù");
	  SetPlayerHealth(playerid, 100.0);
	  joint[playerid] = 0;
	  }
	  else
	  {
	  if (joint[playerid] == 2)
	  {
	  SendClientMessage(playerid, COLOR_LEMON, "Zùstal ti 1/5 jointù");
	  SetPlayerHealth(playerid, 100.0);
	  joint[playerid] = 1;
	  }
	  else
	  {
	  if (joint[playerid] == 3)
	{
		SendClientMessage(playerid, COLOR_LEMON, "Zùstal ti 2/5 jointù");
		SetPlayerHealth(playerid, 100.0);
		joint[playerid] = 2;
	}
	  else
	  {
		  if (joint[playerid] == 4)
		  {
			  SendClientMessage(playerid, COLOR_LEMON, "Zùstal ti 3/5 jointù");
			  SetPlayerHealth(playerid, 100.0);
			  joint[playerid] = 3;
		  }
		  else
		  {
			  if (joint[playerid] == 5)
			  {
				  SendClientMessage(playerid, COLOR_LEMON, "Zùstal ti 4/5 jointù");
				  SetPlayerHealth(playerid, 100.0);
				  joint[playerid] = 4;
			  }
		  }
	  }
}
}
}
return 1;
}

if (strcmp(cmdtext, "/ubalit", true) == 0)
{
	if (joint[playerid] == 5)
	{
		SendClientMessage(playerid, COLOR_LEMON, "[ i ]U má 5 jointu vic nemue /hulit");
	}
	else
	{
		if (zapik[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nemá zapík /zapik");
		}
		else
		{
			if (marihuana[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nemá marihuanu /otrhat");
			}
			else
			{
				if (tabak[playerid] == 0)
				{
					SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nemá tabak /tabak ");
				}
				else
				{
					if (papirek[playerid] == 0)
					{
						SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nemá Papírky /buypapir ");
					}
					else
					{
						joint[playerid] = 1;
						SendClientMessage(playerid, COLOR_LEMON, "[ i ]Ubalil sis jointa 1/5 /hulit");

						if (marihuana[playerid] == 1)
						{
							marihuana[playerid] = 0;
						}
						else
						{
							if (tabak[playerid] == 1)
							{
								tabak[playerid] = 0;
							}
							else
							{
								if (papirek[playerid] == 1)
								{
									papirek[playerid] = 0;
								}
								else
								{
									joint[playerid] = 2;
									SendClientMessage(playerid, COLOR_LEMON, "[ i ]Ubalil sis jointa 2/5 /hulit");
									if (marihuana[playerid] == 2)
									{
										marihuana[playerid] = 1;
									}
									else
									{
										if (tabak[playerid] == 2)
										{
											tabak[playerid] = 1;
										}
										else
										{
											if (papirek[playerid] == 2)
											{
												papirek[playerid] = 1;
											}
											else
											{
												joint[playerid] = 3;
												SendClientMessage(playerid, COLOR_LEMON, "[ i ]Ubalil sis jointa 3/5 /hulit");
												if (marihuana[playerid] == 3)
												{
													marihuana[playerid] = 2;
												}
												else
												{
													if (tabak[playerid] == 3)
													{
														tabak[playerid] = 2;
													}
													else
													{
														if (papirek[playerid] == 3)
														{
															papirek[playerid] = 2;
														}
														else
														{
															joint[playerid] = 4;
															SendClientMessage(playerid, COLOR_LEMON, "[ i ]Ubalil sis jointa 4/5 /hulit");
															if (marihuana[playerid] == 4)
															{
																marihuana[playerid] = 3;
															}
															else
															{
																if (tabak[playerid] == 4)
																{
																	tabak[playerid] = 3;
																}
																else
																{
																	joint[playerid] = 5;
																	SendClientMessage(playerid, COLOR_LEMON, "[ i ]Ubalil sis jointa 5/5 /hulit");
																	if (papirek[playerid] == 4)
																	{
																		papirek[playerid] = 3;
																	}
																	else
																	{
																		if (marihuana[playerid] == 5)
																		{
																			marihuana[playerid] = 4;
																		}
																		else
																		{
																			if (tabak[playerid] == 5)
																			{
																				tabak[playerid] = 4;
																			}
																			else
																			{
																				if (papirek[playerid] == 5)
																				{
																					papirek[playerid] = 4;
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

if (strcmp(cmdtext, "/zapik", true) == 0)
{
	if (zapik[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis zapik! /otrhat /hulit /buypapir /tabak /ubalit");
		zapik[playerid] = 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_LEMON, "[ ! ]U má zapik! /otrhat /hulit /buypapir /tabak /ubalit");
	}
	return 1;
}

if (strcmp(cmdtext, "/sklenik", true) == 0)
{
	SetPlayerPos(playerid, 2360.5535, 72.3878, 27.6625);
	return 1;
}

if (strcmp(cmdtext, "/otrhat", true) == 0)
{
	if (IsPlayerInSphere(playerid, 2360.5535, 72.3878, 27.6625, 101) == 0)
	{
		SendClientMessage(playerid, COLOR_LEMON, "[ ! ]Nejsi we skleníku :P");
	}
	else
	{
		if (marihuana[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_LEMON, "[ i ]Natrhal sis marihuanu 1/5 /ubalit");
			marihuana[playerid] = 1;
		}
		else
		{
			if (marihuana[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_LEMON, "[ i ]Natrhal sis marihuanu 2/5 /ubalit");
				marihuana[playerid] = 2;
			}
			else
			{
				if (marihuana[playerid] == 2)
				{
					SendClientMessage(playerid, COLOR_LEMON, "[ i ]Natrhal sis marihuanu 3/5 /ubalit");
					marihuana[playerid] = 3;
				}
				else
				{
					if (marihuana[playerid] == 3)
					{
						SendClientMessage(playerid, COLOR_LEMON, "[ i ]Natrhal sis marihuanu 4/5 /ubalit");
						marihuana[playerid] = 4;
					}
					else
					{
						if (marihuana[playerid] == 4)
						{
							SendClientMessage(playerid, COLOR_LEMON, "[ i ]Natrhal sis marihuanu 5/5 /ubalit");
							marihuana[playerid] = 5;
						}
						else
						{
							SendClientMessage(playerid, COLOR_LEMON, "[ i ]Vic Marihuany uz neuneses! /ubalit");
						}
					}
				}
			}
		}
	}
	return 1;
}

if (strcmp(cmdtext, "/tabak", true) == 0)
{
	if (tabak[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis tabak 1/5 /ubalit");
		tabak[playerid] = 1;
	}
	else
	{
		if (tabak[playerid] == 1)
		{
			SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis tabak 2/5 /ubalit");
			tabak[playerid] = 2;
		}
		else
		{
			if (tabak[playerid] == 2)
			{
				SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis tabak 3/5 /ubalit");
				tabak[playerid] = 3;
			}
			else
			{
				if (tabak[playerid] == 3)
				{
					SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis tabak 4/5 /ubalit ");
					tabak[playerid] = 4;
				}
				else
				{
					if (tabak[playerid] == 4)
					{
						SendClientMessage(playerid, COLOR_LEMON, "[ i ]Koupil sis tabak 5/5 /ubalit");
						tabak[playerid] = 5;
					}
					else
					{
						SendClientMessage(playerid, COLOR_LEMON, "[ ! ]U má 5 ks tabákù /ubalit");
					}
				}
			}
		}
	}
	return 1;
}*/

return InvalidCommand(playerid);
}

stock InvalidCommand(playerid)
{
	SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Tento prikaz neexistuje! /cmd /help");

	return 1;
}

/*public OnPlayerInfoChange(playerid)
  {
  return 1;
  }*/

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	// Hide velocity meters.
	TextDrawHideForPlayer(playerid, KPH[playerid]);
	TextDrawHideForPlayer(playerid, KPHR[playerid]);

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == 2 || newstate == 3)
	{
		//-------|
		KPH[playerid] = TextDrawCreate(256, 426, "Rychlost:");
		TextDrawAlignment(KPH[playerid], 0);
		TextDrawBackgroundColor(KPH[playerid], 0x000000ff);
		TextDrawFont(KPH[playerid], 1);
		TextDrawLetterSize(KPH[playerid], 0.7, 1.8);
		TextDrawColor(KPH[playerid], 0xff0000cc);
		TextDrawSetOutline(KPH[playerid], 1);
		TextDrawSetProportional(KPH[playerid], 1);
		TextDrawSetShadow(KPH[playerid], 1);
		//-------|
		KPHR[playerid] = TextDrawCreate(370, 426, "0");
		TextDrawAlignment(KPHR[playerid], 0);
		TextDrawBackgroundColor(KPHR[playerid], 0x000000ff);
		TextDrawFont(KPHR[playerid], 3);
		TextDrawLetterSize(KPHR[playerid], 0.7, 1.8);
		TextDrawColor(KPHR[playerid], 0x00ff00cc);
		TextDrawSetOutline(KPHR[playerid], 1);
		TextDrawSetProportional(KPHR[playerid], 1);
		TextDrawSetShadow(KPHR[playerid], 1);
		//-------|
		TextDrawShowForPlayer(playerid, KPHR[playerid]);
		TextDrawShowForPlayer(playerid, KPH[playerid]);
	}
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		if (newstate == PLAYER_STATE_ONFOOT)
		{
			TextDrawHideForPlayer(playerid, KPH[playerid]);
			TextDrawHideForPlayer(playerid, KPHR[playerid]);
		}
	}
	if (oldstate == PLAYER_STATE_PASSENGER)
	{
		if (newstate == PLAYER_STATE_ONFOOT)
		{
			TextDrawHideForPlayer(playerid, KPH[playerid]);
			TextDrawHideForPlayer(playerid, KPHR[playerid]);
		}
	}
	if (newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == gAdminAuto)
	{
		if (!IsPlayerAdmin(playerid))
		{
			SCM(playerid, COLOR_ZLUTA, "[ ! ]Jeliko nejsi admin, bude vozidlo znièeno xD.");
			GameTextForPlayer(playerid, "~r~Toto auto je jen pro ~b~rcon ~g~adminy", 5000, 5);
			SetVehicleHealth(GetPlayerVehicleID(playerid), 100.0);
		}
		else
		{
			SCM(playerid, COLOR_CYAN, "Jsi admin, auto bylo opancerovano");
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
	//
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

IsPlayerInSphere(playerid, Float:x, Float:y, Float:z, radius)
{
	if (GetPlayerDistanceToPointEx(playerid, x, y, z) < radius)
	{
		return 1;
	}
	return 0;
}

GetPlayerDistanceToPointEx(playerid, Float:x, Float:y, Float:z)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid, x1, y1, z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x, x1)), 2) + floatpower(floatabs(floatsub(y, y1)), 2) + floatpower(floatabs(floatsub(z, z1)), 2));
	return floatround(tmpdis);
}

stock bool:IsPlayerInValidNosVehicle(playerid, vehicleid)
{
#define MAX_VALID_NOS_VEHICLES 31

	new ValidNosVehicles[MAX_VALID_NOS_VEHICLES] =
	{
		581, 523, 462, 521, 463, 522, 461, 448, 468, 586,
		509, 481, 510, 472, 473, 493, 595, 484, 430, 453,
		452, 446, 454, 590, 569, 537, 538, 570, 449, 522, 520
	};

	new vehicleIdCheck = GetPlayerVehicleID(playerid);

	// Return when the target player changed vehicles meanwhile, or has exited the target vehicle.
	if (vehicleid != vehicleIdCheck || !IsPlayerInVehicle(playerid, vehicleid))
		return false;

	// Loop over permitted NoS vehicles.
	for (new i = 0; i < MAX_VALID_NOS_VEHICLES; i++)
	{
		if (GetVehicleModel(vehicleid) == ValidNosVehicles[i])
			return true;
	}

	return false;
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

GetVehicleWithinDistance(playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh)
{
	for (new i = 1; i < MAX_VEHICLES; i++)
	{
		if (GetVehicleModel(i) > 0)
		{
			if (GetPlayerVehicleID(playerid) != i)
			{
				new Float:x, Float:y, Float:z;
				new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x;
				y2 = y1 - y;
				z2 = z1 - z;
				new Float:vDist = (x2 * x2 + y2 * y2 + z2 * z2);
				if (vDist < dist)
				{
					veh = i;
					dist = vDist;
				}
			}
		}
	}
}

IsVehicleRcTram(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	switch (model)
	{
		case D_TRAM, RC_GOBLIN, RC_BARON, RC_BANDIT, RC_RAIDER, RC_TANK:
			return 1;
		default:
			return 0;
	}
	return 0;
}

public SplitIntoTwo(input[], token1[], token2[], tokenSize)
{
	new spacePos = strfind(input, " ");
	if (spacePos == -1)
	{
		strmid(token1, input, 0, strlen(input), tokenSize);
		token2[0] = '\0';
		return 1;
	}

	strmid(token1, input, 0, spacePos, tokenSize);

	strmid(token2, input, spacePos + 1, strlen(input), tokenSize);

	return 2;
}

stock TestPrint(print[])
{
#if BUG_SYSTEM
	printf(" BS | %s ", print);
#else
#pragma unused print
#endif
}

public StartServerReset()
{
	SendRconCommand("gmx");

	return 1;
}

/*
   public stavA()
   {
#define vehicleid vehicleid
new Stav[1000][2];
if(IsPlayerInAnyVehicle(playerid))
{
GetVehicleHealth(vehicleid, Stav[0]);
SCM(playerid, MODRA3, "[ i ][ VEH ]Stav Auta: %d ! ", Stav[0]);
}
return 1;
}*/

/*-----------------------------------------------------------------------------/
  /------------------------------------------------------------------------------/
  /        CRLive ** by kRySpiN[CzE * copyright kRySpiN[CzE & kompry *           /
  /------------------------------------------------------------------------------/
  /                                                                              /
  /        I thanks to http://pawno.cz , http://forum.sa-mp.com                  /
  /     Next special thanks to --" RLM]ÐR@G$TR[Cz "-- he me helped.  :)        /
  /                           Mode CRLive :) ENDS                                /
  /-----------------------------------------------------------------------------*/
