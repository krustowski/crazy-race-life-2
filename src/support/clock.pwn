#if defined _CRL2_CLOCK
	#endinput
#endif
#define _CRL2_CLOCK

new 
	// The very game clock's text
	Text: gClockText,
	// A minor hotfix not to change the world time on each tick
	gPreviousHour;

forward DrawClockText();

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

	// Redraw the clock text/string for all online players
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		TextDrawHideForPlayer(i, gClockText);
		TextDrawSetString(gClockText, stringToPrint);
		TextDrawShowForPlayer(i, gClockText);
	}

	// Reset the world time according to the new hour value
	if (gPreviousHour != hour)
	{
		SetWorldTime(hour);
		gPreviousHour = hour;
	}

	return 1;
}

