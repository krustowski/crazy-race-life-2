#if defined _CRL2_TIMERS
	#endinput
#endif
#define _CRL2_TIMERS

//
//  timers.pwn
//

stock InitTimers() 
{
	SetTimer("AntiCheatWeapon", 30 * SECOND_MS, true);
	
	// Breaks connections often while player's in the game menu
	//SetTimer("AntiFlood", 1 * SECOND_MS, true);

	SetTimer("OnRadarCheckpoint", 300, true);

	SetTimer("AutosaveData", 3 * 60 * SECOND_MS, true);
	SetTimer("UpdatePlayerPlayTime", 10 * SECOND_MS, true);
	SetTimer("UpdatePlayerScore", 2 * SECOND_MS, true);

	SetTimer("UpdateBlackMarketRatio", 3 * 60 * SECOND_MS, true);

	SetTimer("SendPlayerSalary", 5 * 60 * SECOND_MS, true);
	SetTimer("SendRealEstateCommission", 5 * 60 * SECOND_MS, true);

	SetTimer("DrawClockText", 10 * SECOND_MS, true);

	SetTimer("ShowAdvert", 2 * 60 * SECOND_MS, true);
}

