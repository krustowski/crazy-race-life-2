forward ShowAdvert();

public ShowAdvert()
{
	new advertList[][] =
	{
		// General tips and info.
		"[ TIP ] Use /cmd to print the basic command set",
		"[ TIP ] To commit a suicide, use /kill",
		"[ TIP ] You can use /port [location ID] to warp throughout the map. No vehicles though",
		"[ TIP ] No money? Use a motorcycle to do stunts!",
		"[ TIP ] In Los Santos, little green Tiki pickups have been placed. Type /tiki for more",
		"[ INFO ] Server hosted and supported by the vxn.dev organization",
		"[ TIP ] Play the /deathmatch with your friends!",
		"[ TIP ] Cash doesn't last forever. Go deposit your money to /bank ($)!",
		"[ GAME ] Beware the policemen, they can stop and /search anybody!",
		"[ GAME ] Any substance or stuff can be saved at your propriety. Go buy one!",
		// Racing. 
		"[ TIP ] Bored? Try any of the loaded races from the /race list",
		"[ TIP ] Stuck in the race? Try /race exit",
		"[ TIP ] Joined the race, but the start is too far? Use /race warp",
		"[ TIP ] List High Scores using /scores",
		"[ GAME ] You cannot use the /fix command to repair your vehicle during a race",
		// Drugz.
		"[ GAME ] In San Fierro there have been some random substances placed. But beware the policemen, they can stop and search anybody!",
		"[ GAME ] To deal any substance or stuff, one has to join the Dealerz team",
		"[ GAME ] Some substances or stuff can be found at the black market too",
		// Housing.
		"[ GAME ] Locations of Green House mapicon host some properties for sell",
		"[ GAME ] Locations of Red House mapicon host some properties for sell in the near future!",
		"[ TIP ] You can attach a vehicle to your property using /property vehicle [property ID]",
		"[ TIP ] Bored of Las Venturas Pyramid spawn point? Buy a property and respawn there instead!",
		// Endtip.
		"[ TIP ] Go skydiving using /skydive!"
	};

	new advertId = random(sizeof(advertList)), stringToPrint[256];

	format(stringToPrint, sizeof(stringToPrint), "%s", advertList[advertId]);
	SendClientMessageToAll(COLOR_WHITE, stringToPrint);

	return 1;
}

