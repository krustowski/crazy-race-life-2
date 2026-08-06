#if defined _CRL2_ADVERT
	#endinput
#endif
#define _CRL2_ADVERT

forward ShowAdvert();

new
	lastAdvertNo = -1;

new advertList[][PlayerLocale][] =
{
	//
	// General tips and info
	//
	{
		"[ TIP ] Use /cmd to print the basic command set",
		"[ TIP ] Pro zobrazeni seznamu prikazu pouzij /cmd"
	},
	{
		"[ TIP ] Go browse the /help sections to explore more features available",
		"[ TIP ] Prohledni si sekce v /help, abys poznal dalsi rozsireni hry"
	},
	{
		"[ TIP ] To commit a suicide, use /kill",
		"[ TIP ] Pro spachani sebevrazdy, pouzij prikaz /kill"
	},
	{
		"[ TIP ] You can use /port to warp throughout the map. No vehicles though",
		"[ TIP ] Ackoliv jen bez aut, muzes se volne pohybovat po mape pomoci /port lokalit"
	},
	{
		"[ TIP ] Need some money??? Let's do some missions: /help /taxi /tow /truck",
		"[ TIP ] Potrebujes prachy??? Zkus delat nektere mise: /help /taxi /tow /truck"
	},
	{
		"[ TIP ] In Los Santos, little green Tiki pickups have been placed. Type /prizes for more",
		"[ TIP ] Ve meste Los Santos byly rozmisteny male zelene Tiki sosky. Pro vice pouzij prikaz /prizes"
	},
	{
		"[ INFO ] Server hosted and supported by the n0p.cz organization",
		"[ INFO ] Server je provozovan a sponzorovan skupinou n0p.cz"
	},
	{
		"[ TIP ] Play the /deathmatch with other players!",
		"[ TIP ] Zahrej si /deathmatch s ostatnimi hraci!"
	},
	{
		"[ TIP ] Cash doesn't last forever. Go deposit your money to bank ATM ($ on map)!",
		"[ TIP ] Penize nevydrzi naveky. Najdi banku (ikona $ na mape) a bezpecne si uloz svou hotovost!"
	},
	{
		"[ GAME ] Beware the policemen, they can stop and /search anybody!",
		"[ HRA ] Pozor na policisty, maji pravomoc kohokoliv zastavit a prohledat pomoci prikazu /search!"
	},
	{
		"[ GAME ] Any substance or stuff can be saved at your propriety. Go buy one!",
		"[ HRA ] Jakekoliv substance nebo propriety lze ulozit ve vlastni nemovitosti. Nevahej a kup si jednu!"
	},
	{
		"[ TIP ] New around here? Type /tut to track your progress through the new player tutorial",
		"[ TIP ] Jsi tu novy? Napis /tut a sleduj svuj postup v tutorialu pro nove hrace"
	},
	{
		"[ TIP ] Press the Y key to open your cellphone menu - call a mechanic, a taxi, or check your bank balance",
		"[ TIP ] Zmackni klavesu Y a otevri si menu mobilu - zavolej mechanika, taxikare nebo si zkontroluj zustatek v bance"
	},
	{
		"[ INFO ] This server speaks your language! Switch between English and Czech anytime using /locale",
		"[ INFO ] Tenhle server mluvi tvou reci! Kdykoliv muzes prepnout mezi anglictinou a cestinou prikazem /locale"
	},
	{
		"[ GAME ] Keep an eye out for the orange Pumpkin pickups too - they're worth $1.5M!",
		"[ HRA ] Davej pozor i na oranzove Pumpkin sosky - maji cenu 1.5M dolaru!"
	},
	//
	//  Racing
	//
	{
		"[ TIP ] Bored? Try any of the loaded races from the /race list",
		"[ TIP ] Nudis se? Zkus si zajet nektery ze zavodu z nabidky prikazu /race"
	},
	{
		"[ TIP ] Stuck in the race? Try /race again to exit the race",
		"[ TIP ] Uviznul jsi v zavodu? Pouzij prikaz /race znovu, abys opustil zavod"
	},
	{
		"[ TIP ] List High Scores using /scores",
		"[ TIP ] Pro zobrazeni top tabulek hracu, pouzij prikaz /scores"
	},
	{
		"[ GAME ] In a race and in need of the vehilce repair? Take a mechanic on the journey with you!",
		"[ HRA ] Jedes zavod a potrebujes rychle opravit auto? Vem s sebou mechanika a ten se o to postara i za jizdy!"
	},
	//
	//  Drugz
	//
	{
		"[ GAME ] In San Fierro there have been some random substances placed. But beware the policemen, they can stop and /search anybody!",
		"[ HRA ] Ve meste San Fierro byly nahodile rozmisteny baliky substanci. Ale davej bacha, policie muze prohledat kohokoliv pomoci prikazu /search!"
	},
	{
		"[ GAME ] Some substances or stuff can be found at the black market too",
		"[ HRA ] Nektere substance ci propriety lze najit tez na cernem trhu!"
	},
	//
	//  Housing
	//
	{
		"[ GAME ] Locations of Green House mapicon host some properties for sell",
		"[ HRA ] Lokace oznacene ikonou Zeleneho domku hostuji nemovitosti ke koupeni!"
	},
	{
		"[ TIP ] There are plenty properties for rent! Go rent some or outbuy a currently rented ones by othe players",
		"[ TIP ] Ve hre se nachazi spousta nemovitosti k pronajmu! Pronajmi si nejakou, klidne i odkupem jiz pronajate prodejny jinymi hraci"
	},
	{
		"[ TIP ] You can attach a vehicle to your property using /property menu item",
		"[ TIP ] Ke sve nemovitosti si muzes priradit vozidlo: pouzij menu prikazu /property"
	},
	{
		"[ TIP ] Bored of the Las Venturas Pyramid spawn point? Buy a property and respawn there instead using /property",
		"[ TIP ] Nudi te spawn bod na vrcholku pyramidy v LV? Kup si svou nemovitost a nastav si spawn bod u ni prikazem /property!"
	},
	//
	//  Teams
	//
	{
		"[ TIP ] Want to talk to your team only? Start your message with ! to use Team Chat",
		"[ TIP ] Chces mluvit jen se svym tymem? Zacni zpravu vykricnikem (!) a pouzijes Tymovy chat"
	},
	//
	//  Missions
	//
	{
		"[ TIP ] Prefer heavy loads? Try the Trucking missions using /truck!",
		"[ TIP ] Mas radsi tezky naklad? Zkus kamionacke mise pomoci prikazu /truck!"
	},
	{
		"[ TIP ] Spot an abandoned car lying around? Impound it with a Tow mission: /tow!",
		"[ TIP ] Vsimnul sis nekde opusteneho auta? Odtahni ho pomoci Tow mise: prikaz /tow!"
	},
	//
	//  Police & Wanted
	//
	{
		"[ GAME ] Wanted level too high? Find a hidden Police Bribe pickup to make it disappear",
		"[ HRA ] Mas moc vysoky wanted level? Najdi schovany Bribe pickup pro policii a zbav se ho"
	},
	{
		"[ TIP ] Check who's currently wanted by the police with /wanted",
		"[ TIP ] Zjisti, kdo je prave hledany policii, pomoci prikazu /wanted"
	},
	//
	//  Trivia
	//
	{
		"[ TRIVIA ] Did you know? CrazyRaceLife2 is a revival of the original CrazyRaceLife gamemode from 2008-2010!",
		"[ TRIVIA ] Vedel jsi, ze? CrazyRaceLife2 je znovuzrozeni puvodniho gamemodu CrazyRaceLife z let 2008-2010!"
	},
	//
	//  Endtip
	//
	{
		"[ TIP ] Go skydiving using /skydive!",
		"[ TIP ] Bez si skocit s padakem pomoci /skydive!"
	}
};

public ShowAdvert()
{
	new 
		advertId = random(sizeof(advertList));

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		if (advertId == lastAdvertNo)
		{
			advertId++;
			advertId %= sizeof(advertList);
		}

		lastAdvertNo = advertId;

		SendClientMessage(i, COLOR_WHITE, advertList[advertId][ gPlayers[i][Locale] ]);
	}

	return 1;
}

