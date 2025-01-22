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

  [ Povolani ] [ iPlayerRole ]

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

//---------------------[ INCLUDY DEFINICE PARAGMY ]---------------------------//

forward ShowAdvert();

forward StartPaintball();
forward GetPaintballScoreboard();
forward EndPaintball();

forward DrawClockText();

//
//
//

forward AntiJetPack();
forward Weapon_Anti_Cheat();

forward Machine();
forward radarCH();
forward radarEX(playerid);
forward ulozeni(playerid);
forward ScoreUpdate();
forward drag();
forward Vyplata(playerid);

forward RESET();

//
//
//

new const GAMEMODE_NAME[] = "CrazyRaceLife2";
new const VEHICLE_PLATE[] = "-CRL2-";

// The very game clock's text.
new Text:gClockText;

//
//
//

enum SPS
{
      Float:X_r,
      Float:Y_r,
      Float:Z_r
}


new PlayerPos[200][SPS];
new Text:KPH[MAX_PLAYERS];
new Text:KPHR[MAX_PLAYERS];
new Radarovany[MAX_PLAYERS];
new bank[MAX_PLAYERS];
new dlistek[MAX_PLAYERS];
new lvl[MAX_PLAYERS];
new iPlayerRole[MAX_PLAYERS];
new vytah;
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

new marihuana[MAX_PLAYERS];
new tabak[MAX_PLAYERS];
new papirek[MAX_PLAYERS];
new zapik[MAX_PLAYERS];
new joint[MAX_PLAYERS];

//
// Paintball
//

enum E_PAINTBALL
{
	E_PAINTBALL_INGAME,
	E_PAINTBALL_SCORE
}

new gPaintball[MAX_PLAYERS][E_PAINTBALL];

#include "paintball.pwn"

//
//
//

enum ACCOUNT
{
	AFK
}

static Hrac[MAX_PLAYERS][ACCOUNT];

//----------------------------------------------------|
new AdminAuto;
//new gPlayerAuth[MAX_PLAYERS];

new gPlayerAuth[MAX_PLAYERS];

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
		return SystemMsg(playerid, "[SERVER] REGISTRACE OK - /login *heslo*");
	if (udb_Exists(PlayerName(playerid)))
		return SystemMsg(playerid, "[SERVER] ÚÈET U TADY MÁ - POUIJ /login *heslo*.");
	if (strlen(params) == 0)
		return SystemMsg(playerid, "[SERVER] REGISTRUJ SE /register *heslo*");
	if (udb_Create(PlayerName(playerid), params))
		return SystemMsg(playerid, "[SERVER] ÚÈET VYTVOØEN - /login *heslo*.");
	return true;

}

dcmd_login(playerid, params[])
{
	if (gPlayerAuth[playerid]) return SystemMsg(playerid, "[SERVER] U jsi pøihláen.");

	if (!udb_Exists(PlayerName(playerid))) return SystemMsg(playerid, "[SERVER] ÚÈET NEEXISTUJE POUZIJ /register *heslo*");

	if (strlen(params) == 0) return SystemMsg(playerid, "[SERVER] POUIJTE /login *heslo*");

	if (udb_CheckLogin(PlayerName(playerid), params))
	{

		GivePlayerMoney(playerid, dUserINT(PlayerName(playerid)).("money") - GetPlayerMoney(playerid)); //[SERVER] U jsi pøihláen
		lvl[playerid] = dUserINT(PlayerName(playerid)).("adminlvl");
		iPlayerRole[playerid] = dUserINT(PlayerName(playerid)).("tym");
		joint[playerid] = dUserINT(PlayerName(playerid)).("joint");
		zapik[playerid] = dUserINT(PlayerName(playerid)).("zapik");
		SetPlayerColor(playerid, bezova);
		//SetPlayerSkin(playerid) = dUserINT(PlayerName(playerid)).("skin");
		gPlayerAuth[playerid] = true;

		return SystemMsg(playerid, "[SERVER] PØIHLÁENO - NAÈTENY PRACHY A SKIN.");
	}
	return SystemMsg(playerid, "[SERVER] PØIHLÁENÍ NEÚSPÌNÉ - OPAKUJTE /login *heslo*");
}


dcmd_smazat(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");

	for (new c = 0; c < 45; c++) SendClientMessageToAll(COLOR_BILA, " ");
	new string[200];
	if (IsPlayerAdmin(hrac))
		format(string, sizeof(string), "[ i ] Admin %s promazal chat.", PlayerName(playerid));
	SendClientMessageToAll(MODRA, string);
	return 1;
}


dcmd_text(playerid, params[])
{
	new pos;
	new zadane_id = strval(params), tvujtext = strval(params[pos]);
	if (!strlen(params) || !IsNumeric(params) || !strlen(params[pos])) return SCM(playerid,  0xFF0000AA, "pouziti /text id [text]");
	if (!IsPlayerConnected(zadane_id)) return SCM(playerid,  0xFF0000AA, "Tento hrac [ID] neni na serveru.");

	new	string[256];
	format(string, 256, "%s rika hraci %s, ze: %s", PlayerName(playerid), PlayerName(zadane_id), tvujtext);
	SendClientMessageToAll(0xFF0000AA, string);

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
	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) == 1)
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /ulozit [Èástka]");
		new castka2 = strval(params);
		if (castka2 > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= GetPlayerMoney(playerid))
		{
			bank[playerid] += castka2;
			GivePlayerMoney(playerid, -castka2);
			new string[256];
			format(string, sizeof(string), "Uloil jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	else if (IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) == 1)
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /ulozit [Èástka]");
		new castka2 = strval(params);
		if (castka2 > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= GetPlayerMoney(playerid))
		{
			bank[playerid] += castka2;
			GivePlayerMoney(playerid, -castka2);
			new string[256];
			format(string, sizeof(string), "Uloil jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	if (IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15) == 1)
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /ulozit [Èástka]");
		new castka2 = strval(params);
		if (castka2 > GetPlayerMoney(playerid)) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= GetPlayerMoney(playerid))
		{
			bank[playerid] += castka2;
			GivePlayerMoney(playerid, -castka2);
			new string[256];
			format(string, sizeof(string), "Uloil jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	return 1;
}

dcmd_vybrat(playerid, params[])
{
	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) == 1) //PREPSAT --------------------------------------------------
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /vybrat [Èástka]");
		new castka2 = strval(params);
		if (castka2 > bank[playerid]) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= bank[playerid])
		{
			bank[playerid] -= castka2;
			GivePlayerMoney(playerid, castka2);
			new string[256];
			format(string, sizeof(string), "Vybral jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	if (IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) == 1)
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /vybrat [Èástka]");
		new castka2 = strval(params);
		if (castka2 > bank[playerid]) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= bank[playerid])
		{
			bank[playerid] -= castka2;
			GivePlayerMoney(playerid, castka2);
			new string[256];
			format(string, sizeof(string), "Vybral jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	if (IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15) == 1)
	{
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ZLUTA, "[NAPI]: /vybrat [Èástka]");
		new castka2 = strval(params);
		if (castka2 > bank[playerid]) return SendClientMessage(playerid, COLOR_CERVENA, "patná èástka!");
		if (castka2 <= bank[playerid])
		{
			bank[playerid] -= castka2;
			GivePlayerMoney(playerid, castka2);
			new string[256];
			format(string, sizeof(string), "Vybral jsi: %d, zùstatek na úètu: %d.", castka2, bank[playerid]);
			SendClientMessage(playerid, COLOR_ZLUTA, string);
		}
	}
	return 1;
}

dcmd_stav(playerid, params[])
{
#pragma unused params
	if (IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) == 1)
	{
		new string[256];
		format(string, sizeof(string), "Zùstatek na vaem úètu èiní: %d.", bank[playerid]);
		SendClientMessage(playerid, COLOR_ZLUTA, string);
	}
	else if (IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) == 1)
	{
		new string[256];
		format(string, sizeof(string), "Zùstatek na vaem úètu èiní: %d.", bank[playerid]);
		SendClientMessage(playerid, COLOR_ZLUTA, string);
	}
	else if (IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15) == 1)
	{
		new string[256];
		format(string, sizeof(string), "Zùstatek na vaem úètu èiní: %d.", bank[playerid]);
		SendClientMessage(playerid, COLOR_ZLUTA, string);
	}
	return 1;
}
//----------------------------------------
dcmd_ccmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	{
		SCM(playerid, COLOR_ZELZLUT, "[ i ][CAM] KAMERY: /cam1 (pyramida dole), /cam2 (banka atd) /camoff");
	}
	return 1;
}
//----------------------------------------

dcmd_acmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	{
		SCM(playerid, COLOR_ZELZLUT, "[ i ] /smazat /prachy /ccmd /acmd /vup /vdown /kick /ban /lvl /hp ");
		SCM(playerid, COLOR_ZELZLUT, "[ i ] /fakechat /admincol /get /goto ");
	}
	return 1;
}
//----------------------------------------
dcmd_help(playerid, params[])
{
#pragma unused params
	SCM(playerid, COLOR_ORANZCERV, "[ NAPOVEDA/POMOC: ]"); //napisou se nasledujici zpravy(jen pro nej)
	SCM(playerid, COLOR_ORANZCERV, "[ Prikazy : /cmd || Pravidla /rules ]");
	SCM(playerid, COLOR_ORANZCERV, "[ Made by kRySpiN[CzE & kompry  ]");
	return 1;
}
//----------------------------------------
//----------------------------------------
dcmd_skydrive(playerid, params[])
{
#pragma unused params
	GivePlayerWeapon(playerid, 46, 1);
	SetPlayerPos(playerid, 2247.61, 1260.14, 1313.40);
	SCM(playerid, MODRA, "[ i ]Uaaaaaaaaah xD.. uij si skok xD");
	return 1;
}
//----------------------------------------
dcmd_odpocet(playerid, params[])
{
#pragma unused params
	new string[256], odpocet ;

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~text", 2000, 4);
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~%d", odpocet);
	GameTextForPlayer(playerid, string, 2000, 3);
	return 1;
}
//----------------------------------------t
dcmd_fakechat(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 4) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	new tmp[256], tmp2[256], Index;
	tmp = strtok(params, Index), tmp2 = strtok(params, Index);
	if (!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, COLOR_CERVENA, "Pouziti: /fakechat [playerid] [text]");

	new hracc = strval(tmp);
	if (IsPlayerConnected(hracc)) return	SendClientMessage(playerid, COLOR_CERVENA, "Hrac se zadanym id neni pripojen.");
	{
		SendPlayerMessageToAll(hracc, params[strlen(tmp) + 1]);
		SendClientMessage(playerid, COLOR_BILA, "Falesna zprava byla uspesne odeslana");
	}
	return 1;
}
//----------------------------------------
dcmd_ban(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 4) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /ban [ID]");
	new banovany = strval(params), Text[256];
	if (!IsPlayerConnected(banovany)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");
	format(Text, 256, "[ i ] Admin %s [ID: %d] zabanoval %s[ID: %d] !!! ", PlayerName(playerid), playerid, PlayerName(banovany), banovany);
	SendClientMessageToAll(MODRA, Text);
	Ban(banovany);
	return 1;
}
//----------------------------------------
dcmd_admins(playerid, params[])
#pragma unused params
{
	new Kdopak = 0;
	new i;
	new string[180];

	for (i = 0; i < GetMaxPlayers(); i++) if (IsPlayerConnected(i)) if (lvl[i] > 0 || IsPlayerAdmin(i)) Kdopak++;
	SCM(playerid, COLOR_SVZEL, "[ ! ]Administrátoøi on-line :");
	if (Kdopak == 0) return SendClientMessage(playerid, COLOR_CERVENA, "[ i ]Na serveru není ádný Admin ");
	else
	{
		for (i = 0; i < GetMaxPlayers(); i++)
		{
			if (!IsPlayerConnected(i)) continue;

			if (lvl[i] > 0 && !IsPlayerAdmin(i))      format(string, 180, "[ %s [ ID: %d ] LVL: [ %d ]", PlayerName(i), i, lvl[i]);
			else if (lvl[i] == 0 && IsPlayerAdmin(i)) format(string, 180, "[ %s [ ID: %d ] [ RCON ]]", PlayerName(i), i);
			else if (lvl[i] > 0 && IsPlayerAdmin(i))  format(string, 180, "[ %s [ ID: %d ] LVL [ %d ] + [ RCON ]]", PlayerName(i), i, lvl[i]);
			SendClientMessage(playerid, COLOR_ZELZLUT, string);
		}
	}
	return 1;
}

//----------------------------------------
dcmd_kick(playerid, params[])
{
	printf("BS || /kick");
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 3) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /kick [ID]");
	new kickly = strval(params), Text[256];
	if (!IsPlayerConnected(kickly)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");

	format(Text, 256, "[ i ] Admin %s vyhodil %s !!! ", PlayerName(playerid), PlayerName(kickly));
	SendClientMessageToAll(COLOR_CERVENA, Text);
	Kick(kickly);
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
	TestPrint("dcmd_lvl(playerid, params[])");

	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 4) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	new ZadaneID = strval(params), pozice = chrfind(' ', params);
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ ID ] není pøítomen na serveru");

	else if (lvl[ZadaneID] == 4) return SCM(playerid, COLOR_CERVENA, "[ ! ] Nemùe mìnit level adminùm 4+.");
	else if (!params[0]nebo!(pozice = chrfind(' ', params) + 1)nebo!params[pozice]) return SCM(playerid, COLOR_SEDA, "[ ! ] Pouití: /lvl [ ID ] [ LEVEL ]");
	new nastaveny_level = strval(params[pozice]);
	if (ZadaneID == playerid) return SCM(playerid, COLOR_CERVENA, "[ ! ] Nemùe mìnit level sám sobì!");
	else if (nastaveny_level > 4 nebo nastaveny_level < 0) return SCM(playerid, COLOR_SEDA, "[ ! ] LvLy Pouze 0-4.");
	else if (nastaveny_level == lvl[ZadaneID]) return SCM(playerid, COLOR_CERVENA, "[ ! ] Tento hráè ji tento lvl má, zadaj jiný");
	new Text[256];

	format(Text, 256, "[ i ] Admin %s nastavil hráèi %s [ ID: %d ] Admin-Level [ %d ][ i ]", PlayerName(playerid), PlayerName(ZadaneID), ZadaneID, nastaveny_level);
	SendClientMessageToAll(COLOR_SEDA, Text);

	lvl[ZadaneID] = nastaveny_level;
	dUserSetINT(PlayerName(ZadaneID)).("adminlvl", lvl[ZadaneID]);

	return true;
}
//----------------------------------------
dcmd_goto(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /goto [ID]! ");
	new ZadaneID = strval(params), Float:a, Float:b, Float:c;
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");
	else if (ZadaneID == playerid) return SCM(playerid, COLOR_CERVENA, "[ ! ]Neni ti divne teleportovat sám sebe? :D");

	GetPlayerPos(ZadaneID, a, b, c);
	new typauta = GetPlayerVehicleID(playerid);
	new State = GetPlayerState(playerid);
	SetPlayerInterior(playerid, 0);

	if (State != PLAYER_STATE_DRIVER)
	{
		SetPlayerPos(playerid, a, b, c);
	}
	if (IsPlayerInVehicle(playerid, typauta) == 1)
	{
		SetVehiclePos(typauta, a, b, c);
	}
	else
	{
		SetPlayerPos(playerid, a, b, c);
	}

	return 1;
}
//----------------------------------------
dcmd_givecash(playerid, params[])
{
	new ZadaneID = strval(params), pozice = chrfind(' ', params), poslane_penize = strval(params[pozice]), Text[256];
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ ID ] není pøítomen na serveru");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /givecash [ID] [CASTKA] !");
	if (GetPlayerMoney(playerid) <= poslane_penize) return SCM(playerid, COLOR_CERVENA, "[ ! ]Nemá dost penìz na poslání");
	{
		GivePlayerMoney(playerid, -poslane_penize);

		format(Text, 256, "[ i ] Hráè %s [ID: %d] ti poslal %d  !", PlayerName(playerid), ZadaneID, poslane_penize);
		SendClientMessageToAll(COLOR_SEDA, Text);

		GivePlayerMoney(ZadaneID, poslane_penize);
	}
	return 1;
}
//----------------------------------------
dcmd_nitro(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 3) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, COLOR_SEDA, "[ i ]Pouití /nitro [ID]!");
	new ZadaneID = strval(params), State = GetPlayerState(ZadaneID),  vehicleid = GetPlayerVehicleID(ZadaneID);
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");

	else if (IsPlayerInAnyVehicle(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ] Zadane ID se nenachazi v autì ! ");
	if (!IsPlayerInAnyVehicle(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ] Zadane ID neni v autì !");
	else if (State != PLAYER_STATE_DRIVER) return SCM(playerid, COLOR_CERVENA, "[ ! ]Zadané ID musí øídit auto");

	if (!IsPlayerInInvalidNosVehicle(playerid, GetPlayerVehicleID(playerid))) return SCM(playerid, COLOR_CERVENA, "[ ! ]Do auta Zadaneho ID nejde nainstalovat nitro ! :P");
	{
		AddVehicleComponent(vehicleid, 1010);
		SCM(playerid, COLOR_SEDA, "[ i ] Nitro nainstalováno do auta Zadaného ID !");
		SCM(ZadaneID, COLOR_SEDA, "[ i ] Admin %s ti nainstaloval do auta nitro !", PlayerName(playerid));
	}
	return 1;
}
//----------------------------------------
dcmd_admincol(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, COLOR_CERVENA, "[ ! ] Pouzití: /admincol [1-5]");
	new barva = strval(params);

	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");

	if (barva < 1 || barva > 5) return SCM(playerid, COLOR_CERVENA, "[ ! ]Barvy pouze 1-5");
	switch (barva)
	{
		case 1:
			{
				SetPlayerColor(playerid, COLOR_SVZEL);
				SCM(playerid, COLOR_SVZEL, "[ i ] Barva nicku Svìtle zelená");
			}
		case 2:
			{
				SetPlayerColor(playerid, MODRA);
				SCM(playerid, MODRA, "[ i ] Barva nicku Modrá");
			}
		case 3:
			{
				SetPlayerColor(playerid, COLOR_CERVENA);
				SCM(playerid, COLOR_CERVENA, "[ i ] Barva nicku Èervená");
			}
		case 4:
			{
				SetPlayerColor(playerid, COLOR_ORANZOVA);
				SCM(playerid, COLOR_ORANZOVA, "[ i ] Barva nicku Ozanová");
			}
		case 5:
			{
				SetPlayerColor(playerid, COLOR_BILA);
				SCM(playerid, COLOR_BILA, "[ i ] Barva nicku Bílá");
			}
	}
	return 1;
}
//----------------------------------------
dcmd_ucet(playerid, params[])
{
#pragma unused params
	new string[256], string2[256], string3[265];
	format(string,  sizeof(string), "[ INFO ] [ VYPIS HERNIHO UCTU ] ***");
	format(string2, sizeof(string2), "[ INFO ] [ Penize | %d ], [ Banka | %d ], [ WL | %d, ], [ Skin | %d ], [ Tym | %d ]", GetPlayerMoney(playerid), bank[playerid], GetPlayerWantedLevel(playerid), GetPlayerSkin(playerid), iPlayerRole[playerid]);
	format(string3, sizeof(string3), "[ INFO ] [ AdminLVL | %d ], [ Joint | %dks ], [ Zapik | %d ], [ Marihuana | %dg ], [ Tabak | %dks ]", lvl[playerid], joint[playerid], zapik[playerid], marihuana[playerid], tabak[playerid]);
	SCM(playerid, COLOR_SEDA, string);
	SCM(playerid, COLOR_SEDA, string2);
	SCM(playerid, COLOR_SEDA, string3);
	return 1;
}
//----------------------------------------
dcmd_get(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /get [ID]!");
	new ZadaneID = strval(params), Float:a, Float:b, Float:c;
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");
	else if (ZadaneID != playerid) return SCM(playerid, COLOR_CERVENA, "[ ! ]Neni ti divne teleportovat sám sebe? :D");

	GetPlayerPos(playerid, a, b, c);
	new typauta = GetPlayerVehicleID(ZadaneID);
	new State = GetPlayerState(ZadaneID);
	SetPlayerInterior(ZadaneID, 0);

	if (State != PLAYER_STATE_DRIVER)
	{
		SetPlayerPos(ZadaneID, a, b, c);
	}
	if (IsPlayerInVehicle(ZadaneID, typauta) == 1)
	{
		SetVehiclePos(typauta, a, b, c);
	}
	else
	{
		SetPlayerPos(ZadaneID, a, b, c);
	}

	return 1;
}
//----------------------------------------
dcmd_flip(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
	else if (!strlen(params) || !IsNumeric(params)) return SCM(playerid, MODRA, "[ i ]Pouití /flip [ID]!");
	new ZadaneID = strval(params), Float:z;
	if (!IsPlayerConnected(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ]Hráè [ID] není na serveru");

	else if (IsPlayerInAnyVehicle(ZadaneID)) return SCM(playerid, COLOR_CERVENA, "[ ! ] Zadane ID se nenachazi v autì ! ");
	{
		GetVehicleZAngle(GetPlayerVehicleID(ZadaneID), z);
		SetVehicleZAngle(GetPlayerVehicleID(ZadaneID), z);
	}
	return 1;
}
//----------------------------------------

//----------------------------------------
dcmd_djoin(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || dlistek[playerid] == 1)
	{
		SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi v aute nebo u jsi v dragu pøihláen");
	}
	else
	{
		dlistek[playerid] = 1;
		SCM(playerid, COLOR_ZELZLUT, "[ i ]Má lístek na drag [ -300  ]. Portni se na drag [ /dwarp ] ");
		GivePlayerMoney(playerid, -300);
	}

	return 1;
}
//----------------------------------------
dcmd_cmd(playerid, params[])
{
#pragma unused params
	SCM(playerid, COLOR_SVZEL, "[ PRIKAZY: ]");
	SCM(playerid, COLOR_SVZEL, "[ /cmd /rules /help /balicek /kill /afk  /lock /unlock ]"); //prikazy
	SCM(playerid, COLOR_SVZEL, "[ /register /login /mp3 /mp3s /djoin(jeste neni hotovo) /dwarp /skydrive ]"); //prikazy 2 radek
	SCM(playerid, COLOR_SVZEL, "[ /admins /paintball /locate /wanted ]");
	return 1;
}
//-----------------------------------------
stock SendMessageToAdmins(color, const string[])
{
	for (new i = 0; i <= MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) == 1)
		{
			if (IsPlayerAdmin(i) || lvl[i] >= 4)
			{
				SendClientMessage(i, color, string);
			}
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

	SetTimer("Weapon_Anti_Cheat", 30000, 1);
	//SetTimer("bomb",60000,1);
	SetTimer("radarCH", 300, 1);
	SetTimer("Machine", 1000, 1);
	SetTimer("ulozeni", 200000, 1);
	SetTimer("ScoreUpdate", 1000, true);
	SetTimer("Vyplata", 300000, 1);

	//------------------------
	//CreatePickup(1274, 1,2029.54, 1320.78, 10.82);
	//	CreatePickup(362, 1,2017.58,1338.44,10.82);

	polisilv = CreatePickup(1239, 1, 2171.22, 1397.11, 11.06);
	menupolisi = CreateMenu("Fizly xD", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menupolisi, 0, "Polisi");

	love = CreatePickup(1240, 1, 2302.85, 1155.93, 85.94); //v admin mistnosti
							       //------------------------
	lamer = CreatePickup(1239, 1, 2252.11, 1285.30, 19.17);
	menulamer = CreateMenu("Kravinec", 1, 150.0, 100.0, 250.0, 150.0); //LV pod pyramidu na "prdeli" swingy
	AddMenuItem(menulamer, 0, "Club Lamy");

	borec = CreatePickup(1239, 1, 2304.43, 1151.95, 85.94);
	menuborec = CreateMenu("Admin Zona", 1, 150.0, 100.0, 250.0, 150.0); // LV admin mistnost LV
	AddMenuItem(menuborec, 0, "Admin - Borci");

	benzinak = CreatePickup(1239, 1, 2637.36, 1127.04, 11.18);
	benzinakmenu = CreateMenu("Benzina", 1, 150.0, 100.0, 250.0, 150.0); // LV benzinky
	AddMenuItem(benzinakmenu, 0, "Benzinak xD");

	dragster = CreatePickup(1239, 1, 2620.14, 1195.76, 10.81);
	dragstermenu = CreateMenu("Dragy", 1, 150.0, 100.0, 250.0, 150.0); // LV zacatek dragu
	AddMenuItem(dragstermenu, 0, "DRaGsTeR");

	tulak = CreatePickup(1581, 1, 2892.8, -2127.9, 3.2);
	menutulak = CreateMenu("Tulaci", 1, 150.0, 100.0, 250.0, 150.0); // LS plaz
	AddMenuItem(menutulak, 0, "Tulaci");

	pizzaboy = CreatePickup(1581, 1, 2101.70, -1810.05, 13.55);
	menupizza = CreateMenu("Pizza", 1, 150.0, 100.0, 250.0, 150.0); // LS u pizza
	AddMenuItem(menupizza, 0, "PizzaBoy");

	hackeri = CreatePickup(1581, 1, 2838.10, -2130.26, 0.19);
	hackerimenu = CreateMenu("Hacker",  1, 150.0, 100.0, 250.0, 150.0); // LS za tulakama
	AddMenuItem(hackerimenu, 0, "Hackeri");

	//technik = CreatePickup(1581,1, );
	menutechnik = CreateMenu("Technik", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menutechnik, 0, "Technik");

	//pyrotechnik = CreatePickup(1581,1, );
	menupyrotechnik = CreateMenu("Pyrotechnik", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menupyrotechnik, 0, "Pyrotechnik");

	interiertulaci = CreatePickup(1318, 1, 2866.62, -2125.24, 5.72);
	tulacizpatky = CreatePickup(1318, 1, 2853.09, -2125.16, 0.19);
	pytelpenez = CreatePickup(1550, 1, 2838.59, -2141.25, 0.19);
	picktunel = CreatePickup(1318, 1, 2263.41, -755.52, 38.04);

	duledvera = CreatePickup(1318, 1, 995.78, -1158.06, 23.87);
	navrchuadmin = CreatePickup(1318, 1, 1007.30, -1160.62, 50.95);

	// Include objects and vehicles
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
			SendClientMessage(playerid, COLOR_SVZEL, "Nejsi přihlášen --> /login heslo");
		}
		else
		{
			GameTextForPlayer(playerid, "~r~Registruj se!", 5000, 5);
			SendClientMessage(playerid, COLOR_SVZEL, "Nejsi registrován --> /register heslo");
		}

		return 0;
	}

	return 1;
}

public OnPlayerConnect(playerid)
{
	new playerName[MAX_PLAYER_NAME];
	new stringToPrint[68];

	// Reset the auth status for a new player.
	gPlayerAuth[playerid] = false;

	// Reset the paintball states.
	gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
	gPaintball[playerid][E_PAINTBALL_SCORE] = 0;

	// Show the game clock.
	TextDrawShowForPlayer(playerid, gClockText);

	// Send a welcome text to the connecting new player.
	SendClientMessage(playerid, GREEN, "Cus, vítej v modu CrazyRaceLife2! :) /cmd /help /rules");

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);

	// Fetch player's name and print it out to outhers online.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Hráč %s se právě připojil ke hře!", playerName);
	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return false;
}

public OnPlayerDisconnect(playerid, reason)
{
	Object_OnPlayerDisconnect(playerid, reason);
	TextDrawHideForPlayer(playerid, KPH[playerid]);

	new string[90], Jmeno[30];

	if (gPlayerAuth[playerid])
	{
		dUserSetINT(PlayerName(playerid)).("money", GetPlayerMoney(playerid)); //co se ulozi do %s.dudb.sav
		dUserSetINT(PlayerName(playerid)).("banka", bank[playerid]); //to co nahore akorat jina vec
		dUserSetINT(PlayerName(playerid)).("adminlvl", lvl[playerid]);
		dUserSetINT(PlayerName(playerid)).("tym", iPlayerRole[playerid]);
		dUserSetINT(PlayerName(playerid)).("joint", iPlayerRole[playerid]);
		dUserSetINT(PlayerName(playerid)).("zapik", iPlayerRole[playerid]);
		//dUserSetINT(playerName(playerid)).
		dUserSetINT(PlayerName(playerid)).("skin", GetPlayerSkin(playerid));
	}

	gPlayerAuth[playerid] = false;

	SendDeathMessage(playerid, INVALID_PLAYER_ID, 201);
	GetPlayerName(playerid, Jmeno, 30);

	switch (reason)
	{
		case 0: format(string, sizeof(string), "[ i ] %s odpojen [spadla hra]", Jmeno); //spadnuti hry - oznameni v konzoli
		case 1: format(string, sizeof(string), "[ i ] %s odpojen [odesel]", Jmeno); //odchod :D - oznameni v konzoli
		case 2: format(string, sizeof(string), "[ i ] %s odpojen [kick/ban]", Jmeno); // vynuceeny odchod adminem - /kick, /ban
	}

	SendClientMessageToAll(COLOR_SEDA, string); // napise to vsem do konzole

	return false;
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
			if (IsPlayerConnected(i))
			{
				if (iPlayerRole[i] == iPlayerRole[playerid])
					SendClientMessage(i, GetPlayerColor(playerid), string);
			}
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
	dcmd(skydrive, 8, cmdtext);       //all
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
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 3) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			new name[30];
			new string[68];
			MoveObject(vytah, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);
			GetPlayerName(playerid, name, sizeof(name));
			format(string, sizeof(string), "[ AV ]Admin %s rozjel vytah", name);
			SendClientMessageToAll(COLOR_ZLUTA, string);
		}//else if(

		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/vstop", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 4) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			new string[100];
			StopObject(vytah);
			format(string, sizeof(string), "[ ! ]Výtah se zasekl ! Kontaktujte technika ! ");
			SendClientMessageToAll(COLOR_CERVENA, string);
		}
		return 1;
	}

	//----------------------------------------
	if (strcmp(cmdtext, "/vdown", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 3) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			new name[30];
			new string[68];
			MoveObject(vytah, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);
			GetPlayerName(playerid, name, sizeof(name));
			format(string, sizeof(string), "[ AV ]Admin %s poslal výtah dolù ", name);
			SendClientMessageToAll(COLOR_ZLUTA, string);
		}
		return 1;
	}
	//----------------------------------------
	if (strcmp("/reset", cmdtext, true) == 0)
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
	}
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
		if (iPlayerRole[playerid] == 3 || IsPlayerAdmin(playerid) || lvl[playerid] > 1)
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
	//----------------------------------------
	if (strcmp("/cam1", cmdtext, true, 10) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			SetPlayerCameraPos(playerid, 2219.87, 1266.13, 12.53);
			SetPlayerCameraLookAt(playerid, 2219.89, 1266.13, 12.53);
			SCM(playerid, MODRA, "[CAM]Kamera 1 zap. [/ccmd][/camoff]");
		}
		return 1;
	}
	//--------------------------------------------
	if (strcmp("/cam2", cmdtext, true, 10) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			SetPlayerCameraPos(playerid, 2035.62, 1303.53, 10.41);
			SetPlayerCameraLookAt(playerid, 2056.07, 1318.53, 10.41);
			SCM(playerid, MODRA, "[CAM]Kamera 2 zap. [/ccmd][/camoff]");
		}
		return 1;
	}
	//--------------------------------------------
	if (strcmp(cmdtext, "/cam3", true, 10) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			SetPlayerCameraPos(playerid, 2254.22, 1207.01, 10.38);
			SetPlayerCameraLookAt(playerid, 2254.22, 1207.01, 10.38);
			SCM(playerid, MODRA, "[CAM]Kamera 3 zap. [/ccmd][/camoff]");
		}
		return 1;
	}
	//--------------------------------------------
	if (strcmp("/camoff", cmdtext, true, 10) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			SetCameraBehindPlayer(playerid);
			SCM(playerid, MODRA, "[CAM]Kamera vypnuta [/ccmd]");
		}
		return 1;
	}
	//---------------------------------------------
	//---------------------------------------------

	//----------------------------------------
	if (strcmp(cmdtext, "/hp", true) == 0)
	{
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 1) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 100.0);
			SCM(playerid, COLOR_SEDA, "[ ! ]Zdravi: 100.0, Vesta: 100.0");
		}
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
		if (iPlayerRole[playerid] != 2) return SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi Admin-borec tým !");
		{
			SetPlayerColor(hrac, COLOR_NEVIDITEL);
			SCM(hrac, COLOR_ZLUTA, "[ HIDE ]Nejsi vidìt na mapì! ");
		}
		return 1;
	}
	//----------------------------------------
	if (strcmp(cmdtext, "/unhide", true) == 0)
	{
		if (iPlayerRole[playerid] != 2) return SCM(playerid, COLOR_CERVENA, "[ ! ]Nejsi Admin-borec tým !");
		{
			SetPlayerColor(hrac, COLOR_SVZEL);
			SCM(hrac, COLOR_ZLUTA, "[ HIDE ]Teï jsi vidìt na mapì! ");
		}
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
		if (!IsPlayerAdmin(playerid) && lvl[playerid] < 2) return SCM(playerid, COLOR_SEDA, "[ ! ] Nedostateèný Admin-level");
		{
			GivePlayerWeapon(playerid, 28, 400);
			GivePlayerWeapon(playerid, 26, 400);
			GivePlayerWeapon(playerid, 31, 400);
			GivePlayerWeapon(playerid, 46, 1);
			GivePlayerWeapon(playerid, 43, 1);
		}
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
					iPlayerRole[playerid] = 1; //promenna na povolani cislo 1
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
					iPlayerRole[playerid] = 2; //promenna na povolani cislo 2
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
					format(string, sizeof(string), "[!] Hrac %s se pripojil k POLIUM", pname); //UVIDI VSICHNI
					GivePlayerWeapon(playerid, 32, 111); //PRIDA HRACOVI ZBRAN ID,NABOJU
					GivePlayerWeapon(playerid, 31, 100);
					GivePlayerWeapon(playerid, 30, 100);
					SendClientMessageToAll(COLOR_ZLUTA, string);
					printf(string); //vytiskne to do logu
					SetPlayerSkin(playerid, 285);
					iPlayerRole[playerid] = 3; //promenna na povolani cislo 3
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
					iPlayerRole[playerid] = 4; //promenna na povolani cislo 4
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
					iPlayerRole[playerid] = 5; //promenna na povolani cislo 5
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
					iPlayerRole[playerid] = 6; //promenna na povolani cislo 6
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
					iPlayerRole[playerid] = 7; //promenna na povolani cislo 7
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
					iPlayerRole[playerid] = 8; //promenna na povolani cislo 8
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
					iPlayerRole[playerid] = 9; //promenna na povolani cislo 9
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
					iPlayerRole[playerid] = 10; //promenna na povolani cislo 10
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

IsPlayerInInvalidNosVehicle(playerid, vehicleid) //TOE K NITRU HAHA
{
#define MAX_INVALID_NOS_VEHICLES 31

	new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
	{
		581, 523, 462, 521, 463, 522, 461, 448, 468, 586,
		509, 481, 510, 472, 473, 493, 595, 484, 430, 453,
		452, 446, 454, 590, 569, 537, 538, 570, 449, 522, 520
	};

	vehicleid = GetPlayerVehicleID(playerid);

	if (IsPlayerInVehicle(playerid, vehicleid))
	{
		for (new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
		{
			if (GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
			{
				return true;
			}
		}
	}
	return false;
}

public AntiJetPack()//antijetpack :)--------------------_)
{
	new wang[MAX_PLAYER_NAME], string[256];
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i) && !IsPlayerAdmin(i))
		{
			if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			{
				GetPlayerName(i, wang, MAX_PLAYER_NAME);
				format(string, sizeof(string), "[ ! ] Hráè %s byl vyhozen za poruení pravidel. [Jet Pack]", wang);
				SendClientMessageToAll(COLOR_CERVENA, string);
				PlayerPlaySound(i, 1056, 0, 0, 0);
				Kick(i);
			}
		}
	}
	return 1;
}

public Weapon_Anti_Cheat()
{
	for (new i = 0; i <= GetMaxPlayers(); i++)
	{
		if (!IsPlayerAdmin(i))
		{
			new WeData[13][2];
			GetPlayerWeaponData(i, 7, WeData[7][0], WeData[7][1]);
			if (WeData[7][0] == 38 || WeData[7][0] == 37 || WeData[7][0] == 36)
			{
				new wang[MAX_PLAYERS], string[256];
				GetPlayerName(i, wang, MAX_PLAYER_NAME);
				format(string, sizeof(string), "Hráè %s byl vyhozen za weapon cheat", wang);
				SendClientMessageToAll(COLOR_CERVENA, string);
				Kick(i);
			}
		}
	}
	return 1;
}

public radarCH()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerInAnyVehicle(i) && IsPlayerConnected(i))
		{
			new string[128], Float:value_r, Float:distance_r, Float:x_r, Float:y_r, Float:z_r;
			GetPlayerPos(i, x_r, y_r, z_r);
			distance_r = floatsqroot(floatpower(floatabs(floatsub(x_r, PlayerPos[i][X_r])), 2) + floatpower(floatabs(floatsub(y_r, PlayerPos[i][Y_r])), 2) + floatpower(floatabs(floatsub(z_r, PlayerPos[i][Z_r])), 2));
			value_r = floatround(distance_r * 11000);
			if (floatround(value_r / 1400) > 65)
			{
				format(string, 128, "~r~~h~%d", floatround(value_r / 1400));
			}
			else
			{
				format(string, 128, "~g~~h~%d", floatround(value_r / 1400));
			}
			TextDrawSetString(KPHR[i], string);
			PlayerPos[i][X_r] = x_r;
			PlayerPos[i][Y_r] = y_r;
			PlayerPos[i][Z_r] = z_r;
			if (IsPlayerInSphere(i, 2048.4158, 1173.2195, 10.6719, 15) ||
					IsPlayerInSphere(i, 2066.5464, 1623.2606, 10.6719, 15) ||
					IsPlayerInSphere(i, 2347.6807, 2413.1965, 10.6719, 15) ||
					IsPlayerInSphere(i, 2507.3359, 1880.9712, 10.6719, 15) ||
					IsPlayerInSphere(i, 2260.2791, 1373.3129, 10.6719, 15) ||
					IsPlayerInSphere(i, 2427.2900, 1257.8555, 10.7901, 15) nebo
					IsPlayerInSphere(i, 2210.5552, 973.2725, 10.6719, 15) ||
					IsPlayerInSphere(i, 1536.0039, 1133.1715, 10.6719, 15) ||
					IsPlayerInSphere(i, 1007.3343, 1540.1764, 10.6719, 15) ||
					IsPlayerInSphere(i, 1448.2607, 2589.8904, 10.6719, 15) ||
					IsPlayerInSphere(i, 1691.7292, 2173.2539, 10.6719, 15))
			{
				if (Radarovany[i] == 0 && floatround(value_r / 1400) > 65)
				{
					Radarovany[i] = 1;
					GivePlayerMoney(i, -500);
					PlayerPlaySound(i, 1147, 0, 0, 0);
					SCM(i, COLOR_BILA, " ");
					format(string, 128, "[ Radar ] Jel jsi pøíli velkou rychlostí ( %d Km/h ). Pokuta: -500 ", floatround(value_r / 1400));
					SCM(i, COLOR_CERVENA, string);
					SetTimerEx("radarEX", 5000, 0, "i", i);
					return 1;
				}
			}
		}
	}
	return 1;
}
//-----------------|
public radarEX(playerid)
{
	Radarovany[playerid] = 0;
}

public Machine()
{
	new i, ip[256], string[256];
	for (i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			if (GetPlayerPing(i) == 0)
			{
				GetPlayerIp(i, ip, 128);
				PlayerPlaySound(i, 1056, 0, 0, 0);
				format(string, 256, "IP: %s se pokouela floodovat server.\r\n", ip);
				Ban(i);
				print(string);
			}
		}
	}
	return 1;
}

public ulozeni(playerid)
{
	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i))
		{
			SCM(i, COLOR_ORANZCERV, "[ i ][DATA] Pøipravuje se uloení vìcí na úèet...");
			//-------
			if (gPlayerAuth[playerid])
			{
				dUserSetINT(PlayerName(playerid)).("banka", bank[playerid]);
				dUserSetINT(PlayerName(playerid)).("money", GetPlayerMoney(playerid));
				dUserSetINT(PlayerName(i)).("adminlvl", lvl[playerid]);
				dUserSetINT(PlayerName(i)).("joint", joint[playerid]);

				SCM(i, COLOR_CERVENA, "[ i ][DATA] Uloeno ! "); //hláka
			}
		}
	}
	return 1;
}

public ScoreUpdate()
{
	for (new i; i <= GetMaxPlayers(); i++)
	{
		SetPlayerScore(i, GetPlayerMoney(i));
	}
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


public Vyplata() // pubic vyplata
{
	new string[256], tmp[256]; //definice stringu pro zpravu a tmp pro game text
	for (new i = 0; i < MAX_PLAYERS; i++) // zjisti kolik hracu je na serveru
	{
		//Vyplata cislo 1
		if (IsPlayerConnected(i) && iPlayerRole[i] == 1)
		{
			new vyplata = 5 + random(20);
			GivePlayerMoney(i, vyplata);
			format(string, sizeof(string), "Výplata povolání: %d | Nemysli si ze lamam budeme davat tolik penìz ! ", vyplata);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d", vyplata);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 2
		if (IsPlayerConnected(i) && iPlayerRole[i] == 2)
		{
			new vyplata2 = 1500 + random(2000);
			GivePlayerMoney(i, vyplata2);
			format(string, sizeof(string), "Výplata povolání: %d | Uijte peníze pro co chcete xD ", vyplata2);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d", vyplata2);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 3
		if (IsPlayerConnected(i) && iPlayerRole[i] == 3)
		{
			new vyplata3 = 1000 + random(600);
			GivePlayerMoney(i, vyplata3);
			format(string, sizeof(string), "Výplata povolání: %d | Pro pány fízle pár papírù z kasy :)", vyplata3);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata3);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 4
		if (IsPlayerConnected(i) && iPlayerRole[i] == 4)
		{
			new vyplata4 = 1000 + random(600);
			GivePlayerMoney(i, vyplata4);
			format(string, sizeof(string), "Výplata povolání: %d | Prachy z benzinky :D", vyplata4);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d", vyplata4);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 5
		if (IsPlayerConnected(i) && iPlayerRole[i] == 5)
		{
			new vyplata5 = 1200 + random(1000);
			GivePlayerMoney(i, vyplata5);
			format(string, sizeof(string), "Výplata povolání: %d | Výdìlek z dragù :D", vyplata5);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata5);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 6
		if (IsPlayerConnected(i) && iPlayerRole[i] == 6)
		{
			new vyplata6 = 120 + random(100);
			GivePlayerMoney(i, vyplata6);
			format(string, sizeof(string), "Výplata povolání: %d | Podpora mìsta a peníze s popelnic xD ", vyplata6);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata6);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 7
		if (IsPlayerConnected(i) && iPlayerRole[i] == 7)
		{
			new vyplata7 = 190 + random(200);
			GivePlayerMoney(i, vyplata7);
			format(string, sizeof(string), "Výplata povolání: %d | PizzaPodpora a výplaty xD ", vyplata7);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata7);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 8 hackri
		if (IsPlayerConnected(i) && iPlayerRole[i] == 8)
		{
			new vyplata8 = 500 + random(300);
			GivePlayerMoney(i, vyplata8);
			format(string, sizeof(string), "Výplata povolání: %d | Vykradené banky xD ", vyplata8);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata8);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 9 technik
		if (IsPlayerConnected(i) && iPlayerRole[i] == 9)
		{
			new vyplata9 = 300 + random(299);
			GivePlayerMoney(i, vyplata9);
			format(string, sizeof(string), "Výplata povolání: %d | Vyplata z autoservisù ", vyplata9);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata9);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 10 pyrotechnik
		if (IsPlayerConnected(i) && iPlayerRole[i] == 10)
		{
			new vyplata10 = 800 + random(210);
			GivePlayerMoney(i, vyplata10);
			format(string, sizeof(string), "Výplata povolání: %d | Vyplata od ministerstva pyrotechniky :D", vyplata10);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata10);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
		//Vyplata cislo 0 nezamnestnany
		if (IsPlayerConnected(i) && iPlayerRole[i] == 0)
		{
			new vyplata0 = 100 + random(150);
			GivePlayerMoney(i, vyplata0);
			format(string, sizeof(string), "Výplata povolání: %d | Pár dorbkù z mìstké kasy :) A nemysli si e nebude pracovat !", vyplata0);
			SendClientMessage(i, COLOR_ORANZCERV, string);
			format(tmp, sizeof(tmp), "~y~V~g~yplata ~n~~y~ %d ", vyplata0);
			GameTextForPlayer(i, tmp, 5000, 1);
		}
	}
	return 1;
}

stock TestPrint(print[])
{
#if BUG_SYSTEM
	printf(" BS | %s ", print);
#else
#pragma unused print
#endif
}

public RESET()
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
