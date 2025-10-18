//
//  taxi.pwn
//  Taxi-related module
//

enum TaxiMission
{
	NPCid,
	bool: Active,

	Float: CommissionCoef,

	TimeElapsed,
	Earned,
	DoneCount,

	Text: InfoText,

	TimerNPCExit,
	TimerUpdate,
	TimerCheckNearNPC
}

new gTaxiMission[MAX_PLAYERS][TaxiMission];

new gTaxiEnterTimer[MAX_PLAYERS];

forward UpdateTaxiMissionInfoText(playerid);
forward CheckTaxiNearNPC(playerid);
forward EnterVehicleTimer(npcid);
forward ExitVehicleTimer(playerid);

// For NPC to enter vehicle.
public EnterVehicleTimer(npcid)
{
	new vehicleid = GetPVarInt(npcid, "VehicleToEnter");

	if (!vehicleid)
	{
		return 1;
	}

	if (GetVehicleModel(vehicleid) != 420 && GetVehicleModel(vehicleid) != 438)
	{
		return 1;
	}

	new driverid = GetVehicleDriver(vehicleid);

	if (!gTaxiMission[driverid][Active])
	{
		KillTimer(gTaxiEnterTimer[npcid]);
		NPC_Destroy(npcid);
		return 1;
	}

	KillTimer(gTaxiEnterTimer[npcid]);

	NPC_EnterVehicle(npcid, vehicleid, 3, NPC_MOVE_TYPE: 1);

	while (NPC_IsEnteringVehicle(npcid))
	{}

	if (!SetTaxiMissionCheckpoint(driverid))
	{
		return SendClientMessage(driverid, COLOR_RED, "[ TAXI ] Error setting new taxi mission!");
	}

	return 1;
}

public ExitVehicleTimer(playerid)
{
	//NPC_Spawn(npcid);
	SetTaxiMissionCustomerPos(playerid);

	return 1;
}

public CheckTaxiNearNPC(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid))
	{
		return 1;
	}

	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 420)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Not a taxi car");
	}

	new Float: pX, Float: pY, Float: pZ, Float: veolcity[3];

	GetPlayerPos(playerid, pX, pY, pZ);
	GetVehicleVelocity(vehicleid, veolcity[0], veolcity[1], veolcity[2]);

	if (IsPlayerInSphere(gTaxiMission[playerid][NPCid], pX, pY, pZ, 10.0) && veolcity[0] == 0.0 && veolcity[1] == 0.0)
	{
		KillTimer(gTaxiMission[playerid][TimerCheckNearNPC]);

		SendClientMessage(playerid, COLOR_YELLOW, "[ TAXI ] Telling NPC to enter the vehicle...");
		SetPVarInt(gTaxiMission[playerid][NPCid], "VehicleToEnter", vehicleid);

		gTaxiEnterTimer[gTaxiMission[playerid][NPCid]] = SetTimerEx("EnterVehicleTimer", 1000, true, "i", gTaxiMission[playerid][NPCid]);
	}

	return 1;
}

public UpdateTaxiMissionInfoText(playerid)
{
	new stringToPrint[256];

	gTaxiMission[playerid][TimeElapsed] += 1000;

	switch (gPlayers[playerid][Locale]) 
	{
		case LOCALE_CZ:
			//
			{}

		default:
			format(stringToPrint, sizeof(stringToPrint), "~w~Done:____~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:___~b~%2d~y~:~b~%2d", gTaxiMission[playerid][DoneCount], gTaxiMission[playerid][Earned], floatround(floatround(gTaxiMission[playerid][TimeElapsed] / 1000) / 60), floatround(gTaxiMission[playerid][TimeElapsed] / 1000) % 60);
	}

	TextDrawSetString(gTaxiMission[playerid][InfoText], stringToPrint);
	TextDrawShowForPlayer(playerid, gTaxiMission[playerid][InfoText]);

	return 1;
}


stock CheckTaxiMissionCheckpoint(playerid)
{
	if (!gTaxiMission[playerid][Active])
	{
		return 1;
	}

	DisablePlayerRaceCheckpoint(playerid);
	SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0, 0.0, 0.0);

	new commission = 8000 + (floatround(gTaxiMission[playerid][CommissionCoef] * (random(++gTaxiMission[playerid][DoneCount]) + 1) * 4000));
	GivePlayerMoney(playerid, commission);
	gTaxiMission[playerid][Earned] += commission;

	new stringToPrint[128];
	format(stringToPrint, sizeof(stringToPrint), "[ TAXI ] Commission earned: $%d", commission);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	NPC_ExitVehicle(gTaxiMission[playerid][NPCid]);
	gTaxiMission[playerid][TimerNPCExit] = SetTimerEx("ExitVehicleTimer", 2000, false, "i", playerid);

	//gTaxiMission[playerid][DoneCount]++;
	gTaxiMission[playerid][TimeElapsed] = 0;

	return 1;
}

stock SetTaxiMissionCheckpoint(playerid)
{
	new Float: X, Float: Y, Float: Z, query[128] = "SELECT primary_x, primary_y, primary_z FROM property_coords WHERE type = 8 ORDER BY random() LIMIT 1";

	for (;;)
	{
		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Database read error!");
			print("Database error: cannot get random row from property_coords!");
			print(query);
			return 0;
		}

		X = DB_GetFieldFloatByName(result, "primary_x");
		Y = DB_GetFieldFloatByName(result, "primary_y");
		Z = DB_GetFieldFloatByName(result, "primary_z");

		DB_FreeResultSet(result);

		if (IsPlayerInSphere(playerid, X, Y, Z, 75.0))
		{
			continue;
		}

		break;
	}

	new Float: pX, Float: pY, Float: pZ;
	GetPlayerPos(playerid, pX, pY, pZ);

	gTaxiMission[playerid][CommissionCoef] = (floatabs(pX - X) / 3000 + floatabs(pY - Y) / 3000) / 2;

	SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, X, Y, Z, X, Y, Z, 15.0);

	gTaxiMission[playerid][TimerCheckNearNPC] = SetTimerEx("CheckTaxiNearNPC", 2000, true, "i", playerid);

	return 1;
}

stock SetTaxiMissionCustomerPos(playerid)
{
	new Float: X, Float: Y, Float: Z, query[128] = "SELECT primary_x, primary_y, primary_z FROM property_coords WHERE type = 8 ORDER BY random() LIMIT 1";

	// Set iteration limit to 150, so the last is used if not anything closer appears...
	for (new i = 0; i < 150; i++)
	{
		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Database read error!");
			print("Database error: cannot get random row from property_coords!");
			print(query);
			return 0;
		}

		X = DB_GetFieldFloatByName(result, "primary_x");
		Y = DB_GetFieldFloatByName(result, "primary_y");
		Z = DB_GetFieldFloatByName(result, "primary_z");

		DB_FreeResultSet(result);

		if (!IsPlayerInSphere(playerid, X, Y, Z, 175.0))
		{
			continue;
		}

		break;
	}

	NPC_SetPos(gTaxiMission[playerid][NPCid], X, Y, Z);
	NPC_SetSkin(gTaxiMission[playerid][NPCid], random(311) + 1);
	SetPlayerMarkerForPlayer(playerid, gTaxiMission[playerid][NPCid], COLOR_YELLOW);

	return 1;
}

stock SetTaxiMissionCustomer(playerid)
{
	if (gTaxiMission[playerid][NPCid] > -1)
	{
		return SetTaxiMissionCustomerPos(playerid);
	}

	new npcs[10];
	NPC_GetAll(npcs, sizeof(npcs));

	new preid = -1;
	for (new i = 0; i < 10; i++)
	{
		if (!NPC_IsValid(i))
		{
			preid = i;
			break;
		}
	}

	if (preid == -1)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Too many customers in game, try again later!");
	}

	new npc_name[MAX_PLAYER_NAME];
	format(npc_name, sizeof(npc_name), "[NPC]taxi_customer%d", preid);

	new npcid = NPC_Create(npc_name);

	if (!npcid)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Too many customers in game, try again later!");
	}

	NPC_Spawn(npcid);

	gTaxiMission[playerid][NPCid] = npcid;

	return SetTaxiMissionCustomerPos(playerid);
}

stock SetPlayerTaxiMission(playerid)
{
	if (gTaxiMission[playerid][Active])
	{
		return AbortPlayerTaxiMission(playerid);
	}

	new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));

	if (modelid != 420 && modelid != 438)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TAXI ] Must be driving a taxi cab!");
	}

	gTaxiMission[playerid][NPCid] = -1;
	SetTaxiMissionCustomer(playerid);

	gTaxiMission[playerid][Active] = true;
	gTaxiMission[playerid][TimerCheckNearNPC] = SetTimerEx("CheckTaxiNearNPC", 1500, true, "i", playerid);
	gTaxiMission[playerid][TimerUpdate] = SetTimerEx("UpdateTaxiMissionInfoText", 1000, true, "i", playerid);

	gTaxiMission[playerid][InfoText] = TextDrawCreate(460.0, 400.0, "");
	TextDrawLetterSize(gTaxiMission[playerid][InfoText], 0.5, 1.5);
	TextDrawFont(gTaxiMission[playerid][InfoText], t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gTaxiMission[playerid][InfoText], 1);

	GameTextForPlayer(playerid, "~w~Taxi Mission ~g~Started!", 3000, 3); 

	return 1;
}

stock AbortPlayerTaxiMission(playerid)
{
	if (!gTaxiMission[playerid][Active])
	{
		return 1;
	}

	KillTimer(gTaxiMission[playerid][TimerCheckNearNPC]);
	KillTimer(gTaxiMission[playerid][TimerUpdate]);

	if (gTaxiMission[playerid][NPCid])
	{
		KillTimer(gTaxiEnterTimer[ gTaxiMission[playerid][NPCid] ]);
		NPC_Destroy(gTaxiMission[playerid][NPCid]);
	}

	gTaxiMission[playerid][Active] = false;
	gTaxiMission[playerid][NPCid] = -1;
	gTaxiMission[playerid][DoneCount] = 0;
	gTaxiMission[playerid][Earned] = 0;
	gTaxiMission[playerid][TimeElapsed] = 0;

	DisablePlayerRaceCheckpoint(playerid);
	TextDrawHideForPlayer(playerid, gTaxiMission[playerid][InfoText]);

	GameTextForPlayer(playerid, "~w~Taxi Mission ~r~Aborted", 3000, 3); 

	return 1;
}
