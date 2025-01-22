public ShowAdvert()
{
	new advertId = random(5);

	switch (advertId)
	{
		case 0:
			{
				SendClientMessageToAll(COLOR_SVZEL, " [TIP] Pro pomoc a dalši info napište /help :)");
			}
		case 1:
			{
				SendClientMessageToAll(COLOR_SVZEL, " [TIP] Pro sebevraždu napiš /kill");
			}
		case 2:
			{
				SendClientMessageToAll(COLOR_SVZEL, " [TIP] Po mapě v LS jsou skryté balíčky (malá zelená soška), pro více informací /soska");
			}
		case 3:
			{
				SendClientMessageToAll(COLOR_SVZEL, " [INFO] Sponzoři: http://athostik.xf.cz | http://kyrspa.wz.cz | http://stunt-server.7x.cz | hosted.czfree-ra.net");
			}
		case 4:
			{
				SendClientMessageToAll(COLOR_SVZEL, " [TIP] Zahrej si s kamarady paintball v paintball arene! /paintball, /paintexit");
			}
	}

	return 1;
}

