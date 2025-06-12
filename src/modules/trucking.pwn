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
	Location[Coords],
	Type[VehicleType]
}

enum TruckingkPoint
{
	ID,
	Name[64],
	Destination[Coords],
}

new gTrucking[MAX_TRUCKING_POINTS];

// Those are used for the trucking editor
new gTruckingEdit[MAX_PLAYERS][TruckingkPoint];
new gTruckingVehicles[MAX_PLAYERS][VehicleType];

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
		gPlayers[playerid][Properties][i] = DB_GetFieldIntByName(result, "id");

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);
}

stock GetRandomDestination();
