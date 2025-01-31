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
		"[ TIP ] Nevahej a vyuzij pestre nabidky zavodu! Pro vice informaci pouzij /race list",
		"[ TIP ] Pokud jsi uvizl v zavodu, muzes ho opustit pomoci /race exit",
		"[ TIP ] Po prihlaseni do jakehokoliv zavodu lze hodit warp ke startu pomoci /race warp",
		"[ TIP ] Po mape se lze volne premistovat pomoci /port [ID lokace], nelze vsak takto cestovat ve vozidle",
		"[ TIP ] Malo penez? Sezen motorku a delej stunty, ktere jsou kdekoliv financne ohodnoceny!",
		"[ GAME ] Ve meste SF a na venkove byly ukryty balicky s ilegalnim obsahem. Pritomnost tahoveho obsahu u hrace muze byt potrestan clenem tymu Policistu!",
		"[ GAME ] Distribuovat (i)legalni substance muze pouze clen tymu Dealeru",
		"[ GAME ] Policiste muzou kohokoliv ve sve blizkosti zastavit a prohledat na ilegalni latky!",
		"[ GAME ] Muzes vlastnit az 3 nemovitosti v lokalitach oznacenych na mape zelenym domkem",
		"[ GAME ] Substance ci propriety zakoupene u clena tymu Dealeru lze ulozit pouze ve vlastnim dome, jinak je treba je mit u sebe!",
		"[ GAME ] Ilegalni substance lze obchodovat i na cernem trhu. Existuje vsak sance, ze na sebe privolas pozornost zvysenim Wanted levelu!",
		"[ TIP ] Skoc si skidive pomoci /skidive!"
	};

	new advertId = random(sizeof(advertList)), stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "%s", advertList[advertId]);
	SendClientMessageToAll(COLOR_BILA, stringToPrint);

	return 1;
}

