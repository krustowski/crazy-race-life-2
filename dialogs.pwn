//
//  Everything dialogs.
//

#include "real.pwn"

enum
{
	DIALOG_UNUSED,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_PROPERTY_BUY,
	DIALOG_PROPERTY_SELL,
	DIALOG_PROPERTY_DRUGZ,
	DIALOG_PROPERTY_DRUGZ_TRANS
};

stock ShowPlayerDrugzDialog(playerid)
{
	new stringToPrint[512] = "Substance/proprieta\tV kapse\tUlozeno doma";

	for (new i = 0; i < MAX_DRUGS; i++)
	{
		new partial[64], propertyID = gPlayerInteriors[playerid][PropertyArrayID];

		format(partial, sizeof(partial), "\n%s\t%d\t%d", gDrugz[i][DrugName], gPlayers[playerid][Drugs][i], gProperties[propertyID][Drugs][i]);
		strcat(stringToPrint, partial, sizeof(stringToPrint));
	}

	ShowPlayerDialog(playerid, DIALOG_PROPERTY_DRUGZ, DIALOG_STYLE_TABLIST_HEADERS, "Drugz", stringToPrint, "Prevest", "Zrusit");
}

