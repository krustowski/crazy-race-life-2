#if defined _CRL2_ADVERT
	#endinput
#endif
#define _CRL2_ADVERT

forward ShowAdvert();

public ShowAdvert()
{
	new advertList[][] =
	{
		// General tips and info.
		"[ TIP ] Use /cmd to print the basic command set",
		"[ TIM ] Go browse the /help sections to explore more features available",
		"[ TIP ] To commit a suicide, use /kill",
		"[ TIP ] You can use /port to warp throughout the map. No vehicles though",
		"[ TIP ] Wand some money??? Let's do some missions: /taxi /truck",
		"[ TIP ] In Los Santos, little green Tiki pickups have been placed. Type /prizes for more",
		"[ INFO ] Server hosted and supported by the n0p.cz organization",
		"[ TIP ] Play the /deathmatch with your friends!",
		"[ TIP ] Cash doesn't last forever. Go deposit your money to bank ATM ($ on map)!",
		"[ GAME ] Beware the policemen, they can stop and /search anybody!",
		"[ GAME ] Any substance or stuff can be saved at your propriety. Go buy one!",
		// Racing. 
		"[ TIP ] Bored? Try any of the loaded races from the /race list",
		"[ TIP ] Stuck in the race? Try /race again to exit the race",
		"[ TIP ] List High Scores using /scores",
		"[ GAME ] You cannot use the /fix command to repair your vehicle during a /race, ask a Mechanic instead",
		// Drugz.
		"[ GAME ] In San Fierro there have been some random substances placed. But beware the policemen, they can stop and /search anybody!",
		//"[ GAME ] To /deal any substance or stuff, one has to join the Dealerz team",
		//"[ GAME ] Some substances or stuff can be found at the black market too",
		// Housing.
		"[ GAME ] Locations of Green House mapicon host some properties for sell",
		"[ TIP ] There are plenty properties for rent! Go rent some or outbuy a current one",
		"[ TIP ] You can attach a vehicle to your property using /property menu item",
		"[ TIP ] Bored of the Las Venturas Pyramid spawn point? Buy a property and respawn there instead using /property",
		// Endtip.
		"[ TIP ] Go skydiving using /skydive!"
	};

	new advertId = random(sizeof(advertList)), stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "%s", advertList[advertId]);
	SendClientMessageToAll(COLOR_WHITE, stringToPrint);

	return 1;
}

