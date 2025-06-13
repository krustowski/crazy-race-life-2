#include <open.mp>
#include <a_mysql>
#include <core>
#include <float>
#include <file>
#include <string>

#include "../src/modules/player.pwn"
#include "../src/modules/real.pwn"
#include "../src/support/helpers.pwn"

main()
{
	new id = EnsurePickupCreated(1272, 1, 0.0, 0.0, 0.0);

	if (id)
		printf("[ PASS ] EnsurePickupCreated() returned %d ", id);
	else
		printf("[ FAIL ] EnsurePickupCreated() returned %d, expected >0", id);
}
