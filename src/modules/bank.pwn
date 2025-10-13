#define MAX_ATM_PICKUPS 20

new gBankPickups[MAX_ATM_PICKUPS];

new Float: gBankLocation[19][4];

stock InitBankLocations()
{
	new query[128];

	format(query, sizeof(query), "SELECT id, x, y, z FROM atm_coords");

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		printf("Database error: cannot list ATM coords!");
		print(query);

		return 0;
	}

	new i = 0;

	do
	{
		gBankLocation[i][0] = DB_GetFieldFloatByName(result, "x");
		gBankLocation[i][1] = DB_GetFieldFloatByName(result, "y");
		gBankLocation[i][2] = DB_GetFieldFloatByName(result, "z");
		gBankLocation[i][3] = 15.0;

		i++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	printf("ATM location coords initialized!");

	return 1;
}

forward CheckPlayerBankLocation(playerid);

public CheckPlayerBankLocation(playerid)
{
	for (new i = 0; i < sizeof(gBankLocation); i++)
	{
		if (IsPlayerInSphere(playerid, gBankLocation[i][0], gBankLocation[i][1], gBankLocation[i][2], gBankLocation[i][3]))
		{
			return 1;
		}
	}

	return 0;
}

