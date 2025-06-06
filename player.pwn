#define MAX_DRUGS		10
#define MAX_TEAMS		10
#define MAX_TEAM_PICKUPS	16
#define MAX_TEAM_MENUS		16
#define MAX_PLAYER_PROPERTIES	5

#include "sql.pwn"

//
//  Drugz.
//

enum
{
	ZAZA,
	TOBACCO,
	PAPER,
	LIGHTER,
	JOINT,
	COCAINE,
	HEROIN,
	METH,
	FENT,
	PCP
}

enum Drug
{
	DrugName[64],
	DrugIniName[64],

	DrugAmount,
	DrugPrice
}

new gDrugz[MAX_DRUGS][Drug];

/*new gDrugZaza[Drug] = 
{
	"zaza",
	"zaza",
	0,
	50
};

new gDrugTobacco[Drug] = 
{
	"tabak",
	"tobacco",
	0,
	5
};

new gDrugPaper[Drug] = 
{
	"vazky",
	"paper",
	0,
	5
};

new gDrugLighter[Drug] = 
{
	"zapik",
	"lighter",
	0,
	5
};

new gDrugJoint[Drug] = 
{
	"brko",
	"joint",
	0,
	30
};

new gDrugCoke[Drug] = 
{
	"koks",
	"cocaine",
	0,
	150
};

new gDrugHeroin[Drug] = 
{
	"hero",
	"heroin",
	0,
	200
};

new gDrugMeth[Drug] = 
{
	"pernik",
	"meth",
	0,
	180
};

new gDrugFent[Drug] = 
{
	"fent",
	"fent",
	0,
	400
};

new gDrugPCP[Drug] = 
{
	"andelak",
	"pcp",
	0,
	350
};*/

stock InitDrugValues()
{
	/*gDrugz[0] = gDrugZaza;
	gDrugz[1] = gDrugTobacco;
	gDrugz[2] = gDrugPaper;
	gDrugz[3] = gDrugLighter;
	gDrugz[4] = gDrugJoint;
	gDrugz[5] = gDrugCoke;
	gDrugz[6] = gDrugHeroin;
	gDrugz[7] = gDrugMeth;
	gDrugz[8] = gDrugFent;
	gDrugz[9] = gDrugPCP;*/

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT name, name_alt, price FROM drug_prices ORDER BY id ASC");
	if (!result) {
		print("Database error: cannot fetch drug prices!");
		return;
	}

	new 
		i = 0,
		name[64], 
		name_alt[64], 
		price;

	while (DB_SelectNextRow(result))
	{
		DB_GetFieldString(result, 0, name, sizeof(name));
		DB_GetFieldString(result, 1, name_alt, sizeof(name_alt));
		price = DB_GetFieldInt(result, 2);

		gDrugz[i][DrugName] = name_alt;
		gDrugz[i][DrugIniName] = name;
		gDrugz[i][DrugAmount] = 0;
		gDrugz[i][DrugPrice] = price;
		i++;
	}

	print("Drug prices initialized!");
	DB_FreeResultSet(result);
}

//
//  Player's props.
//

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

enum Player
{
	ID,
	OrmID,
	Name[MAX_PLAYER_NAME],

	PasswordHash[65],
	PasswordSalt[17],

	TeamID[Team],
	Skin,
	Cash,
	Bank,
	Float: Health,
	Float: Armour,
	AdminLevel,
	LoginAttempts,
	SpawnPoint,

	bool: IsLogged,
	bool: AFK,
	bool: Hidden,
	bool: Spectating,
	bool: Jailed,
	bool: InsideProperty,

	Drugs[MAX_DRUGS],
	Properties[MAX_PLAYER_PROPERTIES],

	Temp
}

//
//  Team definitions.
//

new gTeamNone[Team] = 
{
	TEAM_NONE,
	"Nezarazeno",
	COLOR_ZLUTA,
	{0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	100,
	150
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamLames[Team] = 
{
	TEAM_LAMES,
	"Lamky",
	COLOR_ZLUTA,
	{200, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	10,
	20
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamAdminz[Team] = 
{
	TEAM_ADMINZ,
	"Admin Borci",
	COLOR_SVZEL,
	{29, 0, 0, 0, 0},
	{32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1550,
	2100
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamPolice[Team] = 
{
	TEAM_POLICE,
	"Policie",
	MODRA,
	{285, 0, 0, 0, 0},
	{30, 31, 32, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 100, 111, 0, 0, 0, 0, 0, 0, 0, 0},
	1000,
	1500
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamTruckers[Team] = 
{
	TEAM_TRUCKERS,
	"Truckeri",
	COLOR_CERVENA,
	{50, 0, 0, 0, 0},
	{32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1000,
	1150
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamDragsters[Team] = 
{
	TEAM_DRAGSTERS,
	"Dragsteri",
	COLOR_ZELENA,
	{107, 0, 0, 0, 0},
	{5, 30, 31, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 100, 1000, 0, 0, 0, 0, 0, 0, 0, 0},
	1200,
	1500
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamGarbagemen[Team] = 
{
	TEAM_GARBAGEMEN,
	"Popelari",
	COLOR_HNEDA,
	{230, 0, 0, 0, 0},
	{4, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	250,
	500
	//PICKUP: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//Menu: {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamPizzaguys[Team] = 
{
	TEAM_PIZZAGUYS,
	"Pizza hosi",
	COLOR_ZELZLUT,
	{250, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	500,
	1250
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamHackers[Team] = 
{
	TEAM_HACKERS,
	"Hackeri",
	COLOR_BILA,
	{170, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1500,
	900
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamDealers[Team] = 
{
	TEAM_DEALERS,
	"Dealeri",
	COLOR_ORANZOVA,
	{29, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1800,
	2100
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	//{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};


new gPlayers[MAX_PLAYERS][Player];
new gTeams[MAX_TEAMS][Team];

stock InitTeams()
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
}

//
//
//

public BatchSavePlayerData()
{
	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		SavePlayerData(i);
	}

	return 1;
}

public LoadPlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayers[playerid][IsLogged])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ DATA ] Nacitam ulozena uzivatelska data...");
		SetPlayerColor(playerid, COLOR_ZLUTA);

		new query[256];
		format(query, sizeof(query), "SELECT cash, bank, adminlvl, team, class, health, armour, spawn, properties FROM users WHERE nickname = '%s';", gPlayers[playerid][Name]);

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			print("Database error: cannot fetch user data!");
			return 0;
		}

		new properties[MAX_PLAYER_PROPERTIES], propertiesString[128];

		gPlayers[playerid][Cash] = DB_GetFieldInt(result, 0);
		gPlayers[playerid][Bank] = DB_GetFieldInt(result, 1);
		gPlayers[playerid][AdminLevel] = DB_GetFieldInt(result, 2);
		gPlayers[playerid][TeamID] = DB_GetFieldInt(result, 3);
		gPlayers[playerid][Skin] = DB_GetFieldInt(result, 4);
		gPlayers[playerid][Health] = DB_GetFieldInt(result, 5);
		gPlayers[playerid][Armour] = DB_GetFieldInt(result, 6);
		gPlayers[playerid][SpawnPoint] = DB_GetFieldInt(result, 7);
		DB_GetFieldString(result, 8, propertiesString, sizeof(propertiesString));

		ExtractPropperties(propertiesString, properties);
		gPlayers[playerid][Properties] = properties;

		DB_FreeResultSet(result);

		/*for (new i = 0; i < MAX_DRUGS; i++)
		  {
		  gPlayers[playerid][Drugs][i] = readcfgvalue(gPlayers[playerid][Name], "drugz", gDrugz[i][DrugIniName]);
		  }*/

		GivePlayerMoney(playerid, gPlayers[playerid][Cash]);
		SetPlayerHealth(playerid, gPlayers[playerid][Health]);
		SetPlayerArmour(playerid, gPlayers[playerid][Armour]);
		SetPlayerSkin(playerid, gPlayers[playerid][Skin]);
		SetPlayerColor(playerid, gTeams[ gPlayers[playerid][TeamID] ][Color]);

		SendClientMessage(playerid, GREEN, "[ DATA ] Data uspesne nactena!");

		return 1;
	}

	return 0;
}

stock ExtractPropperties(const input[], properties[MAX_PLAYER_PROPERTIES])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do {
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		properties[i] = strval(token1);

		strcopy(toSplit, token2);
		i++;
	} while (strcmp(token2, ""));

	return properties;
}

public SavePlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayers[playerid][IsLogged])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ AUTOSAVE ] Pripravuje se ulozeni uzivatelskych dat...");

		new Float:armour, Float:health;

		GetPlayerArmour(playerid, armour);
		GetPlayerHealth(playerid, health);

		// Properties, Real Estate elements.
		new propertiesString[64];

		for (new j = 0; j < MAX_PLAYER_PROPERTIES; j++)
		{
			if (!strcmp(propertiesString, ""))
			{
				format(propertiesString, sizeof(propertiesString), "%d", gPlayers[playerid][Properties][j]);

				continue;
			}

			format(propertiesString, sizeof(propertiesString), "%s,%d", propertiesString, gPlayers[playerid][Properties][j]);
		}

		writecfg(gPlayers[playerid][Name], "", "properties", propertiesString);

		new query[256];

		format(query, sizeof(query), "UPDATE users SET cash = %d, bank = %d, adminlvl = %d, team = %d, class = %d, health = %d, armour = %d, spawn = %d, properties = '%s' WHERE nickname = '%s';", GetPlayerMoney(playerid), gPlayers[playerid][Bank], gPlayers[playerid][AdminLevel], gPlayers[playerid][TeamID], GetPlayerSkin(playerid), floatround(health), floatround(armour), gPlayers[playerid][SpawnPoint], propertiesString, gPlayers[playerid][Name]);

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			print("Database error: cannot write user data!");
			return 0;
		}

		// Drugz.
		/*for (new i = 0; i < MAX_DRUGS; i++)
		{
			writecfgvalue(gPlayers[playerid][Name], "drugz", gDrugz[i][DrugIniName], gPlayers[playerid][Drugs][i]);
		}*/

		SendClientMessage(playerid, GREEN, "[ AUTOSAVE ] Data uspesne ulozena! ");
	}

	return 1;
}

public SendPlayerSalary()
{
	new gameText[128], stringToPrint[256], teamSalary;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i)) 
			continue;

		teamSalary = gTeams[ gPlayers[i][TeamID] ][SalaryBase] + random(gTeams[ gPlayers[i][TeamID] ][SalaryVolatile]);

		format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Tymova vyplata pristala do kapsy: $%d", teamSalary);
		SendClientMessage(i, COLOR_ZLUTA, stringToPrint);

		format(gameText, sizeof(gameText), "~y~V~g~yplata~n~~y~$~g~%d", teamSalary);
		GameTextForPlayer(i, gameText, 4000, 1);

		GivePlayerMoney(i, teamSalary);
	}

	return 1;
}


public UpdatePlayerScore()
{
	for (new i; i <= GetMaxPlayers(); i++)
	{
		SetPlayerScore(i, GetPlayerMoney(i));
	}
}

stock OnPlayerPrivMsg(playerid, receiverid, text[])
{
	if (GetPlayerMoney(playerid) < 10) 
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] K odeslani soukrome zpravy potrebujes alespon $10!");
		return 0;
	}

	if (!IsPlayerConnected(receiverid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Prijemce soukrome zpravy neni pritomen na serveru!");
		return 0;
	}

	new stringForReceiver[256], stringForSender[256]; 

	format(stringForReceiver, sizeof(stringForReceiver), "[ PM ] od %s (ID: %d): %s", gPlayers[playerid][Name], playerid, text);
	format(stringForSender, sizeof(stringForSender), "[ PM ] pro %s (ID: %d): %s", gPlayers[receiverid][Name], receiverid, text);

	SendClientMessage(receiverid, GREEN, stringForReceiver);
	SendClientMessage(playerid, GREEN, stringForSender);

	// Play direct message tones.
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); 
	PlayerPlaySound(receiverid, 1057, 0.0, 0.0, 0.0);

	GameTextForPlayer(playerid, "~w~PM ~g~Odeslana~w~.", 3000, 3); 
	GameTextForPlayer(receiverid, "~w~PM ~g~Prijata~w~.", 3000, 3);

	GivePlayerMoney(playerid, -10); 

	/*if (!IsPlayerAdmin(recieverid) && !IsPlayerAdmin(playerid))
	  {
	  SendMessageToAdmins(COLOR_BILA, stringForSender);
	  SendMessageToAdmins(COLOR_BILA, stringForReceiver);
	  }*/

	return 1;
}
