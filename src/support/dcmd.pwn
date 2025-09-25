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
	dcmd(bank, 4, cmdtext);		  //all
	dcmd(cmd, 3, cmdtext);            //all
	dcmd(dance, 5, cmdtext);	  //all
	dcmd(deal, 4, cmdtext);	  	  //all
	dcmd(deathmatch, 10, cmdtext);	  //all
	dcmd(drugz, 5, cmdtext); 	  //all
	dcmd(dwarp, 5, cmdtext); 	  //all
	dcmd(fix, 3, cmdtext); 		  //all
	dcmd(givecash, 8, cmdtext);       //all
	dcmd(help, 4, cmdtext);           //all
	dcmd(hide, 4, cmdtext); 	  //all
	dcmd(kill, 4, cmdtext); 	  //all
	dcmd(lay, 3, cmdtext);		  //all
	dcmd(locate, 6, cmdtext); 	  //all
	dcmd(lock, 4, cmdtext);           //all
	dcmd(pm, 2, cmdtext);		  //all
	dcmd(port, 4, cmdtext); 	  //all
	dcmd(property, 8, cmdtext);	  //all
	dcmd(race, 4, cmdtext);		  //all
	dcmd(rules, 5, cmdtext); 	  //all
	dcmd(scores, 6, cmdtext);	  //all
	dcmd(search, 6, cmdtext); 	  //all
	dcmd(skydive, 7, cmdtext);        //all
	dcmd(text, 4, cmdtext);           //all
	dcmd(tiki, 4, cmdtext); 	  //all
	dcmd(truck, 5, cmdtext); 	  //all
	dcmd(unlock, 6, cmdtext);         //all
	dcmd(wanted, 6, cmdtext);	  //all

	//--------------[ ADMIN COMMANDS ]-------------|

	dcmd(acmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(admincol, 8, cmdtext);       //rcon +
	dcmd(ban, 3, cmdtext);            //rcon + lvl 4
	dcmd(cam, 3, cmdtext); 		  //rcon + 
	dcmd(ccmd, 4, cmdtext);           //rcon + lvl 1
	dcmd(clear, 5, cmdtext);          //rcon +
	dcmd(countdown, 9, cmdtext);      //rcon + 
	dcmd(crime, 5, cmdtext);	  //rcon
	dcmd(drunk, 5, cmdtext);          //rcon +
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
	dcmd(predit, 6, cmdtext);         //rcon +
	dcmd(redit, 5, cmdtext);          //rcon +
	dcmd(reset, 5, cmdtext);	  //rcon + lvl 4
	dcmd(restart, 7, cmdtext);	  //rcon + lvl 4
	dcmd(skin, 4, cmdtext); 	  //rcon + lvl 3
	dcmd(spectate, 8, cmdtext);	  //rcon + lvl 2
	dcmd(tredit, 6, cmdtext);         //rcon +
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
	new accountPropsText[][] =
	{
		"=> Money: cash $%d, bank $%d",
		"=> TeamID: %d, SkinID: %d",
		"=> Admin level: %d, Wanted level: %d"
	};

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ACCOUNT ] Game account stats");

	for (new i = 0; i < sizeof(accountPropsText); i++)
	{
		new stringToPrint[128];

		switch (i)
		{
			case 0:
				{
					format(stringToPrint, sizeof(stringToPrint), accountPropsText[i], GetPlayerMoney(playerid), gPlayers[playerid][Bank]);
				}
			case 1:
				{
					format(stringToPrint, sizeof(stringToPrint), accountPropsText[i], gPlayers[playerid][TeamID], GetPlayerSkin(playerid));
				}
			case 2:
				{
					format(stringToPrint, sizeof(stringToPrint), accountPropsText[i], gPlayers[playerid][AdminLevel], GetPlayerWantedLevel(playerid));
				}
		}

		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
	}

	return 1;
}

dcmd_admins(playerid, const params[])
#pragma unused params
{
	return ShowAdminsOnlineDialog(playerid);
}

dcmd_afk(playerid, const params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (!gPlayers[playerid][AFK])
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AFK ] Player %s (ID: %d) has just gone away from the keyboard (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

		// Lock the player's animations.
		TogglePlayerControllable(playerid, false);

		gPlayers[playerid][AFK] = true;
	}
	else
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AFK ] Player %s (ID: %d) is back in game (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_LIGHTGREEN, stringToPrint);

		// Re-enable player's animations.
		TogglePlayerControllable(playerid, true);

		gPlayers[playerid][AFK] = false;
	}

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

		if (targetAmount > GetPlayerMoney(playerid))
			return SendClientMessage(playerid, COLOR_RED, "[ ATM ] Invalid amount!");

		gPlayers[playerid][Bank] += targetAmount;
		GivePlayerMoney(playerid, -targetAmount);

		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Cash deposit: $%d! Account balance: $%d!", targetAmount, gPlayers[playerid][Bank]);
		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
	}
	else if (!strcmp(token1, "draw"))
	{
		new targetAmount = strval(token2);

		if (targetAmount > gPlayers[playerid][Bank])
			return SendClientMessage(playerid, COLOR_RED, "[ ATM ] Invalid amount!");

		gPlayers[playerid][Bank] -= targetAmount;
		GivePlayerMoney(playerid, targetAmount);

		new stringToPrint[256];

		format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Cash withdrawal: $%d! Account balance: $%d!", targetAmount, gPlayers[playerid][Bank]);
		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
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

dcmd_dance(playerid, const params[])
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "[ ! ] Animation allowed outside the vehicle only!");
		return 1;
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
				SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /dance [1-4]");
			}
	}

	return 1;
}

dcmd_deal(playerid, const params[])
{
	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (gPlayers[playerid][TeamID] != TEAM_DEALERS)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Dealerz-only reserved command!");

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
			return SendClientMessage(playerid, COLOR_RED, "[ ! ] Cannot deal to such player!");

		if (!IsPlayerConnected(targetId))
			return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");

		//
		//
		//

	}
	else if (!strcmp(token1, "list"))
	{
		new stringToPrint[128];

		SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Drug and stuff list:");

		for (new i = 0; i < MAX_DRUGS; i++)
		{
			format(stringToPrint, sizeof(stringToPrint), "-> [ID %2d]: %s (got %d g/pcs)", i, gDrugz[i][DrugName], gPlayers[playerid][Drugs][i]);
			SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
		}
	}

	return 1;
}

dcmd_deathmatch(playerid, const params[])
{
	if (!strcmp(params, "join"))
	{
		SendClientMessageToAll(COLOR_YELLOW, "[ DEATHMATCH ] Deathmatch starts in 45 seconds! /deathmatch join");
		SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);

		SetTimer("StartPaintball", 45000, false);

		gPaintball[playerid][E_PAINTBALL_INGAME] = 1;
	}
	else if (!strcmp(params, "exit"))
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		if (gPaintball[playerid][E_PAINTBALL_INGAME])
		{
			format(stringToPrint, sizeof(stringToPrint), "[ DEATHMATCH ] Player %s left the deathmatch (/deathmatch exit)!", playerName);
			SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

			SetPlayerHealth(playerid, 0.0);
			gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /deathmatch [join/exit]");
	}

	return 1;
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
		return SendClientMessage(playerid, COLOR_YELLOW, "[ WARP ] Leave the property to be able to use this warp command!");

	new t_PLAYER_STATE: playerState = GetPlayerState(playerid), senderName[MAX_PLAYER_NAME], stringToPrint[256], vehicleId = GetPlayerVehicleID(playerid);

	SetPlayerInterior(playerid, 0);
	GetPlayerName(playerid, senderName, sizeof(senderName));

	format(stringToPrint, sizeof(stringToPrint), "[ WARP ] Player %s used warp to the drag race spot [ /dwarp ]", senderName);
	SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

	if (IsPlayerInVehicle(playerid, vehicleId) && playerState == PLAYER_STATE_DRIVER) 
		SetVehiclePos(vehicleId, 2635.67, 1171.51, 10.37);
	else
		SetPlayerPos(playerid, 2635.67, 1171.51, 10.37);

	return 1;
}

dcmd_fix(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return SendClientMessage(playerid, COLOR_RED, "[ FIX ] Must be riding/driving a vehicle!");

	if (CheckPlayerRaceState(playerid))
		return SendClientMessage(playerid, COLOR_RED, "[ FIX ] Cannot fix your vehicle during a race!");

	SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
	RepairVehicle(GetPlayerVehicleID(playerid));

	SendClientMessage(playerid, COLOR_YELLOW, "[ FIX ] Vehicle fixed!");

	return 1;
}

dcmd_givecash(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /givecash [playerID] [amount]");

	new targetId = strval(token1), targetAmount = strval(token2);

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Invalid transaction amount!");

	if (targetAmount > GetPlayerMoney(playerid) || targetAmount < 0)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid amount!");

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128], targetName[MAX_PLAYER_NAME];

	// Fetch players' names.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	// Send an informative statement to the receiving player.
	format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Received money ($%d) from player %s [ID: %d]!", targetAmount, playerName, playerid);
	SendClientMessage(targetId, COLOR_LIGHTGREEN, stringToPrint);

	// Transfer money.
	GivePlayerMoney(targetId, targetAmount);
	GivePlayerMoney(playerid, -targetAmount);

	// Send an informative statement to the sending player.
	format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Sent money ($%d) to player %s [ID: %d]!", targetAmount, targetName, targetId);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

dcmd_help(playerid, const params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_YELLOWGREEN, "[ HELP ]");
	SendClientMessage(playerid, COLOR_YELLOW, "=> Command list:        /cmd");
	SendClientMessage(playerid, COLOR_YELLOW, "=> Admin command list:  /acmd");
	SendClientMessage(playerid, COLOR_YELLOW, "=> Server rules:        /rules");

	return 1;
}

dcmd_hide(playerid, const params[]) 
{
#pragma unused params
	if (gPlayers[playerid][TeamID] != TEAM_ADMINZ)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Adminz-only team-related command!");

	if (!gPlayers[playerid][Hidden])
	{
		SetPlayerColor(playerid, COLOR_INVISIBLE);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ HIDE ] Player color set to invisible!");
	} else {
		SetPlayerColor(playerid, COLOR_LIGHTGREEN);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ HIDE ] Player color set to light green!");
	}

	gPlayers[playerid][Hidden] = !gPlayers[playerid][Hidden];

	return 1;
}

dcmd_kill(playerid, const params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s has just committed a suicide [ /kill ]!", playerName);
	SendClientMessageToAll(COLOR_BROWN, stringToPrint);

	SetPlayerHealth(playerid, 0);

	return 1;
}

dcmd_lay(playerid, const params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "[ ! ] Animation allowed outside the vehicle only!");
		return 1;
	}

	ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, false, true, true, true, true);

	return 1;
}

dcmd_locate(playerid, const params[])
{
#pragma unused params
	new stringToPrint[256], interiorNo = GetPlayerInterior(playerid), Float:X, Float:Y, Float:Z, Float:Angle;

	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);

	format(stringToPrint, sizeof(stringToPrint), "[ COORDS ] Current location coordinates: Interior No. %d, X[%.2f], Y[%.2f], Z[%.2f], Rotation/Angle[%.2f].", interiorNo, X, Y, Z, Angle);
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

dcmd_pm(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /pm [playerID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");

	OnPlayerPrivMsg(playerid, targetId, token2);

	return 1;
}

dcmd_port(playerid, const params[])
{
	if (gPlayers[playerid][InsideProperty])
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Leave the property to be able to use such command!");

	if (IsPlayerInAnyVehicle(playerid))
		RemovePlayerFromVehicle(playerid);

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /port [location ID]");

	switch (strval(params))
	{
		case 0:
			{
				SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
				SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Las Venturas Escalators");
			}
		case 1:
			{
				SetPlayerPos(playerid, -1951.58, 296.77, 41.04);
				SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] San Fierro WangCars");
			}
	}

	return 1;
}

dcmd_property(playerid, const params[])
{
	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "buy") && strcmp(token1, "sell") && strcmp(token1, "list") && strcmp(token1, "spawn") && strcmp(token1, "vehicle")) || (strcmp(token1, "list") && !IsNumeric(token2)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /property buy [property ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /property sell [property ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /property list");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /property spawn [property ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /property vehicle [property ID]");

		return 1;
	}

	if (!strval(token2) && strcmp(token1, "list"))
		return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Invalid property ID");

	if (!strcmp(token1, "buy"))
	{
		BuyPlayerProperty(playerid, strval(token2));
	}
	else if (!strcmp(token1, "sell"))
	{
		SellPlayerProperty(playerid, strval(token2));
	}
	else if (!strcmp(token1, "list"))
	{
		new stringToPrint[128];

		SendClientMessage(playerid, COLOR_ORANGE, "[ REAL ] Property slots:");

		for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
		{
			new arrayId = GetPropertyArrayIDfromID(gPlayers[playerid][Properties][i]);

			format(stringToPrint, sizeof(stringToPrint), "=> %s: (property ID %5d)", 
					gProperties[arrayId][Label], 
					gPlayers[playerid][Properties][i]
			);

			SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
		}
	}
	else if (!strcmp(token1, "spawn"))
	{
		new propertyID = strval(token2);

		if (!IsPlayerOwner(playerid, propertyID))
			return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Such property must be owned first!");

		for (new i = 0; i < sizeof(gProperties); i++)
		{
			if (gProperties[i][ID] != propertyID || !gProperties[i][Occupied])
				continue;
			
			gPlayers[playerid][SpawnPoint] = propertyID;

			SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ REAL ] Spawn point changed successfully");

			break;
		}
	}
	else if (!strcmp(token1, "vehicle"))
	{
		new propertyID = strval(token2);

		if (!IsPlayerOwner(playerid, propertyID))
			return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Dana nemovitost ti nepatri!");

		for (new i = 0; i < sizeof(gProperties); i++)
		{
			if (gProperties[i][ID] != propertyID || !gProperties[i][Occupied])
				continue;
			
			if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return SendClientMessage(playerid, COLOR_RED, "[ REAL ] You must be driving/riding a vehicle!");

			new vehicleId = GetPlayerVehicleID(playerid);
			new modelId = GetVehicleModel(vehicleId);

			if (gProperties[i][Vehicle][Model] == modelId)
				return SendClientMessage(playerid, COLOR_RED, "[ REAL ] Such vehicle model has been already attached to such property!");

			gProperties[i][Vehicle][Model] = modelId;

			new colour1, colour2;

			GetVehicleColours(vehicleId, colour1, colour2);

			gProperties[i][Vehicle][Colours][0] = colour1;
			gProperties[i][Vehicle][Colours][1] = colour2;

			for (new j = 0; j < 16; j++)
			{
				gProperties[i][Vehicle][Components][j] = GetVehicleComponentInSlot(vehicleId, t_CARMODTYPE: j);
			}

			if (gProperties[i][Vehicle][ID])
				DestroyVehicle(gProperties[i][Vehicle]);

			gProperties[i][Vehicle][ID] = CreateVehicle(gProperties[i][Vehicle][Model], Float:gProperties[i][LocationVehicle][CoordX], Float:gProperties[i][LocationVehicle][CoordY], Float:gProperties[i][LocationVehicle][CoordZ], Float:gProperties[i][LocationVehicle][CoordR], colour1, colour2, -1);

			for (new j = 0; j < 16; j++)
			{
				if (gProperties[i][Vehicle][Components][j])
					AddVehicleComponent(gProperties[i][Vehicle][ID], gProperties[i][Vehicle][Components][j]);
			}

			SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ REAL ] This vehicle has been attached to your property successfully");

			break;
		}
	}

	return 1;
}

dcmd_race(playerid, const params[])
{
	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "join") && strcmp(token1, "exit") && strcmp(token1, "list") && strcmp(token1, "warp")) || (!strcmp(token1, "join") && !IsNumeric(token2)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /race join [ID zavodu]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /race exit");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /race list");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /race warp");

		return 1;
	}

	if (!strcmp(token1, "join"))
	{
		new raceId = strval(token2);

		SetPlayerRaceState(playerid, raceId);
	}
	else if (!strcmp(token1, "exit"))
	{
		ResetPlayerRaceState(playerid, 0, false);
	}
	else if (!strcmp(token1, "list"))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ RACE ] List of currently loaded races (cost / prize):");

		for (new i = 1; i < MAX_RACE_COUNT; i++)
		{
			new stringToPrint[256];

			if (gRaces[i][CostDollars] == 0)
				continue;

			format(stringToPrint, sizeof(stringToPrint), "-> ID: %2d: %s ($%d / $%d)", i, gRaces[i][Name], gRaces[i][CostDollars], gRaces[i][PrizeDollars]);
			SendClientMessage(playerid, COLOR_GREY, stringToPrint);
		}
	}
	else if (!strcmp(token1, "warp"))
	{
		if (gPlayers[playerid][InsideProperty])
			return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Leave the property to be able to use such command!");

		if (SetPlayerRaceStartPos(playerid))
			return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RACE ] Warp near the race start used successfully");
	}

	return 1;
}

dcmd_rules(playerid, const params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_ORANGERED, "[ GAME RULES ]");
	SendClientMessage(playerid, COLOR_ORANGERED, "=> No CARKILL, HELIKILL, or BIKEKILL");
	SendClientMessage(playerid, COLOR_ORANGERED, "=> No MINIGUN, or JETPACK usage, No cheating");
	SendClientMessage(playerid, COLOR_ORANGERED, "=> Anti-Cheat filterscript enabled (cheating => kick, or ban)");

	return 1;
}

dcmd_scores(playerid, const params[])
{
#pragma unused params
	/*for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (!strcmp(gRaces[i][Name], ""))
		{
			continue;
		}

		SortScores(gHighScores, i);
	}*/

	ShowHighScoresDialog(playerid);

	return 1;
}

dcmd_search(playerid, const params[]) 
{
	if (gPlayers[playerid][TeamID] != TEAM_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Police team-related command!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /search [playerID] drugz");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /search [playerID] drunk");

		return 1;
	}

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Cannot use the test against yourself");

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(targetId, X, Y, Z);

	if (!IsPlayerInSphere(playerid, X, Y, Z, _: 15.0)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] You need to be closer to the player to search them");

	// Check drunk driving
	if (GetPlayerDrunkLevel(targetId) > 1999 && IsPlayerInAnyVehicle(targetId) && GetPlayerState(targetId) == PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Player is drunk driving! The player is fined $25000");

		// Lock the car for the player and remove them from such vehicle
		SetVehicleParamsForPlayer(GetPlayerVehicleID(targetId), targetId, 0, 1);
		RemovePlayerFromVehicle(targetId);

		// Play the locker sound
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(targetId, pX, pY, pZ);

		PlayerPlaySound(targetId, 1056, pX, pY, pZ);

		// Fine them
		GivePlayerMoney(targetId, -25000);

		SendClientMessage(targetId, COLOR_ORANGE, "[ DRUGZ ] You have been fined $25000 for drunk driving, your vehicle has been confiscated");

		// Generate a bonus for the policeman
		new bonus = random(10000), stringToPrint[128];
		GivePlayerMoney(playerid, bonus);

		format(stringToPrint, sizeof(stringToPrint), "[ CASH ] Received a &%d bonus", bonus);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

		return 1;
	}

	SendClientMessage(playerid, COLOR_YELLOW, "[ DRUGZ ] You have used a breathalyzer, the player is sober.");
	SendClientMessage(targetId, COLOR_YELLOW, "[ DRUGZ ] You have just been tested for intoxication and you passed");

	return 1;
}

dcmd_skydive(playerid, const params[])
{
#pragma unused params
	// Give such user a parachute.
	GivePlayerWeapon(playerid, t_WEAPON: 46, 1);

	// Set their position high above the LV pyramide.
	SetPlayerPos(playerid, 2247.61, 1260.14, 1313.40);

	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SKYDIVE ] Enjoy the skydive");

	return 1;
}

dcmd_text(playerid, const params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /text [ID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[256], targetName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	format(stringToPrint, sizeof(stringToPrint), "Player %s says to player %s: %s", playerName, targetName, token2);

	SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

	return 1;
}

dcmd_tiki(playerid, const params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TIKI ] Tiki pickups");
	SendClientMessage(playerid, COLOR_YELLOW, "-> Located in Los Santos area");
	SendClientMessage(playerid, COLOR_YELLOW, "-> Prize $10M in cash + a potential Admin level");

	return 1;
}

dcmd_truck(playerid, const params[])
{
#pragma unused params
	if (gTrucking[playerid])
	{
		gTrucking[playerid] = false;
		DisablePlayerRaceCheckpoint(playerid);
		TextDrawHideForPlayer(playerid, gMissionInfoText[playerid]);

		KillTimer(_: gPlayerMissions[playerid][TimerElapsed]);
		KillTimer(_: gPlayerMissions[playerid][TimerAttachedCheck]);

		SetVehicleParamsForPlayer(gPlayerMissions[playerid][VehicleID], playerid, false, false);
		SetVehicleParamsForPlayer(gPlayerMissions[playerid][TrailerID], playerid, false, false);

		SendClientMessage(playerid, COLOR_YELLOW, "[ TRUCK ] Mission aborted");

		return 1;
	}

	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] You have to be in a truck as driver");
	}

	new vehicleId = GetPlayerVehicleID(playerid), truckModels[3] = {403, 514, 515}, bool:isTruck = false;

	for (new i = 0; i < sizeof(truckModels); i++)
	{
		if (GetVehicleModel(vehicleId) == truckModels[i])
		{
			isTruck = true;
			break;
		}
	}

	if (!isTruck)
		return SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] You are not driving a truck");

	if (!IsTrailerAttachedToVehicle(vehicleId))
		return SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] No trailer attached!");

	new trailerId = GetVehicleTrailer(vehicleId), MissionType: truckingMissionType;

	switch (GetVehicleModel(trailerId))
	{
		case 584:
			{
				truckingMissionType = MT_PETROL;
			}
		case 435, 450, 591:
			{
				truckingMissionType = MT_FREIGHT;
			}
		default: 
			{
				SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] Unknown trailer model");
				return 1;
			}
	}

	if (!gTrucking[playerid])
	{
		if (!SetPlayerTruckingMission(playerid, truckingMissionType))
		{
			SendClientMessage(playerid, COLOR_RED, "[ TRUCK ] Error setting new mission");
			return 1;
		}

		gTrucking[playerid] = true;

		gPlayerMissions[playerid][VehicleID] = GetPlayerVehicleID(playerid);
		gPlayerMissions[playerid][TrailerID] = trailerId;
		gPlayerMissions[playerid][Type] = truckingMissionType;
		gPlayerMissions[playerid][DoneCount] = 0;
		gPlayerMissions[playerid][Earned] = 0;
		gPlayerMissions[playerid][TimeElapsed] = 0;
		gPlayerMissions[playerid][TimerElapsed] = SetTimerEx("UpdateMissionInfoText", 1000, true, "i", playerid);
		gPlayerMissions[playerid][TimerAttachedCheck] = SetTimerEx("CheckPlayerTrailerAttached", 1500, true, "i", playerid);


		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TRUCK ] Vehicle and trailer registered successfully");
	}

	return 1;
}

dcmd_unlock(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] You must be driving/riding a vehicle!");

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

	return 1;
}

dcmd_wanted(playerid, const params[]) 
{
#pragma unused params
	if (gPlayers[playerid][TeamID] != TEAM_POLICE && !IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Police team-related command!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (GetPlayerWantedLevel(i) == 0)
			continue;

		GetPlayerName(i, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "-> %s [ID: %d] => WANTED level %d", playerName, i, GetPlayerWantedLevel(i));
		SendClientMessage(playerid, COLOR_WHITE, stringToPrint);
	}

	return 1;
}

//
//  DCMDs --- ADMIN COMMANDS
//

dcmd_acmd(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	return ShowAdminCommandsDialog(playerid);
}

dcmd_admincol(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /admincol [1-5]");

	new adminColToSet = strval(params);

	switch (adminColToSet)
	{
		case 1:
			{
				SetPlayerColor(playerid, COLOR_LIGHTGREEN);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ COL ] Player color set to light green!");
			}
		case 2:
			{
				SetPlayerColor(playerid, COLOR_BLUE);
				SendClientMessage(playerid, COLOR_BLUE, "[ COL ] Player color set to blue!");
			}
		case 3:
			{
				SetPlayerColor(playerid, COLOR_RED);
				SendClientMessage(playerid, COLOR_RED, "[ COL ] Player color set to red!");
			}
		case 4:
			{
				SetPlayerColor(playerid, COLOR_ORANGE);
				SendClientMessage(playerid, COLOR_ORANGE, "[ COL ] Player color set to orange!");
			}
		case 5:
			{
				SetPlayerColor(playerid, COLOR_WHITE);
				SendClientMessage(playerid, COLOR_WHITE, "[ COL ] Player color set to white!");
			}
		default:
			{
				return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Usage: /admincol [1-5]");
			}
	}

	return 1;
}

dcmd_ban(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /ban [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToBan = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[256];

	if (!IsPlayerConnected(playerIdToBan))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	// Get participated nicknames.
	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToBan, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ BAN ] Admin %s [ID: %d] banned player %s [ID: %d] from server!", adminName, playerid, playerName, playerIdToBan);
	SendClientMessageToAll(COLOR_CYAN, stringToPrint);

	Ban(playerIdToBan);

	return 1;
}

dcmd_cam(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	switch (strval(params))
	{
		case 1:
			{
				SetPlayerCameraPos(playerid, 2219.87, 1266.13, 12.53);
				SetPlayerCameraLookAt(playerid, 2219.89, 1266.13, 12.53);

				SendClientMessage(playerid, COLOR_BLUE, "[ CAM ] Camera No. 1 attached [/ccmd][/camoff]");
			}
		case 2:
			{
				SetPlayerCameraPos(playerid, 2035.62, 1303.53, 10.41);
				SetPlayerCameraLookAt(playerid, 2056.07, 1318.53, 10.41);

				SendClientMessage(playerid, COLOR_BLUE, "[ CAM ] Camera No. 2 attached [/ccmd][/camoff]");
			}
		case 3: 
			{
				SetPlayerCameraPos(playerid, 2254.22, 1207.01, 10.38);
				SetPlayerCameraLookAt(playerid, 2254.22, 1207.01, 10.38);

				SendClientMessage(playerid, COLOR_BLUE, "[ CAM ] Camera No. 3 attached [/ccmd][/camoff]");
			}
		default:
			{
				SetCameraBehindPlayer(playerid);

				SendClientMessage(playerid, COLOR_BLUE, "[ CAM ] Camera dettached [/ccmd]");
			}
	}

	return 1;
}

dcmd_ccmd(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

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
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	for (new c = 0; c < 60; c++) 
		SendClientMessageToAll(COLOR_INVISIBLE, " ");

	new adminName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	format(stringToPrint, sizeof(stringToPrint), "[ CLEAR ] Chat history flushed");

	SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

	return 1;
}

dcmd_countdown(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params) || !strval(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /countdown [seconds]");

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
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new crimeId = strval(params);

	if (crimeId < 3 || crimeId > 22)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Invalid input");
	}

	PlayCrimeReportForPlayer(playerid, 0, crimeId);

	return 1;
}

dcmd_drunk(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /drunk [playerID] [0-50000]");

	new targetId = strval(token1), level = strval(token2);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (level < 0 || level > 50000)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Invalid level, use a number from range 0-50000");

	SetPlayerDrunkLevel(targetId, level);
	SendClientMessage(targetId, COLOR_ORANGE, "[ DRUGZ ] Your drunk level changed");

	return 1;
}

dcmd_elevator(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!strcmp(params, "up"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);
		GetPlayerName(playerid, adminName, sizeof(adminName));

		format(stringToPrint, sizeof(stringToPrint), "[ AE ] Admin elevator goes up!");
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
	}
	else if (!strcmp(params, "stop"))
	{
		StopObject(gAdminElevator);

		format(stringToPrint, sizeof(stringToPrint), "[ AE ] Admin elevator malfunction!");
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
	}
	else if (!strcmp(params, "down"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);
		GetPlayerName(playerid, adminName, sizeof(adminName));

		format(stringToPrint, sizeof(stringToPrint), "[ AE ] Admin elevator goes down!");
		SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
	}
	else
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /elevator [up/down/stop]");
	}

	return 1;
}

dcmd_fakechat(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /fakechat [playerID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	SendPlayerMessageToAll(targetId, token2);

	SendClientMessage(playerid, COLOR_WHITE, "[ FAKE ] Fake client message sent!");

	return 1;
}

dcmd_flip(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /flip [ID]!");

	new targetId = strval(params), Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (!IsPlayerInAnyVehicle(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Such player not in a vehicle!");

	if (GetPlayerState(targetId) != PLAYER_STATE_DRIVER) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Such player not driving/riding a vehicle!");

	// Flip player's vehicle.
	GetVehicleZAngle(GetPlayerVehicleID(targetId), z);
	SetVehicleZAngle(GetPlayerVehicleID(targetId), z);

	return 1;
}

dcmd_get(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /get [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Cannot get such player!");

	GetPlayerPos(playerid, x, y, z);

	new targetPlayerState = GetPlayerState(targetId), targetVehicleId = GetPlayerVehicleID(targetId);

	SetPlayerInterior(targetId, 0);

	switch (targetPlayerState)
	{
		case PLAYER_STATE_DRIVER:
			{
				SetVehiclePos(targetVehicleId, x, y, z);
			}
		default:
			{
				SetPlayerPos(targetId, x, y, z);
			}
	}

	return 1;
}

dcmd_goto(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usagei: /goto [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Cannot go to such player!");

	// Fetch the coordinates of the targetId player.
	GetPlayerPos(targetId, x, y, z);

	new playerState = GetPlayerState(playerid), vehicleId = GetPlayerVehicleID(playerid);

	// Ensure the player is outside.
	SetPlayerInterior(playerid, 0);

	switch (playerState) 
	{
		case PLAYER_STATE_DRIVER:
			{
				SetVehiclePos(vehicleId, x, y, z);
			}
		default:
			{
				SetPlayerPos(playerid, x, y, z);
			}
	}

	return 1;
}

dcmd_hp(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /hp [playerID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	SetPlayerHealth(targetId, 100.0);
	SetPlayerArmour(targetId, 100.0);

	SendClientMessage(targetId, COLOR_LIGHTGREEN, "[ HP ] Health: 100.0, Armour: 100.0");

	return 1;
}

dcmd_kick(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /kick [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToKick = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!IsPlayerConnected(playerIdToKick)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToKick, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ KICK ] Admin %s [ID: %d] kicked player %s [ID: %d] from server! ", adminName, playerid, playerName, playerIdToKick);

	SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
	Kick(playerIdToKick);

	return 1;
}

dcmd_lvl(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /lvl [playerID] [0-5]");

	new targetId = strval(token1), targetLvl = strval(token2);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (gPlayers[playerid][AdminLevel] <= gPlayers[targetId][AdminLevel])
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] You can only set the same or lower level that you have got yourself!");

	if (targetId == playerid) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid player!");

	if (targetLvl < 0 || targetLvl > 5)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Usage: /lvl [playerID] [0-5]");

	if (targetLvl == gPlayers[targetId][AdminLevel])
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No need to change such admin level!");

	new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(targetId, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s set player %s [ ID: %d ] an Admin (level %d)!", adminName, playerName, targetId, targetLvl);

	gPlayers[targetId][AdminLevel] = targetLvl;
	SavePlayerData(targetId);

	SendClientMessageToAll(COLOR_GREY, stringToPrint);

	return 1;
}

dcmd_nitro(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 1) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /nitro [ID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (!IsPlayerInAnyVehicle(targetId))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Such player must be driving a vehicle!");

	new t_PLAYER_STATE: targetPlayerState = GetPlayerState(targetId), targetVehicleId = GetPlayerVehicleID(targetId);

	if (targetPlayerState != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] Such player must be driving a vehicle!");

	if (!IsPlayerInValidNosVehicle(targetId, targetVehicleId)) 
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Cannot mod such vehicle!");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));

	// Add the NoS component to such vehicleId.
	AddVehicleComponent(targetVehicleId, 1010);

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s installed the Nitrous component to your vehicle!", adminName);

	SendClientMessage(playerid, COLOR_GREY, "[ i ] The Nitrous component installed for such player!");
	SendClientMessage(targetId, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

dcmd_packet(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /packet [ID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	new Float: loss = 0.0, stringToPrint[128];

	GetPlayerPacketLoss(targetId, loss);

	format(stringToPrint, sizeof(stringToPrint), "[ NET ] Player ID: %d, packet loss: %.2f %%", targetId, loss);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	return 1;
}

dcmd_predit(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "entrance") && strcmp(token1, "offer") && strcmp(token1, "vehicle") && !IsNumeric(token1)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /predit [ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /predit entrance");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /predit offer");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /predit vehicle");

		return 1;
	}

	if (IsNumeric(token1))
	{
		new propertyid = strval(token1);

		gPlayers[playerid][EditingMode] = true;
		gPropertyEdit[playerid][ID] = propertyid;

		ShowPropertyEditDialogMain(playerid);
	}
	else if (!strcmp(token1, "entrance"))
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);

		gPropertyEdit[playerid][LocationEntrance][CoordX] = X;
		gPropertyEdit[playerid][LocationEntrance][CoordY] = Y;
		gPropertyEdit[playerid][LocationEntrance][CoordZ] = Z;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Entrance pickup coords recorded!");
		ShowPropertyEditDialogMain(playerid);
	}
	else if (!strcmp(token1, "offer"))
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);

		gPropertyEdit[playerid][LocationOffer][CoordX] = X;
		gPropertyEdit[playerid][LocationOffer][CoordY] = Y;
		gPropertyEdit[playerid][LocationOffer][CoordZ] = Z;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Offer pickup coords recorded!");
		ShowPropertyEditDialogMain(playerid);
	}
	else if (!strcmp(token1, "vehicle"))
	{
		new Float:X, Float:Y, Float:Z, Float:R;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, R);

		gPropertyEdit[playerid][LocationVehicle][CoordX] = X;
		gPropertyEdit[playerid][LocationVehicle][CoordY] = Y;
		gPropertyEdit[playerid][LocationVehicle][CoordZ] = Z;
		gPropertyEdit[playerid][LocationVehicle][CoordR] = R;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
		ShowPropertyEditDialogMain(playerid);
	}

	return 1;
}

dcmd_redit(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "save") && strcmp(token1, "checkpoint") && strcmp(token1, "truck") && strcmp(token1, "freight") && strcmp(token1, "gas") && strcmp(token1, "info") && !IsNumeric(token1)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit [ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit checkpoint");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit info");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit truck");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit freight");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /redit gas");

		return 1;
	}

	new facilityId = strval(token1);

	if (IsNumeric(params))
	{
		gPlayers[playerid][EditingMode] = true;
		gTruckingEdit[playerid][ID] = facilityId;

		SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] New trucking point editing initialized");
	}

	return 1;
}

dcmd_reset(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /reset [playerID]!");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	ResetPlayerMoney(targetId);

	return 1;
}

dcmd_restart(playerid, const params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new stringToPrint[128];

	format(stringToPrint, sizeof(stringToPrint), "[ RESTART ] Server restarts in 60 seconds!");
	SendClientMessageToAll(COLOR_YELLOW, stringToPrint);

	CountDownHelper(60);
	SetTimer("StartServerReset", 60 * SECOND_MS, true);

	return 1;
}

dcmd_skin(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 2)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /skin [playerID] [skinID]");

	new targetId = strval(token1), targetSkin = strval(token2);

	if (targetSkin < 0 || targetSkin > 311)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid skin ID!");

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");

	SetPlayerSkin(targetId, targetSkin);

	return 1;
}

dcmd_spectate(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3) 
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if ((!strlen(params) || !IsNumeric(params)) && !gPlayers[playerid][Spectating])
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /spectate [playerID]");

	if (gPlayers[playerid][Spectating])
	{
		TogglePlayerSpectating(playerid, false);

		gPlayers[playerid][Spectating] = false;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode disabled!");
	}

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");

	if (playerid == targetId)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid player!");

	TogglePlayerSpectating(playerid, true);
	PlayerSpectatePlayer(playerid, targetId);

	gPlayers[playerid][Spectating] = true;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode enabled (type /spectate again to disable)");

	return 1;
}

dcmd_tredit(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 4)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "save") && strcmp(token1, "checkpoint") && strcmp(token1, "truck") && strcmp(token1, "freight") && strcmp(token1, "gas") && strcmp(token1, "info") && !IsNumeric(token1)))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit [ID]");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit checkpoint");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit info");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit truck");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit freight");
		SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /tredit gas");

		return 1;
	}

	new facilityId = strval(token1);

	if (IsNumeric(params))
	{
		gPlayers[playerid][EditingMode] = true;
		gTruckingEdit[playerid][ID] = facilityId;

		SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] New trucking point editing initialized");
	}
	else if (!strcmp(token1, "checkpoint"))
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);

		gTruckingEdit[playerid][LocationCheckpoint][CoordX] = X;
		gTruckingEdit[playerid][LocationCheckpoint][CoordY] = Y;
		gTruckingEdit[playerid][LocationCheckpoint][CoordZ] = Z;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Checkpoint coords recorded!");
	}
	else if (!strcmp(token1, "info"))
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);

		gTruckingEdit[playerid][LocationInfoPickup][CoordX] = X;
		gTruckingEdit[playerid][LocationInfoPickup][CoordY] = Y;
		gTruckingEdit[playerid][LocationInfoPickup][CoordZ] = Z;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Info pickup coords recorded!");
	}
	else if (!strcmp(token1, "truck"))
	{
		if (gTruckingVehiclesIndex == MAX_VEHICLES_PER_FACILITY)
		{
			SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Vehicle limit reached");
			return 1;
		}

		new Float:X, Float:Y, Float:Z, Float:R;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, R);

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Truck;

		gTruckingVehiclesIndex++;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
	}
	else if (!strcmp(token1, "freight"))
	{
		if (gTruckingVehiclesIndex == MAX_VEHICLES_PER_FACILITY)
		{
			SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Vehicle limit reached");
			return 1;
		}

		new Float:X, Float:Y, Float:Z, Float:R;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, R);

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Freight;

		gTruckingVehiclesIndex++;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
	}
	else if (!strcmp(token1, "gas"))
	{
		if (gTruckingVehiclesIndex == MAX_VEHICLES_PER_FACILITY)
		{
			SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Vehicle limit reached");
			return 1;
		}

		new Float:X, Float:Y, Float:Z, Float:R;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, R);

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordX] = X;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordY] = Y;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordZ] = Z;
		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Location][CoordR] = R;

		gTruckingVehicles[playerid][gTruckingVehiclesIndex][Type] = Gas;

		gTruckingVehiclesIndex++;

		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Vehicle coords recorded!");
	}
	else if (!strcmp(token1, "save"))
	{
		if (SetTruckingPoint(playerid))
			return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point and vehicles saved successfully");

		SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Database error occured while saving trucking data");
	}

	return 1;
}

dcmd_vehicle(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /vehicle [vehicleID]");

	new vehicleId = strval(params);

	if (vehicleId < 400 || vehicleId > 611)
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid ID! (IDs 400-611)");

	new Float:X, Float:Y, Float:Z;

	GetPlayerPos(playerid, X, Y, Z);
	CreateVehicle(vehicleId, Float:X, Float:Y, Float:Z, 0.0, -1, -1, -1);

	return 1;
}

dcmd_weapon(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /weapon [playerID] [weaponID]");

	new targetId = strval(token1), targetWeapon = strval(token2);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No such player online!");

	GivePlayerWeapon(targetId, t_WEAPON: targetWeapon, 1000);

	return 1;
}

dcmd_weapons(playerid, const params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3)
		return SendClientMessage(playerid, COLOR_RED, "[ CMD ] Admin level too low!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_YELLOW, "[ CMD ] Usage: /weapons [playerID]!");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		//return SendClientMessage(playerid, COLOR_RED, "[ ! ] No such player online!");
		targetId = playerid;

	GivePlayerWeapon(targetId, t_WEAPON: 26, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 28, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 31, 400);
	GivePlayerWeapon(targetId, t_WEAPON: 43, 1);
	GivePlayerWeapon(targetId, t_WEAPON: 46, 1);

	return 1;
}

