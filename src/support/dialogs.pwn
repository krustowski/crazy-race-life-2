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
	DIALOG_HIGH_SCORES_MAIN
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
	new stringToPrint[512];
	format(stringToPrint, sizeof(stringToPrint), "");
	
	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (gHighScores[i][Time][0] == 0 || !strcmp(gRaces[i][Name], ""))
		{
			continue;
		}

		format(stringToPrint, sizeof(stringToPrint), "%s\nRace No. %d\n\n1st\t%s\t%d sec\t(model %d)\n", 
				stringToPrint, 
				i, 
				gHighScores[i][Nickname1], 
				gHighScores[i][Time][0] / 1000,
				gHighScores[i][VehicleModel][0]
		      );

		if (gHighScores[i][Time][1] != 0)
		{
			format(stringToPrint, sizeof(stringToPrint), "%s2nd\t%s\t%d sec\t(model %d)\n", 
					stringToPrint,
					gHighScores[i][Nickname2], 
					gHighScores[i][Time][1] / 1000,
					gHighScores[i][VehicleModel][1]
			      );
		}

		if (gHighScores[i][Time][2] != 0)
		{
			format(stringToPrint, sizeof(stringToPrint), "%s3rd\t%s\t%d sec\t(model %d)\n", 
					stringToPrint,
					gHighScores[i][Nickname3], 
					gHighScores[i][Time][2] / 1000,
					gHighScores[i][VehicleModel][2]
			      );
		}
	}

	ShowPlayerDialog(playerid, DIALOG_HIGH_SCORES_MAIN, DIALOG_STYLE_MSGBOX, "High Scores", stringToPrint, "Close", "");
}
