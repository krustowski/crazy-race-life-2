//
//  team.pwn
//

#include "sql.pwn"

enum 
{
	TEAM_NONE,
	TEAM_LAMES,
	TEAM_ADMINZ,
	TEAM_POLICE,
	TEAM_TRUCKERS,
	TEAM_DRAGSTERS,
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
	Weapons[11],
	Ammu[11],
	SalaryBase,
	SalaryVolatile,
	PICKUP: Pickups[MAX_TEAM_PICKUPS],
	Menu: Menus[MAX_TEAM_MENUS]
}

new gTeams[MAX_TEAMS][Team];

/*stock InitTeams()
{
	gTeams[0] = gTeamNone;
	gTeams[1] = gTeamLames;
	gTeams[2] = gTeamAdminz;
	gTeams[3] = gTeamPolice;
	gTeams[4] = gTeamTruckers;
	gTeams[5] = gTeamDragsters;
	gTeams[6] = gTeamGarbagemen;
	gTeams[7] = gTeamPizzaguys;
	gTeams[8] = gTeamHackers;
	gTeams[9] = gTeamDealers;
}*/

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
		       	ammu[11],	
			ammuString[128], 
			skins[5],
			skinsString[128], 
			weapons[11],
			weaponsString[128];

		DB_GetFieldString(result, FIELD_TEAM_NAME, name, sizeof(name));
		gTeams[i][TeamName] = name;

		gTeams[i][ID] = DB_GetFieldInt(result, FIELD_TEAM_ID);
		gTeams[i][Color] = DB_GetFieldInt(result, FIELD_TEAM_COLOR);
		gTeams[i][SalaryBase] = DB_GetFieldInt(result, FIELD_TEAM_SALARY_BASE);
		gTeams[i][SalaryVolatile] = DB_GetFieldInt(result, FIELD_TEAM_SALARY_VOLATILE);

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

		i++;
	}

	print("Teams initiated!");
	DB_FreeResultSet(result);

	return 1;
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

