//
//  test_utils.pwn
//  The string, number and list helpers (helpers.pwn, and the list parsers in
//  team.pwn, player.pwn and real.pwn that read comma separated DB columns).
//

Test: HelpersStrings()
{
	TEST_START("HelpersStrings");

	new
		haystack[] = "a,b,c",
		empty[] = "",
		digits[] = "0123456789",
		negative[] = "-5",
		spaced[] = "12 3",
		word[] = "12a",
		comma = ',',
		letter = 'x';

	ASSERT_EQ(chrfind(comma, haystack), 1);
	ASSERT_EQ(chrfind(comma, haystack, 2), 3);
	ASSERT_EQ(chrfind(letter, haystack), -1);
	ASSERT_EQ(chrfind(comma, empty), -1);

	ASSERT_TRUE(IsNumeric(digits));
	ASSERT_FALSE(IsNumeric(negative));
	ASSERT_FALSE(IsNumeric(spaced));
	ASSERT_FALSE(IsNumeric(word));

	// The dialogs check strval() too: an empty input passes IsNumeric()
	ASSERT_TRUE(IsNumeric(empty));

	new
		token1[32],
		token2[32],
		command[] = "bank depo 500",
		single[] = "balance",
		list[] = "50,0,0",
		expectBank[] = "bank",
		expectDepo[] = "depo 500",
		expectBalance[] = "balance",
		expect50[] = "50",
		expectRest[] = "0,0";

	ASSERT_EQ(SplitIntoTwo(command, token1, token2, sizeof(token1)), 2);
	ASSERT_STREQ(token1, expectBank);
	ASSERT_STREQ(token2, expectDepo);

	ASSERT_EQ(SplitIntoTwo(single, token1, token2, sizeof(token1)), 1);
	ASSERT_STREQ(token1, expectBalance);
	ASSERT_EQ(strlen(token2), 0);

	new
		parts = SplitIntoTwo(list, token1, token2, sizeof(token1), ",");

	ASSERT_EQ(parts, 2);
	ASSERT_STREQ(token1, expect50);
	ASSERT_STREQ(token2, expectRest);

	new
		sanitized[32],
		quoted[] = "it's",
		plain[] = "plain",
		expectQuoted[] = "it''s";

	SanitizeString(quoted, sanitized, sizeof(sanitized));
	ASSERT_STREQ(sanitized, expectQuoted);

	SanitizeString(plain, sanitized, sizeof(sanitized));
	ASSERT_STREQ(sanitized, plain);

	// Never past the end of a short buffer, even with a quote at the cut
	new
		tiny[5],
		quotes[] = "''''''";

	SanitizeString(quotes, tiny, sizeof(tiny));
	ASSERT_TRUE(strlen(tiny) < sizeof(tiny));

	TEST_END("HelpersStrings");
}

// Expects <timestamp> to be <y>-<mo>-<d> <h>:<mi>:<s> UTC.
stock CheckUnixToDateTime(timestamp, y, mo, d, h, mi, s)
{
	new
		year,
		month,
		day,
		hour,
		minute,
		second;

	UnixToDateTime(timestamp, year, month, day, hour, minute, second);

	if (year != y || month != mo || day != d || hour != h || minute != mi || second != s)
	{
		printf("[INFO] UnixToDateTime(%d) = %04d-%02d-%02d %02d:%02d:%02d, expected %04d-%02d-%02d %02d:%02d:%02d",
				timestamp, year, month, day, hour, minute, second, y, mo, d, h, mi, s);

		return 0;
	}

	return 1;
}

Test: HelpersUnixToDateTime()
{
	TEST_START("HelpersUnixToDateTime");

	ASSERT_TRUE(CheckUnixToDateTime(0, 1970, 1, 1, 0, 0, 0));

	// 2000 is a leap year (divisible by 400), 2024 an ordinary one
	ASSERT_TRUE(CheckUnixToDateTime(951782400, 2000, 2, 29, 0, 0, 0));
	ASSERT_TRUE(CheckUnixToDateTime(951868799, 2000, 2, 29, 23, 59, 59));
	ASSERT_TRUE(CheckUnixToDateTime(1709251199, 2024, 2, 29, 23, 59, 59));
	ASSERT_TRUE(CheckUnixToDateTime(1735689599, 2024, 12, 31, 23, 59, 59));

	// The last second a 32-bit cell holds
	ASSERT_TRUE(CheckUnixToDateTime(2147483647, 2038, 1, 19, 3, 14, 7));

	TEST_END("HelpersUnixToDateTime");
}

Test: HelpersWeaponModel()
{
	TEST_START("HelpersWeaponModel");

	ASSERT_EQ(GetWeaponModel(0), 0);
	ASSERT_EQ(GetWeaponModel(1), 331);
	ASSERT_EQ(GetWeaponModel(24), 348);
	ASSERT_EQ(GetWeaponModel(31), 356);
	ASSERT_EQ(GetWeaponModel(32), 372);
	ASSERT_EQ(GetWeaponModel(46), 371);

	// Unused ids and anything out of range have no model
	ASSERT_EQ(GetWeaponModel(20), 0);
	ASSERT_EQ(GetWeaponModel(47), 0);
	ASSERT_EQ(GetWeaponModel(-1), 0);

	TEST_END("HelpersWeaponModel");
}

Test: HelpersListParsing()
{
	TEST_START("HelpersListParsing");

	// The teams table colors
	new
		color[] = "008B8BAA",
		robberz[] = "9932CCAA",
		ff[] = "FF",
		noColor[] = "";

	ASSERT_EQ(HexToInt(color), 0x008B8BAA);
	ASSERT_EQ(HexToInt(robberz), 0x9932CCAA);
	ASSERT_EQ(HexToInt(ff), 255);
	ASSERT_EQ(HexToInt(noColor), 0);

	new
		skins[5],
		skinList[] = "271,1,2";

	ExtractSkinsFromString(skinList, skins);
	ASSERT_EQ(skins[0], 271);
	ASSERT_EQ(skins[1], 1);
	ASSERT_EQ(skins[2], 2);

	new
		weapons[MAX_TEAM_WEAPONS],
		weaponList[] = "5,23,26,28,0,0,0,0,0,0,46";

	ExtractWeaponsAmmuFromString(weaponList, weapons);
	ASSERT_EQ(weapons[0], 5);
	ASSERT_EQ(weapons[3], 28);
	ASSERT_EQ(weapons[4], 0);
	ASSERT_EQ(weapons[MAX_TEAM_WEAPONS - 1], 46);

	new
		properties[MAX_PLAYER_PROPERTIES],
		propertyList[] = "12,0,345";

	ExtractPropperties(propertyList, properties);
	ASSERT_EQ(properties[0], 12);
	ASSERT_EQ(properties[1], 0);
	ASSERT_EQ(properties[2], 345);

	new
		ints[16],
		intList[] = "7";

	ExtractIntsFromString(intList, ints);
	ASSERT_EQ(ints[0], 7);

	new
		Float: coords[Coords],
		coordList[] = "1.5,-2.25,10.0,90.0";

	ExtractCoordsFromString(coordList, coords);
	ASSERT_FLOAT_EQ(coords[CoordX], 1.5);
	ASSERT_FLOAT_EQ(coords[CoordY], -2.25);
	ASSERT_FLOAT_EQ(coords[CoordZ], 10.0);
	ASSERT_FLOAT_EQ(coords[CoordR], 90.0);

	TEST_END("HelpersListParsing");
}
