#if defined _CRL2_TRUCKING
	#endinput
#endif
#define _CRL2_TRUCKING

//
//  trucking.pwn
//

#define MAX_TRUCKING_POINTS		128
#define MAX_VEHICLES_PER_FACILITY	10

// Coordinate type
enum 
{
	CT_STUB,
	CT_CHECKPOINT,
	CT_INFO_PICKUP,
	CT_JOB_PICKUP,
	CT_TRUCK_CAB,
	CT_TRAIL_FREIGHT,
	CT_TRAIL_GAS
}

// Facility type
enum
{
	FT_STUB,
	FT_FREIGHT,
	FT_GAS_STATION
}

enum TruckingEditorType
{
	TREDIT_NONE,
	TREDIT_CHECKPOINT,
	TREDIT_INFO_PICKUP,
	TREDIT_TRUCK,
	TREDIT_GAS,
	TREDIT_FREIGHT
}

// Mission types
enum MissionType
{
	MT_NONE,
	MT_FREIGHT,
	MT_PETROL
}

enum VehicleType
{
	Truck,
	Freight,
	Gas
}

enum TruckingVehicle
{
	ID,
	Location[Coords],

	VehicleType: Type[VehicleType]
}

enum TruckingkPoint
{
	ID,
	Name[64],
	Type,
	LocationCheckpoint[Coords],
	LocationInfoPickup[Coords],
	LocationJobPickup[Coords],
	InfoPickup,

	TruckingEditorType: EditType
}

enum MissionStats
{
	VehicleID,
	TrailerID,
	MissionType: Type,

	Float: CommissionBonusWeight,
	DoneCount,
	TimeElapsed,
	Earned,

	Checkpoint[Coords],
	bool: CheckpointDisabled,

	TimerElapsed,
	TimerAttachedCheck
}

new 
	gPlayerMissions[MAX_PLAYERS][MissionStats],
	Text: gMissionInfoText[MAX_PLAYERS],
	gTrucking[MAX_PLAYERS],
	gTruckingPoints[MAX_TRUCKING_POINTS][TruckingkPoint];

// Those are used for the trucking editor
new 
	gTruckingEdit[MAX_PLAYERS][TruckingkPoint],
	gTruckingVehicles[MAX_PLAYERS][MAX_VEHICLES_PER_FACILITY][TruckingVehicle],
	gTruckingVehiclesIndex = 0;

//
//
//

forward UpdateMissionInfoText(playerid);
forward CheckPlayerTrailerAttached(playerid);

public UpdateMissionInfoText(playerid)
{
	new 
		stringToPrint[256];

	gPlayerMissions[playerid][TimeElapsed] += 1000;

	GetLocalizedString(playerid, I18N_TRUCK_MISS_INFO_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint,
			gPlayerMissions[playerid][DoneCount], 
			gPlayerMissions[playerid][Earned], 
			floatround(floatround(gPlayerMissions[playerid][TimeElapsed] / 1000) / 60), 
			floatround(gPlayerMissions[playerid][TimeElapsed] / 1000) % 60
		);

	TextDrawSetString(gMissionInfoText[playerid], stringToPrint);
	TextDrawShowForPlayer(playerid, gMissionInfoText[playerid]);

	return 1;
}

stock CheckTruckingCheckpoint(playerid)
{
	if (!gTrucking[playerid])
	{
		return 0;
	}

	DisablePlayerRaceCheckpoint(playerid);

	new 
		commission, 
		stringToPrint[128];

	if (!gPlayerMissions[playerid][DoneCount])
	{
		commission = 10000 + (floatround(gPlayerMissions[playerid][CommissionBonusWeight] * 1 * 5000));
	}
	else
	{
		commission = 10000 + (floatround(gPlayerMissions[playerid][CommissionBonusWeight] * (random(gPlayerMissions[playerid][DoneCount]) + 1) * 5000));
	}

	GivePlayerMoney(playerid, commission);
	gPlayerMissions[playerid][Earned] += commission;
	gPlayerMissions[playerid][TimeElapsed] = 0;
	gPlayerMissions[playerid][DoneCount] += 1;

	GetLocalizedString(playerid, I18N_TRUCK_MISS_COMMISSION_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, commission);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	if (!SetPlayerTruckingMission(playerid, gPlayerMissions[playerid][Type]))
	{
		SendClientMessageLocalized(playerid, I18N_TRUCK_NEW_MISS_ERROR);
		return 0;
	}

	return 1;
}

public CheckPlayerTrailerAttached(playerid)
{
	new 
		trailerid = gPlayerMissions[playerid][TrailerID],
		vehicleid = gPlayerMissions[playerid][VehicleID];

	if (IsTrailerAttachedToVehicle(vehicleid) && IsPlayerInVehicle(playerid, vehicleid))
	{
		SetVehicleParamsForPlayer(vehicleid, playerid, false, false);
		SetVehicleParamsForPlayer(trailerid, playerid, false, false);

		if (gPlayerMissions[playerid][CheckpointDisabled] && gPlayerMissions[playerid][Checkpoint][CoordX] != 0.0 && gPlayerMissions[playerid][Checkpoint][CoordY] != 0.0)
		{
			SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, gPlayerMissions[playerid][Checkpoint][CoordX], gPlayerMissions[playerid][Checkpoint][CoordY], gPlayerMissions[playerid][Checkpoint][CoordZ], 0.0, 0.0, 0.0, 12.0);
			gPlayerMissions[playerid][CheckpointDisabled] = false;
		}

		return 1;
	}

	DisablePlayerRaceCheckpoint(playerid);
	gPlayerMissions[playerid][CheckpointDisabled] = true;

	new
		gameText[64];

	if (!IsPlayerInVehicle(playerid, vehicleid))
	{
		SetVehicleParamsForPlayer(vehicleid, playerid, true, false);

		GetLocalizedString(playerid, I18N_TRUCK_RETURN_TO_TRUCK_FMT, gameText, sizeof(gameText));
		GameTextForPlayer(playerid, gameText, 1000, 3); 
		return 1;
	}

	SetVehicleParamsForPlayer(trailerid, playerid, true, false);

	GetLocalizedString(playerid, I18N_TRUCK_TRAILER_DETACHED_FMT, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 1000, 3); 
	return 1;
}

//
//
//

stock SetPlayerTruckingMission(playerid, MissionType: missionType)
{
	const 
		MAX_ITERATIONS = 50;

	new 
		query[256];
	format(query, sizeof(query), "select p.name, c.x, c.y, c.z from trucking_points as p join trucking_coords as c on c.trucking_id = p.id where c.type = 1 and p.type = %d order by random() limit 1", _: missionType);

	new 
		Float: x0, 
		Float: y0, 
		Float: z0, 
		name[64];

	for (new i = 0; i < MAX_ITERATIONS; i++)
	{
		new 
			DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result)
		{
			print("Database error: cannot fetch random trucking point!");
			print(query);
			return 0;
		}

		if (!DB_GetRowCount(result))
		{
			print("Database warning: no rows for given query!");
			print(query);
			DB_FreeResultSet(result);
			return 0;
		}

		x0 = DB_GetFieldFloatByName(result, "x");
		y0 = DB_GetFieldFloatByName(result, "y");
		z0 = DB_GetFieldFloatByName(result, "z");
		DB_GetFieldStringByName(result, "name", name, sizeof(name));

		DB_FreeResultSet(result);

		// Prevent generating the same checkpoint twice for current position
		if (!IsPlayerInSphere(playerid, x0, y0, z0, 50.0))
		{
			break;
		}
	}

	new 
		Float: X, 
		Float: Y, 
		Float: Z;

	GetPlayerPos(playerid, X, Y, Z);

	gPlayerMissions[playerid][Checkpoint][CoordX] = x0;
	gPlayerMissions[playerid][Checkpoint][CoordY] = y0;
	gPlayerMissions[playerid][Checkpoint][CoordZ] = z0;

	gPlayerMissions[playerid][CommissionBonusWeight] = (floatabs(X - x0) / 3000 + floatabs(Y - y0) / 3000) / 2;

	new 
		gameText[128];

	GetLocalizedString(playerid, I18N_TRUCK_NEXT_DESTINATION_FMT, gameText, sizeof(gameText));
	format(gameText, sizeof(gameText), gameText, name);

	GameTextForPlayer(playerid, gameText, 4000, 3); 
	SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, x0, y0, z0, x0, y0, z0, 12.0);

	return 1;
}

stock GetRandomDestination()
{
	new 
		pointIndex = 0;

	for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	{
		if (gTruckingPoints[i][Type])
		{
			pointIndex++;
		}
	}

	return random(pointIndex);
}

stock InitTrucking()
{
	new 
		i = 0, 
		query[512];

	format(query, sizeof(query), "SELECT id, name, type FROM trucking_points"); 

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot read trucking points data");
		print(query);

		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		print("Database warning: no trucking points to load");

		DB_FreeResultSet(result);
		return 0;
	}

	do 
	{
		new 
			id = DB_GetFieldIntByName(result, "id"),
			type = DB_GetFieldIntByName(result, "type"),
			name[64];

		if (!id)
		{
			continue;
		}

		DB_GetFieldStringByName(result, "name", name, sizeof(name));

		gTruckingPoints[id][Name] = name;
		gTruckingPoints[id][ID] = id;
		gTruckingPoints[id][Type] = type;
	}
	while (DB_SelectNextRow(result));

	//

	format(query, sizeof(query), "SELECT type, x, y, z, rot, trucking_id FROM trucking_coords"); 

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot read trucking coords data");
		print(query);

		return 0;
	}

	do
	{
		new 
			type = DB_GetFieldIntByName(result, "type"),
			Float: X = DB_GetFieldFloatByName(result, "x"),
			Float: Y = DB_GetFieldFloatByName(result, "y"),
			Float: Z = DB_GetFieldFloatByName(result, "z"),
			Float: R = DB_GetFieldFloatByName(result, "rot");

		switch (type)
		{
			case CT_CHECKPOINT:
				{
					gTruckingPoints[i][LocationCheckpoint][CoordX] = X;
					gTruckingPoints[i][LocationCheckpoint][CoordY] = Y;
					gTruckingPoints[i][LocationCheckpoint][CoordZ] = Z;
					gTruckingPoints[i][Type] = type;
					i++;
				}
			case CT_INFO_PICKUP:
				{
					gTruckingPoints[i][InfoPickup] = EnsurePickupCreated(1239, 1, X, Y, Z);

					new 
						trucking_id = DB_GetFieldIntByName(result, "trucking_id");

					Create3DTextLabel("%s", COLOR_ORANGE, X, Y, Z, 15.0, -1, false, gTruckingPoints[trucking_id][Name]);
				}
			case CT_JOB_PICKUP:
				{
					//
				}
			case CT_TRUCK_CAB:
				{
					CreateVehicle(515, X, Y, Z, R, 0, 0, -1);
					//CreateVehicle(403, X, Y, Z, R, 0, 0, -1);
				}
			case CT_TRAIL_FREIGHT:
				{
					CreateVehicle(450, X, Y, Z, R, 0, 0, -1);
				}
			case CT_TRAIL_GAS:
				{
					CreateVehicle(584, X, Y, Z, R, 0, 0, -1);
				}
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("Trucking initialized!");

	return 1;
}

stock SetTruckingPoint(playerid)
{
	new 
		query[512], 
		DBResult: result, 
		truckPointIndex = gTruckingEdit[playerid][ID];

	if (!truckPointIndex)
	{
		format(query, sizeof(query), "SELECT id FROM trucking_points ORDER BY id DESC LIMIT 1");

		result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			printf("Database error: cannot write trucking point data");
			print(query);

			return 0;
		}

		truckPointIndex = DB_GetFieldIntByName(result, "id") + 1;

		DB_FreeResultSet(result);
	}

	// TODO: Make a batch query insead of sending multiple queries in loop
	for (new i = 0; i < gTruckingVehiclesIndex; i++)
	{
		new 
			type;

		switch (gTruckingVehicles[playerid][i][Type])
		{
			case Truck:
				{
					type = CT_TRUCK_CAB;
				}
			case Freight:
				{
					type = CT_TRAIL_FREIGHT;
				}
			case Gas:
				{
					type = CT_TRAIL_GAS;
				}
		}

		format(query, sizeof(query), "INSERT INTO trucking_coords (type, x, y, z, rot, trucking_id) VALUES (%d, %.2f, %.2f, %.2f, %.2f, %d)",
				type,
				gTruckingVehicles[playerid][i][Location][CoordX],
				gTruckingVehicles[playerid][i][Location][CoordY],
				gTruckingVehicles[playerid][i][Location][CoordZ],
				gTruckingVehicles[playerid][i][Location][CoordR],
				truckPointIndex
		      );

		result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			printf("Database error: cannot write trucking coords data for vehicles");
			print(query);

			return 0;
		}

		DB_FreeResultSet(result);
	}

	gTruckingVehiclesIndex = 0;

	//
	//  Trucking point
	//

	if (gTruckingEdit[playerid][LocationCheckpoint][CoordX] == 0.0 && gTruckingEdit[playerid][LocationCheckpoint][CoordY] == 0.0 && gTruckingEdit[playerid][LocationCheckpoint][CoordZ] == 0.0)
	{
		return 1;
	}

	new 
		pointId = gTruckingEdit[playerid][ID];

	if (pointId)
	{
		format(query, sizeof(query), "UPDATE trucking_points SET name = '%s', type = %d WHERE id = %d", 
				gTruckingEdit[playerid][Name],
				FT_GAS_STATION,
				pointId
		      );
	}
	else
	{
		format(query, sizeof(query), "INSERT INTO trucking_points (name, type) VALUES ('%s', %d)", 
				gTruckingEdit[playerid][Name],
				FT_GAS_STATION
				//gTruckingEdit[playerid][Type]
		      );
	}

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot write trucking point data");
		print(query);

		return 0;
	}

	DB_FreeResultSet(result);

	//
	//  Checkpoint
	//

	format(query, sizeof(query), "INSERT INTO trucking_coords (type, x, y, z, rot, trucking_id) VALUES (%d, %.2f, %.2f, %.2f, %.2f, %d)",
			CT_CHECKPOINT,
			gTruckingEdit[playerid][LocationCheckpoint][CoordX],
			gTruckingEdit[playerid][LocationCheckpoint][CoordY],
			gTruckingEdit[playerid][LocationCheckpoint][CoordZ],
			0.0,
			truckPointIndex
	      );

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot write trucking coords for checkpoint");
		print(query);

		return 0;
	}

	DB_FreeResultSet(result);

	//
	//  Info pickup
	//

	if (gTruckingEdit[playerid][LocationInfoPickup][CoordX] == 0.0 && gTruckingEdit[playerid][LocationInfoPickup][CoordY] == 0.0 && gTruckingEdit[playerid][LocationInfoPickup][CoordZ] == 0.0)
	{
		return 1;
	}

	format(query, sizeof(query), "INSERT INTO trucking_coords (type, x, y, z, rot, trucking_id) VALUES (%d, %.2f, %.2f, %.2f, %.2f, %d)",
			CT_INFO_PICKUP,
			gTruckingEdit[playerid][LocationInfoPickup][CoordX],
			gTruckingEdit[playerid][LocationInfoPickup][CoordY],
			gTruckingEdit[playerid][LocationInfoPickup][CoordZ],
			0.0,
			truckPointIndex
	      );

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot write trucking coords for info pickup");
		print(query);

		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

stock SaveTruckingMissionScore(playerid)
{
	if (!gPlayerMissions[playerid][DoneCount])
	{
		return 1;
	}

	new 
		query[256];

	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id) VALUES (%d, '%d', %d, %d)",
			4,
			1,
			gPlayerMissions[playerid][DoneCount],
			gPlayers[playerid][OrmID]
	      );

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data!");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

stock AbortTruckingMission(playerid)
{
	if (!gTrucking[playerid])
	{
		return 1;
	}

	gPlayers[playerid][InMinigame] = false;

	gTrucking[playerid] = false;
	DisablePlayerRaceCheckpoint(playerid);
	TextDrawHideForPlayer(playerid, gMissionInfoText[playerid]);

	KillTimer(_: gPlayerMissions[playerid][TimerElapsed]);
	KillTimer(_: gPlayerMissions[playerid][TimerAttachedCheck]);

	SetVehicleParamsForPlayer(gPlayerMissions[playerid][VehicleID], playerid, false, false);
	SetVehicleParamsForPlayer(gPlayerMissions[playerid][TrailerID], playerid, false, false);

	SaveTruckingMissionScore(playerid);

	new
		gameText[32];

	GetLocalizedString(playerid, I18N_TRUCK_MISS_ABORT_FMT, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 3000, 3); 

	return SendClientMessageLocalized(playerid, I18N_TRUCK_MISS_ABORT);
}

stock IsPlayerInTruck(playerid)
{
	if (!IsPlayerInAnyVehicle(playerid))
	{
		return 0;
	}

        new 
		vehicleId = GetPlayerVehicleID(playerid), 
		truckModels[3] = {403, 514, 515}, 
		bool:isTruck = false;

        for (new i = 0; i < sizeof(truckModels); i++)
        {
                if (GetVehicleModel(vehicleId) == truckModels[i])
                {
                        isTruck = true;
                        break;
                }
        }

	if (isTruck)
	{
		return 1;
	}

	return 0;
}

stock CheckPlayerForTruckingMission(playerid)
{
	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_TRUCK_IN_MINIGAME_BLOCK);
	}

        if (!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        {
                return SendClientMessageLocalized(playerid, I18N_TRUCK_NOT_DRIVER);
        }

        new 
		vehicleId = GetPlayerVehicleID(playerid);

	if (!IsPlayerInTruck(playerid))
	{
                return SendClientMessageLocalized(playerid, I18N_TRUCK_NOT_DRIVER);
	}

        if (!IsTrailerAttachedToVehicle(vehicleId))
	{
                return SendClientMessageLocalized(playerid, I18N_TRUCK_NO_TRAILER);
	}

        new 
		trailerId = GetVehicleTrailer(vehicleId), 
		MissionType: truckingMissionType;

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
                                return SendClientMessageLocalized(playerid, I18N_TRUCK_UNKNOWN_TRAILER_MODEL);
                        }
        }

        if (!gTrucking[playerid])
        {
                if (!SetPlayerTruckingMission(playerid, truckingMissionType))
                {
                        return SendClientMessageLocalized(playerid, I18N_TRUCK_NEW_MISS_ERROR);
                }

		gPlayers[playerid][InMinigame] = true;

                gTrucking[playerid] = true;

                gPlayerMissions[playerid][VehicleID] = GetPlayerVehicleID(playerid);
                gPlayerMissions[playerid][TrailerID] = trailerId;
                gPlayerMissions[playerid][Type] = truckingMissionType;
                gPlayerMissions[playerid][DoneCount] = 0;
                gPlayerMissions[playerid][Earned] = 0;
                gPlayerMissions[playerid][TimeElapsed] = 0;
                gPlayerMissions[playerid][TimerElapsed] = SetTimerEx("UpdateMissionInfoText", 1000, true, "i", playerid);
                gPlayerMissions[playerid][TimerAttachedCheck] = SetTimerEx("CheckPlayerTrailerAttached", 1500, true, "i", playerid);

		new
			gameText[32];

		GetLocalizedString(playerid, I18N_TRUCK_MISS_START_FMT, gameText, sizeof(gameText));
                GameTextForPlayer(playerid, gameText, 3000, 3); 

                SendClientMessageLocalized(playerid, I18N_TRUCK_VEHICLES_REGISTERED);
        }

        return 1;
}



