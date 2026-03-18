#if defined _CRL2_TOW
	#endinput
#endif
#define _CRL2_TOW

//
//  tow.pwn
//

#define VEHICLE_ID_TOW_TRUCK	525

enum TowMission
{
	bool: Active,
	TruckID
}

new gTowMission[MAX_PLAYERS][TowMission];

stock ToggleTowMission(playerid)
{
	if (gTowMission[playerid][Active])
	{
		gTowMission[playerid][TruckID] = INVALID_VEHICLE_ID;
		gTowMission[playerid][Active] = false;
		SendClientMessage(playerid, COLOR_YELLOW, "[ TOW ] Tow mission aborted!");

		return 1;
	}

	
	if (!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(GetPlayerVehicleID(playerid)) != VEHICLE_ID_TOW_TRUCK)
	{
		SendClientMessage(playerid, COLOR_RED, "[ TOW ] You must be driving the Tow Truck!");
		return 1;
	}

	gTowMission[playerid][TruckID] = GetPlayerVehicleID(playerid);
	gTowMission[playerid][Active] = true;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] Tow mission started!");

	return 1;
}

stock OperateTowTruck(playerid)
{
	if (!gTowMission[playerid][Active] || !gTowMission[playerid][TruckID] || gTowMission[playerid][TruckID] == INVALID_VEHICLE_ID)
	{
		SendClientMessage(playerid, COLOR_RED, "[ TOW ] Invalid car!");
		return 0;
	}

	if (IsTrailerAttachedToVehicle(gTowMission[playerid][TruckID]))
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] Trailer detached successfully!");
		return DetachTrailerFromVehicle(gTowMission[playerid][TruckID]);
	}

	new Float: vX, Float: vY, Float: vZ, Float: velocity[3];
	GetVehicleVelocity(gTowMission[playerid][TruckID], velocity[0], velocity[1], velocity[2]);

	if (velocity[0] != 0.0 && velocity[1] != 0.0)
	{
		return 1;
	}

	for (new i = 0; i < MAX_VEHICLES; i++)
	{
		if (i == gTowMission[playerid][TruckID])
		{
			continue;
		}

		GetVehiclePos(i, vX, vY, vZ);

		if (IsPlayerInSphere(playerid, vX, vY, vZ, 7.0) && velocity[0] == 0.0 && velocity[1] == 0.0)
		{
			AttachTrailerToVehicle(i, gTowMission[playerid][TruckID]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] New trailer attached successfully!");

			break;
		}
	}

	return 1;
}
