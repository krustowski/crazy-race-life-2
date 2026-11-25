-- +goose up

-- Rob quests: 5, 50 and 500 robberies. QUEST_EVT_PROPERTY_ROBBED (15) fires
-- once per robbery that paid anything (StopRobbery in src/modules/rob.pwn), so
-- the targets count robbed properties.
--
-- ids continue from 14; seq_no continues the 10-step ladder from 140. As in
-- 000011, descriptions contain no "\n" and Czech strings stay diacritic-free.

-- Mirrors the QuestEvent enum in src/modules/quest.pwn -- ids must agree.
INSERT INTO "quest_events" VALUES (15,'QUEST_EVT_PROPERTY_ROBBED');

INSERT INTO "quest_types" ("id","event","target","reward","seq_no","active") VALUES
	(15, 15,   5,   20000, 150, 1),
	(16, 15,  50,  150000, 160, 1),
	(17, 15, 500, 1000000, 170, 1);

INSERT INTO "quest_labels" ("quest_type","locale","label","desc") VALUES
	(15, 0, 'Rob 5 properties','Join the Robberz team, stand by a commercial property (a blue house pickup) and hold LALT or LSHIFT to rob it for up to 20 seconds. Get away with cash from 5 robberies. Every robbery raises your wanted level.'),
	(15, 1, 'Vykradni 5 nemovitosti','Pridej se k tymu Robberz, postav se ke komercni nemovitosti (pickup modreho domku) a drz LALT nebo LSHIFT, cimz ji az 20 sekund vykradas. Odnes si lup z 5 loupezi. Kazda loupez ti zvysi hledanost.'),
	(16, 0, 'Rob 50 properties','Keep the Robberz business going and get away with cash from 50 robberies. A robbed property stays locked for 5 minutes, so keep moving between shops.'),
	(16, 1, 'Vykradni 50 nemovitosti','Pokracuj v loupeznem remesle a odnes si lup z 50 loupezi. Vykradena nemovitost je 5 minut zamcena, takze se mezi obchody presouvej.'),
	(17, 0, 'Rob 500 properties','Become a Robberz legend and get away with cash from 500 robberies. Robberies less than 5 minutes apart chain into one Rob mission and its high score.'),
	(17, 1, 'Vykradni 500 nemovitosti','Stan se legendou Robberz a odnes si lup z 500 loupezi. Loupeze mene nez 5 minut po sobe se spojuji do jedne loupezne mise a jejiho skore.');

-- +goose Down
DELETE FROM "quests" WHERE "quest_type" IN (15, 16, 17);
DELETE FROM "quest_labels" WHERE "quest_type" IN (15, 16, 17);
DELETE FROM "quest_types" WHERE "id" IN (15, 16, 17);
DELETE FROM "quest_events" WHERE "id" = 15;
