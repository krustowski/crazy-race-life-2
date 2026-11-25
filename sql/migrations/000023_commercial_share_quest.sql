-- +goose up

-- Quest for renting every commercial property at once. QUEST_EVT_COMMERCIAL_SHARE
-- (19) is a level event, not a count: RentProperty in src/modules/real.pwn and
-- the login path in src/modules/auth.pwn report the share of all commercial
-- properties the player rents right now, in percent rounded down, and progress
-- keeps the highest share reported (FireQuestLevelEvent). The target of 100
-- therefore means every single commercial property, however many there are.
--
-- ids continue from 22; seq_no continues the 10-step ladder from 220. As in
-- 000011, descriptions contain no "\n", and Czech and Bosnian strings stay
-- diacritic-free.

-- Mirrors the QuestEvent enum in src/modules/quest.pwn -- ids must agree.
INSERT INTO "quest_events" VALUES (19,'QUEST_EVT_COMMERCIAL_SHARE');

INSERT INTO "quest_types" ("id","event","target","reward","seq_no","active") VALUES
	(23, 19, 100, 5000000, 230, 1);

INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(23, 0, 'Rent 100% of commercial properties','Rent every commercial property (a blue house pickup) at the same time. A property you rent stays locked for 3 days, after that anyone can take it over. Progress is the highest share in percent you have held so far.'),
	(23, 1, 'Pronajmi si 100% komercnich nemovitosti','Mej v pronajmu vsechny komercni nemovitosti (pickup modreho domku) najednou. Pronajata nemovitost je 3 dny zamcena, pak ti ji muze kdokoli prebrat. Postup je nejvyssi podil v procentech, jaky jsi zatim drzel.'),
	(23, 2, 'Iznajmi 100% komercijalnih nekretnina','Drzi u najmu sve komercijalne nekretnine (pickup plave kucice) u isto vrijeme. Iznajmljena nekretnina je 3 dana zakljucana, onda je bilo ko moze preuzeti. Napredak je najveci udio u procentima koji si do sada imao.');

-- +goose Down
DELETE FROM "quests" WHERE "quest_type" = 23;
DELETE FROM "quest_labels" WHERE "quest_type" = 23;
DELETE FROM "quest_types" WHERE "id" = 23;
DELETE FROM "quest_events" WHERE "id" = 19;
