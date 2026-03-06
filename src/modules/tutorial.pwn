#if defined _CRL2_TUTORIAL
	#endinput
#endif
#define _CRL2_TUTORIAL

//
//  tutorial.pwn
//  A special module to guide new players through the game,
//

/*
 *  Raw notes: buy a house, go racing, go trucking, go taxi, rent a property, join a team,...
 *
 *  
 */

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

#pragma unused gPlayerTutorial
new gPlayerTutorial[MAX_PLAYERS][Tutorial];


