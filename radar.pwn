enum E_POSITION
{
      Float:X_r,
      Float:Y_r,
      Float:Z_r
}

// Global variables to track the player's position and state.
new gPlayerPosition[MAX_PLAYERS][E_POSITION];
new gRadarCaught[MAX_PLAYERS];

// Text variables to show on player's screen.
new Text:KPH[MAX_PLAYERS];
new Text:KPHR[MAX_PLAYERS];

public OnRadarCheckpoint()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
		{
			new stringToPrint[128], Float:value_r, Float:distance_r, Float:x_r, Float:y_r, Float:z_r;

			// Fetch the current player's position.
			GetPlayerPos(i, x_r, y_r, z_r);

			distance_r = floatsqroot(floatpower(floatabs(floatsub(x_r, gPlayerPosition[i][X_r])), 2) + floatpower(floatabs(floatsub(y_r, gPlayerPosition[i][Y_r])), 2) + floatpower(floatabs(floatsub(z_r, gPlayerPosition[i][Z_r])), 2));
			value_r = floatround(distance_r * 11000);

			if (floatround(value_r / 1400) > 65)
			{
				format(stringToPrint, 128, "~r~~h~%d", floatround(value_r / 1400));
			}
			else
			{
				format(stringToPrint, 128, "~g~~h~%d", floatround(value_r / 1400));
			}

			// Redraw the player's current velocity.
			TextDrawSetString(KPHR[i], stringToPrint);

			gPlayerPosition[i][X_r] = x_r;
			gPlayerPosition[i][Y_r] = y_r;
			gPlayerPosition[i][Z_r] = z_r;

			// Compare the current position with the radar positions.
			if (IsPlayerInSphere(i, 2048.4158, 1173.2195, 10.6719, 15) ||
					IsPlayerInSphere(i, 2066.5464, 1623.2606, 10.6719, 15) ||
					IsPlayerInSphere(i, 2347.6807, 2413.1965, 10.6719, 15) ||
					IsPlayerInSphere(i, 2507.3359, 1880.9712, 10.6719, 15) ||
					IsPlayerInSphere(i, 2260.2791, 1373.3129, 10.6719, 15) ||
					IsPlayerInSphere(i, 2427.2900, 1257.8555, 10.7901, 15) ||
					IsPlayerInSphere(i, 2210.5552, 973.2725, 10.6719, 15) ||
					IsPlayerInSphere(i, 1536.0039, 1133.1715, 10.6719, 15) ||
					IsPlayerInSphere(i, 1007.3343, 1540.1764, 10.6719, 15) ||
					IsPlayerInSphere(i, 1448.2607, 2589.8904, 10.6719, 15) ||
					IsPlayerInSphere(i, 1691.7292, 2173.2539, 10.6719, 15))
			{
				if (gRadarCaught[i] == 0 && floatround(value_r / 1400) > 65)
				{
					gRadarCaught[i] = 1;

					GivePlayerMoney(i, -500);
					PlayerPlaySound(i, 1147, 0, 0, 0);

					SendClientMessage(i, COLOR_BILA, " ");
					format(stringToPrint, 128, "[ Radar ] Jel jsi příliš velkou rychlostí ( %3d km/h ). Pokuta: 500 €", floatround(value_r / 1400));
					SendClientMessage(i, COLOR_CERVENA, stringToPrint);

					SetTimerEx("OffRadarCheckpoint", 5000, 0, "i", i);

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

