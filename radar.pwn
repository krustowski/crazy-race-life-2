new RADAR_FEE = 500;

enum E_POSITION
{
	Float:E_POSITION_X,
     	Float:E_POSITION_Y,
        Float:E_POSITION_Z
}

// Global variables to track the player's position and state.
new gPlayerPosition[MAX_PLAYERS][E_POSITION];
new gRadarCaught[MAX_PLAYERS];

// Text variables to show on player's screen.
//new Text:KPH[MAX_PLAYERS];
//new Text:KPHR[MAX_PLAYERS];

new Text:gVehicleStatesText[MAX_PLAYERS];

new Float: gRadarPositions[][4] =
{
	// LV
	{2048.4158, 1173.2195, 10.6719, 15.0},
	{2066.5464, 1623.2606, 10.6719, 15.0},
	{2347.6807, 2413.1965, 10.6719, 15.0},
	{2507.3359, 1880.9712, 10.6719, 15.0},
	{2260.2791, 1373.3129, 10.6719, 15.0},
	{2427.2900, 1257.8555, 10.7901, 15.0},
	{2210.5552, 973.2725, 10.6719, 15.0},
	{1536.0039, 1133.1715, 10.6719, 15.0},
	{1007.3343, 1540.1764, 10.6719, 15.0},
	{1448.2607, 2589.8904, 10.6719, 15.0},
	{1691.7292, 2173.2539, 10.6719, 15.0}
};


public OnRadarCheckpoint()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || !IsPlayerInAnyVehicle(i))
			continue;

		new stringToPrint[256], Float:radarValue, Float:radarDistance, Float:radarX, Float:radarY, Float:radarZ, Float:vehicleHelth;

		// Fetch the current player's position.
		GetPlayerPos(i, radarX, radarY, radarZ);

		radarDistance = floatsqroot(floatpower(floatabs(floatsub(radarX, gPlayerPosition[i][E_POSITION_X])), 2) + floatpower(floatabs(floatsub(radarY, gPlayerPosition[i][E_POSITION_Y])), 2) + floatpower(floatabs(floatsub(radarZ, gPlayerPosition[i][E_POSITION_Z])), 2));
		radarValue = floatround(radarDistance * 11000);

		GetVehicleHealth(GetPlayerVehicleID(i), vehicleHelth);

		if (floatround(radarValue / 1400) > 65)
		{
			format(stringToPrint, sizeof(stringToPrint), "~w~Stav:______%3d_%%~n~~w~Rychlost:_~r~~h~%3d", floatround(vehicleHelth / 10), floatround(radarValue / 1400));
		}
		else
		{
			format(stringToPrint, sizeof(stringToPrint), "~w~Stav:______%3d_%%~n~~w~Rychlost:_~g~~h~%3d", floatround(vehicleHelth / 10), floatround(radarValue / 1400));
		}

		// Redraw the player's current velocity.
		TextDrawSetString(gVehicleStatesText[i], stringToPrint);

		gPlayerPosition[i][E_POSITION_X] = radarX;
		gPlayerPosition[i][E_POSITION_Y] = radarY;
		gPlayerPosition[i][E_POSITION_Z] = radarZ;

		for (new j = 0; j < sizeof(gRadarPositions); j++)
		{
			if (IsPlayerInSphere(i, Float:gRadarPositions[j][0], Float:gRadarPositions[j][1], Float:gRadarPositions[j][2], _:gRadarPositions[j][3]))
			{
				// Compare the current position with the radar positions.
				if (gRadarCaught[i] == 0 && floatround(radarValue / 1400) > 65 && GetPlayerState(i) == PLAYER_STATE_DRIVER)
				{
					gRadarCaught[i] = 1;

					GivePlayerMoney(i, -RADAR_FEE);
					PlayerPlaySound(i, 1147, 0, 0, 0);

					format(stringToPrint, 128, "[ RADAR ] Jel jsi prilis vysokou rychlosti ( %3d km/h )! Pokuta: $%d", floatround(radarValue / 1400), RADAR_FEE);
					SendClientMessage(i, COLOR_CERVENA, stringToPrint);

					SetTimerEx("OffRadarCheckpoint", 5000, false, "i", i);

					return 1;
				}
			}
		}
	}

	return 1;
}

public OffRadarCheckpoint(playerid)
{
	gRadarCaught[playerid] = 0;
}

