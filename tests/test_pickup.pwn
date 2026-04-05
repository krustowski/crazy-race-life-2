#include <open.mp>

#include "includes/test_helpers.pwn"

#include "support/includes.pwn"

Test:PickupCreate()
{
	TEST_START("PickupCreate");
	
	new 
		id = EnsurePickupCreated(1272, 1, 0.0, 0.0, 0.0);

	ASSERT_TRUE(id > 0);

	DestroyPickup(id);

	TEST_END("PickupCreate");
}

