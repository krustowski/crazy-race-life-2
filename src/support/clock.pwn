#if defined _CRL2_CLOCK
	#endinput
#endif
#define _CRL2_CLOCK

// The very game clock's text
new Text:gClockText;

// A minor hotfix not to change the world time on each tick
new prevHour;

forward DrawClockText();

public DrawClockText()
{
	new hour, minute, second, stringToPrint[25];

	// Load the current time
	gettime(hour, minute, second);

	if (minute < 10)
		format(stringToPrint, sizeof(stringToPrint), "%2d:0%d", hour, minute);
	else
		format(stringToPrint, sizeof(stringToPrint), "%2d:%2d", hour, minute);

	// Redraw the clock text/string for all online players
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		TextDrawHideForPlayer(i, gClockText);
		TextDrawSetString(gClockText, stringToPrint);
		TextDrawShowForPlayer(i, gClockText);
	}

	if (prevHour != hour)
	{
		SetWorldTime(hour);
		prevHour = hour;
	}

	return 1;
}

