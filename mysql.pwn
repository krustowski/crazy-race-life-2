#include <a_mysql>
#include "player.pwn"

#define MYSQL_HOST	"mariadb"
#define MYSQL_PORT	3306
#define MYSQL_USER	"samp_gg_vxn_dev"
#define MYSQL_DATABASE	"samp_gg_vxn_dev"
#define MYSQL_PASSWORD  "sd4f4a65f4sa65f4as8f7as9f7as9df7"

new MySQL: gSQL;

new gMySQLRaceCheck[MAX_PLAYERS];

enum
{
	DIALOG_UNUSED,
	DIALOG_LOGIN,
	DIALOG_REGISTER
};

//
//
//

public InitDB()
{
	new MySQLOpt: optionId = mysql_init_options();

	mysql_set_option(optionId, AUTO_RECONNECT, true);

	gSQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, optionId);
	if (gSQL == MYSQL_INVALID_HANDLE || mysql_errno(gSQL) != 0)
	{
		printf(" * MySQL connection failed. Shutting down the server.");
		SendRconCommand("exit");
		return 1;
	}

	printf(" * MySQL connection successful.");

	SetupPlayerTable();

	return 1;
}

stock LoadPlayerDataDB(playerid)
{
	gMySQLRaceCheck[playerid]++;

	new ORM: ormId = gPlayers[playerid][E_PLAYER_DATA_ORM] = orm_create("players", gSQL);

	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_ID], "id");
	orm_addvar_string(ormId, 	gPlayers[playerid][E_PLAYER_DATA_NAME], MAX_PLAYER_NAME, "username");
	orm_addvar_string(ormId, 	gPlayers[playerid][E_PLAYER_DATA_PWD_HASH], 65, "password");
	orm_addvar_string(ormId, 	gPlayers[playerid][E_PLAYER_DATA_SALT], 17, "salt");
	orm_addvar_float(ormId, 	gPlayers[playerid][E_PLAYER_DATA_HEALTH], "health");
	orm_addvar_float(ormId, 	gPlayers[playerid][E_PLAYER_DATA_ARMOUR], "armour");
	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_CASH], "cash");
	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_BANK], "bank");
	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_ADMIN_LVL], "admin_lvl");
	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_TEAM], "team");
	orm_addvar_int(ormId, 		gPlayers[playerid][E_PLAYER_DATA_CLASS], "class");

	orm_setkey(ormId, "username");

	orm_load(ormId, "OnPlayerDataLoaded", "dd", playerid, gMySQLRaceCheck[playerid]);
}

/*public OnPlayerDataLoaded(playerid, raceCheck)
{
	if (raceCheck != gMySQLRaceCheck[playerid]) 
		return Kick(playerid);

	orm_setkey(gPlayers[playerid][E_PLAYER_DATA_ORM], "id");

	new stringToPrint[128];

	switch (orm_errno(gPlayers[playerid][E_PLAYER_DATA_ORM]))
	{
		case ERROR_OK:
		{
			format(stringToPrint, sizeof(stringToPrint), "[ AUTH ] Ucet hrace (%s) je jiz registrovan. Prihlas se pomoci dialogu nize:", gPlayers[playerid][E_PLAYER_DATA_NAME]);

			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", stringToPrint, "Login", "Zrusit");

			// from now on, the player has 30 seconds to login
			//Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
		}
		case ERROR_NO_DATA:
		{
			format(stringToPrint, sizeof(stringToPrint), "Vitej %s! Zaregistruj svuj ucet zadanim sveho hesla nize:", gPlayers[playerid][E_PLAYER_DATA_NAME]);

			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registrace", stringToPrint, "Registrovat", "Zrusit");
		}
	}

	return 1;
}

public OnPlayerRegister(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Registrace", "Registrace probehla uspesne, prihlaseni probehlo automaticky.", "Ok", "");

	gPlayerAuth[playerid] = 1;

	SpawnPlayer(playerid);

	return 1;
}

stock UpdatePlayerData(playerid)
{
	gMySQLRaceCheck[playerid]++;

	// orm_save sends an UPDATE query
	orm_save(gPlayers[playerid][E_PLAYER_DATA_ORM]);
	return 1;
}*/

stock SetupPlayerTable()
{
	mysql_tquery(gSQL, "CREATE TABLE IF NOT EXISTS `players` (`id` int(11) NOT NULL AUTO_INCREMENT,`username` varchar(24) NOT NULL,`password` char(64) NOT NULL,`salt` char(16) NOT NULL,`kills` mediumint(8) NOT NULL DEFAULT '0',`deaths` mediumint(8) NOT NULL DEFAULT '0',`x` float NOT NULL DEFAULT '0',`y` float NOT NULL DEFAULT '0',`z` float NOT NULL DEFAULT '0',`angle` float NOT NULL DEFAULT '0',`interior` tinyint(3) NOT NULL DEFAULT '0', PRIMARY KEY (`id`), UNIQUE KEY `username` (`username`))");
	return 1;
}
