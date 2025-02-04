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
	{2748.44, -1466.40, 30.01, 15},

	// Bayside near SF
	{-2477.54, 2323.47, 4.81, 15},

	// Fort Carson Desert
	{-178.05, 1110.06, 19.57, 15},

	// Las Payasadas Desert
	{-229.02, 2709.20, 62.54, 15},

	// El Quebrados Desert 
	{-1509.22, 2593.82, 55.40, 15},

	// Montgomery
	{1307.16, 307.68, 19.55, 15},

	// Dillymore
	{648.01, -521.63, 15.90, 15}
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
