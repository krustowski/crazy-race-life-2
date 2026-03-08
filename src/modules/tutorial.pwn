#if defined _CRL2_TUTORIAL
	#endinput
#endif
#define _CRL2_TUTORIAL

//
//  tutorial.pwn
//  A special module to guide new players through the game,
//

enum Tutorial
{
	bool: Active,
	      
	PropertyRentedCount,
	PropertyBoughtCount,
	RaceFinishedCount,
	bool: JoinedTeam,
	TruckingMissionsDone,
	TaxiMissionsDone,
	bool: SentPM,
	DepositedMoneyToBank,
	bool: DeathmatchPlayed
};

