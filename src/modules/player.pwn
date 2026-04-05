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

	// Temporary and concurrent vars
	ClickedPlayerID, 
	PMTargetID,
	PropertyOwnedID,
	SelectedDrugID,
	SelectedSkinID,
	NewRaceID,
	RacesHSOffset,

	// To precompile and save the currently online player list mappings to the dialog-controlled listitem values.
	OnlinePlayerList[MAX_PLAYERS],

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
forward UpdatePlayerPlayTime();
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
		if (!result) 
		{
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
		if (!result_drugz) 
		{
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
		if (!result_tutorial) 
		{
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
		{
			SetPlayerColor(playerid, gTeams[ gPlayers[playerid][TeamID] ][Color]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
		}

		SendClientMessageLocalized(playerid, I18N_USER_DATA_LOAD_SUCCESS);

		return 1;
	}

	return 0;
}

stock ExtractPropperties(const input[], properties[MAX_PLAYER_PROPERTIES])
{
	new i = 0, token1[128], token2[128], toSplit[128];

	strcopy(toSplit, input);

	do 
	{
		SplitIntoTwo(toSplit, token1, token2, sizeof(token1), ",");
		properties[i] = strval(token1);

		strcopy(toSplit, token2);
		i++;
	} 
	while (strcmp(token2, ""));

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
		if (!result) 
		{
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
		if (!result_drugz) 
		{
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
		if (!result_tutorial) 
		{
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
		{
			continue;
		}

		if (gPlayers[i][TeamID] == 0)
		{
			continue;
		}

		if (gPlayers[i][AFK])
		{
			continue;
		}

		teamSalary = gTeams[ gPlayers[i][TeamID] - 1 ][SalaryBase] + random(gTeams[ gPlayers[i][TeamID] - 1 ][SalaryVolatile]);

		// Send localized client message to a player
		GetLocalizedString(i, I18N_PLAYER_SALARY_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, teamSalary);
		SendClientMessage(i, COLOR_YELLOW, stringToPrint);

		// Show localized game text to a player
		GetLocalizedString(i, I18N_PLAYER_SALARY_GAMETEXT_FMT, gameText, sizeof(gameText));
		format(gameText, sizeof(gameText), gameText, teamSalary);
		GameTextForPlayer(i, gameText, 4000, 1);

		GivePlayerMoney(i, teamSalary);
	}

	return 1;
}

public UpdatePlayerPlayTime()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			return 1;	
		}

		gPlayers[i][PlayTime] += 5000;
	}

	return 1;
}

public UpdatePlayerScore()
{
	for (new i; i < GetMaxPlayers(); i++)
	{
		if (!IsPlayerConnected(i))
		{
			return 1;	
		}

		SetPlayerScore(i, GetPlayerMoney(i));
	}

	return 1;
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

	GetLocalizedString(receiverid, I18N_PRIV_MSG_RECEIVED_FMT, stringForReceiver, sizeof(stringForReceiver));
	format(stringForReceiver, sizeof(stringForReceiver), stringForReceiver, 
			gPlayers[playerid][Name], 
			playerid, 
			text
		);

	GetLocalizedString(playerid, I18N_PRIV_MSG_SENT_FMT, stringForSender, sizeof(stringForSender));
	format(stringForSender, sizeof(stringForSender), stringForSender,
			gPlayers[receiverid][Name], 
			receiverid, 
			text
		);

	SendClientMessage(receiverid, COLOR_GREEN, stringForReceiver);
	SendClientMessage(playerid, COLOR_GREEN, stringForSender);

	// Play direct message tones.
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0); 
	PlayerPlaySound(receiverid, 1057, 0.0, 0.0, 0.0);

	new gameTextSent[32], gameTextReceived[32];

	GetLocalizedString(playerid, I18N_PRIV_MSG_SENT_GAMETEXT, gameTextSent, sizeof(gameTextSent));
	GetLocalizedString(receiverid, I18N_PRIV_MSG_RECEIVED_GAMETEXT, gameTextReceived, sizeof(gameTextReceived));

	GameTextForPlayer(playerid, gameTextSent, 3000, 3); 
	GameTextForPlayer(receiverid, gameTextReceived, 3000, 3);

	GivePlayerMoney(playerid, -10); 

	return 1;
}

#include "modules/deathmatch.pwn"
#include "modules/combat.pwn"

stock MovePlayerToPlayer(playerid, targetid, bool: reversed)
{
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (targetid == playerid)
	{
		return SendClientMessageLocalized(playerid, I18N_MOVE_TO_PLAYER_INVALID_ID);
	}

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
		return SendClientMessageLocalized(playerid, I18N_MOVE_TO_PLAYER_IN_MINIGAME_BLOCK);
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
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (!IsPlayerInAnyVehicle(targetid))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_DRIVER);
	}

	new 
		t_PLAYER_STATE: targetPlayerState = GetPlayerState(targetid), 
		targetVehicleId = GetPlayerVehicleID(targetid);

	if (targetPlayerState != PLAYER_STATE_DRIVER)
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_DRIVER);
	}

	if (!IsPlayerInValidNosVehicle(targetid, targetVehicleId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_VEHICLE_MOD_BLOCKED);
	}

	new 
		adminName[MAX_PLAYER_NAME], 
		stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));

	// Add the NoS component to such vehicleId.
	AddVehicleComponent(targetVehicleId, 1010);

	GetLocalizedString(targetid, I18N_VEHICLE_MOD_NITRO_INSTALLED_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, adminName);
	SendClientMessage(targetid, COLOR_LIGHTGREEN, stringToPrint);

	GetLocalizedString(playerid, I18N_VEHICLE_MOD_NITRO_INSTALLED_ADMIN, stringToPrint, sizeof(stringToPrint));
	SendClientMessage(playerid, COLOR_GREY, stringToPrint);

	return 1;
}

stock DepositMoneyToBankAccount(playerid, amount)
{
	if (amount > GetPlayerMoney(playerid))
	{
		return SendClientMessageLocalized(playerid, I18N_ATM_INVALID_AMOUNT);
	}

	gPlayers[playerid][Bank] += amount;
	GivePlayerMoney(playerid, -amount);

	new stringToPrint[256];

	GetLocalizedString(playerid, I18N_ATM_DEPOSITED_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, amount, gPlayers[playerid][Bank]);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	return 1;
}

stock WithdrawMoneyFromBankAccount(playerid, amount)
{
	if (amount > gPlayers[playerid][Bank])
	{
		return SendClientMessageLocalized(playerid, I18N_ATM_INVALID_AMOUNT);
	}

	gPlayers[playerid][Bank] -= amount;
	GivePlayerMoney(playerid, amount);

	new stringToPrint[256];

	GetLocalizedString(playerid, I18N_ATM_WITHDRAWAL_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, amount, gPlayers[playerid][Bank]);
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

		GetLocalizedString(playerid, I18N_DRUGZ_PICKUP_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, amount, gDrugz[type - 1][DrugName]);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
		break;
	}

	return 1;
}

stock ProcessBlackMarketOffer(playerid, listitem)
{
	if (!gBlackMarketItems[listitem][OrmID])
	{
		return SendClientMessageLocalized(playerid, I18N_BLACK_MARKET_ALREADY_PROCESSED);
	}

	new 
		offerid = gBlackMarketItems[listitem][OrmID],
		settler_id = gBlackMarketItems[listitem][SettlerID],
		Float: amount = gBlackMarketItems[listitem][Amount],
		value = gBlackMarketItems[listitem][Value],
		DrugType: type = gBlackMarketItems[listitem][Type],
		price = floatround(amount * value);

	if (GetPlayerMoney(playerid) < price)
	{
		return SendClientMessageLocalized(playerid, I18N_BLACK_MARKET_NO_MONEY);
	}

	new query[64];
	format(query, sizeof(query), "UPDATE users SET bank = bank + %d WHERE id = %d", 
			price,
			settler_id
		);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot update players bank account (offer ID %d, settler_id: %d)!", offerid, settler_id);
		return 1;
	}

	DB_FreeResultSet(result);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (settler_id == gPlayers[i][OrmID] && IsPlayerConnected(i))
		{
			gPlayers[i][Bank] += price;
			//GivePlayerMoney(i, price);

			new msg[64];
			GetLocalizedString(i, I18N_BLACK_MARKET_OFFER_ACCEPTED_FMT, msg, sizeof(msg));
			format(msg, sizeof(msg), msg, price);
			SendClientMessage(i, COLOR_ORANGE, msg);
			break;
		}
	}

	GivePlayerMoney(playerid, -price);
	gPlayers[playerid][Drugs][_: type] += floatround(amount);

	// Clean the market item
	gBlackMarketItems[listitem][OrmID] = -1;
	gBlackMarketItems[listitem][SettlerID] = -1;
	gBlackMarketItems[listitem][Amount] = 0;
	gBlackMarketItems[listitem][Value] = 0;
	gBlackMarketItems[listitem][Type] = DrugType: TYPE_NONE;

	new msg[64];
	GetLocalizedString(playerid, I18N_BLACK_MARKET_OFFER_PROCESSED_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, offerid, price);
	SendClientMessage(playerid, COLOR_ORANGE, msg);

	format(query, sizeof(query), "DELETE FROM black_market_items WHERE id = %d", offerid);

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
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

	return SendClientMessageLocalized(playerid, I18N_BLACK_MARKET_OFFER_PLACED);
}

forward SpawnPlayerDelayed(playerid);
public SpawnPlayerDelayed(playerid)
{
	SpawnPlayer(playerid);
}

#include "modules/trucking.pwn"
#include "modules/taxi.pwn"
#include "modules/tow.pwn"
#include "modules/race.pwn"

stock HandlePlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
	switch (newkeys)
	{
		//case KEY_SPRINT:
		case KEY_JUMP:
			{
				if (!gPlayers[playerid][SwitchedControllers])
				{
					return 1;
				}

				if (!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(GetPlayerVehicleID(playerid)) != 530)
				{
					return 1;
				}

				new vehicleid = GetPlayerVehicleID(playerid);

				new Float:vx, Float:vy, Float:vz;
				GetVehicleVelocity(vehicleid, vx, vy, vz);

				vx *= 1.125;
				vy *= 1.125;

				SetVehicleVelocity(vehicleid, vx, vy, vz);

			    	return 1;
			}
		case KEY_SECONDARY_ATTACK:
			{
				if (!IsPlayerInAnyVehicle(playerid))
				{
					new Float:x, Float:y, Float:z, vehicle;
					GetPlayerPos(playerid, x, y, z);
					GetVehicleWithinDistance(playerid, x, y, z, 20.0, vehicle);
					if (IsVehicleRcTram(vehicle))
					{
						PutPlayerInVehicle(playerid, vehicle, 0);
					}
				}
				else
				{
					new vehicleID = GetPlayerVehicleID(playerid);
					if (IsVehicleRcTram(vehicleID) || GetVehicleModel(vehicleID) == RC_CAM)
					{
						if (GetVehicleModel(vehicleID) == D_TRAM)
						{
							new Float:x, Float:y, Float:z;
							GetPlayerPos(playerid, x, y, z);
							SetPlayerPos(playerid, x + 0.5, y, z + 1.0);

							SetCameraBehindPlayer(playerid);
						}
					}
				}
			}
		case KEY_SUBMISSION:
			{
				if (gTrucking[playerid])
				{
					return AbortTruckingMission(playerid);
				}

				if (IsPlayerInTruck(playerid))
				{
					return CheckPlayerForTruckingMission(playerid);
				}

				if (gTaxiMission[playerid][Active])
				{
					return AbortPlayerTaxiMission(playerid);
				}

				if (IsPlayerInTaxiCab(playerid))
				{
					return ShowTaxiMissionOptionsDialog(playerid);
				}

				if (gTowMission[playerid][Active])
				{
					return OperateTowTruck(playerid);
				}

				if (gPlayers[playerid][TeamID] && gTeams[ gPlayers[playerid][TeamID] - 1 ][ID] == TEAM_MECHANICS)
				{
					for (new i = 0; i < MAX_PLAYERS; i++)
					{
						if (!IsPlayerConnected(i) || !IsPlayerInAnyVehicle(i))
						{
							continue;
						}

						new Float: X, Float: Y, Float: Z;
						GetPlayerPos(playerid, X, Y, Z);

						if (!IsPlayerInSphere(i, X, Y, Z, 7.5))
						{
							continue;
						}

						new Float: health;
						GetVehicleHealth(GetPlayerVehicleID(i), health);

						if (health >= 1000.0)
						{
							//SendClientMessage(playerid, COLOR_YELLOW, "[ FIX ] No need to repair this vehicle");
							continue;
						}

						SetVehicleHealth(GetPlayerVehicleID(i), 1000.0);
						RepairVehicle(GetPlayerVehicleID(i));

						SendClientMessage(i, COLOR_LIGHTGREEN, "[ FIX ] Vehicle fixed!");

						if (i == playerid)
						{
							continue;
						}

						new commission = 1500 + random(1000), stringToPrint[128];
						GivePlayerMoney(playerid, commission);

						format(stringToPrint, sizeof(stringToPrint), "[ FIX ] Vehicle fixed, commission earned: $%d", commission);

						SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
					}
				}
			}
		case KEY_YES:
			{
				ApplyAnimation(playerid, "ped", "phone_in", 4.1, false, false, false, true, 0);
				SetPlayerAttachedObject(playerid, 3, 330, 6, 0.00, 0.00, 0.05, 59.59, 60.19, -30.50, 1.02, 1.00, 1.00);

				ShowPhoneOptionsDialog(playerid);
			}
		case KEY_NO:
			{
				if (gPlayers[playerid][AdminLevel] < 4)
				{
					return 1;
				}

				if (!gPlayers[playerid][EditingMode])
				{
					return 1;
				}

				if (gPlayerRaceEdit[playerid][ID])
				{
					switch (gPlayerRaceEdit[playerid][EditType])
					{
						case RACE_EDITOR_START_COORDS:
							{
								new Float: X, Float: Y, Float: Z;
								GetPlayerPos(playerid, X, Y, Z);

								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_X] = X;
								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_Y] = Y;
								gPlayerRaceEdit[playerid][Start][E_RACE_COORD_Z] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Start coords recorded!");
								return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
							}
						case RACE_EDITOR_TRACK_COORDS:
							{
								new Float: X, Float: Y, Float: Z;
								GetPlayerPos(playerid, X, Y, Z);

								new coord_no = gPlayerRaceEdit[playerid][EditTrackCoordNo];

								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_X] = X;
								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_Y] = Y;
								gPlayerRaceEditTrackCoords[playerid][coord_no][E_RACE_COORD_Z] = Z;

								gPlayerRaceEdit[playerid][EditTrackCoordNo]++;

								new stringToPrint[128];
								format(stringToPrint, sizeof(stringToPrint), "[ EDIT ] Track coords no. %d recorded!", coord_no);
								SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

								return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
							}
					}
				}

				if (gPropertyEdit[playerid][ID])
				{
					new Float: X, Float: Y, Float: Z, Float: R;
					GetPlayerPos(playerid, X, Y, Z);

					switch (gPropertyEdit[playerid][EditingMode])
					{
						case PREDIT_SPAWN_POINT:
							{
								gPropertyEdit[playerid][CoordsSpawn][CoordX] = X;
								gPropertyEdit[playerid][CoordsSpawn][CoordY] = Y;
								gPropertyEdit[playerid][CoordsSpawn][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Spawn coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_ENTRANCE_POINT:
							{
								gPropertyEdit[playerid][CoordsEntrance][CoordX] = X;
								gPropertyEdit[playerid][CoordsEntrance][CoordY] = Y;
								gPropertyEdit[playerid][CoordsEntrance][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Entrance coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_OFFER_POINT:
							{
								gPropertyEdit[playerid][CoordsOffer][CoordX] = X;
								gPropertyEdit[playerid][CoordsOffer][CoordY] = Y;
								gPropertyEdit[playerid][CoordsOffer][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Offer coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_MONEY_POINT:
							{
								gPropertyEdit[playerid][CoordsMoney][CoordX] = X;
								gPropertyEdit[playerid][CoordsMoney][CoordY] = Y;
								gPropertyEdit[playerid][CoordsMoney][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Money coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_SHIRT_POINT:
							{
								if (!gPropertyEdit[playerid][CustomInterior])
								{
									SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Shirt coords are automatic when the property has no custom interior!");
									return ShowPropertyEditDialogMain(playerid);
								}

								gPropertyEdit[playerid][CoordsShirt][CoordX] = X;
								gPropertyEdit[playerid][CoordsShirt][CoordY] = Y;
								gPropertyEdit[playerid][CoordsShirt][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Shirt coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						case PREDIT_VEHICLE_POINT:
							{
								GetPlayerFacingAngle(playerid, R);

								gPropertyEdit[playerid][CoordsVehicle][CoordX] = X;
								gPropertyEdit[playerid][CoordsVehicle][CoordY] = Y;
								gPropertyEdit[playerid][CoordsVehicle][CoordZ] = Z;
								gPropertyEdit[playerid][CoordsVehicle][CoordR] = R;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
								gPropertyEdit[playerid][EditingMode] = PREDIT_NONE;

								return ShowPropertyEditDialogMain(playerid);
							}
						default:
							{
								return 1;
							}
					}
				}

				if (gBribeEdit[playerid][Type] != BREDIT_NONE)
				{
					new Float: X, Float: Y, Float: Z;
					GetPlayerPos(playerid, X, Y, Z);

					switch (gBribeEdit[playerid][Type])
					{
						case BREDIT_NEW:
							{
								gBribeEdit[playerid][CoordX] = X;
								gBribeEdit[playerid][CoordY] = Y;
								gBribeEdit[playerid][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Bribe pickup coords presaved!");
								return ShowBribeEditorNoteDialog(playerid);
							}
						case BREDIT_DELETE:
							{
								return 1;
							}
						default:
							{
								return 1;
							}
					}
				}

				if (gTruckingEdit[playerid][ID])
				{
					new Float: X, Float: Y, Float: Z, Float: R;
					GetPlayerPos(playerid, X, Y, Z);

					switch (gTruckingEdit[playerid][EditType])
					{
						case TREDIT_CHECKPOINT:
							{
								gTruckingEdit[playerid][LocationCheckpoint][CoordX] = X;
								gTruckingEdit[playerid][LocationCheckpoint][CoordY] = Y;
								gTruckingEdit[playerid][LocationCheckpoint][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Checkpoint coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_INFO_PICKUP:
							{
								gTruckingEdit[playerid][LocationInfoPickup][CoordX] = X;
								gTruckingEdit[playerid][LocationInfoPickup][CoordY] = Y;
								gTruckingEdit[playerid][LocationInfoPickup][CoordZ] = Z;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Info pickup coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_TRUCK:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Truck;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Truck vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_GAS:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Gas;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Gas trailer vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						case TREDIT_FREIGHT:
							{
								GetPlayerFacingAngle(playerid, R);

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

								gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Freight;
								gTruckingVehiclesIndex++;

								SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Freight trailer vehicle coords recorded!");
								return ShowTruckingEditorOptionsDialog(playerid);
							}
						default:
							{
								return 1;
							}
					}
				}
			}
	}

	return 1;
}

