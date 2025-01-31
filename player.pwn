#define MAX_DRUGS		10
#define MAX_TEAMS		10
#define MAX_TEAM_PICKUPS	16
#define MAX_TEAM_MENUS		16

//
//  Drugz.
//

enum Drug
{
	DrugName[64],
	DrugIniName[64],

	Amount,
	Price
}

new gDrugz[MAX_DRUGS][Drug];

new gDrugZaza[Drug] = 
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
	"wafers",
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
};

public InitDrugValues()
{
	gDrugz[0] = gDrugZaza;
	gDrugz[1] = gDrugTobacco;
	gDrugz[2] = gDrugPaper;
	gDrugz[3] = gDrugLighter;
	gDrugz[4] = gDrugJoint;
	gDrugz[5] = gDrugCoke;
	gDrugz[6] = gDrugHeroin;
	gDrugz[7] = gDrugMeth;
	gDrugz[8] = gDrugFent;
	gDrugz[9] = gDrugPCP;
}

//
//  Player's props.
//

enum Team
{
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
	Name[MAX_PLAYER_NAME],
	bool: IsLogged,

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
	bool: AFK,
	bool: Hidden,
	bool: Spectating,
	bool: Jailed,
	Drugs[MAX_DRUGS]
}

new gTeamNone[Team] = 
{
	"Nezarazeno",
	COLOR_ZLUTA,
	{0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	100,
	150,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamLames[Team] = 
{
	"Lamky",
	COLOR_ZLUTA,
	{200, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	10,
	20,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamAdminz[Team] = 
{
	"Admin Borci",
	COLOR_SVZEL,
	{29, 0, 0, 0, 0},
	{32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1550,
	2100,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamPolice[Team] = 
{
	"Policie",
	MODRA,
	{285, 0, 0, 0, 0},
	{30, 31, 32, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 100, 111, 0, 0, 0, 0, 0, 0, 0, 0},
	1000,
	1500,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamTruckers[Team] = 
{
	"Truckeri",
	COLOR_CERVENA,
	{50, 0, 0, 0, 0},
	{32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1000,
	1150,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamDragsters[Team] = 
{
	"Dragsteri",
	COLOR_ZELENA,
	{107, 0, 0, 0, 0},
	{5, 30, 31, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 100, 1000, 0, 0, 0, 0, 0, 0, 0, 0},
	1200,
	1500,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamGarbagemen[Team] = 
{
	"Popelari",
	COLOR_HNEDA,
	{230, 0, 0, 0, 0},
	{4, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	250,
	500,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamPizzaguys[Team] = 
{
	"Pizza hosi",
	COLOR_ZELZLUT,
	{250, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	500,
	1250,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamHackers[Team] = 
{
	"Hackeri",
	COLOR_BILA,
	{170, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1500,
	900,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};

new gTeamDealers[Team] = 
{
	"Dealeri",
	COLOR_ORANZOVA,
	{29, 0, 0, 0, 0},
	{4, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	1800,
	2100,
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}
};


new gPlayers[MAX_PLAYERS][Player];
new gTeams[MAX_TEAMS][Team];

public InitGroups()
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

/*enum E_PLAYER_DATA
{
	E_PLAYER_DATA_ID,
	E_PLAYER_DATA_ORM,
	E_PLAYER_DATA_NAME[MAX_PLAYER_NAME],
	E_PLAYER_DATA_PWD_HASH[65],
	E_PLAYER_DATA_SALT[17],
	E_PLAYER_DATA_CASH,
	E_PLAYER_DATA_BANK,
	E_PLAYER_DATA_HEALTH,
	E_PLAYER_DATA_ARMOUR,
	E_PLAYER_DATA_ADMIN_LVL,
	E_PLAYER_DATA_TEAM,
	E_PLAYER_DATA_CLASS,
	E_PLAYER_DATA_LOGIN_ATT,
	E_PLAYER_DATA_AFK,
	E_PLAYER_DATA_HIDE,
	E_PLAYER_DATA_SPECTATE
}

enum E_PLAYER_TEAM
{
	E_PLAYER_TEAM_NONE,
	E_PLAYER_TEAM_LAME,
	E_PLAYER_TEAM_ADMINZ,
	E_PLAYER_TEAM_POLICE,
	E_PLAYER_TEAM_GASMAN,
	E_PLAYER_TEAM_DRAGSTER,
	E_PLAYER_TEAM_GARBAGE,
	E_PLAYER_TEAM_PIZZABOY,
	E_PLAYER_TEAM_HACKER,
	E_PLAYER_TEAM_DEALER
}

enum E_PLAYER_DRUGZ
{
	E_PLAYER_DRUGZ_ZAZA,
	E_PLAYER_DRUGZ_TOBACCO,
	E_PLAYER_DRUGZ_PAPER,
	E_PLAYER_DRUGZ_LIGHTER,
	E_PLAYER_DRUGZ_JOINT,
	E_PLAYER_DRUGZ_COCAINE,
	E_PLAYER_DRUGZ_HEROIN,
	E_PLAYER_DRUGZ_METH,
	E_PLAYER_DRUGZ_FENT,
	E_PLAYER_DRUGZ_PCP
}

new gPlayerAuth[MAX_PLAYERS];
new gPlayerData[MAX_PLAYERS][E_PLAYER_DATA];

new gPlayerDrugz[MAX_PLAYERS][E_PLAYER_DRUGZ];
new gPlayerDrugNames[E_PLAYER_DRUGZ][] = 
{
	"zaza",
	"tabak",
	"vazky",
	"zapik",
	"brko",
	"kokain",
	"heroin",
	"pernik",
	"fent",
	"andelak"
};

new PICKUP:gTeamPickup[E_PLAYER_TEAM];
new gTeamMenu[E_PLAYER_TEAM];*/

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

		new Drugs:drugs, teamID;

		gPlayers[playerid][Cash] 	= readcfgvalue(gPlayers[playerid][Name], "", "cash");
		gPlayers[playerid][Bank] 	= readcfgvalue(gPlayers[playerid][Name], "", "bank");
		gPlayers[playerid][AdminLevel] 	= readcfgvalue(gPlayers[playerid][Name], "", "adminlvl"); 
		gPlayers[playerid][Skin] 	= readcfgvalue(gPlayers[playerid][Name], "", "class"); 
		gPlayers[playerid][Health] 	= readcfgvalue(gPlayers[playerid][Name], "", "health");
		gPlayers[playerid][Armour] 	= readcfgvalue(gPlayers[playerid][Name], "", "armour");

		teamID 				= readcfgvalue(gPlayers[playerid][Name], "", "team"); 
		gPlayers[playerid][TeamID] 	= gTeams[teamID];

		/*gPlayers[playerid][Drugs][Cocaine][Amount] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "cocaine");
		gPlayers[playerid][Drugs][Heroin][Amount] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "heroin");
		gPlayers[playerid][Drugs][Meth][Amount] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "meth");
		gPlayers[playerid][Drugs][Fent][Amount] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "fent");
		gPlayers[playerid][Drugs][PCP][Amount] 		= readcfgvalue(gPlayers[playerid][Name], "drugz", "pcp");

		gPlayers[playerid][Drugs][0] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "zaza");
		gPlayers[playerid][Drugs][1] 	= readcfgvalue(gPlayers[playerid][Name], "drugz", "tobacco");*/

		for (new i = 0; i < MAX_DRUGS; i++)
		{
			gPlayers[playerid][Drugs][i] = readcfgvalue(gPlayers[playerid][Name], "drugz", gDrugz[i][DrugIniName]);
		}

		GivePlayerMoney(playerid, gPlayers[playerid][Cash]);
		SetPlayerHealth(playerid, gPlayers[playerid][Health]);
		SetPlayerArmour(playerid, gPlayers[playerid][Armour]);
		SetPlayerSkin(playerid, gPlayers[playerid][Skin]);
		SetPlayerColor(playerid, gPlayers[playerid][TeamID][Color]);

		SendClientMessage(playerid, GREEN, "[ DATA ] Data uspesne nactena!");

		return 1;
	}

	return 0;
}

public SavePlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayers[playerid][IsLogged])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ AUTOSAVE ] Pripravuje se ulozeni uzivatelskych dat...");

		new Float:armour, Float:health;

		GetPlayerArmour(playerid, armour);
		GetPlayerHealth(playerid, health);

		writecfgvalue(gPlayers[playerid][Name], "", "cash", GetPlayerMoney(playerid));
		writecfgvalue(gPlayers[playerid][Name], "", "bank", gPlayers[playerid][Bank]);
		writecfgvalue(gPlayers[playerid][Name], "", "adminlvl", gPlayers[playerid][AdminLevel]);
		writecfgvalue(gPlayers[playerid][Name], "", "team", gPlayers[playerid][TeamID]);
		writecfgvalue(gPlayers[playerid][Name], "", "class", GetPlayerSkin(playerid));
		writecfgvalue(gPlayers[playerid][Name], "", "health", floatround(health));
		writecfgvalue(gPlayers[playerid][Name], "", "armour", floatround(armour));

		for (new i = 0; i < MAX_DRUGS; i++)
		{
			writecfgvalue(gPlayers[playerid][Name], "drugz", gDrugz[i][DrugIniName], gPlayers[playerid][Drugs][i]);
		}

		/*writecfgvalue(gPlayers[playerid][Name], "drugz", "cocaine", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_COCAINE]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "heroin", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_HEROIN]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "meth", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_METH]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "fent", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_FENT]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "pcp", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_PCP]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "zaza", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_ZAZA]);
		writecfgvalue(gPlayers[playerid][Name], "drugz", "tobacco", 	gPlayerDrugz[playerid][E_PLAYER_DRUGZ_TOBACCO]);*/

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

		teamSalary = gPlayers[i][TeamID][SalaryBase] + random(gPlayers[i][TeamID][SalaryVolatile]);

		format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Tymova vyplata pristala do kapsy: $%d");

		/*switch (gPlayerData[i][E_PLAYER_DATA_TEAM]) 
		{
			case E_PLAYER_TEAM_NONE:
				{
					teamSalary = 100 + random(150);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Podpora v nezamestnanosti: $%d | Par drobku z mestske kasy :) A nemysli si ze nebudes pracovat!", teamSalary);
				}
			case E_PLAYER_TEAM_LAME:
				{
					teamSalary = 5 + random(20);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Nemysli si ze lamam budeme davat tolik penez!", teamSalary);
				}
			case E_PLAYER_TEAM_ADMINZ:
				{
					teamSalary = 1500 + random(2000);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Uzijte peníze pro co chcete! :D", teamSalary);
				}
			case E_PLAYER_TEAM_POLICE:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Pro pany fizle par papiru z mestske kasy! :)", teamSalary);
				}
			case E_PLAYER_TEAM_GASMAN:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Provize z benzinky! :D", teamSalary);
				}
			case E_PLAYER_TEAM_DRAGSTER:
				{
					teamSalary = 1200 + random(1000);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Provize z dragu! :D", teamSalary);
				}
			case E_PLAYER_TEAM_GARBAGE:
				{
					teamSalary = 120 + random(100);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Podpora mesta a penize z popelnic! :D", teamSalary);
				}
			case E_PLAYER_TEAM_PIZZABOY:
				{
					teamSalary = 190 + random(200);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Pizza provize a spropitne! :D", teamSalary);
				}
			case E_PLAYER_TEAM_HACKER:
				{
					teamSalary = 1500 + random(800);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Vypalne a provize z prodeje ukradenych dat! :D", teamSalary);
				}
			case E_PLAYER_TEAM_DEALER:
				{
					teamSalary = 1800 + random(2100);
					format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Vyplata povolani: $%d | Prachy z cerneho trhu a prodeje narkotik!", teamSalary);
				}
		}*/

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

public OnPlayerPrivMsg(playerid, receiverid, text[])
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

