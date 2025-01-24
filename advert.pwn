public ShowAdvert()
{
	new advertList[][] =
	{
		"[ TIP ] Pro zobrazeni zakladniho seznamu prikazu pouzij /cmd",
		"[ TIP ] Pro okamzitou sebevrazdu napis /kill",
		"[ TIP ] Ve meste LS a jeho okoli byly ukryty tajne predmety (male zelene sosky), pro vice informaci /soska",
		"[ INFO ] Hostovano a sponzorovano organizaci vxn.dev",
		"[ TIP ] Zahrej si deathmatch spolu s kamarady ve specialni arene: /deathmatch [join/exit]",
		"[ TIP ] Hotovost nevydrzi vecne (umrti, uraz apod), sver sve finance bance!",
		"[ TIP ] Nevahej a vyuzij pestre nabidky zavodu! Pro vice informaci pouzij /race list"
	};

	new advertId = random(sizeof(advertList)), stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "%s", advertList[advertId]);
	SendClientMessageToAll(COLOR_BILA, stringToPrint);

	return 1;
}

