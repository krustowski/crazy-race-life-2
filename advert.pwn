public ShowAdvert()
{
	new advertId = random(5);

	switch (advertId)
	{
		case 0:
			{
				SendClientMessageToAll(COLOR_SVZEL, "[ TIP ] Pro zobrazeni zakladniho seznamu prikazu pouzij /cmd");
			}
		case 1:
			{
				SendClientMessageToAll(COLOR_SVZEL, "[ TIP ] Pro okamzitou sebevrazdu napis /kill");
			}
		case 2:
			{
				SendClientMessageToAll(COLOR_SVZEL, "[ TIP ] Ve meste LS a okoli jsou schovany tajne predmety (mala zelena soska), pro vice informaci napis /soska");
			}
		case 3:
			{
				//SendClientMessageToAll(COLOR_SVZEL, "[ INFO ] Sponzoři: http://athostik.xf.cz | http://kyrspa.wz.cz | http://stunt-server.7x.cz | hosted.czfree-ra.net");
				SendClientMessageToAll(COLOR_SVZEL, "[ INFO ] Hostovano a sponzorovano organizaci vxn.dev");
			}
		case 4:
			{
				SendClientMessageToAll(COLOR_SVZEL, "[ TIP ] Zahrej si deathmatch spolu s kamarady ve specialni arene! /deathmatch [join/exit]");
			}
	}

	return 1;
}

