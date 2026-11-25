-- +goose up

-- Quests for the NPC taxi stops (src/modules/taxistop.pwn) and the petrol
-- stations (src/modules/fuel.pwn). Each event fires as follows:
--   16 QUEST_EVT_TAXI_STOP_REACHED  once per phone call whose stop the player
--                                   walked to (CheckTaxiStopCheckpoint)
--   17 QUEST_EVT_TAXI_RIDE_STOP     once per stop the player's cab pulls up at
--                                   while they ride in it (UpdateTaxiRide)
--   18 QUEST_EVT_FUEL_BOUGHT        once per /fuel purchase, with the litres
--                                   bought as the amount (BuyFuel), so a target
--                                   of 1 means any purchase and 1000 means litres
--
-- ids continue from 17; seq_no continues the 10-step ladder from 170. As in
-- 000011, descriptions contain no "\n", and Czech and Bosnian strings stay
-- diacritic-free.

-- Mirrors the QuestEvent enum in src/modules/quest.pwn -- ids must agree.
INSERT INTO "quest_events" VALUES (16,'QUEST_EVT_TAXI_STOP_REACHED');
INSERT INTO "quest_events" VALUES (17,'QUEST_EVT_TAXI_RIDE_STOP');
INSERT INTO "quest_events" VALUES (18,'QUEST_EVT_FUEL_BOUGHT');

INSERT INTO "quest_types" ("id","event","target","reward","seq_no","active") VALUES
	(18, 16,    1,  2500, 180, 1),
	(19, 17,    1,  5000, 190, 1),
	(20, 17,   10, 20000, 200, 1),
	(21, 18,    1,  2500, 210, 1),
	(22, 18, 1000, 10000, 220, 1);

INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(18, 0, 'Call a taxi','Open your phone with the Y key, choose Call Taxi and walk to the checkpoint at the nearest taxi stop. The phone tells you how long until the next cab pulls up there.'),
	(18, 1, 'Zavolej si taxi','Otevri mobil klavesou Y, vyber Call Taxi a dojdi ke checkpointu u nejblizsi zastavky taxi. Mobil ti napise, za jak dlouho tam zastavi dalsi taxik.'),
	(18, 2, 'Pozovi taksi','Otvori mobitel tipkom Y, izaberi Call Taxi i dodji do checkpointa kod najblizeg taksi stajalista. Mobitel ce ti reci za koliko ce tamo stati sljedeci taksi.'),
	(19, 0, 'Ride a taxi','Wait at a taxi stop, get in an NPC taxi as a passenger with the G key and stay in until the cab pulls up at the stop the driver announced.'),
	(19, 1, 'Svez se taxikem','Pockej na zastavce taxi, nastup do NPC taxiku jako spolujezdec klavesou G a zustan uvnitr, dokud taxik nezastavi na zastavce, kterou ridic ohlasil.'),
	(19, 2, 'Provozaj se taksijem','Sacekaj na taksi stajalistu, udji u NPC taksi kao putnik tipkom G i ostani unutra dok taksi ne stane na stajalistu koje je vozac najavio.'),
	(20, 0, 'Ride through 10 taxi stops','Keep riding the NPC taxis around the map and stay aboard for 10 stops. The driver always tells you where he pulls up next and how long it takes. Rides are free.'),
	(20, 1, 'Projed taxikem 10 zastavek','Jezdi s NPC taxiky po mape a zustan na palube po dobu 10 zastavek. Ridic ti vzdy rekne, kde zastavi priste a za jak dlouho. Jizdy jsou zdarma.'),
	(20, 2, 'Provozaj se kroz 10 stajalista','Vozi se NPC taksijima po mapi i ostani u vozilu 10 stajalista. Vozac ti uvijek kaze gdje sljedece staje i za koliko. Voznje su besplatne.'),
	(21, 0, 'Fill up at a petrol station','Drive any vehicle to a petrol station and buy fuel with /fuel from the driver seat. Every station has its own price per litre and its own tank, which NPC tankers top up.'),
	(21, 1, 'Natankuj na benzince','Dojed jakymkoli vozidlem k benzince a ze sedadla ridice si kup palivo prikazem /fuel. Kazda benzinka ma vlastni cenu za litr a vlastni nadrz, kterou doplnuji NPC cisterny.'),
	(21, 2, 'Natoci gorivo na pumpi','Dovezi bilo koje vozilo do benzinske pumpe i sa vozacevog sjedista kupi gorivo komandom /fuel. Svaka pumpa ima svoju cijenu po litri i svoj rezervoar, koji pune NPC cisterne.'),
	(22, 0, 'Buy 1000 litres of fuel','Buy 1000 litres of fuel in total with /fuel. One fill-up is 60 litres. A station can run dry, then move on to another one or wait for a tanker.'),
	(22, 1, 'Kup 1000 litru paliva','Kup prikazem /fuel celkem 1000 litru paliva. Jedno natankovani je 60 litru. Benzince muze dojit palivo, pak zajed k jine nebo pockej na cisternu.'),
	(22, 2, 'Kupi 1000 litara goriva','Kupi ukupno 1000 litara goriva komandom /fuel. Jedno tocenje je 60 litara. Pumpi moze nestati goriva, onda idi do druge ili sacekaj cisternu.');

-- +goose Down
DELETE FROM "quests" WHERE "quest_type" IN (18, 19, 20, 21, 22);
DELETE FROM "quest_labels" WHERE "quest_type" IN (18, 19, 20, 21, 22);
DELETE FROM "quest_types" WHERE "id" IN (18, 19, 20, 21, 22);
DELETE FROM "quest_events" WHERE "id" IN (16, 17, 18);
