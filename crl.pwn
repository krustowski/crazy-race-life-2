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

//-----------------------[FORWARDS NEWS ENUMS ]------------------------------//
forward Reklama();
forward AntiJetPack();
forward Weapon_Anti_Cheat();
forward Machine();
forward radarCH();
forward radarEX(playerid);
forward ulozeni(playerid);
forward ScoreUpdate();
forward drag();
forward Vyplata(playerid);
forward THodiny();

forward RESET();

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
new Text:Hodiny;
new dlistek[MAX_PLAYERS];
new lvl[MAX_PLAYERS];
new vytah;
new iPlayerRole[MAX_PLAYERS];
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

//paintball ------------------
new skore[MAX_PLAYERS];
new hrajepaint[MAX_PLAYERS];

new vytez = 999;
new vytezskore = 0;

forward konecpaint();
forward startpaint();
//paintball ------------------

enum ACCOUNT
{
    AFK
}

static Hrac[MAX_PLAYERS][ACCOUNT];

//----------------------------------------------------|
new AdminAuto;
new PLAYERLIST_authed[MAX_PLAYERS];

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
    //zamiky piky ble blba vychovatelka :!
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

    if (PLAYERLIST_authed[playerid])
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
    if (PLAYERLIST_authed[playerid]) return SystemMsg(playerid, "[SERVER] U jsi pøihláen.");

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
        PLAYERLIST_authed[playerid] = true;

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
    print("    [ *** CrAzY RaCe LiVe *** ]     ");
    print("  [ StUnTs, RaCeS aNd DrIvIng ! ]  ");
    print(" [ Made by kRySpiNCzE and kompry ] ");
    print("----------------------------------\n");
}

public OnGameModeInit()
{
    Object_Object();
    // nepouzivat v pripade FS// // // /

    SetGameModeText("CRLive 1.30i "); //nazev GM

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


    //------------------------admin house
    vytah = CreateObject(5837, 2303.207, 1174.944, 80.285, 0.0, 0.0, 142.812);
    CreateObject(1219, 2298.66, 1171.64, 10.92, 0, 0, 0); //paleta
    //CreateObject(2528,0,0,0,0,0,0);//zachod xD
    CreateDynamicObject(980, 2308.141, 1150.977, 87.661, 0.0, 0.0, -161.797);
    CreateDynamicObject(980, 2310.636, 1151.781, 87.683, 0.0, 0.0, -161.797);
    CreateDynamicObject(971, 2301.360, 1153.487, 86.832, 0.0, 0.0, -71.797);
    CreateDynamicObject(971, 2314.688, 1157.859, 86.886, 0.0, 0.0, -251.797);
    CreateDynamicObject(971, 2309.025, 1160.659, 86.857, 0.0, 0.0, -160.93);
    CreateDynamicObject(980, 2301.250, 1170.381, 78.861, -89.381, -8.594, -225.782);
    CreateDynamicObject(3399, 2299.039, 1164.836, 81.682, 0.0, -8.594, -71.015);
    CreateDynamicObject(971, 2311.220, 1156.746, 90.432, -90.241, 0.0, -251.797);
    CreateDynamicObject(971, 2304.456, 1154.501, 90.407, -90.241, 0.0, -251.797);
    CreateDynamicObject(980, 2296.447, 1163.688, 78.874, -89.381, -8.594, -225.782);
    CreateDynamicObject(1998, 2305.986, 1152.446, 84.912, 0.0, 0.0, -71.797);
    CreateDynamicObject(2356, 2306.391, 1151.348, 84.932, 0.0, 0.0, -45.000);
    CreateDynamicObject(1742, 2312.109, 1152.751, 84.933, 0.0, 0.0, 112.500);
    CreateDynamicObject(1742, 2311.578, 1154.048, 84.933, 0.0, 0.0, 112.500);
    CreateDynamicObject(1747, 2311.601, 1154.238, 86.687, 19.767, 0.0, 112.500);
    CreateDynamicObject(1745, 2311.757, 1154.720, 84.922, 0.0, 0.0, -69.219);
    CreateDynamicObject(2160, 2307.286, 1159.764, 84.972, 0.0, 0.0, 21.641);
    CreateDynamicObject(2157, 2308.616, 1160.269, 84.961, 0.0, 0.0, -340.93);
    CreateDynamicObject(2164, 2302.652, 1149.842, 84.899, 0.0, 0.0, -611.797);
    CreateDynamicObject(643, 2308.460, 1156.917, 85.383, 0.0, 0.0, 0.0);
    CreateDynamicObject(1738, 2314.466, 1153.250, 85.542, 0.0, 0.0, -157.500);
    CreateDynamicObject(2017, 2310.002, 1160.507, 84.938, 0.0, 0.0, 19.062);
    CreateDynamicObject(2099, 2313.076, 1161.652, 84.936, 0.0, 0.0, -33.750);
    CreateDynamicObject(1219, 2303.03, 1163.85, 79.94, 0, 0, 0);

    //------------------MADE BY KOMPRY - MTA -----------------//
    AddStaticVehicle(522, 199.328, -1790.488, 3.655, 0.0, -1, -1); // spawnpoint (1)
    AddStaticVehicle(522, 1888.236, -2399.764, 13.199, 182.0, -1, -1); // spawnpoint (2)
    AddStaticVehicle(522, 1891.617, -2399.939, 13.199, 173.0, -1, -1); // spawnpoint (2)
    AddStaticVehicle(522, 1889.321, -2399.803, 13.074, 175.0, -1, -1); // spawnpoint (3)
    AddStaticVehicle(522, 1890.475, -2399.837, 13.074, 176.0, -1, -1); // spawnpoint (4)

    CreateDynamicObject(1276, 2254.107, -2261.670, 13.929, 0.0, 0.0, 0.0); // object
    CreateDynamicObject(1276, 2130.374, -2275.248, 14.338, 0.0, 0.0, 0.0); // object (2)
    CreateDynamicObject(1276, 1082.610, -73.319, 54.258, 0.0, 0.0, 0.0); // object (3)
    CreateDynamicObject(1276, 2803.757, -1245.871, 49.152, 0.0, 0.0, 0.0); // object (4)
    CreateDynamicObject(1276, 153.958, -1951.624, 47.204, 0.0, 0.0, 0.0); // object (6)
    CreateDynamicObject(18056, 1482.323, -1193.001, 24.861, 0.0, 0.0, 135.000); // object (8)
    CreateDynamicObject(14467, 1696.456, -1331.903, 19.186, 0.0, 0.0, 0.0); // object (7)
    CreateDynamicObject(18018, 1750.176, -2034.804, 12.251, 0.0, 0.0, 180.000); // object (8)
    CreateDynamicObject(1318, 1760.104, -2031.596, 13.011, 0.0, 0.0, 0.0); // object (9)
    CreateDynamicObject(1318, 1765.110, -2031.507, 13.540, 0.0, 0.0, 0.0); // object (10)
    CreateDynamicObject(849, 2884.708, -2122.715, 2.979, 2.578, 0.0, -67.500); // object (13)
    CreateDynamicObject(853, 2879.145, -2128.203, 3.688, -9.454, 0.0, -90.000); // object (14)
    CreateDynamicObject(850, 2875.921, -2119.956, 4.863, 15.470, 0.0, 11.250); // object (15)
    CreateDynamicObject(1553, 2869.596, -2126.230, 3.663, 0.859, 180.482, 85.703); // object (16)
    CreateDynamicObject(1553, 2869.632, -2126.219, 6.043, 0.859, 180.482, 85.703); // object (17)
    CreateDynamicObject(1358, 2869.739, -2129.250, 5.307, 0.0, 0.859, -0.859); // object (18)
    CreateDynamicObject(1344, 2869.279, -2128.261, 6.274, -46.410, 4.297, 5.157); // object (19)
    CreateDynamicObject(850, 2869.863, -2126.368, 7.272, 0.0, 0.0, 0.0); // object (21)
    CreateDynamicObject(1429, 2869.688, -2127.369, 6.869, 0.0, 0.0, 56.250); // object (22)
    CreateDynamicObject(1327, 2867.559, -2129.290, 4.732, 0.859, 26.643, -4.374); // object (23)
    CreateDynamicObject(14593, 2844.824, -2132.332, 1.522, 0.0, 0.0, 91.960); // object (24)
    CreateDynamicObject(1502, 2858.509, -2125.934, -0.815, 0.0, 0.0, 90.859); // object (27)
    CreateDynamicObject(18008, 1495.980, -1702.625, 8.651, 0.0, 0.0, -97.976); // object (27)
    CreateDynamicObject(5302, 1489.429, -1716.241, 7.983, 0.0, 0.0, -96.953); // object (32)
    CreateDynamicObject(1738, 1238.994, -2370.746, 0.502, -64.458, 0.0, 0.0); // object (33)
    CreateDynamicObject(1738, 2852.076, -2137.431, -0.152, -0.859, 0.0, 92.896); // object (34)
    CreateDynamicObject(1778, 2852.676, -2127.784, -0.808, 0.0, 0.0, -90.000); // object (35)
    CreateDynamicObject(1809, 2834.502, -2133.458, 0.383, 0.0, 0.0, 91.719); // object (37)
    CreateDynamicObject(1829, 2831.965, -2141.674, -0.342, 0.0, 0.0, 90.000); // object (39)
    CreateDynamicObject(2201, 2834.501, -2131.781, 0.139, 0.0, 0.0, 90.000); // object (50)
    CreateDynamicObject(2202, 2842.598, -2133.122, -0.813, 0.0, 0.0, 271.341); // object (51)
    CreateDynamicObject(14532, 2834.990, -2138.480, 0.176, 0.0, 0.0, -45.000); // object (54)
    CreateDynamicObject(14527, 2841.875, -2131.973, 1.590, 0.0, 0.0, 0.0); // object (55)
    CreateDynamicObject(1736, 2841.375, -2123.460, 2.103, 0.0, 0.0, 0.0); // object (56)
    CreateDynamicObject(2190, 2834.425, -2131.278, 0.139, 0.0, 0.0, 91.719); // object (57)
    CreateDynamicObject(2192, 2834.875, -2133.050, 0.339, -2.578, 0.0, -109.767); // object (58)
    CreateDynamicObject(941, 2834.683, -2131.515, -0.332, 0.0, 0.0, 90.000); // object (59)
    CreateDynamicObject(1416, 2834.592, -2133.166, -0.193, 0.0, 0.0, 92.578); // object (60)
    CreateDynamicObject(2185, 2839.340, -2128.065, -0.808, 0.0, 0.0, 180.000); // object (62)
    CreateDynamicObject(2198, 2843.415, -2131.048, -0.839, 0.0, 0.0, 2.578); // object (63)
    CreateDynamicObject(2356, 2835.540, -2131.240, -0.812, 0.0, 0.0, 90.000); // object (64)
    CreateDynamicObject(2356, 2838.459, -2128.691, -0.812, 0.0, 0.0, 22.500); // object (65)
    CreateDynamicObject(2198, 2844.413, -2129.988, -0.843, 0.0, 0.0, 182.201); // object (66)
    CreateDynamicObject(2198, 2844.541, -2133.123, -0.814, 0.0, 0.0, 182.201); // object (67)
    CreateDynamicObject(2198, 2843.554, -2134.180, -0.841, 0.0, 0.0, 2.201); // object (68)
    CreateDynamicObject(2198, 2844.604, -2136.118, -0.814, 0.0, 0.0, -178.281); // object (69)
    CreateDynamicObject(2356, 2843.833, -2131.668, -0.812, 0.0, 1.719, -3.679); // object (70)
    CreateDynamicObject(2356, 2843.848, -2132.426, -0.812, 0.0, 1.719, 176.803); // object (71)
    CreateDynamicObject(2226, 2838.976, -2128.019, -0.003, 0.0, 0.0, -45.000); // object (72)
    CreateDynamicObject(2198, 2847.071, -2135.674, -0.814, 0.0, 0.0, -268.281); // object (73)
    CreateDynamicObject(2198, 2847.034, -2132.680, -0.814, 0.0, 0.0, -268.281); // object (74)
    CreateDynamicObject(2198, 2846.951, -2129.678, -0.814, 0.0, 0.0, -268.281); // object (75)
    CreateDynamicObject(2356, 2847.565, -2129.075, -0.812, 0.0, 3.438, 120.080); // object (76)
    CreateDynamicObject(2356, 2847.781, -2132.144, -0.812, 0.0, 3.438, 68.514); // object (77)
    CreateDynamicObject(2356, 2847.760, -2135.202, -0.812, 0.0, 3.438, 12.651); // object (78)
    CreateDynamicObject(2190, 2870.183, -2129.606, 5.359, -53.285, 79.068, 102.264); // object (79)
    CreateDynamicObject(2190, 2869.460, -2127.734, 6.746, -118.602, 91.960, 75.389); // object (80)
    CreateDynamicObject(2356, 2843.961, -2134.715, -0.812, 0.0, 1.719, -3.679); // object (58)
    CreateDynamicObject(2356, 2844.090, -2135.488, -0.879, 0.0, 1.719, 227.510); // object (60)
    CreateDynamicObject(980, 2407.626, -2260.619, 44.831, -90.241, 0.0, 45.000); // object (62)
    CreateDynamicObject(980, 2401.095, -2267.130, 44.849, -90.241, 0.0, 45.000); // object (63)
    CreateDynamicObject(980, 2397.167, -2263.196, 44.855, -90.241, 0.0, 45.000); // object (64)
    CreateDynamicObject(980, 2403.738, -2256.739, 44.822, -90.241, 0.0, 45.000); // object (65)
    CreateDynamicObject(980, 2399.815, -2252.830, 44.833, -90.241, 0.0, 45.000); // object (66)
    CreateDynamicObject(980, 2393.250, -2259.294, 44.856, -90.241, 0.0, 45.000); // object (67)
    CreateDynamicObject(984, 2407.620, -2252.616, 45.499, 0.0, 0.0, 45.000); // object (71)
    CreateDynamicObject(983, 2413.265, -2258.267, 45.565, 0.0, 0.0, 45.000); // object (73)
    CreateDynamicObject(984, 2393.062, -2267.123, 45.532, 0.0, 0.0, 45.000); // object (74)
    CreateDynamicObject(983, 2397.600, -2271.655, 45.576, 0.0, 0.0, 45.000); // object (75)
    CreateDynamicObject(983, 2411.319, -2263.536, 45.491, 0.0, 0.0, -45.000); // object (76)
    CreateDynamicObject(983, 2404.074, -2270.878, 45.491, 0.0, 0.0, 135.000); // object (77)
    CreateDynamicObject(12950, 2411.263, -2270.759, 41.428, 0.0, 0.0, 44.141); // object (82)
    CreateDynamicObject(8167, 2412.451, -2269.284, 42.600, 0.0, 0.0, 45.000); // object (86)
    CreateDynamicObject(8167, 2409.599, -2272.047, 42.597, 0.0, 0.0, 45.000); // object (87)
    CreateDynamicObject(8167, 2417.689, -2274.511, 42.621, 0.0, 0.0, 45.000); // object (88)
    CreateDynamicObject(8167, 2422.950, -2279.749, 42.621, 0.0, 0.0, 45.000); // object (89)
    CreateDynamicObject(8167, 2427.828, -2284.608, 42.621, 0.0, 0.0, 45.000); // object (90)
    CreateDynamicObject(8167, 2414.861, -2277.273, 42.621, 0.0, 0.0, 45.000); // object (91)
    CreateDynamicObject(8167, 2420.061, -2282.447, 42.621, 0.0, 0.0, 45.000); // object (92)
    CreateDynamicObject(8167, 2425.028, -2287.458, 42.621, 0.0, 0.0, 45.000); // object (93)
    CreateDynamicObject(1435, 2407.050, -2268.392, 41.545, 0.0, 0.0, 45.000); // object (96)
    CreateDynamicObject(1435, 2407.961, -2267.473, 41.545, 0.0, 0.0, 45.000); // object (98)
    CreateDynamicObject(1435, 2408.892, -2266.550, 41.545, 0.0, 0.0, 45.000); // object (99)
    CreateDynamicObject(982, 1011.045, -1159.371, 50.635, 0.0, 0.0, 90.000); // object (86)
    CreateDynamicObject(983, 1026.191, -1159.372, 50.635, 0.0, 0.0, 90.000); // object (87)
    CreateDynamicObject(984, 1029.373, -1165.788, 50.588, 0.0, 0.0, 0.0); // object (88)
    CreateDynamicObject(983, 1029.394, -1175.404, 50.635, 0.0, 0.0, 0.0); // object (89)
    CreateDynamicObject(984, 998.247, -1165.755, 50.588, 0.0, 0.0, 0.0); // object (90)
    CreateDynamicObject(983, 998.238, -1175.338, 50.635, 0.0, 0.0, 0.0); // object (91)
    CreateDynamicObject(1634, 2599.080, -1469.549, 17.153, 0.0, 0.0, 11.250); // object (92)
    CreateDynamicObject(1634, 1906.080, -2617.136, 13.844, 0.0, 0.0, 92.578); // object (93)
    CreateDynamicObject(1634, 1898.596, -2617.484, 18.981, 18.048, 0.0, 92.578); // object (94)
    CreateDynamicObject(12956, 1964.717, -2538.242, 16.375, 0.0, 0.0, 0.0); // object (95)
    CreateDynamicObject(6066, 1980.039, -2645.061, 15.047, 0.0, 0.0, 0.0); // object (98)
    CreateDynamicObject(13592, 1879.881, -2460.758, 22.400, 0.0, 0.0, 11.250); // object (99)
    CreateDynamicObject(13592, 1868.234, -2469.432, 22.450, 0.0, 0.0, 190.391); // object (100)
    CreateDynamicObject(13641, 1811.791, -2443.258, 14.274, 0.0, 0.0, 188.594); // object (105)
    CreateDynamicObject(1225, 1799.331, -2444.864, 18.488, 90.241, 0.0, 7.735); // object (106)
    CreateDynamicObject(1225, 1799.506, -2446.041, 18.452, 90.241, 0.0, 7.735); // object (107)
    CreateDynamicObject(1225, 1799.682, -2447.323, 18.635, 68.755, 0.0, 7.735); // object (108)
    CreateDynamicObject(1634, 1811.777, -2445.518, 13.727, 0.859, 0.0, 100.313); // object (109)
    CreateDynamicObject(1634, 1811.049, -2441.481, 13.737, 0.859, 0.0, 100.313); // object (110)
    CreateDynamicObject(1225, 1799.825, -2448.415, 19.085, 57.582, 0.0, 7.735); // object (111)
    CreateDynamicObject(1225, 1799.925, -2449.317, 19.760, 49.847, 0.0, 7.735); // object (112)
    CreateDynamicObject(1225, 1800.032, -2450.142, 20.635, 34.377, 0.0, 7.735); // object (113)
    CreateDynamicObject(1225, 1800.133, -2450.731, 21.635, 23.205, 0.0, 7.735); // object (114)
    CreateDynamicObject(1225, 1800.184, -2451.162, 22.785, 12.892, 0.0, 7.735); // object (115)
    CreateDynamicObject(1225, 1800.230, -2451.255, 23.985, -7.735, 0.0, 7.735); // object (116)
    CreateDynamicObject(1225, 1799.224, -2443.959, 18.685, -68.755, 0.0, 7.735); // object (117)
    CreateDynamicObject(1225, 1799.014, -2442.876, 19.210, -51.566, 0.0, 7.735); // object (118)
    CreateDynamicObject(1225, 1798.889, -2441.987, 20.035, -51.566, 0.0, 5.157); // object (119)
    CreateDynamicObject(1225, 1798.751, -2441.272, 21.060, -30.940, -0.859, 6.016); // object (120)
    CreateDynamicObject(1225, 1798.661, -2440.729, 22.185, -15.470, -0.859, 8.594); // object (121)
    CreateDynamicObject(1225, 1798.553, -2440.397, 23.285, -12.892, -0.859, 8.594); // object (122)
    CreateDynamicObject(1225, 1798.566, -2440.394, 24.510, 10.313, -0.859, 8.594); // object (123)
    CreateDynamicObject(14467, 2407.558, -2266.818, 63.641, 0.0, 0.0, 45.000); // object (125)
    CreateDynamicObject(1655, 1553.436, -2631.355, 13.622, 0.0, 0.0, 90.000); // object (126)
    CreateDynamicObject(1655, 1553.438, -2622.634, 13.622, 0.0, 0.0, 90.000); // object (127)
    CreateDynamicObject(1655, 1547.016, -2622.504, 13.597, 0.0, 0.0, 269.622); // object (128)
    CreateDynamicObject(1655, 1547.021, -2631.201, 13.622, 0.0, 0.0, 269.622); // object (129)
    CreateDynamicObject(1655, 1684.523, -2466.838, 13.605, 0.0, 0.0, -275.329); // object (128)
    CreateDynamicObject(1655, 1677.567, -2466.317, 18.855, 26.643, -0.859, -273.610); // object (130)
    CreateDynamicObject(1655, 1685.241, -2458.252, 13.680, 0.0, -0.859, -274.470); // object (131)
    CreateDynamicObject(1655, 1678.218, -2457.814, 18.930, 26.643, -0.859, -273.610); // object (132)
    CreateDynamicObject(1503, 1599.233, -2441.890, 35.487, 0.0, 0.0, 90.000); // object (136)
    CreateDynamicObject(6099, 1599.767, -2464.265, 29.514, 0.0, 0.0, -90.241); // object (143)
    CreateDynamicObject(881, -1378.742, -2266.332, 37.079, 0.0, 0.0, 0.0); // object (127)
    CreateDynamicObject(657, -1391.836, -2267.761, 37.733, 0.0, 0.0, 0.0); // object (128)
    CreateDynamicObject(12917, -1357.479, -2323.076, 36.874, 0.0, 0.0, 0.0); // object (131)
    CreateDynamicObject(1453, -1399.403, -2266.000, 36.793, 0.0, 0.0, 0.0); // object (132)
    CreateDynamicObject(1453, -1346.453, -2282.297, 37.644, 0.0, 0.0, 0.0); // object (133)
    CreateDynamicObject(1453, -1387.506, -2273.288, 38.224, 0.0, 0.0, 0.0); // object (134)
    CreateDynamicObject(1453, -1360.453, -2324.407, 40.426, 0.0, 0.0, 0.0); // object (135)
    CreateDynamicObject(1453, -1370.811, -2289.912, 38.744, 0.0, 0.0, 0.0); // object (136)
    CreateDynamicObject(1453, -1392.746, -2318.526, 34.096, 0.0, 0.0, 0.0); // object (137)
    CreateDynamicObject(1453, -1378.763, -2345.222, 34.820, 0.0, 0.0, 0.0); // object (138)
    CreateDynamicObject(1453, -1349.857, -2297.358, 38.853, 0.0, 0.0, 0.0); // object (139)
    CreateDynamicObject(8263, -1404.826, -2298.761, 32.849, 0.0, 0.0, 106.484); // object (148)
    CreateDynamicObject(8210, -1359.875, -2356.429, 32.734, 0.0, 0.0, 180.000); // object (150)
    CreateDynamicObject(8210, -1317.302, -2332.983, 32.718, 0.0, 0.0, 238.442); // object (151)
    CreateDynamicObject(8210, -1306.502, -2281.666, 32.686, 0.0, 0.0, 277.976); // object (152)
    CreateDynamicObject(8210, -1336.902, -2241.168, 32.381, 0.0, 0.0, -22.500); // object (153)
    CreateDynamicObject(8210, -1390.034, -2234.950, 32.294, 0.0, 0.0, 9.299); // object (154)
    CreateDynamicObject(3374, -1377.463, -2292.435, 39.504, 0.0, 0.0, 0.0); // object (161)
    CreateDynamicObject(1225, -1307.133, -2298.424, 34.336, 0.0, 0.0, 0.0); // object (162)
    CreateDynamicObject(1225, -1307.251, -2297.299, 34.310, 0.0, 0.0, 0.0); // object (163)
    CreateDynamicObject(1225, -1305.560, -2295.889, 33.996, 0.0, 0.0, 0.0); // object (164)
    CreateDynamicObject(1225, -1306.374, -2298.269, 34.178, 0.0, 0.0, 0.0); // object (165)
    CreateDynamicObject(1225, -1305.219, -2297.365, 34.026, -21.486, 0.0, -78.750); // object (166)
    CreateDynamicObject(1225, -1306.389, -2297.003, 34.157, 0.0, 0.0, 0.0); // object (167)
    CreateDynamicObject(1225, -1308.089, -2297.476, 34.438, 90.241, 0.0, 14.765); // object (168)
    CreateDynamicObject(1225, -1312.804, -2297.030, 35.503, 0.0, 0.0, 0.0); // object (169)
    CreateDynamicObject(1225, -1305.140, -2298.444, 33.971, 0.0, 0.0, 0.0); // object (170)
    CreateDynamicObject(1217, -1354.691, -2292.736, 38.744, 0.0, 0.0, 0.0); // object (171)
    CreateDynamicObject(1222, -1354.718, -2291.906, 38.777, 0.0, 0.0, 0.0); // object (172)
    CreateDynamicObject(3374, -1339.644, -2280.119, 37.983, 0.0, 0.0, -22.500); // object (175)
    CreateDynamicObject(3425, -1422.294, -2241.120, 42.887, 0.0, 0.0, 11.250); // object (177)
    CreateDynamicObject(2600, -1362.000, -2324.843, 39.654, 0.0, 0.0, 180.000); // object (179)
    CreateDynamicObject(1476, -1355.966, -2324.834, 40.241, 0.0, 0.0, 180.000); // object (180)
    CreateDynamicObject(1471, -1357.465, -2324.832, 40.247, 0.0, 0.0, 180.000); // object (181)
    CreateDynamicObject(1470, -1358.961, -2324.825, 40.247, 0.0, 0.0, 180.000); // object (182)
    CreateDynamicObject(18367, -1359.695, -2274.733, 35.500, -0.859, 205.406, 191.654); // object (184)
    CreateDynamicObject(2062, -1337.647, -2323.405, 38.687, 0.0, 0.0, 0.0); // object (185)
    CreateDynamicObject(1474, -1356.009, -2326.594, 39.198, 0.0, 0.0, 0.0); // object (186)
    CreateDynamicObject(1474, -1357.519, -2326.608, 39.198, 0.0, 0.0, 0.0); // object (187)
    CreateDynamicObject(1474, -1359.010, -2326.612, 39.198, 0.0, 0.0, 0.0); // object (188)
    CreateDynamicObject(759, -1351.039, -2323.646, 38.357, 0.0, 0.0, 0.0); // object (197)
    CreateDynamicObject(1225, -1357.240, -2322.749, 38.310, -85.944, 0.0, 87.344); // object (204)
    // Converted map: CR Live
    // Converting time: 156 ms
    // Converted vehicles: 5
    // Converted objects: 168
    // Total lines checked: 1048


    //------------------MADE BY KOMPRY - MTA -----------------//



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
    //------------------------
    AddStaticVehicle(522, 2040.105, 1341.658, 10.332, 259.0, -1, -1);
    AddStaticVehicle(522, 2040.151, 1344.618, 10.332, 259.0, -1, -1);
    AddStaticVehicle(522, 2040.051, 1346.566, 10.332, 259.0, -1, -1);
    AddStaticVehicle(409, 2379.6838, 1031.7986, 10.6203, 179.8633, 1, 1); //
    AddStaticVehicle(605, 1844.4413, 1248.1547, 10.6394, 91.5823, 2, 2); //
    AddStaticVehicle(581, 2409.8162, 1020.6308, 10.4183, 356.9659, 87, 1); //
    AddStaticVehicle(581, 2407.7952, 1020.7648, 10.4181, 358.7930, 36, 1); //
    AddStaticVehicle(581, 2405.8110, 1021.1887, 10.4178, 358.7873, 66, 1); //



    //-------------------------------------------------------------------------------
    //Boss


    AddStaticVehicle(411, 1707.4657, 1434.3721, 10.3533, 356.7238, 116, 1); // letiste venturas
    AddStaticVehicle(411, 1708.1104, 1443.7477, 10.4670, 349.7090, 106, 1); // letiste venturas
    AddStaticVehicle(481, 1688.7257, 1445.7723, 10.2836, 279.5629, 46, 46); // kolo venturas letiste
    AddStaticVehicle(481, 1688.4663, 1447.5942, 10.2810, 282.0507, 14, 1); // kolo venturas letiste
    AddStaticVehicle(481, 1688.3223, 1449.2086, 10.2833, 271.8508, 26, 1); // kolo venturas letiste
    AddStaticVehicle(481, 1688.4011, 1450.5739, 10.2743, 274.7141, 3, 3); // kolo venturas letiste
    AddStaticVehicle(481, 1688.3363, 1451.7584, 10.2739, 278.0057, 46, 46); // kolo venturas letiste
    AddStaticVehicle(522, 1696.9905, 1477.3119, 10.3284, 294.7530, 7, 79); // MOTO venturas letiste
    AddStaticVehicle(522, 1696.9918, 1480.0471, 10.3340, 313.0961, 36, 105); // MOTO venturas letiste
    AddStaticVehicle(522, 1696.9917, 1480.0471, 10.3303, 313.0990, 36, 105); // MOTO venturas letiste
    AddStaticVehicle(431, 1727.3485, 1481.0919, 10.7686, 342.4481, 71, 87); // BUs venturas letiste
    AddStaticVehicle(405, 2039.0491, 995.6431, 10.5468, 179.4234, 40, 1); // four dragons
    AddStaticVehicle(409, 2038.7787, 1004.5322, 10.4719, 180.3101, 1, 1); // four dragons
    AddStaticVehicle(405, 2038.8015, 1014.7733, 10.5469, 180.1547, 91, 1); // four dragons
    AddStaticVehicle(519, 1333.9961, 1617.8342, 11.7390, 268.5894, 1, 1); // Letiste venturas vnitrek
    AddStaticVehicle(519, 1332.0784, 1588.6335, 11.7416, 266.8001, 1, 1); // Letiste venturas vnitrek
    AddStaticVehicle(519, 1633.0486, 1547.3411, 11.7233, 46.0568, 1, 1); // Letiste venturas vnitrek
    AddStaticVehicle(519, 1572.8802, 1448.6053, 11.7471, 88.3226, 1, 1); // Letiste venturas vnitrek
    AddStaticVehicle(577, 1582.9418, 1269.7876, 10.7286, 52.0746, 8, 16); // Letiste venturas vnitrek
    AddStaticVehicle(417, 1304.7650, 1410.2708, 10.9384, 273.2145, 0, 0); // Letiste venturas vnitrek
    AddStaticVehicle(417, 1300.7816, 1441.8033, 10.8904, 274.0446, 0, 0); // Letiste venturas vnitrek
    AddStaticVehicle(593, 1285.8500, 1360.9598, 11.2844, 272.0649, 13, 8); // Letiste venturas vnitrek
    AddStaticVehicle(511, 1284.3549, 1324.3623, 12.1943, 269.8205, 34, 51); // Letiste venturas vnitrek
    AddStaticVehicle(475, 1322.5449, 1278.6807, 10.6270, 180.7509, 56, 29); // Letiste venturas vnitrek
    AddStaticVehicle(463, 1312.7643, 1279.2102, 10.3607, 189.8089, 36, 36); // Letiste venturas vnitrek
    AddStaticVehicle(404, 1282.2305, 1294.1544, 10.5546, 89.7916, 119, 50); // Letiste venturas vnitrek
    AddStaticVehicle(513, 1573.4563, 1632.8821, 11.3643, 142.1108, 51, 6); // Letiste venturas vnitrek
    AddStaticVehicle(513, 1558.9230, 1645.2474, 11.3695, 136.1284, 21, 36); // Letiste venturas vnitrek
    AddStaticVehicle(513, 1551.3788, 1657.7781, 11.3638, 103.9002, 30, 34); // Letiste venturas vnitrek
    AddStaticVehicle(513, 1586.0459, 1626.0530, 11.3645, 164.8137, 55, 20); // Letiste venturas vnitrek
    AddStaticVehicle(513, 1571.3127, 1644.6924, 11.3660, 136.8022, 51, 6); // Letiste venturas vnitrek
    AddStaticVehicle(480, 1703.7491, 1619.5308, 10.1593, 155.0648, 53, 53); // Letiste venturas vnitrek
    AddStaticVehicle(479, 1698.7765, 1622.2445, 10.5292, 151.8812, 27, 36); // Letiste venturas vnitrek
    AddStaticVehicle(474, 1694.0846, 1625.0941, 10.5830, 144.6756, 105, 1); // Letiste venturas vnitrek
    AddStaticVehicle(497, 2295.3979, 2443.8813, 47.1600, 178.3152, 0, 1); // POLICIE VRTULASI
    AddStaticVehicle(497, 2284.0427, 2441.3237, 47.1573, 0.9358, 0, 1); // POLICIE VRTULASI
    AddStaticVehicle(497, 2273.2456, 2444.4827, 47.1478, 185.3554, 0, 1); // POLICIE VRTULASI

    AddStaticVehicle(579, 2588.1018, -944.3834, 81.3247, 191.4354, 62, 62); // off road
    AddStaticVehicle(579, 2591.4219, -943.5134, 81.3322, 194.7983, 10, 10); // off road
    AddStaticVehicle(579, 2594.3972, -942.7399, 81.2430, 192.6938, 15, 15); // off road
    AddStaticVehicle(579, 2588.2163, -968.2394, 81.3225, 277.1459, 42, 42); // off road
    AddStaticVehicle(579, 2590.2410, -951.2093, 81.3075, 192.8260, 62, 62); // off road
    AddStaticVehicle(579, 2594.4514, -950.1075, 81.3275, 193.0102, 10, 10); // off road
    AddStaticVehicle(500, 2577.2266, -971.1443, 81.4824, 5.9593, 25, 119); // off road
    AddStaticVehicle(500, 2573.6101, -972.0602, 81.6890, 9.6057, 13, 119); // off road
    AddStaticVehicle(500, 2570.4070, -972.2739, 81.9880, 9.5686, 75, 84); // off road
    AddStaticVehicle(468, 2579.7830, -970.9474, 81.0274, 8.1648, 6, 6); // off road
    AddStaticVehicle(468, 2593.8870, -968.8467, 81.0205, 8.0766, 53, 53); // off road
    AddStaticVehicle(468, 2597.9978, -968.3833, 80.8931, 5.0265, 6, 6); // off road
    AddStaticVehicle(468, 2595.6707, -968.3954, 80.9645, 12.2957, 53, 53); // off road
    AddStaticVehicle(468, 2600.0435, -967.9568, 80.7797, 17.2735, 53, 53); // off road

    AddStaticVehicle(411, 2351.7466, 1405.1989, 10.5505, 269.5594, 106, 1); // garaz
    AddStaticVehicle(411, 2351.6194, 1408.6191, 10.5505, 270.5017, 64, 1); // garaz
    AddStaticVehicle(411, 2351.9487, 1411.8346, 10.5505, 269.2871, 106, 1); // garaz
    AddStaticVehicle(411, 2351.4678, 1415.7719, 10.5505, 271.7662, 64, 1); // garaz
    AddStaticVehicle(451, 2351.9185, 1419.2119, 10.5307, 270.6961, 61, 61); // garaz


    //-------------------------------------------------------------------------------------------
    //HAJATI
    AddStaticVehicle(406, 1372.0599, -1888.5458, 15.0201, 359.8915, 1, 1); //
    AddStaticVehicle(601, 2282.3809, 2476.7578, 10.5791, 180.6260, 1, 1); //
    AddStaticVehicle(599, 2277.5945, 2476.6782, 11.0094, 179.9791, 0, 1); //
    AddStaticVehicle(599, 2277.2668, 2443.8179, 11.0103, 358.9673, 0, 1); //
    AddStaticVehicle(598, 2278.3423, 2416.9207, 10.4326, 90.6088, 0, 1); //
    AddStaticVehicle(598, 2289.3726, 2416.9402, 10.4750, 90.7897, 0, 1); //
    AddStaticVehicle(597, 2255.8340, 2458.6948, 10.5896, 2.2111, 0, 1); //


    AddStaticVehicle(427, 2251.6208, 2475.5220, 10.9521, 178.5989, 0, 1); //
    AddStaticVehicle(427, 2291.0657, 2443.8220, 10.9549, 2.5235, 0, 1); //
    AddStaticVehicle(585, 2142.0415, 1006.5154, 10.4056, 89.5371, 62, 62); //
    AddStaticVehicle(581, 2142.3408, 1019.1952, 10.4126, 90.0508, 66, 1); //
    AddStaticVehicle(580, 2172.1748, 1025.8055, 10.6162, 270.2493, 67, 67); //
    AddStaticVehicle(566, 2172.1506, 1019.2934, 10.6000, 88.8206, 95, 1); //
    AddStaticVehicle(565, 2162.8140, 1016.2005, 10.4465, 272.5718, 62, 62); //
    AddStaticVehicle(561, 2142.6189, 1025.8116, 10.6337, 88.6019, 43, 21); //

    AddStaticVehicle(588, 1937.7334, 1395.4403, 9.1546, 320.6901, 1, 1); // nwmmm
    AddStaticVehicle(545, 1943.2976, 1366.3328, 8.9202, 181.1409, 40, 96); // nwmm
    AddStaticVehicle(603, 2169.1453, 1114.3914, 12.3971, 332.9957, 75, 77); // nwm
    AddStaticVehicle(586, 2456.0103, 1286.6018, 10.3339, 3.0928, 25, 1); // moto u baráku

    AddStaticVehicle(608, 1530.6556, 1190.6989, 11.3453, 0.0001, 1, 1); // www
    AddStaticVehicle(601, 1559.2065, 1161.7305, 10.5634, 359.4489, 1, 1); // ww
    AddStaticVehicle(601, 1567.6467, 1161.3405, 10.5638, 360.0000, 1, 1); // w
    AddStaticVehicle(601, 1563.3978, 1161.1917, 10.5773, 359.9292, 1, 1); // vvv
    AddStaticVehicle(407, 1571.9799, 1161.8931, 11.0418, 2.1316, 3, 1); // vv
    AddStaticVehicle(407, 1576.1803, 1162.1091, 11.0389, 2.0883, 3, 1); // v

    AddStaticVehicle(605, 2087.3149, 1460.4913, 10.6245, 345.2599, 67, 8); // 1
    AddStaticVehicle(602, 2423.6025, 1146.2777, 10.4779, 180.3826, 75, 77); // 2
    AddStaticVehicle(589, 2351.1174, 1501.6195, 10.4784, 270.6555, 7, 7); // 3
    AddStaticVehicle(587, 2351.7122, 1487.3732, 10.5455, 271.1997, 53, 1); // 4
    AddStaticVehicle(585, 2351.5193, 1490.7429, 10.4041, 269.3290, 53, 53); // 5
    AddStaticVehicle(580, 2351.9956, 1476.3799, 10.6165, 270.4769, 67, 67); // 6
    AddStaticVehicle(579, 2350.9351, 1472.7313, 10.7543, 91.8873, 62, 62); // 7
    AddStaticVehicle(576, 2351.0713, 1458.4519, 10.4290, 89.2360, 74, 8); // 8
    AddStaticVehicle(576, 2351.4885, 1440.6265, 10.4334, 269.5279, 74, 8); // 9
    AddStaticVehicle(575, 2352.0901, 1447.8015, 10.4256, 272.1600, 25, 96); // 10
    AddStaticVehicle(571, 2272.1382, 1385.5864, 42.1042, 2.7126, 40, 35); // 11
    AddStaticVehicle(571, 2273.9817, 1385.6183, 42.1039, 359.3380, 36, 2); // 12
    AddStaticVehicle(571, 2275.8926, 1385.6545, 42.1040, 0.5967, 91, 2); // 13
    AddStaticVehicle(571, 2269.5225, 1392.0181, 42.1044, 1.3084, 2, 35); // 14
    AddStaticVehicle(571, 2271.9255, 1392.4990, 42.1042, 358.1568, 51, 53); // 15
    AddStaticVehicle(571, 2273.6775, 1392.4683, 42.1040, 0.9704, 91, 2); // 16
    AddStaticVehicle(571, 2275.7869, 1392.4569, 42.1046, 356.1782, 40, 35); // 17

    AddStaticVehicle(560, -2795.7339, -121.0982, 6.8574, 90.6723, 2, 1); // 1
    AddStaticVehicle(560, -2691.9761, 204.5431, 3.9995, 0.1673, 6, 1); // 2
    AddStaticVehicle(560, -2266.5076, 121.3087, 34.8284, 268.9907, 3, 1); // 3
    AddStaticVehicle(579, -2184.4077, 293.1379, 35.0848, 358.2932, 3, 3); // 4
    AddStaticVehicle(402, -1956.7057, 305.2405, 40.8751, 177.0687, 0, 3); // 6
    AddStaticVehicle(415, -1952.4701, 258.6288, 40.8238, 88.9323, 25, 1); // 7
    AddStaticVehicle(562, -1952.4683, 263.0709, 40.7076, 90.3869, 35, 1); // 8
    AddStaticVehicle(565, -1952.5840, 268.5277, 40.6896, 90.9275, 53, 53); // 9
    AddStaticVehicle(496, 652.8029, 1698.4017, 6.6533, 310.5625, 250, 101); // 10
    AddStaticVehicle(581, 435.9633, 2537.2192, 15.8692, 94.1647, 186, 75); // 11
    AddStaticVehicle(477, 425.9083, 2544.6746, 16.0417, 88.7763, 185, 39); // 12
    AddStaticVehicle(475, 414.6477, 2532.1875, 16.3424, 267.1475, 32, 165); // 13



    //------------------------------------------------------------------------------------------
    //Chack
    AddStaticVehicle(534, 2093.5459, 2157.6160, 10.5441, 358.5436, 53, 53); //
    AddStaticVehicle(534, 2080.6294, 2158.0891, 10.5433, 359.9919, 62, 62); //
    AddStaticVehicle(579, 1248.6991, -806.0133, 84.0723, 180.4498, 62, 62); //
    AddStaticVehicle(603, 1423.5546, -881.6712, 50.2973, 0.5547, 18, 1); //
    AddStaticVehicle(603, 1423.5548, -881.6707, 50.2981, 0.5660, 18, 1); //
    AddStaticVehicle(405, 2510.0908, -1671.7053, 13.2852, 346.1132, 75, 1); //
    AddStaticVehicle(405, 2510.0908, -1671.7053, 13.2852, 346.1132, 75, 1); //
    AddStaticVehicle(405, 1464.8967, -901.7821, 54.7142, 359.5529, 75, 1); //
    AddStaticVehicle(402, 1528.5540, -813.5322, 71.6205, 271.3222, 39, 39); //
    AddStaticVehicle(427, 1497.1135, -696.7408, 94.8819, 91.5784, 0, 1); //
    AddStaticVehicle(445, 1460.5386, -632.6729, 95.6466, 179.0355, 37, 37); //
    AddStaticVehicle(451, 1337.2939, -1125.8040, 23.4687, 176.5716, 36, 36); //
    AddStaticVehicle(426, 1314.7368, -1411.4272, 13.1268, 89.8783, 53, 53); //
    AddStaticVehicle(405, 1078.8638, -943.4752, 42.6225, 97.3053, 75, 1); //
    AddStaticVehicle(587, 1889.9089, -1757.9772, 13.1890, 269.7582, 43, 1); //
    AddStaticVehicle(415, 1876.3981, 1179.6964, 10.6021, 0.4130, 36, 1); //
    AddStaticVehicle(445, 1886.0162, 1180.0969, 10.7031, 180.0130, 37, 37); //
    AddStaticVehicle(434, 1913.0947, 697.9313, 10.7820, 358.3806, 6, 6); //
    AddStaticVehicle(451, 1929.2423, 698.1835, 10.5297, 180.1301, 36, 36); //
    AddStaticVehicle(429, 1938.8356, 698.1643, 10.5050, 359.7591, 2, 1); //
    AddStaticVehicle(426, 1925.9933, 708.4312, 10.5897, 0.2086, 7, 7); //
    AddStaticVehicle(421, 1913.1555, 708.7736, 10.7117, 359.8270, 36, 1); //
    AddStaticVehicle(579, 1882.0939, 957.2076, 10.7549, 269.0636, 15, 15); //
    AddStaticVehicle(560, 1880.9763, 982.1381, 10.5257, 269.7756, 37, 0); //
    AddStaticVehicle(560, 1881.0511, 1013.2974, 10.5255, 269.8147, 56, 29); //
    AddStaticVehicle(579, 1882.0300, 963.7077, 10.7483, 270.5491, 62, 62); //
    AddStaticVehicle(579, 1882.0275, 954.0338, 10.7529, 269.6631, 15, 15); //
    AddStaticVehicle(522, 2215.20, 1263.36, 10.82, 0, 0, 0); //moto
    AddStaticVehicle(522, 2215.04, 1261.42, 10.82, 0, 0, 0); //moto2
    AddStaticVehicle(522, 2215.66, 1259.38, 10.82, 0, 0, 0); //moto3
    AddStaticVehicle(522, 2215.68, 1256.53, 10.82, 0, 0, 0); //moto4
    AddStaticVehicle(603, 2249.19, 1261.59, 10.82, 0, 0, 0); //fínix
    AddStaticVehicle(603, 2249.14, 1256.81, 10.81, 0, 0, 0); //fínix 2
    AddStaticVehicle(603, 2660.19, 1173.02, 10.66, 0, 0, 0); //phoenix
    AddStaticVehicle(448, 2096.0518, -1812.6667, 12.9671, 90.8525, 3, 6); //
    AddStaticVehicle(448, 2096.0674, -1814.0520, 12.9767, 90.9450, 3, 6); //
    AddStaticVehicle(448, 2096.0898, -1815.1420, 12.9694, 84.8328, 3, 6); //
    AddStaticVehicle(448, 2096.0994, -1816.2047, 12.9754, 86.4761, 3, 6); //
    AddStaticVehicle(466, 2115.8135, -1782.2570, 13.1303, 178.8026, 2, 76); //
    AddStaticVehicle(480, 2110.0852, -1783.2638, 13.1620, 179.0197, 6, 6); //
    AddStaticVehicle(408, 2861.3445, -2049.9368, 11.4825, 358.4635, 26, 26); //
    AddStaticVehicle(408, 2861.5190, -2038.8027, 11.4801, 0.1247, 26, 26); //
    AddStaticVehicle(408, 2861.3423, -2027.7723, 11.4880, 0.3243, 26, 26); //
    AddStaticVehicle(604, 2862.6074, -1996.9855, 10.7223, 329.7362, 16, 76); //
    AddStaticVehicle(495, 2373.8804, -1928.1426, 13.5149, 0.1294, 118, 117); //
    AddStaticVehicle(427, 1601.5320, -1605.8014, 13.6134, 89.6029, 0, 1); //
    AddStaticVehicle(601, 1602.0303, -1692.1196, 5.6494, 272.3871, 1, 1); //
    AddStaticVehicle(601, 1602.0303, -1692.1196, 5.6494, 272.3870, 1, 1); //
    AddStaticVehicle(601, 1602.1957, -1696.0555, 5.6494, 271.2098, 1, 1); //

    AddStaticVehicle(596, 1595.5342, -1711.0197, 5.6145, 178.9316, 0, 1); //
    AddStaticVehicle(596, 1587.5128, -1711.0092, 5.6127, 357.8445, 0, 1); //
    AddStaticVehicle(596, 1590.9025, -1711.3728, 5.5903, 176.9570, 0, 1); //
    AddStaticVehicle(528, 1578.7892, -1710.7571, 5.9352, 177.5343, 0, 0); //

    //-------------------------
    Hodiny = TextDrawCreate(547.0, 24.0, "nacitani");
    TextDrawLetterSize(Hodiny, 0.6, 1.8);
    TextDrawFont(Hodiny, 3);
    TextDrawSetOutline(Hodiny, 1);
    //------------
    SetTimer("THodiny", 60000, 1);
    //*******************************************
    SetTimer("Reklama", 1000 * 60 * 2, true); //1OOO milisekund * 60 = 1 minuta * 2 = 2 minuty :) xD

    //----SPZ--AUTA
    for (new i = 0; i < MAX_VEHICLES; i++)
    {
        SetVehicleNumberPlate(i, "CRL MOD");
    }
    return 1;
}

//--------------------------[ MAIN GAMEMODE INIT ]----------------------------//

public OnGameModeExit()
{
    print("\n +-----------------------------+");
    print("   | Mode CRLive is Shuting DOwn |");
    print(" +-----------------------------+ \n");
    KillTimer(SetTimer("Reklama", 1000 * 60 * 2, true));
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
    if (!PLAYERLIST_authed[playerid])
    {
        if (udb_Exists(PlayerName(playerid)))
        {
            GameTextForPlayer(playerid, "~w~Prihlas se!", 5000, 5);
            SCM(playerid, COLOR_SVZEL, "Nejsi prihlaseny, napi /login heslo");
        }
        else
        {
            GameTextForPlayer(playerid, "~r~Registruj se!", 5000, 5);
            SCM(playerid, COLOR_SVZEL, "Nejsi registrovany, napis /register heslo");
        }
        return 0;
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    new pName[MAX_PLAYER_NAME];
    new string[68];
    skore[playerid] = 0;
    hrajepaint[playerid] = 0;
    TextDrawShowForPlayer(playerid, Hodiny);
    SCM(playerid, GREEN, "Cus, vítej v mode CRLive ;) /cmd /acmd /help /rules");
    PLAYERLIST_authed[playerid] = false;
    SendDeathMessage(playerid, INVALID_PLAYER_ID, 200);
    GetPlayerName(playerid, pName, sizeof(pName));
    format(string, sizeof(string), "[ i ] Èus xD! %s doel na server za námi xD", pName); // co to ma napsat
    SendClientMessageToAll(COLOR_SEDA, string); // oznameni :D
    return false;
}

public OnPlayerDisconnect(playerid, reason)
{
    Object_OnPlayerDisconnect(playerid, reason);
    TextDrawHideForPlayer(playerid, KPH[playerid]);
    new string[90], Jmeno[30];


    if (PLAYERLIST_authed[playerid])
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
    PLAYERLIST_authed[playerid] = false;
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
    if (hrajepaint[playerid] == 1)
    {
        SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);
        GivePlayerWeapon(playerid, 29, 999);//zbran
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    new text[256];
    SendDeathMessage(killerid, playerid, reason);
    if (hrajepaint[playerid] == 1)
    {
        skore[killerid] ++;
        if (skore[killerid] > vytezskore)
        {
            new killer[MAX_PLAYER_NAME];
            vytez = killerid;
            vytezskore = skore[killerid];
            GetPlayerName(killerid, killer, sizeof(killer));
            for (new i = 0; i < MAX_PLAYERS; i++)
            {
                format(text, sizeof(text), "[ i ] %s je ve vedení ! [ Score: %d ].", killer, vytezskore); //text kdo je ve vedeni podle skore :)
                SendClientMessage(playerid, COLOR_BILA, text);
            }
        }
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
            MoveObject(vytah, 2303.207, 1174.944, 80.285, 3.0);
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
            MoveObject(vytah, 2303.207, 1174.944, 11.260, 3.0);
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
                SetTimer("startpaint", 10000, 0);
                hrajepaint[i] = 1;
            }
        }
        return 1;
    }
    //----------------------------------------
    if (strcmp("/paintexit", cmdtext, true, 10) == 0)
    {
        new string[256];
        if (hrajepaint[playerid])
        {
            format(string, 256, "[ ! ] %s opousti paintball, /paintexit", playerid);
            SendClientMessageToAll(COLOR_ZLUTA, string);
            SetPlayerHealth(playerid, 0.0);
            hrajepaint[playerid] = 0;
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

public Reklama()
{
    new text_reklamy = random(5);//vygeneruje nahodu z 5

    switch (text_reklamy)
    {
        case 0://kdyz nahoda = 0
        {
            SendClientMessageToAll(COLOR_SVZEL, " [TIP] Pro pomoc a dalsi info napiste /help :)");
        }

        case 1://kdyz nahoda = 1
        {
            SendClientMessageToAll(COLOR_SVZEL, " [TIP] Pro sebevrazdu napis /kill xD");
        }

        case 2://kdyz nahoda = 2............
        {
            SendClientMessageToAll(COLOR_SVZEL, " [TIP] Po mapì v LS jsou skrytì balíèky(malá zelená soka) více informací ... /soska ");
        }

        case 3: //kdyz 4?
        {
            SendClientMessageToAll(COLOR_SVZEL, " [INFO] Sponzori: http://athostik.xf.cz | http://kyrspa.wz.cz | http://stunt-server.7x.cz | hosted.czfree-ra.net");
        }
        case 4:
        {
            SendClientMessageToAll(COLOR_SVZEL, " [TIP] Zahrej si s kamaradi paintball v paintball arene ! /paintball, /paintexit ");
        }
    }//uzavreni switch

    return true;
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
}//konec

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
            if (PLAYERLIST_authed[playerid])
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

public THodiny()
{
    new hodina, minuta, s, string[256];
    gettime(hodina, minuta, s);
    if (minuta <= 9)
    {
        format(string, 25, "%d:0%d", hodina, minuta);
    }
    else
    {
        format(string, 25, "%d:%d", hodina, minuta);
    }
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        TextDrawHideForPlayer(i, Hodiny);
        TextDrawSetString(Hodiny, string);
        TextDrawShowForPlayer(i, Hodiny);
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

public startpaint()
{
    vytez = 999;
    vytezskore = 0;
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i))
        {
            ResetPlayerWeapons(i);
            GivePlayerWeapon(i, 29, 999);
            TogglePlayerControllable(i, 1);
            SendClientMessage(i, COLOR_ZLUTA, "[ ! ] Paintball zaèal, 4 minuty do konce.");
            PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);//xD
            SetTimer("konecpaint", 240000, 0);
        }
    }
    return 1;
}

public konecpaint()
{

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
