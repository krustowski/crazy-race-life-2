//
//  taxi.pwn
//  Taxi-related module
//

enum TaxiMission
{
	NPCid,
	bool: Active,

	TaxiCheckTimer
}

new gTaxiMission[MAX_PLAYERS][TaxiMission];

new gTaxiEnterTimer[MAX_PLAYERS];

forward EnterVehicleTimer(npcid);
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

	KillTimer(gTaxiEnterTimer[npcid]);

	NPC_EnterVehicle(npcid, vehicleid, 3, NPC_MOVE_TYPE: 1);

	return 1;
}

forward CheckTaxiNearNPC(playerid);
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
		KillTimer(gTaxiMission[playerid][TaxiCheckTimer]);

		SendClientMessage(playerid, COLOR_GREY, "[ TAXI ] Telling NPC to enter the vehicle...");
		SetPVarInt(gTaxiMission[playerid][NPCid], "VehicleToEnter", vehicleid);
	}

	return 1;
}

stock SetPlayerTaxiMission(playerid)
{
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

	gTaxiMission[playerid][Active] = true;
	gTaxiMission[playerid][NPCid] = npcid;
	gTaxiMission[playerid][TaxiCheckTimer] = SetTimerEx("CheckTaxiNearNPC", 1500, true, "i", playerid);

	return 1;
}

stock AbortPlayerTaxiMission(playerid)
{
	if (!gTaxiMission[playerid][Active])
	{
		return 1;
	}

	gTaxiMission[playerid][Active] = false;
	gTaxiMission[playerid][NPCid] = -1;
	KillTimer(gTaxiMission[playerid][TaxiCheckTimer]);

	return 1;
}
