#if defined _CRL2_BANK
	#endinput
#endif
#define _CRL2_BANK

//
//  bank.pwn
//

#define MAX_ATM_PICKUPS 19

new 
	gBankPickups[MAX_ATM_PICKUPS],
	Float: gBankLocation[MAX_ATM_PICKUPS][4];

stock InitBankLocations()
{
	new 
		query[128];

	format(query, sizeof(query), "SELECT id, x, y, z FROM atm_coords");

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) 
	{
		print("Database error: cannot list ATM coords!");
		print(query);

		return 0;
	}

	new 
		i = 0;

	if (!DB_GetRowCount(result))
	{
		print("Database warning: no ATM coords to load");
		DB_FreeResultSet(result);
		return 0;
	}

	do
	{
		gBankLocation[i][0] = DB_GetFieldFloatByName(result, "x");
		gBankLocation[i][1] = DB_GetFieldFloatByName(result, "y");
		gBankLocation[i][2] = DB_GetFieldFloatByName(result, "z");
		gBankLocation[i][3] = 15.0;

		i++;

		if (i == MAX_ATM_PICKUPS)
		{
			printf("Database warning: too much ATM items (i = %d), stopping", i);
			break;
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("ATM location coords initialized!");

	return 1;
}

stock CheckPlayerBankLocation(playerid)
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

