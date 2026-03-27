#if defined _CRL2_DCMD
	#endinput
#endif
#define _CRL2_DCMD

//
//  dcmd.pwn
//

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

forward LoadDcmdAll(playerid, cmdtext[]);

public LoadDcmdAll(playerid, cmdtext[]) {
	//--------------[ COMMON COMMANDS ]-------------|

	dcmd(acc, 3, cmdtext);            //all
	dcmd(admins, 6, cmdtext);         //all
	dcmd(afk, 3, cmdtext);            //all
	dcmd(animoff, 7, cmdtext);        //all
	dcmd(bank, 4, cmdtext);		  //all
	dcmd(cmd, 3, cmdtext);            //all
	dcmd(credits, 7, cmdtext);        //all
	dcmd(dance, 5, cmdtext);	  //all
	dcmd(deal, 4, cmdtext);	  	  //all
	dcmd(deathmatch, 10, cmdtext);	  //all
	dcmd(drugz, 5, cmdtext); 	  //all
	dcmd(dwarp, 5, cmdtext); 	  //all
	dcmd(fix, 3, cmdtext); 		  //all
	dcmd(fork, 4, cmdtext); 	  //all
	dcmd(givecash, 8, cmdtext);       //all
	dcmd(help, 4, cmdtext);           //all
	dcmd(hide, 4, cmdtext); 	  //all
	dcmd(kill, 4, cmdtext); 	  //all
	dcmd(lay, 3, cmdtext);		  //all
	dcmd(locale, 6, cmdtext); 	  //all
	dcmd(locate, 6, cmdtext); 	  //all
	dcmd(lock, 4, cmdtext);           //all
	dcmd(phone, 5, cmdtext);	  //all
	dcmd(pm, 2, cmdtext);		  //all
	dcmd(port, 4, cmdtext); 	  //all
	dcmd(prizes, 6, cmdtext); 	  //all
	dcmd(property, 8, cmdtext);	  //all
	dcmd(race, 4, cmdtext);		  //all
	dcmd(rules, 5, cmdtext); 	  //all
	dcmd(scores, 6, cmdtext);	  //all
	dcmd(search, 6, cmdtext); 	  //all
	dcmd(skydive, 7, cmdtext);        //all
	dcmd(taxi, 4, cmdtext);           //all
	dcmd(text, 4, cmdtext);           //all
	dcmd(tow, 3, cmdtext);            //all
	dcmd(truck, 5, cmdtext); 	  //all
	dcmd(tut, 3, cmdtext);            //all
	dcmd(unlock, 6, cmdtext);         //all
	dcmd(wanted, 6, cmdtext);	  //all

	//--------------[ ADMIN COMMANDS ]-------------|

	dcmd(acmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(admincol, 8, cmdtext);       //rcon +
	dcmd(ban, 3, cmdtext);            //rcon + lvl 4
	dcmd(cam, 3, cmdtext); 		  //rcon + 
	dcmd(casino, 6, cmdtext);	  ///    + lvl 3
	dcmd(ccmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(clear, 5, cmdtext);          //rcon +
	dcmd(combat, 6, cmdtext);	  //rcon + lvl 4
	dcmd(countdown, 9, cmdtext);      //rcon + 
	dcmd(crime, 5, cmdtext);	  //rcon
	dcmd(drunk, 5, cmdtext);          //rcon +
	dcmd(edit, 4, cmdtext);		  //rcon + lvl 4
	dcmd(elevator, 8, cmdtext);	  //rcon + lvl 4
	dcmd(fakechat, 8, cmdtext);       //rcon + lvl 2
	dcmd(flip, 4, cmdtext);           //rcon + 
	dcmd(get, 3, cmdtext);            //rcon + lvl 3
	dcmd(goto, 4, cmdtext);           //rcon + lvl 3
	dcmd(hp, 2, cmdtext); 		  //rcon + 
	dcmd(kick, 4, cmdtext);           //rcon +
	dcmd(lvl, 3, cmdtext);            //rcon + lvl 4
	dcmd(nitro, 5, cmdtext);          //rcon + lvl 3
	dcmd(packet, 6, cmdtext);         //rcon +
	dcmd(radio, 5, cmdtext);	  //rcon + lvl 4
	dcmd(reset, 5, cmdtext);	  //rcon + lvl 4
	dcmd(restart, 7, cmdtext);	  //rcon + lvl 4
	dcmd(skin, 4, cmdtext); 	  //rcon + lvl 3
	dcmd(spectate, 8, cmdtext);	  //rcon + lvl 2
	dcmd(vehicle, 7, cmdtext);	  //rcon + lvl 4
	dcmd(weapon, 6, cmdtext); 	  //rcon + lvl 3
	dcmd(weapons, 7, cmdtext); 	  //rcon + lvl 3

	return InvalidCommand(playerid);
}


//
//  DCMDs --- COMMON COMMANDS
//

dcmd_acc(playerid, const params[])
{
#pragma unused params
	return ShowPlayerAccountDialog(playerid);
}

dcmd_admins(playerid, const params[])
#pragma unused params
{
	return ShowAdminsOnlineDialog(playerid);
}

dcmd_afk(playerid, const params[])
{
#pragma unused params
	if (gDeathmatch[playerid][InGame] || gDeathmatch[playerid][IsRegistered])
	{
		return SendClientMessageLocalized(playerid, I18N_AFK_CMD_DEATHMATCH_BLOCK);
	}

	new stringToPrint[256], stringID;

	if (!gPlayers[playerid][AFK])
	{
		stringID = I18N_AFK_CMD_APPLIED;

		new playerAFKName[MAX_PLAYER_NAME];
		format(playerAFKName, sizeof(playerAFKName), "%s_AFK", gPlayers[playerid][Name]);
		SetPlayerName(playerid, playerAFKName);

		// Lock the player's animations.
		TogglePlayerControllable(playerid, false);

		gPlayers[playerid][AFK] = true;
	}
	else
	{
		stringID = I18N_AFK_CMD_REVERTED;

		SetPlayerName(playerid, gPlayers[playerid][Name]);

		// Re-enable player's animations.
		TogglePlayerControllable(playerid, true);

		gPlayers[playerid][AFK] = false;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, stringID, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gPlayers[playerid][Name], playerid);
		SendClientMessage(i, COLOR_YELLOW, stringToPrint);
	}

	return 1;
}

dcmd_animoff(playerid, const params[])
{
#pragma unused params
	ClearAnimations(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	return 1;
}

dcmd_bank(playerid, const params[])
{
	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "depo") && strcmp(token1, "draw") && strcmp(token1, "balance")) || (!strcmp(token1, "depo") && !IsNumeric(token2)) || (!strcmp(token1, "draw") && !IsNumeric(token2)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /bank depo [amount]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /bank draw [amount]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /bank balance");
		return 1;
	}

	if (!CheckPlayerBankLocation(playerid))
		return SendClientMessage(playerid, COLOR_RED, "[ ATM ] You must be near the ATM ($) pickup!");

	if (!strcmp(token1, "depo"))
	{
		new targetAmount = strval(token2);

		DepositMoneyToBankAccount(playerid, targetAmount);

	}
	else if (!strcmp(token1, "draw"))
	{
		new targetAmount = strval(token2);

		WithdrawMoneyFromBankAccount(playerid, targetAmount);
	}
	else if (!strcmp(token1, "balance"))
	{
		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Account balance: $%d!", gPlayers[playerid][Bank]);
		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
	}

	return 1;
}

dcmd_cmd(playerid, const params[])
{
#pragma unused params
	return ShowCommonCommandsDialog(playerid);
}

dcmd_credits(playerid, const params[])
{
#pragma unused params
	return ShowCreditsDialog(playerid);
}

dcmd_dance(playerid, const params[])
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessageLocalized(playerid, I18N_ANIMATION_VEHICLE_BLOCK);
	}

	switch (strval(params)) 
	{
		case 1:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
			}
		case 2:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
			}
		case 3:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
			}
		case 4:
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
			}
		default:
			{
				new msg[64];
				GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
				format(msg, sizeof(msg), msg, "/dance [1-4]");
				return SendClientMessage(playerid, COLOR_YELLOW, msg);
			}
	}

	return 1;
}

dcmd_deal(playerid, const params[])
{
	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (gPlayers[playerid][TeamID] != TEAM_DEALERS)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Dealerz-only reserved command!");
	}

	if (!strlen(params) || (!IsNumeric(token1) && !IsNumeric(token2) && !strcmp(token1, "list")) || (strcmp(token1, "list") && IsNumeric(token2)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /deal [playerID] [drugID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /deal list");
		return 1;
	}

	if (IsNumeric(token1) && IsNumeric(token2))
	{
		new targetId = strval(token1);// targetAmount = strval(token2);

		if (targetId == playerid)
		{
			return SendClientMessage(playerid, COLOR_RED, "[ ! ] Cannot deal to such player!");
		}

		if (!IsPlayerConnected(targetId))
		{
			return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");
		}

		//
		//
		//

	}
	else if (!strcmp(token1, "list"))
	{
		new stringToPrint[128];

		SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Drug and stuff list:");

		for (new i = 0; i < MAX_DRUG_TYPES; i++)
		{
			format(stringToPrint, sizeof(stringToPrint), "-> [ID %2d]: %s (got %d g/pcs)", i, gDrugz[i][DrugName], gPlayers[playerid][Drugs][i]);
			SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
		}
	}

	return 1;
}

dcmd_deathmatch(playerid, const params[])
{
#pragma unused params
	return ShowDeathmatchOptionsDialog(playerid);
}

dcmd_drugz(playerid, const params[])
{
#pragma unused params
	return ShowPlayerPocketDrugzDialog(playerid);
}

dcmd_dwarp(playerid, const params[])
{
#pragma unused params
	if (gPlayers[playerid][InsideProperty])
	{
		return SendClientMessageLocalized(playerid, I18N_IN_PROPERTY_BLOCK);
	}

	new t_PLAYER_STATE: playerState = GetPlayerState(playerid), senderName[MAX_PLAYER_NAME], stringToPrint[256], vehicleId = GetPlayerVehicleID(playerid);

	SetPlayerInterior(playerid, 0);
	GetPlayerName(playerid, senderName, sizeof(senderName));

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, I18N_DWARP_CMD_APPLIED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, senderName);
		SendClientMessage(i, COLOR_YELLOW, stringToPrint);
	}

	if (IsPlayerInVehicle(playerid, vehicleId) && playerState == PLAYER_STATE_DRIVER) 
	{
		SetVehiclePos(vehicleId, 2635.67, 1171.51, 10.37);
	}
	else
	{
		SetPlayerPos(playerid, 2635.67, 1171.51, 10.37);
	}

	return 1;
}

dcmd_fix(playerid, const params[])
{
	if (gPlayers[playerid][TeamID] != TEAM_MECHANICS)
	{
		return SendClientMessageLocalized(playerid, I18N_TEAM_RELATED_CMD_MECHANICS);
	}

	if (!strlen(params))
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
			SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
			RepairVehicle(GetPlayerVehicleID(playerid));

			return SendClientMessageLocalized(playerid, I18N_FIX_CMD_APPLIED);
		}

		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/fix [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetid = strval(params);

	if (!IsPlayerConnected(targetid))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (!IsPlayerInAnyVehicle(targetid) || GetPlayerState(targetid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessageLocalized(playerid, I18N_FIX_CMD_TARGET_NOT_IN_VEHICLE);
	}

	new Float: vehicleHealth;
	GetVehicleHealth(GetPlayerVehicleID(targetid), vehicleHealth);

	if (vehicleHealth >= 1000.0)
	{
		return SendClientMessageLocalized(playerid, I18N_FIX_CMD_NO_REPAIRING);
	}

	new Float: pX, Float: pY, Float: pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	if (!IsPlayerInSphere(targetid, pX, pY, pZ, 10.0))
	{
		return SendClientMessageLocalized(playerid, I18N_FIX_CMD_TARGET_TOO_FAR);
	}
	
	SetVehicleHealth(GetPlayerVehicleID(targetid), 1000.0);
	RepairVehicle(GetPlayerVehicleID(targetid));

	new commission = 1500 + random(1000), stringToPrint[128];
	GivePlayerMoney(playerid, commission);

	GetLocalizedString(playerid, I18N_FIX_CMD_COMMISSION_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, commission);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	return SendClientMessageLocalized(targetid, I18N_FIX_CMD_APPLIED);
}

dcmd_fork(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(GetPlayerVehicleID(playerid)) != 530)
	{
		return SendClientMessageLocalized(playerid, I18N_FORK_CMD_FORKLIFTS_BLOCK);
	}

	gPlayers[playerid][SwitchedControllers] = !gPlayers[playerid][SwitchedControllers];

	return SendClientMessageLocalized(playerid, I18N_FORK_CMD_APPLIED);
}

dcmd_givecash(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/givecash [playerID] [$$$]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1), targetAmount = strval(token2);

	if (targetId == playerid)
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_ID_INVALID);
	}

	if (targetAmount > GetPlayerMoney(playerid) || targetAmount <= 0)
	{
		return SendClientMessageLocalized(playerid, I18N_GIVECASH_INVALID_AMOUNT);
	}

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	new playerName[MAX_PLAYER_NAME], stringToPrint[128], targetName[MAX_PLAYER_NAME];

	// Fetch players' names.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	// Send an informative statement to the receiving player.
	GetLocalizedString(targetId, I18N_GIVECASH_RECEIVED, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, targetAmount, playerName, playerid);
	SendClientMessage(targetId, COLOR_LIGHTGREEN, stringToPrint);

	// Transfer money.
	GivePlayerMoney(targetId, targetAmount);
	GivePlayerMoney(playerid, -targetAmount);

	// Send an informative statement to the sending player.
	GetLocalizedString(playerid, I18N_GIVECASH_SENT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, targetAmount, targetName, targetId);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

dcmd_help(playerid, const params[])
{
#pragma unused params
	return ShowServerHelpListDialog(playerid);
}

dcmd_hide(playerid, const params[]) 
{
#pragma unused params
	if (gPlayers[playerid][TeamID] != TEAM_ADMINZ)
	{
		return SendClientMessageLocalized(playerid, I18N_TEAM_RELATED_CMD_ADMINZ);
	}

	new color = GetPlayerColor(playerid);

	if (!gPlayers[playerid][Hidden])
	{
		SetPlayerColor(playerid, color | 0x00);
		SendClientMessageLocalized(playerid, I18N_HIDE_CMD_APPLIED);
	} else {
		SetPlayerColor(playerid, color | 0xAA);
		SendClientMessageLocalized(playerid, I18N_HIDE_CMD_REVERTED);
	}

	gPlayers[playerid][Hidden] = !gPlayers[playerid][Hidden];

	return 1;
}

dcmd_kill(playerid, const params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, I18N_KILL_CMD_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName);
		SendClientMessage(i, COLOR_BROWN, stringToPrint);
	}

	SetPlayerHealth(playerid, 0);

	return 1;
}

dcmd_lay(playerid, const params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessageLocalized(playerid, I18N_ANIMATION_VEHICLE_BLOCK);
	}

	ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, false, true, true, true, true);

	return 1;
}

dcmd_locale(playerid, const params[])
{
#pragma unused params
	return ShowPlayerLocaleListDialog(playerid);
}

dcmd_locate(playerid, const params[])
{
#pragma unused params
	new stringToPrint[256], interiorNo = GetPlayerInterior(playerid), Float:X, Float:Y, Float:Z, Float:Angle;

	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);

	GetLocalizedString(playerid, I18N_LOCATE_COORDS_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, interiorNo, X, Y, Z, Angle);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

dcmd_lock(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_RED, "[ LOCK ] You must be driving/riding a vehicle!");
		return 1;
	}

	if (gTaxiMission[playerid][Active])
	{
		return SendClientMessage(playerid, COLOR_RED, "[ LOCK ] You cannot lock this car!");
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i != playerid)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
		}
	}

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ LOCK ] Vehicle locked!");

	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	PlayerPlaySound(playerid, 1056, pX, pY, pZ);

	return 1;
}

dcmd_phone(playerid, const params[])
{
#pragma unused params
	ApplyAnimation(playerid, "ped", "phone_in", 4.1, false, false, false, true, 0);
	SetPlayerAttachedObject(playerid, 3, 330, 6, 0.00, 0.00, 0.05, 59.59, 60.19, -30.50, 1.02, 1.00, 1.00);

	//EditAttachedObject(playerid, 3);
	ShowPhoneOptionsDialog(playerid);

	return 1;
}

dcmd_pm(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/pm [playerID] [text]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (targetId == playerid)
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_ID_INVALID);
	}

	OnPlayerPrivMsg(playerid, targetId, token2);

	return 1;
}

dcmd_port(playerid, const params[])
{
#pragma unused params

	if (gPlayers[playerid][InsideProperty])
	{
		return SendClientMessageLocalized(playerid, I18N_IN_PROPERTY_BLOCK);
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_IN_MINIGAME_BLOCK);
	}

	return ShowPortListDialog(playerid);
}

dcmd_prizes(playerid, const params[])
{
#pragma unused params
	return ShowPrizesInfoDialog(playerid);
}

dcmd_property(playerid, const params[])
{
#pragma unused params

	return ShowPropertyListDialog(playerid);
}

dcmd_race(playerid, const params[])
{
#pragma unused params

	new raceid = CheckPlayerRaceState(playerid);

	if (!raceid)
	{
		return ShowRaceListDialog(playerid);
	}

	return ShowRaceOptionsDialog(playerid, raceid);
}

dcmd_rules(playerid, const params[])
{
#pragma unused params
	return ShowServerRulesDialog(playerid);
}

dcmd_scores(playerid, const params[])
{
#pragma unused params
	return ShowHighScoresOptionsDialog(playerid);
}

dcmd_search(playerid, const params[]) 
{
	if (gPlayers[playerid][TeamID] != TEAM_POLICE)
	{
		SendClientMessageLocalized(playerid, I18N_TEAM_RELATED_CMD_POLICE);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/search [playerID] [drugz/drunk]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (targetId == playerid)
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_ID_INVALID);
	}

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(targetId, X, Y, Z);

	if (!IsPlayerInSphere(playerid, X, Y, Z, _: 15.0)) 
	{
		return SendClientMessageLocalized(playerid, I18N_SEARCH_CMD_PROXIMITY);
	}

	// Check drunk driving
	if (GetPlayerDrunkLevel(targetId) > 1999 && IsPlayerInAnyVehicle(targetId) && GetPlayerState(targetId) == PLAYER_STATE_DRIVER)
	{
		SendClientMessageLocalized(playerid, I18N_SEARCH_DRUNK_POSITIVE);

		// Lock the car for the player and remove them from such vehicle
		SetVehicleParamsForPlayer(GetPlayerVehicleID(targetId), targetId, 0, 1);
		RemovePlayerFromVehicle(targetId);

		// Play the locker sound
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(targetId, pX, pY, pZ);

		PlayerPlaySound(targetId, 1056, pX, pY, pZ);

		// Fine them
		GivePlayerMoney(targetId, -25000);

		SendClientMessageLocalized(targetId, I18N_SEARCH_DRUNK_POSITIVE_PLAYER);

		// Generate a bonus for the policeman
		new bonus = 4000 + random(6000), stringToPrint[128];
		GivePlayerMoney(playerid, bonus);

		GetLocalizedString(playerid, I18N_SEARCH_DRUNK_BONUS_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, bonus);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

		return 1;
	}

	SendClientMessageLocalized(playerid, I18N_SEARCH_DRUNK_NEGATIVE);
	SendClientMessageLocalized(targetId, I18N_SEARCH_DRUNK_NEGATIVE_PLAYER);

	return 1;
}

dcmd_skydive(playerid, const params[])
{
#pragma unused params
	// Give such user a parachute.
	GivePlayerWeapon(playerid, t_WEAPON: 46, 1);

	// Set their position high above the LV pyramide.
	SetPlayerPos(playerid, 2247.61, 1260.14, 1313.40);

	SendClientMessageLocalized(playerid, I18N_SKYDIVE);

	return 1;
}

dcmd_taxi(playerid, const params[])
{
#pragma unused params
	if (gTaxiMission[playerid][Active])
	{
		return SetPlayerTaxiMission(playerid, 0);
	}

	return ShowTaxiMissionOptionsDialog(playerid);
}

dcmd_text(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/text [playerID] [text]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	new playerName[MAX_PLAYER_NAME], stringToPrint[256], targetName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, I18N_TEXT_PLAYER_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, playerName, targetName, token2);

		SendClientMessage(i, COLOR_YELLOW, stringToPrint);
	}

	return 1;
}

dcmd_tow(playerid, const params[])
{
#pragma unused params
	return ToggleTowMission(playerid);
}

dcmd_truck(playerid, const params[])
{
#pragma unused params
	if (gTrucking[playerid])
	{
		return AbortTruckingMission(playerid);
	}

	return CheckPlayerForTruckingMission(playerid);
}

dcmd_tut(playerid, const params[])
{
#pragma unused params
	return ShowTutorialMainDialog(playerid);
}

dcmd_unlock(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid))
	{
		for (new i = 0; i < MAX_PROPERTIES; i++)
		{
			new vehicleid = gProperties[i][Vehicle][ID];

			if (vehicleid && IsPlayerOwner(playerid, gProperties[i][ID]))
			{
				new Float: X, Float: Y, Float: Z;
				GetVehiclePos(vehicleid, X, Y, Z);

				if (IsPlayerInSphere(playerid, X, Y, Z, 7.5))
				{
					SetVehicleParamsEx(vehicleid, true, false, false, false, false, false, false);
					PlayerPlaySound(playerid, 1056, X, Y, Z);

					SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ LOCK ] Your car is now unlocked and started up");
				}
			}
		}
	}
	else
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			return SendClientMessage(playerid, COLOR_RED, "[ LOCK ] You must be driving/riding a vehicle!");
		}

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
			}
		}

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ LOCK ] Vehicle unlocked");

		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);

		PlayerPlaySound(playerid, 1056, pX, pY, pZ);
	}

	return 1;
}

dcmd_wanted(playerid, const params[]) 
{
#pragma unused params
	if (gPlayers[playerid][TeamID] != TEAM_POLICE && !IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1)
	{
		return SendClientMessageLocalized(playerid, I18N_TEAM_RELATED_CMD_POLICE);
	}

	return ShowWantedListDialog(playerid);
}


//
//  DCMDs --- ADMIN COMMANDS
//

dcmd_acmd(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	return ShowAdminCommandsDialog(playerid);
}

dcmd_admincol(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/admincol [1-5]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new adminColToSet = strval(params);

	new msg[64];
	GetLocalizedString(playerid, I18N_ADMINCOL_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, gAdminColNames[adminColToSet][ gPlayers[playerid][Locale] ]);

	switch (adminColToSet)
	{
		case 1:
			{
				SetPlayerColor(playerid, COLOR_LIGHTGREEN);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
			}
		case 2:
			{
				SetPlayerColor(playerid, COLOR_BLUE);
				SendClientMessage(playerid, COLOR_BLUE, msg);
			}
		case 3:
			{
				SetPlayerColor(playerid, COLOR_RED);
				SendClientMessage(playerid, COLOR_RED, msg);
			}
		case 4:
			{
				SetPlayerColor(playerid, COLOR_ORANGE);
				SendClientMessage(playerid, COLOR_ORANGE, msg);
			}
		case 5:
			{
				SetPlayerColor(playerid, COLOR_WHITE);
				SendClientMessage(playerid, COLOR_WHITE, msg);
			}
		default:
			{
				GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
				format(msg, sizeof(msg), msg, "/admincol [1-5]");
				return SendClientMessage(playerid, COLOR_YELLOW, msg);
			}
	}

	return 1;
}

dcmd_ban(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/ban [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new adminName[MAX_PLAYER_NAME], playerIdToBan = strval(params), playerName[MAX_PLAYER_NAME];

	if (!IsPlayerConnected(playerIdToBan))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	// Fetch participated nicknames.
	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToBan, playerName, sizeof(playerName));

	new msg[128];
	GetLocalizedString(playerid, I18N_PLAYER_BAN_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, adminName, playerid, playerName, playerIdToBan);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		SendClientMessage(i, COLOR_YELLOW, msg);
	}

	Ban(playerIdToBan);

	return 1;
}

dcmd_cam(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/cam [camID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new camid = strval(params);

	new msg[64];
	GetLocalizedString(playerid, I18N_CAM_ATTACHED_ID_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, camid);

	switch (camid)
	{
		case 1:
			{
				SetPlayerCameraPos(playerid, 2219.87, 1266.13, 12.53);
				SetPlayerCameraLookAt(playerid, 2219.89, 1266.13, 12.53);

				return SendClientMessage(playerid, COLOR_BLUE, msg);
			}
		case 2:
			{
				SetPlayerCameraPos(playerid, 2035.62, 1303.53, 10.41);
				SetPlayerCameraLookAt(playerid, 2056.07, 1318.53, 10.41);

				return SendClientMessage(playerid, COLOR_BLUE, msg);
			}
		case 3: 
			{
				SetPlayerCameraPos(playerid, 2254.22, 1207.01, 10.38);
				SetPlayerCameraLookAt(playerid, 2254.22, 1207.01, 10.38);

				return SendClientMessage(playerid, COLOR_BLUE, msg);
			}
		default:
			{
				SetCameraBehindPlayer(playerid);

				return SendClientMessageLocalized(playerid, I18N_CAM_DETACHED);
			}
	}
}

dcmd_casino(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	SetPlayerInterior(playerid, 10);
	SetPlayerPos(playerid, 2016.11, 1017.15, 996.87);

	return 1;
}

dcmd_ccmd(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	SendClientMessage(playerid, COLOR_YELLOWGREEN, "[ CAM ] Cameras:");
	SendClientMessage(playerid, COLOR_YELLOW, "-> /cam 1 (LV Pyramid Entrance)");
	SendClientMessage(playerid, COLOR_YELLOW, "-> /cam 2 (Bank)");
	SendClientMessage(playerid, COLOR_YELLOW, "-> /cam 3");
	SendClientMessage(playerid, COLOR_YELLOW, "-> /camoff");

	return 1;
}

dcmd_clear(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	for (new c = 0; c < 60; c++) 
	{
		SendClientMessageToAll(COLOR_INVISIBLE, " ");
	}

	new msg[64];
	GetLocalizedString(playerid, I18N_CLEAR_CHAT_INFO, msg, sizeof(msg));

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		SendClientMessage(i, COLOR_YELLOW, msg);
	}

	return 1;
}

dcmd_combat(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (gCombatMission[playerid][Active])
	{
		return AbortCombatMission(playerid, false);
	}

	return ShowCombatListDialog(playerid);
}

dcmd_countdown(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params) || !strval(params))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/countdown [sec]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new remaining = strval(params);

	CountDownHelper(remaining);

	return 1;
}

forward CountDownHelper(remaining);

public CountDownHelper(remaining)
{
	if (remaining >= 0)
	{
		GameTextForAll("~n~~n~~n~~n~~n~~n~%d", 1000, 4, remaining);
		SetTimerEx("CountDownHelper", 1000, false, "i", --remaining);
	}
}

dcmd_crime(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new crimeId = strval(params);

	if (crimeId < 3 || crimeId > 22)
	{
		return SendClientMessageLocalized(playerid, I18N_CRIME_LEVEL_INVALID);
	}

	PlayCrimeReportForPlayer(playerid, 0, crimeId);

	return 1;
}

dcmd_drunk(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/drunk [playerID] [0-50000]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1), level = strval(token2);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (level < 0 || level > 50000)
	{
		return SendClientMessageLocalized(playerid, I18N_DRUNK_LEVEL_INVALID);
	}

	SetPlayerDrunkLevel(targetId, level);

	SendClientMessageLocalized(targetId, I18N_DRUNK_LEVEL_SET);

	return 1;
}

dcmd_edit(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	return ShowGameEditorListDialog(playerid);
}

dcmd_elevator(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strcmp(params, "up"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);

		new msg[64];
		GetLocalizedString(playerid, I18N_AE_MOVE_UP, msg, sizeof(msg));
		//format(msg, sizeof(msg), msg);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			SendClientMessage(i, COLOR_YELLOW, msg);
		}
	}
	else if (!strcmp(params, "stop"))
	{
		StopObject(gAdminElevator);

		new msg[64];
		GetLocalizedString(playerid, I18N_AE_MOVE_STOP, msg, sizeof(msg));
		//format(msg, sizeof(msg), msg);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			SendClientMessage(i, COLOR_YELLOW, msg);
		}
	}
	else if (!strcmp(params, "down"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);

		new msg[64];
		GetLocalizedString(playerid, I18N_AE_MOVE_DOWN, msg, sizeof(msg));
		//format(msg, sizeof(msg), msg);

		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			if (!IsPlayerConnected(i))
			{
				continue;
			}

			SendClientMessage(i, COLOR_YELLOW, msg);
		}
	}
	else
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/elevator [up/down/stop]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	return 1;
}

dcmd_fakechat(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/fakechat [playerID] [text]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	SendPlayerMessageToAll(targetId, token2);

	//SendClientMessage(playerid, COLOR_WHITE, "[ FAKE ] Fake client message sent!");

	return 1;
}

dcmd_flip(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new Float: z;

	if (!strlen(params) || !IsNumeric(params)) 
	{
		// Flip and fix player's self vehicle.
		GetVehicleZAngle(GetPlayerVehicleID(playerid), z);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), z);

		SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
		RepairVehicle(GetPlayerVehicleID(playerid));

		return 1;
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (!IsPlayerInAnyVehicle(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_IN_VEHICLE);
	}

	if (GetPlayerState(targetId) != PLAYER_STATE_DRIVER) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_DRIVER);
	}

	// Flip and fix player's vehicle.
	GetVehicleZAngle(GetPlayerVehicleID(targetId), z);
	SetVehicleZAngle(GetPlayerVehicleID(targetId), z);

	SetVehicleHealth(GetPlayerVehicleID(targetId), 1000.0);
	RepairVehicle(GetPlayerVehicleID(targetId));

	return 1;
}

dcmd_get(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		return ShowGetPlayerListDialog(playerid);
	}

	new targetid = strval(params);

	return MovePlayerToPlayer(playerid, targetid, true);

}

dcmd_goto(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		return ShowGotoPlayerListDialog(playerid);
	}

	new targetid = strval(params);

	return MovePlayerToPlayer(playerid, targetid, false);
}

dcmd_hp(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/hp [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (gDeathmatch[targetId][IsRegistered] || gDeathmatch[targetId][InGame])
	{
		return SendClientMessageLocalized(playerid, I18N_DEATHMATCH_INGAME_BLOCK);
	}

	SetPlayerHealth(targetId, 100.0);
	SetPlayerArmour(targetId, 100.0);

	SendClientMessageLocalized(targetId, I18N_PLAYER_HP_SET);

	return 1;
}

dcmd_kick(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/kick [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new adminName[MAX_PLAYER_NAME], playerIdToKick = strval(params), playerName[MAX_PLAYER_NAME];

	if (!IsPlayerConnected(playerIdToKick)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToKick, playerName, sizeof(playerName));

	new msg[128];
	GetLocalizedString(playerid, I18N_PLAYER_KICK_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, adminName, playerid, playerName, playerIdToKick);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		SendClientMessage(i, COLOR_YELLOW, msg);
	}

	Kick(playerIdToKick);

	return 1;
}

dcmd_lvl(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/lvl [playerID] [0-5]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1), targetLvl = strval(token2);

	if (!IsPlayerConnected(targetId)) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (gPlayers[playerid][AdminLevel] <= gPlayers[targetId][AdminLevel])
	{
		return SendClientMessageLocalized(playerid, I18N_ADMIN_LVL_SET_MISMATCH);
	}

	if (targetId == playerid) 
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_ID_INVALID);
	}

	if (targetLvl < 0 || targetLvl > 5)
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/lvl [playerID] [0-5]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	if (targetLvl == gPlayers[targetId][AdminLevel])
	{
		return SendClientMessageLocalized(playerid, I18N_ADMIN_LVL_SET_SAME);
	}

	new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(targetId, playerName, sizeof(playerName));

	gPlayers[targetId][AdminLevel] = targetLvl;
	SavePlayerData(targetId);

	new msg[64];
	GetLocalizedString(playerid, I18N_ADMIN_LVL_SET_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, adminName, playerName, targetId, targetLvl);
	SendClientMessage(playerid, COLOR_GREY, msg);

	return 1;
}

dcmd_nitro(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params))
	{
		new msg[128];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/nitro [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetid = strval(params);

	return SetPlayerVehicleNitro(playerid, targetid);
}

dcmd_packet(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/packet [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	new Float: loss = 0.0;

	GetPlayerPacketLoss(targetId, loss);

	new msg[64];
	GetLocalizedString(playerid, I18N_PACKET_LOSS_FMT, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, targetId, loss);
	SendClientMessage(playerid, COLOR_YELLOW, msg);

	return 1;
}

dcmd_radio(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!gPlayers[playerid][Listening])
	{
		gPlayers[playerid][Listening] = true;
		return PlayAudioStreamForPlayer(playerid, "https://icecast8.play.cz/freeradio128.mp3");
	}
	else
	{
		gPlayers[playerid][Listening] = false;
		return StopAudioStreamForPlayer(playerid);
	}
}

dcmd_reset(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/reset [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	ResetPlayerMoney(targetId);

	return 1;
}

dcmd_restart(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new seconds = 0;

	if (!strlen(params) || !IsNumeric(params)) 
	{
		seconds = 60;
	}
	else 
	{
		seconds = strval(params);
	}

	new msg[64];
	GetLocalizedString(playerid, I18N_SERVER_RESTART_COUNTDOWN, msg, sizeof(msg));
	format(msg, sizeof(msg), msg, seconds);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		SendClientMessage(i, COLOR_YELLOW, msg);
	}

	CountDownHelper(seconds);
	SetTimer("StartServerReset", seconds * SECOND_MS, true);

	return 1;
}

dcmd_skin(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/skin [playerID] [skinID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1), targetSkin = strval(token2);

	if (targetSkin < 0 || targetSkin > 311)
	{
		return SendClientMessageLocalized(playerid, I18N_SKIN_ID_MISMATCH);
	}

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	gPlayers[targetId][Skin] = targetSkin;
	SetPlayerSkin(targetId, targetSkin);

	return 1;
}

dcmd_spectate(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if ((!strlen(params) || !IsNumeric(params)) && !gPlayers[playerid][Spectating])
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/spectate [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	if (gPlayers[playerid][Spectating])
	{
		TogglePlayerSpectating(playerid, false);
		gPlayers[playerid][Spectating] = false;

		SendClientMessageLocalized(playerid, I18N_SPECTATE_DISABLED);
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (playerid == targetId)
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_ID_INVALID);
	}

	TogglePlayerSpectating(playerid, true);
	PlayerSpectatePlayer(playerid, targetId);

	gPlayers[playerid][Spectating] = true;
	SendClientMessageLocalized(playerid, I18N_SPECTATE_ENABLED);

	return 1;
}

dcmd_vehicle(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/vehicle [vehicleID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new modelid = strval(params);

	if (modelid < 400 || modelid > 611)
	{
		return SendClientMessageLocalized(playerid, I18N_VEHICLE_ID_MISMATCH);
	}

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);

	new vehicleid = CreateVehicle(modelid, Float:X, Float:Y, Float:Z + 2.0, 0.0, -1, -1, -1);

	if (vehicleid)
	{
		PutPlayerInVehicle(playerid, vehicleid, 0);
	}

	return 1;
}

dcmd_weapon(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/weapon [playerID] [weaponID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(token1), targetWeapon = strval(token2);

	if (!IsPlayerConnected(targetId))
	{
		return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
	}

	if (gDeathmatch[targetId][IsRegistered] || gDeathmatch[targetId][InGame])
	{
		return SendClientMessageLocalized(playerid, I18N_DEATHMATCH_INGAME_BLOCK);
	}

	GivePlayerWeapon(targetId, t_WEAPON: targetWeapon, 1000);

	return 1;
}

dcmd_weapons(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
	{
		return SendClientMessageLocalized(playerid, I18N_LOW_ADMIN_LEVEL);
	}

	if (!strlen(params) || !IsNumeric(params)) 
	{
		new msg[64];
		GetLocalizedString(playerid, I18N_CMD_USAGE_FMT, msg, sizeof(msg));
		format(msg, sizeof(msg), msg, "/weapons [playerID]");
		return SendClientMessage(playerid, COLOR_YELLOW, msg);
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
	{
		targetId = playerid;
	}

	if (gDeathmatch[targetId][IsRegistered] || gDeathmatch[targetId][InGame])
	{
		return SendClientMessageLocalized(playerid, I18N_DEATHMATCH_INGAME_BLOCK);
	}

	GivePlayerWeapon(targetId, t_WEAPON: 26, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 28, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 31, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 43, 1);
	GivePlayerWeapon(targetId, t_WEAPON: 46, 1);

	return 1;
}

