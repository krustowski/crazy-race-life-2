//
//  trucking.pwn
//

#define MAX_TRUCKING_POINTS	128

enum TruckType
{
	Goods,
	Gas
}

enum TruckPoint
{
	ID,
	Name[64],
	Type[TruckType],
	Destination[Coords]
}

new gTrucking[MAX_TRUCKING_POINTS];

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
