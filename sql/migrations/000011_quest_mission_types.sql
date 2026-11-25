-- +goose up

-- 000010 seeded nine quests, covering nine of the fifteen QuestEvent values in
-- src/modules/quest.pwn. These five fill in the mission events that had no
-- quest_types row: tow, drug, rampage, deathmatch-won and combat.
--
-- ids continue from 9; seq_no continues the 10-step ladder from 90.
--
-- Targets follow how each event actually fires:
--   tow      fires per delivered vehicle (CheckTowMissionCheckpoint) -> 3
--   drug     fires once per run that collected anything              -> 1
--   rampage  fires once per run with a non-zero kill count           -> 1
--   dm won   fires once for the top scorer of a finished round       -> 1
--   combat   fires once per successful mission                       -> 1
INSERT INTO "quest_types" ("id","event","target","reward","seq_no","active") VALUES
	(10, 11, 3, 15000, 100, 1),
	(11, 14, 1, 10000, 110, 1),
	(12, 13, 1, 20000, 120, 1),
	(13,  8, 1, 25000, 130, 1),
	(14, 12, 1, 30000, 140, 1);

-- Descriptions deliberately contain no "\n": SQLite stores the escape as two
-- literal characters rather than a line break (the quest_type 1 rows seeded in
-- 000010 render a visible "\n" in-game because of this), and
-- ShowPlayerQuestDescDialog already puts a blank line after the label.
-- Czech strings stay diacritic-free, as in 000010.
INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(10, 0, 'Tow 3 vehicles','Get behind the wheel of a tow truck, start a run with /tow, hitch up parked vehicles with the submission key and deliver 3 of them to the San Fierro dock.'),
	(10, 1, 'Odtahni 3 vozidla','Sedni si za volant odtahovky, spust jizdu prikazem /tow, pripoj zaparkovana vozidla klavesou submission a odvez 3 z nich do doku v San Fierru.'),
	(11, 0, 'Complete a drug run','Join the Dealers team, start a run with /drug and collect drug pickups around the map. End the run with /drug again to bank what you picked up.'),
	(11, 1, 'Dokonci drogovou jizdu','Pridej se k tymu Dealers, spust jizdu prikazem /drug a sesbirej drogove pickupy po mape. Jizdu ukonci opet prikazem /drug.'),
	(12, 0, 'Survive a rampage','Find a rampage start pickup in Las Venturas, San Fierro or Los Santos and last the full five minute firefight. You have to take down at least one NPC.'),
	(12, 1, 'Prezij rampage','Najdi startovni pickup rampage v Las Venturas, San Fierru nebo Los Santos a vydrz celou petiminutovou prestrelku. Musis sejmout aspon jedno NPC.'),
	(13, 0, 'Win a deathmatch round','Register to /deathmatch, survive the round and finish it as the player with the highest score.'),
	(13, 1, 'Vyhraj kolo deathmatche','Registruj se do /deathmatch, prezij cele kolo a dokonci jej jako hrac s nejvyssim skore.'),
	(14, 0, 'Complete a combat mission','Start a mission with /combat, loot the briefcases inside the interior and hand them over to the briefcase man to get paid.'),
	(14, 1, 'Dokonci combat misi','Spust misi prikazem /combat, poseber kufriky uvnitr interieru a predej je briefcase manovi, ktery te vyplati.');

UPDATE quest_labels SET desc = replace(desc, '\n', char(10)) WHERE quest_type = 1;

-- +goose Down
DELETE FROM "quests" WHERE "quest_type" IN (10, 11, 12, 13, 14);
DELETE FROM "quest_labels" WHERE "quest_type" IN (10, 11, 12, 13, 14);
DELETE FROM "quest_types" WHERE "id" IN (10, 11, 12, 13, 14);
