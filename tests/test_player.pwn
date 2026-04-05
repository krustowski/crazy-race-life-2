#include <open.mp>

#include "includes/test_helpers.pwn"

#include "support/includes.pwn"

Test:PlayerConnect()
{
	TEST_START("PlayerConnect");
	
	new 
		playerid = CreateTestPlayer();
    
	// Test registration system
	new 
		name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	ASSERT_TRUE(strlen(name) > 0);
    
	// Test default values
	ASSERT_EQ(GetPlayerMoney(playerid), 0);

	new 
		Float:health;
	GetPlayerHealth(playerid, health);
	ASSERT_FLOAT_EQ(health, 0.0);
    
	DestroyTestPlayer();

	TEST_END("PlayerConnect");
}

Test:PlayerRegistration()
{
	TEST_START("PlayerRegistration");
	
	new 
		playerid = CreateTestPlayer(),
		reg = SetPlayerAccountRegistration(playerid, "test1234");
    
	ASSERT_TRUE(reg == 1);

	reg = SetPlayerAccountRegistration(playerid, "test1234");

	ASSERT_TRUE(reg == 0);

	DestroyTestPlayer();

	TEST_END("PlayerRegistration");
}
