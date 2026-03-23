#if defined _CRL2_PLAYER
	#endinput
#endif
#define _CRL2_PLAYER

//
//  player.pwn
//

#define MAX_PLAYER_PROPERTIES 7

#include "support/i18n.pwn"
#include "db/sql.pwn"
#include "modules/team.pwn"
#include "modules/tutorial.pwn"
#include "modules/drugz.pwn"
#include "support/helpers.pwn"

//
//  Player's props.
//

enum SkinOperation
{
	SKIN_OP_NONE,
	SKIN_OP_NEW,
	SKIN_OP_SELECT,
	SKIN_OP_DELETE
}

enum Player
{
	ID,
	OrmID,
	Name[MAX_PLAYER_NAME],

	PasswordHash[65],
	PasswordSalt[17],
	LoginAttempts,

	TeamID,
	Skin,
	Cash,
	Bank,
	Float: Health,
	Float: Armour,
	AdminLevel,
	WantedLevel,
	SpawnPoint,

	PlayerLocale: Locale,

	bool: IsLogged,
	bool: AFK,
	bool: Hidden,
	bool: Spectating,
	bool: Jailed,
	bool: InsideProperty,
	bool: EditingMode,
	bool: DialogShown,
	bool: Listening,
	bool: InMinigame,
	bool: SwitchedControllers,

	PlayTime,

	Drugs[MAX_DRUG_TYPES],
	Properties[MAX_PLAYER_PROPERTIES],

	Timer: OnDeathGunsTimer[11],
	Timer: LoginTimer,
	Timer: PlayTimeTimer,

	TutorialStats[Tutorial],

	Temp,
	SkinOperation: SkinOp
}

new gPlayers[MAX_PLAYERS][Player];

//
//
//

forward BatchSavePlayerData();
forward GivePlayerWeaponEx(playerid, timerid, weaponid, ammo);
forward LoadPlayerData(playerid);
forward SavePlayerData(playerid);
forward SendPlayerSalary();
forward UpdatePlayerScore();

public BatchSavePlayerData()
{
	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		// Ensure only online and logged-in players are subject for autosave
		if (!IsPlayerConnected(i) || !gPlayers[i][IsLogged])
		{
			continue;
		}

		SavePlayerData(i);
	}

	return 1;
}

public GivePlayerWeaponEx(playerid, timerid, weaponid, ammo)
{
	KillTimer(_: gPlayers[playerid][OnDeathGunsTimer][timerid]);

	GivePlayerWeapon(playerid, t_WEAPON: weaponid, ammo);
}

public LoadPlayerData(playerid)
{
	if (IsPlayerConnected(playerid) && gPlayers[playerid][IsLogged])
	{
		SendClientMessageLocalized(playerid, I18N_USER_DATA_LOAD);
		SetPlayerColor(playerid, COLOR_INVISIBLE);

		new query[512];
		format(query, sizeof(query), "SELECT id, cash, bank, adminlvl, wanted, team, class, health, armour, spawn, properties, locale, playtime FROM users WHERE nickname = '%s';", gPlayers[playerid][Name]);

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			print("Database error: cannot fetch user data!");
			return 0;
		}

		new properties[MAX_PLAYER_PROPERTIES], propertiesString[128];

		gPlayers[playerid][OrmID] = DB_GetFieldIntByName(result, "id");
		gPlayers[playerid][Cash] = DB_GetFieldIntByName(result, "cash");
		gPlayers[playerid][Bank] = DB_GetFieldIntByName(result, "bank");
		gPlayers[playerid][AdminLevel] = DB_GetFieldIntByName(result, "adminlvl");
		gPlayers[playerid][WantedLevel] = DB_GetFieldIntByName(result, "wanted");
		gPlayers[playerid][TeamID] = DB_GetFieldIntByName(result, "team");
		gPlayers[playerid][Skin] = DB_GetFieldIntByName(result, "class");
		gPlayers[playerid][Health] = DB_GetFieldIntByName(result, "health");
		gPlayers[playerid][Armour] = DB_GetFieldIntByName(result, "armour");
		gPlayers[playerid][SpawnPoint] = DB_GetFieldIntByName(result, "spawn");
		DB_GetFieldStringByName(result, "properties", propertiesString, sizeof(propertiesString));
		gPlayers[playerid][Locale] = PlayerLocale: DB_GetFieldIntByName(result, "locale");
		gPlayers[playerid][PlayTime] = DB_GetFieldIntByName(result, "playtime");

		ExtractPropperties(propertiesString, properties);
		gPlayers[playerid][Properties] = properties;

		DB_FreeResultSet(result);

		//
		// Drugz
		//

		format(query, sizeof(query), "SELECT cocaine, heroin, meth, fent, zaza, tobacco, pcp, paper, lighter, joint FROM drugz WHERE owner_id = %d AND owner_type = 1", gPlayers[playerid][OrmID]);

		new DBResult: result_drugz = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_drugz) {
			print("Database error: cannot fetch user data (drugz)!");
		}

		gPlayers[playerid][Drugs][COCAINE] = DB_GetFieldIntByName(result_drugz, "cocaine");
		gPlayers[playerid][Drugs][HEROIN] = DB_GetFieldIntByName(result_drugz, "heroin");
		gPlayers[playerid][Drugs][METH] = DB_GetFieldIntByName(result_drugz, "meth");
		gPlayers[playerid][Drugs][FENT] = DB_GetFieldIntByName(result_drugz, "fent");
		gPlayers[playerid][Drugs][ZAZA] = DB_GetFieldIntByName(result_drugz, "zaza");
		gPlayers[playerid][Drugs][TOBACCO] = DB_GetFieldIntByName(result_drugz, "tobacco");
		gPlayers[playerid][Drugs][PCP] = DB_GetFieldIntByName(result_drugz, "pcp");
		gPlayers[playerid][Drugs][PAPER] = DB_GetFieldIntByName(result_drugz, "paper");
		gPlayers[playerid][Drugs][LIGHTER] = DB_GetFieldIntByName(result_drugz, "lighter");
		gPlayers[playerid][Drugs][JOINT] = DB_GetFieldIntByName(result_drugz, "joint");

		DB_FreeResultSet(result_drugz);

		//
		// Tutorial
		//

		format(query, sizeof(query), "SELECT active, property_rented_count, property_bought_count, race_finished_count, joined_team, trucking_missions_done, taxi_missions_done, sent_pm, deposited_money_to_bank, deathmatch_played FROM tutorials WHERE user_id = %d", gPlayers[playerid][OrmID]);

		new DBResult: result_tutorial = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_tutorial) {
			print("Database error: cannot fetch user data (tutorial)!");
		}

		if (DB_GetRowCount(result_tutorial))
		{
			gPlayers[playerid][TutorialStats][Active] = bool: DB_GetFieldIntByName(result_tutorial, "active");
			gPlayers[playerid][TutorialStats][PropertyRentedCount] = DB_GetFieldIntByName(result_tutorial, "property_rented_count");
			gPlayers[playerid][TutorialStats][PropertyBoughtCount] = DB_GetFieldIntByName(result_tutorial, "property_bought_count");
			gPlayers[playerid][TutorialStats][RaceFinishedCount] = DB_GetFieldIntByName(result_tutorial, "race_finished_count");
			gPlayers[playerid][TutorialStats][JoinedTeam] = bool: DB_GetFieldIntByName(result_tutorial, "joined_team");
			gPlayers[playerid][TutorialStats][TruckingMissionsDone] = DB_GetFieldIntByName(result_tutorial, "trucking_missions_done");
			gPlayers[playerid][TutorialStats][TaxiMissionsDone] = DB_GetFieldIntByName(result_tutorial, "taxi_missions_done");
			gPlayers[playerid][TutorialStats][SentPM] = bool: DB_GetFieldIntByName(result_tutorial, "sent_pm");
			gPlayers[playerid][TutorialStats][DepositedMoneyToBank] = DB_GetFieldIntByName(result_tutorial, "deposited_money_to_bank");
			gPlayers[playerid][TutorialStats][DeathmatchPlayed] = bool: DB_GetFieldIntByName(result_tutorial, "deathmatch_played");
		}

		DB_FreeResultSet(result_tutorial);

		GivePlayerMoney(playerid, gPlayers[playerid][Cash]);
		SetPlayerHealth(playerid, gPlayers[playerid][Health]);
		SetPlayerArmour(playerid, gPlayers[playerid][Armour]);
		SetPlayerSkin(playerid, gPlayers[playerid][Skin]);
		SetPlayerTeam(playerid, gPlayers[playerid][TeamID]);
		SetPlayerWantedLevel(playerid, gPlayers[playerid][WantedLevel]);

		if (gPlayers[playerid][TeamID])
			SetPlayerColor(playerid, gTeams[ gPlayers[playerid][TeamID] ][Color]);
		else
			SetPlayerColor(playerid, COLOR_WHITE);

		SendClientMessageLocalized(playerid, I18N_USER_DATA_LOAD_SUCCESS);

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
		SendClientMessageLocalized(playerid, I18N_AUTOSAVE_START);

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

		//writecfg(gPlayers[playerid][Name], "", "properties", propertiesString);

		new query[1024];

		format(query, sizeof(query), "UPDATE users SET cash = %d, bank = %d, adminlvl = %d, wanted = %d, team = %d, class = %d, health = %d, armour = %d, spawn = %d, properties = '%s', locale = %d, playtime = %d WHERE nickname = '%s';", 
				GetPlayerMoney(playerid), 
				gPlayers[playerid][Bank], 
				gPlayers[playerid][AdminLevel], 
				GetPlayerWantedLevel(playerid),
				gPlayers[playerid][TeamID], 
				GetPlayerSkin(playerid), 
				floatround(health), 
				floatround(armour), 
				gPlayers[playerid][SpawnPoint], 
				propertiesString, 
				_: gPlayers[playerid][Locale],
				gPlayers[playerid][PlayTime],
				gPlayers[playerid][Name]
		);

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) {
			printf("Database error: cannot write user data (%s)!", gPlayers[playerid][Name]);
			return 0;
		}

		DB_FreeResultSet(result);

		//
		//  Drugz
		//

		format(query, sizeof(query), "INSERT INTO drugz (owner_type, owner_id, cocaine, heroin, meth, fent, zaza, tobacco, pcp, paper, lighter, joint) VALUES (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d) ON CONFLICT(owner_id) DO UPDATE SET cocaine = excluded.cocaine, heroin = excluded.heroin, meth = excluded.meth, fent = excluded.fent, zaza = excluded.zaza, tobacco = excluded.tobacco, pcp = excluded.pcp, paper = excluded.paper, lighter = excluded.lighter, joint = excluded.joint",
				1,
				gPlayers[playerid][OrmID],
				gPlayers[playerid][Drugs][COCAINE],
				gPlayers[playerid][Drugs][HEROIN],
				gPlayers[playerid][Drugs][METH],
				gPlayers[playerid][Drugs][FENT],
				gPlayers[playerid][Drugs][ZAZA],
				gPlayers[playerid][Drugs][TOBACCO],
				gPlayers[playerid][Drugs][PCP],
				gPlayers[playerid][Drugs][PAPER],
				gPlayers[playerid][Drugs][LIGHTER],
				gPlayers[playerid][Drugs][JOINT]
			);

		new DBResult: result_drugz = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_drugz) {
			printf("Database error: cannot write user data (drugz, ID: %d)!", gPlayers[playerid][OrmID]);
			print(query);
		}

		DB_FreeResultSet(result_drugz);

		//
		//  Tutorial
		//

		format(query, sizeof(query), "INSERT INTO tutorials (user_id, active, property_rented_count, property_bought_count, race_finished_count, joined_team, trucking_missions_done, taxi_missions_done, sent_pm, deposited_money_to_bank, deathmatch_played) VALUES (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d) ON CONFLICT(user_id) DO UPDATE SET active = excluded.active, property_rented_count = excluded.property_rented_count, property_bought_count = excluded.property_bought_count, race_finished_count = excluded.race_finished_count, joined_team = excluded.joined_team, trucking_missions_done = excluded.trucking_missions_done, taxi_missions_done = excluded.taxi_missions_done, sent_pm = excluded.sent_pm, deposited_money_to_bank = excluded.deposited_money_to_bank, deathmatch_played = excluded.deathmatch_played", 
			gPlayers[playerid][OrmID],
			gPlayers[playerid][TutorialStats][Active],
			gPlayers[playerid][TutorialStats][PropertyRentedCount],
			gPlayers[playerid][TutorialStats][PropertyBoughtCount],
			gPlayers[playerid][TutorialStats][RaceFinishedCount],
			gPlayers[playerid][TutorialStats][JoinedTeam],
			gPlayers[playerid][TutorialStats][TruckingMissionsDone],
			gPlayers[playerid][TutorialStats][TaxiMissionsDone],
			gPlayers[playerid][TutorialStats][SentPM],
			gPlayers[playerid][TutorialStats][DepositedMoneyToBank],
			gPlayers[playerid][TutorialStats][DeathmatchPlayed]
		);

		new DBResult: result_tutorial = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result_tutorial) {
			printf("Database error: cannot write user data (tutorial, ID: %d)!", gPlayers[playerid][OrmID]);
			print(query);
		}

		DB_FreeResultSet(result_tutorial);
		
		SendClientMessageLocalized(playerid, I18N_AUTOSAVE_SUCCESS);
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

		if (gPlayers[i][TeamID] == 0)
			continue;

		if (gPlayers[i][AFK])
			continue;

		teamSalary = gTeams[ gPlayers[i][TeamID] - 1 ][SalaryBase] + random(gTeams[ gPlayers[i][TeamID] - 1 ][SalaryVolatile]);

		switch (gPlayers[i][Locale]) 
		{
			case LOCALE_CZ:
				{
				format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Tymova vyplata pristala do kapsy: $%d", teamSalary);

				format(gameText, sizeof(gameText), "~y~V~g~yplata~n~~y~$~g~%d", teamSalary);
				}
			default:
				{
				format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Team salary just arrived: $%d", teamSalary);

				format(gameText, sizeof(gameText), "~y~S~g~alary~n~~y~$~g~%d", teamSalary);
				}
		}

		GameTextForPlayer(i, gameText, 4000, 1);
		SendClientMessage(i, COLOR_YELLOW, stringToPrint);
		GivePlayerMoney(i, teamSalary);
	}

	return 1;
}

forward UpdatePlayerPlayTime(playerid);

public UpdatePlayerPlayTime(playerid)
{
	if (!IsPlayerConnected(playerid))
	{
		KillTimer(_: gPlayers[playerid][PlayTimeTimer]);
	}

	gPlayers[playerid][PlayTime] += 5000;

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
		SendClientMessageLocalized(playerid, I18N_PRIV_MSG_MONEY);
		return 0;
	}

	if (!IsPlayerConnected(receiverid))
	{
		SendClientMessageLocalized(playerid, I18N_PRIV_MSG_NO_PLAYER);
		return 0;
	}

	new stringForReceiver[256], stringForSender[256]; 

	switch (gPlayers[playerid][Locale])
	{
		case LOCALE_CZ:
			{
				format(stringForReceiver, sizeof(stringForReceiver), "[ PM ] od %s (ID: %d): %s", gPlayers[playerid][Name], playerid, text);
				format(stringForSender, sizeof(stringForSender), "[ PM ] pro %s (ID: %d): %s", gPlayers[receiverid][Name], receiverid, text);
			}

		default:
			{
				format(stringForReceiver, sizeof(stringForReceiver), "[ PM ] Received from %s (ID: %d): %s", gPlayers[playerid][Name], playerid, text);
				format(stringForSender, sizeof(stringForSender), "[ PM ] Sent for %s (ID: %d): %s", gPlayers[receiverid][Name], receiverid, text);
			}
	}

	SendClientMessage(receiverid, COLOR_GREEN, stringForReceiver);
	SendClientMessage(playerid, COLOR_GREEN, stringForSender);

	// Play direct message tones.
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); 
	PlayerPlaySound(receiverid, 1057, 0.0, 0.0, 0.0);

	GameTextForPlayer(playerid, "~w~PM ~g~Sent~w~.", 3000, 3); 
	GameTextForPlayer(receiverid, "~w~PM ~g~Received~w~.", 3000, 3);

	GivePlayerMoney(playerid, -10); 

	return 1;
}

#include "modules/deathmatch.pwn"
#include "modules/combat.pwn"

stock MovePlayerToPlayer(playerid, targetid, bool: reversed)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Cannot use get/goto for the player!");

	new 
		interior,
		portedid,
		Float: X, 
		Float: Y, 
		Float: Z;

	if (!reversed)
	{
		GetPlayerPos(targetid, X, Y, Z);
		interior = GetPlayerInterior(targetid);
		portedid = playerid;
	}
	else
	{
		GetPlayerPos(playerid, X, Y, Z);
		interior = GetPlayerInterior(playerid);
		portedid = targetid;
	}

	if (gDeathmatch[portedid][IsRegistered] || gDeathmatch[portedid][InGame] || gCombatMission[playerid][Active])
	{
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
	}

	new portedPlayerState = GetPlayerState(portedid), portedVehicleId = GetPlayerVehicleID(portedid);

	SetPlayerInterior(portedid, interior);

	switch (portedPlayerState)
	{
		case PLAYER_STATE_DRIVER:
			{
				SetVehiclePos(portedVehicleId, X, Y, Z);
			}
		default:
			{
				SetPlayerPos(portedid, X, Y, Z);
			}
	}

	return 1;
}

stock SetPlayerVehicleNitro(playerid, targetid)
{
	if (!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (!IsPlayerInAnyVehicle(targetid))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] The player must be driving a vehicle!");

	new t_PLAYER_STATE: targetPlayerState = GetPlayerState(targetid), targetVehicleId = GetPlayerVehicleID(targetid);

	if (targetPlayerState != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] The player must be driving a vehicle!");

	if (!IsPlayerInValidNosVehicle(targetid, targetVehicleId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Cannot mod such vehicle!");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));

	// Add the NoS component to such vehicleId.
	AddVehicleComponent(targetVehicleId, 1010);

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s installed the Nitrous component to your vehicle!", adminName);

	SendClientMessage(playerid, COLOR_GREY, "[ i ] The Nitrous component installed for the player!");
	SendClientMessage(targetid, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

stock DepositMoneyToBankAccount(playerid, amount)
{
	if (amount > GetPlayerMoney(playerid))
		return SendClientMessage(playerid, COLOR_RED, "[ ATM ] Invalid amount!");

	gPlayers[playerid][Bank] += amount;
	GivePlayerMoney(playerid, -amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Cash deposit: $%d! Account balance: $%d!", amount, gPlayers[playerid][Bank]);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	return 1;
}

stock WithdrawMoneyFromBankAccount(playerid, amount)
{
	if (amount > gPlayers[playerid][Bank])
		return SendClientMessage(playerid, COLOR_RED, "[ ATM ] Invalid amount!");

	gPlayers[playerid][Bank] -= amount;
	GivePlayerMoney(playerid, amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Cash withdrawal: $%d! Account balance: $%d!", amount, gPlayers[playerid][Bank]);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	return 1;
}

stock CheckDrugzPickup(playerid, pickupid)
{
	for (new i = 0; i < MAX_DRUG_PICKUPS; i++)
	{
		if (pickupid != gDrugPickups[i][Pickup])
		{
			continue;
		}

		new amount = random(10), type = _: gDrugPickups[i][Type], stringToPrint[128];

		gPlayers[playerid][Drugs][type - 1] += amount;

		format(stringToPrint, sizeof(stringToPrint), "[ DRUGZ ] Just found %d g of %s.", amount, gDrugz[type - 1][DrugName]);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}

	return 1;
}

stock ProcessBlackMarketOffer(playerid, listitem)
{
	if (!gBlackMarketItems[listitem][OrmID])
	{
		return SendClientMessage(playerid, COLOR_RED, "[ MAKRET ] Such offer has been already processed!");
	}

	new 
		offerid = gBlackMarketItems[listitem][OrmID],
		Float: amount = gBlackMarketItems[listitem][Amount],
		value = gBlackMarketItems[listitem][Value],
		DrugType: type = gBlackMarketItems[listitem][Type],
		price = floatround(amount * value);

	if (GetPlayerMoney(playerid) < price)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ MARKET ] Not enough money to buy an offer!");
	}

	GivePlayerMoney(playerid, -price);
	gPlayers[playerid][Drugs][_: type] += floatround(amount);

	// Clean the market item
	gBlackMarketItems[listitem][OrmID] = -1;
	gBlackMarketItems[listitem][Amount] = 0;
	gBlackMarketItems[listitem][Value] = 0;
	gBlackMarketItems[listitem][Type] = DrugType: TYPE_NONE;

	new msg[64];
	format(msg, sizeof(msg), "[ MARKET ] Offer %d proceeded! (price: %d)", offerid, price);
	SendClientMessage(playerid, COLOR_ORANGE, msg);

	new query[64];	
	format(query, sizeof(query), "DELETE FROM black_market_items WHERE id = %d", offerid);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		printf("Database error: cannot delete market item (ID %d)!", offerid);
		return 1;
	}

	DB_FreeResultSet(result);

	return 1;
}

stock ProcessNewBlackMarketOffer(playerid)
{
	new query[256];
	format(query, sizeof(query), "INSERT INTO black_market_items (settler_id, drug_type, amount, value) VALUES (%d, %d, %f, %d)",
			gPlayers[playerid][OrmID],
			_: gBlackMarketItemOffer[playerid][Type],
			gBlackMarketItemOffer[playerid][Amount],
			gBlackMarketItemOffer[playerid][Value]
		);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		printf("Database error: cannot write new market item!");
		return 1;
	}

	DB_FreeResultSet(result);

	gPlayers[playerid][Drugs][ _: gBlackMarketItemOffer[playerid][Type] - 1 ] -= gBlackMarketItemOffer[playerid][Amount];

	gBlackMarketItemOffer[playerid][Type] = DrugType: TYPE_NONE;
	gBlackMarketItemOffer[playerid][Amount] = 0;
	gBlackMarketItemOffer[playerid][Value] = 0;

	SendClientMessage(playerid, COLOR_ORANGE, "[ MARKET ] New offer placed!");

	return 1;
}
