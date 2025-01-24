#define RC_BANDIT   	441
#define RC_BARON    	464
#define RC_GOBLIN  	501
#define RC_RAIDER  	465
#define D_TRAM     	449
#define RC_TANK    	564
#define RC_CAM      	594

stock chrfind(n, h[], s = 0)
{
	new l = strlen(h);
	while (s < l)
	{
		if (h[s] == n) return s;
		s++;
	}
	return -1;
}

stock BanAll()
{
	for (new i; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			Ban(i);
		}
	}
}

stock KickAll()
{
	for (new i; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			Kick(i);
		}
	}
}

stock SystemMsg(playerid, msg[])
{
	if (IsPlayerConnected(playerid) && strlen(msg) > 0)
	{
		SendClientMessage(playerid, COLOR_SVZEL, msg);
	}

	return 1;
}

stock IsNumeric(input[])
{
	for (new i = 0, j = strlen(input); i < j; i++) 
	{
		if (input[i] > '9' || input[i] < '0') 
			return 0;
	}

	return 1;
}

stock SendMessageToAdmins(colorId, const messageString[])
{
	for (new i = 0; i <= MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || gPlayerData[i][E_PLAYER_DATA_ADMIN_LVL] >= 3))
		{
			SendClientMessage(i, colorId, messageString);
		}
	}

	return 1;
}

stock InvalidCommand(playerid)
{
	SendClientMessage(playerid, COLOR_SEDA, "[ ! ] Tento prikaz neexistuje! /cmd /help /rules");

	return 1;
}

stock IsPlayerInSphere(playerid, Float:x, Float:y, Float:z, radius)
{
	if (GetPlayerDistanceToPointEx(playerid, x, y, z) < radius)
	{
		return 1;
	}
	return 0;
}

stock GetPlayerDistanceToPointEx(playerid, Float:x, Float:y, Float:z)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid, x1, y1, z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x, x1)), 2) + floatpower(floatabs(floatsub(y, y1)), 2) + floatpower(floatabs(floatsub(z, z1)), 2));
	return floatround(tmpdis);
}

stock bool:IsPlayerInValidNosVehicle(playerid, vehicleid)
{
#define MAX_VALID_NOS_VEHICLES 31

	new ValidNosVehicles[MAX_VALID_NOS_VEHICLES] =
	{
		581, 523, 462, 521, 463, 522, 461, 448, 468, 586,
		509, 481, 510, 472, 473, 493, 595, 484, 430, 453,
		452, 446, 454, 590, 569, 537, 538, 570, 449, 522, 520
	};

	new vehicleIdCheck = GetPlayerVehicleID(playerid);

	// Return when the target player changed vehicles meanwhile, or has exited the target vehicle.
	if (vehicleid != vehicleIdCheck || !IsPlayerInVehicle(playerid, vehicleid))
		return false;

	// Loop over permitted NoS vehicles.
	for (new i = 0; i < MAX_VALID_NOS_VEHICLES; i++)
	{
		if (GetVehicleModel(vehicleid) == ValidNosVehicles[i])
			return true;
	}

	return false;
}

stock GetVehicleWithinDistance(playerid, Float:x1, Float:y1, Float:z1, Float:dist, &veh)
{
	for (new i = 1; i < MAX_VEHICLES; i++)
	{
		if (GetVehicleModel(i) > 0)
		{
			if (GetPlayerVehicleID(playerid) != i)
			{
				new Float:x, Float:y, Float:z;
				new Float:x2, Float:y2, Float:z2;
				GetVehiclePos(i, x, y, z);
				x2 = x1 - x;
				y2 = y1 - y;
				z2 = z1 - z;
				new Float:vDist = (x2 * x2 + y2 * y2 + z2 * z2);
				if (vDist < dist)
				{
					veh = i;
					dist = vDist;
				}
			}
		}
	}
}

stock IsVehicleRcTram(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	switch (model)
	{
		case D_TRAM, RC_GOBLIN, RC_BARON, RC_BANDIT, RC_RAIDER, RC_TANK:
			return 1;
		default:
			return 0;
	}
	return 0;
}

public SplitIntoTwo(input[], token1[], token2[], tokenSize)
{
	new spacePos = strfind(input, " ");
	if (spacePos == -1)
	{
		strmid(token1, input, 0, strlen(input), tokenSize);
		token2[0] = '\0';
		return 1;
	}

	strmid(token1, input, 0, spacePos, tokenSize);

	strmid(token2, input, spacePos + 1, strlen(input), tokenSize);

	return 2;
}

stock TestPrint(print[])
{
#if BUG_SYSTEM
	printf(" BS | %s ", print);
#else
#pragma unused print
#endif
}

public StartServerReset()
{
	SendRconCommand("gmx");

	return 1;
}

