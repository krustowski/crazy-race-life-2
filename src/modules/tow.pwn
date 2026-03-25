#if defined _CRL2_TOW
	#endinput
#endif
#define _CRL2_TOW

//
//  tow.pwn
//

#define TYPE_MISSION_TOW	6

#define VEHICLE_ID_TOW_TRUCK	525

#define MAX_VEHICLE_COUNT	211

#define DOCK_SF_X		-1588.42
#define DOCK_SF_Y		109.28
#define DOCK_SF_Z		3.42

enum TowMission
{
	bool: Active,
	TruckID,
	TowedID,

	ModelCount,
	DoneCount,
	TimeElapsed,
	Earned,
	Float: CommissionBonusWeight,

	TimerElapsed,
	TimerAttachedCheck,

	bool: Models[MAX_VEHICLE_COUNT],

	bool: CheckpointDisabled
}

new gTowMission[MAX_PLAYERS][TowMission];
new Text: gTowMissionText[MAX_PLAYERS];

forward UpdateTowMissionText(playerid);
forward CheckPlayerTowTrailerAttached(playerid);

public UpdateTowMissionText(playerid)
{
	new stringToPrint[256];

	gTowMission[playerid][TimeElapsed] += 1000;

	format(stringToPrint, sizeof(stringToPrint), gI18nMessages[I18N_TOW_MISS_INFO][ gPlayers[playerid][Locale] ], 
			gTowMission[playerid][ModelCount], 
			gTowMission[playerid][DoneCount], 
			gTowMission[playerid][Earned], 
			floatround(floatround(gTowMission[playerid][TimeElapsed] / 1000) / 60), 
			floatround(gTowMission[playerid][TimeElapsed] / 1000) % 60
		);

	TextDrawSetString(gTowMissionText[playerid], stringToPrint);
	TextDrawShowForPlayer(playerid, gTowMissionText[playerid]);

	return 1;
}

public CheckPlayerTowTrailerAttached(playerid)
{
	new 
		vehicleid = gTowMission[playerid][TruckID],
		trailerid = gTowMission[playerid][TowedID];

	if (IsTrailerAttachedToVehicle(vehicleid) && IsPlayerInVehicle(playerid, vehicleid))
	{
		SetVehicleParamsForPlayer(vehicleid, playerid, false, false);
		SetVehicleParamsForPlayer(trailerid, playerid, false, false);

		if (gTowMission[playerid][CheckpointDisabled])
		{
			SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, DOCK_SF_X, DOCK_SF_Y, DOCK_SF_Z, 0.0, 0.0, 0.0, 12.0);
			gTowMission[playerid][CheckpointDisabled] = false;
		}

		return 1;
	}

	DisablePlayerRaceCheckpoint(playerid);
	gTowMission[playerid][CheckpointDisabled] = true;

	if (!IsPlayerInVehicle(playerid, vehicleid))
	{
		// Mark the tower truck vehicle
		SetVehicleParamsForPlayer(vehicleid, playerid, true, false);

		GameTextForPlayer(playerid, "~w~Return to ~y~the truck ~w~to continue ~y~the tow mission!", 1000, 3); 
		return 1;
	}

	SetVehicleParamsForPlayer(vehicleid, playerid, false, false);

	//GameTextForPlayer(playerid, "~w~Trailer ~r~Detached! ~w~Reattach to continue!", 1000, 3); 

	return 1;
}

stock CheckVehicleModelTowed(playerid, modelid)
{
	if (modelid - 400 >= MAX_VEHICLE_COUNT)
	{
		return 0;
	}

	if (!gTowMission[playerid][Models][modelid - 400])
	{
		gTowMission[playerid][Models][modelid - 400] = true;
		gTowMission[playerid][ModelCount]++;
		return 1;
	}

	return 0;
}

stock AbortTowMission(playerid)
{
	if (!gTowMission[playerid][Active])
	{
		return 1;
	}

	SaveTowMissionScore(playerid);

	gPlayers[playerid][InMinigame] = false;

	gTowMission[playerid][TruckID] = INVALID_VEHICLE_ID;
	gTowMission[playerid][Active] = false;
	gTowMission[playerid][Earned] = 0;
	gTowMission[playerid][TimeElapsed] = 0;
	gTowMission[playerid][DoneCount] = 0;
	gTowMission[playerid][ModelCount] = 0;
	gTowMission[playerid][CheckpointDisabled] = true;

	for (new i = 0; i < MAX_VEHICLE_COUNT; i++)
	{
		gTowMission[playerid][Models][i] = false;
	}

	KillTimer(gTowMission[playerid][TimerElapsed]);
	KillTimer(gTowMission[playerid][TimerAttachedCheck]);

	DisablePlayerRaceCheckpoint(playerid);
	TextDrawHideForPlayer(playerid, gTowMissionText[playerid]);

	SetVehicleParamsForPlayer(gTowMission[playerid][TruckID], playerid, false, false);
	SetVehicleParamsForPlayer(gTowMission[playerid][TowedID], playerid, false, false);

	return GameTextForPlayer(playerid, "~w~Tow Mission ~r~Aborted", 3000, 3); 
}

stock ToggleTowMission(playerid)
{
	if (gTowMission[playerid][Active])
	{
		return AbortTowMission(playerid);
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TOW ] Another minigame started, close it to start the towing mission!");
	}
	
	if (!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(GetPlayerVehicleID(playerid)) != VEHICLE_ID_TOW_TRUCK)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ TOW ] You must be driving the Tow Truck!");
	}

	gPlayers[playerid][InMinigame] = true;

	gTowMission[playerid][TruckID] = GetPlayerVehicleID(playerid);
	gTowMission[playerid][Active] = true;
	gTowMission[playerid][Earned] = 0;
	gTowMission[playerid][TimeElapsed] = 0;
	gTowMission[playerid][DoneCount] = 0;
	gTowMission[playerid][ModelCount] = 0;
	gTowMission[playerid][CheckpointDisabled] = true;

	for (new i = 0; i < MAX_VEHICLE_COUNT; i++)
	{
		gTowMission[playerid][Models][i] = false;
	}

	gTowMission[playerid][TimerElapsed] = SetTimerEx("UpdateTowMissionText", 1000, true, "i", playerid);
	gTowMission[playerid][TimerAttachedCheck] = SetTimerEx("CheckPlayerTowTrailerAttached", 1500, true, "i", playerid);

	GameTextForPlayer(playerid, "~w~Tow Mission ~g~Started", 3000, 3); 

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
		DetachTrailerFromVehicle(gTowMission[playerid][TruckID]);
		gTowMission[playerid][TowedID] = INVALID_VEHICLE_ID;

		return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] Trailer detached successfully!");
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

		if (IsPlayerInSphere(playerid, vX, vY, vZ, 9.0) && velocity[0] == 0.0 && velocity[1] == 0.0)
		{
			AttachTrailerToVehicle(i, gTowMission[playerid][TruckID]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] New trailer attached successfully!");

			gTowMission[playerid][TowedID] = i;
			gTowMission[playerid][CheckpointDisabled] = false;

			new Float: X, Float: Y, Float: Z;
			GetPlayerPos(playerid, X, Y, Z);

			gTowMission[playerid][CommissionBonusWeight] = (floatabs(X - Float: DOCK_SF_X) / 3000 + floatabs(Y - Float: DOCK_SF_Y) / 3000) / 2;

			SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, DOCK_SF_X, DOCK_SF_Y, DOCK_SF_Z, 0.0, 0.0, 0.0, 12.0);

			break;
		}
	}

	return 1;
}

stock CheckTowMissionCheckpoint(playerid)
{
	if (!gTowMission[playerid][Active])
	{
		return 0;
	}

	DisablePlayerRaceCheckpoint(playerid);

	if (!IsTrailerAttachedToVehicle(gTowMission[playerid][TruckID]))
	{
		return 0;
	}

	new commission = 0, stringToPrint[128];

	if (CheckVehicleModelTowed(playerid, GetVehicleModel(gTowMission[playerid][TowedID])))
	{
		commission += 2500;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TOW ] New vehicle model towed! A bonus to commission of $2500!");
	}

	DetachTrailerFromVehicle(gTowMission[playerid][TruckID]);
	SetVehicleToRespawn(gTowMission[playerid][TowedID]);
	gTowMission[playerid][TowedID] = INVALID_VEHICLE_ID;

	commission += 5000 + (floatround(gTowMission[playerid][CommissionBonusWeight] * (random(++gTowMission[playerid][DoneCount])) * 5000));

	GivePlayerMoney(playerid, commission);
	gTowMission[playerid][Earned] += commission;
	gTowMission[playerid][TimeElapsed] = 0;
	//gTowMission[playerid][DoneCount] += 1;

	format(stringToPrint, sizeof(stringToPrint), "[ TOW ] Mission completed! Commision earned: $%d", commission);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	return 1;
}

stock SaveTowMissionScore(playerid)
{
	if (!gTowMission[playerid][DoneCount])
	{
		return 1;
	}

	new query[256];

	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id) VALUES (%d, '%d', %d, %d)",
			TYPE_MISSION_TOW,
			gTowMission[playerid][ModelCount],
			gTowMission[playerid][DoneCount],
			gPlayers[playerid][OrmID]
	      );

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write tow high scores data!");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}
