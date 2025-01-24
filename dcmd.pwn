//
//
//  [ DCMDs ]
//
//

dcmd_lock(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute, nebo nejsi ridicem!");
		return 1;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i != playerid)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
		}
	}

	SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Vozidlo zamceno! :)");

	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	PlayerPlaySound(playerid, 1056, pX, pY, pZ);

	return 1;
}

dcmd_unlock(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute, nebo nejsi ridicem!");
		return 1;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i != playerid)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
		}
	}

	SendClientMessage(playerid, COLOR_SVZEL, "[ i ] Vozidlo odemceno! :)");

	new Float:pX, Float:pY, Float:pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	PlayerPlaySound(playerid, 1056, pX, pY, pZ);

	return 1;
}

dcmd_register(playerid, params[])
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (gPlayerAuth[playerid])
		return SystemMsg(playerid, "[SERVER] Registrace herniho uctu probehla uspesne! --> /login *heslo*");

	if (udb_Exists(playerName))
		return SystemMsg(playerid, "[SERVER] Neni treba se znovu registrovat --> /login *heslo*.");

	if (strlen(params) == 0)
		return SystemMsg(playerid, "[SERVER] Registrace je povinna --> /register *heslo*");

	if (udb_Create(playerName, params))
		return SystemMsg(playerid, "[SERVER] Herni ucet uspesne vytvoren --> /login *heslo*.");

	return 1;
}

dcmd_login(playerid, params[])
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (gPlayerAuth[playerid]) 
		return SystemMsg(playerid, "[SERVER] Uz jsi prihlasen.");

	if (!udb_Exists(playerName)) 
		return SystemMsg(playerid, "[SERVER] Data pro dany nickname nenalezena --> /register *heslo*");

	if (strlen(params) == 0) 
		return SystemMsg(playerid, "[SERVER] Je treba se prihlasit --> /login *heslo*");

	if (udb_CheckLogin(playerName, params))
	{
		gPlayerAuth[playerid] = true;
		LoadPlayerData(playerid);

		return SystemMsg(playerid, "[SERVER] Hrac prihlasen, pokracujte pomoci Spawn.");
	}

	return SystemMsg(playerid, "[SERVER] Prihlaseni se nezdarilo --> /login *heslo*");
}


dcmd_smazat(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	for (new c = 0; c < 45; c++) 
		SendClientMessageToAll(COLOR_NEVIDITEL, " ");

	new adminName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s promazal(a) chat.", adminName);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_text(playerid, params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /text [ID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[256], targetName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	format(stringToPrint, sizeof(stringToPrint), "Hrac %s rika hraci %s, ze: %s", playerName, targetName, token2);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_afk(playerid, params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (!gPlayerData[playerid][E_PLAYER_DATA_AFK])
	{
		format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrac %s (ID: %d) na chvili odesel od PC (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

		// Lock the player's animations.
		TogglePlayerControllable(playerid, false);

		gPlayerData[playerid][E_PLAYER_DATA_AFK] = 1;
	}
	else
	{
		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s (ID: %d) se vratil do hry (/afk)!", playerName, playerid);
		SendClientMessageToAll(COLOR_SVZEL, stringToPrint);

		// Re-enable player's animations.
		TogglePlayerControllable(playerid, true);

		gPlayerData[playerid][E_PLAYER_DATA_AFK] = 0;
	}

	return 1;
}

dcmd_ulozit(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ulozit [castka]");

	new amount = strval(params);

	if (amount > GetPlayerMoney(playerid))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	gPlayerData[playerid][E_PLAYER_DATA_BANK] += amount;
	GivePlayerMoney(playerid, -amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Ulozil jsi castku: $%d! Zustatek na uctu: $%d!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_vybrat(playerid, params[])
{
	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /vybrat [castka]");

	new amount = strval(params);

	if (amount > gPlayerData[playerid][E_PLAYER_DATA_BANK])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	gPlayerData[playerid][E_PLAYER_DATA_BANK] -= amount;
	GivePlayerMoney(playerid, amount);

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Vybral jsi castku: $%d! Zustatek na uctu: $%d!", amount, gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_stav(playerid, params[])
{
#pragma unused params
	if (!IsPlayerInSphere(playerid, 1519.4808, 1053.7301, 10.8203, 15) &&
			!IsPlayerInSphere(playerid, 1481.1512, 2158.1211, 11.0234, 15) &&
			!IsPlayerInSphere(playerid, 2074.4917, 2295.2041, 10.8203, 15))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v dosahu bankomatu!");
		return 1;
	}

	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Bezny zustatek na bankovnim uctu: $%d!", gPlayerData[playerid][E_PLAYER_DATA_BANK]);
	SendClientMessage(playerid, COLOR_ZLUTA, stringToPrint);

	return 1;
}

dcmd_ccmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	SendClientMessage(playerid, COLOR_ZELZLUT, "[ i ][CAM] KAMERY: /cam1 (pyramida dole), /cam2 (banka atd), /camoff");

	return 1;
}

dcmd_acmd(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	SendClientMessage(playerid, COLOR_ZELZLUT, "[ -- ADMIN CMD SET -- ]");
	SendClientMessage(playerid, COLOR_ZELZLUT, "[ /acmd /admincol /ban /cam /ccmd /elevator /fakechat /get /goto ]");
	SendClientMessage(playerid, COLOR_ZELZLUT, "[ /kick /lvl /nitro /reset /smazat /zbrane ");

	return 1;
}

dcmd_help(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_ZLUTA, "[ -- NAPOVEDA/POMOC -- ]");
	SendClientMessage(playerid, COLOR_ZLUTA, "[ Prikazy:  /cmd       ]");
	SendClientMessage(playerid, COLOR_ZLUTA, "[ Pravidla: /rules     ]");
	SendClientMessage(playerid, COLOR_ZLUTA, "[ Made by krusty & kompry ]");

	return 1;
}

dcmd_skydive(playerid, params[])
{
#pragma unused params
	// Give such user a parachute.
	GivePlayerWeapon(playerid, 46, 1);

	// Set their position high above the LV pyramide.
	SetPlayerPos(playerid, 2247.61, 1260.14, 1313.40);

	SendClientMessage(playerid, COLOR_CYAN, "[ i ] Skocil jsi z letadla! Uzij si skydive!");

	return 1;
}

dcmd_odpocet(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params) || !strval(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /odpocet [sekundy]");

	//new stringToPrint[256];

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~odpocet", strval(params) * 1000, 4);

	//format(stringToPrint, sizeof(stringToPrint), "~n~~n~~n~~n~~n~~n~%d", strval(params));
	//GameTextForPlayer(playerid, stringToPrint, 2000, 3);

	return 1;
}

dcmd_fakechat(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /fakechat [playerID] [text]");

	new targetId = strval(token1);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac se zadanym ID neni pritomen na serveru!.");

	SendPlayerMessageToAll(targetId, token2);

	SendClientMessage(playerid, COLOR_BILA, "[ i ] Falesna zprava byla uspesne odeslana!");

	return 1;
}

dcmd_ban(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /ban [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToBan = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[256];

	if (!IsPlayerConnected(playerIdToBan))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni na serveru!");

	// Get participated nicknames.
	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToBan, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s [ID: %d] zabanoval hrace %s [ID: %d] !!!", adminName, playerid, playerName, playerIdToBan);
	SendClientMessageToAll(COLOR_CYAN, stringToPrint);

	Ban(playerIdToBan);

	return 1;
}

dcmd_admins(playerid, params[])
#pragma unused params
{
	SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Administratori online:");

	new adminCount;

	for (new i = 0; i < GetMaxPlayers(); i++) 
	{
		// IsPlayerAdmin(i) == RCON admin
		if (IsPlayerConnected(i) && (gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] > 0 || IsPlayerAdmin(i)))
		{
			adminCount++;

			new adminName[MAX_PLAYER_NAME], stringToPrint[128];

			// Omit RCON admin(s) in the output for now...
			if (gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] > 0) 
			{
				GetPlayerName(i, adminName, sizeof(adminName));
				format(stringToPrint, sizeof(stringToPrint), "[ %s [ID: %2d] LVL: %d]", adminName, i, gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL]);
				SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);
			}
		}
	}

	if (!adminCount) 
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Zadny admin neni pritomen na serveru!");
		return 0;
	}

	return 1;
}

dcmd_kick(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /kick [ID]");

	new adminName[MAX_PLAYER_NAME], playerIdToKick = strval(params), playerName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!IsPlayerConnected(playerIdToKick)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(playerIdToKick, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s vyhodil(a) hrace %s ze serveru !!! ", adminName, playerName);

	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	Kick(playerIdToKick);

	return 1;
}

dcmd_lvl(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /lvl [playerID] [adminLvl]");

	new targetId = strval(token1), targetLvl = strval(token2);

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] <= gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nemuzes menit level adminum stejneho nebo vyssiho levelu nez mas sam!");

	if (targetId == playerid) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nemuzes menit level sam sobe!");

	if (targetLvl < 0 || targetLvl > 4)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Rozsah levelu je pouze 0-4!");

	if (targetLvl == gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL])
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Dany hrac jiz vlastni dany admin level!");

	new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));
	GetPlayerName(targetId, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s nastavil hraci %s [ ID: %d ] Admin-Level %d!", adminName, playerName, targetId, targetLvl);

	gPlayerData[targetId][E_PLAYER_DATA_ADMIN_LVL] = targetLvl;
	SavePlayerData(targetId);

	SendClientMessageToAll(COLOR_SEDA, stringToPrint);

	return 1;
}

dcmd_goto(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /goto [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Neni mozne teleportovat se k sobe samemu!");

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

dcmd_get(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /get [ID]!");

	new targetId = strval(params), Float:x, Float:y, Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Neni mozne teleportovat sebe sama!");

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

dcmd_givecash(playerid, params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || count != 2 || !IsNumeric(token1) || !IsNumeric(token2))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti /givecash [playerID] [castka]");

	new targetId = strval(token1), targetAmount = strval(token2);

	if (targetId == playerid)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Takovy financni prevod je bezpredmetny!");

	if (targetAmount > GetPlayerMoney(playerid) || targetAmount < 0)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Neplatna castka!");

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128], targetName[MAX_PLAYER_NAME];

	// Fetch players' names.
	GetPlayerName(playerid, playerName, sizeof(playerName));
	GetPlayerName(targetId, targetName, sizeof(targetName));

	// Send an informative statement to the receiving player.
	format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s [ID: %d] ti poslal castku %d €!", playerName, playerid, targetAmount);
	SendClientMessage(targetId, COLOR_SVZEL, stringToPrint);

	// Transfer money.
	GivePlayerMoney(targetId, targetAmount);
	GivePlayerMoney(playerid, -targetAmount);

	// Send an informative statement to the sending player.
	format(stringToPrint, sizeof(stringToPrint), "[ i ] Castka %s € uspesne zaslana hraci %s [ID: %d]!");
	SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);

	return 1;
}

dcmd_nitro(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /nitro [ID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	new targetPlayerState = GetPlayerState(targetId), targetVehicleId = GetPlayerVehicleID(targetId);

	if (!IsPlayerInVehicle(targetId))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac se nenachazi ve vozidle!");

	if (targetPlayerState != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Hrac je sice v aute, ale neni ridicem!");

	if (!IsPlayerInValidNosVehicle(targetId, targetVehicleId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Do auta hrace nejde nainstalovat nitro !");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, adminName, sizeof(adminName));

	// Add the NoS component to such vehicleId.
	AddVehicleComponent(targetVehicleId, 1010);

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s ti do auta nainstaloval nitro!", adminName);

	SendClientMessage(playerid, COLOR_SEDA, "[ i ] Nitro nainstalováno do auta hrace s danym ID!");
	SendClientMessage(targetId, COLOR_SVZEL, stringToPrint);

	return 1;
}

dcmd_admincol(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouzití: /admincol [1-5]");

	new adminColToSet = strval(params);

	switch (adminColToSet)
	{
		case 1:
			{
				SetPlayerColor(playerid, COLOR_SVZEL);
				SendClientMessage(playerid, COLOR_SVZEL, "[ ! ] Barva nicku nastavena na svetle zelenou!");
			}
		case 2:
			{
				SetPlayerColor(playerid, MODRA);
				SendClientMessage(playerid, MODRA, "[ i ] Barva nicku nastavena na modrou!");
			}
		case 3:
			{
				SetPlayerColor(playerid, COLOR_CERVENA);
				SendClientMessage(playerid, COLOR_CERVENA, "[ i ] Barva nicku nastavena na cervenou!");
			}
		case 4:
			{
				SetPlayerColor(playerid, COLOR_ORANZOVA);
				SendClientMessage(playerid, COLOR_ORANZOVA, "[ i ] Barva nicku nastavena na oranzovou!");
			}
		case 5:
			{
				SetPlayerColor(playerid, COLOR_BILA);
				SendClientMessage(playerid, COLOR_BILA, "[ i ] Barva nicku nastavena na bilou!");
			}
		default:
			{
				return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Barvy pouze 1-5!");
			}
	}

	return 1;
}

dcmd_ucet(playerid, params[])
{
#pragma unused params
	new lineToPrint1[256], lineToPrint2[256], lineToPrint3[265];

	format(lineToPrint1, sizeof(lineToPrint1), "[ INFO ] [ VYPIS HERNIHO UCTU ] ***");
	format(lineToPrint2, sizeof(lineToPrint2), "[ INFO ] [ Penize | $%d ], [ Banka | $%d ], [ Wanted level | %d ], [ Skin | %d ], [ Tym | %d ]", GetPlayerMoney(playerid), gPlayerData[playerid][E_PLAYER_DATA_BANK], GetPlayerWantedLevel(playerid), GetPlayerSkin(playerid), gPlayerData[playerid][E_PLAYER_DATA_TEAM]);
	format(lineToPrint3, sizeof(lineToPrint3), "[ INFO ] [ Admin level | %d ], [ Joint | %d ks ], [ Zapik | %d ks ], [ Marihuana | %d g ], [ Tabak | %d ks ]", gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL], gPlayerDrugz[playerid][E_PLAYER_DRUGZ_JOINT], gPlayerDrugz[playerid][E_PLAYER_DRUGZ_LIGHTER], gPlayerDrugz[playerid][E_PLAYER_DRUGZ_ZAZA], gPlayerDrugz[playerid][E_PLAYER_DRUGZ_TOBACCO]);

	SendClientMessage(playerid, COLOR_ZLUTA, lineToPrint1);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint2);
	SendClientMessage(playerid, COLOR_SEDA, lineToPrint3);

	return 1;
}

dcmd_flip(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /flip [ID]!");

	new targetId = strval(params), Float:z;

	if (!IsPlayerConnected(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	if (!IsPlayerInAnyVehicle(targetId)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID se nenachazi v aute!");

	if (GetPlayerState(targetId) != PLAYER_STATE_DRIVER) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID se sice nachazi v aute, ale neni ridicem!");

	// Flip player's vehicle.
	GetVehicleZAngle(GetPlayerVehicleID(targetId), z);
	SetVehicleZAngle(GetPlayerVehicleID(targetId), z);

	return 1;
}

dcmd_race(playerid, params[])
{
	new token1[32], token2[32];
	new count = SplitIntoTwo(params, token1, token2, sizeof(token1));

	if (!strlen(params) || (strcmp(token1, "join") && strcmp(token1, "exit") && strcmp(token1, "list")) || (!strcmp(token1, "join") && !IsNumeric(token2)))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /race [join/exit/list] [ID zavodu]");

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
		SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Seznam dostupnych zavodu:");

		for (new i = 1; i < sizeof(gRaceNames); i++)
		{
			new stringToPrint[128];

			format(stringToPrint, sizeof(stringToPrint), "ID: %2d: %s", i, gRaceNames[i]);
			SendClientMessage(playerid, COLOR_SEDA, stringToPrint);
		}
	}

	return 1;
}

dcmd_dance(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nelze byt v aute pro zapnuti animace!");
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
				SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /dance [1-4]");
			}
	}

	return 1;
}

dcmd_cam(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 2) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	switch (strval(params))
	{
		case 1:
			{
				SetPlayerCameraPos(playerid, 2219.87, 1266.13, 12.53);
				SetPlayerCameraLookAt(playerid, 2219.89, 1266.13, 12.53);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 1 zap. [/ccmd][/camoff]");
			}
		case 2:
			{
				SetPlayerCameraPos(playerid, 2035.62, 1303.53, 10.41);
				SetPlayerCameraLookAt(playerid, 2056.07, 1318.53, 10.41);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 2 zap. [/ccmd][/camoff]");
			}
		case 3: 
			{
				SetPlayerCameraPos(playerid, 2254.22, 1207.01, 10.38);
				SetPlayerCameraLookAt(playerid, 2254.22, 1207.01, 10.38);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera 3 zap. [/ccmd][/camoff]");
			}
		default:
			{
				SetCameraBehindPlayer(playerid);

				SendClientMessage(playerid, MODRA, "[CAM] Kamera vypnuta [/ccmd]");
			}
	}

	return 1;
}

dcmd_lay(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nelze byt v aute pro zapnuti animace!");
		return 1;
	}

	ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 0, 1, 1, 1, 1);

	return 1;
}

dcmd_cmd(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_SVZEL, "[ -- ZAKLADNI CMD SET -- ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /admins /afk /cmd /dance /djoin /dwarp /fix /givecash ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /help /hide /lay /locate /lock /login /paintball /register ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /rules /skydive /soska /stav /text /ucet /ulozit /unlock ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ /vybrat /wanted ]");

	return 1;
}

dcmd_elevator(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new adminName[MAX_PLAYER_NAME], stringToPrint[128];

	if (!strcmp(params, "up"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 80.285, 3.0, 0.0, 0.0, 142.812);
		GetPlayerName(playerid, adminName, sizeof(adminName));

		format(stringToPrint, sizeof(stringToPrint), "[ AV ] Admin %s rozjel vytah nahoru!", adminName);
		SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	}
	else if (!strcmp(params, "stop"))
	{
		StopObject(gAdminElevator);

		format(stringToPrint, sizeof(stringToPrint), "[ ! ] Vytah se zasekl! Kontaktujte technika!");
		SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	}
	else if (!strcmp(params, "down"))
	{
		MoveObject(gAdminElevator, 2303.207, 1174.944, 11.260, 3.0, 0.0, 0.0, 0.0);
		GetPlayerName(playerid, adminName, sizeof(adminName));

		format(stringToPrint, sizeof(stringToPrint), "[ AV ] Admin %s poslal vytah dolu", adminName);
		SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);
	}
	else
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /elevator [up/down/stop]");
	}

	return 1;
}

dcmd_paintball(playerid, params[])
{
	if (!strcmp(params, "join"))
	{
		SendClientMessageToAll(COLOR_ZLUTA, "[ ! ] Paintball zacne za 45 sekund! Pripojte se pomoci /paintball join");
		SetPlayerPos(playerid, -1365.1, -2307.0, 39.1);

		SetTimer("StartPaintball", 45000, 0);

		gPaintball[playerid][E_PAINTBALL_INGAME] = 1;
	}
	else if (!strcmp(params, "exit"))
	{
		new playerName[MAX_PLAYER_NAME], stringToPrint[128];

		GetPlayerName(playerid, playerName, sizeof(playerName));

		if (gPaintball[playerid][E_PAINTBALL_INGAME])
		{
			format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s opousti paintball (/paintball exit)!", playerName);
			SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

			SetPlayerHealth(playerid, 0.0);
			gPaintball[playerid][E_PAINTBALL_INGAME] = 0;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /paintball [join/exit]");
	}

	return 1;
}

dcmd_zbrane(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 3)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params)) 
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /zbrane [playerID]!");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		//return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");
		targetId = playerid;

	GivePlayerWeapon(targetId, 26, 400);
	GivePlayerWeapon(targetId, 28, 400);
	GivePlayerWeapon(targetId, 31, 400);
	GivePlayerWeapon(targetId, 43, 1);
	GivePlayerWeapon(targetId, 46, 1);

	return 1;
}

dcmd_reset(playerid, params[])
{
#pragma unused params
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 4)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	new stringToPrint[128];

	format(stringToPrint, sizeof(stringToPrint), "[ ! ][ SERVER ] Za 60 sekund dojde k automatickemu restartu serveru!");
	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

	SetTimer("StartServerReset", 60000, true);

	return 1;
}

dcmd_locate(playerid, params[])
{
#pragma unused params
	new stringToPrint[256], interiorNo = GetPlayerInterior(playerid), Float:X, Float:Y, Float:Z, Float:Angle;

	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Nachazite se se v interieru No. %d na souradnicich: X[%.2f], Y[%.2f], Z[%.2f], Rotace[%.2f].", interiorNo, X, Y, Z, Angle);
	SendClientMessage(playerid, COLOR_SVZEL, stringToPrint);

	return 1;
}

dcmd_wanted(playerid, params[]) 
{
#pragma unused params
	if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_POLICE && !IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Tuhle pravomoc maji pouze clenove tymu Policajtu!");

	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (GetPlayerWantedLevel(i) == 0)
			continue;

		GetPlayerName(i, playerName, sizeof(playerName));

		format(stringToPrint, sizeof(stringToPrint), "%s [ID: %d] --- WANTED level %d", playerName, i, GetPlayerWantedLevel(i));
		SendClientMessage(playerid, COLOR_BILA, stringToPrint);
	}

	return 1;
}

dcmd_hp(playerid, params[])
{
	if (!IsPlayerAdmin(playerid) && gPlayerData[playerid][E_PLAYER_DATA_ADMIN_LVL] < 1) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nedostatecny Admin level!");

	if (!strlen(params) || !IsNumeric(params))
		return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Pouziti: /hp [playerID]");

	new targetId = strval(params);

	if (!IsPlayerConnected(targetId))
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Hrac s danym ID neni pritomen na serveru!");

	SetPlayerHealth(targetId, 100.0);
	SetPlayerArmour(targetId, 100.0);

	SendClientMessage(targetId, COLOR_SEDA, "[ ! ] Zdravi: 100.0, Vesta: 100.0");

	return 1;
}

dcmd_port(playerid, params[])
{
#pragma unused params
	if (IsPlayerInAnyVehicle(playerid))
	{
		RemovePlayerFromVehicle(playerid);
	}

	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Portl ses do LV nad schodiste.");

	return 1;
}

dcmd_hide(playerid, params[]) 
{
#pragma unused params
	if (gPlayerData[playerid][E_PLAYER_DATA_TEAM] != E_PLAYER_TEAM_ADMINZ)
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Tento prikaz je urcen pouze pro tym Admin-borcu!");

	if (!gPlayerData[playerid][E_PLAYER_DATA_HIDE])
	{
		SetPlayerColor(playerid, COLOR_NEVIDITEL);
		SendClientMessage(playerid, COLOR_SVZEL, "[ HIDE ] Nyni jsi na herni mape neviditelny!");
	} else {
		SetPlayerColor(playerid, COLOR_SVZEL);
		SendClientMessage(playerid, COLOR_SVZEL, "[ HIDE ] Nyni jsi na opet viditelny na herni mape!");
	}

	gPlayerData[playerid][E_PLAYER_DATA_HIDE] = !gPlayerData[playerid][E_PLAYER_DATA_HIDE];

	return 1;
}

dcmd_rules(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ -- PRAVIDLA SERVER/MODU -- ]");
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ JE ZAKAZANY CARKILL,HELKILL, BIKEKILL, JETPACK, CHEATY ! ]");
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ NA HRACE KTERI BUDOU IGNOROVAT TYTO PRAVIDLA CEKA /KICK POZDEJI /BAN ! ]");
	SendClientMessage(playerid, COLOR_ORANZCERV, "[ V MODU JE ZABUDOVAN ANTI-JETPACK I ANTI-CHEAT !]");

	return 1;
}

dcmd_kill(playerid, params[])
{
#pragma unused params
	new playerName[MAX_PLAYER_NAME], stringToPrint[256];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	format(stringToPrint, sizeof(stringToPrint), "[ i ] Hrace %s uz to nebavilo a spachal sebevrazdu (/kill)!", playerName);
	SendClientMessageToAll(COLOR_HNEDA, stringToPrint);

	SetPlayerHealth(playerid, 0);

	return 1;
}

dcmd_fix(playerid, params[])
{
#pragma unused params
	//if(GetPlayerVehicleID(playerid) == gAdminAuto && !IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_CERVENA, "Nelze opravit");

	if (!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_CERVENA, "[ ! ] Nejsi v aute!");

	SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Opravil sis auto!");
	SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);

	//RepairVehicle(GetPlayerVedicleID(playerid));
	return 1;
}


dcmd_dwarp(playerid, params[])
{
#pragma unused params
	new playerState = GetPlayerState(playerid), senderName[MAX_PLAYER_NAME], stringToPrint[256], vehicleId = GetPlayerVehicleID(playerid);

	SetPlayerInterior(playerid, 0);
	GetPlayerName(playerid, senderName, sizeof(senderName));

	format(stringToPrint, sizeof(stringToPrint), "[ ! ] Hrac %s hodil warp na drag [ /dwarp ]", senderName);
	SendClientMessageToAll(COLOR_ZLUTA, stringToPrint);

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

dcmd_soska(playerid, params[])
{
#pragma unused params
	SendClientMessage(playerid, COLOR_SVZEL, "[ ------------ SOSKY ------------ ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ Sosky se nachazeji v LS a okoli ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ Sosek je zatim celkem 5         ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[                                 ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ ----------- ODMENA ------------ ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ $10 000 000 na ruku             ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ Prihlednuti k ziskani admin-lvl ]");
	SendClientMessage(playerid, COLOR_SVZEL, "[ TAK HLEDEJTE! :) :D             ]");

	return 1;
}

