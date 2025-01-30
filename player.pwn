enum E_PLAYER_DATA
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
		SendClientMessage(playerid, COLOR_ZLUTA, "[ DATA ] Nacitam ulozena uzivatelska data...");

		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playerName, sizeof(playerName));

		SetPlayerColor(playerid, COLOR_ZLUTA);

		gPlayerData[playerid][E_PLAYER_DATA_CASH] = readcfgvalue(playerName, "", "cash");
		gPlayerData[playerid][E_PLAYER_DATA_BANK] = readcfgvalue(playerName, "", "bank");
		gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] = readcfgvalue(playerName, "", "adminlvl"); 
		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = readcfgvalue(playerName, "", "team"); 
		gPlayerData[playerid][E_PLAYER_DATA_CLASS] = readcfgvalue(playerName, "", "class"); 
		gPlayerData[playerid][E_PLAYER_DATA_HEALTH] = readcfgvalue(playerName, "", "health");
		gPlayerData[playerid][E_PLAYER_DATA_ARMOUR] = readcfgvalue(playerName, "", "armour");

		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_COCAINE] = readcfgvalue(playerName, "drugz", "cocaine");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_HEROIN] = readcfgvalue(playerName, "drugz", "heroin");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_METH] = readcfgvalue(playerName, "drugz", "meth");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_FENT] = readcfgvalue(playerName, "drugz", "fent");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_PCP] = readcfgvalue(playerName, "drugz", "pcp");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_ZAZA] = readcfgvalue(playerName, "drugz", "zaza");
		gPlayerDrugz[playerid][E_PLAYER_DRUGZ_TOBACCO] = readcfgvalue(playerName, "drugz", "tobacco");

		GivePlayerMoney(playerid, gPlayerData[playerid][E_PLAYER_DATA_CASH]);
		SetPlayerHealth(playerid, gPlayerData[playerid][E_PLAYER_DATA_HEALTH]);
		SetPlayerArmour(playerid, gPlayerData[playerid][E_PLAYER_DATA_ARMOUR]);
		SetPlayerSkin(playerid, gPlayerData[playerid][E_PLAYER_DATA_CLASS]);

		//joint[playerid] = dUserINT(PlayerName(playerid)).("joint");
		//zapik[playerid] = dUserINT(PlayerName(playerid)).("zapik");

		SendClientMessage(playerid, GREEN, "[ DATA ] Data uspesne nactena!");

		return 1;
	}

	return 0;
}

public SavePlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayerAuth[playerid])
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ AUTOSAVE ] Pripravuje se ulozeni uzivatelskych dat...");

		new Float:armour, Float:health, playerName[MAX_PLAYER_NAME];

		GetPlayerArmour(playerid, armour);
		GetPlayerHealth(playerid, health);
		GetPlayerName(playerid, playerName, sizeof(playerName));

		writecfgvalue(playerName, "", "cash", GetPlayerMoney(playerid));
		writecfgvalue(playerName, "", "bank", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		writecfgvalue(playerName, "", "adminlvl", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL]);
		writecfgvalue(playerName, "", "team", gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
		writecfgvalue(playerName, "", "class", GetPlayerSkin(playerid));
		writecfgvalue(playerName, "", "health", floatround(health));
		writecfgvalue(playerName, "", "armour", floatround(armour));

		writecfgvalue(playerName, "drugz", "cocaine", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_COCAINE]);
		writecfgvalue(playerName, "drugz", "heroin", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_HEROIN]);
		writecfgvalue(playerName, "drugz", "meth", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_METH]);
		writecfgvalue(playerName, "drugz", "fent", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_FENT]);
		writecfgvalue(playerName, "drugz", "pcp", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_PCP]);
		writecfgvalue(playerName, "drugz", "zaza", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_ZAZA]);
		writecfgvalue(playerName, "drugz", "tobacco", gPlayerDrugz[playerid][E_PLAYER_DRUGZ_TOBACCO]);

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

		switch (gPlayerData[i][E_PLAYER_DATA_TEAM]) 
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
		}

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

	new senderName[MAX_PLAYER_NAME], receiverName[MAX_PLAYER_NAME], stringForReceiver[256], stringForSender[256]; 

	// Get both counterparts' nicknames.
	GetPlayerName(playerid, senderName, sizeof(senderName)); 
	GetPlayerName(receiverid, receiverName, sizeof(receiverName)); 

	format(stringForReceiver, sizeof(stringForReceiver), "[ PM ] od %s (ID: %d): %s", senderName, playerid, text);
	format(stringForSender, sizeof(stringForSender), "[ PM ] pro %s (ID: %d): %s", receiverName, receiverid, text);

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

