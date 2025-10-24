#if defined _CRL2_TEAM
	#endinput
#endif
#define _CRL2_TEAM

//
//  team.pwn
//

#define MAX_TEAMS		10
#define MAX_TEAM_PICKUPS	16
#define MAX_TEAM_MENUS		16
#define MAX_TEAM_WEAPONS	11

#include "db/sql.pwn"

enum 
{
	TEAM_NONE,
	TEAM_MECHANICS,
	TEAM_ADMINZ,
	TEAM_POLICE,
	TEAM_TRUCKERS,
	TEAM_TAXIMEN,
	TEAM_GARBAGEMEN,
	TEAM_PIZZAGUYS,
	TEAM_HACKERS,
	TEAM_DEALERS
}

enum Team
{
	ID,
	TeamName[64],
	Color,
	Skins[5],

	Weapons[MAX_TEAM_WEAPONS],
	Ammo[MAX_TEAM_WEAPONS],

	SalaryBase,
	SalaryVolatile,

	PICKUP: Pickups[MAX_TEAM_PICKUPS],
	Menu: Menus[MAX_TEAM_MENUS]
}

new gTeams[MAX_TEAMS][Team];

forward InitTeams();

public InitTeams()
{
	new i = 0, query[512];

	format(query, sizeof(query), "SELECT id,name,color,skins,weapons,ammu,salary_base_dollars,salary_volatile_dollars FROM teams");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch team data!");
		return 0;
	}

	while (DB_SelectNextRow(result))
	{
		new 
			name[64],
		       	ammo[MAX_TEAM_WEAPONS],	
			ammoString[128], 
			colorString[128],
			skins[5],
			skinsString[128], 
			weapons[MAX_TEAM_WEAPONS],
			weaponsString[128];

		DB_GetFieldStringByName(result, "name", name, sizeof(name));
		gTeams[i][TeamName] = name;

		gTeams[i][ID] = DB_GetFieldIntByName(result, "id");
		gTeams[i][SalaryBase] = DB_GetFieldIntByName(result, "salary_base_dollars");
		gTeams[i][SalaryVolatile] = DB_GetFieldIntByName(result, "salary_volatile_dollars");

		// Color
		DB_GetFieldStringByName(result, "color", colorString, sizeof(colorString));
		gTeams[i][Color] = HexToInt(colorString);

		// Skins
		DB_GetFieldStringByName(result, "skins", skinsString, sizeof(skinsString));
		ExtractSkinsFromString(skinsString, skins);
		gTeams[i][Skins] = skins;

		// Weapons
		DB_GetFieldStringByName(result, "weapons", weaponsString, sizeof(weaponsString));
		ExtractWeaponsAmmuFromString(weaponsString, weapons);
		gTeams[i][Weapons] = weapons;

		// Ammo
		DB_GetFieldStringByName(result, "ammu", ammoString, sizeof(ammoString));
		ExtractWeaponsAmmuFromString(ammoString, ammo);
		gTeams[i][Ammo] = ammo;

		printf("-> Team %s (ID: %d, color: %d) loaded!", gTeams[i][TeamName], gTeams[i][ID], gTeams[i][Color]);

		i++;
	}

	print("Teams initialized!");
	DB_FreeResultSet(result);

	return 1;
}

stock HexToInt(const string[])
{
    if (!string[0])
    {
        return 0;
    }

    new
        cur = 1,
        res = 0;

    for (new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

stock ExtractSkinsFromString(const input[], ints[5])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		ints[i] = strval(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return ints;
}

stock ExtractWeaponsAmmuFromString(const input[], ints[MAX_TEAM_WEAPONS])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		ints[i] = strval(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return ints;
}

stock CheckTaxiDriversOnline()
{
	return 0;
}

stock CheckCarMechanicsOnline()
{
	return 0;
}

stock CheckPizzaguysOnline()
{
	return 0;
}
