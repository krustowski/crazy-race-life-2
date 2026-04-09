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

#define MAX_MESSAGE_LEN		512

enum PlayerLocale
{
	LOCALE_EN,
	LOCALE_CZ
}

enum
{
	I18N_WELCOME_MESSAGE,
	I18N_CARKILL_VIOLATION_FMT,
	I18N_PLAYER_CONNECTED_FMT,
	I18N_PLAYER_DISCONNECT_CRASH,
	I18N_PLAYER_DISCONNECT_LEFT,
	I18N_PLAYER_DISCONNECT_KICK_BAN,
	I18N_PLAYER_DISCONNECT_UNKNOWN,
	I18N_SERVER_RESTART_COUNTDOWN,
	I18N_SERVER_RESTART_ABORTED,
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
	I18N_GIVECASH_INVALID_AMOUNT,
	I18N_GIVECASH_RECEIVED,
	I18N_GIVECASH_SENT,
	I18N_FORK_CMD_FORKLIFTS_BLOCK,
	I18N_FORK_CMD_APPLIED,
	I18N_TEAM_RELATED_CMD_MECHANICS,
	I18N_FIX_CMD_APPLIED,
	I18N_FIX_CMD_TARGET_NOT_IN_VEHICLE,
	I18N_FIX_CMD_NO_REPAIRING,
	I18N_FIX_CMD_TARGET_TOO_FAR,
	I18N_FIX_CMD_COMMISSION_FMT,
	I18N_DWARP_CMD_APPLIED_FMT,
	I18N_AFK_CMD_APPLIED,
	I18N_AFK_CMD_REVERTED,
	I18N_AFK_CMD_DEATHMATCH_BLOCK,
	I18N_PLAYER_SALARY_FMT,
	I18N_PLAYER_SALARY_GAMETEXT_FMT,
	I18N_MOVE_TO_PLAYER_INVALID_ID,
	I18N_MOVE_TO_PLAYER_IN_MINIGAME_BLOCK,
	I18N_VEHICLE_MOD_BLOCKED,
	I18N_VEHICLE_MOD_NITRO_INSTALLED_FMT,
	I18N_VEHICLE_MOD_NITRO_INSTALLED_ADMIN,
	I18N_ATM_INVALID_AMOUNT,
	I18N_ATM_DEPOSITED_FMT,
	I18N_ATM_WITHDRAWAL_FMT,
	// Private messages
	I18N_PRIV_MSG_RECEIVED_FMT,
	I18N_PRIV_MSG_SENT_FMT,
	I18N_PRIV_MSG_RECEIVED_GAMETEXT,
	I18N_PRIV_MSG_SENT_GAMETEXT,
	// Radar (vehicle stats)
	I18N_HID_STATS_GREEN_FMT,
	I18N_HID_STATS_RED_FMT,
	I18N_RADAR_FEE_FMT,
	// Admin elevator
	I18N_AE_MOVE_UP,
	I18N_AE_MOVE_DOWN,
	I18N_AE_MOVE_STOP,
	// Deals
	I18N_DEAL_NO_MONEY,
	I18N_DEAL_NOT_ACCEPTED,
	I18N_DEAL_OFFER_PLACED,
	I18N_DEAL_ACCPTED_TARGET,
	I18N_DEAL_ACCPTED_DEALER,
	I18N_DEAL_DECLINED,
	// Black Market
	I18N_BLACK_MARKET_RATIO_UPDATE,
	I18N_BLACK_MARKET_ALREADY_PROCESSED,
	I18N_BLACK_MARKET_NO_MONEY,
	I18N_BLACK_MARKET_OFFER_ACCEPTED_FMT,
	I18N_BLACK_MARKET_OFFER_PROCESSED_FMT,
	I18N_BLACK_MARKET_OFFER_PLACED,
	I18N_DRUGZ_PICKUP_FMT,
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
	I18N_RACE_IN_MINIGAME_BLOCK,
	I18N_RACE_REGISTERED_FMT,
	I18N_RACE_FINISHED_FMT,
	I18N_RACE_STARTED_GAMETEXT,
	I18N_RACE_FINISHED_GAMETEXT,
	I18N_RACE_ABORTED_GAMETEXT,
	I18N_RACE_INFO_TEXT_FMT,
	I18N_RACE_DATABASE_ERROR,
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
	I18N_REAL_PERIODIC_COMMISSION_FMT,
	I18N_REAL_PROPERTY_OWNED_FMT,
	I18N_REAL_PROPERTY_RENTED_FMT,
	I18N_REAL_PROPERTY_LOCKED_FMT,
	I18N_REAL_ALREADY_RENTED_BY_PLAYER,
	I18N_REAL_STILL_LOCKED,
	I18N_REAL_DATABASE_ERROR,
	I18N_REAL_RENTED_SUCCESSFULLY,
	I18N_REAL_RENT_OUTBOUGHT,
	I18N_REAL_PAINTJOB_ASSIGNED,
	I18N_REAL_PROPERTY_LIMIT_REACHED,
	I18N_REAL_PROPERTY_SAVED,
	I18N_REAL_PRIVATE_PROPERTY_ENTRANCE_BLOCK,
	I18N_REAL_PROPERTY_FOR_SELL_FMT,
	I18N_REAL_PROPERTY_FOR_SELL_OWNED_FMT,
	I18N_REAL_PROPERTY_FOR_RENT_FMT,
	I18N_REAL_PROPERTY_FOR_RENT_OWNED_FMT,
	I18N_REAL_PROPERTY_ALREADY_SOLD,
	I18N_REAL_ATTACHED_VEHICLE_RESPAWN_SET,
	I18N_REAL_NOT_OWNED_BY_PLAYER,
	I18N_REAL_NOT_DRIVING_VEHICLE,
	I18N_REAL_VEHICLE_MODEL_ALREADY_ATTACHED,
	I18N_REAL_NO_VEHICLE_SLOT,
	I18N_REAL_VEHICLE_ATTACHED_SUCCESSFULLY,
	I18N_REAL_SPAWN_POINT_CHANGED,
	I18N_REAL_PLAYER_NOT_INSIDE,
	I18N_REAL_SKIN_ALREADY_SAVED,
	I18N_REAL_SKIN_NO_FREE_SLOT,
	I18N_REAL_SKIN_SAVED,
	I18N_REAL_SKIN_FREE_SLOT,
	I18N_REAL_SKIN_SET,
	I18N_REAL_SKIN_DELETED,
	I18N_REAL_VEHICLE_MOD_SAVED,
	// Combat
	I18N_COMBAT_BRIEFCASES_EXCHANGED_FMT,
	I18N_COMBAT_INFO_FMT,
	I18N_COMBAT_FOLLOW_MARKER_BRIEFCASEMAN,
	I18N_COMBAT_FOUND_BRIEFCASE_FMT,
	I18N_COMBAT_HELICOPTER_INSTRUCTIONS,
	I18N_COMBAT_IN_MINIGAME_BLOCK,
	I18N_COMBAT_GENERIC_ERROR_NEW_MISS,
	I18N_COMBAT_MISS_START,
	I18N_COMBAT_MISS_ABORT,
	I18N_COMBAT_MISS_FINISHED,
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
	// Trucking
	I18N_TRUCK_MISS_INFO_FMT,
	I18N_TRUCK_MISS_COMMISSION_FMT,
	I18N_TRUCK_NEW_MISS_ERROR,
	I18N_TRUCK_RETURN_TO_TRUCK_FMT,
	I18N_TRUCK_TRAILER_DETACHED_FMT,
	I18N_TRUCK_NEXT_DESTINATION_FMT,
	I18N_TRUCK_MISS_START_FMT,
	I18N_TRUCK_MISS_ABORT_FMT,
	I18N_TRUCK_MISS_ABORT,
	I18N_TRUCK_IN_MINIGAME_BLOCK,
	I18N_TRUCK_NOT_DRIVER,
	I18N_TRUCK_NO_TRAILER,
	I18N_TRUCK_UNKNOWN_TRAILER_MODEL,
	I18N_TRUCK_VEHICLES_REGISTERED,
	// Tow
	I18N_TOW_MISS_INFO
}

new gI18nMessageColor[] = 
{
	COLOR_GREEN,
	COLOR_RED,
	COLOR_GREY,
	COLOR_GREY,
	COLOR_GREY,
	COLOR_GREY,
	COLOR_GREY,
	COLOR_YELLOW,
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
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	// Private messages
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	// Radar (vehicle stats)
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	// Admin elevator
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	// Deals
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_YELLOW,
	// Black Market
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
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
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_LIGHTGREEN,
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
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_ORANGE,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_YELLOW,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	// Combat
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
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
	// Trucking
	COLOR_INVISIBLE,
	COLOR_LIGHTGREEN,
	COLOR_RED,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	// Tow
	COLOR_INVISIBLE
};

new gI18nMessages[][PlayerLocale][MAX_MESSAGE_LEN] = 
{
	{
		"Welcome to the gamemode CrazyRaceLife2! /help",
		"Vitej ve hre! /help"
	},
	{
		"[ CARKILL ] Player %s [ID: %d] has just broken the server rules!",
		"[ CARKILL ] Hrac %s [ID: %d] prave porusil pravidla serveru!"
	},
	{
		"[ i ] Player %s joined the game!",
		"[ i ] Hrac %s prisel do hry!"
	},
	{
		"[ i ] Player %s disconnected [crash].",
		"[ i ] Hrac %s se odpojil [spadlo to]."
	},
	{
		"[ i ] Player %s disconnected [left].",
		"[ i ] Hrac %s se odpojil [odchod]."
	},
	{
		"[ i ] Player %s disconnected [kick/ban].",
		"[ i ] Hrac %s se odpojil [kick/ban]."
	},
	{
		"[ i ] Player %s disconnected [unknown].",
		"[ i ] Hrac %s se odpojil [neznamy duvod]."
	},
	{
		"[ RESTART ] Server restarts in %d seconds!",
		"[ RESTART ] Za %d sekund dojde k restartu serveru!"
	},
	{
		"[ RESTART ] Server restart aborted!",
		"[ RESTART ] Restart serveru zrusen!"
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
	{
		"[ ! ] Invalid amount!",
		"[ ! ] Neplatna castka!"
	},
	{
		"[ CASH ] Received money ($%d) from player %s [ID: %d]!",
		"[ CASH ] Prijem hotovosti ($%d) od hrace %s [ID: %d]!"
	},
	{
		"[ CASH ] Sent money ($%d) to player %s [ID: %d]!",
		"[ CASH ] Hotovost ($%d) odeslana hraci %s [ID: %d]!"
	},
	{
		"[ FORK ] Only applies to forklifts!",
		"[ FORK ] Prikaz je pouzitelny pouze pro vysokozdvizne voziky!"
	},
	{
		"[ FORK ] Controllers switch toggled!",
		"[ FORK ] Ovladani prepnuto!"
	},
	{
		"[ CMD ] Mechanics team-related command!",
		"[ CMD ] Prikaz je urcen pouze pro cleny teamu mechaniku!"
	},
	{
		"[ FIX ] Vehicle fixed!",
		"[ FIX ] Vozidlo opraveno!"
	},
	{
		"[ FIX ] Player with that ID is not riding/driving a vehicle!",
		"[ FIX ] Hrac s danym ID neni ve vozidle!"
	},
	{
		"[ FIX ] No need to repair this car",
		"[ FIX ] Vozidlo neni treba opravovat"
	},
	{
		"[ FIX ] Target vehicle is too far away!",
		"[ FIX ] Cilove vozidlo je moc daleko!"
	},
	{
		"[ FIX ] Vehicle fixed, commission earned: $%d",
		"[ FIX ] Vozidlo opraveno, odmena: $%d"
	},
	{
		"[ WARP ] Player %s used warp to the drag race spot! [ /dwarp ]",
		"[ WARP ] Hrac %s hodil warp na drag spot! [ /dwarp ]"
	},
	{
		"[ AFK ] Player %s (ID: %d) has just gone away from the keyboard! [ /afk ]",
		"[ AFK ] Hrac %s (ID: %d) odesel na chvili od klavesnice! [ /afk ]"
	},
	{
		"[ AFK ] Player %s (ID: %d) is back in game! [ /afk ]",
		"[ AFK ] Hrac %s (ID: %d) je zpet ve hre! [ /afk ]"
	},
	{
		"[ AFK ] Cannot go to AFK mode while in Deathmatch!",
		"[ AFK ] Nesmis pouzit /afk kdyz jsi v Deathmatch minihre!"
	},
	{
		"[ CASH ] Team salary just arrived: $%d",
		"[ CASH ] Tymova vyplata pristala do kapsy: $%d"
	},
	{
		"~y~S~g~alary~n~~y~$~g~%d",
		"~y~V~g~yplata~n~~y~$~g~%d"
	},
	{
		"[ ! ] Cannot use get/goto for the player!",
		"[ ! ] Nelze pouzit get/goto u daneho hrace!"
	},
	{
		"[ ! ] Target ID is playing a minigame, try again later!",
		"[ ! ] Cilove ID hraje minihru, zkus to pozdeji!"
	},
	{
		"[ ! ] Cannot mod such vehicle!",
		"[ ! ] Nelze modifikovat dane vozidlo!"
	},
	{
		"[ i ] Admin %s installed the Nitrous component to your vehicle!",
		"[ i ] Admin %s nainstaloval do tveho vozu nitro!"
	},
	{
		"[ i ] The Nitrous component installed for the player!",
		"[ i ] Hraci bylo nainstalovano nitro!"
	},
	{
		"[ ATM ] Invalid amount!",
		"[ ATM ] Neplatna castka!"
	},
	{
		"[ ATM ] Cash deposit: $%d! Account balance: $%d!",
		"[ ATM ] Vlozeno na ucet: $%d! Aktualni zustatek: $%d!"
	},
	{
		"[ ATM ] Cash withdrawal: $%d! Account balance: $%d!",
		"[ ATM ] Vybrano z uctu: $%d! Aktualni zustatek: $%d!"
	},
	//
	//  Private messages
	//
	{
		"[ PM ] Received from %s (ID: %d): %s",
		"[ PM ] Prijato od %s (ID: %d): %s"
	},
	{
		"[ PM ] Sent for %s (ID: %d): %s",
		"[ PM ] Odeslano pro %s (ID: %d): %s"
	},
	{
		"~w~PM ~g~Received~w~.",
		"~w~PM ~g~Prijata~w~."
	},
	{
		"~w~PM ~g~Sent~w~.",
		"~w~PM ~g~Odeslana~w~."
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
	//  Deals
	//
	{
		"[ DEAL ] Player got no money for such deal!",
		"[ DEAL ] Hrac nema dostatek penez pro danou transakci!"
	},
	{
		"[ DEAL ] Deal was not accepted.",
		"[ DEAL ] Nabidka byla odmitnuta."
	},
	{
		"[ DEAL ] The offer was sent to target player!",
		"[ DEAL ] Nabidka byla odeslana hraci!"
	},
	{
		"[ DEAL ] The offer was accepted and processed!",
		"[ DEAL ] Nabidka byla prijata a zprocesovana!"
	},
	{
		"[ DEAL ] The offer was accepted and processed!",
		"[ DEAL ] Nabidka byla prijata a zprocesovana!"
	},
	{
		"[ DEAL ] The offer was declined!",
		"[ DEAL ] Nabidka byla hracem odmitnuta!"
	},
	//
	//  Black Market
	//
	{
		"[ MARKET ] Market token-to-dollar ratio changed to: %.3f",
		"[ TRH ] Kurz token ku dolaru na trhu se zmenil: %.3f"
	},
	{
		"[ MAKRET ] Such offer has been already processed, try another one!",
		"[ TRH ] Dana nabidka jiz byla zpracovana, zkus jinou!"
	},
	{
		"[ MARKET ] Not enough money to buy an offer!",
		"[ TRH ] Danou nabidku nemas jak zaplatit!"
	},
	{
		"[ MARKET ] Somebody accepted your offer! (+$%d)",
		"[ TRH ] Nekdo prijal tvou nabidku na cernem trhu! (+$%d)"
	},
	{
		"[ MARKET ] Offer %d proceeded (price: %d)!",
		"[ TRH ] Nabidka %d zprocesovana (cena: %d)!"
	},
	{
		"[ MARKET ] New offer placed!",
		"[ TRH ] Nova nabidka byla vlozena na cerny trh!"
	},
	{
		"[ DRUGZ ] Just found %d g of %s.",
		"[ DRUGZ ] Prave jsi nasel %d g %s."
	},
	//
	//  Server data autosave
	//
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
		"[ RACE ] Another minigame is running, stop it to start racing!",
		"[ ZAVOD ] Jiz mas spustenou jinou minihru, ukonci ji pro zahajeni zavodu!"
	},
	{
		"[ RACE ] Joined the '%s' race (cost $%d). Use the first checkpoint to start the race!",
		"[ ZAVOD ] Uspesne prihlasen do zavodu '%s' (prihlaska $%d). Projed prvnim checkpointem pro spusteni casomiry."
	},
	{
		"[ RACE ] Player %s just finished the '%s' race, and received a prize of $%d!",
		"[ ZAVOD ] Hrac %s prave dokoncil zavod '%s' a ziskal odmenu $%d!"
	},
	{
		"~w~Race ~g~Started",
		"~w~Zavod ~g~Zahajen"
	},
	{
		"~w~Race ~g~Finished",
		"~w~Zavod ~g~Dokoncen"
	},
	{
		"~w~Race ~r~Aborted",
		"~w~Zavod ~r~Zrusen"
	},
	{
		"~w~Race:__________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Time:______~b~%4d~y~:~b~%2d",
		"~w~Zavod:_________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Cas:_______~b~%4d~y~:~b~%2d"
	},
	{
		"[ RACE ] Database error!",
		"[ ZAVOD ] Chyba databaze!"
	},
	//
	//  Deathmatch
	//
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
	//
	//  Real Estate
	//
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
		"[ REAL ] Jiz vlastnis limitni pocet nemovitosti, je treba nejakou prodat, abys mohl nakoupit novou"
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
		"[ CASH ] Periodic commission from rented properties: $%d",
		"[ CASH ] Periodicka provize z pronajatych nemovitosti: $%d"
	},
	{
		"%s owns this property",
		"%s vlastni tuto nemovitost"
	},
	{
		"property is rented by %s",
		"nemovitost pronajata hracem %s"
	},
	{
		"%s\n\nlocked until %02d/%02d/%4d %02d:%02d:%02d UTC",
		"%s\n\nzamknuto do %02d/%02d/%4d %02d:%02d:%02d UTC"
	},
	{
		"[ REAL ] This property is already rented by you!",
		"[ REAL ] Tuto nemovitost jiz mas v pronajmu!"
	},
	{
		"[ REAL ] This property is still locked for rent!",
		"[ REAL ] Tuto nemovitost stale nelze pronajat (je zamknuta)!"
	},
	{
		"[ REAL ] Database error!",
		"[ REAL ] Chyba databaze!"
	},
	{
		"[ REAL ] Property rented successfully!",
		"[ REAL ] Nemovitost uspesne pronajata!"
	},
	{
		"[ REAL ] Somebody has outbought one of your rented properties!",
		"[ REAL ] Nekdo prave odkoupil pronajem nektere tve nemovitosti!"
	},
	{
		"[ REAL ] New paintjob assigned to property vehicle!",
		"[ REAL ] Novy paintjob byl ulozen k zaparkovanemu autu!"
	},
	{
		"[ EDIT ] Max properties limit reached, cancelling the transaction",
		"[ EDIT ] Limit poctu nemovitosti byl dosazen, rusim transakci"
	},
	{
		"[ EDIT ] Property saved successfully!",
		"[ EDIT ] Nemovitost uspesne ulozena!"
	},
	{
		"[ REAL ] Cannot enter the private property!",
		"[ REAL ] Soukromy pozemek!"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' for sell.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nTo buy this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je na prodej.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nZadej kod nemovitosti pro nakup:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' is owned by you.\n\nCurrent value: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nThe selling fee is set to 10%% of the property value.\nEnter its code to sell this property:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je v tvem drzeni.\n\nAktualni hodnota: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nProvize realitni kancelari je 10%% z ceny nemovitosti.\nZadej kod nemovitosti pro prodej:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' for rent.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: %d\n\nTo rent this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je k pronajmu.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: %d\n\nK pronajmuti zadej kod nemovitosti:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' is currently rented by {FFD700}%s{FFFFFF}, but you can still pay the cost to rent it yourself.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nTo rent this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je v soucasne dobe pronajata hracem {FFD700}%s{FFFFFF}, ale stale ji muzes preplatit a pronajat si ji.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nK pronajmuti zadej kod nemovitosti:"
	},
	{
		"[ REAL ] This property has been already sold.",
		"[ REAL ] Tahle nemovitost jiz byla prodana."
	},
	{
		"[ REAL ] Attached vehicle set to respawn!",
		"[ REAL ] Zaparkovane auto bude respawnuto!"
	},
	{
		"[ REAL ] You do not own such property!",
		"[ REAL ] Danou nemovitost nevlastnis!"
	},
	{
		"[ REAL ] You must be driving/riding a vehicle!",
		"[ REAL ] Musis ridit auto, aby mohlo byt zaregistrovano k tve nemovitosti!"
	},
	{
		"[ REAL ] Such vehicle model has been already attached to such property!",
		"[ REAL ] Tento model vozidla jiz byl zaregistrovan k tve nemovitosti!"
	},
	{
		"[ REAL ] Such property does not have a vehicle spot!",
		"[ REAL ] Dana nemovitost nema parkovaci misto pro vozidlo!"
	},
	{
		"[ REAL ] This vehicle has been attached to your property successfully",
		"[ REAL ] Vozidlo bylo uspesne zaparkovano u tve nemovitosti"
	},
	{
		"[ REAL ] Spawn point changed successfully",
		"[ REAL ] Spawn bod byl uspesne zmenen"
	},
	{
		"[ REAL ] You need to be inside your owned property!",
		"[ REAL ] Je treba byt uvnitr nemovitosti!"
	},
	{
		"[ REAL ] This skin model has been already saved!",
		"[ REAL ] Tento skin byl jiz ulozen!"
	},
	{
		"[ REAL ] No more free skin slots for such property!",
		"[ REAL ] Nejsou zadna dalsi volna mista pro ulozeni skinu!"
	},
	{
		"[ REAL ] New skin model saved successfully!",
		"[ REAL ] Novy skin byl uspesne ulozen!"
	},
	{
		"[ REAL ] This skin slot is free!",
		"[ REAL ] Volny slot pro skin!"
	},
	{
		"[ REAL ] Property skin set successfully!",
		"[ REAL ] Skin ulozeny v nemovitosti byl nastaven!"
	},
	{
		"[ REAL ] Selected skin model deleted successfully!",
		"[ REAL ] Zvoleny skin byl smazan!"
	},
	{
		"[ REAL ] Vehicle mod saved!",
		"[ REAL ] Uprava auta ulozena!"
	},
	//
	//  Combat
	//
	{
		"[ COMBAT ] Briefcases exchanged for money ($%d)!",
		"[ COMBAT ] Kufriky vymeneny za prachy ($%d)!"
	},
	{
		"~w~Briefcase:_~g~%d~n~~w~Time:______~b~%d~y~:~b~%02d",
		"~w~Kufriky:___~g~%d~n~~w~Cas:_______~b~%d~y~:~b~%02d"
	},
	{
		"[ COMBAT ] Follow the yellow marker on map to give the briefcase man the briefcases!",
		"[ COMBAT ] Nasleduj zluty stitek na mape, ktery te zavede za kufikovym typkem!"
	},
	{
		"[ COMBAT ] You found briefcase no. %d",
		"[ COMBAT ] Nasel jsi kufrik cislo %d"
	},
	{
		"[ COMBAT ] Take the helicopter and follow the checkpoint on the minimap!",
		"[ COMBAT ] Vem vrtulnik a nasleduj cerveny checkpoint na minimape!"
	},
	{
		"[ COMBAT ] Another minigame started, close it to start the combat mission!",
		"[ COMBAT ] Jina minihra je aktivni, ukonci ji, abys mohl zacit combat misi!"
	},
	{
		"[ COMBAT ] Error setting new combat mission!",
		"[ COMBAT ] Nepodarilo se nastavit novou misi!"
	},
	{
		"~w~Combat Mission ~g~Started",
		"~w~Combat Mise ~g~Zahajena"
	},
	{
		"~w~Combat Mission ~r~Aborted",
		"~w~Combat Mise ~r~Zrusena"
	},
	{
		"~w~Combat Mission ~g~Finished",
		"~w~Combat Mise ~g~Dokoncena"
	},
	//
	//  Taxi
	//
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
	//
	//  Trucking
	//
	{
		"~w~Done:___________~g~%3d~n~~w~Earned:__~g~$~y~%7d~n~~w~Time:______~b~%4d~y~:~b~%02d",
		"~w~Jizd:___________~g~%3d~n~~w~Vydelek:_~g~$~y~%7d~n~~w~Cas:_______~b~%4d~y~:~b~%02d"
	},
	{
		"[ TRUCK ] Mission completed! Commission earned: $%d",
		"[ TRUCK ] Dobra prace! Provize: $%d"
	},
	{
		"[ TRUCK ] Error setting new mission!",
		"[ TRUCK ] Nepodarilo se nastavit novou misi!"
	},
	{
		"~w~Return to ~y~the truck ~w~to continue ~y~the mission!",
		"~w~Vrat se do ~y~kabiny nakladaku ~w~pro pokracovani ~y~mise!"
	},
	{
		"~w~Trailer ~r~Detached! ~w~Reattach to continue the mission!",
		"~w~Prives ~r~Odpojen! ~w~Pripoj jej zpet pro pokracovani mise!"
	},
	{
		"~w~Next destination: ~y~%s",
		"~w~Dalsi destinace: ~y~%s"
	},
	{
		"~w~Trucking Mission ~g~Started",
		"~w~Trucking mise ~g~Zahajena"
	},
	{
		"~w~Trucking Mission ~r~Aborted",
		"~w~Trucking mise ~r~Zrusena"
	},
	{
		"[ TRUCK ] Mission aborted",
		"[ TRUCK ] Mise zrusena"
	},
	{
		"[ TRUCK ] Another minigame started, close it to start the trucking mission!",
		"[ TRUCK ] Jina minihra je aktivni, ukonci ji, abys mohl zacit trucking misi!"
	},
	{
		"[ TRUCK ] You have to be in a truck as driver!",
		"[ TRUCK ] Musis byt ridicem kamionu!"
	},
	{
		"[ TRUCK ] No trailer attached!",
		"[ TRUCK ] Nemas pripojeny zadny naves!"
	},
	{
		"[ TRUCK ] Unknown trailer model",
		"[ TRUCK ] Neznamy model navesul"
	},
	{
		"[ TRUCK ] Vehicle and trailer registered successfully",
		"[ TRUCK ] Kamion a naves uspesne zaregistrovany k misi"
	},
	//
	//  Tow
	//
	{
		"~w~Models:_~g~%d~n~~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:____~b~%d~y~:~b~%02d",
		"~w~Modely:_~g~%d~n~~w~Zavezeno:_~g~%d~n~~w~Vydelek:__~g~$~y~%d~n~~w~Cas:_____~b~%d~y~:~b~%02d"
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
