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
	LocationJobPickup[Coords]
}

new gTrucking[MAX_PLAYERS];
new gTruckingPoints[MAX_TRUCKING_POINTS][TruckingkPoint];

// Those are used for the trucking editor
new gTruckingEdit[MAX_PLAYERS][TruckingkPoint];
new gTruckingVehicles[MAX_PLAYERS][MAX_VEHICLES_PER_FACILITY][TruckingVehicle];
new gTruckingVehiclesIndex = 0;

//
//
//

stock CheckTruckingCheckpoint(playerid)
{
	if (!gTrucking[playerid])
		return 0;

	DisablePlayerRaceCheckpoint(playerid);

	SetPlayerTruckingMission(playerid);

	return 1;
}

stock SetPlayerTruckingMission(playerid)
{
	new Float: x0, Float: y0, Float: z0, pointId = GetRandomDestination();

	x0 = gTruckingPoints[pointId][LocationCheckpoint][CoordX];
	y0 = gTruckingPoints[pointId][LocationCheckpoint][CoordY];
	z0 = gTruckingPoints[pointId][LocationCheckpoint][CoordZ];

	SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, Float:x0, Float:y0, Float:z0, Float:x0, Float:y0, Float:z0, 10.0);

	return 1;
}

stock GetRandomDestination()
{
	new pointIndex = 0;

	for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	{
		if (gTruckingPoints[i][Type])
			pointIndex++;
	}

	return random(pointIndex);
}

stock InitTrucking()
{
	new i = 0, query[512];

	format(query, sizeof(query), "SELECT type, x, y, z, rot FROM trucking_coords"); 

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot read trucking coords data");
		print(query);

		return 0;
	}

	do
	{
		new type = DB_GetFieldIntByName(result, "type");

		new
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
					EnsurePickupCreated(1239, 1, X, Y, Z);
				}
			case CT_JOB_PICKUP:
				{}
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
	new query[512], DBResult: result, truckPointIndex = gTruckingEdit[playerid][ID];

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
		new type;

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

	new pointId = gTruckingEdit[playerid][ID];

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

