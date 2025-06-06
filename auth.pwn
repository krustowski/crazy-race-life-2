//
//  auth.pwn
//

#include "dialogs.pwn"

stock SetPlayerAccountLogin(playerid, const text[])
{
	new hashedPwd[65], hashedPwdDb[65], saltDb[17];

	new query[256];

	format(query, sizeof(query), "SELECT pwdhash, salt FROM users WHERE nickname = '%s'", gPlayers[playerid][Name]);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch user data!");
		return 0;
	}

	DB_GetFieldString(result, 0, hashedPwdDb, sizeof(hashedPwdDb));
	DB_GetFieldString(result, 1, saltDb, sizeof(saltDb));

	DB_FreeResultSet(result);

	SHA256_Hash(text, saltDb, hashedPwd, sizeof(hashedPwd));

	if (strcmp(hashedPwd, hashedPwdDb))
	{
		SystemMsg(playerid, "[ AUTH ] Spatne heslo! Zkuste znovu!");
		return 0;
	}

	gPlayers[playerid][IsLogged] = true;
	LoadPlayerData(playerid);

	SpawnPlayer(playerid);

	return 1;
}

stock SetPlayerAccountRegistration(playerid, const text[])
{
	new hashedPwd[65], salt[17];

	if (fexist(gPlayers[playerid][Name]))
		return 0;

	// 16 random characters from 33 to 126 (in ASCII) for the salt
	for (new i = 0; i < 16; i++) 
		salt[i] = random(94) + 33;

	SHA256_Hash(text, salt, hashedPwd, sizeof(hashedPwd));

	writecfg(gPlayers[playerid][Name], "", "pwdhash", hashedPwd);
	writecfg(gPlayers[playerid][Name], "", "salt", salt);
	writecfgvalue(gPlayers[playerid][Name], "", "health", 100);

	gPlayers[playerid][IsLogged] = true;
	LoadPlayerData(playerid);

	SetPlayerHealth(playerid, 100.0);
	SpawnPlayer(playerid);

	return 1; 
}

stock ShowAuthDialog(playerid)
{
	new query[256];
	new stringToPrint[128];

	format(query, sizeof(query), "SELECT pwdhash, salt FROM users WHERE nickname = '%s'", gPlayers[playerid][Name]);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (result) {
		DB_FreeResultSet(result);
		format(stringToPrint, sizeof(stringToPrint), "Ucet hrace (%s) je jiz registrovan. Prihlas se zadanim sveho hesla nize:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", stringToPrint, "Login", "Zrusit");

		// from now on, the player has 30 seconds to login
	 	//Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
	}
	else 
	{
		DB_FreeResultSet(result);
		format(stringToPrint, sizeof(stringToPrint), "Vitej %s! Zaregistruj svuj ucet zadanim sveho hesla nize:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registrace", stringToPrint, "Registrovat", "Zrusit");
	}

	return 1;
}
