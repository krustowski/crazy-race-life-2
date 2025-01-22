	//------------------------
	//CreatePickup(1274, 1,2029.54, 1320.78, 10.82);
	//	CreatePickup(362, 1,2017.58,1338.44,10.82);

	polisilv = CreatePickup(1239, 1, 2171.22, 1397.11, 11.06);
	menupolisi = CreateMenu("Fizly xD", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menupolisi, 0, "Polisi");

	love = CreatePickup(1240, 1, 2302.85, 1155.93, 85.94); //v admin mistnosti
							       //------------------------
	lamer = CreatePickup(1239, 1, 2252.11, 1285.30, 19.17);
	menulamer = CreateMenu("Kravinec", 1, 150.0, 100.0, 250.0, 150.0); //LV pod pyramidu na "prdeli" swingy
	AddMenuItem(menulamer, 0, "Club Lamy");

	borec = CreatePickup(1239, 1, 2304.43, 1151.95, 85.94);
	menuborec = CreateMenu("Admin Zona", 1, 150.0, 100.0, 250.0, 150.0); // LV admin mistnost LV
	AddMenuItem(menuborec, 0, "Admin - Borci");

	benzinak = CreatePickup(1239, 1, 2637.36, 1127.04, 11.18);
	benzinakmenu = CreateMenu("Benzina", 1, 150.0, 100.0, 250.0, 150.0); // LV benzinky
	AddMenuItem(benzinakmenu, 0, "Benzinak xD");

	dragster = CreatePickup(1239, 1, 2620.14, 1195.76, 10.81);
	dragstermenu = CreateMenu("Dragy", 1, 150.0, 100.0, 250.0, 150.0); // LV zacatek dragu
	AddMenuItem(dragstermenu, 0, "DRaGsTeR");

	tulak = CreatePickup(1581, 1, 2892.8, -2127.9, 3.2);
	menutulak = CreateMenu("Tulaci", 1, 150.0, 100.0, 250.0, 150.0); // LS plaz
	AddMenuItem(menutulak, 0, "Tulaci");

	pizzaboy = CreatePickup(1581, 1, 2101.70, -1810.05, 13.55);
	menupizza = CreateMenu("Pizza", 1, 150.0, 100.0, 250.0, 150.0); // LS u pizza
	AddMenuItem(menupizza, 0, "PizzaBoy");

	hackeri = CreatePickup(1581, 1, 2838.10, -2130.26, 0.19);
	hackerimenu = CreateMenu("Hacker",  1, 150.0, 100.0, 250.0, 150.0); // LS za tulakama
	AddMenuItem(hackerimenu, 0, "Hackeri");

	//technik = CreatePickup(1581,1, );
	menutechnik = CreateMenu("Technik", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menutechnik, 0, "Technik");

	//pyrotechnik = CreatePickup(1581,1, );
	menupyrotechnik = CreateMenu("Pyrotechnik", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(menupyrotechnik, 0, "Pyrotechnik");

	interiertulaci = CreatePickup(1318, 1, 2866.62, -2125.24, 5.72);
	tulacizpatky = CreatePickup(1318, 1, 2853.09, -2125.16, 0.19);
	pytelpenez = CreatePickup(1550, 1, 2838.59, -2141.25, 0.19);
	picktunel = CreatePickup(1318, 1, 2263.41, -755.52, 38.04);

