//
//  Texts.
//

new Text:gGameModeText;

public InitTexts()
{
	//
	//  DrawTexts initialization.
	//

	gGameModeText = TextDrawCreate(20.0, 425.0, MINIMAP_TEXT);

	TextDrawLetterSize(gGameModeText, 0.5, 1.5);
	TextDrawFont(gGameModeText, t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gGameModeText, 1);

	gClockText = TextDrawCreate(547.0, 24.0, "loading");

	TextDrawLetterSize(gClockText, 0.6, 1.8);
	TextDrawFont(gClockText, t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gClockText, 1);
}

public AddTexts(playerid)
{
	gRaceInfoText[playerid] = TextDrawCreate(460.0, 400.0, "");

	TextDrawLetterSize(gRaceInfoText[playerid], 0.5, 1.5);
	TextDrawFont(gRaceInfoText[playerid], t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gRaceInfoText[playerid], 1);

	// Show the game clock.
	TextDrawShowForPlayer(playerid, gClockText);
	TextDrawShowForPlayer(playerid, gGameModeText);

}
