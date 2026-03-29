#include <open.mp>

#include "includes/test_helpers.pwn"

Test:PlayerRegistration()
{
	TEST_START("PlayerRegistration");
	
	new playerid = CreateTestPlayer();
    
	// Test registration system
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	ASSERT_TRUE(strlen(name) > 0);
    
	// Test default values
	//ASSERT_EQ(GetPlayerMoney(playerid), 0);
	//ASSERT_FLOAT_EQ(GetPlayerHealth(playerid), 100.0);
    
	DestroyTestPlayer();

	TEST_END("PlayerRegistration");
}
