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
	DIALOG_TRUCKING_INFO
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
