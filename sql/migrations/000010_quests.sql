-- +goose up
CREATE TABLE IF NOT EXISTS "quest_events" (
	"id"	INTEGER,
	"name"	TEXT UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "quest_types" (
	"id"		INTEGER,
	"event"		INTEGER NOT NULL,
	"target"	INTEGER NOT NULL DEFAULT 1,
	"reward"	INTEGER NOT NULL DEFAULT 0,
	"seq_no"	INTEGER NOT NULL DEFAULT 0,
	"active"	INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("event") REFERENCES "quest_events"("id")
);

CREATE TABLE IF NOT EXISTS "quest_labels" (
	"id"		INTEGER,
	"quest_type"	INTEGER NOT NULL,
	"locale"	INTEGER NOT NULL,
	"label"		TEXT NOT NULL,
    "desc"      TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("quest_type") REFERENCES "quest_types"("id"),
	FOREIGN KEY("locale") REFERENCES "locale_types"("id"),
	UNIQUE("quest_type", "locale")
);

CREATE TABLE IF NOT EXISTS "quests" (
	"id"		INTEGER,
	"user_id"	INTEGER NOT NULL,
	"quest_type"	INTEGER NOT NULL,
	"progress"	INTEGER NOT NULL DEFAULT 0,
	"completed_at"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "users"("id"),
	FOREIGN KEY("quest_type") REFERENCES "quest_types"("id"),
	UNIQUE("user_id", "quest_type")
);

-- Mirrors the QuestEvent enum in src/modules/quest.pwn -- ids must agree.
INSERT INTO "quest_events" VALUES (0,'QUEST_EVT_NONE');
INSERT INTO "quest_events" VALUES (1,'QUEST_EVT_PROPERTY_RENTED');
INSERT INTO "quest_events" VALUES (2,'QUEST_EVT_PROPERTY_BOUGHT');
INSERT INTO "quest_events" VALUES (3,'QUEST_EVT_RACE_FINISHED');
INSERT INTO "quest_events" VALUES (4,'QUEST_EVT_TEAM_JOINED');
INSERT INTO "quest_events" VALUES (5,'QUEST_EVT_PM_SENT');
INSERT INTO "quest_events" VALUES (6,'QUEST_EVT_BANK_DEPOSIT');
INSERT INTO "quest_events" VALUES (7,'QUEST_EVT_DEATHMATCH_PLAYED');
INSERT INTO "quest_events" VALUES (8,'QUEST_EVT_DEATHMATCH_WON');
INSERT INTO "quest_events" VALUES (9,'QUEST_EVT_TRUCKING_DONE');
INSERT INTO "quest_events" VALUES (10,'QUEST_EVT_TAXI_DONE');
INSERT INTO "quest_events" VALUES (11,'QUEST_EVT_TOW_DONE');
INSERT INTO "quest_events" VALUES (12,'QUEST_EVT_COMBAT_DONE');
INSERT INTO "quest_events" VALUES (13,'QUEST_EVT_RAMPAGE_DONE');
INSERT INTO "quest_events" VALUES (14,'QUEST_EVT_DRUG_DONE');

INSERT INTO "quest_types" ("id","event","target","reward","seq_no") VALUES
	(1,  4, 1,  5000, 10),
	(2,  3, 1, 10000, 20),
	(3, 10, 3, 15000, 30),
	(4,  9, 3, 15000, 40),
	(5,  1, 1,  5000, 50),
	(6,  2, 1, 25000, 60),
	(7,  6, 1,  2500, 70),
	(8,  5, 1,  2500, 80),
	(9,  7, 1,  5000, 90);

INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(1, 0, 'Join a team','You can find the team joining pickups at train stations, petrol stations, airports, paintjob shops etc.\n\nThe Pickup is of the form of a credit/ID card.'),
	(1, 1, 'Pridej se k tymu','Pickupy pro vstup do teamu jsou rozmisteny okolo nadrazi, letist, benzinek, opraven aut a dalsich.\n\nPickup samotny ma tvar kreditni/identifikacni karty.'),
	(2, 0, 'Finish a race','Choose a race from the /race command list and finish it completely.'),
	(2, 1, 'Dokonci zavod','Vyber si zavod ze seznamu zavodu prikazu /race a usposne jej dokonci.'),
	(3, 0, 'Complete 3 taxi fares','Join the Taximen team, take a taxi as a driver and complete 3 Taxi missions using /taxi.'),
	(3, 1, 'Odvez 3 zakazniky taxikem','Pridej se k tymu Taximen, sezen taxik a pomoci prikazu /taxi zajed 3 Taxi mise.'),
	(4, 0, 'Complete 3 trucking runs','Get a truck cabin with a trailer attached and complete 3 Trucking missions using /truck.'),
	(4, 1, 'Dokonci 3 kamionove jizdy','Sezen si kamion s privesem a uspesne zvladni zajet 3 Trucking mise pomoci prikazu /truck.'),
	(5, 0, 'Rent a property','Find a blue house pickup indicating that such property is commercial and rent it for you.'),
	(5, 1, 'Pronajmi si nemovitost','Najdi nektery pickup ve forme modreho domku, ktery oznacuje danou nemovitost jako komercni, a uspesne si nemovitost pronajmi.'),
	(6, 0, 'Buy a property','Find a green house pickup indicating that such property is personal and thus for sell and buy it for yourself.'),
	(6, 1, 'Kup si nemovitost','Najdi nektery pickup ve forme zeleneho domku, ktery oznacuje danou nemovitost jako osobni, a uspesne si nemovitost kup.'),
	(7, 0, 'Deposit money in the bank','Find a ATM (a green dollar sign on the minimap) and deposit some cash there.'),
	(7, 1, 'Uloz penize do banky','Najdi bankomat (symbol zeleneho dolaru na minimape) a uloz si svou hotovost na ucet.'),
	(8, 0, 'Send a private message','Open your phone using the Y key and send a private message to other online player!'),
	(8, 1, 'Posli soukromou zpravu','Otevri svuj mobil pomoci klavesy Y a posli jinemu hraci soukromou zpravu.'),
	(9, 0, 'Play a deathmatch round','Register to /deathmatch. Survive for the full period of time of sush deathmatch.'),
	(9, 1, 'Zahraj si deathmatch','Registruj se do /deathmatch. Prezij celou dobu uvnitr minihry.');

DROP TABLE IF EXISTS "tutorials";

-- +goose Down
CREATE TABLE IF NOT EXISTS "tutorials" (
	"id"	INTEGER,
	"user_id"	INTEGER NOT NULL UNIQUE,
	"active"	INTEGER DEFAULT 0,
	"property_rented_count"	INTEGER DEFAULT 0,
	"property_bought_count"	INTEGER DEFAULT 0,
	"race_finished_count"	INTEGER DEFAULT 0,
	"joined_team"	INTEGER DEFAULT 0,
	"trucking_missions_done"	INTEGER DEFAULT 0,
	"taxi_missions_done"	INTEGER DEFAULT 0,
	"sent_pm"	INTEGER DEFAULT 0,
	"deposited_money_to_bank"	INTEGER DEFAULT 0,
	"deathmatch_played"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "users"("id")
);

DROP TABLE IF EXISTS "quests";
DROP TABLE IF EXISTS "quest_labels";
DROP TABLE IF EXISTS "quest_types";
DROP TABLE IF EXISTS "quest_events";
