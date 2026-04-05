#include <open.mp>

#include "support/includes.pwn"

#include "includes/test_helpers.pwn"

Test:MemoryInit()
{
	TEST_START("MemoryInit");

	new 
		size = sizeof(gI18nMessages),
		stringToPrint[64];

	format(stringToPrint, sizeof(stringToPrint), "sizeof(gI18nMessages): %d bytes\n", size);
	print(stringToPrint);
	ASSERT_TRUE(size > 0);
	
	TEST_END("MemoryInit");
}


