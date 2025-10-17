//
//  taxi.pwn
//  Taxi-related module
//

enum TaxiMission
{
	NPCid,
	bool: Active,

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
forward ExitVehicleTimer(npcid);

// For NPC to enter vehicle.
public EnterVehicleTimer(npcid)
{
	new vehicleid = GetPVarInt(npcid, "VehicleToEnter");

	if (!vehicleid)
	{
		return 1;
	}

	if (GetVehicleModel(vehicleid) != 420)
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

	new Float: dX, Float: dY, Float: dZ, Float: veolcity[3];

	GetPlayerPos(driverid, dX, dY, dZ);
	GetVehicleVelocity(vehicleid, veolcity[0], veolcity[1], veolcity[2]);

	if (IsPlayerInSphere(gTaxiMission[driverid][NPCid], dX, dY, dZ, 10.0) && veolcity[0] == 0.0 && veolcity[1] == 0.0)
	{
		KillTimer(gTaxiEnterTimer[npcid]);

		NPC_EnterVehicle(npcid, vehicleid, 3, NPC_MOVE_TYPE: 1);

		while (NPC_IsEnteringVehicle(npcid))
		{}

		if (!SetTaxiMissionCheckpoint(driverid))
		{
			return SendClientMessage(driverid, COLOR_RED, "[ TAXI ] Error setting new taxi mission!");
		}
	}

	return 1;
}

public ExitVehicleTimer(npcid)
{
	NPC_Spawn(npcid);

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
			format(stringToPrint, sizeof(stringToPrint), "~w~Done:___________~g~%d~n~~w~Earned:__~g~$~y~%d~n~~w~Time:______~b~%2d~y~:~b~%2d", gTaxiMission[playerid][DoneCount], gTaxiMission[playerid][Earned], floatround(floatround(gTaxiMission[playerid][TimeElapsed] / 1000) / 60), floatround(gTaxiMission[playerid][TimeElapsed] / 1000) % 60);
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

	NPC_ExitVehicle(gTaxiMission[playerid][NPCid]);

	gTaxiMission[playerid][TimerNPCExit] = SetTimerEx("ExitVehicleTimer", 3000, false, "i", gTaxiMission[playerid][NPCid]);

	gTaxiMission[playerid][DoneCount]++;
	gTaxiMission[playerid][TimeElapsed] = 0;

	SetTaxiMissionCustomer(playerid);
	gTaxiMission[playerid][TimerCheckNearNPC] = SetTimerEx("CheckTaxiNearNPC", 1500, true, "i", playerid);

	return 1;
}

stock SetTaxiMissionCheckpoint(playerid)
{
	new Float: X, Float: Y, Float: Z;

	// TODO: get random coordinate from database

	X = -2413.08;
	Y = 329.24;
	Z = 34.74;

	if (IsPlayerInSphere(playerid, X, Y, Z, 10.0))
	{
		return 0;
	}

	SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, X, Y, Z, X, Y, Z, 10.0);

	return 1;
}

stock SetTaxiMissionCustomer(playerid)
{
	if (gTaxiMission[playerid][NPCid])
	{
		return 1;
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

	return 1;
}

stock SetPlayerTaxiMission(playerid)
{
	if (gTaxiMission[playerid][Active])
	{
		return AbortPlayerTaxiMission(playerid);
	}

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

	TextDrawHideForPlayer(playerid, gTaxiMission[playerid][InfoText]);

	GameTextForPlayer(playerid, "~w~Taxi Mission ~r~Aborted", 3000, 3); 

	return 1;
}
