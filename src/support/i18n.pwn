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
	I18N_USER_DATA_LOAD,
	I18N_USER_DATA_LOAD_SUCCESS,
	I18N_AUTOSAVE_START,
	I18N_AUTOSAVE_SUCCESS,
	I18N_PRIV_MSG_MONEY,
	I18N_PRIV_MSG_NO_PLAYER,
	//
	I18N_RACE_WARP_NO_RACE,
	I18N_RACE_WARP_AFTER_START,
	I18N_RACE_WARP_NO_VEHIC_DRIVER,
	I18N_RACE_ENDED_PREMATURELY,
	I18N_RACE_ENDED_SUCCESSFULLY,
	I18N_RACE_NO_RACE,
	I18N_RACE_NO_SUCH_RACE,
	I18N_RACE_ALREADY_JOINED,
	I18N_RACE_NO_MONEY,
	//
	I18N_DEATHMATCH_STARTED,
	//
	I18N_NO_SUCH_COMMAND,
	//
	I18N_DEATH_MONEY_LOCALITY,
	//
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
	I18N_REAL_SELL_SUCCESS
}

new gI18nMessageColor[] = 
{
	COLOR_GREEN,
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
	//
	COLOR_YELLOW,
	//
	COLOR_GREY,
	//
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
	COLOR_LIGHTGREEN
};

new gI18nMessageEn[][] = 
{
	"Welcome to the gamemode CrazyRaceLife2!",
	"[ DATA ] Loading user data...",
	"[ DATA ] Data loaded successfully!",
	"[ AUTOSAVE ] Saving user and system data... ",
	"[ AUTOSAVE ] Data saved successfully! ",
	"[ PM ] You need at least $10 to send a private message!",
	"[ PM ] Such user (ID) not found in the game!",
	"[ WARP ] You need to join a race to be able to use warp command!",
	"[ WARP ] The race has already started, no warp allowed anymore!",
	"[ WARP ] You need drive a vehicle before the warp to the race start!",
	"[ RACE ] The race ended prematurely!",
	"[ RACE ] You have just finished the race!",
	"[ RACE ] You need to join a race to use such feature!",
	"[ RACE ] No such race prepared to join!",
	"[ RACE ] You have already joined the race!",
	"[ RACE ] You haven't got enough moeny to join such race!",
	"[ DEATHMATCH ] New match just started, join to play!",
	"[ ! ] No such command! /cmd /help /rules",
	"[ i ] You dropped your money at the death position!",
	"[ REAL ] Vehicle modifications saved",
	"[ REAL ] Invalid property code entered!",
	"[ REAL ] Use the red property pickup to sell such property!",
	"[ REAL ] Such property is not for sell, or is not occupied at all!",
	"[ REAL ] Such property is not owned by you!",
	"[ REAL ] You have just bought such property!",
	"[ REAL ] Interior generation failed!",
	"[ REAL ] No free slot to buy such property! You need to sell one to be able to buy another",
	"[ REAL ] Such property is already occupied! Invalid action",
	"[ REAL ] You haven't got enough money to buy such property!",
	"[ REAL ] The property has been sold successfully!"
};

new gI18nMessageCz[][] = 
{
	"Vitej ve hre!",
	"[ DATA ] Nacitam ulozena uzivatelska data...",
	"[ DATA ] Data uspesne nactena!",
	"[ AUTOSAVE ] Ukladam uzivatelska a systemova data...",
	"[ AUTOSAVE ] Data uspesne ulozena!",
	"[ PM ] K odeslani soukrome zpravy potrebujes alespon $10!",
	"[ PM ] Prijemce soukrome zpravy neni pritomen na serveru!",
	"[ WARP ] Nejsi prihlasen v zadnem zavode, warp se nekona!",
	"[ WARP ] Zavod jiz zacal, warp na start uz neni mozny!",
	"[ WARP ] Pro warp je treba byt ve vozidle a byt ridicem!",
	"[ ZAVOD ] Zavod, ve kterem jsi byl prihlasen, byl predcasne ukoncen!",
	"[ ZAVOD ] Dokoncil jsi zavod!",
	"[ ZAVOD ] Nejsi prihlasen v zadnem zavodu!",
	"[ ZAVOD ] Dany zavod neni pripraven nebo neexistuje!",
	"[ ZAVOD ] Do daneho zavodu jsi jiz prihlasen!",
	"[ ZAVOD ] Nemas dostatek hotovosti pro zaplaceni prihlasky do zavodu!",
	"[ DEATHMATCH ] Utkani zacalo! 4 minuty do konce",
	"[ ! ] Tento prikaz neexistuje! /cmd /help /rules",
	"[ i ] Tve penize zustaly na miste umrti!",
	"[ REAL ] Modifikace auta ulozeny k zaparkovanemu autu",
	"[ REAL ] Neplatny kod nemovitosti!",
	"[ REAL ] Je treba byt v okoli puvodniho pickupu (nyni rotujici cerveny domek)!",
	"[ REAL ] Nelze prodat nemovitost, ktera neni prodana/obsazena.",
	"[ REAL ] Dana nemovitost ti nepatri!",
	"[ REAL ] Nemovitost uspesne zakoupena!",
	"[ REAL ] Nebylo mozne vygenerovat vsechny pickupy v dome!",
	"[ REAL ] Jiz vlastnis limitni pocet nemocitosti, je treba nejakou prodat, abys mohl nakoupit novou",
	"[ REAL ] Tato nemovitost je jiz obsazena. Neplatna akce!",
	"[ REAL ] Na danou transakci nemas dostatek hotovosti!",
	"[ REAL ] Nemovitost byla uspesne prodana!"
};


//
//
//

#include "modules/player.pwn"

public SendClientMessageLocalized(playerid, msg_id)
{
	switch (gPlayers[playerid][Locale])
	{
		case LOCALE_CZ:
			SendClientMessage(playerid, gI18nMessageColor[msg_id], gI18nMessageCz[msg_id]);
		default:
			SendClientMessage(playerid, gI18nMessageColor[msg_id], gI18nMessageEn[msg_id]);
	}

	return 1;
}
