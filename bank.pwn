new Float: gBankLocation[][4] = 
{
	// LV
	{1519.4808, 1053.7301, 10.8203, 15.0},
	{1481.1512, 2158.1211, 11.0234, 15.0},
	{2074.4917, 2295.2041, 10.8203, 15.0},

	// SF
	{-1553.97, 1061.80, 6.81, 15.0},
	{-1940.25, 511.79, 34.79, 15.0},
	{-1972.70, -851.47, 31.79, 15.0},

	// LS
	{824.43, -1353.66, 13.10, 15.0},
	{1380.42, -1088.84, 26.94, 15.0},
	{2748.44, -1466.40, 30.01, 15.0},

	// Bayside near SF
	{-2477.54, 2323.47, 4.81, 15.0},

	// Fort Carson Desert
	{-178.05, 1110.06, 19.57, 15.0},

	// Las Payasadas Desert
	{-229.02, 2709.20, 62.54, 15.0},

	// El Quebrados Desert 
	{-1509.22, 2593.82, 55.40, 15.0},

	// Montgomery
	{1307.16, 307.68, 19.55, 15.0},

	// Dillymore
	{648.01, -521.63, 15.90, 15.0},

	// Angel Pine
	//...

	// Palomino Creek
	{2302.73, -20.05, 26.25, 15.0}
};

public CheckPlayerBankLocation(playerid)
{
	for (new i = 0; i < sizeof(gBankLocation); i++)
	{
		if (IsPlayerInSphere(playerid, gBankLocation[i][0], gBankLocation[i][1], gBankLocation[i][2], _: gBankLocation[i][3]))
		{
			return true;
		}
	}

	return false;
}
