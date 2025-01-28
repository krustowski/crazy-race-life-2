new gBankLocation[][4] = 
{
	// LV
	{1519.4808, 1053.7301, 10.8203, 15},
	{1481.1512, 2158.1211, 11.0234, 15},
	{2074.4917, 2295.2041, 10.8203, 15},

	// SF
	{-1553.97, 1061.80, 6.81, 15},
	{-1940.25, 511.79, 34.79, 15},
	{-1972.70, -851.47, 31.79, 15},

	// LS
	{824.43, -1353.66, 13.10, 15},
	{1380.42, -1088.84, 26.94, 15},
	{2748.44, -1466.40, 30.01, 15}
};

public CheckPlayerBankLocation(playerid)
{
	for (new i = 0; i < sizeof(gBankLocation); i++)
	{
		if (IsPlayerInSphere(playerid, Float:gBankLocation[i][0], Float:gBankLocation[i][1], Float:gBankLocation[i][2], Float:gBankLocation[i][3]))
		{
			return true;
			break;
		}
	}

	return false;
}
