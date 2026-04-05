#include <open.mp>

#include "support/includes.pwn"

#include "includes/test_helpers.pwn"

Test:MemoryInit()
{
	TEST_START("MemoryInit");

	printf("sizeof gI18nMessages: %d * %d * %d bytes\n", 
			sizeof(gI18nMessages),
			sizeof(gI18nMessages[]),
			sizeof(gI18nMessages[][])
		);
	
	TEST_END("MemoryInit");
}


