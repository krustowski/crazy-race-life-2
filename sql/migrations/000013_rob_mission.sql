-- +goose up

-- The Robberz team (id 10) and the Rob Mission high score type (9), see
-- src/modules/rob.pwn.
--
-- Robbers make their money robbing commercial properties, so their salary sits
-- below every other team's. Loadout: baseball bat, silenced 9mm, sawn-off and a
-- micro Uzi. The skin is Ryder (271), matching the job pickup's map icon.
INSERT INTO "teams" VALUES (10,'Robberz','9932CCAA','271,0,0,0,0','5,23,26,28,0,0,0,0,0,0,0','1,170,50,300,0,0,0,0,0,0,0',1000,500,'0','0');

INSERT INTO "team_coords" ("team_id","x","y","z") VALUES (10, 2456.26, -1759.78, 13.58);

-- spec_id holds the robbed property count, value the money earned.
INSERT INTO "high_scores_types" VALUES (9,'TYPE_MISSION_ROB');

-- +goose Down
DELETE FROM "high_scores" WHERE "type" = 9;
DELETE FROM "high_scores_types" WHERE "id" = 9;

DELETE FROM "team_coords" WHERE "team_id" = 10;
UPDATE "users" SET "team" = 0 WHERE "team" = 10;
DELETE FROM "teams" WHERE "id" = 10;
