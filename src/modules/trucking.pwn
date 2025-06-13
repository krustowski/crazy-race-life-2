//
//  trucking.pwn
//

#define MAX_TRUCKING_POINTS		128
#define MAX_VEHICLES_PER_FACILITY	10

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
	LocationJobPickup[Coords]
}

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
	new query[256];

	format(query, sizeof(query), "SELECT id FROM trucking"); 

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot read trucking data");
		print(query);

		return 0;
	}

	new i = 0;

	do
	{
		gTrucking[i][ID] = DB_GetFieldIntByName(result, "id");

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);
}

stock SetTruckingPoint(playerid)
{
	new query[256];

	// TODO: Make a batch query insead of sending multiple queries in loop
	for (new i = 0; i < gTruckingVehiclesIndex; i++)
	{
		new type;

		switch (gTruckingVehicles[playerid][i][Type])
		{
			case Truck:
				{
					type = 4;
				}
			case Freight:
				{
					type = 5;
				}
			case Gas:
				{
					type = 6;
				}
		}

		format(query, sizeof(query), "INSERT INTO trucking_coords (type, x, y, z, rot) VALUES (%d, %.2f, %.2f, %.2f, %.2f) ON CONFLICT(id) DO UPDATE SET x = excluded.x, y = excluded.y, z = excluded.z, rot = excluded.rot",
				type,
				gTruckingVehicles[playerid][i][Location][CoordX],
				gTruckingVehicles[playerid][i][Location][CoordY],
				gTruckingVehicles[playerid][i][Location][CoordZ],
				gTruckingVehicles[playerid][i][Location][CoordR]
		      );

		new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			printf("Database error: cannot write trucking coords data");
			print(query);

			return 0;
		}

	  	DB_FreeResultSet(result);

		//
		// Trucking point 
		//

		new pointId[3];

		format(pointId, sizeof(pointId), "'%d'", gTruckingEdit[playerid][ID]);

		if (!strcmp(pointId, "'0'"))
		{
			// New item
			pointId = "''";
		}

		format(query, sizeof(query), "INSERT INTO trucking (id, name, coord_x, coord_y, coord_z, type) VALUES (%d, '%s', %.2f, %.2f, %.2f, %d) ON CONFLICT(id) DO UPDATE SET name = excluded.name, coord_x = excluded.coord_x, coord_y = excluded.coord_y, coord_z = excluded.coord_z, type = excluded.type", 
					pointId,
					gTruckingEdit[playerid][Name],
					gTruckingEdit[playerid][LocationCheckpoint][CoordX],
					gTruckingEdit[playerid][LocationCheckpoint][CoordY],
					gTruckingEdit[playerid][LocationCheckpoint][CoordZ],
					2
					//gTruckingEdit[playerid][Type]
		);

		result = DB_ExecuteQuery(gDbConnectionHandle, query);
		if (!result) 
		{
			printf("Database error: cannot write trucking point data");
			print(query);

			return 0;
		}

	  	DB_FreeResultSet(result);
	}

	return 1;
}
