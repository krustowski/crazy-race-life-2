#if defined _CRL2_I18N
	#endinput
#endif
#define _CRL2_I18N

//
//  i18n.pwn
//

#define COLOR_GREEN           	0x21DD00FF
#define COLOR_GREEN2 		0x008000AA
#define COLOR_LIGHTGREEN     	0x29FF06AA
#define COLOR_ORANGE          	0xF97804FF
#define COLOR_ORANGE2		0xFF8C00AA
#define COLOR_ORANGERED 	0xFF4500AA
#define COLOR_RED             	0xE60000FF
#define COLOR_RED2		0xFF0000AA
#define COLOR_BLUE      	0x0000BBAA
#define COLOR_BLUE2      	0x4682B4AA
#define COLOR_BLUE3      	0x4169FFAA
#define COLOR_CYAN 		0x00FFFFAA
#define COLOR_YELLOWGREEN	0xADFF2FAA
#define COLOR_DARKCYAN		0x008B8BAA
#define COLOR_WHITE		0xFFFFFFAA
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_LEMON 		0xFFFF00AA
#define COLOR_BROWN 		0xA52A2AAA
#define COLOR_BROWN2		0xBC8F8FAA
#define COLOR_GREY 		0x808080AA
#define COLOR_PINK		0xFFC0CBAA
#define COLOR_CHARTR		0x7FFF00AA
#define COLOR_SYSTEM    	0xEFEFF7AA
#define COLOR_INVISIBLE 	0x4682B400
#define COLOR_BEIGE          	0xFFF8DCAA

enum PlayerLocale
{
	LOCALE_EN,
	LOCALE_CZ
}

enum 
{
	I18N_WELCOME_MESSAGE,
	I18N_SERVER_RESTART_COUNTDOWN,
	I18N_PLAYER_NOT_IN_VEHICLE,
	I18N_PLAYER_NOT_DRIVER,
	I18N_PLAYER_NOT_CONNECTED,
	I18N_PLAYER_ID_INVALID,
	I18N_NO_SUCH_COMMAND,
	I18N_CMD_USAGE_FMT,
	I18N_LOW_ADMIN_LEVEL,
	I18N_VEHICLE_ID_MISMATCH,
	I18N_SPECTATE_DISABLED,
	I18N_SPECTATE_ENABLED,
	I18N_SKIN_ID_MISMATCH,
	I18N_PACKET_LOSS_FMT,
	I18N_ADMIN_LVL_SET_MISMATCH,
	I18N_ADMIN_LVL_SET_SAME,
	I18N_ADMIN_LVL_SET_FMT,
	I18N_PLAYER_KICK_FMT,
	I18N_PLAYER_BAN_FMT,
	I18N_PLAYER_HP_SET,
	I18N_DRUNK_LEVEL_INVALID,
	I18N_DRUNK_LEVEL_SET,
	I18N_CRIME_LEVEL_INVALID,
	I18N_CLEAR_CHAT_INFO,
	I18N_CAM_ATTACHED_ID_FMT,
	I18N_CAM_DETACHED,
	I18N_ADMINCOL_FMT,
	I18N_TEAM_RELATED_CMD_POLICE,
	I18N_TEXT_PLAYER_FMT,
	I18N_SKYDIVE,
	I18N_SEARCH_CMD_PROXIMITY,
	I18N_SEARCH_DRUNK_POSITIVE,
	I18N_SEARCH_DRUNK_POSITIVE_PLAYER,
	I18N_SEARCH_DRUNK_BONUS_FMT,
	I18N_SEARCH_DRUNK_NEGATIVE,
	I18N_SEARCH_DRUNK_NEGATIVE_PLAYER,
	I18N_IN_PROPERTY_BLOCK,
	I18N_IN_MINIGAME_BLOCK,
	I18N_LOCATE_COORDS_FMT,
	I18N_ANIMATION_VEHICLE_BLOCK,
	I18N_KILL_CMD_FMT,
	I18N_TEAM_RELATED_CMD_ADMINZ,
	I18N_HIDE_CMD_APPLIED,
	I18N_HIDE_CMD_REVERTED,
	// Radar (vehicle stats)
	I18N_HID_STATS_GREEN_FMT,
	I18N_HID_STATS_RED_FMT,
	I18N_RADAR_FEE_FMT,
	// Admin elevator
	I18N_AE_MOVE_UP,
	I18N_AE_MOVE_DOWN,
	I18N_AE_MOVE_STOP,
	// Black Market
	I18N_BLACK_MARKET_RATIO_UPDATE,
	// User data load
	I18N_USER_DATA_LOAD,
	I18N_USER_DATA_LOAD_SUCCESS,
	// Autosave
	I18N_AUTOSAVE_START,
	I18N_AUTOSAVE_SUCCESS,
	// Private messages
	I18N_PRIV_MSG_MONEY,
	I18N_PRIV_MSG_NO_PLAYER,
	// Racing
	I18N_RACE_WARP_NO_RACE,
	I18N_RACE_WARP_AFTER_START,
	I18N_RACE_WARP_NO_VEHIC_DRIVER,
	I18N_RACE_ENDED_PREMATURELY,
	I18N_RACE_ENDED_SUCCESSFULLY,
	I18N_RACE_NO_RACE,
	I18N_RACE_NO_SUCH_RACE,
	I18N_RACE_ALREADY_JOINED,
	I18N_RACE_NO_MONEY,
	// Deathmatch
	I18N_DEATHMATCH_STARTED,
	I18N_DEATHMATCH_INGAME_BLOCK,
	// Player
	I18N_DEATH_MONEY_LOCALITY,
	// Real estate
	I18N_REAL_VEHMOD_SAVED,
	I18N_REAL_INVALID_CODE,
	I18N_REAL_SELL_PICKUP_MISLOC,
	I18N_REAL_SELL_NOT_OCCUPIED,
	I18N_REAL_SELL_NOT_OWNED,
	I18N_REAL_PROPERTY_ACQ,
	I18N_REAL_INTERIOR_GEN_FAIL,
	I18N_REAL_NO_FREE_SLOT,
	I18N_REAL_ALREADY_OCCUPIED,
	I18N_REAL_NO_MONEY,
	I18N_REAL_SELL_SUCCESS,
	// Taxi
	I18N_TAXI_MISS_WRONG_VEHICLE,
	I18N_TAXI_MISS_NPC_ENTERING,
	I18N_TAXI_MISS_COMMISSION,
	I18N_TAXI_MISS_DB_READ_ERROR,
	I18N_TAXI_MISS_TOO_MANY_CUSTOMERS,
	I18N_TAXI_MISS_MINIGAME_COLLISION,
	I18N_TAXI_MISS_INFO,
	I18N_TAXI_MISS_EXIT_VEHICLE,
	I18N_TAXI_MISS_NEXT_DESTINATION,
	I18N_TAXI_MISS_START,
	I18N_TAXI_MISS_ABORT,
	// Tow
	I18N_TOW_MISS_INFO
}

new gI18nMessageColor[] = 
{
	COLOR_GREEN,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_GREY,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_BLUE,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED2,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	// Radar (vehicle stats)
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	// Admin elevator
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	// Black Market
	COLOR_ORANGE,
	// User data load
	COLOR_YELLOW,
	COLOR_GREEN,
	// Autosave
	COLOR_YELLOW,
	COLOR_GREEN,
	// Private messages
	COLOR_RED,
	COLOR_RED,
	// Racing
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_RED,
	// Deathmatch
	COLOR_YELLOW,
	COLOR_RED,
	// Player
	COLOR_YELLOW,
	// Real estate
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	// Taxi
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_INVISIBLE,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	// Tow
	COLOR_INVISIBLE
};

new gI18nMessages[][PlayerLocale][] = 
{
	{
		"Welcome to the gamemode CrazyRaceLife2! /help",
		"Vitej ve hre! /help"
	},
	{
		"[ RESTART ] Server restarts in %d seconds!",
		"[ RESTART ] Za %d sekund dojde k restartu serveru!"
	},
	{
		"[ ! ] Such player not in a vehicle!",
		"[ ! ] Hrac se nenachazi ve vozidle!"
	},
	{
		"[ ! ] Such player not driving/riding a vehicle!",
		"[ ! ] Hrac neni ridicem ve vozidle!"
	},
	{
		"[ ! ] The player is not connected!",
		"[ ! ] Hrac neni pripojen ke hre!"
	},
	{
		"[ ! ] Invalid player ID!",
		"[ ! ] Neplatne ID hrace!"
	},
	{
		"[ CMD ] No such command! /cmd /help /rules",
		"[ CMD ] Tento prikaz neexistuje! /cmd /help /rules"
	},
	{
		"[ CMD ] Usage: %s",
		"[ CMD ] Pouziti prikazu: %s"
	},
	{
		"[ CMD ] Admin level too low!",
		"[ CMD ] Pro dany prikaz nemas opravneni!"
	},
	{
		"[ CMD ] Invalid vehicle model ID! (Model IDs: 400-611)",
		"[ CMD ] Neplatne ID modelu vozidla! (Pouzij ID z rozmezi 400-611)"
	},
	{
		"[ SPECTATE ] Mode disabled!",
		"[ SPECTATE ] Spehovani vypnuto!"
	},
	{
		"[ SPECTATE ] Mode enabled!",
		"[ SPECTATE ] Spehovani zapnuto!"
	},
	{
		"[ CMD ] Invalid skin ID!",
		"[ CMD ] Neplatne ID skinu!"
	},
	{
		"[ NET ] Player ID: %d, packet loss: %.2f %%",
		"[ NET ] ID hrace: %d, ztrata paketu: %.2f %%"
	},
	{
		"[ ADMIN ] You can only set the same or lower level that you have got yourself!",
		"[ ADMIN ] Muzes nastavit pouze stejny nebo nizsi level nez jaky sam mas!"
	},
	{
		"[ ADMIN ] No need to change such admin level!",
		"[ ADMIN ] Neni potreba menit jiz nastaveny stejny level!"
	},
	{
		"[ ADMIN ] Admin %s set player %s [ ID: %d ] an Admin (level %d)!",
		"[ ADMIN ] Admin %s nastavil hrace %s [ ID: %d ] adminem (level %d)!"
	},
	{
		"[ KICK ] Admin %s [ID: %d] kicked player %s [ID: %d] from server!",
		"[ KICK ] Admin %s [ID: %d] vykopl hrace %s [ID: %d] ze hry!"
	},
	{
		"[ BAN ] Admin %s [ID: %d] banned player %s [ID: %d] from server!",
		"[ BAN ] Admin %s [ID: %d] zakazal hraci %s [ID: %d] pristup do hry!"
	},
	{
		"[ HP ] Health: 100.0, armour: 100.0",
		"[ HP ] Zdravi: 100.0, vesta: 100.0"
	},
	{
		"[ DRUGZ ] Invalid level, use a number from range 0-50000",
		"[ DRUGZ ] Neplatny level, pouzij cislo z rozmezi 0-50000"
	},
	{
		"[ DRUGZ ] Your drunk level changed!",
		"[ DRUGZ ] Zmenil se level opilstvi!"
	},
	{
		"[ CMD ] Invalid input (crime IDs: 3-22)",
		"[ CMD ] Neplatne ID zlocinu (rozmezi ID je 3-22)"
	},
	{
		"[ CLEAR ] Chat history flushed!",
		"[ CLEAR ] Historie chatu byla smazana!"
	},
	{
		"[ CAM ] Camera No. %d attached [/ccmd /camoff]",
		"[ CAM ] Kamera cislo %d pripojena [/ccmd /camoff]"
	},
	{
		"[ CAM ] Camera dettached [/ccmd]",
		"[ CAM ] Kamera odpojena [/ccmd]"
	},
	{
		"[ COL ] Player label color set to %s!",
		"[ COL ] Barva stitku hrace zmenena na %s!"
	},
	{
		"[ CMD ] Police team-related command!",
		"[ CMD ] Tento prikaz je urcen pouze pro team policistu!"
	},
	{
		"Player %s says to player %s: %s",
		"Hrac %s vzkazuje hraci %s: %s"
	},
	{
		"[ SKYDIVE ] Enjoy the skydive!",
		"[ SKYDIVE ] Uzij si seskok!"
	},
	{
		"[ ! ] You need to be closer to the player to search them",
		"[ ! ] Potrebujes byt hraci blize, abys mohl provest prohlidku"
	},
	{
		"[ DRUGZ ] Player is drunk driving! The player is fined $25000",
		"[ DRUGZ ] Hrac ridi opily! Hrac zaplati pokutu $25000"
	},
	{
		"[ DRUGZ ] You have been fined $25000 for drunk driving, your vehicle has been confiscated",
		"[ DRUGZ ] Za rizeni pod vlivem zaplatis pokutu $25000, vozidlo bylo odstaveno"
	},
	{
		 "[ CASH ] Received a bonus of $%d!",
		 "[ CASH ] Ziskana odmena $%d!"
	},
	{
		"[ DRUGZ ] You have used a breathalyzer, the player is sober",
		"[ DRUGZ ] Hraci byl podan alkoholtester, hrac je strizlivy"
	},
	{
		"[ DRUGZ ] You have just been tested for intoxication and you passed",
		"[ DRUGZ ] Byl ti podan alkoholtester, jsi strizlivy"
	},
	{
		"[ ! ] Leave the property to be able to use such command!",
		"[ ! ] Pred pouzitim daneho prikazu musis opustit nemovitost!"
	},
	{
		"[ ! ] You cannot use such command while in minigame!",
		"[ ! ] Pred pouzitim daneho prikazu musis ukoncit aktualne spustenou minihru"
	},
	{
		"[ COORDS ] Current location coordinates: Interior No. %d, X[%.2f], Y[%.2f], Z[%.2f], Rotation/Angle[%.2f]",
		"[ COORDS ] Souradnice aktualni polohy: Interier cislo %d, X[%.2f], Y[%.2f], Z[%.2f], Rotace/Uhel[%.2f]"
	},
	{
		"[ ! ] Animation allowed outside the vehicle only!",
		"[ ! ] Musis byt venku z vozidla pro pouziti teto animace!"
	},
	{
		"[ i ] Player %s has just committed a suicide! [ /kill ]",
		"[ i ] Hrac %s prave spachal sebevrazdu!  [ /kill ]!"
	},
	{
		"[ CMD ] Adminz-only team-related command!",
		"[ CMD ] Prikaz je urcen pouze pro cleny teamu Adminz!"
	},
	{
		"[ HIDE ] Player color set to invisible!",
		"[ HIDE ] Hracsky stitek zneviditelnen pro ostatni hrace!"
	},
	{
		"[ HIDE ] Player color set to visible!",
		"[ HIDE ] Hracsky stitek zviditelnen pro ostatni hrace!"
	},
	//
	//  Radar (vehicle stats)
	//
	{
		"~w~Health:____%3d_%%~n~~w~Velocity:__~g~~h~%3d",
		"~w~Stav:______%3d_%%~n~~w~Rychlost:__~g~~h~%3d"
	},
	{
		"~w~Health:____%3d_%%~n~~w~Velocity:__~r~~h~%3d",
		"~w~Stav:______%3d_%%~n~~w~Rychlost:__~r~~h~%3d"
	},
	{
		"[ SPEED ] Vehicle speed too high (%3d km/h)! Fee amount: $%d",
		"[ SPEED ] Jedes prilis rychle (%3d km/h)! Pokuta: $%d"
	},
	//
	//  Admin elevator
	//
	{
		"[ AE ] Admin elevator goes up!",
		"[ AE ] Vytah adminu se rozjel nahoru!"
	},
	{
		"[ AE ] Admin elevator goes down!",
		"[ AE ] Vytah adminu se rozjel dolu!"
	},
	{
		"[ AE ] Admin elevator stopped due to a technical malfunction!",
		"[ AE ] Vytah admin se zasekl kvuli poruse zarizeni!"
	},
	//
	//  Black Market
	//
	{
		"[ MARKET ] Market token-to-dollar ratio changed to: %.3f",
		"[ TRH ] Kurz token ku dolaru na trhu se zmenil: %.3f"
	},
	{
		"[ DATA ] Loading user data...",
		"[ DATA ] Nacitam ulozena uzivatelska data..."
	},
	{
		"[ DATA ] Data loaded successfully!",
		"[ DATA ] Data uspesne nactena!"
	},
	{
		"[ AUTOSAVE ] Saving user and system data... ",
		"[ AUTOSAVE ] Ukladam uzivatelska a systemova data..."
	},
	{
		"[ AUTOSAVE ] Data saved successfully! ",
		"[ AUTOSAVE ] Data uspesne ulozena!"
	},
	{
		"[ PM ] You need at least $10 to send a private message!",
		"[ PM ] K odeslani soukrome zpravy potrebujes alespon $10!"
	},
	{
		"[ PM ] Such user (ID) not found in the game!",
		"[ PM ] Prijemce soukrome zpravy neni pritomen na serveru!"
	},
	{
		"[ WARP ] You need to join a race to be able to use warp command!",
		"[ WARP ] Nejsi prihlasen v zadnem zavode, warp se nekona!"
	},
	{
		"[ WARP ] The race has already started, no warp allowed anymore!",
		"[ WARP ] Zavod jiz zacal, warp na start uz neni mozny!"
	},
	{
		"[ WARP ] You need drive a vehicle before the warp to the race start!",
		"[ WARP ] Pro warp je treba byt ve vozidle a byt ridicem!"
	},
	{
		"[ RACE ] The race ended prematurely!",
		"[ ZAVOD ] Zavod, ve kterem jsi byl prihlasen, byl predcasne ukoncen!"
	},
	{
		"[ RACE ] You have just finished the race!",
		"[ ZAVOD ] Dokoncil jsi zavod!"
	},
	{
		"[ RACE ] You need to join a race to use such feature!",
		"[ ZAVOD ] Nejsi prihlasen v zadnem zavodu!"
	},
	{
		"[ RACE ] No such race prepared to join!",
		"[ ZAVOD ] Dany zavod neni pripraven nebo neexistuje!"
	},
	{
		"[ RACE ] You have already joined the race!",
		"[ ZAVOD ] Do daneho zavodu jsi jiz prihlasen!"
	},
	{
		"[ RACE ] You haven't got enough moeny to join such race!",
		"[ ZAVOD ] Nemas dostatek hotovosti pro zaplaceni prihlasky do zavodu!"
	},
	{
		"[ DEATHMATCH ] New match just started!",
		"[ DEATHMATCH ] Nove utkani zacalo!"
	},
	{
		"[ DEATHMATCH ] The player is currently in a deathmatch minigame, try again later!",
		"[ DEATHMATCH ] Hrac zrovna hraje utkani deathmatch, zkus to pozdeji!"
	},
	{
		"[ CASH ] You dropped your money at the death position!",
		"[ CASH ] Tve penize zustaly na miste umrti!"
	},
	{
		"[ REAL ] Vehicle modifications saved",
		"[ REAL ] Modifikace auta ulozeny k zaparkovanemu autu"
	},
	{
		"[ REAL ] Invalid property code entered!",
		"[ REAL ] Neplatny kod nemovitosti!"
	},
	{
		"[ REAL ] Use the red property pickup to sell such property!",
		"[ REAL ] Je treba byt v okoli puvodniho pickupu (nyni rotujici cerveny domek)!"
	},
	{
		"[ REAL ] Such property is not for sell, or is not occupied at all!",
		"[ REAL ] Nelze prodat nemovitost, ktera neni prodana/obsazena."
	},
	{
		"[ REAL ] Such property is not owned by you!",
		"[ REAL ] Dana nemovitost ti nepatri!"
	},
	{
		"[ REAL ] You have just bought such property!",
		"[ REAL ] Nemovitost uspesne zakoupena!"
	},
	{
		"[ REAL ] Interior generation failed!",
		"[ REAL ] Nebylo mozne vygenerovat vsechny pickupy v dome!"
	},
	{
		"[ REAL ] No free slot to buy such property! You need to sell one to be able to buy another",
		"[ REAL ] Jiz vlastnis limitni pocet nemocitosti, je treba nejakou prodat, abys mohl nakoupit novou"
	},
	{
		"[ REAL ] Such property is already occupied! Invalid action",
		"[ REAL ] Tato nemovitost je jiz obsazena. Neplatna akce!"
	},
	{
		"[ REAL ] You haven't got enough money to buy such property!",
		"[ REAL ] Na danou transakci nemas dostatek hotovosti!"
	},
	{
		"[ REAL ] The property has been sold successfully!",
		"[ REAL ] Nemovitost byla uspesne prodana!"
	},
	{
		"[ TAXI ] Not a taxi cab!",
		"[ TAXI ] Musis ridit taxi auto!"
	},
	{
		"[ TAXI ] Telling NPC to enter the vehicle...",
		"[ TAXI ] NPC nastupuje do auta..."
	},
	{
		"[ TAXI ] Good job! Commission earned: $%d",
		"[ TAXI ] Dobra prace! Provize: $%d"
	},
	{
		"[ TAXI ] Database read error!",
		"[ TAXI ] Chyba cteni databaze!"
	},
	{
		"[ TAXI ] Too many customers in game, try again later!",
		"[ TAXI ] Ve hre je prilis mnoho zakazniku, zkus to pozdeji!"
	},
	{
		"[ TAXI ] Another minigame started, close it to start the taxi mission!",
		"[ TAXI ] Jina minihra jiz bezi, ukonci ji pro zahajeni taxi mise!"
	},
	{
		"~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:____~b~%d~y~:~b~%2d", 
		"~w~Jizd:_____~g~%d~n~~w~Vydelek:_~g~$~y~%d~n~~w~Cas:_____~b~%d~y~:~b~%2d"
	},
	{
		"~w~Return to the ~y~taxi cab ~w~to continue the ~y~mission!",
		"~w~Vrat se do ~y~taxiku ~w~k pokracovani zapocate ~y~mise!"
	},
	{
		"~w~Next destination: ~y~%s",
		"~w~Pristi destinace: ~y~%s"
	},
	{
		"~w~Taxi Mission ~g~Started!",
		"~w~Taxi Mise ~g~Zahajena!"
	},
	{
		"~w~Taxi Mission ~r~Aborted!",
		"~w~Taxi Mise ~r~Ukoncena!"
	},
	{
		"~w~Models:_~g~%d~n~~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:____~b~%d~y~:~b~%2d",
		"~w~Modely:_~g~%d~n~~w~Zavezeno:_~g~%d~n~~w~Vydelek:__~g~$~y~%d~n~~w~Cas:_____~b~%d~y~:~b~%2d"
	}
};

new gAdminColNames[6][PlayerLocale][] = {
	{
		"none",
		"zadna"
	},
	{
		"green",
		"zelenou"
	},
	{
		"blue",
		"modrou"
	},
	{
		"red",
		"cervenou"
	},
	{
		"orange",
		"oranzovou"
	},
	{
		"white",
		"bilou"
	}
};

//
//
//

#include "modules/player.pwn"

forward SendClientMessageLocalized(playerid, msg_id);

public SendClientMessageLocalized(playerid, msg_id)
{
	return SendClientMessage(playerid, gI18nMessageColor[msg_id], gI18nMessages[msg_id][ gPlayers[playerid][Locale] ]);
}

stock GetLocalizedString(playerid, msg_id, str[], size)
{
	format(str, size, "%s", gI18nMessages[msg_id][ gPlayers[playerid][Locale] ]);
	return 1;
}
