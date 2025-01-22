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

new gAdminElevator;

//
// Global static team objects.
//

new lamer;
new Menu:menulamer;
new borec;
new love;
new Menu:menuborec;
new Menu:menupolisi;
new polisilv;
new polisils;
new benzinak;
new Menu:benzinakmenu;
new dragster;
new Menu:dragstermenu;
new tulak;
new Menu:menutulak;
new pizzaboy;
new Menu:menupizza;
new technik;
new Menu:menutechnik;
new pyrotechnik;
new Menu:menupyrotechnik;
new interiertulaci;
new tulacizpatky;
new pytelpenez;
new duledvera;
new navrchuadmin;
new picktunel;
new hackeri;
new Menu:hackerimenu;

//
//
//

new marihuana[MAX_PLAYERS];
new tabak[MAX_PLAYERS];
new papirek[MAX_PLAYERS];
new zapik[MAX_PLAYERS];
new joint[MAX_PLAYERS];

//
//
//

enum ACCOUNT
{
	AFK
}

static Hrac[MAX_PLAYERS][ACCOUNT];

new AdminAuto;


/*new VehicleName[][] = {
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
*/

chrfind(n, h[], s = 0)
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
	if ((IsPlayerConnected(playerid)) && (strlen(msg) > 0))
	{
		SCM(playerid, COLOR_SVZEL, msg);
	}
	return 1;
}

//-----------------[FORWARDS NEWS ENUMS ]------------------------------------//

//-----------------------------------------------------------------------------//
// DCMD  |  DCMD  |  DCMD  |  DCMD  |  DCMD  |  DCMD  |  DCMD  |  DCMD  | DCMD //
//-----------------------------------------------------------------------------//

dcmd_lock(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		new State = GetPlayerState(playerid);
		if (State != PLAYER_STATE_DRIVER)
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ] Neøídí tedkon auto");
			return 1;
		}
		new i;
		for (i = 0; i < MAX_PLAYERS; i++)
		{
			if (i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
			}
		}
		SCM(playerid, 0xFFFF00AA, "[ i ] Vozidlo zamèeno :)");
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		PlayerPlaySound(playerid, 1056, pX, pY, pZ);
	}
	else
	{
		SCM(playerid, COLOR_CERVENA, "[ ! ] Nejsi ve aute");
	}
	return 1;//nejak takto :-)
}

dcmd_unlock(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		new State = GetPlayerState(playerid);
		if (State != PLAYER_STATE_DRIVER)
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ] Neøídí tedkon auto");
			return 1;
		}
		new i;
		for (i = 0; i < MAX_PLAYERS; i++)
		{
			if (i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
			}
		}
		SCM(playerid, 0xFFFF00AA, "[ i ] Vozidlo odemceno");
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);
		PlayerPlaySound(playerid, 1056, pX, pY, pZ);
	}
	else
	{
		SCM(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute");
	}
	return 1;
}

dcmd_register(playerid, params[])
{
	if (gPlayerAuth[playerid])
		return SystemMsg(playerid, "[SERVER] Registrace herniho uctu probehla uspesne! --> /login *heslo*");

	if (udb_Exists(PlayerName(playerid)))
		return SystemMsg(playerid, "[SERVER] Neni treba se znovu registrovat --> /login *heslo*.");

	if (strlen(params) == 0)
		return SystemMsg(playerid, "[SERVER] Registrace je povinna --> /register *heslo*");

	if (udb_Create(PlayerName(playerid), params))
		return SystemMsg(playerid, "[SERVER] Herni ucet uspesne vytvoren --> /login *heslo*.");

	return 1;
}

dcmd_login(playerid, params[])
{
	if (gPlayerAuth[playerid]) 
		return SystemMsg(playerid, "[SERVER] Uz jsi prihlasen.");

	if (!udb_Exists(PlayerName(playerid))) 
		return SystemMsg(playerid, "[SERVER] Data pro dany nickname nenalezena --> /register *heslo*");

	if (strlen(params) == 0) 
		return SystemMsg(playerid, "[SERVER] Je treba se prihlasit --> /login *heslo*");

	if (udb_CheckLogin(PlayerName(playerid), params))
	{
		LoadPlayerData(playerid);
		gPlayerAuth[playerid] = true;

		return SystemMsg(playerid, "[SERVER] Hrac prihlasen, pokracujte pomoci Spawn.");
	}

	return SystemMsg(playerid, "[SERVER] Prihlaseni se nezdarilo --> /login *heslo*");
}


dcmd_smazat(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_SEDA, "[ ! ] Nedostatecny Admin level!");

	for (new c = 0; c < 45; c++) 
		SendClientMessageToAll(COLOR_BILA, " ");

	new adminName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s promazal(a) chat.", adminName);

	SendClientMessageToAll(MODRA, stringToPrint);

	return 1;
}


dcmd_text(playerid, params[])
{
	if (!sizeof(params) || !IsNumeric(params[0]) || sizeof(params) < 2 || strlen(params[1]) == 0) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Pouziti /text [ID] [text]");

	new targetId = strval(params[0]), targetText = strval(params[1]);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Tento hrac [ID] neni na serveru.");

	new playerName[MAX_PLAYER_NAME], stringToPrint[256], targetName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	format(stringToPrint, sizeof(stringToPrint), "Hrac %s rika hraci %s, ze: %s", playerName, targetName, targetText);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

/*dcmd_/(playerid,params[])
  {
  new pos;
  new tvujtext = strval(params);
  if (!strlen(params) || !strlen(params[pos])) return SCM(playerid,  0xFF0000AA, "pouziti // [text]");
  if (!IsPlayerAdmin(playerid)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi admin ");

  new	string[256];
  format(string, 256, "[ AdminChat ]%s : %s", PlayerName(playerid), tvujtext);
  SendMessageToAdmins(COLOR_SVZEL, string);

  return 1;
  } */

//-----------------------------------------------------------------------------
/*stock SystemMsg(playerid,msg[])
  {
  if ((IsPlayerConnected(playerid))&&(strlen(msg)>0))
  {
  SCM(playerid,COLOR_SYSTEM,msg);
  }
  return 1;
  }
 */
//---------------------------------------------------
IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++) if (string[i] > '9' || string[i] < '0') return 0;
	return 1;
}
//---------------------------------------------------

stock PlayerName(playerid)
{
	new name[255];
	GetPlayerName(playerid, name, 255);
	return name;
}
//--//

dcmd_afk(playerid, params[])
{
#pragma unused params

	new str[256];
	if (Hrac[playerid][AFK] == 0)
	{
		format(str, 256, "[ i ] %s (ID: %d) na chvili odesel od PC !", PlayerName(playerid), playerid);
		SendClientMessageToAll(MODRA, str);
		TogglePlayerControllable(playerid, false);
		Hrac[playerid][AFK] = 1;
	}
	else
	{
		format(str, 256, "[ ! ] %s (ID: %d) se vratil :)", PlayerName(playerid), playerid);
		SendClientMessageToAll(COLOR_SVZEL, str);
		TogglePlayerControllable(playerid, true);
		Hrac[playerid][AFK] = 0;
	}
	return true;
}

dcmd_ulozit(playerid, params[])
{
	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ulozit [castka]");

	new amount = strval(params[0]);

	if (amount > GetPlayerMoney(playerid))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) ||
			IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) || 
			IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		gPlayerData[playerid][E_PLAYER_DATA_BANK] += amount;
		GivePlayerMoney(playerid, -amount);

		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Ulozil jsi castku: %d €! Zustatek na uctu: %d €!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);
	}

	return 1;
}

dcmd_vybrat(playerid, params[])
{
	if (!sizeof(params) || !IsNumeric(params[0]))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /vybrat [castka]");

	new amount = strval(params[0]);

	if (amount > gPlayerData[playerid][E_PLAYER_DATA_BANK])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) ||
			IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) ||
			IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		gPlayerData[playerid][E_PLAYER_DATA_BANK] -= amount;
		GivePlayerMoney(playerid, amount);

		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Vybral jsi castku: %d €! Zustatek na uctu: %d €!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);
	}

	return 1;
}

dcmd_stav(playerid, params[])
{
#pragma unused params
	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) ||
			IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) ||
			IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Bezny zustatek na bankovnim uctu: %d €!", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);
	}

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
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ NAPOVEDA/POMOC: ]");
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ Prikazy : /cmd || Pravidla /rules ]");
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ Made by krusty & kompry  ]");

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
#pragma unused params
	new countdown, stringToPrint[256];

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~text", 2000, 4);

	format(stringToPrint, sizeof(stringToPrint), "~n~~n~~n~~n~~n~~n~%d", countdown);

	GameTextForPlayer(playerid, stringToPrint, 2000, 3);

	return 1;
}

dcmd_fakechat(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!sizeof(params) || sizeof(params) < 2 || !IsNumeric(params[0]))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /fakechat [playerID] [text]");

	new targetId = strval(params[0]); //targetText[256] = params;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac se zadanym id neni pripojen.");

	SendPlayerMessageToAll(targetId, params);

	SendClientMessage(playerid, COLOR_BILA, "[ i ] Falesna zprava byla uspesne odeslana!");

	return 1;
}

dcmd_ban(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ban [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToBan = strval(params[0]), playerName[MAX_PLAYER_NAME], stringToPrint[256];

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
//----------------------------------------
dcmd_admins(playerid, params[])
#pragma unused params
{
	SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Administratori online:");

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

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /kick [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToKick = strval(params[0]), playerName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!IsPlayerConnected(playerIdToKick)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToKick, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s vyhodil(a) hrace %s ze serveru !!! ", adminName, playerName);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	Kick(playerIdToKick);

	return 1;
}
//----------------------------------------
/*dcmd_lvl(playerid, params[])
  {
  if(!IsPlayerAdmin(playerid) && lvl[playerid] < 3) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
//else if(!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /lvl [ID] [LEVEL] ! tLAMO xD";
new pos;
if(!params[0] || !(pos=chrfind(' ',params)+1) || !params[pos])
return SCM(playerid, COLOR_SEDA, "Pouití: /lvl [ID] [LEVEL]");

new lvlovany = strval(params), level = strval(params[pos]);
if(!IsPlayerConnected(lvlovany)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");
else if(level < 1 || level > 3) return SCM(playerid, COLOR_CERVENA, "[ ! ] Level pouze 1-3");

new string[150];
format(string, 150, "[ i ] Admin %s [ID:%d] dal hráèi %s[ID:%d] %d level", PlayerName(playerid), playerid,PlayerName(lvlovany),lvlovany, level);

lvl[lvlovany] = level;

return 1;
}*/
//----------------------------------------

dcmd_lvl(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!sizeof(params) || sizeof(params) < 2 || !IsNumeric(params[0]) || !IsNumeric(params[1])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /lvl [playerID] [adminLvl]");

	new targetId = strval(params[0]), targetLvl = strval(params[1]);

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
//----------------------------------------
dcmd_goto(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /goto [ID]!");

	new targetId = strval(params[0]), Float:x, Float:y, Float:z;

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

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /get [ID]!");

	new targetId = strval(params[0]), Float:x, Float:y, Float:z;

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
	if (!sizeof(params) || !IsNumeric(params[0]) || !IsNumeric(params[1]))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /givecash [ID] [castka]");

	new targetId = strval(params[0]), targetAmount = strval(params[1]);

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

	if (!sizeof(params) || !IsNumeric(params[0]))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /nitro [ID]");

	new targetId = strval(params[0]);

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

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouzití: /admincol [1-5]");

	new adminColToSet = strval(params[0]);

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
	format(lineToPrint2, sizeof(lineToPrint2), "[ INFO ] [ Penize | %d € ], [ Banka | %d € ], [ Wanted level | %d ], [ Skin | %d ], [ Tym | %d ]", GetPlayerMoney(playerid), gPlayerData[playerid][E_PLAYER_DATA_BANK], GetPlayerWantedLevel(playerid), GetPlayerSkin(playerid), gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
	format(lineToPrint3, sizeof(lineToPrint3), "[ INFO ] [ Admin level | %d ], [ Joint | %d ks ], [ Zapik | %d ks ], [ Marihuana | %d g ], [ Tabak | %d ks ]", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL], joint[playerid], zapik[playerid], marihuana[playerid], tabak[playerid]);

	SendClientMessage(playerid, COLOR_SEDA, lineToPrint1);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint2);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint3);

	return 1;
}

//----------------------------------------
dcmd_flip(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!sizeof(params) || !IsNumeric(params[0])) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /flip [ID]!");

	new targetId = strval(params[0]), Float:z;

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
//----------------------------------------

//----------------------------------------
dcmd_djoin(playerid, params[])
{
	if (!sizeof(params) || !IsNumeric(params[0]))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /djoin [ID zavodu]");

	new dragRaceId = strval(params[0]), stringToPrint[128];

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

				SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Uspesne prihlasen do daneho zavodu (prihlaska 300 €)!");
			}
		default:
			{
				format(stringToPrint, sizeof(stringToPrint), "[ i ] Drag zavod s danym ID neni pripraven!");
				return SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);
			}
	}

	return 1;
}

dcmd_cam(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_SEDA, "[ ! ] Nedostatecny Admin level!");

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

dcmd_cmd(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_SVZEL, "[ PRIKAZY: ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /cmd /rules /help /balicek /kill /afk  /lock /unlock ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /register /login /mp3 /mp3s /djoin(jeste neni hotovo) /dwarp /skydrive ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /admins /paintball /locate /wanted ]");

	return 1;
}

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
	print("    [ *** CrAzY RaCe Life *** ]     ");
	print("  [ StUnTs, RaCeS aNd DrIvIng ! ]  ");
	print(" [ Made by krusty and kompry ] ");
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
	SetTimer("OnRadarCheckpoint", 300, 1);

	SetTimer("Machine", 1000, 1);

	SetTimer("BatchSavePlayerData", 200000, 1);
	SetTimer("UpdatePlayerScore", 1000, 1);
	SetTimer("SendPlayerSalary", 300000, 1);

	//
	// Create pickups, static objects and static vehicles.
	//

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

	SetTimer("ShowAdvert", 1000 * 60 * 2, true); //1OOO milisekund * 60 = 1 minuta * 2 = 2 minuty :) xD

	//----SPZ--AUTA
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
	printf("   | Mode %s is Shuting Down |", GAMEMODE_NAME);
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
		if (udb_Exists(PlayerName(playerid)))
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

	// Show the game clock.
	TextDrawShowForPlayer(playerid, gClockText);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, GREEN, "Cus, vitej v modu CrazyRaceLife2! :) /cmd /help /rules");

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s se prave pripojil ke hre!", playerName);

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return false;
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
	new text[256];
	SendDeathMessage(killerid, playerid, reason);

	TextDrawHideForPlayer(playerid, KPH[playerid]);

	if (gPaintball[playerid][E_PAINTBALL_INGAME])
	{
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

	new killerstate = GetPlayerState(killerid); //zjisti kde sedi hrac
	if (IsPlayerInAnyVehicle(killerid) && (!IsPlayerInAnyVehicle(playerid)) && (killerstate == PLAYER_STATE_DRIVER) && (reason != WEAPON_VEHICLE))
	{
		//slozena podminka
		new wang[MAX_PLAYER_NAME], string[256]; //nadefinovani jmena a formatu zpravy
		GetPlayerName(killerid, wang, MAX_PLAYER_NAME); // zjisti vrahoho jmeno
		TextDrawHideForPlayer(playerid, KPH[playerid]);
		TextDrawHideForPlayer(playerid, KPHR[playerid]);
		format(string, sizeof(string), "[ ! ] Hráè %s poruil pravidla. [Car kill]", wang);//format zpravy
		SendClientMessageToAll(COLOR_CERVENA, string); // posle zpravu
		SpawnPlayer(killerid); //spawne hrace (vylepsena metoda zabiti)
		PlayerPlaySound(killerid, 1056, 0, 0, 0); //prehraje hraci zvuk
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
	if (text[0] == '!')
	{
		new name[24], string[256];
		GetPlayerName(playerid, name, 24);
		format(string, sizeof(string), "%s[Team Chat]: %s", name, text[1]);
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i) && gPlayerData[i][E_PLAYER_DATA_TEAM] == gPlayerData[playerid][E_PLAYER_DATA_TEAM])
				SendClientMessage(i, GetPlayerColor(playerid), string);
		}

		return 0;
	}

	return 1;
}

public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	if (GetPlayerMoney(playerid) >= 5)  // Kdyz ma hrac 5 dolaru a vic
	{
		GivePlayerMoney(playerid, -5);  // Odecte 5 dolaru hracovi
		new sendername[MAX_PLAYER_NAME], recievername[MAX_PLAYER_NAME], string[256], string2[256];  // Nadefinovany odesilatele,prijemce, a stringu pro spravy
		GetPlayerName(playerid, sendername, sizeof(sendername));  // Zjisti jmeno odesilatele zpravy
		GetPlayerName(recieverid, recievername, sizeof(recievername));  // Zjisti jmeno Prijemce zpravy
		format(string, 256, "[PM] od %s (ID: %d): %s", sendername, playerid, text);
		format(string2, 256, "[PM] pro %s (ID: %d): %s", recievername, recieverid, text);
		SendClientMessage(recieverid, GREEN, string); // Prijem zpravy
		SendClientMessage(playerid, GREEN, string2); //  Potvrzeni o odeslani zpravy
		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); // Ton pro prijemce
		PlayerPlaySound(recieverid, 1057, 0.0, 0.0, 0.0); // Ton pro odesilatele
		GameTextForPlayer(playerid, "~w~Pm ~r~Odeslana~w~.", 3000, 3); // Game Text pro odesilatele ze byla zprava dorucena
		GameTextForPlayer(recieverid, "~w~Pm ~r~Prijata~w~.", 3000, 3); // Game text pro prijemce, ze prisla nova zprava
		if (!IsPlayerAdmin(recieverid) && !IsPlayerAdmin(playerid)) // kdyz neni prijemce ani odesilatel admin
		{
			SendMessageToAdmins(COLOR_BILA, string); // posle adminovi pm
			SendMessageToAdmins(COLOR_BILA, string2);
		}
	}
	else
	{
		//Podminka jinak. (co se stane kdyz ma min jak 5 dolaru)
		SendClientMessage(playerid, COLOR_CERVENA, "K odeslání PM potøebuje 5$"); //Zprava o tom ze je chudej
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

	//---------------[  ZÁPIS DCMD   ]----------------|
	//-----------------[ PLAYER COMMANDS ]--------------|

	dcmd(afk, 3, cmdtext);            //all
	dcmd(text, 4, cmdtext);           //all
	dcmd(lock, 4, cmdtext);           //all
	dcmd(unlock, 6, cmdtext);         //all
	dcmd(login, 5, cmdtext);          //all
	dcmd(register, 8, cmdtext);       //all
	dcmd(ulozit, 6, cmdtext);         //all
	dcmd(stav, 4, cmdtext);           //all
	dcmd(vybrat, 6, cmdtext);         //all
	dcmd(cmd, 3, cmdtext);            //all
	dcmd(help, 4, cmdtext);           //all
	dcmd(djoin, 5, cmdtext);          //all
	dcmd(skydive, 8, cmdtext);       //all
	dcmd(flip, 4, cmdtext);           //all
	dcmd(odpocet, 7, cmdtext);        //all
	dcmd(admins, 6, cmdtext);         //all
	dcmd(ucet, 4, cmdtext);           //all
	dcmd(givecash, 8, cmdtext);       //all


	//---------------[ ADMIN COMMANDS ]----------------|

	dcmd(kick, 4, cmdtext);           //rcon +
	dcmd(fakechat, 8, cmdtext);       //rcon + lvl 2
	dcmd(smazat, 6, cmdtext);         //rcon +
	dcmd(admincol, 8, cmdtext);       //rcon +
	dcmd(cam, 3, cmdtext);
	dcmd(acmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(ccmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(ban, 3, cmdtext);            //rcon + lvl 4
	dcmd(goto, 4, cmdtext);           //rcon + lvl 3
	dcmd(get, 3, cmdtext);            //rcon + lvl 3
	dcmd(lvl, 3, cmdtext);            //rcon + lvl 4
	dcmd(nitro, 5, cmdtext);          //rcon + lvl 3

	//---------------[  ZÁPIS DCMD   ]----------------|
	//-----------------------------[ ANIMACE ]--------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/dance", true) == 0)
	{
		SCM(playerid, COLOR_CERVENA, "[ ! ] Pouití: /dance [1-4]");
		return 1;
	}
	//----------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/dance 1", true) == 0) //%)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nemoze být v autì.");
			return 1;
		}
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/dance 2", true) == 0)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nemoze být v autì.");
			return 1;
		}
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/dance 3", true) == 0)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nemoze být v autì.");
		}
		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/dance 4", true) == 0)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nemoze být v autì.");
			return 1;
		}
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/lay", true) == 0)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 0, 1, 1, 1, 1);
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nemoze být v autì.");
		}
		return 1;
	}
	//----------------------------------------

	//----------------------------------------
	//-----------------------------[ ANIMACE ]--------------------------------------
	//----------------------------------------
	if (strcmp(cmdtext, "/vup", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

		new name[30];
		new string[68];
		MoveObject(gAdminElevator, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "[ AV ]Admin %s rozjel gAdminElevator", name);
		SendClientMessageToAll(COLOR_ZLUTA, string);

		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/vstop", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

		new string[100];
		StopObject(gAdminElevator);
		format(string, sizeof(string), "[ ! ]Výtah se zasekl ! Kontaktujte technika ! ");
		SendClientMessageToAll(COLOR_CERVENA, string);

		return 1;
	}

	//----------------------------------------
	if (strcmp(cmdtext, "/vdown", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

		new name[30];
		new string[68];
		MoveObject(gAdminElevator, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "[ AV ]Admin %s poslal výtah dolù ", name);
		SendClientMessageToAll(COLOR_ZLUTA, string);

		return 1;
	}
	//----------------------------------------
	/*if (strcmp("/reset", cmdtext, true) == 0)
	  {
	  if (IsPlayerAdmin(playerid) && lvl[playerid] < 4) return SCM(playerid, COLOR_SEDA, "] ! ] Nedostateèný Admin-level");
	  {
	  if (lvl[playerid] == 1)
	  {
	  new string[100];
	  format(string, 256, "[ ! ][ SERVER ][ ! ]OPUSTE SERVER ZA 10 SEKUND RESTART SERVERU[ ! ]");
	  SendClientMessageToAll(COLOR_CERVENA, string);
	  SetTimer("RESET", 10000, true);
	  }
	  }
	  return 1;
	  }*/
	//----------------------------------------
	if (strcmp("/paintball", cmdtext, true, 10) == 0)
	{
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (IsPlayerConnected(i))
			{
				SendClientMessage(i, COLOR_ZLUTA, "Paintball zaène za 10 sekund vyberte si své zaèáteèní pozice.");
				SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
				SetTimer("StartPaintball", 10000, 0);

				gPaintball[i][E_PAINTBALL_INGAME] = 1;
			}
		}
		return 1;
	}
	//----------------------------------------
	if (strcmp("/paintexit", cmdtext, true, 10) == 0)
	{
		new string[256];
		if (gPaintball[playerid][E_PAINTBALL_INGAME])
		{
			format(string, 256, "[ ! ] %s opousti paintball, /paintexit", playerid);
			SendClientMessageToAll(COLOR_ZLUTA, string);
			SetPlayerHealth(playerid, 0.0);

			gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
		}
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/locate", true) == 0)
	{
		new formatovany_text[256], Int = GetPlayerInterior(playerid), Float:X, Float:Y, Float:Z, Float:Uhel;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Uhel);
		format(formatovany_text, 256, "[ i ] Nacházíte se v interiéru %d na souøadnicích X[%.1f], Y[%.1f], Z[%.1f], Rotace[%.1f].", Int, X, Y, Z, Uhel);
		SCM(playerid, MODRA, formatovany_text);
		return true;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/wanted", true) == 0)
	{
		if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] == E_PLAYER_TEAM_POLICE || IsPlayerAdmin(playerid) || gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] > 1)
		{
			new string[256];
			for (new i = 0; i <= GetMaxPlayers(); i++)
			{
				if (GetPlayerWantedLevel(i) > 0)
				{
					format(string, sizeof(string), "%s [ WANTED ] - %d", PlayerName(i), GetPlayerWantedLevel(i));
					SendClientMessage(playerid, COLOR_BILA, string);
				}
			}
		}
		else
		{
			SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi polis");
		}
		return 1;
	}
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
		new formatovany_text[256];
		format(formatovany_text, sizeof(formatovany_text), "[ i ] Hráèe %s u to nebavilo a spáchal sebevradu!", PlayerName(playerid));
		SendClientMessageToAll(COLOR_CERVENA, formatovany_text);
		SetPlayerHealth(playerid, 0);
		return 1;
	}

	//----------------------------------------
	if (strcmp(cmdtext, "/opr", true) == 0)
	{
		//if(GetPlayerVehicleID(playerid) == AdminAuto && !IsPlayerAdmin(playerid)) return SCM(playerid, COLOR_CERVENA, "Nelze opravit");
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
	if (strcmp(cmdtext, "/hp", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostateèný Admin level!");

			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 100.0);

			SendClientMessage(playerid, COLOR_SEDA, "[ ! ] Zdravi: 100.0, Vesta: 100.0");

		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/port", true) == 0)
	{
		if (!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
			SCM(playerid, COLOR_ZLUTA, "[ i ] Portl ses pøed schody v LV.");
		}
		else
		{
			SCM(playerid, COLOR_ZLUTA, "[ ! ] Nesmis byt v aute.");
		}
		return 1;
	}

	//----------------------------------------
	if (strcmp(cmdtext, "/hide", true) == 0)
	{
		if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_ADMINZ) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v tymu Adminz!");

		SetPlayerColor(playerid, COLOR_NEVIDITEL);
		SendClientMessage(playerid, COLOR_ZLUTA, "[ HIDE ] Nyni nejsi videt na mape!");

		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/unhide", true) == 0)
	{
		if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_ADMINZ) 
			return SCM(playerid, COLOR_CERVENA, "[ ! ] Nejsi v tymu Adminz!");

		SetPlayerColor(playerid, COLOR_SVZEL);
		SendClientMessage(playerid, COLOR_ZLUTA, "[ HIDE ] Jsi opet videt na mape!");

		return 1;
	}
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
		SCM(playerid, COLOR_SVZEL, "[ ----- SOKY ----- ]");
		SCM(playerid, COLOR_SVZEL, "[ Soky se nacházejí v a v okolí LS ]");
		SCM(playerid, COLOR_SVZEL, "[ Soek je zatim celkem 5 ]");
		SCM(playerid, COLOR_SVZEL, "[ ----- ODMÌNA ------ ]");
		SCM(playerid, COLOR_SVZEL, "[ 10 000 000 na ruku ]");
		SCM(playerid, COLOR_SVZEL, "[ Pozitivnìjí pøihlíení k dostání admin-lvl ]");
		SCM(playerid, COLOR_SVZEL, "[ TAK HLEDEJTE :) :P:D ]");
		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/buypapir", true) == 0)
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
	}
	//----------------------------------------
	if (strcmp("/balicek", cmdtext, true) == 0)
	{
		GivePlayerWeapon(playerid, 32, 20);

		GivePlayerWeapon(playerid, 46, 1);
		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/vybava", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
			return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostateèný Admin level!");

			GivePlayerWeapon(playerid, 28, 400);
			GivePlayerWeapon(playerid, 26, 400);
			GivePlayerWeapon(playerid, 31, 400);
			GivePlayerWeapon(playerid, 46, 1);
			GivePlayerWeapon(playerid, 43, 1);

		return 1;
	}

	return InvalidCommand(playerid);
}

InvalidCommand(playerid)
{
	SendClientMessage(playerid, COLOR_ZELENA, "[ SERVER ] Tento pøíkaz neexistuje! /cmd /help");
	return 1;
}

public OnPlayerInfoChange(playerid)
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
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
	if (newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == AdminAuto)
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
	if (pickupid == lamer)
	{
		ShowMenuForPlayer(menulamer, playerid);
	}
	else if (pickupid == borec)
	{
		ShowMenuForPlayer(menuborec, playerid);
	}
	else if (pickupid == love)
	{
		SetPlayerHealth(hrac, 100.0);
	}
	else if (pickupid == polisils)
	{
		ShowMenuForPlayer(menupolisi, playerid);
	}
	else if (pickupid == polisilv)
	{
		ShowMenuForPlayer(menupolisi, playerid);
	}
	else if (pickupid == benzinak)
	{
		ShowMenuForPlayer(benzinakmenu, playerid);
	}
	else if (pickupid == dragster)
	{
		ShowMenuForPlayer(dragstermenu, playerid);
	}
	else if (pickupid == tulak)
	{
		ShowMenuForPlayer(menutulak, playerid);
	}
	else if (pickupid == pizzaboy)
	{
		ShowMenuForPlayer(menupizza, playerid);
	}
	else if (pickupid == interiertulaci)
	{
		SetPlayerPos(playerid, 2845.28, -2125.33, 0.19);
	}
	else if (pickupid == tulacizpatky)
	{
		SetPlayerPos(playerid, 2881.27, -2123.99, 4.32);
	}
	else if (pickupid == pytelpenez)
	{
		GivePlayerMoney(playerid, 10000);
		DestroyPickup(pytelpenez);
	}
	else if (pickupid == duledvera)
	{
		SetPlayerPos(playerid, 1007.98, -1164.11, 50.95);
	}
	else if (pickupid == navrchuadmin)
	{
		SetPlayerPos(playerid, 981.84, -1158.15, 23.86);
	}
	else if (pickupid == hackeri)
	{
		ShowMenuForPlayer(hackerimenu, playerid);
	}
	else if (pickupid == technik)
	{
		ShowMenuForPlayer(menutechnik, playerid);
	}
	else if (pickupid == pyrotechnik)
	{
		ShowMenuForPlayer(menupyrotechnik, playerid);
	}

	//---------------------
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new string[256];
	new Menu:Current = GetPlayerMenu(playerid);
	if (Current == menulamer)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k LAMAM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 5, 1); //PRIDA HRACOVI ZBRAN ID,NABOJU
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //
					ResetPlayerWeapons(playerid); //restartuj hracovi zbrane-MUETE VYMAZAT
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_LAME; //promenna na povolani cislo 1
					SetPlayerSkin(playerid, 200); // hracUV skin
					SetPlayerColor(playerid, COLOR_ZLUTA); //hracovo barva
									       //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//----------------------------------
	if (Current == menuborec)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k BORCÙM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 32, 1000); //PRIDA HRACOVI ZBRAN ID,NABOJU
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					SetPlayerSkin(playerid, 29);
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_ADMINZ; //promenna na povolani cislo 2
					SetPlayerColor(playerid, COLOR_SVZEL); //hracovo barva
									       //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
	if (Current == menupolisi)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k POLISUM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 32, 111); //PRIDA HRACOVI ZBRAN ID,NABOJU
					GivePlayerWeapon(playerid, 31, 100);
					GivePlayerWeapon(playerid, 30, 100);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					SetPlayerSkin(playerid, 285);
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_POLICE; //promenna na povolani cislo 3
					SetPlayerColor(playerid, MODRA); //hracovo barva
				}
		}
	}
	//---------------------------------

	if (Current == benzinakmenu)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k BENZINAKÙM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 32, 1); //PRIDA HRACOVI ZBRAN ID,NABOJU
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_GASMAN; //promenna na povolani cislo 4
					SetPlayerColor(playerid, COLOR_CERVENA); //hracovo barva
					SetPlayerSkin(playerid, 50);
					//SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}

	//---------------------------------
	if (Current == dragstermenu)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k týmu DRaGsTeRù !!", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 31, 1000);
					GivePlayerWeapon(playerid, 30, 100);
					GivePlayerWeapon(playerid, 5, 1);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //tisk
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_DRAGSTER; //promenna na povolani cislo 5
					SetPlayerSkin(playerid, 107);
					SetPlayerColor(playerid, COLOR_ORANZOVA);
				}
		}
	}
	//---------------------------------
	if (Current == menutulak)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k TULAKOM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 32, 1); //PRIDA HRACOVI ZBRAN ID,NABOJU
					GivePlayerWeapon(playerid, 4, 1);
					SetPlayerSkin(playerid, 230) || SetPlayerSkin(playerid, 137);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_GARBAGE; //promenna na povolani cislo 6
					SetPlayerColor(playerid, COLOR_SVZEL); //hracovo barva
									       //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
	if (Current == menupizza)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k PIZZABOYs", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 24, 111); //PRIDA HRACOVI ZBRAN ID,NABOJU
					GivePlayerWeapon(playerid, 4, 1);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					SetPlayerSkin(playerid, 250);
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_PIZZABOY; //promenna na povolani cislo 7
					SetPlayerColor(playerid, COLOR_ZELZLUT); //hracovo barva
										 //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
	if (Current == hackerimenu)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k HACKRÙM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 4, 100);
					GivePlayerWeapon(playerid, 24, 200);
					SetPlayerSkin(playerid, 170);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_HACKER; //promenna na povolani cislo 8
					SetPlayerColor(playerid, COLOR_BILA); //hracovo barva
									      //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
	if (Current == menutechnik)
	{
		switch (row)
		{
			case 0:
				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k TECHNIKOM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 4, 100);
					GivePlayerWeapon(playerid, 24, 200);
					SetPlayerSkin(playerid, 50);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_CAR_REPAIR; //promenna na povolani cislo 9
					SetPlayerColor(playerid, COLOR_SEDA); //hracovo barva
									      //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
	if (Current == menupyrotechnik)
	{
		switch (row)
		{
			case 0:

				{
					new pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format(string, sizeof(string), "[!] Hrac %s se pripojil k PYROTECHNIKOM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 4, 100);
					GivePlayerWeapon(playerid, 24, 200);
					SetPlayerSkin(playerid, 230);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					gPlayerData[playerid][E_PLAYER_DATA_TEAM] = E_PLAYER_TEAM_PYRO; //promenna na povolani cislo 10
					SetPlayerColor(playerid, COLOR_SEDA); //hracovo barva
									      //SetPlayerPos(playerid,,-2024.5919,145.2734,28.8359); //(,-2024.5919,145.2734,28.8359) teleportuje pri prihlaseni zamestnani
				}
		}
	}
	//---------------------------------
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

stock TestPrint(print[])
{
#if BUG_SYSTEM
	printf(" BS | %s ", print);
#else
#pragma unused print
#endif
}

/*public RESET()
  {
  SendRconCommand("gmx");
  return 1;
  }*/

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
