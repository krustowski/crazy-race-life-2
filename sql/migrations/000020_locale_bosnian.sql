-- +goose up

-- Mirrors the PlayerLocale enum in src/support/i18n.pwn -- ids must agree.
INSERT INTO "locale_types" VALUES (2,'LOCALE_BS','Bosnian');

INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(1, 2, 'Pridruzi se timu','Pickupe za ulazak u tim mozes naci kod zeljeznickih stanica, benzinskih pumpi, aerodroma, radionica za farbanje itd.' || char(10) || char(10) || 'Pickup ima oblik kreditne/licne karte.'),
	(2, 2, 'Zavrsi utrku','Izaberi utrku sa liste komande /race i uspjesno je zavrsi.'),
	(3, 2, 'Odvezi 3 musterije taksijem','Pridruzi se timu Taximen, uzmi taksi kao vozac i zavrsi 3 Taxi misije komandom /taxi.'),
	(4, 2, 'Zavrsi 3 voznje kamionom','Nabavi kamion sa zakacenom prikolicom i zavrsi 3 Trucking misije komandom /truck.'),
	(5, 2, 'Iznajmi nekretninu','Pronadji pickup u obliku plave kucice, koji oznacava komercijalnu nekretninu, i iznajmi je.'),
	(6, 2, 'Kupi nekretninu','Pronadji pickup u obliku zelene kucice, koji oznacava privatnu nekretninu na prodaju, i kupi je.'),
	(7, 2, 'Uplati novac u banku','Pronadji bankomat (zeleni znak dolara na minimapi) i uplati svoju gotovinu na racun.'),
	(8, 2, 'Posalji privatnu poruku','Otvori svoj mobitel tipkom Y i posalji privatnu poruku drugom igracu koji je online!'),
	(9, 2, 'Odigraj deathmatch rundu','Prijavi se na /deathmatch i prezivi cijelo trajanje mini-igre.'),
	(10, 2, 'Odvuci 3 vozila','Sjedi za volan vucnog vozila, pokreni voznju komandom /tow, zakaci parkirana vozila tipkom submission i odvezi 3 od njih do doka u San Fierru.'),
	(11, 2, 'Zavrsi voznju droge','Pridruzi se timu Dealers, pokreni voznju komandom /drug i skupljaj pickupe droge po mapi. Voznju zavrsi ponovo komandom /drug da sacuvas ono sto si skupio.'),
	(12, 2, 'Prezivi rampage','Pronadji startni pickup rampage u Las Venturasu, San Fierru ili Los Santosu i izdrzi cijelu petominutnu pucnjavu. Moras eliminisati barem jedan NPC.'),
	(13, 2, 'Pobijedi u rundi deathmatcha','Prijavi se na /deathmatch, prezivi cijelu rundu i zavrsi je kao igrac s najvecim skorom.'),
	(14, 2, 'Zavrsi combat misiju','Pokreni misiju komandom /combat, pokupi aktovke u enterijeru i predaj ih covjeku s aktovkama koji ce te isplatiti.'),
	(15, 2, 'Opljackaj 5 nekretnina','Pridruzi se timu Robberz, stani kod komercijalne nekretnine (pickup plave kucice) i drzi LALT ili LSHIFT da je pljackas do 20 sekundi. Izvuci se s plijenom iz 5 pljacki. Svaka pljacka ti povecava wanted level.'),
	(16, 2, 'Opljackaj 50 nekretnina','Nastavi s pljackaskim poslom i izvuci se s plijenom iz 50 pljacki. Opljackana nekretnina ostaje zakljucana 5 minuta, zato obilazi razlicite radnje.'),
	(17, 2, 'Opljackaj 500 nekretnina','Postani legenda Robberz tima i izvuci se s plijenom iz 500 pljacki. Pljacke u razmaku manjem od 5 minuta spajaju se u jednu pljackasku misiju i njen rekord.');

-- +goose Down
UPDATE "users" SET "locale" = 0 WHERE "locale" = 2;
DELETE FROM "quest_labels" WHERE "locale" = 2;
DELETE FROM "locale_types" WHERE "id" = 2;
