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

#pragma unused gTrucking
new gTrucking[MAX_TRUCKING_POINTS];

// Those are used for the trucking editor
new gTruckingEdit[MAX_PLAYERS][TruckingkPoint];
new gTruckingVehicles[MAX_PLAYERS][MAX_VEHICLES_PER_FACILITY][TruckingVehicle];
new gTruckingVehiclesIndex = 0;

//
//
//

// To be implemented
stock GetRandomDestination();

stock InitTrucking()
{
	new query[512];

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
				{}
			case CT_INFO_PICKUP:
				{}
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
		format(query, sizeof(query), "INSERT INTO trucking_points (id, name, type) VALUES (%s, '%s', %d) ON CONFLICT(id) DO UPDATE SET name = excluded.name, type = excluded.type", 
				pointId,
				gTruckingEdit[playerid][Name],
				FT_GAS_STATION
				//gTruckingEdit[playerid][Type]
		      );
	}
	else
	{
		format(query, sizeof(query), "INSERT INTO trucking_points (name, type) VALUES ('%s', %d) ON CONFLICT(id) DO UPDATE SET name = excluded.name, type = excluded.type", 
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

