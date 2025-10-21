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
	Ammu[MAX_TEAM_WEAPONS],

	SalaryBase,
	SalaryVolatile,

	PICKUP: Pickups[MAX_TEAM_PICKUPS],
	Menu: Menus[MAX_TEAM_MENUS]
}

new gTeams[MAX_TEAMS][Team];

/*new gTeamNone[Team] = 
{
	0,
	"Blank team (stub)",
	0,
	{0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	0,
	0
};*/

enum 
{
	FIELD_TEAM_ID,
	FIELD_TEAM_NAME,
	FIELD_TEAM_COLOR,
	FIELD_TEAM_SKINS,
	FIELD_TEAM_WEAPONS,
	FIELD_TEAM_AMMU,
	FIELD_TEAM_SALARY_BASE,
	FIELD_TEAM_SALARY_VOLATILE,
}

forward InitTeams();

public InitTeams()
{
	new i = 0, query[512];

	//gTeams[0] = gTeamNone;

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
		       	ammu[11],	
			ammuString[128], 
			colorString[128],
			skins[5],
			skinsString[128], 
			weapons[11],
			weaponsString[128];

		DB_GetFieldString(result, FIELD_TEAM_NAME, name, sizeof(name));
		gTeams[i][TeamName] = name;

		gTeams[i][ID] = DB_GetFieldInt(result, FIELD_TEAM_ID);
		gTeams[i][SalaryBase] = DB_GetFieldInt(result, FIELD_TEAM_SALARY_BASE);
		gTeams[i][SalaryVolatile] = DB_GetFieldInt(result, FIELD_TEAM_SALARY_VOLATILE);

		// Color
		DB_GetFieldString(result, FIELD_TEAM_COLOR, colorString, sizeof(colorString));
		gTeams[i][Color] = HexToInt(colorString);

		// Skins
		DB_GetFieldString(result, FIELD_TEAM_SKINS, skinsString, sizeof(skinsString));
		ExtractSkinsFromString(skinsString, skins);
		gTeams[i][Skins] = skins;

		// Weapons
		DB_GetFieldString(result, FIELD_TEAM_WEAPONS, weaponsString, sizeof(weaponsString));
		ExtractWeaponsAmmuFromString(weaponsString, weapons);
		gTeams[i][Weapons] = weapons;

		// Ammu
		DB_GetFieldString(result, FIELD_TEAM_WEAPONS, ammuString, sizeof(ammuString));
		ExtractWeaponsAmmuFromString(ammuString, ammu);
		gTeams[i][Ammu] = ammu;

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

stock ExtractWeaponsAmmuFromString(const input[], ints[11])
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
