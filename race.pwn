#define MAX_RACE_NAME		64
#define MAX_RACE_CP		64
#define MAX_RACE_COORD		3

enum E_RACE_COORD
{
	Float: E_RACE_COORD_X,
	Float: E_RACE_COORD_Y,
	Float: E_RACE_COORD_Z
}

enum E_RACE_FEE
{
	E_RACE_FEE_FEE,
	E_RACE_FEE_PRIZE
}

enum E_RACE_ID
{
	E_RACE_ID_NONE,
	E_RACE_ID_LV_PYRAMID,
	E_RACE_ID_STUNT_LV_1,
	E_RACE_ID_CIRCUIT_SF_WANG,
	E_RACE_ID_SF_LS_AIRPORT,
	E_RACE_ID_LV_MAP_CIRCUIT,
	E_RACE_ID_DESERT_AIR_CIRCUIT
}

enum
{
	E_RACE_TYPE_GROUND,
	E_RACE_TYPE_AIR
}

// gPlayerRace hold a reference to the state of a player's registration to such race. Thus if registered, a value for such RACE_ID should return true (1).
new gPlayerRace[MAX_PLAYERS][E_RACE_ID];

new gPlayerRaceTime[MAX_PLAYERS];

new Timer:gPlayerRaceTimer[MAX_PLAYERS];

new Text:gRaceInfoText[MAX_PLAYERS];

//
//  Race props.
//

new Float: gRaceWarp[E_RACE_ID][E_RACE_COORD] = 
{
	// E_RACE_ID_NONE
	{0.0, 0.0, 0.0},
	// E_RACE_ID_LV_PYRAMID
	{2635.67, 1171.51, 10.37},
	// E_RACE_ID_STUNT_LV_1
	{2635.67, 1171.51, 10.37},
	// E_RACE_ID_CIRCUIT_SF_WANG
	{-2005.75, 320.07, 34.58},
	// SF to LS Airport race
	{-1386.19, -407.38, 14.14},
	// LV map circuit
	{2046.05, 1009.33, 10.24},
	// E_RACE_ID_DESERT_AIR_CIRCUIT
	{400.64, 2504.60, 16.48}
};

// gRaceNames is an array to hold all race names referenced via E_RACE_ID.
new const gRaceNames[E_RACE_ID][] = 
{
	// E_RACE_ID_NONE
	"Blank Race (stub)",
	// E_RACE_ID_LV_PYRAMID
	"Las Venturas Pyramid Race",
	// E_RACE_ID_STUNT_LV_1
	"Las Venturas Stunt Race No. 1",
	// E_RACE_ID_CIRCUIT_SF_WANG
	"San Fierro WangCars Circuit",
	// E_RACE_ID_SF_LS_AIRPORT
	"San Fierro to Los Santos Airport race",
	// E_RACE_ID_LV_MAP_CIRCUIT
	"Las Venturas to Whole Map Circuit",
	// E_RACE_ID_DESERT_AIR_CIRCUIT
	"Desert Air Circuit"
};

new const gRaceFeePrize[E_RACE_ID][E_RACE_FEE] =
{
	// E_RACE_ID_NONE
	{0, 0},
	// E_RACE_ID_LV_PYRAMID
	{300, 5000},
	// E_RACE_ID_STUNT_LV_1
	{1500, 25000},
	// E_RACE_ID_CIRCUIT_SF_WANG
	{1500, 20000},
	// E_RACE_ID_SF_LS_AIRPORT
	{2000, 35000},
	// E_RACE_ID_LV_MAP_CIRCUIT
	{3500, 45000},
	// E_RACE_ID_DESERT_AIR_CIRCUIT
	{4000, 65000}
};

new gRaceTypes[E_RACE_ID] = 
{
	// E_RACE_ID_NONE
 	E_RACE_TYPE_GROUND,
	// E_RACE_ID_LV_PYRAMID
	E_RACE_TYPE_GROUND,
	// E_RACE_ID_STUNT_LV_1
	E_RACE_TYPE_GROUND,
	// E_RACE_ID_CIRCUIT_SF_WANG
	E_RACE_TYPE_GROUND,
	// E_RACE_ID_SF_LS_AIRPORT
	E_RACE_TYPE_GROUND,
	// E_RACE_ID_LV_MAP_CIRCUIT
	E_RACE_TYPE_GROUND,
	// E_RACE_ID_DESERT_AIR_CIRCUIT
	E_RACE_TYPE_AIR
};

new Float: gRaceCoordsLVPyramid[][E_RACE_COORD] =
{
};

// E_RACE_ID_STUNT_LV_1
new Float: gRaceCoordsLVStuntNo1[][E_RACE_COORD] =
{
	{2605.1, 1193.9, 10.4},
	{2393.16, 1192.98, 10.50},
	{2002.7, 1209.4, 17.6},
	{1971.5, 1248.1, 17.6},
	{1874.3, 1247.6, 17.6},
	{1871.15, 1151.11, 10.38},
	{1869.7, 935.8, 10.2},
	{2106.8, 955.2, 15.3},
	{2079.5, 1031.7, 10.3},
	{2175.8, 1134.2, 12.2},
	{2158.6, 1274.4, 17.3}
};

// E_RACE_ID_CIRCUIT_SF_WANG
new Float: gRaceCoordsSFCircuitWang[][E_RACE_COORD] = 
{
	{-2005.41, 288.46, 33.52},
	{-2007.04, 110.69, 27.11},
	{-2006.25, -290.78, 34.88},
	{-2209.03, -289.74, 34.88},
	{-2209.73, -189.65, 34.79},
	{-2254.61, -190.96, 34.74},
	{-2256.06, -350.24, 50.44},
	{-2185.70, -515.48, 47.66},
	{-2224.95, -746.13, 64.05},
	{-2346.90, -786.03, 93.68},
	// 11
	{-2422.64, -608.41, 132.12},
	{-2628.31, -491.66, 69.57},
	{-2328.72, -460.53, 79.59},
	{-2661.18, -401.12, 32.10},
	{-2806.27, -470.40, 6.74},
	{-2807.58, -167.50, 6.59},
	{-2808.82, 35.12, 6.58},
	{-2640.80, 39.60, 3.75},
	{-2499.37, 39.95, 26.03},
	{-2422.13, 40.88, 34.57},
	// 21
	{-2417.30, 210.72, 34.57},
	{-2308.73, 419.44, 34.56},
	{-2386.68, 593.88, 26.84},
	{-2386.03, 806.54, 34.60},
	{-2528.37, 807.28, 49.39},
	{-2750.92, 810.49, 52.62},
	{-2823.32, 947.66, 43.46},
	{-2879.47, 1182.73, 8.25},
	{-2681.97, 1290.53, 6.60},
	{-2460.92, 1377.01, 5.59},
	// 31
	{-2192.16, 1331.99, 6.60},
	{-1783.95, 1353.35, 6.60},
	{-1580.80, 1171.59, 6.87},
	{-1557.73, 797.32, 6.59},
	{-1566.18, 495.60, 6.58},
	{-1739.46, 313.67, 6.60},
	{-1864.09, 412.28, 16.58},
	{-2005.41, 288.46, 33.52}
};

new Float: gRaceCoordsLSFLSAirport[][E_RACE_COORD] =
{
	{-1440.25, -287.26, 13.82},
	{-1665.94, -546.80, 11.19},
	{-1810.79, -580.08, 16.16},
	{-1809.76, -972.80, 49.10},
	{-1553.35, -1442.38, 39.98},
	{-1618.58, -1188.70, 69.51},
	{-1725.06, -830.24, 79.17},
	{-1632.21, -828.92, 93.80},
	{-1591.80, -1152.68, 102.64},
	{-1406.56, -1415.77, 105.19},
	// 11
	{-1130.43, -1336.53, 127.54},
	{-933.18, -1396.86, 127.35},
	{-878.21, -1102.05, 97.44},
	{-603.46, -975.79, 63.84},
	{-315.57, -866.21, 46.70},
	{-108.91, -1009.81, 23.85},
	{-144.43, -1272.83, 2.62},
	{-22.91, -1518.86, 1.65},
	{164.26, -1519.18, 12.25},
	{291.03, -1493.18, 32.46},
	// 21
	{317.53, -1642.43, 32.97},
	{631.01, -1675.74, 16.18},
	{636.30, -1408.25, 13.23},
	{848.48, -1403.57, 13.21},
	{1050.65, -1402.20, 13.23},
	{1057.90, -1223.01, 16.80},
	{1062.64, -1144.43, 23.56},
	{1273.61, -1144.37, 23.48},
	{1504.86, -1162.56, 23.74},
	{1845.19, -1181.76, 23.47},
	// 31
	{1849.23, -1367.16, 13.23},
	{1820.55, -1727.58, 13.21},
	{1688.72, -1730.07, 13.21},
	{1574.59, -1732.32, 13.21},
	{1567.24, -1870.16, 13.22},
	{1306.41, -1853.97, 13.21},
	{1059.67, -1850.80, 13.23},
	{1033.12, -2077.10, 12.76},
	{1057.64, -2312.45, 12.64},
	{1315.26, -2464.73, 7.28},
	// 41
	{1504.08, -2457.98, 2.09},
	{1520.50, -2290.82, -3.36},
	{1574.24, -2285.73, -3.36},
	{1580.57, -2255.93, -3.22},
	{1751.79, -2254.44, -1.39},
	{1797.36, -2283.21, 8.94},
	{1694.67, -2319.06, 13.00},
	{1578.43, -2317.91, 13.00},
	{1579.59, -2194.64, 12.99},
	{1771.15, -2169.07, 13.00},
	// 51
	{1954.61, -2165.85, 13.00},
	{1965.29, -2289.74, 13.17},
	{1889.86, -2411.43, 13.16}
};

new Float: gRaceCoordsLVMapCircuit[][E_RACE_COORD] =
{
	{2046.95, 982.90, 10.21},
	{2048.64, 842.09, 6.27},
	{2214.63, 834.22, 6.30},
	{2500.25, 838.85, 6.30},
	{2687.55, 978.64, 6.29},
	{2726.26, 1206.99, 6.29},
	{2726.26, 1446.08, 6.29},
	{2727.66, 1822.88, 6.30},
	{2725.44, 2155.23, 6.31},
	{2681.64, 2450.49, 6.28},
	// 11
	{2491.00, 2612.43, 4.66},
	{2198.72, 2612.03, 6.33},
	{1908.17, 2531.06, 6.36},
	{1587.37, 2472.76, 6.35},
	{1242.10, 2478.20, 8.03},
	{961.07, 2586.93, 10.16},
	{661.18, 2659.26, 27.36},
	{389.09, 2700.56, 60.27},
	{113.12, 2713.06, 52.12},
	{-219.29, 2635.40, 62.42},
	// 21
	{-502.10, 2716.77, 65.31},
	{-831.92, 2727.31, 45.20},
	{-1247.94, 2677.41, 47.00},
	{-1440.67, 2723.94, 63.56},
	{-1769.11, 2715.47, 58.66},
	{-1972.12, 2613.21, 49.13},
	{-2382.21, 2671.81, 58.85},
	{-2764.70, 2501.85, 95.51},
	{-2689.33, 2114.70, 54.98},
	{-2688.34, 1456.02, 54.99},
	// 31
	{-2625.09, 1138.82, 54.99},
	{-2217.28, 1055.74, 55.14},
	{-1889.41, 1051.04, 44.85},
	{-1899.67, 849.85, 34.58},
	{-1713.30, 845.33, 24.29},
	{-1539.91, 839.95, 6.61},
	{-1565.61, 498.05, 6.58},
	{-1747.15, 308.38, 6.59},
	{-1831.84, 386.98, 16.57},
	{-1895.20, 111.27, 37.69},
	// 41
	{-1932.30, -234.41, 38.18},
	{-2156.96, -334.99, 34.75},
	{-2583.10, -337.75, 21.52},
	{-2809.17, -499.68, 6.63},
	{-2871.45, -866.36, 7.16},
	{-2916.02, -1187.03, 8.91},
	{-2929.46, -1695.34, 16.90},
	{-2784.75, -2012.38, 37.57},
	{-2540.79, -2218.72, 28.94},
	{-2449.42, -2542.66, 48.93},
	// 51
	{-2035.02, -2659.05, 55.27},
	{-1719.66, -2665.35, 46.54},
	{-1276.70, -2896.97, 56.23},
	{-973.31, -2867.58, 66.50},
	{-647.90, -2784.31, 50.05},
	{-185.61, -2872.17, 38.74},
	{6.84, -2647.05, 39.75},
	{-288.26, -2197.39, 27.96},
	{-292.68, -1771.75, 15.14},
	{-110.23, -1455.49, 12.36},
	// 61
	{116.72, -1268.03, 14.77},
	{495.35, -1137.53, 30.69},
	{627.63, -1246.94, 17.19},
	{632.06, -1525.99, 14.54},
	{632.98, -1742.99, 12.85},
	{836.37, -1782.85, 13.31},
	{1039.18, -2062.38, 12.48},
	{1075.37, -2339.65, 12.01},
	{1310.95, -2464.58, 7.22},
	{1334.09, -2583.55, 12.94},
	// 71
	{1551.35, -2684.51, 6.85},
	{2021.18, -2685.05, 10.63},
	{2175.52, -2523.74, 12.93},
	{2311.62, -2260.42, 12.92},
	{2600.69, -2169.42, 12.04},
	{2829.70, -2096.63, 10.49},
	{2858.51, -1731.37, 10.44},
	{2926.18, -1446.60, 10.44},
	{2891.28, -918.27, 10.44},
	{2897.26, -526.27, 12.00},
	// 81
	{2800.09, -240.79, 11.09},
	{2877.81, -40.02, 16.99},
	{2808.87, 76.25, 19.55},
	{2740.16, 276.19, 19.83},
	{2475.49, 318.15, 30.81},
	{2124.84, 319.75, 33.45},
	{1717.89, 303.15, 19.01},
	{1741.18, 501.11, 28.57},
	{1807.99, 829.19, 10.24},
	{2051.83, 834.95, 6.30},
	// 91
	{2070.53, 961.72, 9.88},
	{2046.41, 999.06, 10.24}
};

new Float: gRaceCoordsDesertAirCircuit[][E_RACE_COORD] =
{
	{369.64, 2502.15, 17.40},
	{-14.31, 2500.38, 48.37},
	{-416.20, 2460.88, 99.84},
	{-763.97, 2511.05, 148.77},
	{-1165.76, 2715.24, 108.65},
	{-1496.06, 2721.65, 135.44},
	{-1818.74, 2634.10, 130.46},
	{-1932.01, 2278.66, 130.03},
	{-1784.93, 2042.32, 130.40},
	{-1518.67, 1946.81, 136.81},
	// 11
	{-1148.50, 2143.69, 121.28},
	{-861.34, 2313.76, 178.20},
	{-591.26, 2500.01, 120.71},
	{-267.54, 2545.04, 78.56},
	{125.84, 2510.74, 35.65},
	{353.49, 2505.97, 17.40}
};

//
//  Race-related functions.
//

public InitRaces() 
{
	//
}

stock StartRace()
{
	return 1;
}

stock SetPlayerRaceSingle(playerid, E_RACE_ID: raceId, const Float:coords[][E_RACE_COORD], len)
{
	// Fetch the relative position in such race (position of checkpoints).
	new lastCPNo = len - 1, raceCPPosition = gPlayerRace[playerid][raceId] - 1, raceType = gRaceTypes[raceId];

	// Prepare the coords to show a race checkpoint.
	new Float: x0, Float: y0, Float: z0, Float: x1, Float: y1, Float: z1, t_CP_TYPE: cpType;

	if (raceType == E_RACE_TYPE_GROUND)
		cpType = CP_TYPE_GROUND_NORMAL;
	else
		cpType = CP_TYPE_AIR_NORMAL;

	// End the race.
	if (raceCPPosition > lastCPNo)
	{
		ResetPlayerRaceState(playerid, raceId, true);

		return 1;
	}

	x0 = coords[raceCPPosition][E_RACE_COORD_X];
	y0 = coords[raceCPPosition][E_RACE_COORD_Y];
	z0 = coords[raceCPPosition][E_RACE_COORD_Z];

	if (raceCPPosition + 1 <= lastCPNo)
	{
		x1 = coords[raceCPPosition+1][E_RACE_COORD_X];
		y1 = coords[raceCPPosition+1][E_RACE_COORD_Y];
		z1 = coords[raceCPPosition+1][E_RACE_COORD_Z];
	} else {
		if (raceType == E_RACE_TYPE_GROUND)
			cpType = CP_TYPE_GROUND_FINISH;
		else
			cpType = CP_TYPE_AIR_FINISH;
	}

	// Set the next checkpoint to reach.
	SetPlayerRaceCheckpoint(playerid, cpType, Float:x0, Float:y0, Float:z0, Float:x1, Float:y1, Float:z1, 10.0);

	return 1;
}

stock SetPlayerRace(playerid, E_RACE_ID: raceId)
{
	// Check if player has joined such race.
	if (!IsPlayerConnected(playerid) || raceId == E_RACE_ID_NONE || !gPlayerRace[playerid][raceId])
		return 0;

	switch (raceId)
	{
		case E_RACE_ID_STUNT_LV_1:
			{
				SetPlayerRaceSingle(playerid, raceId, gRaceCoordsLVStuntNo1, sizeof(gRaceCoordsLVStuntNo1));
			}
		case E_RACE_ID_CIRCUIT_SF_WANG:
			{
				SetPlayerRaceSingle(playerid, raceId, gRaceCoordsSFCircuitWang, sizeof(gRaceCoordsSFCircuitWang));
			}
		case E_RACE_ID_SF_LS_AIRPORT:
			{
				SetPlayerRaceSingle(playerid, raceId, gRaceCoordsLSFLSAirport, sizeof(gRaceCoordsLSFLSAirport));
			}
		case E_RACE_ID_LV_MAP_CIRCUIT:
			{
				SetPlayerRaceSingle(playerid, raceId, gRaceCoordsLVMapCircuit, sizeof(gRaceCoordsLVMapCircuit));
			}
		case E_RACE_ID_DESERT_AIR_CIRCUIT:
			{
				SetPlayerRaceSingle(playerid, raceId, gRaceCoordsDesertAirCircuit, sizeof(gRaceCoordsDesertAirCircuit));
			}
		default:
			{
				return 0;
			}
	}

	return 1;
}

stock SetPlayerRaceState(playerid, E_RACE_ID: raceId)
{
	new stringToPrint[256];

	if (!IsPlayerInAnyVehicle(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);

	// Check if already joined such race.
	if (gPlayerRace[playerid][raceId])
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_JOINED);

	if (CheckPlayerRaceState(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_ALREADY_JOINED);
		//return SendClientMessage(playerid, COLOR_ZLUTA, "[ ! ] Jiz jsi prihlasen v jinem zavode! Pred prihlasenim je treba predchozi zavod dokoncit!");

	if (raceId == E_RACE_ID_NONE)
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_SUCH_RACE);

	if (GetPlayerMoney(playerid) < gRaceFeePrize[raceId][E_RACE_FEE_FEE])
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_MONEY);

	//
	//  Ok, register the player with given raceId.
	//

	gPlayerRace[playerid][raceId] = 1;
	GivePlayerMoney(playerid, -gRaceFeePrize[raceId][E_RACE_FEE_FEE]);

	switch (gPlayers[playerid][Locale])
	{
		case LOCALE_CZ:
			format(stringToPrint, sizeof(stringToPrint), "[ ZAVOD ] Uspesne prihlasen do zavodu '%s' (prihlaska $%d). Projed prvnim checkpointem pro spusteni casomiry.", gRaceNames[raceId], gRaceFeePrize[raceId][E_RACE_FEE_FEE]);

		default:
			format(stringToPrint, sizeof(stringToPrint), "[ RACE ] Joined the '%s' race (cost $%d). Use the first checkpoint to start the race!", gRaceNames[raceId], gRaceFeePrize[raceId][E_RACE_FEE_FEE]);
	}

	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);
	SetPlayerRace(playerid, raceId);

	return 1;
}

stock ResetPlayerRaceState(playerid, E_RACE_ID: raceId, finishedSuccessfully)
{
	if (!CheckPlayerRaceState(playerid))
		return SendClientMessageLocalized(playerid, I18N_RACE_NO_RACE);

	DisablePlayerRaceCheckpoint(playerid);
	TextDrawHideForPlayer(playerid, gRaceInfoText[playerid]);
	KillTimer(_: gPlayerRaceTimer[playerid]);

	gPlayerRaceTimer[playerid] = Timer: 0;
	gPlayerRaceTime[playerid] = 0;

	if (finishedSuccessfully)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_SUCCESSFULLY);

		new playerName[MAX_PLAYER_NAME], stringToPrint[256];

		GetPlayerName(playerid, playerName, sizeof(playerName));
		GivePlayerMoney(playerid, gRaceFeePrize[raceId][E_RACE_FEE_PRIZE]);

		format(stringToPrint, sizeof(stringToPrint), "[ i ] Player %s just won the '%s' race, and received a price of $%d!", playerName, gRaceNames[raceId], gRaceFeePrize[raceId][E_RACE_FEE_PRIZE]);
		SendClientMessageToAll(COLOR_LIGHTGREEN, stringToPrint);
	}

	if (!finishedSuccessfully && CheckPlayerRaceState(playerid))
	{
		SendClientMessageLocalized(playerid, I18N_RACE_ENDED_PREMATURELY);
	}

	// Reset all race states to be sure not to interfere with others.
	for (new i = 0; i < sizeof(gRaceNames); i++)
	{
		gPlayerRace[playerid][E_RACE_ID: i] = 0;
	}

	return 1;
}

// This number should be aither 0, or 1 at max! This means the player must be in just one race at the time!
stock CheckPlayerRaceState(playerid)
{
	for (new i = 0; i < sizeof(gRaceNames); i++)
	{
		if (gPlayerRace[playerid][E_RACE_ID: i])
		{
			// The player is racing at the moment!
			return i;
		}
	}

	// The player does not seem to be in any race now.
	return 0;
}

stock SetPlayerRaceStartPos(playerid)
{
	new E_RACE_ID: raceId = E_RACE_ID: CheckPlayerRaceState(playerid);

	if (!raceId)
	{
		 SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_RACE);
		 return 0;
	}

	if (gPlayerRace[playerid][raceId] > 1)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_WARP_AFTER_START);
		return 0;
	}

	if (!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		SendClientMessageLocalized(playerid, I18N_RACE_WARP_NO_VEHIC_DRIVER);
		return 0;
	}

	SetVehiclePos(GetPlayerVehicleID(playerid), Float:gRaceWarp[raceId][E_RACE_COORD_X], Float:gRaceWarp[raceId][E_RACE_COORD_Y], Float:gRaceWarp[raceId][E_RACE_COORD_Z]);

	return 1;
}

public UpdateRaceInfoText(playerid)
{
	new 
		cpCount, 
		E_RACE_ID:raceId = E_RACE_ID:CheckPlayerRaceState(playerid), 
		stringToPrint[128];

	switch (raceId)
	{
		case E_RACE_ID_STUNT_LV_1:
			cpCount = sizeof(gRaceCoordsLVStuntNo1);
		case E_RACE_ID_CIRCUIT_SF_WANG:
			cpCount = sizeof(gRaceCoordsSFCircuitWang);
		case E_RACE_ID_SF_LS_AIRPORT:
			cpCount = sizeof(gRaceCoordsLSFLSAirport);
		case E_RACE_ID_LV_MAP_CIRCUIT:
			cpCount = sizeof(gRaceCoordsLVMapCircuit);
		case E_RACE_ID_DESERT_AIR_CIRCUIT:
			cpCount = sizeof(gRaceCoordsDesertAirCircuit);
	}

	gPlayerRaceTime[playerid] += 1000;

	switch (gPlayers[playerid][Locale]) 
	{
		case LOCALE_CZ:
			format(stringToPrint, sizeof(stringToPrint), "~w~Zavod:_________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Cas:_______~b~%4d~y~:~b~%2d", float:raceId, gPlayerRace[playerid][raceId]-1, cpCount, floatround(floatround(gPlayerRaceTime[playerid] / 1000) / 60), floatround(gPlayerRaceTime[playerid] / 1000) % 60);

		default:
			format(stringToPrint, sizeof(stringToPrint), "~w~Race:__________~g~%3d~n~~w~Checkpoint:_~r~%2d~y~/~r~%2d~n~~w~Time:______~b~%4d~y~:~b~%2d", float:raceId, gPlayerRace[playerid][raceId]-1, cpCount, floatround(floatround(gPlayerRaceTime[playerid] / 1000) / 60), floatround(gPlayerRaceTime[playerid] / 1000) % 60);
	}

	// Redraw the player's current velocity.
	TextDrawSetString(gRaceInfoText[playerid], stringToPrint);
	TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);

	return 1;
}

stock CheckRaceCheckpoint(playerid)
{
	if (!gPlayerRaceTimer[playerid])
	{
		gPlayerRaceTimer[playerid] = Timer: SetTimerEx("UpdateRaceInfoText", 1 * SECOND_MS, true, "i", playerid);
		TextDrawShowForPlayer(playerid, gRaceInfoText[playerid]);
	}

	//SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Jsi v zavodnim checkpointu!");
	DisablePlayerRaceCheckpoint(playerid);

	for (new i = 0; i <= sizeof(gRaceNames); i++)
	{
		if (gPlayerRace[playerid][E_RACE_ID: i])
		{
			gPlayerRace[playerid][E_RACE_ID: i]++;
			SetPlayerRace(playerid, E_RACE_ID: i);
			break;
		}
	}

	return 1;
}
