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

	bool: PropertyRented,
      	bool: PropertyBought,
      	bool: RaceFinished,
      	bool: JoinedTeam,
	bool: WentTrucking,
	bool: DkdTaxiMission,
	bool: SentPM,
	bool: DepositedMoneyToBank,
	bool: PlayedDeathmath
};

#pragma unused gPlayerTutorial
new gPlayerTutorial[MAX_PLAYERS][Tutorial];


