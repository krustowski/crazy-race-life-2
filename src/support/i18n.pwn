#if defined _CRL2_I18N
	#endinput
#endif
#define _CRL2_I18N

//
//  i18n.pwn
//

#define COLOR_GREEN				0x21DD00FF
#define COLOR_GREEN2			0x008000AA
#define COLOR_LIGHTGREEN		0x29FF06AA
#define COLOR_ORANGE			0xF97804FF
#define COLOR_ORANGE2			0xFF8C00AA
#define COLOR_ORANGERED			0xFF4500AA
#define COLOR_RED				0xE60000FF
#define COLOR_RED2				0xFF0000AA
#define COLOR_BLUE				0x0000BBAA
#define COLOR_BLUE2				0x4682B4AA
#define COLOR_BLUE3				0x4169FFAA
#define COLOR_CYAN				0x00FFFFAA
#define COLOR_YELLOWGREEN		0xADFF2FAA
#define COLOR_DARKCYAN			0x008B8BAA
#define COLOR_WHITE				0xFFFFFFAA
#define COLOR_YELLOW			0xFFFF00AA
#define COLOR_LEMON				0xFFFF00AA
#define COLOR_BROWN				0xA52A2AAA
#define COLOR_BROWN2			0xBC8F8FAA
#define COLOR_GREY				0x808080AA
#define COLOR_PINK				0xFFC0CBAA
#define COLOR_CHARTR			0x7FFF00AA
#define COLOR_SYSTEM			0xEFEFF7AA
#define COLOR_INVISIBLE			0x4682B400
#define COLOR_BEIGE          	0xFFF8DCAA

#define MAX_MESSAGE_LEN			512

enum PlayerLocale
{
	LOCALE_EN,
	LOCALE_CZ,
	LOCALE_BS
}

enum
{
	I18N_WELCOME_MESSAGE,
	I18N_WEAPON_CHEAT_VIOLATION_FMT,
	I18N_JETPACK_VIOLATION_FMT,
	I18N_CARKILL_VIOLATION_FMT,
	I18N_IP_FLOOD_VIOLATION_FMT,
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
	I18N_KILL_CMD_UNAVAILABLE,
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
	// Rampages
	I18N_RAMPAGE_MISS_INFO,
	I18N_RAMPAGE_MISS_START,
	I18N_RAMPAGE_MISS_ABORT,
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
	// Drug Mission
	I18N_DRUG_MISS_INFO,
	I18N_DRUG_MISS_INMINIGAME_CONFLICT,
	I18N_DRUG_MISS_UNMET_TEAM,
	I18N_DRUG_MISS_STARTED,
	I18N_DRUG_MISS_ABORTED,
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
	I18N_RACE_ALREADY_RUNNING,
	// Deathmatch
	I18N_DEATHMATCH_STARTED,
	I18N_DEATHMATCH_INGAME_BLOCK,
	I18N_DEATHMATCH_NO_PLAYERS,
	I18N_DEATHMATCH_INFO_FMT,
	I18N_DEATHMATCH_ALREADY_STARTED,
	I18N_DEATHMATCH_IN_MINIGAME_BLOCK,
	I18N_DEATHMATCH_PRESTARTED,
	I18N_DEATHMATCH_WAITING_FOR_OTHERS,
	I18N_DEATHMATCH_PLAYER_LEFT,
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
	I18N_COMBAT_OCCUPIED_BLOCK,
	I18N_COMBAT_GENERIC_ERROR_NEW_MISS,
	I18N_COMBAT_MISS_START,
	I18N_COMBAT_MISS_ABORT,
	I18N_COMBAT_MISS_FINISHED,
	// Taxi
	I18N_TAXI_MISS_WRONG_TEAM,
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
	I18N_TAXI_CALL_MINIGAME_BLOCK,
	I18N_TAXI_CALL_NO_TAXI,
	I18N_TAXI_CALL_STOP_FMT,
	I18N_TAXI_CALL_ARRIVED_FMT,
	I18N_TAXI_CALL_CAB_WAITING_FMT,
	I18N_TAXI_RIDE_WELCOME,
	I18N_TAXI_RIDE_ARRIVED_FMT,
	I18N_TAXI_RIDE_NEXT_STOP_FMT,
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
	I18N_TOW_MISS_INFO,
	I18N_TOW_RETURN_TO_TRUCK_FMT,
	I18N_TOW_MISS_START,
	I18N_TOW_MISS_ABORT,
	I18N_TOW_IN_MINIGAME_BLOCK,
	I18N_TOW_NOT_DRIVER,
	I18N_TOW_INVALID_VEHICLE,
	I18N_TOW_VEHICLE_ATTACHED,
	I18N_TOW_VEHICLE_DETACHED,
	I18N_TOW_VEHICLE_ALREADY_TOWED,
	I18N_TOW_VEHICLE_MODEL_BONUS_FMT,
	I18N_TOW_VEHICLE_TOWED_COMMISSION_FMT,
	// HD version
	I18N_HD_CMD_APPLIED,
	I18N_HD_CMD_REVERTED,
	// Rob mission
	I18N_ROB_MISS_INFO,
	I18N_ROB_MISS_START,
	I18N_ROB_MISS_ABORT,
	I18N_ROB_MISS_SUMMARY_FMT,
	I18N_ROB_STARTED_FMT,
	I18N_ROB_PROGRESS_GAMETEXT_FMT,
	I18N_ROB_DONE_FMT,
	I18N_ROB_NOTHING_TAKEN,
	I18N_ROB_PROPERTY_LOCKED_FMT,
	I18N_ROB_PROPERTY_BUSY,
	I18N_ROB_OWN_PROPERTY_BLOCK,
	I18N_ROB_IN_MINIGAME_BLOCK,
	I18N_ROB_TEAM_HINT,
	I18N_ROB_OWNER_NOTICE,
	// Quests
	I18N_QUEST_COMPLETED_FMT,
	I18N_QUEST_COMPLETED_GAMETEXT_FMT,
	// Fuel
	I18N_FUEL_NOT_DRIVER,
	I18N_FUEL_NO_STATION,
	I18N_FUEL_STATION_EMPTY_FMT,
	I18N_FUEL_NO_MONEY_FMT,
	I18N_FUEL_BOUGHT_FMT,
	// Anticheat
	I18N_ANTICHEAT_STRIKE_FMT,
	I18N_ANTICHEAT_KICK_FMT,
	// Fence
	I18N_FENCE_DEALERZ_ONLY,
	I18N_FENCE_NOT_AT_POINT,
	I18N_FENCE_WRONG_AMOUNT,
	I18N_FENCE_CLOSED,
	I18N_FENCE_WORTHLESS,
	I18N_FENCE_LIMIT_REACHED_FMT,
	I18N_FENCE_SOLD_FMT,
	I18N_FENCE_PARTIAL_FMT,
	I18N_FENCE_RATIO_PEAK_FMT,
	// Deals
	I18N_DEAL_DEALER_OUT_OF_STOCK,
	// Rampage
	I18N_RAMPAGE_MISS_TAKEN,
	// Admin
	I18N_ADMIN_LVL_SET_NOT_LOGGED
}

new gI18nMessageColor[] = 
{
	COLOR_GREEN,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
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
	// Rampage
	COLOR_YELLOW,
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
	// Drug Mission
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
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
	COLOR_RED,
	// Deathmatch
	COLOR_YELLOW,
	COLOR_RED,
	COLOR_GREY,
	COLOR_INVISIBLE,
	COLOR_GREY,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_INVISIBLE,
	COLOR_YELLOW,
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
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	// Taxi
	COLOR_RED,
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
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
	COLOR_YELLOW,
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
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	COLOR_YELLOW,
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	// HD version
	COLOR_LIGHTGREEN,
	COLOR_LIGHTGREEN,
	// Rob mission
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_INVISIBLE,
	COLOR_ORANGE,
	COLOR_ORANGE,
	COLOR_INVISIBLE,
	COLOR_ORANGE,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_ORANGE,
	// Quests
	COLOR_LIGHTGREEN,
	COLOR_INVISIBLE,
	// Fuel
	COLOR_RED,
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_RED,
	COLOR_LIGHTGREEN,
	// Anticheat
	COLOR_ORANGE,
	COLOR_RED,
	// Fence
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_RED,
	COLOR_ORANGE,
	COLOR_YELLOW,
	COLOR_ORANGE,
	// Deals
	COLOR_RED,
	// Rampage
	COLOR_ORANGE,
	// Admin
	COLOR_RED
};

new gI18nMessages[][PlayerLocale][MAX_MESSAGE_LEN] = 
{
	{
		"Welcome to the gamemode CrazyRaceLife2! /help",
		"Vitej ve hre! /help",
		"Dobro dosao u igru CrazyRaceLife2! /help"
	},
	{
		"[ ! ] Player %s violated the weapon cheat rule and was kicked from the server!",
		"[ ! ] Hrac %s byl(a) vyhozen(a) za weapon cheat!",
		"[ ! ] Igrac %s je izbacen sa servera zbog weapon cheata!"
	},
	{
		"[ ! ] Player %s violated the no JetPack rule and was kicked from the server!",
		"[ ! ] Hrac %s byl(a) vyhozen(a) za poruseni pravidel! [JetPack]",
		"[ ! ] Igrac %s je izbacen sa servera zbog krsenja pravila! [JetPack]"
	},
	{
		"[ CARKILL ] Player %s [ID: %d] has just broken the server rules!",
		"[ CARKILL ] Hrac %s [ID: %d] prave porusil pravidla serveru!",
		"[ CARKILL ] Igrac %s [ID: %d] je upravo prekrsio pravila servera!"
	},
	{
		"[ ! ] IP %s tried to flood the server and was banned.",
		"[ ! ] IP %s se pokousela floodovat server. Byl udelen ban.",
		"[ ! ] IP %s je pokusala floodati server i dobila je ban."
	},
	{
		"[ i ] Player %s joined the game!",
		"[ i ] Hrac %s prisel do hry!",
		"[ i ] Igrac %s je usao u igru!"
	},
	{
		"[ i ] Player %s disconnected [crash].",
		"[ i ] Hrac %s se odpojil [spadlo to].",
		"[ i ] Igrac %s je prekinuo vezu [pad igre]."
	},
	{
		"[ i ] Player %s disconnected [left].",
		"[ i ] Hrac %s se odpojil [odchod].",
		"[ i ] Igrac %s je prekinuo vezu [izlaz]."
	},
	{
		"[ i ] Player %s disconnected [kick/ban].",
		"[ i ] Hrac %s se odpojil [kick/ban].",
		"[ i ] Igrac %s je prekinuo vezu [kick/ban]."
	},
	{
		"[ i ] Player %s disconnected [unknown].",
		"[ i ] Hrac %s se odpojil [neznamy duvod].",
		"[ i ] Igrac %s je prekinuo vezu [nepoznat razlog]."
	},
	{
		"[ RESTART ] Server restarts in %d seconds!",
		"[ RESTART ] Za %d sekund dojde k restartu serveru!",
		"[ RESTART ] Server se restartuje za %d sekundi!"
	},
	{
		"[ RESTART ] Server restart aborted!",
		"[ RESTART ] Restart serveru zrusen!",
		"[ RESTART ] Restart servera je otkazan!"
	},
	{
		"[ ! ] Such player not in a vehicle!",
		"[ ! ] Hrac se nenachazi ve vozidle!",
		"[ ! ] Igrac nije u vozilu!"
	},
	{
		"[ ! ] Such player not driving/riding a vehicle!",
		"[ ! ] Hrac neni ridicem ve vozidle!",
		"[ ! ] Igrac nije vozac vozila!"
	},
	{
		"[ ! ] The player is not connected!",
		"[ ! ] Hrac neni pripojen ke hre!",
		"[ ! ] Igrac nije spojen na server!"
	},
	{
		"[ ! ] Invalid player ID!",
		"[ ! ] Neplatne ID hrace!",
		"[ ! ] Nevazeci ID igraca!"
	},
	{
		"[ CMD ] No such command! /cmd /help /rules",
		"[ CMD ] Tento prikaz neexistuje! /cmd /help /rules",
		"[ CMD ] Ova komanda ne postoji! /cmd /help /rules"
	},
	{
		"[ CMD ] Usage: %s",
		"[ CMD ] Pouziti prikazu: %s",
		"[ CMD ] Upotreba komande: %s"
	},
	{
		"[ CMD ] Admin level too low!",
		"[ CMD ] Pro dany prikaz nemas opravneni!",
		"[ CMD ] Nemas ovlasti za ovu komandu!"
	},
	{
		"[ CMD ] Invalid vehicle model ID! (Model IDs: 400-611)",
		"[ CMD ] Neplatne ID modelu vozidla! (Pouzij ID z rozmezi 400-611)",
		"[ CMD ] Nevazeci ID modela vozila! (Koristi ID iz raspona 400-611)"
	},
	{
		"[ SPECTATE ] Mode disabled!",
		"[ SPECTATE ] Spehovani vypnuto!",
		"[ SPECTATE ] Posmatranje iskljuceno!"
	},
	{
		"[ SPECTATE ] Mode enabled!",
		"[ SPECTATE ] Spehovani zapnuto!",
		"[ SPECTATE ] Posmatranje ukljuceno!"
	},
	{
		"[ CMD ] Invalid skin ID!",
		"[ CMD ] Neplatne ID skinu!",
		"[ CMD ] Nevazeci ID skina!"
	},
	{
		"[ NET ] Player ID: %d, packet loss: %.2f %%",
		"[ NET ] ID hrace: %d, ztrata paketu: %.2f %%",
		"[ NET ] ID igraca: %d, gubitak paketa: %.2f %%"
	},
	{
		"[ ADMIN ] You can only set the same or lower level that you have got yourself!",
		"[ ADMIN ] Muzes nastavit pouze stejny nebo nizsi level nez jaky sam mas!",
		"[ ADMIN ] Mozes postaviti samo isti ili nizi level od onog koji sam imas!"
	},
	{
		"[ ADMIN ] No need to change such admin level!",
		"[ ADMIN ] Neni potreba menit jiz nastaveny stejny level!",
		"[ ADMIN ] Nije potrebno mijenjati vec postavljeni isti level!"
	},
	{
		"[ ADMIN ] Admin %s set player %s [ ID: %d ] an Admin (level %d)!",
		"[ ADMIN ] Admin %s nastavil hrace %s [ ID: %d ] adminem (level %d)!",
		"[ ADMIN ] Admin %s je postavio igraca %s [ ID: %d ] za admina (level %d)!"
	},
	{
		"[ KICK ] Admin %s [ID: %d] kicked player %s [ID: %d] from server!",
		"[ KICK ] Admin %s [ID: %d] vykopl hrace %s [ID: %d] ze hry!",
		"[ KICK ] Admin %s [ID: %d] je izbacio igraca %s [ID: %d] iz igre!"
	},
	{
		"[ BAN ] Admin %s [ID: %d] banned player %s [ID: %d] from server!",
		"[ BAN ] Admin %s [ID: %d] zakazal hraci %s [ID: %d] pristup do hry!",
		"[ BAN ] Admin %s [ID: %d] je zabranio igracu %s [ID: %d] pristup igri!"
	},
	{
		"[ HP ] Health: 100.0, armour: 100.0",
		"[ HP ] Zdravi: 100.0, vesta: 100.0",
		"[ HP ] Zdravlje: 100.0, pancir: 100.0"
	},
	{
		"[ DRUGZ ] Invalid level, use a number from range 0-50000",
		"[ DRUGZ ] Neplatny level, pouzij cislo z rozmezi 0-50000",
		"[ DRUGZ ] Nevazeci level, koristi broj iz raspona 0-50000"
	},
	{
		"[ DRUGZ ] Your drunk level changed!",
		"[ DRUGZ ] Zmenil se level opilstvi!",
		"[ DRUGZ ] Tvoj level pijanstva je promijenjen!"
	},
	{
		"[ CMD ] Invalid input (crime IDs: 3-22)",
		"[ CMD ] Neplatne ID zlocinu (rozmezi ID je 3-22)",
		"[ CMD ] Nevazeci ID zlocina (raspon ID-a je 3-22)"
	},
	{
		"[ CLEAR ] Chat history flushed!",
		"[ CLEAR ] Historie chatu byla smazana!",
		"[ CLEAR ] Historija chata je obrisana!"
	},
	{
		"[ CAM ] Camera No. %d attached [/ccmd /camoff]",
		"[ CAM ] Kamera cislo %d pripojena [/ccmd /camoff]",
		"[ CAM ] Kamera broj %d prikljucena [/ccmd /camoff]"
	},
	{
		"[ CAM ] Camera dettached [/ccmd]",
		"[ CAM ] Kamera odpojena [/ccmd]",
		"[ CAM ] Kamera iskljucena [/ccmd]"
	},
	{
		"[ COL ] Player label color set to %s!",
		"[ COL ] Barva stitku hrace zmenena na %s!",
		"[ COL ] Boja oznake igraca postavljena na %s!"
	},
	{
		"[ CMD ] Police team-related command!",
		"[ CMD ] Tento prikaz je urcen pouze pro team policistu!",
		"[ CMD ] Ova komanda je namijenjena samo za tim policije!"
	},
	{
		"Player %s says to player %s: %s",
		"Hrac %s vzkazuje hraci %s: %s",
		"Igrac %s porucuje igracu %s: %s"
	},
	{
		"[ SKYDIVE ] Enjoy the skydive!",
		"[ SKYDIVE ] Uzij si seskok!",
		"[ SKYDIVE ] Uzivaj u skoku!"
	},
	{
		"[ ! ] You need to be closer to the player to search them",
		"[ ! ] Potrebujes byt hraci blize, abys mohl provest prohlidku",
		"[ ! ] Moras biti blize igracu da bi mogao izvrsiti pretres"
	},
	{
		"[ DRUGZ ] Player is drunk driving! The player is fined $25000",
		"[ DRUGZ ] Hrac ridi opily! Hrac zaplati pokutu $25000",
		"[ DRUGZ ] Igrac vozi pijan! Igrac placa kaznu $25000"
	},
	{
		"[ DRUGZ ] You have been fined $25000 for drunk driving, your vehicle has been confiscated",
		"[ DRUGZ ] Za rizeni pod vlivem zaplatis pokutu $25000, vozidlo bylo odstaveno",
		"[ DRUGZ ] Zbog voznje pod uticajem placas kaznu $25000, vozilo je oduzeto"
	},
	{
		 "[ CASH ] Received a bonus of $%d!",
		 "[ CASH ] Ziskana odmena $%d!",
		 "[ CASH ] Dobijena nagrada $%d!"
	},
	{
		"[ DRUGZ ] You have used a breathalyzer, the player is sober",
		"[ DRUGZ ] Hraci byl podan alkoholtester, hrac je strizlivy",
		"[ DRUGZ ] Igracu je uradjen alkotest, igrac je trijezan"
	},
	{
		"[ DRUGZ ] You have just been tested for intoxication and you passed",
		"[ DRUGZ ] Byl ti podan alkoholtester, jsi strizlivy",
		"[ DRUGZ ] Uradjen ti je alkotest, trijezan si"
	},
	{
		"[ ! ] Leave the property to be able to use such command!",
		"[ ! ] Pred pouzitim daneho prikazu musis opustit nemovitost!",
		"[ ! ] Prije koristenja ove komande moras napustiti nekretninu!"
	},
	{
		"[ ! ] You cannot use such command while in minigame!",
		"[ ! ] Pred pouzitim daneho prikazu musis ukoncit aktualne spustenou minihru",
		"[ ! ] Prije koristenja ove komande moras zavrsiti trenutno pokrenutu mini-igru"
	},
	{
		"[ COORDS ] Current location coordinates: Interior No. %d, X[%.2f], Y[%.2f], Z[%.2f], Rotation/Angle[%.2f]",
		"[ COORDS ] Souradnice aktualni polohy: Interier cislo %d, X[%.2f], Y[%.2f], Z[%.2f], Rotace/Uhel[%.2f]",
		"[ COORDS ] Koordinate trenutne lokacije: Enterijer broj %d, X[%.2f], Y[%.2f], Z[%.2f], Rotacija/Ugao[%.2f]"
	},
	{
		"[ ! ] Animation allowed outside the vehicle only!",
		"[ ! ] Musis byt venku z vozidla pro pouziti teto animace!",
		"[ ! ] Moras biti izvan vozila da bi koristio ovu animaciju!"
	},
	{
		"[ i ] Player %s has just committed a suicide! [ /kill ]",
		"[ i ] Hrac %s prave spachal sebevrazdu!  [ /kill ]!",
		"[ i ] Igrac %s je upravo izvrsio samoubistvo! [ /kill ]"
	},
	{
		"[ ! ] You can only use /kill while alive and spawned!",
		"[ ! ] Prikaz /kill lze pouzit pouze pokud jsi nazivu a ve hre!",
		"[ ! ] Komandu /kill mozes koristiti samo ako si ziv i u igri!"
	},
	{
		"[ CMD ] Adminz-only team-related command!",
		"[ CMD ] Prikaz je urcen pouze pro cleny teamu Adminz!",
		"[ CMD ] Komanda je namijenjena samo clanovima tima Adminz!"
	},
	{
		"[ HIDE ] Player color set to invisible!",
		"[ HIDE ] Hracsky stitek zneviditelnen pro ostatni hrace!",
		"[ HIDE ] Oznaka igraca je sakrivena za ostale igrace!"
	},
	{
		"[ HIDE ] Player color set to visible!",
		"[ HIDE ] Hracsky stitek zviditelnen pro ostatni hrace!",
		"[ HIDE ] Oznaka igraca je vidljiva za ostale igrace!"
	},
	{
		"[ ! ] Invalid amount!",
		"[ ! ] Neplatna castka!",
		"[ ! ] Nevazeci iznos!"
	},
	{
		"[ CASH ] Received money ($%d) from player %s [ID: %d]!",
		"[ CASH ] Prijem hotovosti ($%d) od hrace %s [ID: %d]!",
		"[ CASH ] Primljen novac ($%d) od igraca %s [ID: %d]!"
	},
	{
		"[ CASH ] Sent money ($%d) to player %s [ID: %d]!",
		"[ CASH ] Hotovost ($%d) odeslana hraci %s [ID: %d]!",
		"[ CASH ] Novac ($%d) poslan igracu %s [ID: %d]!"
	},
	{
		"[ FORK ] Only applies to forklifts!",
		"[ FORK ] Prikaz je pouzitelny pouze pro vysokozdvizne voziky!",
		"[ FORK ] Komanda se moze koristiti samo za viljuskare!"
	},
	{
		"[ FORK ] Controllers switch toggled!",
		"[ FORK ] Ovladani prepnuto!",
		"[ FORK ] Upravljanje prebaceno!"
	},
	{
		"[ CMD ] Mechanics team-related command!",
		"[ CMD ] Prikaz je urcen pouze pro cleny teamu mechaniku!",
		"[ CMD ] Komanda je namijenjena samo clanovima tima mehanicara!"
	},
	{
		"[ FIX ] Vehicle fixed!",
		"[ FIX ] Vozidlo opraveno!",
		"[ FIX ] Vozilo popravljeno!"
	},
	{
		"[ FIX ] Player with that ID is not riding/driving a vehicle!",
		"[ FIX ] Hrac s danym ID neni ve vozidle!",
		"[ FIX ] Igrac sa tim ID-om nije u vozilu!"
	},
	{
		"[ FIX ] No need to repair this car",
		"[ FIX ] Vozidlo neni treba opravovat",
		"[ FIX ] Vozilo nije potrebno popravljati"
	},
	{
		"[ FIX ] Target vehicle is too far away!",
		"[ FIX ] Cilove vozidlo je moc daleko!",
		"[ FIX ] Ciljano vozilo je predaleko!"
	},
	{
		"[ FIX ] Vehicle fixed, commission earned: $%d",
		"[ FIX ] Vozidlo opraveno, odmena: $%d",
		"[ FIX ] Vozilo popravljeno, nagrada: $%d"
	},
	{
		"[ WARP ] Player %s used warp to the drag race spot! [ /dwarp ]",
		"[ WARP ] Hrac %s hodil warp na drag spot! [ /dwarp ]",
		"[ WARP ] Igrac %s se warpao na drag spot! [ /dwarp ]"
	},
	{
		"[ AFK ] Player %s (ID: %d) has just gone away from the keyboard! [ /afk ]",
		"[ AFK ] Hrac %s (ID: %d) odesel na chvili od klavesnice! [ /afk ]",
		"[ AFK ] Igrac %s (ID: %d) je nakratko otisao od tastature! [ /afk ]"
	},
	{
		"[ AFK ] Player %s (ID: %d) is back in game! [ /afk ]",
		"[ AFK ] Hrac %s (ID: %d) je zpet ve hre! [ /afk ]",
		"[ AFK ] Igrac %s (ID: %d) se vratio u igru! [ /afk ]"
	},
	{
		"[ AFK ] Cannot go to AFK mode while in Deathmatch!",
		"[ AFK ] Nesmis pouzit /afk kdyz jsi v Deathmatch minihre!",
		"[ AFK ] Ne mozes koristiti /afk dok si u Deathmatch mini-igri!"
	},
	{
		"[ CASH ] Team salary just arrived: $%d",
		"[ CASH ] Tymova vyplata pristala do kapsy: $%d",
		"[ CASH ] Stigla je timska plata: $%d"
	},
	{
		"~y~S~g~alary~n~~y~$~g~%d",
		"~y~V~g~yplata~n~~y~$~g~%d",
		"~y~P~g~lata~n~~y~$~g~%d"
	},
	{
		"[ ! ] Cannot use get/goto for the player!",
		"[ ! ] Nelze pouzit get/goto u daneho hrace!",
		"[ ! ] Nije moguce koristiti get/goto za ovog igraca!"
	},
	{
		"[ ! ] Target ID is playing a minigame, try again later!",
		"[ ! ] Cilove ID hraje minihru, zkus to pozdeji!",
		"[ ! ] Ciljani ID igra mini-igru, pokusaj kasnije!"
	},
	{
		"[ ! ] Cannot mod such vehicle!",
		"[ ! ] Nelze modifikovat dane vozidlo!",
		"[ ! ] Ovo vozilo nije moguce modifikovati!"
	},
	{
		"[ i ] Admin %s installed the Nitrous component to your vehicle!",
		"[ i ] Admin %s nainstaloval do tveho vozu nitro!",
		"[ i ] Admin %s je ugradio nitro u tvoje vozilo!"
	},
	{
		"[ i ] The Nitrous component installed for the player!",
		"[ i ] Hraci bylo nainstalovano nitro!",
		"[ i ] Igracu je ugradjen nitro!"
	},
	{
		"[ ATM ] Invalid amount!",
		"[ ATM ] Neplatna castka!",
		"[ ATM ] Nevazeci iznos!"
	},
	{
		"[ ATM ] Cash deposit: $%d! Account balance: $%d!",
		"[ ATM ] Vlozeno na ucet: $%d! Aktualni zustatek: $%d!",
		"[ ATM ] Uplaceno na racun: $%d! Trenutno stanje: $%d!"
	},
	{
		"[ ATM ] Cash withdrawal: $%d! Account balance: $%d!",
		"[ ATM ] Vybrano z uctu: $%d! Aktualni zustatek: $%d!",
		"[ ATM ] Podignuto sa racuna: $%d! Trenutno stanje: $%d!"
	},
	//
	//  Rampage
	//
	{
		"~w~Killed:_____~g~%d~n~~w~Time:______~b~%d~y~:~b~%02d",
		"~w~Zabito:_____~g~%d~n~~w~Cas:_______~b~%d~y~:~b~%02d",
		"~w~Ubijeno:____~g~%d~n~~w~Vrijeme:___~b~%d~y~:~b~%02d"
	},
	{
		"~y~Rampage ~w~Mission ~g~Started~w~.",
		"~y~Rampage ~w~Mise ~g~Zapocala.",
		"~y~Rampage ~w~Misija ~g~Pocela~w~."
	},
	{
		"~y~Rampage ~w~Mission ~r~Ended~w~.",
		"~y~Rampage ~w~Mise ~r~Skoncila.",
		"~y~Rampage ~w~Misija ~r~Zavrsena~w~."
	},
	//
	//  Private messages
	//
	{
		"[ PM ] Received from %s (ID: %d): %s",
		"[ PM ] Prijato od %s (ID: %d): %s",
		"[ PM ] Primljeno od %s (ID: %d): %s"
	},
	{
		"[ PM ] Sent for %s (ID: %d): %s",
		"[ PM ] Odeslano pro %s (ID: %d): %s",
		"[ PM ] Poslano igracu %s (ID: %d): %s"
	},
	{
		"~w~PM ~g~Received~w~.",
		"~w~PM ~g~Prijata~w~.",
		"~w~PM ~g~Primljena~w~."
	},
	{
		"~w~PM ~g~Sent~w~.",
		"~w~PM ~g~Odeslana~w~.",
		"~w~PM ~g~Poslana~w~."
	},
	//
	//  Radar (vehicle stats)
	//
	{
		"~w~Health:____%3d_%%~n~~w~Velocity:__~g~~h~%3d",
		"~w~Stav:______%3d_%%~n~~w~Rychlost:__~g~~h~%3d",
		"~w~Stanje:____%3d_%%~n~~w~Brzina:____~g~~h~%3d"
	},
	{
		"~w~Health:____%3d_%%~n~~w~Velocity:__~r~~h~%3d",
		"~w~Stav:______%3d_%%~n~~w~Rychlost:__~r~~h~%3d",
		"~w~Stanje:____%3d_%%~n~~w~Brzina:____~r~~h~%3d"
	},
	{
		"[ SPEED ] Vehicle speed too high (%3d km/h)! Fee amount: $%d",
		"[ SPEED ] Jedes prilis rychle (%3d km/h)! Pokuta: $%d",
		"[ SPEED ] Vozis prebrzo (%3d km/h)! Kazna: $%d"
	},
	//
	//  Admin elevator
	//
	{
		"[ AE ] Admin elevator goes up!",
		"[ AE ] Vytah adminu se rozjel nahoru!",
		"[ AE ] Admin lift je krenuo gore!"
	},
	{
		"[ AE ] Admin elevator goes down!",
		"[ AE ] Vytah adminu se rozjel dolu!",
		"[ AE ] Admin lift je krenuo dole!"
	},
	{
		"[ AE ] Admin elevator stopped due to a technical malfunction!",
		"[ AE ] Vytah admin se zasekl kvuli poruse zarizeni!",
		"[ AE ] Admin lift se zaglavio zbog tehnickog kvara!"
	},
	//
	//  Deals
	//
	{
		"[ DEAL ] Player got no money for such deal!",
		"[ DEAL ] Hrac nema dostatek penez pro danou transakci!",
		"[ DEAL ] Igrac nema dovoljno novca za ovu transakciju!"
	},
	{
		"[ DEAL ] Deal was not accepted.",
		"[ DEAL ] Nabidka byla odmitnuta.",
		"[ DEAL ] Ponuda nije prihvacena."
	},
	{
		"[ DEAL ] The offer was sent to target player!",
		"[ DEAL ] Nabidka byla odeslana hraci!",
		"[ DEAL ] Ponuda je poslana igracu!"
	},
	{
		"[ DEAL ] The offer was accepted and processed!",
		"[ DEAL ] Nabidka byla prijata a zprocesovana!",
		"[ DEAL ] Ponuda je prihvacena i obradjena!"
	},
	{
		"[ DEAL ] The offer was accepted and processed!",
		"[ DEAL ] Nabidka byla prijata a zprocesovana!",
		"[ DEAL ] Ponuda je prihvacena i obradjena!"
	},
	{
		"[ DEAL ] The offer was declined!",
		"[ DEAL ] Nabidka byla hracem odmitnuta!",
		"[ DEAL ] Igrac je odbio ponudu!"
	},
	//
	//  Drug Mission
	//
	{
		"~w~Count:_____~g~%d~n~~w~Time:______~b~%d~y~:~b~%02d",
		"~w~Sebrano:___~g~%d~n~~w~Cas:_______~b~%d~y~:~b~%02d",
		"~w~Skupljeno:_~g~%d~n~~w~Vrijeme:___~b~%d~y~:~b~%02d"
	},
	{
		"[ DRUGZ ] Another minigame is active, abort/finish it to be able to start a drug mission!",
		"[ DRUGZ ] Jina minihra je aktivni, ukonci ji, abys mohl zapocit drugovou misi!",
		"[ DRUGZ ] Druga mini-igra je aktivna, zavrsi je da bi mogao zapoceti misiju droge!"
	},
	{
		"[ DRUGZ ] You must be a member of the Dealerz team!",
		"[ DRUGZ ] Musis byt clenem teamu Dealeru!",
		"[ DRUGZ ] Moras biti clan tima Dealerz!"
	},
	{
		"~w~Drug Mission ~g~Started",
		"~w~Drogova Mise ~g~Zahajena",
		"~w~Misija droge ~g~Pocela"
	},
	{
		"~w~Drog Mission ~r~Aborted",
		"~w~Drogova Mise ~r~Zrusena",
		"~w~Misija droge ~r~Otkazana"
	},
	//
	//  Black Market
	//
	{
		"[ MARKET ] Market token-to-dollar ratio changed to: %.3f",
		"[ TRH ] Kurz token ku dolaru na trhu se zmenil: %.3f",
		"[ TRZISTE ] Kurs tokena prema dolaru promijenjen: %.3f"
	},
	{
		"[ MAKRET ] Such offer has been already processed, try another one!",
		"[ TRH ] Dana nabidka jiz byla zpracovana, zkus jinou!",
		"[ TRZISTE ] Ova ponuda je vec obradjena, pokusaj drugu!"
	},
	{
		"[ MARKET ] Not enough money to buy an offer!",
		"[ TRH ] Danou nabidku nemas jak zaplatit!",
		"[ TRZISTE ] Nemas dovoljno novca za ovu ponudu!"
	},
	{
		"[ MARKET ] Somebody accepted your offer! (+$%d)",
		"[ TRH ] Nekdo prijal tvou nabidku na cernem trhu! (+$%d)",
		"[ TRZISTE ] Neko je prihvatio tvoju ponudu! (+$%d)"
	},
	{
		"[ MARKET ] Offer %d proceeded (price: %d)!",
		"[ TRH ] Nabidka %d zprocesovana (cena: %d)!",
		"[ TRZISTE ] Ponuda %d obradjena (cijena: %d)!"
	},
	{
		"[ MARKET ] New offer placed!",
		"[ TRH ] Nova nabidka byla vlozena na cerny trh!",
		"[ TRZISTE ] Nova ponuda je postavljena na crno trziste!"
	},
	{
		"[ DRUGZ ] Just found %d g of %s.",
		"[ DRUGZ ] Prave jsi nasel %d g %s.",
		"[ DRUGZ ] Upravo si pronasao %d g %s."
	},
	//
	//  Server data autosave
	//
	{
		"[ DATA ] Loading user data...",
		"[ DATA ] Nacitam ulozena uzivatelska data...",
		"[ DATA ] Ucitavam sacuvane korisnicke podatke..."
	},
	{
		"[ DATA ] Data loaded successfully!",
		"[ DATA ] Data uspesne nactena!",
		"[ DATA ] Podaci uspjesno ucitani!"
	},
	{
		"[ AUTOSAVE ] Saving user and system data... ",
		"[ AUTOSAVE ] Ukladam uzivatelska a systemova data...",
		"[ AUTOSAVE ] Cuvam korisnicke i sistemske podatke..."
	},
	{
		"[ AUTOSAVE ] Data saved successfully! ",
		"[ AUTOSAVE ] Data uspesne ulozena!",
		"[ AUTOSAVE ] Podaci uspjesno sacuvani!"
	},
	{
		"[ PM ] You need at least $10 to send a private message!",
		"[ PM ] K odeslani soukrome zpravy potrebujes alespon $10!",
		"[ PM ] Za slanje privatne poruke trebas najmanje $10!"
	},
	{
		"[ PM ] Such user (ID) not found in the game!",
		"[ PM ] Prijemce soukrome zpravy neni pritomen na serveru!",
		"[ PM ] Primalac privatne poruke nije prisutan na serveru!"
	},
	{
		"[ WARP ] You need to join a race to be able to use warp command!",
		"[ WARP ] Nejsi prihlasen v zadnem zavode, warp se nekona!",
		"[ WARP ] Nisi prijavljen ni u jednu utrku, nema warpa!"
	},
	{
		"[ WARP ] The race has already started, no warp allowed anymore!",
		"[ WARP ] Zavod jiz zacal, warp na start uz neni mozny!",
		"[ WARP ] Utrka je vec pocela, warp na start vise nije moguc!"
	},
	{
		"[ WARP ] You need drive a vehicle before the warp to the race start!",
		"[ WARP ] Pro warp je treba byt ve vozidle a byt ridicem!",
		"[ WARP ] Za warp moras biti u vozilu kao vozac!"
	},
	{
		"[ RACE ] The race ended prematurely!",
		"[ ZAVOD ] Zavod, ve kterem jsi byl prihlasen, byl predcasne ukoncen!",
		"[ UTRKA ] Utrka u koju si bio prijavljen je prijevremeno zavrsena!"
	},
	{
		"[ RACE ] You have just finished the race!",
		"[ ZAVOD ] Dokoncil jsi zavod!",
		"[ UTRKA ] Zavrsio si utrku!"
	},
	{
		"[ RACE ] You need to join a race to use such feature!",
		"[ ZAVOD ] Nejsi prihlasen v zadnem zavodu!",
		"[ UTRKA ] Nisi prijavljen ni u jednu utrku!"
	},
	{
		"[ RACE ] No such race prepared to join!",
		"[ ZAVOD ] Dany zavod neni pripraven nebo neexistuje!",
		"[ UTRKA ] Ova utrka nije pripremljena ili ne postoji!"
	},
	{
		"[ RACE ] You have already joined the race!",
		"[ ZAVOD ] Do daneho zavodu jsi jiz prihlasen!",
		"[ UTRKA ] Vec si prijavljen u ovu utrku!"
	},
	{
		"[ RACE ] You haven't got enough moeny to join such race!",
		"[ ZAVOD ] Nemas dostatek hotovosti pro zaplaceni prihlasky do zavodu!",
		"[ UTRKA ] Nemas dovoljno gotovine za placanje prijave na utrku!"
	},
	{
		"[ RACE ] Another minigame is running, stop it to start racing!",
		"[ ZAVOD ] Jiz mas spustenou jinou minihru, ukonci ji pro zahajeni zavodu!",
		"[ UTRKA ] Vec imas pokrenutu drugu mini-igru, zavrsi je da bi zapoceo utrku!"
	},
	{
		"[ RACE ] Joined the '%s' race (cost $%d). Watch the race start countdown!",
		"[ ZAVOD ] Uspesne prihlasen do zavodu '%s' (prihlaska $%d). Sleduj odpocet do startu zavodu!",
		"[ UTRKA ] Uspjesno prijavljen na utrku '%s' (prijava $%d). Prati odbrojavanje do starta utrke!"
	},
	{
		"[ RACE ] Player %s just finished the '%s' race, and received a prize of $%d!",
		"[ ZAVOD ] Hrac %s prave dokoncil zavod '%s' a ziskal odmenu $%d!",
		"[ UTRKA ] Igrac %s je upravo zavrsio utrku '%s' i osvojio nagradu $%d!"
	},
	{
		"~w~Race ~g~Started",
		"~w~Zavod ~g~Zahajen",
		"~w~Utrka ~g~Pocela"
	},
	{
		"~w~Race ~g~Finished",
		"~w~Zavod ~g~Dokoncen",
		"~w~Utrka ~g~Zavrsena"
	},
	{
		"~w~Race ~r~Aborted",
		"~w~Zavod ~r~Zrusen",
		"~w~Utrka ~r~Otkazana"
	},
	{
		"~w~Race:__________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Position:_____~g~%d~y~/~r~%2d~n~~w~Time:______~b~%4d~y~:~b~%02d",
		"~w~Zavod:_________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Pozice:_______~g~%d~y~/~r~%2d~n~~w~Cas:_______~b~%4d~y~:~b~%02d",
		"~w~Utrka:_________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Pozicija:_____~g~%d~y~/~r~%2d~n~~w~Vrijeme:___~b~%4d~y~:~b~%02d"
	},
	{
		"[ RACE ] Database error!",
		"[ ZAVOD ] Chyba databaze!",
		"[ UTRKA ] Greska baze podataka!"
	},
	{
		"[ RACE ] This race is in process at the moment. Try registering in later",
		"[ ZAVOD ] Tento zavod je prave v plnem proudu. Zkus se zaregistrovat pozdeji",
		"[ UTRKA ] Ova utrka je trenutno u toku. Pokusaj se prijaviti kasnije"
	},
	//
	//  Deathmatch
	//
	{
		"[ DEATHMATCH ] New match just started!",
		"[ DEATHMATCH ] Nove utkani zacalo!",
		"[ DEATHMATCH ] Novi mec je poceo!"
	},
	{
		"[ DEATHMATCH ] The player is currently in a deathmatch minigame, try again later!",
		"[ DEATHMATCH ] Hrac zrovna hraje utkani deathmatch, zkus to pozdeji!",
		"[ DEATHMATCH ] Igrac trenutno igra deathmatch, pokusaj kasnije!"
	},
	{
		"[ DEATHMATCH ] No players registered, resetting the minigame.",
		"[ DEATHMATCH ] Zadni hraci ve hre, resetuju minihru.",
		"[ DEATHMATCH ] Nema prijavljenih igraca, resetujem mini-igru."
	},
	{
		"~w~Players:_~g~%d~n~~w~Lead:_~y~%s:_~g~%d~n~~w~Time:____~b~%d~y~:~b~%02d",
		"~w~Hracu:___~g~%d~n~~w~Vede:_~y~%s:_~g~%d~n~~w~Cas:_____~b~%d~y~:~b~%02d",
		"~w~Igraca:__~g~%d~n~~w~Vodi:_~y~%s:_~g~%d~n~~w~Vrijeme:_~b~%d~y~:~b~%02d"
	},
	{
		"[ DEATHMATCH ] The game already started, try again later!",
		"[ DEATHMATCH ] Hra jiz zacala, zkus znovu pozdeji!",
		"[ DEATHMATCH ] Igra je vec pocela, pokusaj ponovo kasnije!"
	},
	{
		"[ DEATHMATCH ] Another minigame started, close it to start the deathmatch minigame!",
		"[ DEATHMATCH ] Jina minihra je aktivni, ukonci ji, abys mohl zacit deathmatch minihru!",
		"[ DEATHMATCH ] Druga mini-igra je aktivna, zavrsi je da bi mogao zapoceti deathmatch!"
	},
	{
		"[ DEATHMATCH ] Deathmatch starts in 45 seconds! Join /deathmatch!",
		"[ DEATHMATCH ] Deathmatch zacina za 45 sekund! Pridej se pomoci /deathmatch!",
		"[ DEATHMATCH ] Deathmatch pocinje za 45 sekundi! Pridruzi se sa /deathmatch!"
	},
	{
		"~w~Waiting for others to join",
		"~w~Cekani na ostatni hrace",
		"~w~Cekanje na ostale igrace"
	},
	{
		"[ DEATHMATCH ] Player %s left the /deathmatch!",
		"[ DEATHMATCH ] Hrac %s opsutil /deathmatch!",
		"[ DEATHMATCH ] Igrac %s je napustio /deathmatch!"
	},
	{
		"[ CASH ] You dropped your money at the death position!",
		"[ CASH ] Tve penize zustaly na miste umrti!",
		"[ CASH ] Tvoj novac je ostao na mjestu smrti!"
	},
	//
	//  Real Estate
	//
	{
		"[ REAL ] Vehicle modifications saved",
		"[ REAL ] Modifikace auta ulozeny k zaparkovanemu autu",
		"[ REAL ] Modifikacije vozila sacuvane"
	},
	{
		"[ REAL ] Invalid property code entered!",
		"[ REAL ] Neplatny kod nemovitosti!",
		"[ REAL ] Nevazeci kod nekretnine!"
	},
	{
		"[ REAL ] Use the red property pickup to sell such property!",
		"[ REAL ] Je treba byt v okoli puvodniho pickupu (nyni rotujici cerveny domek)!",
		"[ REAL ] Za prodaju nekretnine koristi crveni pickup nekretnine!"
	},
	{
		"[ REAL ] Such property is not for sell, or is not occupied at all!",
		"[ REAL ] Nelze prodat nemovitost, ktera neni prodana/obsazena.",
		"[ REAL ] Ova nekretnina nije na prodaju ili uopce nije zauzeta!"
	},
	{
		"[ REAL ] Such property is not owned by you!",
		"[ REAL ] Dana nemovitost ti nepatri!",
		"[ REAL ] Ova nekretnina nije tvoja!"
	},
	{
		"[ REAL ] You have just bought such property!",
		"[ REAL ] Nemovitost uspesne zakoupena!",
		"[ REAL ] Uspjesno si kupio ovu nekretninu!"
	},
	{
		"[ REAL ] Interior generation failed!",
		"[ REAL ] Nebylo mozne vygenerovat vsechny pickupy v dome!",
		"[ REAL ] Generisanje enterijera nije uspjelo!"
	},
	{
		"[ REAL ] No free slot to buy such property! You need to sell one to be able to buy another",
		"[ REAL ] Jiz vlastnis limitni pocet nemovitosti, je treba nejakou prodat, abys mohl nakoupit novou",
		"[ REAL ] Nemas slobodno mjesto za kupovinu ove nekretnine! Moras prodati jednu da bi mogao kupiti drugu"
	},
	{
		"[ REAL ] Such property is already occupied! Invalid action",
		"[ REAL ] Tato nemovitost je jiz obsazena. Neplatna akce!",
		"[ REAL ] Ova nekretnina je vec zauzeta! Nevazeca akcija"
	},
	{
		"[ REAL ] You haven't got enough money to buy such property!",
		"[ REAL ] Na danou transakci nemas dostatek hotovosti!",
		"[ REAL ] Nemas dovoljno novca za kupovinu ove nekretnine!"
	},
	{
		"[ REAL ] The property has been sold successfully!",
		"[ REAL ] Nemovitost byla uspesne prodana!",
		"[ REAL ] Nekretnina je uspjesno prodana!"
	},
	{
		"[ CASH ] Periodic commission from rented properties: $%d",
		"[ CASH ] Periodicka provize z pronajatych nemovitosti: $%d",
		"[ CASH ] Periodicna provizija od iznajmljenih nekretnina: $%d"
	},
	{
		"%s owns this property",
		"%s vlastni tuto nemovitost",
		"%s je vlasnik ove nekretnine"
	},
	{
		"property is rented by %s",
		"nemovitost pronajata hracem %s",
		"nekretninu je iznajmio %s"
	},
	{
		"%s\n\nlocked until %02d/%02d/%4d %02d:%02d:%02d UTC",
		"%s\n\nzamknuto do %02d/%02d/%4d %02d:%02d:%02d UTC",
		"%s\n\nzakljucano do %02d/%02d/%4d %02d:%02d:%02d UTC"
	},
	{
		"[ REAL ] This property is already rented by you!",
		"[ REAL ] Tuto nemovitost jiz mas v pronajmu!",
		"[ REAL ] Ovu nekretninu vec imas u najmu!"
	},
	{
		"[ REAL ] This property is still locked for rent!",
		"[ REAL ] Tuto nemovitost stale nelze pronajat (je zamknuta)!",
		"[ REAL ] Ova nekretnina je jos uvijek zakljucana za najam!"
	},
	{
		"[ REAL ] Database error!",
		"[ REAL ] Chyba databaze!",
		"[ REAL ] Greska baze podataka!"
	},
	{
		"[ REAL ] Property rented successfully!",
		"[ REAL ] Nemovitost uspesne pronajata!",
		"[ REAL ] Nekretnina uspjesno iznajmljena!"
	},
	{
		"[ REAL ] Somebody has outbought one of your rented properties!",
		"[ REAL ] Nekdo prave odkoupil pronajem nektere tve nemovitosti!",
		"[ REAL ] Neko je preuzeo najam jedne od tvojih nekretnina!"
	},
	{
		"[ REAL ] New paintjob assigned to property vehicle!",
		"[ REAL ] Novy paintjob byl ulozen k zaparkovanemu autu!",
		"[ REAL ] Novi paintjob je dodijeljen vozilu nekretnine!"
	},
	{
		"[ EDIT ] Max properties limit reached, cancelling the transaction",
		"[ EDIT ] Limit poctu nemovitosti byl dosazen, rusim transakci",
		"[ EDIT ] Dostignut je limit broja nekretnina, ponistavam transakciju"
	},
	{
		"[ EDIT ] Property saved successfully!",
		"[ EDIT ] Nemovitost uspesne ulozena!",
		"[ EDIT ] Nekretnina uspjesno sacuvana!"
	},
	{
		"[ REAL ] Cannot enter the private property!",
		"[ REAL ] Soukromy pozemek!",
		"[ REAL ] Ne mozes uci u privatni posjed!"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' for sell.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nTo buy this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je na prodej.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nZadej kod nemovitosti pro nakup:",
		"{FFFFFF}Nekretnina '{FFD700}%s{FFFFFF}' je na prodaju.\n\n\tCijena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nekretnine: {FFD700}%d{FFFFFF}\n\nUnesi kod nekretnine za kupovinu:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' is owned by you.\n\nCurrent value: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nThe selling fee is set to 10%% of the property value.\nEnter its code to sell this property:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je v tvem drzeni.\n\nAktualni hodnota: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nProvize realitni kancelari je 10%% z ceny nemovitosti.\nZadej kod nemovitosti pro prodej:",
		"{FFFFFF}Nekretnina '{FFD700}%s{FFFFFF}' je u tvom vlasnistvu.\n\nTrenutna vrijednost: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nekretnine: {FFD700}%d{FFFFFF}\n\nNaknada za prodaju iznosi 10%% vrijednosti nekretnine.\nUnesi kod nekretnine za prodaju:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' for rent.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: %d\n\nTo rent this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je k pronajmu.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: %d\n\nK pronajmuti zadej kod nemovitosti:",
		"{FFFFFF}Nekretnina '{FFD700}%s{FFFFFF}' je za najam.\n\n\tCijena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nekretnine: %d\n\nZa najam unesi kod nekretnine:"
	},
	{
		"{FFFFFF}Property '{FFD700}%s{FFFFFF}' is currently rented by {FFD700}%s{FFFFFF}, but you can still pay the cost to rent it yourself.\n\n\tCost: ${00FF00}%d{FFFFFF} (%.2f mio)\n\n\nProperty code: {FFD700}%d{FFFFFF}\n\nTo rent this property, enter its code below:",
		"{FFFFFF}Nemovitost '{FFD700}%s{FFFFFF}' je v soucasne dobe pronajata hracem {FFD700}%s{FFFFFF}, ale stale ji muzes preplatit a pronajat si ji.\n\n\tCena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nemovitosti: {FFD700}%d{FFFFFF}\n\nK pronajmuti zadej kod nemovitosti:",
		"{FFFFFF}Nekretninu '{FFD700}%s{FFFFFF}' trenutno iznajmljuje {FFD700}%s{FFFFFF}, ali i dalje mozes platiti cijenu i iznajmiti je za sebe.\n\n\tCijena: ${00FF00}%d{FFFFFF} (%.2f mil)\n\n\nKod nekretnine: {FFD700}%d{FFFFFF}\n\nZa najam unesi kod nekretnine:"
	},
	{
		"[ REAL ] This property has been already sold.",
		"[ REAL ] Tahle nemovitost jiz byla prodana.",
		"[ REAL ] Ova nekretnina je vec prodana."
	},
	{
		"[ REAL ] Attached vehicle set to respawn!",
		"[ REAL ] Zaparkovane auto bude respawnuto!",
		"[ REAL ] Parkirano vozilo ce biti respawnovano!"
	},
	{
		"[ REAL ] You do not own such property!",
		"[ REAL ] Danou nemovitost nevlastnis!",
		"[ REAL ] Ne posjedujes ovu nekretninu!"
	},
	{
		"[ REAL ] You must be driving/riding a vehicle!",
		"[ REAL ] Musis ridit auto, aby mohlo byt zaregistrovano k tve nemovitosti!",
		"[ REAL ] Moras voziti vozilo da bi ga registrovao uz svoju nekretninu!"
	},
	{
		"[ REAL ] Such vehicle model has been already attached to such property!",
		"[ REAL ] Tento model vozidla jiz byl zaregistrovan k tve nemovitosti!",
		"[ REAL ] Ovaj model vozila je vec registrovan uz ovu nekretninu!"
	},
	{
		"[ REAL ] Such property does not have a vehicle spot!",
		"[ REAL ] Dana nemovitost nema parkovaci misto pro vozidlo!",
		"[ REAL ] Ova nekretnina nema parking mjesto za vozilo!"
	},
	{
		"[ REAL ] This vehicle has been attached to your property successfully",
		"[ REAL ] Vozidlo bylo uspesne zaparkovano u tve nemovitosti",
		"[ REAL ] Vozilo je uspjesno parkirano uz tvoju nekretninu"
	},
	{
		"[ REAL ] Spawn point changed successfully",
		"[ REAL ] Spawn bod byl uspesne zmenen",
		"[ REAL ] Spawn tacka je uspjesno promijenjena"
	},
	{
		"[ REAL ] You need to be inside your owned property!",
		"[ REAL ] Je treba byt uvnitr nemovitosti!",
		"[ REAL ] Moras biti unutar svoje nekretnine!"
	},
	{
		"[ REAL ] This skin model has been already saved!",
		"[ REAL ] Tento skin byl jiz ulozen!",
		"[ REAL ] Ovaj skin je vec sacuvan!"
	},
	{
		"[ REAL ] No more free skin slots for such property!",
		"[ REAL ] Nejsou zadna dalsi volna mista pro ulozeni skinu!",
		"[ REAL ] Nema vise slobodnih mjesta za skinove u ovoj nekretnini!"
	},
	{
		"[ REAL ] New skin model saved successfully!",
		"[ REAL ] Novy skin byl uspesne ulozen!",
		"[ REAL ] Novi skin je uspjesno sacuvan!"
	},
	{
		"[ REAL ] This skin slot is free!",
		"[ REAL ] Volny slot pro skin!",
		"[ REAL ] Ovo mjesto za skin je slobodno!"
	},
	{
		"[ REAL ] Property skin set successfully!",
		"[ REAL ] Skin ulozeny v nemovitosti byl nastaven!",
		"[ REAL ] Skin iz nekretnine je uspjesno postavljen!"
	},
	{
		"[ REAL ] Selected skin model deleted successfully!",
		"[ REAL ] Zvoleny skin byl smazan!",
		"[ REAL ] Odabrani skin je uspjesno obrisan!"
	},
	{
		"[ REAL ] Vehicle mod saved!",
		"[ REAL ] Uprava auta ulozena!",
		"[ REAL ] Modifikacija vozila sacuvana!"
	},
	//
	//  Combat
	//
	{
		"[ COMBAT ] Briefcases exchanged for money ($%d)!",
		"[ COMBAT ] Kufriky vymeneny za prachy ($%d)!",
		"[ COMBAT ] Aktovke zamijenjene za novac ($%d)!"
	},
	{
		"~w~Briefcase:_~g~%d~n~~w~Time:______~b~%d~y~:~b~%02d",
		"~w~Kufriky:___~g~%d~n~~w~Cas:_______~b~%d~y~:~b~%02d",
		"~w~Aktovke:___~g~%d~n~~w~Vrijeme:___~b~%d~y~:~b~%02d"
	},
	{
		"[ COMBAT ] Follow the yellow marker on map to give the briefcase man the briefcases!",
		"[ COMBAT ] Nasleduj zluty stitek na mape, ktery te zavede za kufikovym typkem!",
		"[ COMBAT ] Prati zuti marker na mapi i predaj aktovke covjeku s aktovkama!"
	},
	{
		"[ COMBAT ] You found briefcase no. %d",
		"[ COMBAT ] Nasel jsi kufrik cislo %d",
		"[ COMBAT ] Pronasao si aktovku broj %d"
	},
	{
		"[ COMBAT ] Take the helicopter and follow the checkpoint on the minimap!",
		"[ COMBAT ] Vem vrtulnik a nasleduj cerveny checkpoint na minimape!",
		"[ COMBAT ] Uzmi helikopter i prati checkpoint na minimapi!"
	},
	{
		"[ COMBAT ] Another minigame started, close it to start the combat mission!",
		"[ COMBAT ] Jina minihra je aktivni, ukonci ji, abys mohl zacit combat misi!",
		"[ COMBAT ] Druga mini-igra je aktivna, zavrsi je da bi mogao zapoceti combat misiju!"
	},
	{
		"[ COMBAT ] Another player is running a combat mission, try again later!",
		"[ COMBAT ] Combat misi prave hraje jiny hrac, zkus to pozdeji!",
		"[ COMBAT ] Drugi igrac trenutno igra combat misiju, pokusaj kasnije!"
	},
	{
		"[ COMBAT ] Error setting new combat mission!",
		"[ COMBAT ] Nepodarilo se nastavit novou misi!",
		"[ COMBAT ] Greska pri postavljanju nove combat misije!"
	},
	{
		"~w~Combat Mission ~g~Started",
		"~w~Combat Mise ~g~Zahajena",
		"~w~Combat Misija ~g~Pocela"
	},
	{
		"~w~Combat Mission ~r~Aborted",
		"~w~Combat Mise ~r~Zrusena",
		"~w~Combat Misija ~r~Otkazana"
	},
	{
		"~w~Combat Mission ~g~Finished",
		"~w~Combat Mise ~g~Dokoncena",
		"~w~Combat Misija ~g~Zavrsena"
	},
	//
	//  Taxi
	//
	{
		"[ TAXI ] Not a Taximen team member!",
		"[ TAXI ] Nejsi clenem tymu taxikaru!",
		"[ TAXI ] Nisi clan tima Taximen!"
	},
	{
		"[ TAXI ] Not a taxi cab!",
		"[ TAXI ] Musis ridit taxi auto!",
		"[ TAXI ] Moras voziti taksi!"
	},
	{
		"[ TAXI ] Telling the passanger to enter the vehicle...",
		"[ TAXI ] Pasazer nastupuje do auta...",
		"[ TAXI ] Putnik ulazi u vozilo..."
	},
	{
		"[ TAXI ] Good job! Commission earned: $%d",
		"[ TAXI ] Dobra prace! Provize: $%d",
		"[ TAXI ] Dobar posao! Provizija: $%d"
	},
	{
		"[ TAXI ] Database read error!",
		"[ TAXI ] Chyba cteni databaze!",
		"[ TAXI ] Greska pri citanju baze podataka!"
	},
	{
		"[ TAXI ] Too many customers in game, try again later!",
		"[ TAXI ] Ve hre je prilis mnoho zakazniku, zkus to pozdeji!",
		"[ TAXI ] U igri je previse musterija, pokusaj kasnije!"
	},
	{
		"[ TAXI ] Another minigame started, close it to start the taxi mission!",
		"[ TAXI ] Jina minihra jiz bezi, ukonci ji pro zahajeni taxi mise!",
		"[ TAXI ] Druga mini-igra je vec pokrenuta, zavrsi je da bi zapoceo taxi misiju!"
	},
	{
		"~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:____~b~%d~y~:~b~%02d", 
		"~w~Jizd:_____~g~%d~n~~w~Vydelek:_~g~$~y~%d~n~~w~Cas:_____~b~%d~y~:~b~%02d",
		"~w~Voznji:__~g~%d~n~~w~Zarada:__~g~$~y~%d~n~~w~Vrijeme:_~b~%d~y~:~b~%02d"
	},
	{
		"~w~Return to the ~y~taxi cab ~w~to continue the ~y~mission!",
		"~w~Vrat se do ~y~taxiku ~w~k pokracovani zapocate ~y~mise!",
		"~w~Vrati se u ~y~taksi ~w~da nastavis ~y~misiju!"
	},
	{
		"~w~Next destination: ~y~%s",
		"~w~Pristi destinace: ~y~%s",
		"~w~Sljedeca destinacija: ~y~%s"
	},
	{
		"~w~Taxi Mission ~g~Started!",
		"~w~Taxi Mise ~g~Zahajena!",
		"~w~Taxi Misija ~g~Pocela!"
	},
	{
		"~w~Taxi Mission ~r~Aborted!",
		"~w~Taxi Mise ~r~Ukoncena!",
		"~w~Taxi Misija ~r~Otkazana!"
	},
	{
		"[ TAXI ] Finish your current mission before calling a taxi!",
		"[ TAXI ] Pred zavolanim taxi dokonci rozjetou misi!",
		"[ TAXI ] Prije pozivanja taksija zavrsi zapocetu misiju!"
	},
	{
		"[ TAXI ] Dispatch: No taxi is in service right now, try again later!",
		"[ TAXI ] Dispecink: Zadne taxi ted nejezdi, zkus to pozdeji!",
		"[ TAXI ] Dispecer: Trenutno nijedan taksi nije u sluzbi, pokusaj kasnije!"
	},
	{
		"[ TAXI ] Dispatch: Nearest taxi stop is %s (%d m). Next cab in %d:%02d, follow the checkpoint!",
		"[ TAXI ] Dispecink: Nejblizsi zastavka taxi je %s (%d m). Dalsi taxik za %d:%02d, sleduj checkpoint!",
		"[ TAXI ] Dispecer: Najbliza taksi stanica je %s (%d m). Sljedeci taksi za %d:%02d, prati checkpoint!"
	},
	{
		"[ TAXI ] Taxi stop %s: wait for the cab and get in as a passenger (G). Next one in %d:%02d.",
		"[ TAXI ] Zastavka taxi %s: pockej na taxik a nastup jako spolujezdec (G). Dalsi za %d:%02d.",
		"[ TAXI ] Taksi stanica %s: sacekaj taksi i udji kao putnik (G). Sljedeci za %d:%02d."
	},
	{
		"[ TAXI ] Taxi stop %s: a cab is waiting right here, get in as a passenger (G)!",
		"[ TAXI ] Zastavka taxi %s: taxik tu prave ceka, nastup jako spolujezdec (G)!",
		"[ TAXI ] Taksi stanica %s: taksi ceka upravo ovdje, udji kao putnik (G)!"
	},
	{
		"[ TAXI ] Driver: Welcome aboard, sit back and enjoy the ride!",
		"[ TAXI ] Ridic: Vitej na palube, uzij si jizdu!",
		"[ TAXI ] Vozac: Dobro dosao, opusti se i uzivaj u voznji!"
	},
	{
		"[ TAXI ] Driver: Here we are, %s!",
		"[ TAXI ] Ridic: Jsme tady, %s!",
		"[ TAXI ] Vozac: Stigli smo, %s!"
	},
	{
		"[ TAXI ] Driver: Next stop %s, we'll be there in %d:%02d.",
		"[ TAXI ] Ridic: Pristi zastavka %s, budeme tam za %d:%02d.",
		"[ TAXI ] Vozac: Sljedeca stanica %s, stizemo za %d:%02d."
	},
	//
	//  Trucking
	//
	{
		"~w~Done:___________~g~%3d~n~~w~Earned:__~g~$~y~%7d~n~~w~Time:______~b~%4d~y~:~b~%02d",
		"~w~Jizd:___________~g~%3d~n~~w~Vydelek:_~g~$~y~%7d~n~~w~Cas:_______~b~%4d~y~:~b~%02d",
		"~w~Voznji:_________~g~%3d~n~~w~Zarada:__~g~$~y~%7d~n~~w~Vrijeme:___~b~%4d~y~:~b~%02d"
	},
	{
		"[ TRUCK ] Mission completed! Commission earned: $%d",
		"[ TRUCK ] Dobra prace! Provize: $%d",
		"[ TRUCK ] Misija zavrsena! Provizija: $%d"
	},
	{
		"[ TRUCK ] Error setting new mission!",
		"[ TRUCK ] Nepodarilo se nastavit novou misi!",
		"[ TRUCK ] Greska pri postavljanju nove misije!"
	},
	{
		"~w~Return to ~y~the truck ~w~to continue ~y~the mission!",
		"~w~Vrat se do ~y~kabiny nakladaku ~w~pro pokracovani ~y~mise!",
		"~w~Vrati se u ~y~kamion ~w~da nastavis ~y~misiju!"
	},
	{
		"~w~Trailer ~r~Detached! ~w~Reattach to continue the mission!",
		"~w~Prives ~r~Odpojen! ~w~Pripoj jej zpet pro pokracovani mise!",
		"~w~Prikolica ~r~Odvojena! ~w~Zakaci je ponovo za nastavak!"
	},
	{
		"~w~Next destination: ~y~%s",
		"~w~Dalsi destinace: ~y~%s",
		"~w~Sljedeca destinacija: ~y~%s"
	},
	{
		"~w~Trucking Mission ~g~Started",
		"~w~Trucking mise ~g~Zahajena",
		"~w~Trucking Misija ~g~Pocela"
	},
	{
		"~w~Trucking Mission ~r~Aborted",
		"~w~Trucking mise ~r~Zrusena",
		"~w~Trucking Misija ~r~Otkazana"
	},
	{
		"[ TRUCK ] Mission aborted",
		"[ TRUCK ] Mise zrusena",
		"[ TRUCK ] Misija otkazana"
	},
	{
		"[ TRUCK ] Another minigame started, close it to start the trucking mission!",
		"[ TRUCK ] Jina minihra je aktivni, ukonci ji, abys mohl zacit trucking misi!",
		"[ TRUCK ] Druga mini-igra je aktivna, zavrsi je da bi mogao zapoceti trucking misiju!"
	},
	{
		"[ TRUCK ] You have to be in a truck as driver!",
		"[ TRUCK ] Musis byt ridicem kamionu!",
		"[ TRUCK ] Moras biti vozac kamiona!"
	},
	{
		"[ TRUCK ] No trailer attached!",
		"[ TRUCK ] Nemas pripojeny zadny naves!",
		"[ TRUCK ] Nemas zakacenu prikolicu!"
	},
	{
		"[ TRUCK ] Unknown trailer model",
		"[ TRUCK ] Neznamy model navesul",
		"[ TRUCK ] Nepoznat model prikolice"
	},
	{
		"[ TRUCK ] Vehicle and trailer registered successfully",
		"[ TRUCK ] Kamion a naves uspesne zaregistrovany k misi",
		"[ TRUCK ] Kamion i prikolica uspjesno registrovani za misiju"
	},
	//
	//  Tow
	//
	{
		"~w~Models:_~g~%d~n~~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:____~b~%d~y~:~b~%02d",
		"~w~Modely:_~g~%d~n~~w~Zavezeno:_~g~%d~n~~w~Vydelek:__~g~$~y~%d~n~~w~Cas:_____~b~%d~y~:~b~%02d",
		"~w~Modeli:_~g~%d~n~~w~Dostave:_~g~%d~n~~w~Zarada:__~g~$~y~%d~n~~w~Vrijeme:_~b~%d~y~:~b~%02d"
	},
	{
		"~w~Return to ~y~the truck ~w~to continue ~y~the tow mission!",
		"~w~Vrat se do ~y~odtahovky ~w~pro pokracovani ~y~mise!",
		"~w~Vrati se u ~y~vucno vozilo ~w~da nastavis ~y~misiju vuce!"
	},
	{
		"~w~Tow Mission ~g~Started",
		"~w~Odtahova mise ~g~Zahajena",
		"~w~Misija vuce ~g~Pocela"
	},
	{
		"~w~Tow Mission ~r~Aborted",
		"~w~Odtahova mise ~r~Zrusena",
		"~w~Misija vuce ~r~Otkazana"
	},
	{
		"[ TOW ] Another minigame started, close it to start the towing mission!",
		"[ TOW ] Jina minihra je aktivni, ukonci ji, abys zahajil odtahovou misi!",
		"[ TOW ] Druga mini-igra je aktivna, zavrsi je da bi zapoceo misiju vuce!"
	},
	{
		"[ TOW ] You must be driving the Tow Truck!",
		"[ TOW ] Nejsi ridicem odtahovky!",
		"[ TOW ] Moras voziti vucno vozilo!"
	},
	{
		"[ TOW ] Invalid car!",
		"[ TOW ] Neplatne vozidlo!",
		"[ TOW ] Nevazece vozilo!"
	},
	{
		"[ TOW ] New trailer attached successfully!",
		"[ TOW ] Nove vozidlo uspesne pripojeno!",
		"[ TOW ] Novo vozilo uspjesno zakaceno!"
	},
	{
		"[ TOW ] Trailer detached successfully!",
		"[ TOW ] Vozidlo uspesne odpojeno!",
		"[ TOW ] Vozilo uspjesno otkaceno!"
	},
	{
		"[ TOW ] This vehicle model has been already towed!",
		"[ TOW ] Tento model vozidla jiz byl odtazen!",
		"[ TOW ] Ovaj model vozila je vec odvucen!"
	},
	{
		"[ TOW ] New vehicle model (%s) towed! A bonus to commission of $2500!",
		"[ TOW ] Novy model vozidla (%s) odtazen! Bonus $2500!",
		"[ TOW ] Odvucen novi model vozila (%s)! Bonus na proviziju $2500!"
	},
	{
		"[ TOW ] Mission completed! Commision earned: $%d",
		"[ TOW ] Dobra prace! Provize: $%d",
		"[ TOW ] Misija zavrsena! Provizija: $%d"
	},
	{
		"[ HD ] HUD layout set for the HD (widescreen) version of GTA SA! Use /hd again to revert.",
		"[ HD ] Rozlozeni HUD nastaveno pro HD (sirokouhlou) verzi GTA SA! Pro navrat pouzij znovu /hd.",
		"[ HD ] Raspored HUD-a postavljen za HD (widescreen) verziju GTA SA! Za povratak ponovo koristi /hd."
	},
	{
		"[ HD ] Classic HUD layout restored!",
		"[ HD ] Klasicke rozlozeni HUD obnoveno!",
		"[ HD ] Klasicni raspored HUD-a je vracen!"
	},
	//
	//  Rob mission
	//
	{
		"~w~Robbed:____~g~%d~n~~w~Earned:____~g~$%d~n~~w~Time:______~b~%d~y~:~b~%02d",
		"~w~Vykradeno:_~g~%d~n~~w~Lup:_______~g~$%d~n~~w~Cas:_______~b~%d~y~:~b~%02d",
		"~w~Pljacki:___~g~%d~n~~w~Plijen:____~g~$%d~n~~w~Vrijeme:___~b~%d~y~:~b~%02d"
	},
	{
		"~y~Rob ~w~Mission ~g~Started~w~.",
		"~y~Loupezna ~w~Mise ~g~Zapocala.",
		"~y~Pljackaska ~w~Misija ~g~Pocela~w~."
	},
	{
		"~y~Rob ~w~Mission ~r~Ended~w~.",
		"~y~Loupezna ~w~Mise ~r~Skoncila.",
		"~y~Pljackaska ~w~Misija ~r~Zavrsena~w~."
	},
	{
		"[ ROB ] Rob mission over! Properties robbed: %d, earned: $%d",
		"[ ROB ] Loupezna mise skoncila! Vykradeno nemovitosti: %d, lup: $%d",
		"[ ROB ] Pljackaska misija je gotova! Opljackano nekretnina: %d, plijen: $%d"
	},
	{
		"[ ROB ] Robbing %s! Hold the key for up to %d seconds.",
		"[ ROB ] Vykradas %s! Drz klavesu az %d sekund.",
		"[ ROB ] Pljackas %s! Drzi tipku do %d sekundi."
	},
	{
		"~w~Robbing~n~~g~$%d ~w~(%d s)",
		"~w~Loupez~n~~g~$%d ~w~(%d s)",
		"~w~Pljacka~n~~g~$%d ~w~(%d s)"
	},
	{
		"[ ROB ] You took $%d from %s! The property is locked for 5 minutes now.",
		"[ ROB ] Ukoristil jsi $%d z %s! Nemovitost je ted na 5 minut zamcena.",
		"[ ROB ] Uzeo si $%d iz %s! Nekretnina je sada zakljucana na 5 minuta."
	},
	{
		"[ ROB ] You let go too early, nothing taken! The property is locked for 5 minutes now.",
		"[ ROB ] Pustil jsi prilis brzy, nic jsi neukoristil! Nemovitost je ted na 5 minut zamcena.",
		"[ ROB ] Pustio si prerano, nista nisi uzeo! Nekretnina je sada zakljucana na 5 minuta."
	},
	{
		"[ ROB ] This property has been robbed recently, try again in %d:%02d!",
		"[ ROB ] Tahle nemovitost byla nedavno vykradena, zkus to znovu za %d:%02d!",
		"[ ROB ] Ova nekretnina je nedavno opljackana, pokusaj ponovo za %d:%02d!"
	},
	{
		"[ ROB ] Someone else is robbing this property right now!",
		"[ ROB ] Tuhle nemovitost prave vykrada nekdo jiny!",
		"[ ROB ] Neko drugi upravo pljacka ovu nekretninu!"
	},
	{
		"[ ROB ] You cannot rob your own property!",
		"[ ROB ] Nemuzes vykrast vlastni nemovitost!",
		"[ ROB ] Ne mozes opljackati svoju nekretninu!"
	},
	{
		"[ ROB ] You cannot rob while in another minigame!",
		"[ ROB ] Nemuzes loupit, kdyz jsi v jine minihre!",
		"[ ROB ] Ne mozes pljackati dok si u drugoj mini-igri!"
	},
	{
		"[ ROB ] Hold LALT or LSHIFT by a commercial property (blue house pickup) to rob it, up to 20 seconds at a time.",
		"[ ROB ] Drz LALT nebo LSHIFT u komercni nemovitosti (modry domecek) a vykrades ji, pokazde az na 20 sekund.",
		"[ ROB ] Drzi LALT ili LSHIFT kod komercijalne nekretnine (plava kucica) da je opljackas, svaki put do 20 sekundi."
	},
	{
		"[ CASH ] One of your rented properties has just been robbed! It brings you no commission for the next 5 minutes.",
		"[ CASH ] Jedna z tvych pronajatych nemovitosti byla prave vykradena! Dalsich 5 minut ti z ni neplyne zadna provize.",
		"[ CASH ] Jedna od tvojih iznajmljenih nekretnina je upravo opljackana! Narednih 5 minuta ti ne donosi proviziju."
	},
	//
	//  Quests
	//
	{
		"[ QUEST ] Quest completed: %s! Reward: $%d",
		"[ QUEST ] Ukol splnen: %s! Odmena: $%d",
		"[ QUEST ] Zadatak zavrsen: %s! Nagrada: $%d"
	},
	{
		"~y~Quest completed!~n~~g~$%d",
		"~y~Ukol splnen!~n~~g~$%d",
		"~y~Zadatak zavrsen!~n~~g~$%d"
	},
	//
	//  Fuel
	//
	{
		"[ FUEL ] You have to drive a vehicle to fill it up!",
		"[ FUEL ] Musis ridit vozidlo, abys ho mohl natankovat!",
		"[ FUEL ] Moras voziti vozilo da bi natocio gorivo!"
	},
	{
		"[ FUEL ] There is no petrol station nearby!",
		"[ FUEL ] V blizkosti neni zadna cerpaci stanice!",
		"[ FUEL ] U blizini nema benzinske pumpe!"
	},
	{
		"[ FUEL ] %s has run dry, wait for a tanker to top it up!",
		"[ FUEL ] %s nema zadne palivo, pockej na cisternu!",
		"[ FUEL ] %s nema goriva, sacekaj cisternu!"
	},
	{
		"[ FUEL ] Not enough cash, a litre costs $%d here!",
		"[ FUEL ] Nemas dost penez, litr tu stoji $%d!",
		"[ FUEL ] Nemas dovoljno novca, litar ovdje kosta $%d!"
	},
	{
		"[ FUEL ] Filled up %d L at %s for $%d",
		"[ FUEL ] Natankovano %d l na %s za $%d",
		"[ FUEL ] Natoceno %d L na %s za $%d"
	},
	//
	//  Anticheat
	//
	{
		"[ ! ] Anticheat reverted your weapons/health to what the server gave you (warning %d/%d)!",
		"[ ! ] Anticheat ti vratil zbrane/zdravi na stav, ktery ti dal server (varovani %d/%d)!",
		"[ ! ] Anticheat ti je vratio oruzje/zdravlje na stanje koje ti je dao server (upozorenje %d/%d)!"
	},
	{
		"[ ! ] Player %s was kicked from the server for repeated cheating!",
		"[ ! ] Hrac %s byl(a) vyhozen(a) za opakovane podvadeni!",
		"[ ! ] Igrac %s je izbacen sa servera zbog ponovljenog varanja!"
	},
	//
	//  Fence
	//
	{
		"[ FENCE ] The fence only buys from Dealerz!",
		"[ PASERAK ] Paserak vykupuje jen od Dealerz!",
		"[ OTKUP ] Otkupljivac kupuje samo od Dealerz!"
	},
	{
		"[ FENCE ] The fence only deals at a druggery point (skull pickup)!",
		"[ PASERAK ] Paserak obchoduje jen na drogovem miste (pickup s lebkou)!",
		"[ OTKUP ] Otkupljivac radi samo na mjestu za droge (pickup s lobanjom)!"
	},
	{
		"[ FENCE ] Wrong amount, or you don't have that much of it in your pockets!",
		"[ PASERAK ] Spatne mnozstvi, nebo tolik toho v kapsach nemas!",
		"[ OTKUP ] Pogresna kolicina, ili toliko nemas u dzepovima!"
	},
	{
		"[ FENCE ] The fence can't deal right now, try again later!",
		"[ PASERAK ] Paserak ted nemuze obchodovat, zkus to pozdeji!",
		"[ OTKUP ] Otkupljivac trenutno ne moze trgovati, pokusaj kasnije!"
	},
	{
		"[ FENCE ] At the current market ratio the fence would pay nothing for that!",
		"[ PASERAK ] Pri aktualnim kurzu na trhu by ti za to paserak nedal nic!",
		"[ OTKUP ] Po trenutnom kursu na trzistu otkupljivac ti za to ne bi dao nista!"
	},
	{
		"[ FENCE ] The fence buys no more from you this hour (limit: %d g / $%d per hour)!",
		"[ PASERAK ] Paserak od tebe tuto hodinu uz nic nekoupi (limit: %d g / $%d za hodinu)!",
		"[ OTKUP ] Otkupljivac ovaj sat od tebe vise nista ne kupuje (limit: %d g / $%d po satu)!"
	},
	{
		"[ FENCE ] Sold %d g of %s for $%d (ratio: %.3f).",
		"[ PASERAK ] Prodano %d g %s za $%d (kurz: %.3f).",
		"[ OTKUP ] Prodano %d g %s za $%d (kurs: %.3f)."
	},
	{
		"[ FENCE ] The hourly limit let you sell only %d of %d g (left this hour: %d g / $%d).",
		"[ PASERAK ] Hodinovy limit ti dovolil prodat jen %d z %d g (zbyva tuto hodinu: %d g / $%d).",
		"[ OTKUP ] Limit po satu ti je dozvolio da prodas samo %d od %d g (ostalo ovaj sat: %d g / $%d)."
	},
	{
		"[ MARKET ] The market ratio hit its maximum of %.0f! The fence at the druggery points pays top dollar now.",
		"[ TRH ] Kurz na trhu dosahl maxima %.0f! Paserak na drogovych mistech ted plati nejvic.",
		"[ TRZISTE ] Kurs na trzistu je dostigao maksimum od %.0f! Otkupljivac na mjestima za droge sada placa najvise."
	},
	//  Deals
	{
		"[ DEAL ] The dealer no longer has that amount, the deal was cancelled.",
		"[ DEAL ] Dealer uz takove mnozstvi nema, obchod byl zrusen.",
		"[ DEAL ] Diler vise nema tu kolicinu, posao je otkazan."
	},
	//  Rampage
	{
		"[ RAMPAGE ] Someone is on this rampage already, come back later!",
		"[ RAMPAGE ] Tenhle rampage uz nekdo hraje, prijd pozdeji!",
		"[ RAMPAGE ] Neko vec igra ovaj rampage, dodji kasnije!"
	},
	//  Admin
	{
		"[ ADMIN ] The player is not logged in, the admin level could not be saved!",
		"[ ADMIN ] Hrac neni prihlasen, admin level by nesel ulozit!",
		"[ ADMIN ] Igrac nije prijavljen, admin level se ne bi mogao sacuvati!"
	}
};

new gAdminColNames[6][PlayerLocale][] = {
	{
		"none",
		"zadna",
		"nikakvu"
	},
	{
		"green",
		"zelenou",
		"zelenu"
	},
	{
		"blue",
		"modrou",
		"plavu"
	},
	{
		"red",
		"cervenou",
		"crvenu"
	},
	{
		"orange",
		"oranzovou",
		"narandzastu"
	},
	{
		"white",
		"bilou",
		"bijelu"
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
