-- +goose up

-- Combat mission 3, Sherman Dam, and the combat_coords columns it needs.
--
-- interior: the interior an NPC, NPC_MAN or SPAWN row is in. Pickups and
-- vehicles ignore it. target_*: where a DOOR pickup leads; a door with no
-- target (mission 2's) stays scenery.
ALTER TABLE "combat_coords" ADD COLUMN "interior" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "combat_coords" ADD COLUMN "target_x" REAL;
ALTER TABLE "combat_coords" ADD COLUMN "target_y" REAL;
ALTER TABLE "combat_coords" ADD COLUMN "target_z" REAL;
ALTER TABLE "combat_coords" ADD COLUMN "target_interior" INTEGER;

INSERT INTO "combat_coord_types" VALUES (10, 'COORD_SPAWN');

-- Mission 1 is played in the Planning Department (interior 3), which is
-- where its NPCs were always created; the heli, roof, checkpoint and
-- briefcase man are outside. Mission 2 stays in interior 0.
UPDATE "combat_coords" SET "interior" = 3 WHERE "mission_id" = 1 AND "type" IN (1, 2, 3, 5);

-- Start positions, formerly hardcoded in SetCombatMission().
INSERT INTO "combat_coords" ("type","mission_id","x","y","z","interior") VALUES
	(10, 1, 376.27, 186.46, 1008.38, 3),
	(10, 2, 20.9, 2233.0, 101.1, 0);

-- Sherman Dam: start on the quay at the foot of the dam, fight up it to the
-- door, go through the generator hall (interior 17) to the exit at its north
-- end, which comes out on the crest by the control tower door. Fly the
-- Maverick waiting there to the Verdant Meadows helipad and hand the
-- briefcases to the man by the tower office.
--
-- The door and exit sit where the game's own dam entrances are (the DAMOUT
-- enex and the alternate door at the foot of the dam); the crest landing is
-- 7 units north of the tower door so it misses the property pickup there.
-- Every point was checked against the map collision: a floor 1.0 below it
-- and head room above.
INSERT INTO "combat_mission" VALUES (3, 'Sherman Dam');

INSERT INTO "combat_coords" ("type","mission_id","x","y","z","interior") VALUES
	-- quay
	(10, 3, -811.07, 1816.08, 7.0, 0),
	(2, 3, -806.0, 1842.0, 7.0, 0),
	(2, 3, -814.0, 1878.0, 7.0, 0),
	(2, 3, -820.0, 1920.0, 7.0, 0),
	(2, 3, -826.0, 1960.0, 7.0, 0),
	(2, 3, -828.5, 1976.0, 7.0, 0),
	(3, 3, -816.0, 1895.0, 7.0, 0);

INSERT INTO "combat_coords" ("type","mission_id","x","y","z","interior","target_x","target_y","target_z","target_interior") VALUES
	(9, 3, -830.27, 1982.12, 9.25, 0, -942.13, 1849.14, 5.0, 17);

INSERT INTO "combat_coords" ("type","mission_id","x","y","z","interior") VALUES
	-- generator hall: main floor at z 4, turbine platforms and walkway at z 8
	(1, 3, -952.0, 1867.0, 5.0, 17),
	(1, 3, -948.0, 1878.6, 9.0, 17),
	(1, 3, -942.0, 1900.0, 5.0, 17),
	(1, 3, -957.0, 1910.5, 5.0, 17),
	(1, 3, -957.0, 1924.0, 9.0, 17),
	(1, 3, -944.0, 1930.0, 5.0, 17),
	(1, 3, -957.0, 1943.0, 9.0, 17),
	(3, 3, -940.0, 1888.0, 5.0, 17),
	(3, 3, -940.0, 1945.0, 5.0, 17),
	(2, 3, -945.0, 1858.0, 5.0, 17),
	(2, 3, -956.0, 1855.0, 9.0, 17),
	(2, 3, -940.0, 1872.0, 5.0, 17),
	(2, 3, -957.0, 1876.0, 9.0, 17),
	(2, 3, -959.5, 1895.0, 9.0, 17),
	(2, 3, -948.0, 1903.0, 9.0, 17),
	(2, 3, -940.0, 1912.0, 5.0, 17),
	(2, 3, -948.0, 1919.0, 9.0, 17),
	(2, 3, -952.0, 1933.0, 5.0, 17),
	(2, 3, -940.0, 1938.0, 5.0, 17),
	(2, 3, -948.5, 1946.0, 9.0, 17),
	(2, 3, -956.0, 1952.0, 5.0, 17),
	(5, 3, -959.5, 1953.5, 9.0, 17),
	-- crest (the ROOF row has to come after the EXIT row)
	(6, 3, -593.5, 2027.0, 60.2, 0),
	(4, 3, -578.0, 2030.0, 60.2, 0),
	(2, 3, -586.0, 2040.0, 60.2, 0),
	(2, 3, -600.0, 2042.0, 60.2, 0),
	(2, 3, -572.0, 2016.0, 60.2, 0),
	(2, 3, -610.0, 2040.0, 60.4, 0),
	(3, 3, -590.0, 2030.0, 60.4, 0),
	-- Verdant Meadows
	(7, 3, 387.6, 2525.55, 16.5, 0),
	(8, 3, 410.0, 2528.0, 16.6, 0);

-- +goose Down
DELETE FROM "high_scores" WHERE "type" = 5 AND "spec_id" = 3;
DELETE FROM "combat_coords" WHERE "mission_id" = 3 OR "type" = 10;
DELETE FROM "combat_mission" WHERE "id" = 3;
DELETE FROM "combat_coord_types" WHERE "id" = 10;

ALTER TABLE "combat_coords" DROP COLUMN "target_interior";
ALTER TABLE "combat_coords" DROP COLUMN "target_z";
ALTER TABLE "combat_coords" DROP COLUMN "target_y";
ALTER TABLE "combat_coords" DROP COLUMN "target_x";
ALTER TABLE "combat_coords" DROP COLUMN "interior";
