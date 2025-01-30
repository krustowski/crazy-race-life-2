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
	new hashedPwd[65], hashedPwdDb[65], playerName[MAX_PLAYER_NAME], saltDb[17];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	readcfg(playerName, "", "pwdhash", hashedPwdDb);
	readcfg(playerName, "", "salt", saltDb);

	SHA256_PassHash(text, saltDb, hashedPwd, sizeof(hashedPwd));

	if (strcmp(hashedPwd, hashedPwdDb))
	{
		SystemMsg(playerid, "[ AUTH ] Spatne heslo! Zkuste znovu!");
		return 0;
	}

	gPlayerAuth[playerid] = true;
	LoadPlayerData(playerid);

	SpawnPlayer(playerid);

	return 1;
}

public SetPlayerAccountRegistration(playerid, text[])
{
	new hashedPwd[65], playerName[MAX_PLAYER_NAME], salt[17];

	GetPlayerName(playerid, playerName, sizeof(playerName));
	
	if (fexist(playerName))
		return 0;

	// 16 random characters from 33 to 126 (in ASCII) for the salt
	for (new i = 0; i < 16; i++) 
		salt[i] = random(94) + 33;

	SHA256_PassHash(text, salt, hashedPwd, sizeof(hashedPwd));

	writecfg(playerName, "", "pwdhash", hashedPwd);
	writecfg(playerName, "", "salt", salt);
	writecfgvalue(playerName, "", "health", 100);

	gPlayerAuth[playerid] = true;
	LoadPlayerData(playerid);

	SetPlayerHealth(playerid, 100.0);

	SpawnPlayer(playerid);

	return 1; 
}

public ShowAuthDialog(playerid)
{
	new playerName[MAX_PLAYER_NAME], stringToPrint[128];

	GetPlayerName(playerid, playerName, sizeof(playerName));

	if (fexist(playerName))
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AUTH ] Ucet hrace (%s) je jiz registrovan. Prihlas se pomoci dialogu nize:", gPlayerData[playerid][E_PLAYER_DATA_NAME]);

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", stringToPrint, "Login", "Zrusit");

		// from now on, the player has 30 seconds to login
		//Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
	}
	else
	{
		format(stringToPrint, sizeof(stringToPrint), "[ AUTH ] Vitej %s! Zaregistruj svuj ucet zadanim sveho hesla nize:", gPlayerData[playerid][E_PLAYER_DATA_NAME]);

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registrace", stringToPrint, "Registrovat", "Zrusit");
	}

	return 1;
}
