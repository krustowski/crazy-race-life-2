//
//  Everything dialogs.
//

#include "modules/real.pwn"

enum
{
	DIALOG_UNUSED,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_PROPERTY_BUY,
	DIALOG_PROPERTY_SELL,
	DIALOG_PROPERTY_DRUGZ,
	DIALOG_PROPERTY_DRUGZ_TRANS,
	DIALOG_PROPERTY_EDIT_MAIN,
	DIALOG_PROPERTY_EDIT_NAME,
	DIALOG_PROPERTY_EDIT_COST,
	DIALOG_TRUCKING_INFO,
	DIALOG_HIGH_SCORES_MAIN,
	DIALOG_ADMIN_CMDS
};

stock ShowPlayerDrugzDialog(playerid)
{
	new stringToPrint[512] = "Substance/stuff\tIn pockets\tAt home";

	for (new i = 0; i < MAX_DRUGS; i++)
	{
		new partial[64], propertyID = gPlayerInteriors[playerid][PropertyArrayID];

		format(partial, sizeof(partial), "\n%s\t%d\t%d", gDrugz[i][DrugName], gPlayers[playerid][Drugs][i], gProperties[propertyID][Drugs][i]);
		strcat(stringToPrint, partial, sizeof(stringToPrint));
	}

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_DRUGZ, DIALOG_STYLE_TABLIST_HEADERS, "Drugz", stringToPrint, "Transfer", "Cancel");
}

stock ShowPropertyEditDialogMain(playerid)
{
	new
		propertyid = gPropertyEdit[playerid][ID],
		stringToPrint[128],
		title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);
	format(stringToPrint, sizeof(stringToPrint), "Name\nCost in dollars\nEntrance pickup coords\nOffer pickup coords\nVehicle coords\nOccupied state\nSave property");

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_MAIN, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
}

stock ShowPropertyEditDialogName(playerid)
{
	new
		propertyid = gPropertyEdit[playerid][ID],
		title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_NAME, DIALOG_STYLE_INPUT, title, "Enter a new property name:", "Enter", "Cancel");
}

stock ShowPropertyEditDialogCost(playerid)
{
	new
		propertyid = gPropertyEdit[playerid][ID],
		title[32];

	format(title, sizeof(title), "Edit property ID: %d", propertyid);

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDIT_COST, DIALOG_STYLE_INPUT, title, "Enter a new property cost in dollars:", "Enter", "Cancel");
}

stock ShowHighScoresDialog(playerid)
{
	new stringToPrint[1024];
	format(stringToPrint, sizeof(stringToPrint), "");
	
	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (gHighScores[i][Time][0] == 0 || !strcmp(gRaces[i][Name], ""))
		{
			continue;
		}

		new highScoreTimeSec[8];

		if ((gHighScores[i][Time][0] / 1000) % 60 < 10)
		{
			format(highScoreTimeSec, sizeof(highScoreTimeSec), "%d%d", 0, (gHighScores[i][Time][0] / 1000) % 60);
		}
		else
		{
			format(highScoreTimeSec, sizeof(highScoreTimeSec), "%2d", (gHighScores[i][Time][0] / 1000) % 60);
		}

		format(stringToPrint, sizeof(stringToPrint), "%s\nRace No. %d\n\n1st\t%d:%s min\t%s\t(model %d)\n", 
				stringToPrint, 
				i, 
				(gHighScores[i][Time][0] / 1000) / 60,
				highScoreTimeSec,
				gHighScores[i][Nickname1], 
				gHighScores[i][VehicleModel][0]
		      );

		if (gHighScores[i][Time][1] != 0)
		{
			if ((gHighScores[i][Time][1] / 1000) % 60 < 10)
			{
				format(highScoreTimeSec, sizeof(highScoreTimeSec), "%d%d", 0, (gHighScores[i][Time][1] / 1000) % 60);
			}
			else
			{
				format(highScoreTimeSec, sizeof(highScoreTimeSec), "%d", (gHighScores[i][Time][1] / 1000) % 60);
			}

			format(stringToPrint, sizeof(stringToPrint), "%s2nd\t%d:%s min\t%s\t(model %d)\n", 
					stringToPrint,
					(gHighScores[i][Time][1] / 1000) / 60,
					highScoreTimeSec,
					gHighScores[i][Nickname2], 
					gHighScores[i][VehicleModel][1]
			      );
		}

		if (gHighScores[i][Time][2] != 0)
		{
			if ((gHighScores[i][Time][2] / 1000) % 60 < 10)
			{
				format(highScoreTimeSec, sizeof(highScoreTimeSec), "%d%d", 0, (gHighScores[i][Time][2] / 1000) % 60);
			}
			else
			{
				format(highScoreTimeSec, sizeof(highScoreTimeSec), "%d", (gHighScores[i][Time][2] / 1000) % 60);
			}

			format(stringToPrint, sizeof(stringToPrint), "%s3rd\t%d:%s min\t%s\t(model %d)\n", 
					stringToPrint,
					(gHighScores[i][Time][2] / 1000) / 60,
					highScoreTimeSec,
					gHighScores[i][Nickname3], 
					gHighScores[i][VehicleModel][2]
			      );
		}
	}

	return ShowPlayerDialog(playerid, DIALOG_HIGH_SCORES_MAIN, DIALOG_STYLE_MSGBOX, "High Scores", stringToPrint, "Close", "");
}

stock ShowAdminCommandsDialog(playerid)
{
	new stringToPrint[2048];
	format(stringToPrint, sizeof(stringToPrint), "");

	if (gPlayers[playerid][AdminLevel] < 1)
		return 1;

	format(stringToPrint, sizeof(stringToPrint), "Level 1\n\n%s%s%s%s%s%s",
			"/acmd\t\t\tshows admin commands per level\n",
			"/admincol ID\t\tchanges the admin color according to color ID\n",
			"/clear\t\t\tflushes the chat\n",
			"/flip ID\t\t\tflips the player's car\n",
			"/hp ID\t\t\tsets the HP to 100 + armour to player ID\n",
			"/nitro ID\t\tsets the nitrous boost to player's car\n"
	      );

	if (gPlayers[playerid][AdminLevel] < 2)
		return ShowPlayerDialog(playerid, DIALOG_ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Admin Commands", stringToPrint, "Close", "");

	format(stringToPrint, sizeof(stringToPrint), "%s\nLevel 2\n\n%s%s%s%s%s",
			stringToPrint,
			"/cam ID\t\t\tsets the camera view to a specific place in LV\n",
			"/countdown SEC\tsets the seconds to start the countdown\n",
			"/get ID\t\t\twarps a player ID to the admin\n",
			"/goto ID\t\t\twarps the admin to a player ID\n",
			"/skin pID sID\t\tsets the skin sID to player pID\n"
	      );

	if (gPlayers[playerid][AdminLevel] < 3)
		return ShowPlayerDialog(playerid, DIALOG_ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Admin Commands", stringToPrint, "Close", "");

	format(stringToPrint, sizeof(stringToPrint), "%s\nLevel 3\n\n%s%s%s%s%s%s%s%s%s%s",
			stringToPrint,
			"/crime ID\t\tplays the crime sound (Police T-Code), experimental\n",
			"/drunk ID\t\tsets the drunk level to a player ID, experimental\n",
			"/elevator SUBCMD\t operates the Admin elevator\n",
			"/kick ID\t\t\tkicks the player ID from server\n",
			"/packet ID\t\tprints the packet loss per player ID\n",
			"/reset ID\t\tresets cash for a player\n",
			"/spectate ID\t\tsets the spectate mode on a player ID\n",
			"/vehicle ID\t\tspawns a vehicle by ID\n",
			"/weapon pID wID\tsets a weapon wID to a player pID\n",
			"/weapons ID\t\tsets the weapons pack to player ID\n"
		);

	if (gPlayers[playerid][AdminLevel] < 4)
		return ShowPlayerDialog(playerid, DIALOG_ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Admin Commands", stringToPrint, "Close", "");

	format(stringToPrint, sizeof(stringToPrint), "%s\nLevel 4\n\n%s%s%s%s%s%s%s",
			stringToPrint,
			"/ban ID\t\t\tbans the player ID (via IP)\n",
			"/fakechat ID TEXT\tsends the fake chat TEXT as the player ID\n",
			"/lvl pID LVL\t\tsets the Admin LVL to player ID\n",
			"/predit ID\t\tstarts the property editor for property ID\n",
			"/redit ID\t\t\tstarts the race editor for race ID\n",
			"/restart\t\t\tsets the countdown for 60 seconds to restart the server\n",
			"/tredit ID\t\tstarts the Trucking editor for point ID\n"
		);

	return ShowPlayerDialog(playerid, DIALOG_ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Admin Commands", stringToPrint, "Close", "");
}
