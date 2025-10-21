#if defined _CRL2_HELPERS
	#endinput
#endif
#define _CRL2_HELPERS

#define RC_BANDIT   	441
#define RC_BARON    	464
#define RC_GOBLIN  	501
#define RC_RAIDER  	465
#define D_TRAM     	449
#define RC_TANK    	564
#define RC_CAM      	594

enum Coords
{
	Float: CoordX,
       	Float: CoordY,
       	Float: CoordZ,
       	Float: CoordR
}

new const GAMEMODE_CREDITS[] = "krusty, kompry, DRaGsTeR, amdulka";

forward AutosaveData();
forward StartServerReset();

public AutosaveData()
{
	BatchSavePlayerData();
	SaveRealEstateData();
}

public StartServerReset()
{
	SendRconCommand("gmx");
	return 1;
}

//
//
//

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

stock SystemMsg(playerid, const msg[])
{
	if (IsPlayerConnected(playerid) && strlen(msg) > 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, msg);
	}

	return 1;
}

stock IsNumeric(const input[])
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
	return SendClientMessageLocalized(playerid, I18N_NO_SUCH_COMMAND);
}

stock IsPlayerInSphere(playerid, Float:x, Float:y, Float:z, Float:radius)
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

stock bool: IsPlayerInValidNosVehicle(playerid, vehicleid)
{
#define MAX_INVALID_NOS_VEHICLES 31

	new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
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
	for (new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
	{
		if (GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
			return false;
	}

	return true;
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

stock EnsurePickupCreated(model, type, Float:X, Float:Y, Float:Z)
{
	new i = 0, MAX_ITERATIONS = 50, pId;

	for (;;)
	{
		pId = CreatePickup(model, type, Float:X, Float:Y, Float:Z);

		if (pId)
			break;

		if (i == MAX_ITERATIONS)
			break;

		i++;
	}

	return pId;
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

stock SplitIntoTwo(const input[], token1[], token2[], tokenSize, const delimiter[2] = " ")
{
	new spacePos = strfind(input, delimiter);
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

stock PrintAsciiLogoToLogs()
{
	printf(" *************************************************************************************   ");
	printf(" *");
	printf(" *       ______                       ____                  __    _ ____    ___          ");
	printf(" *      / ____/________ _____  __  __/ __ \\____ _________  / /   (_) __/__ |__ \\       ");
	printf(" *     / /   / ___/ __ `/_  / / / / / /_/ / __ `/ ___/ _ \\/ /   / / /_/ _ \\__/ /       ");
	printf(" *    / /___/ /  / /_/ / / /_/ /_/ / _, _/ /_/ / /__/  __/ /___/ / __/  __/ __/          ");
	printf(" *    \\____/_/   \\__,_/ /___/\\__, /_/ |_|\\__,_/\\___/\\___/_____/_/_/  \\___/____/   ");
	printf(" *                          /____/                                                       ");
	printf(" ");
	printf(" * GameMode CRL2 ");
	printf(" * Credits: %s ", GAMEMODE_CREDITS);
	printf(" * 2025 ");
	printf(" ");
	printf(" *************************************************************************************   ");
}

// GPT-generated
stock UnixToDateTime(timestamp, &year, &month, &day, &hour, &minute, &second)
{
	new days, secs;

	secs = timestamp % 86400;
	days = timestamp / 86400;

	hour = secs / 3600;
	secs %= 3600;
	minute = secs / 60;
	second = secs % 60;

	year = 1970;
	for (;;)
	{
		new leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		new year_days = leap ? 366 : 365;
		if (days >= year_days)
		{
			days -= year_days;
			year++;
		}
		else break;
	}

	// Days in each month
	new month_days[12] = {
		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	};

	// Adjust February for leap year
	new is_leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
	if (is_leap) 
		month_days[1] = 29; 
	else 
		month_days[1] = 28;

	month = 1;
	for (new i = 0; i < 12; i++)
	{
		if (days >= month_days[i])
		{
			days -= month_days[i];
			month++;
		}
		else break;
	}

	day = days + 1;
}

