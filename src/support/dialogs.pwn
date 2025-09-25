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
	DIALOG_COMMON_CMDS
};

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

stock ShowCommonCommandsDialog(playerid)
{
	new stringToPrint[2048];

	format(stringToPrint, sizeof(stringToPrint), "Common Commands\n\n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
    			"/acc\t\t\tgame account info dump\n",
			"/admins\t\t\tlists admins online\n",
			"/afk\t\t\t(un)sets the Away-From-Keyboard state\n",
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
			"/pm ID TEXT\t\tsends the private message to other player ($10)\n",
			"/port ID\t\t\tenables to warp to special location IDs on map\n",
			"/property SUBCMD ID\tlists subcommands for property ID handling\n",
			"/race SUBCMD ID\tlists subcommands for racing module\n",

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
