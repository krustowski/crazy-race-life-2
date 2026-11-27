#if defined _CRL2_CLOCK
	#endinput
#endif
#define _CRL2_CLOCK

new 
	// The very game clock's text
	Text: gClockText,
	// The clock's text squeezed between the weapon icon and the armour bar for the HD (widescreen) GTA SA HUD
	Text: gClockTextHD,
	// A minor hotfix not to change the world time on each tick
	gPreviousHour = -1,
	bool: gWeatherSet = false;

forward DrawClockText();

// Show the clock variant matching the player's GTA SA version (HD or classic), hide the other one.
stock ShowPlayerClock(playerid)
{
	TextDrawHideForPlayer(playerid, gClockText);
	TextDrawHideForPlayer(playerid, gClockTextHD);

	return TextDrawShowForPlayer(playerid, gPlayers[playerid][HDVersion] ? gClockTextHD : gClockText);
}

public DrawClockText()
{
	new 
		hour, 
		minute,	
		second, 
		stringToPrint[25];

	// Load the current time
	gettime(hour, minute, second);

	format(stringToPrint, sizeof(stringToPrint), "%2d:%02d", hour, minute);

	TextDrawSetString(gClockText, stringToPrint);
	TextDrawSetString(gClockTextHD, stringToPrint);

	// Redraw the clock text/string for all online players
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		ShowPlayerClock(i);
	}

	if (minute % 15 == 0 && !gWeatherSet)
	{
		SetWeather(random(17));
		gWeatherSet = true;
	}

	if (minute % 15 == 1 && gWeatherSet)
	{
		gWeatherSet = false;
	}

	// Reset the world time according to the new hour value
	if (gPreviousHour != hour)
	{
		SetWorldTime(hour);
		gPreviousHour = hour;
	}

	return 1;
}

