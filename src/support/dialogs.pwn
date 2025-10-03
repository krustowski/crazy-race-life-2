//
//  Everything dialogs.
//

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
	DIALOG_ADMIN_CMDS,
	DIALOG_COMMON_CMDS,
	DIALOG_ADMINS_ONLINE,
	DIALOG_PLAYER_DRUGZ,
	DIALOG_RACE_LIST,
	DIALOG_PROPERTY_LIST,
	DIALOG_PROPERTY_OPTIONS,
	DIALOG_BANK_OPTIONS,
	DIALOG_BANK_DEPOSIT,
	DIALOG_BANK_WITHDRAW,
	DIALOG_PORT_LIST,
	DIALOG_TRUCKING_POINT_LIST,
	DIALOG_PROPERTY_EDITOR_LIST,
	DIALOG_RACE_OPTIONS,
	DIALOG_GET_LIST,
	DIALOG_GOTO_LIST,
	DIALOG_PLAYER_CLICKED_LIST,
	DIALOG_PLAYER_SKIN_ID_SET,
	DIALOG_PLAYER_DRUNK_LEVEL_SET,
	DIALOG_PLAYER_WEAPON_SET,
	DIALOG_PLAYER_FAKECHAT,
	DIALOG_PLAYER_ADMIN_LEVEL_SET,
	DIALOG_DEATHMATCH_OPTIONS,
	DIALOG_PHONE_OPTIONS,
	DIALOG_PHONE_PM_PLAYER_LIST,
	DIALOG_PHONE_PM_TEXT,
	DIALOG_PLAYER_ACCOUNT,
	DIALOG_HELP_LIST,
	DIALOG_SERVER_RULES,
	DIALOG_EDITOR_LIST,
	DIALOG_RACE_EDITOR_MAIN,
	DIALOG_RACE_EDITOR_LIST,
	DIALOG_RACE_EDITOR_OPTIONS
};

#include "modules/real.pwn"

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

	format(stringToPrint, sizeof(stringToPrint), "%s\nLevel 4\n\n%s%s%s%s%s%s%s%s",
			stringToPrint,
			"/ban ID\t\t\tbans the player ID (via IP)\n",
			"/edit\t\t\tshows a dialog window with all common editors\n",
			"/fakechat ID TEXT\tsends the fake chat TEXT as the player ID\n",
			"/lvl pID LVL\t\tsets the Admin LVL to player ID\n",
			"/predit ID\t\tstarts the property editor for property ID\n",
			"/redit ID\t\t\tstarts the race editor for race ID\n",
			"/restart\t\t\tsets the countdown for 60 seconds to restart the server\n",
			"/tredit ID\t\tstarts the Trucking editor for point ID\n"
		);

	return ShowPlayerDialog(playerid, DIALOG_ADMIN_CMDS, DIALOG_STYLE_MSGBOX, "Admin Commands", stringToPrint, "Close", "");
}

stock ShowCommonCommandsDialog(playerid)
{
	new stringToPrint[2048];

	format(stringToPrint, sizeof(stringToPrint), "Common Commands\n\n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
    			"/acc\t\t\tgame account info dump\n",
			"/admins\t\t\tlists admins online\n",
			"/afk\t\t\t(un)sets the Away-From-Keyboard state\n",
			"/animoff\t\tclears all animations\n",
			"/bank SUBCMD\t\tlists banking subcommands\n",

			"/cmd\t\t\tlists available commands for player (this dialog)\n",
			"/dance ID\t\tenables special animations (dancing)\n",
			"/deathmatch SUBCMD\tlists subcommands for the deathmatch module\n",
			"/drugz\t\t\tlists substances in pockets\n",
			"/dwarp\t\t\tteleports the player in vehicle to racing the common location\n",

			"/fix\t\t\trepairs the player's vehicle\n",
			"/givecash ID CASH\tsends cash to other player\n",
			"/help\t\t\tlists helper information\n",
			"/kill\t\t\tto commit suicide\n",
			"/lay\t\t\tenables special animations (laying)\n",

			"/locate\t\t\tdumps the actual player's coordinates\n",
			"/lock\t\t\tlocks the player's vehicle\n",
			"/phone\t\t\tshows the phone call menu\n",
			"/pm ID TEXT\t\tsends the private message to other player ($10)\n",
			"/port\t\t\tenables to warp to special locations on map\n",

			"/property\t\tlists subcommands for property ID handling\n",
			"/race\t\t\tlists subcommands for racing module\n",
			"/rules\t\t\tdumps the server rules information\n",
			"/scores\t\t\tshows the High Scores table\n",
			"/skydive\t\tenables to skydive from random locations\n",

			"/text ID TEXT\t\tsends a public message to other player\n",
			"/tiki\t\t\tdumps the information about Tiki prizes\n",
			"/truck\t\t\tenables/disables the Trucking missions\n",
			"/unlock\t\t\tunlocks the player's vehicle\n",
			//
			"\nSpecial Team-related Commands\n\n",
			//
			"/deal ID\t\t\tlists subcommands for dealerz\n",
			"/hide\t\t\t(un)hides the player on map\n",
			"/search ID SUBCMD\tspecial command for Policemen to search and pre-jail a player by ID\n",
			"/wanted\t\t\tshows the wanted list of online players\n"
		);

	return ShowPlayerDialog(playerid, DIALOG_COMMON_CMDS, DIALOG_STYLE_MSGBOX, "Commands", stringToPrint, "Close", "");
}

stock ShowAdminsOnlineDialog(playerid)
{
	new adminCount = 0, stringToPrint[512];

	format(stringToPrint, sizeof(stringToPrint), "");

	for (new i = 0; i < MAX_PLAYERS; i++) 
	{
		// IsPlayerAdmin(i) == RCON admin
		if (IsPlayerConnected(i) && (gPlayers[i][AdminLevel] > 0 || IsPlayerAdmin(i)))
		{
			adminCount++;

			new adminName[MAX_PLAYER_NAME];

			// Omit RCON admin(s) in the output for now...
			if (gPlayers[i][AdminLevel] > 0) 
			{
				GetPlayerName(i, adminName, sizeof(adminName));
				format(stringToPrint, sizeof(stringToPrint), "%s[ID: %2d]\t%24s \t\tLevel: %d\n", stringToPrint, i, adminName, gPlayers[i][AdminLevel]);
			}
		}
	}

	if (!adminCount) 
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "[ ! ] No admin online!");
	}

	return ShowPlayerDialog(playerid, DIALOG_ADMINS_ONLINE, DIALOG_STYLE_MSGBOX, "Admins Online", stringToPrint, "Close", "");
}

stock ShowPlayerPocketDrugzDialog(playerid)
{
	new stringToPrint[512] = "Substance/stuff\tIn pockets";

	for (new i = 0; i < MAX_DRUGS; i++)
	{
		new partial[64];

		format(partial, sizeof(partial), "\n%s\t%d", gDrugz[i][DrugName], gPlayers[playerid][Drugs][i]);
		strcat(stringToPrint, partial, sizeof(stringToPrint));
	}

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_DRUGZ, DIALOG_STYLE_TABLIST_HEADERS, "Pocket Drugz and Stuff", stringToPrint, "Use", "Cancel");
}

stock ShowRaceListDialog(playerid)
{
	new stringToPrint[512] = "Race ID and Name\tCost ($)\tPrize ($)";

	for (new i = 1; i < MAX_RACE_COUNT; i++)
	{
		if (gRaces[i][CostDollars] == 0)
			continue;

		format(stringToPrint, sizeof(stringToPrint), "%s\n%2d: %s\t%d\t%d", stringToPrint, i, gRaces[i][Name], gRaces[i][CostDollars], gRaces[i][PrizeDollars]);
	}

	return ShowPlayerDialog(playerid, DIALOG_RACE_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Race List", stringToPrint, "Join", "Cancel");
}

stock ShowPropertyListDialog(playerid)
{
	new stringToPrint[256] = "Property Name\tID";

	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		new arrayId = GetPropertyArrayIDfromID(gPlayers[playerid][Properties][i]);

		if (arrayId <= 0 || !gPlayers[playerid][Properties][i]) 
			continue;

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%5d", 
				stringToPrint,
				gProperties[arrayId][Label], 
				gPlayers[playerid][Properties][i]
		      );
	}

	return ShowPlayerDialog(playerid, DIALOG_PROPERTY_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Property List", stringToPrint, "Select", "Cancel");
}

stock ShowPropertyOptionsDialog(playerid)
{
	new propertyName[64];
        format(propertyName, sizeof(propertyName), "%s", gProperties[ GetPropertyArrayIDfromID( gPlayers[playerid][Temp] ) ][Label]);

	return ShowPlayerDialog(playerid, DIALOG_PROPERTY_OPTIONS, DIALOG_STYLE_LIST, propertyName, "Set spawn point\nAttach new vehicle\nSell property", "Select", "Cancel");
}

stock ShowBankOptionsDialog(playerid)
{
	return ShowPlayerDialog(playerid, DIALOG_BANK_OPTIONS, DIALOG_STYLE_LIST, "Banking", "Deposit money\nWithdraw money\nAccount balance", "Select", "Cancel");
}

stock ShowBankDepositDialog(playerid)
{
	return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "Banking", "Entry cash amount ($) to deposit to your account:", "Deposit", "Cancel");
}

stock ShowBankWithdrawDialog(playerid)
{
	return ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "Banking", "Entry cash amount ($) to withdraw from account:", "Withdraw", "Cancel");
}

stock ShowPortListDialog(playerid)
{
	new portList[256];

	format(portList, sizeof(portList), "%s\n%s",
			"Las Venturas Escalators",
			"San Fierro WangCars"
		);

	return ShowPlayerDialog(playerid, DIALOG_PORT_LIST, DIALOG_STYLE_LIST, "Port List", portList, "Port", "Cancel");
}

#include "modules/trucking.pwn"

stock ShowTruckingPointListDialog(playerid)
{
	new stringToPrint[1024] = "Point Name\tID";

	for (new i = 0; i < MAX_TRUCKING_POINTS; i++)
	{
		if (!gTruckingPoints[i][Type] || !gTruckingPoints[i][ID])
			continue;

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				gTruckingPoints[i][Name],
				gTruckingPoints[i][ID]
			);
	}

	return ShowPlayerDialog(playerid, DIALOG_TRUCKING_POINT_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Trucking Points", stringToPrint, "Edit", "Cancel");
}

stock ShowPropertyEditorListDialog(playerid)
{
	new stringToPrint[2048] = "Property Name\tID";

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (!gProperties[i][ID])
			continue;

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				gProperties[i][Label],
				gProperties[i][ID]
			);
	}

	return ShowPlayerDialog(playerid, DIALOG_PROPERTY_EDITOR_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Property Editor", stringToPrint, "Edit", "Cancel");
}

stock ShowRaceEditorListDialog(playerid)
{
	new stringToPrint[1024] = "Race Name\tID";

	for (new i = 0; i < MAX_RACE_COUNT; i++)
	{
		if (!strcmp(gRaces[i][Name], ""))
		{
			continue;
		}

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				gRaces[i][Name],
				gRaces[i][ID]
			);
	}

	return ShowPlayerDialog(playerid, DIALOG_RACE_EDITOR_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Race Editor", stringToPrint, "Edit", "Cancel");
}

stock ShowRaceOptionsDialog(playerid, raceid)
{
	new title[70];
	format(title, sizeof(title), "Race '%s'", gRaces[raceid][Name]);

	return ShowPlayerDialog(playerid, DIALOG_RACE_OPTIONS, DIALOG_STYLE_LIST, title, "Exit race", "Select", "Cancel");
}

stock ShowGetPlayerListDialog(playerid)
{
	new stringToPrint[512] = "Name\tID";

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(i, playerName);

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				playerName,
				i
		      );
	}

	return ShowPlayerDialog(playerid, DIALOG_GET_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Player List", stringToPrint, "Get", "Cancel");
}

stock ShowGotoPlayerListDialog(playerid)
{
	new stringToPrint[1024] = "Name\tID";

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(i, playerName);

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				playerName,
				i
		      );
	}

	return ShowPlayerDialog(playerid, DIALOG_GOTO_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Player List", stringToPrint, "Goto", "Cancel");
}

stock ShowPlayerClickedDialog(playerid, clickedplayerid)
{
	new playerName[MAX_PLAYER_NAME], stringToPrint[512], title[MAX_PLAYER_NAME + 17];

	if (!IsPlayerConnected(clickedplayerid) || gPlayers[playerid][AdminLevel] < 1)
		return 1;

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	gPlayers[playerid][Temp] = clickedplayerid;

	format(stringToPrint, sizeof(stringToPrint), "%s\n%s",
			"Set 100 HP + armour",
			"Install nitro"
		);

	if (gPlayers[playerid][AdminLevel] < 2)
	{
		return ShowPlayerDialog(playerid, DIALOG_PLAYER_CLICKED_LIST, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
	}

	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s\n%s",
			stringToPrint,
			"Port (get) the player",
			"Port (goto) to the player",
			"Set skin ID"
	      );

	if (gPlayers[playerid][AdminLevel] < 3)
	{
		return ShowPlayerDialog(playerid, DIALOG_PLAYER_CLICKED_LIST, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
	}

	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
			stringToPrint,
			"Set drunk level",
			"Kick from server",
			"Print the packet loss",
			"Reset cash money",
			"Spectate",
			"Give weapons",
			"Give a specific weapon"
	      );

	if (gPlayers[playerid][AdminLevel] < 4)
	{
		return ShowPlayerDialog(playerid, DIALOG_PLAYER_CLICKED_LIST, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
	}

	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s\n%s",
			stringToPrint,
			"Ban",
			"Send fakechat",
			"Set admin level"
	      );

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_CLICKED_LIST, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
}

stock ShowPlayerSkinIDSetDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	new clickedplayerid = gPlayers[playerid][Temp];

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_SKIN_ID_SET, DIALOG_STYLE_INPUT, title, "Set player skin ID (0-311):", "Set", "Cancel");
}

stock ShowPlayerDrunkLevelSetDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	new clickedplayerid = gPlayers[playerid][Temp];

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_DRUNK_LEVEL_SET, DIALOG_STYLE_INPUT, title, "Set player drunk level (0-50000):", "Set", "Cancel");
}

stock ShowPlayerAdminLevelSetDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	new clickedplayerid = gPlayers[playerid][Temp];

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_ADMIN_LEVEL_SET, DIALOG_STYLE_INPUT, title, "Set player admin level (0-5):", "Set", "Cancel");
}

stock ShowPlayerGiveWeaponDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	new clickedplayerid = gPlayers[playerid][Temp];

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_WEAPON_SET, DIALOG_STYLE_INPUT, title, "Give player a specific weapon model (0-46):", "Set", "Cancel");
}

stock ShowPlayerFakechatDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	new clickedplayerid = gPlayers[playerid][Temp];

	GetPlayerName(clickedplayerid, playerName);
	format(title, sizeof(title), "Player '%s' Options", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_FAKECHAT, DIALOG_STYLE_INPUT, title, "Set a message to be send as a fakechat as clicked player ID:", "Send", "Cancel");
}

#include "modules/deathmatch.pwn"

stock ShowDeathmatchOptionsDialog(playerid)
{
	new stringToPrint[256];

	if (!gDeathmatch[playerid][IsRegistered] && !gDeathmatch[playerid][InGame])
	{
		format(stringToPrint, sizeof(stringToPrint), "%s",
				"Register to Deathmatch"
		      );

		return ShowPlayerDialog(playerid, DIALOG_DEATHMATCH_OPTIONS, DIALOG_STYLE_LIST, "Deathmatch Options", stringToPrint, "Select", "Cancel");
	}

	format(stringToPrint, sizeof(stringToPrint), "%s",
			"Leave Deathmatch"
	      );

	return ShowPlayerDialog(playerid, DIALOG_DEATHMATCH_OPTIONS, DIALOG_STYLE_LIST, "Deathmatch Options", stringToPrint, "Select", "Cancel");
}

stock ShowPhoneOptionsDialog(playerid)
{
	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s\n%s\n%s",
			"Check Bank account balance",
			"Send SMS to player",
			"Call Taxi",
			"Call Car mechanic",
			"Call Pizza delivery"
		);

	return ShowPlayerDialog(playerid, DIALOG_PHONE_OPTIONS, DIALOG_STYLE_LIST, "Phone Operations List", stringToPrint, "Select", "Cancel");
}

stock ShowPhonePMPlayerListDialog(playerid)
{
	new stringToPrint[512] = "Name\tID";

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
			continue;

		new playerName[MAX_PLAYER_NAME];
		GetPlayerName(i, playerName);

		format(stringToPrint, sizeof(stringToPrint), "%s\n%s\t%d",
				stringToPrint,
				playerName,
				i
		      );
	}

	return ShowPlayerDialog(playerid, DIALOG_PHONE_PM_PLAYER_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Players List", stringToPrint, "Select", "Cancel");
}

stock ShowPhonePMTextDialog(playerid, clickedplayerid)
{
	new playerName[MAX_PLAYER_NAME], title[128];

	gPlayers[playerid][Temp] = clickedplayerid;

	GetPlayerName(clickedplayerid, playerName, sizeof(playerName));
	format(title, sizeof(title), "New PM to '%s'", playerName);

	return ShowPlayerDialog(playerid, DIALOG_PHONE_PM_TEXT, DIALOG_STYLE_INPUT, title, "Write a new PM to selected player:", "Send", "Cancel");
}

stock ShowPlayerAccountDialog(playerid)
{
	new stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "Account details:\n\n{FFFFFF}Cash: \t\t{00FF00}${FFD700}%d{FFFFFF}\nTeam: \t\t{FFD700}%s{FFFFFF} (ID: {FFD700}%d{FFFFFF})\nSkin ID:\t\t{FFD700}%d{FFFFFF}\nAdmin level: \t{FFD700}%d{FFFFFF}\nWanted level: \t{FFD700}%d{FFFFFF}",
			GetPlayerMoney(playerid),
			gTeams[ gPlayers[playerid][TeamID] ][TeamName],
			gPlayers[playerid][TeamID],
			GetPlayerSkin(playerid),
			gPlayers[playerid][AdminLevel],
			GetPlayerWantedLevel(playerid)
	      );

	return ShowPlayerDialog(playerid, DIALOG_PLAYER_ACCOUNT, DIALOG_STYLE_MSGBOX, "Player Account Info", stringToPrint, "Close", "");
}

stock ShowServerHelpListDialog(playerid)
{
	new stringToPrint[256];
	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s",
			"Show Player Commands",
			"Show Admin Commands",
			"Show Server Rules"
		);

	return ShowPlayerDialog(playerid, DIALOG_HELP_LIST, DIALOG_STYLE_LIST, "Server Help List", stringToPrint, "Select", "Close");
}

stock ShowServerRulesDialog(playerid)
{
	new stringToPrint[512];
	format(stringToPrint, sizeof(stringToPrint), "Game Server Rules\n\n1. No Carkill, Helikill, or Bikekill\n2. No Minigun or Jetpack usage\n3. No Cheating\n\nAnti-Cheat filterscript enabled (cheating => kick, or ban)");

	return ShowPlayerDialog(playerid, DIALOG_SERVER_RULES, DIALOG_STYLE_MSGBOX, "Server Rules", stringToPrint, "Close", "");
}

stock ShowGameEditorListDialog(playerid)
{
	new stringToPrint[256];
	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s",
			"Property Editor",
			"Trucking Editor",
			"Race Editor"
		);

	return ShowPlayerDialog(playerid, DIALOG_EDITOR_LIST, DIALOG_STYLE_LIST, "Game Editors", stringToPrint, "Select", "Cancel");
}

stock ShowRaceEditorMainDialog(playerid)
{
	new stringToPrint[128];
	format(stringToPrint, sizeof(stringToPrint), "%s\n%s",
			"Draft New Race",
			"List Existing Races"
		);

	return ShowPlayerDialog(playerid, DIALOG_RACE_EDITOR_MAIN, DIALOG_STYLE_LIST, "Race Editor", stringToPrint, "Select", "Cancel");
}

stock ShowRaceEditorOptionsDialog(playerid, raceid)
{
	new title[70];
	format(title, sizeof(title), "Race '%s'", gRaces[raceid][Name]);

	new stringToPrint[256];
	format(stringToPrint, sizeof(stringToPrint), "%s\n%s\n%s\n%s\n%s",
			"Change Name",
			"Change Cost in Dollars",
			"Change Prize in Dollars",
			"Change Start Coords",
			"Record New Race Track/Path"
		);

	return ShowPlayerDialog(playerid, DIALOG_RACE_EDITOR_OPTIONS, DIALOG_STYLE_LIST, title, stringToPrint, "Select", "Cancel");
}

stock ShowRaceEditorNameChangeDialog(playerid)
{}

stock ShowRaceEditorCostChangeDialog(playerid)
{}

stock ShowRaceEditorPrizeChangeDialog(playerid)
{}
