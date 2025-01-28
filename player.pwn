enum E_PLAYER_DATA
{
	E_PLAYER_DATA_PWD_HASH,
	E_PLAYER_DATA_CASH,
	E_PLAYER_DATA_BANK,
	E_PLAYER_DATA_HEALTH,
	E_PLAYER_DATA_ARMOUR,
	E_PLAYER_DATA_ADMIN_LVL,
	E_PLAYER_DATA_TEAM,
	E_PLAYER_DATA_CLASS,
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
	E_PLAYER_TEAM_CAR_REPAIR,
	E_PLAYER_TEAM_PYRO
}

enum E_PLAYER_DRUGZ
{
	E_PLAYER_DRUGZ_ZAZA,
	E_PLAYER_DRUGZ_TOBACCO,
	E_PLAYER_DRUGZ_PAPER,
	E_PLAYER_DRUGZ_LIGHTER,
	E_PLAYER_DRUGZ_JOINT
}

new gPlayerAuth[MAX_PLAYERS];
new gPlayerData[MAX_PLAYERS][E_PLAYER_DATA];

new gPlayerDrugz[MAX_PLAYERS][E_PLAYER_DRUGZ];

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

		GivePlayerMoney(playerid, dUserINT(playerName).("cash"));
		gPlayerData[playerid][E_PLAYER_DATA_BANK] = dUserINT(playerName).("bank");
		gPlayerData[playerid][E_PLAYER_DATA_HEALTH] = dUserINT(playerName).("health");
		gPlayerData[playerid][E_PLAYER_DATA_ARMOUR] = dUserINT(playerName).("armour");
		gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] = dUserINT(playerName).("adminlvl");
		gPlayerData[playerid][E_PLAYER_DATA_TEAM] = dUserINT(playerName).("team");
		gPlayerData[playerid][E_PLAYER_DATA_CLASS] = dUserINT(playerName).("class");

		//joint[playerid] = dUserINT(PlayerName(playerid)).("joint");
		//zapik[playerid] = dUserINT(PlayerName(playerid)).("zapik");

		SetPlayerColor(playerid, COLOR_ZLUTA);
		SetPlayerSkin(playerid, gPlayerData[playerid][E_PLAYER_DATA_CLASS]);
		SetPlayerHealth(playerid, gPlayerData[playerid][E_PLAYER_DATA_HEALTH]);
		SetPlayerArmour(playerid, gPlayerData[playerid][E_PLAYER_DATA_ARMOUR]);

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

		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playerName, sizeof(playerName));

		dUserSetINT(playerName).("cash", GetPlayerMoney(playerid));
		dUserSetINT(playerName).("bank", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
		dUserSetINT(playerName).("health", GetPlayerHealth(playerid));
		dUserSetINT(playerName).("armour", GetPlayerArmour(playerid));
		dUserSetINT(playerName).("adminlvl", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL]);
		dUserSetINT(playerName).("team", gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
		dUserSetINT(playerName).("class", GetPlayerSkin(playerid));

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
					format(stringToPrint, sizeof(stringToPrint), "Podpora v nezamestnanosti: $%d | Par drobku z mestske kasy :) A nemysli si ze nebudes pracovat!", teamSalary);
				}
			case E_PLAYER_TEAM_LAME:
				{
					teamSalary = 5 + random(20);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Nemysli si ze lamam budeme davat tolik penez!", teamSalary);
				}
			case E_PLAYER_TEAM_ADMINZ:
				{
					teamSalary = 1500 + random(2000);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Uzijte peníze pro co chcete! :D", teamSalary);
				}
			case E_PLAYER_TEAM_POLICE:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Pro pany fizle par papiru z mestske kasy! :)", teamSalary);
				}
			case E_PLAYER_TEAM_GASMAN:
				{
					teamSalary = 1000 + random(600);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Provize z benzinky! :D", teamSalary);
				}
			case E_PLAYER_TEAM_DRAGSTER:
				{
					teamSalary = 1200 + random(1000);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Provize z dragu! :D", teamSalary);
				}
			case E_PLAYER_TEAM_GARBAGE:
				{
					teamSalary = 120 + random(100);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Podpora mesta a penize z popelnic! :D", teamSalary);
				}
			case E_PLAYER_TEAM_PIZZABOY:
				{
					teamSalary = 190 + random(200);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Pizza provize a spropitne! :D", teamSalary);
				}
			case E_PLAYER_TEAM_HACKER:
				{
					teamSalary = 1500 + random(800);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Vypalne a provize z prodeje ukradenych dat! :D", teamSalary);
				}
			case E_PLAYER_TEAM_CAR_REPAIR:
				{
					teamSalary = 300 + random(299);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Vyplata z autoservisu!", teamSalary);
				}
			case E_PLAYER_TEAM_PYRO:
				{
					teamSalary = 800 + random(210);
					format(stringToPrint, sizeof(stringToPrint), "Vyplata povolani: $%d | Vyplata od ministerstva pyrotechniky! :D", teamSalary);
				}
		}

		SendClientMessage(i, COLOR_ORANZCERV, stringToPrint);

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

	format(stringForReceiver, sizeof(stringForReceiver), "[PM] od %s (ID: %d): %s", senderName, playerid, text);
	format(stringForSender, sizeof(stringForSender), "[PM] pro %s (ID: %d): %s", receiverName, receiverid, text);

	SendClientMessage(receiverid, GREEN, stringForReceiver);
	SendClientMessage(playerid, GREEN, stringForSender);

	// Play direct message tones.
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); 
	PlayerPlaySound(receiverid, 1057, 0.0, 0.0, 0.0);

	GameTextForPlayer(playerid, "~w~PM ~r~Odeslana~w~.", 3000, 3); 
	GameTextForPlayer(receiverid, "~w~PM ~r~Prijata~w~.", 3000, 3);

	GivePlayerMoney(playerid, -10); 

	/*if (!IsPlayerAdmin(recieverid) && !IsPlayerAdmin(playerid))
	  {
	  SendMessageToAdmins(COLOR_BILA, stringForSender);
	  SendMessageToAdmins(COLOR_BILA, stringForReceiver);
	  }*/

	return 1;
}

