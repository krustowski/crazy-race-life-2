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
		"[ TIP ] Pro zobrazeni seznamu prikazu pouzij /cmd",
		"[ TIP ] Za prikaz liste komandi koristi /cmd"
	},
	{
		"[ TIP ] Go browse the /help sections to explore more features available",
		"[ TIP ] Prohledni si sekce v /help, abys poznal dalsi rozsireni hry",
		"[ TIP ] Pregledaj sekcije u /help da otkrijes vise mogucnosti igre"
	},
	{
		"[ TIP ] To commit a suicide, use /kill",
		"[ TIP ] Pro spachani sebevrazdy, pouzij prikaz /kill",
		"[ TIP ] Za samoubistvo koristi komandu /kill"
	},
	{
		"[ TIP ] You can use /port to warp throughout the map. No vehicles though",
		"[ TIP ] Ackoliv jen bez aut, muzes se volne pohybovat po mape pomoci /port lokalit",
		"[ TIP ] Komandom /port se mozes teleportovati po mapi. Doduse, bez vozila"
	},
	{
		"[ TIP ] Need some money??? Let's do some missions: /help /taxi /tow /truck",
		"[ TIP ] Potrebujes prachy??? Zkus delat nektere mise: /help /taxi /tow /truck",
		"[ TIP ] Trebaju ti pare??? Probaj neke misije: /help /taxi /tow /truck"
	},
	{
		"[ TIP ] In Los Santos, little green Tiki pickups have been placed. Type /prizes for more",
		"[ TIP ] Ve meste Los Santos byly rozmisteny male zelene Tiki sosky. Pro vice pouzij prikaz /prizes",
		"[ TIP ] U Los Santosu su postavljeni mali zeleni Tiki pickupi. Za vise koristi /prizes"
	},
#if R2_SERVER
	{
		"[ INFO ] Server hosted and supported by the n0p.cz organization",
		"[ INFO ] Server je provozovan a sponzorovan skupinou n0p.cz",
		"[ INFO ] Server hostuje i podrzava organizacija n0p.cz"
	},
#endif
	{
		"[ TIP ] Play the /deathmatch with other players!",
		"[ TIP ] Zahrej si /deathmatch s ostatnimi hraci!",
		"[ TIP ] Zaigraj /deathmatch sa ostalim igracima!"
	},
	{
		"[ TIP ] Cash doesn't last forever. Go deposit your money to bank ATM ($ on map)!",
		"[ TIP ] Penize nevydrzi naveky. Najdi banku (ikona $ na mape) a bezpecne si uloz svou hotovost!",
		"[ TIP ] Gotovina ne traje vjecno. Pronadji bankomat ($ na mapi) i sigurno uplati svoj novac!"
	},
	{
		"[ GAME ] Beware the policemen, they can stop and /search anybody!",
		"[ HRA ] Pozor na policisty, maji pravomoc kohokoliv zastavit a prohledat pomoci prikazu /search!",
		"[ IGRA ] Pazi se policajaca, mogu bilo koga zaustaviti i pretresti komandom /search!"
	},
	{
		"[ GAME ] Any substance or stuff can be saved at your propriety. Go buy one!",
		"[ HRA ] Jakekoliv substance nebo propriety lze ulozit ve vlastni nemovitosti. Nevahej a kup si jednu!",
		"[ IGRA ] Bilo koju supstancu ili stvari mozes cuvati u svojoj nekretnini. Kupi jednu!"
	},
	{
		"[ TIP ] New around here? Type /quest for a list of tasks, each one paying a cash reward",
		"[ TIP ] Jsi tu novy? Napis /quest a uvidis seznam ukolu, za kazdy z nich dostanes penezni odmenu",
		"[ TIP ] Nov si ovdje? Upisi /quest za listu zadataka, svaki od njih donosi novcanu nagradu"
	},
	{
		"[ TIP ] Press the Y key to open your cellphone menu - call a mechanic, a taxi, or check your bank balance",
		"[ TIP ] Zmackni klavesu Y a otevri si menu mobilu - zavolej mechanika, taxikare nebo si zkontroluj zustatek v bance",
		"[ TIP ] Pritisni tipku Y da otvoris meni mobitela - pozovi mehanicara, taksi ili provjeri stanje u banci"
	},
	{
		"[ INFO ] This server speaks your language! Switch between English, Czech and Bosnian anytime using /locale",
		"[ INFO ] Tenhle server mluvi tvou reci! Kdykoliv muzes prepnout mezi anglictinou, cestinou a bosenstinou prikazem /locale",
		"[ INFO ] Ovaj server govori tvoj jezik! Prebaci izmedju engleskog, ceskog i bosanskog bilo kada komandom /locale"
	},
	{
		"[ GAME ] Keep an eye out for the orange Pumpkin pickups too - they're worth $1.5M!",
		"[ HRA ] Davej pozor i na oranzove Pumpkin sosky - maji cenu 1.5M dolaru!",
		"[ IGRA ] Pazi i na narandzaste Pumpkin pickupe - vrijede $1.5M!"
	},
	//
	//  Racing
	//
	{
		"[ TIP ] Bored? Try any of the loaded races from the /race list",
		"[ TIP ] Nudis se? Zkus si zajet nektery ze zavodu z nabidky prikazu /race",
		"[ TIP ] Dosadno ti je? Probaj neku od ucitanih utrka sa liste /race"
	},
	{
		"[ TIP ] Stuck in the race? Try /race again to exit the race",
		"[ TIP ] Uviznul jsi v zavodu? Pouzij prikaz /race znovu, abys opustil zavod",
		"[ TIP ] Zaglavio si u utrci? Ponovo upisi /race da izadjes iz utrke"
	},
	{
		"[ TIP ] List High Scores using /scores",
		"[ TIP ] Pro zobrazeni top tabulek hracu, pouzij prikaz /scores",
		"[ TIP ] Za prikaz tabela najboljih rezultata koristi /scores"
	},
	{
		"[ GAME ] In a race and in need of the vehilce repair? Take a mechanic on the journey with you!",
		"[ HRA ] Jedes zavod a potrebujes rychle opravit auto? Vem s sebou mechanika a ten se o to postara i za jizdy!",
		"[ IGRA ] Vozis utrku i treba ti popravka vozila? Povedi mehanicara sa sobom, popravit ce ga i u voznji!"
	},
	//
	//  Drugz
	//
	{
		"[ GAME ] In San Fierro there have been some random substances placed. But beware the policemen, they can stop and /search anybody!",
		"[ HRA ] Ve meste San Fierro byly nahodile rozmisteny baliky substanci. Ale davej bacha, policie muze prohledat kohokoliv pomoci prikazu /search!",
		"[ IGRA ] U San Fierru su nasumicno postavljene neke supstance. Ali pazi se policajaca, mogu bilo koga pretresti komandom /search!"
	},
	{
		"[ GAME ] Some substances or stuff can be found at the black market too",
		"[ HRA ] Nektere substance ci propriety lze najit tez na cernem trhu!",
		"[ IGRA ] Neke supstance ili stvari mogu se naci i na crnom trzistu"
	},
	{
		"[ GAME ] Every sale to the fence pushes the market ratio down for all dealers. Sell early, before the others flood the market!",
		"[ HRA ] Kazdy prodej paserakovi srazi kurz na trhu vsem dealerum. Prodavej driv, nez trh zaplavi ostatni!",
		"[ IGRA ] Svaka prodaja otkupljivacu obara kurs na trzistu za sve dilere. Prodaj ranije, prije nego drugi preplave trziste!"
	},
	//
	//  Housing
	//
	{
		"[ TIP ] There are plenty properties for rent! Go rent some or outbuy a currently rented ones by othe players",
		"[ TIP ] Ve hre se nachazi spousta nemovitosti k pronajmu! Pronajmi si nejakou, klidne i odkupem jiz pronajate prodejny jinymi hraci",
		"[ TIP ] Ima puno nekretnina za najam! Iznajmi neku ili preuzmi najam koji drze drugi igraci"
	},
	{
		"[ TIP ] You can attach a vehicle to your property using /property menu item",
		"[ TIP ] Ke sve nemovitosti si muzes priradit vozidlo: pouzij menu prikazu /property",
		"[ TIP ] Vozilo mozes dodijeliti svojoj nekretnini preko menija /property"
	},
	{
		"[ TIP ] Bored of the Las Venturas Pyramid spawn point? Buy a property and respawn there instead using /property",
		"[ TIP ] Nudi te spawn bod na vrcholku pyramidy v LV? Kup si svou nemovitost a nastav si spawn bod u ni prikazem /property!",
		"[ TIP ] Dosadila ti je spawn tacka na piramidi u Las Venturasu? Kupi nekretninu i postavi spawn tamo preko /property"
	},
	//
	//  Teams
	//
	{
		"[ TIP ] Want to talk to your team only? Start your message with ! to use Team Chat",
		"[ TIP ] Chces mluvit jen se svym tymem? Zacni zpravu vykricnikem (!) a pouzijes Tymovy chat",
		"[ TIP ] Zelis pricati samo sa svojim timom? Pocni poruku sa ! za timski chat"
	},
	//
	//  Missions
	//
	{
		"[ TIP ] Prefer heavy loads? Try the Trucking missions using /truck!",
		"[ TIP ] Mas radsi tezky naklad? Zkus kamionacke mise pomoci prikazu /truck!",
		"[ TIP ] Vise volis teske terete? Probaj Trucking misije komandom /truck!"
	},
	{
		"[ TIP ] Spot an abandoned car lying around? Impound it with a Tow mission: /tow!",
		"[ TIP ] Vsimnul sis nekde opusteneho auta? Odtahni ho pomoci Tow mise: prikaz /tow!",
		"[ TIP ] Vidis negdje napusteno vozilo? Odvuci ga u Tow misiji: /tow!"
	},
	//
	//  Police & Wanted
	//
	{
		"[ GAME ] Wanted level too high? Find a hidden Police Bribe pickup to make it disappear",
		"[ HRA ] Mas moc vysoky wanted level? Najdi schovany Bribe pickup pro policii a zbav se ho",
		"[ IGRA ] Previsok wanted level? Pronadji skriveni Police Bribe pickup da ga se rijesis"
	},
	{
		"[ TIP ] Check who's currently wanted by the police with /wanted",
		"[ TIP ] Zjisti, kdo je prave hledany policii, pomoci prikazu /wanted",
		"[ TIP ] Provjeri ko je trenutno trazen od policije komandom /wanted"
	},
	//
	//  Trivia
	//
	{
		"[ TRIVIA ] Did you know? CrazyRaceLife2 is a revival of the original CrazyRaceLife gamemode from 2008-2010!",
		"[ TRIVIA ] Vedel jsi, ze? CrazyRaceLife2 je znovuzrozeni puvodniho gamemodu CrazyRaceLife z let 2008-2010!",
		"[ TRIVIA ] Jesi li znao? CrazyRaceLife2 je ozivljavanje originalnog CrazyRaceLife gamemoda iz 2008-2010!"
	},
	//
	//  What's new
	//
	{
		"[ NEW ] Quests replaced the tutorial! The top one pays $5M for renting every commercial property at once. See /quest",
		"[ NOVINKA ] Tutorial nahradily ukoly! Nejvyssi plati $5M za pronajem vsech komercnich nemovitosti naraz. Viz /quest",
		"[ NOVO ] Zadaci su zamijenili tutorijal! Najveci placa $5M za najam svih komercijalnih nekretnina odjednom. Vidi /quest"
	},
	{
		"[ NEW ] Dealerz can sell drugz to the fence at any skull pickup: 60% of the market price, up to 5000 g and $1M per hour",
		"[ NOVINKA ] Dealerz mohou prodavat drogy paserakovi na kazdem pickupu s lebkou: 60% trzni ceny, az 5000 g a $1M za hodinu",
		"[ NOVO ] Dealerz mogu prodati droge otkupljivacu na svakom pickupu s lobanjom: 60% trzisne cijene, do 5000 g i $1M po satu"
	},
	{
		"[ NEW ] Once a day the black market booms and the ratio climbs to 100. Dealerz get a heads-up in chat - that's the time to sell!",
		"[ NOVINKA ] Jednou denne cerny trh vybuchne a kurz vyleti az na 100. Dealerz dostanou zpravu v chatu - to je cas prodavat!",
		"[ NOVO ] Jednom dnevno crno trziste eksplodira i kurs skoci do 100. Dealerz dobiju poruku u chatu - tad je vrijeme za prodaju!"
	},
	{
		"[ NEW ] Robberz: hold LALT or LSHIFT by a blue house pickup to rob the shop for up to 20 s. Every robbery raises your wanted level!",
		"[ NOVINKA ] Robberz: drz LALT nebo LSHIFT u modreho domku a vykrades obchod, az 20 s. Kazda loupez ti zvysi wanted level!",
		"[ NOVO ] Robberz: drzi LALT ili LSHIFT kod plave kucice da opljackas radnju, do 20 s. Svaka pljacka ti podize wanted level!"
	},
	{
		"[ NEW ] Petrol stations now have their own tanks, refilled by NPC tanker trucks. Fill up with /fuel - every station has its own price",
		"[ NOVINKA ] Cerpaci stanice maji vlastni nadrze, ktere doplnuji NPC cisterny. Natankuj pres /fuel - kazda stanice ma svou cenu",
		"[ NOVO ] Benzinske pumpe imaju svoje rezervoare koje pune NPC cisterne. Natoci gorivo sa /fuel - svaka pumpa ima svoju cijenu"
	},
	{
		"[ NEW ] Need a ride? Press Y, pick Call Taxi and wait at the checkpoint. An NPC cab picks you up and announces every stop",
		"[ NOVINKA ] Potrebujes odvoz? Zmackni Y, vyber Call Taxi a pockej na checkpointu. NPC taxik te vyzvedne a hlasi kazdou zastavku",
		"[ NOVO ] Treba ti prevoz? Pritisni Y, izaberi Call Taxi i sacekaj na checkpointu. NPC taksi te pokupi i najavljuje svaku stanicu"
	},
#if R2_SERVER
	{
		"[ NEW ] Look up! Two AT-400 airliners now fly back and forth between the Las Venturas and San Fierro airports",
		"[ NOVINKA ] Podivej se nahoru! Mezi letisti v Las Venturas a San Fierru ted letaji dve AT-400",
		"[ NOVO ] Pogledaj gore! Dva AT-400 aviona sada lete izmedju aerodroma u Las Venturasu i San Fierru"
	},
#endif
	{
		"[ TIP ] Playing the HD (widescreen) version of GTA SA? Type /hd and the clock moves to fit your HUD",
		"[ TIP ] Hrajes HD (widescreen) verzi GTA SA? Napis /hd a hodiny se presunou tak, aby sedely do tveho HUD",
		"[ TIP ] Igras HD (widescreen) verziju GTA SA? Upisi /hd i sat ce se pomjeriti da odgovara tvom HUD-u"
	},
	//
	//  Coming soon
	//
	{
		"[ SOON ] Vehicles will soon burn fuel. Get to know the petrol stations and /fuel before your tank runs dry!",
		"[ CHYSTAME ] Auta budou brzy spotrebovavat palivo. Seznam se s cerpacimi stanicemi a /fuel driv, nez ti dojde nadrz!",
		"[ USKORO ] Vozila ce uskoro trositi gorivo. Upoznaj benzinske pumpe i /fuel prije nego ti se isprazni rezervoar!"
	},
	{
		"[ SOON ] Paid pizza deliveries are coming for the Pizzaboyz. The delivery minigame is already in the oven!",
		"[ CHYSTAME ] Pizzaboyz se brzy dockaji placenych rozvozu pizzy. Minihra na rozvoz se uz pece v troube!",
		"[ USKORO ] Pizzaboyz uskoro dobijaju placene dostave pice. Minigra za dostavu je vec u pecnici!"
	},
	{
		"[ SOON ] Calling a Car mechanic or a Pizza delivery from your phone (Y) will soon reach the players on those teams",
		"[ CHYSTAME ] Zavolat mechanika nebo rozvoz pizzy z mobilu (Y) te brzy spoji primo s hraci z techto tymu",
		"[ USKORO ] Poziv mehanicaru ili dostavi pice sa mobitela (Y) uskoro ce stizati do igraca iz tih timova"
	},
	{
		"[ SOON ] Combat missions are in testing: grab briefcases from armed gangs, like in the new Sherman Dam heist, then escape by chopper",
		"[ CHYSTAME ] Testujeme bojove mise: seber kufriky ozbrojenym gangum, treba v nove misi na Sherman Dam, a unikni vrtulnikem",
		"[ USKORO ] Testiramo borbene misije: pokupi kofere od naoruzanih bandi, kao u novoj pljacki na Sherman Dam, i pobjegni helikopterom"
	},
	{
		"[ SOON ] A second parkour course is being built in Bone County. Until then, try the San Fierro Ship Parkour from /port",
		"[ CHYSTAME ] V Bone County stavime druhou parkourovou trat. Do te doby zkus San Fierro Ship Parkour z /port",
		"[ USKORO ] U Bone Countyju gradimo drugu parkour stazu. Do tada probaj San Fierro Ship Parkour iz /port"
	},
	//
	//  Endtip
	//
	{
		"[ TIP ] Go skydiving using /skydive!",
		"[ TIP ] Bez si skocit s padakem pomoci /skydive!",
		"[ TIP ] Skoci padobranom komandom /skydive!"
	}
};

public ShowAdvert()
{
	new 
		advertId = random(sizeof(advertList));

	if (advertId == lastAdvertNo)
	{
		advertId++;
		advertId %= sizeof(advertList);
	}

	lastAdvertNo = advertId;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		SendClientMessage(i, COLOR_WHITE, advertList[advertId][ gPlayers[i][Locale] ]);
	}

	return 1;
}

