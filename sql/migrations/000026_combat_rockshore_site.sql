-- +goose up

-- Combat mission 4, Rockshore Building Site: played outdoors, on the
-- building site in Rockshore East where the Dozer is parked
-- (src/support/vehicles.pwn). Start on the pavement at the site's south-east
-- corner, fight across the ground-floor slab, drop into the open pit and
-- through the basement under the slab, climb the dirt ramp (or cross the
-- excavation by the freeway) into the yard, and take the Maverick waiting
-- at the yard's north end. It has no exit pickup, so getting into the
-- Maverick shows the checkpoint (CheckCombatVehicle). Fly it to the helipad
-- on the roof of K.A.C.C. Military Fuels and hand the briefcases to the man
-- by the stairs.
--
-- Levels: basement floor at z 4.3 under the slab at z 10 (open to the sky
-- over the pit), excavation floor at z 5.1, yard at z 8 to 10, pad at 35.5.
-- Every point was checked against the map collision: a floor 1.0 below it,
-- head room above, no wall closer than 1.6 (columns and pallets are cover),
-- and every pickup reachable on foot from the start. The Maverick has 8
-- units of flat ground around it.
INSERT INTO "combat_mission" VALUES (4, 'Rockshore Building Site');

INSERT INTO "combat_coords" ("type","mission_id","x","y","z","interior") VALUES
	-- start, on the pavement by the scaffolding on the site's east side
	(10, 4, 2719.0, 790.0, 10.9, 0),
	-- ground-floor slab, the west end under the first-floor frame
	(2, 4, 2692.0, 800.0, 10.95, 0),
	(2, 4, 2668.0, 822.0, 10.95, 0),
	(2, 4, 2640.0, 790.0, 10.95, 0),
	(2, 4, 2610.0, 812.0, 10.82, 0),
	(2, 4, 2585.0, 790.0, 10.95, 0),
	(1, 4, 2660.0, 790.0, 10.95, 0),
	(1, 4, 2565.0, 805.0, 10.95, 0),
	(3, 4, 2600.0, 790.0, 10.95, 0),
	-- basement and the open pit
	(2, 4, 2672.0, 800.0, 5.32, 0),
	(2, 4, 2600.0, 805.0, 5.32, 0),
	(2, 4, 2570.0, 830.0, 5.32, 0),
	(2, 4, 2640.0, 840.0, 5.32, 0),
	(1, 4, 2690.0, 820.0, 5.32, 0),
	(1, 4, 2580.0, 790.0, 5.32, 0),
	(1, 4, 2635.0, 815.0, 5.32, 0),
	(3, 4, 2620.0, 790.0, 5.32, 0),
	-- excavation by the freeway embankment
	(2, 4, 2648.0, 870.0, 6.09, 0),
	(2, 4, 2641.0, 851.0, 6.09, 0),
	(1, 4, 2652.0, 878.0, 6.1, 0),
	(3, 4, 2655.0, 855.0, 6.14, 0),
	-- yard: the dirt ramp, the skips, the concrete pipes and the pallets
	(2, 4, 2700.0, 840.0, 9.23, 0),
	(2, 4, 2695.0, 850.0, 9.02, 0),
	(2, 4, 2674.0, 856.0, 10.94, 0),
	(2, 4, 2704.0, 870.0, 9.92, 0),
	(2, 4, 2668.0, 885.0, 7.52, 0),
	(2, 4, 2712.0, 885.0, 10.76, 0),
	(2, 4, 2690.0, 895.0, 10.18, 0),
	(2, 4, 2705.0, 900.0, 10.34, 0),
	(2, 4, 2704.0, 912.0, 10.81, 0),
	(1, 4, 2686.0, 866.0, 9.84, 0),
	(1, 4, 2698.0, 901.0, 10.37, 0),
	(3, 4, 2706.0, 858.0, 9.84, 0),
	(4, 4, 2686.5, 906.0, 10.57, 0),
	-- K.A.C.C. Military Fuels helipad
	(7, 4, 2619.0, 2721.0, 36.54, 0),
	(8, 4, 2626.0, 2732.0, 36.54, 0);

-- +goose Down
DELETE FROM "high_scores" WHERE "type" = 5 AND "spec_id" = 4;
DELETE FROM "combat_coords" WHERE "mission_id" = 4;
DELETE FROM "combat_mission" WHERE "id" = 4;
