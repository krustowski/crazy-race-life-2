//
//  auth.pwn
//

enum
{
	DIALOG_UNUSED,
	DIALOG_LOGIN,
	DIALOG_REGISTER
};

public SetPlayerAccountLogin(playerid, text[])
{
	new hashedPwd[65], hashedPwdDb[65], saltDb[17];

	readcfg(gPlayers[playerid][Name], "", "pwdhash", hashedPwdDb);
	readcfg(gPlayers[playerid][Name], "", "salt", saltDb);

	SHA256_PassHash(text, saltDb, hashedPwd, sizeof(hashedPwd));

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

public SetPlayerAccountRegistration(playerid, text[])
{
	new hashedPwd[65], salt[17];

	if (fexist(gPlayers[playerid][Name]))
		return 0;

	// 16 random characters from 33 to 126 (in ASCII) for the salt
	for (new i = 0; i < 16; i++) 
		salt[i] = random(94) + 33;

	SHA256_PassHash(text, salt, hashedPwd, sizeof(hashedPwd));

	writecfg(gPlayers[playerid][Name], "", "pwdhash", hashedPwd);
	writecfg(gPlayers[playerid][Name], "", "salt", salt);
	writecfgvalue(gPlayers[playerid][Name], "", "health", 100);

	gPlayers[playerid][IsLogged] = true;
	LoadPlayerData(playerid);

	SetPlayerHealth(playerid, 100.0);
	SpawnPlayer(playerid);

	return 1; 
}

public ShowAuthDialog(playerid)
{
	new stringToPrint[128];

	if (fexist(gPlayers[playerid][Name]))
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AUTH ] Ucet hrace (%s) je jiz registrovan. Prihlas se pomoci dialogu nize:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", stringToPrint, "Login", "Zrusit");

		// from now on, the player has 30 seconds to login
		//Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
	}
	else
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AUTH ] Vitej %s! Zaregistruj svuj ucet zadanim sveho hesla nize:", gPlayers[playerid][Name]);

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registrace", stringToPrint, "Registrovat", "Zrusit");
	}

	return 1;
}
