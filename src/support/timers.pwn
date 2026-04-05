#if defined _CRL2_TIMERS
	#endinput
#endif
#define _CRL2_TIMERS

//
//  timers.pwn
//

enum ServerTimer
{
	TIMER_NONE,
	TIMER_ANTICHEAT_WEAPON,
	TIMER_ANTIFLOOD,
	TIMER_ON_RADAR_CHECKPOINT,
	TIMER_AUTOSAVE_DATA,
	TIMER_UPDATE_PLAYER_PLAYTIME,
	TIMER_UPDATE_PLAYER_SCORE,
	TIMER_UPDATE_BLACK_MARKET_RATIO,
	TIMER_SEND_PLAYER_SALARY,
	TIMER_SEND_REAL_ESTATE_COMMISSION,
	TIMER_DRAW_CLOCK_TEXT,
	TIMER_SHOW_ADVERT
}

new
	Timer: gTimers[ServerTimer];

stock InitTimers() 
{
	gTimers[TIMER_ANTICHEAT_WEAPON] = SetTimer("AntiCheatWeapon", 30 * SECOND_MS, true);
	
	// Breaks connections often while player's in the game menu
	//gTimers[TIMER_ANTIFLOOD] = SetTimer("AntiFlood", 1 * SECOND_MS, true);

	gTimers[TIMER_ON_RADAR_CHECKPOINT] = SetTimer("OnRadarCheckpoint", 300, true);

	gTimers[TIMER_AUTOSAVE_DATA] = SetTimer("AutosaveData", 3 * 60 * SECOND_MS, true);
	gTimers[TIMER_UPDATE_PLAYER_PLAYTIME] = SetTimer("UpdatePlayerPlayTime", 10 * SECOND_MS, true);
	gTimers[TIMER_UPDATE_PLAYER_SCORE] = SetTimer("UpdatePlayerScore", 2 * SECOND_MS, true);

	gTimers[TIMER_UPDATE_BLACK_MARKET_RATIO] = SetTimer("UpdateBlackMarketRatio", 3 * 60 * SECOND_MS, true);

	gTimers[TIMER_SEND_PLAYER_SALARY] = SetTimer("SendPlayerSalary", 5 * 60 * SECOND_MS, true);
	gTimers[TIMER_SEND_REAL_ESTATE_COMMISSION] = SetTimer("SendRealEstateCommission", 5 * 60 * SECOND_MS, true);

	gTimers[TIMER_DRAW_CLOCK_TEXT] = SetTimer("DrawClockText", 10 * SECOND_MS, true);

	gTimers[TIMER_SHOW_ADVERT] = SetTimer("ShowAdvert", 2 * 60 * SECOND_MS, true);
}

stock KillTimers()
{
	for (new i = 0; i < sizeof(gTimers); i++)
	{
		KillTimer(_: gTimers[ServerTimer: i]);
	}
}
