enum E_PLAYER_DATA
{
	E_PLAYER_DATA_PWD_HASH,
	E_PLAYER_DATA_CASH,
	E_PLAYER_DATA_BANK,
	E_PLAYER_DATA_HEALTH,
	E_PLAYER_DATA_VEST,
	E_PLAYER_DATA_ADMIN_LVL,
	E_PLAYER_DATA_TEAM,
	E_PLAYER_DATA_CLASS,
	E_PLAYER_DATA_AFK
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
	E_PLAYER_TEAM_CAR_REPAIR,
	E_PLAYER_TEAM_PYRO,
}

enum E_PLAYER_HULO
{
	E_PLAYER_HULO_ZAZA,
	E_PLAYER_HULO_TOBACCO,
	E_PLAYER_HULO_PAPER,
	E_PLAYER_HULO_LIGHTER,
	E_PLAYER_HULO_JOINT
}

new gPlayerAuth[MAX_PLAYERS];
new gPlayerData[MAX_PLAYERS][E_PLAYER_DATA];

new gPlayerHulo[MAX_PLAYERS][E_PLAYER_HULO];

new gTeamPickup[E_PLAYER_TEAM];
new gTeamMenu[E_PLAYER_TEAM];

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
	if (IsPlayerConnected(playerid) && gPlayerAuth[playerid])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ i ][DATA] Nacitam ulozena uzivatelska data...");

		GivePlayerMoney(playerid, dUserINT(PlayerName(playerid)).("cash"));
		gPlayerData[playerid][E_PLAYER_DATA_BANK] = dUserINT(PlayerName(playerid)).("bank");
		gPlayerData[playerid][E_PLAYER_DATA_HEALTH] = dUserINT(PlayerName(playerid)).("health");
		gPlayerData[playerid][E_PLAYER_DATA_VEST] = dUserINT(PlayerName(playerid)).("vest");
		gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] = dUserINT(PlayerName(playerid)).("adminlvl");
		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = dUserINT(PlayerName(playerid)).("team");
		gPlayerData[playerid][E_PLAYER_DATA_CLASS] = dUserINT(PlayerName(playerid)).("class");

		//joint[playerid] = dUserINT(PlayerName(playerid)).("joint");
		//zapik[playerid] = dUserINT(PlayerName(playerid)).("zapik");

		SetPlayerColor(playerid, bezova);
		SetPlayerSkin(playerid, dUserINT(PlayerName(playerid)).("class"));

		SendClientMessage(playerid, GREEN, "[ i ][DATA] Data uspesne nactena!");

		return 0;
	}

	return 1;
}

public SavePlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayerAuth[playerid])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ i ][DATA] Pripravuje se ulozeni uzivatelskych dat...");

		dUserSetINT(PlayerName(playerid)).("cash", GetPlayerMoney(playerid));
		dUserSetINT(PlayerName(playerid)).("bank", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		dUserSetINT(PlayerName(playerid)).("health", gPlayerData[playerid][E_PLAYER_DATA_HEALTH]);
		dUserSetINT(PlayerName(playerid)).("vest", gPlayerData[playerid][E_PLAYER_DATA_VEST]);
		dUserSetINT(PlayerName(playerid)).("adminlvl", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL]);
		dUserSetINT(PlayerName(playerid)).("team", gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
		dUserSetINT(PlayerName(playerid)).("class", gPlayerData[playerid][E_PLAYER_DATA_CLASS]);

		SendClientMessage(playerid, GREEN, "[ i ][DATA] Data uspesne ulozena! ");
	}

	return 1;
}

public SendPlayerSalary()
{
	new gameText[128], stringToPrint[256], teamSalary;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i)) 
		{
			continue;
		}

		switch (gPlayerData[i][E_PLAYER_DATA_TEAM]) 
		{
			case E_PLAYER_TEAM_NONE:
				{
					teamSalary = 100 + random(150);
					format(stringToPrint, sizeof(stringToPrint), "Podpora v nezamestnanosti: %d € | Par drobku z mestske kasy :) A nemysli si ze nebudes pracovat!", teamSalary);
				}
			case E_PLAYER_TEAM_LAME:
				{
					teamSalary = 5 + random(20);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Nemysli si ze lamam budeme davat tolik penez!", teamSalary);
				}
			case E_PLAYER_TEAM_ADMINZ:
				{
					teamSalary = 1500 + random(2000);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Uzijte peníze pro co chcete! :D", teamSalary);
				}
			case E_PLAYER_TEAM_POLICE:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Pro pany fizle par papiru z mestske kasy! :)", teamSalary);
				}
			case E_PLAYER_TEAM_GASMAN:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Provize z benzinky! :D", teamSalary);
				}
			case E_PLAYER_TEAM_DRAGSTER:
				{
					teamSalary = 1200 + random(1000);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Provize z dragu! :D", teamSalary);
				}
			case E_PLAYER_TEAM_GARBAGE:
				{
					teamSalary = 120 + random(100);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Podpora mesta a penize z popelnic! :D", teamSalary);
				}
			case E_PLAYER_TEAM_PIZZABOY:
				{
					teamSalary = 190 + random(200);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Pizza provize a spropitne! :D", teamSalary);
				}
			case E_PLAYER_TEAM_HACKER:
				{
					teamSalary = 1500 + random(800);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Vypalne a provize z prodeje ukradenych dat! :D", teamSalary);
				}
			case E_PLAYER_TEAM_CAR_REPAIR:
				{
					teamSalary = 300 + random(299);
					format(stringToPrint, sizeof(stringToPrint), "Výplata povolani: %d € | Vyplata z autoservisu!", teamSalary);
				}
			case E_PLAYER_TEAM_PYRO:
				{
					teamSalary = 800 + random(210);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: %d € | Vyplata od ministerstva pyrotechniky! :D", teamSalary);
				}
		}

		SendClientMessage(i, COLOR_ORANZCERV, stringToPrint);
		format(gameText, sizeof(gameText), "~y~V~g~yplata ~n~~y~ %d ", teamSalary);
		GameTextForPlayer(i, gameText, 5000, 1);
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


