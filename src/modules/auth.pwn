//
//  auth.pwn
//

#include "support/dialogs.pwn"

// SetPlayerAccountLogin sets the IsLogged Player value to 'true' if the <text> input, hashed, is equal to the hash stored in database.
stock SetPlayerAccountLogin(playerid, const text[])
{
	new hashedPwd[65], hashedPwdDb[65], saltDb[17], query[256];

	// Fetch the sha256 hash and salt from DB
	format(query, sizeof(query), "SELECT id, pwdhash, salt FROM users WHERE nickname = '%s'", gPlayers[playerid][Name]);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot fetch user data!");
		return 0;
	}

	DB_GetFieldStringByName(result, "pwdhash", hashedPwdDb, sizeof(hashedPwdDb));
	DB_GetFieldStringByName(result, "salt", saltDb, sizeof(saltDb));

	// Keep the ORM ID for further transactions
	gPlayers[playerid][OrmID] = DB_GetFieldIntByName(result, "id");

	DB_FreeResultSet(result);

	// Hash the input and compare it with the saved pwd fingerprint
	SHA256_Hash(text, saltDb, hashedPwd, sizeof(hashedPwd));

	if (strcmp(hashedPwd, hashedPwdDb))
	{
		SystemMsg(playerid, "[ AUTH ] Wrong password, try again!");
		return 0;
	}

	gPlayers[playerid][IsLogged] = true;

	LoadPlayerData(playerid);
	LoadPlayerProperties(playerid);

	SpawnPlayer(playerid);

	return 1;
}

stock SetPlayerAccountRegistration(playerid, const text[])
{
	new hashedPwd[65], salt[17];

	// 16 random characters from 33 to 126 (in ASCII) for the salt
	for (new i = 0; i < 16; i++) 
		salt[i] = random(94) + 33;

	SHA256_Hash(text, salt, hashedPwd, sizeof(hashedPwd));

	new query[512];
	format(query, sizeof(query), "INSERT INTO users (nickname, pwdhash, salt, cash, bank, adminlvl, wanted, team, class, health, armour, spawn, properties) VALUES ('%s', '%s', '%s', %d, %d, %d, %d, %d, %d, %.2f, %.2f, %d, '%s');", 
			gPlayers[playerid][Name], 
			hashedPwd, 
			salt, 
			5000, 
			0, 
			0, 
			0, 
			0, 
			0, 
			100.0, 
			100.0, 
			0, 
			"0,0,0,0,0"
	);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot write (register) user data!");
		return 0;
	}

	DB_FreeResultSet(result);

	format(query, sizeof(query), "SELECT id FROM users WHERE nickname = '%s'", gPlayers[playerid][Name]);

	result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result) {
		print("Database error: cannot read (register) user data!");
		return 0;
	}

	gPlayers[playerid][OrmID] = DB_GetFieldIntByName(result, "id");

	DB_FreeResultSet(result);

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

	if (DB_GetRowCount(result)) {
		DB_FreeResultSet(result);
		format(stringToPrint, sizeof(stringToPrint), "Player (%s) has already registered their account. Log-in using your password:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", stringToPrint, "Log-in", "Cancel");

		// from now on, the player has 30 seconds to login
	 	//Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
	}
	else 
	{
		DB_FreeResultSet(result);
		format(stringToPrint, sizeof(stringToPrint), "Welcome %s! Register your account by entering a password:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registeration", stringToPrint, "Register", "Cacnel");
	}

	return 1;
}
