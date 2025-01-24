// The very game clock's text.
new Text:gClockText;

public DrawClockText()
{
	new hour, minute, second, stringToPrint[256];

	// Load the current time.
	gettime(hour, minute, second);

	format(stringToPrint, 25, "%2d:%2d", hour, minute);

	// Redraw the clock text/string for all online players.
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		TextDrawHideForPlayer(i, gClockText);
		TextDrawSetString(gClockText, stringToPrint);
		TextDrawShowForPlayer(i, gClockText);
	}

	return 1;
}

