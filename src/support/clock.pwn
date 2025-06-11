// The very game clock's text.
new Text:gClockText;

forward DrawClockText();

public DrawClockText()
{
	new hour, minute, second, stringToPrint[25];

	// Load the current time.
	gettime(hour, minute, second);

	if (minute < 10)
		format(stringToPrint, sizeof(stringToPrint), "%2d:0%d", hour, minute);
	else
		format(stringToPrint, sizeof(stringToPrint), "%2d:%2d", hour, minute);

	// Redraw the clock text/string for all online players.
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		TextDrawHideForPlayer(i, gClockText);
		TextDrawSetString(gClockText, stringToPrint);
		TextDrawShowForPlayer(i, gClockText);
	}

	return 1;
}

