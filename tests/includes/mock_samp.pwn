/*
 *  mock_samp.inc - Mock SA-MP natives for testing
 */

#if defined RUNNING_TESTS
// Mock implementations for testing
stock Mock_GetPlayerMoney(playerid) 
{
	return gMockPlayerMoney[playerid];
}
    
stock Mock_GivePlayerMoney(playerid, money)
{
	gMockPlayerMoney[playerid] += money;
	return 1;
}
    
// Redirect natives to mocks
#define GetPlayerMoney Mock_GetPlayerMoney
#define GivePlayerMoney Mock_GivePlayerMoney
    
// Mock variables
new gMockPlayerMoney[MAX_PLAYERS];

#else
// Use real SA-MP functions
native GetPlayerMoney(playerid);
native GivePlayerMoney(playerid, money);

#endif
