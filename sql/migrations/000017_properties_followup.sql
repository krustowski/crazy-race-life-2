-- +goose up

-- Three properties built in-game after the 000015 snapshot, with their
-- property_coords: 21601 Aldea Malvada: The Lost Pueblo and 21701 Sherman Dam
-- (commercial), 21801 Valle Ocultado Ville (personal). Taken from the running
-- database on 2026-11-05; ids are kept as they are there.
--
-- As in 000015, every insert is INSERT OR IGNORE, so on the running database
-- this migration only records the version, and properties are seeded unowned.
INSERT OR IGNORE INTO "properties" ("id","type","user_id","vehicle_id","name","cost","occupied","custom_interior","locked_until_timestamp") VALUES
	(21601, 2, 0, NULL, 'Aldea Malvada: The Lost Pueblo', 99000, 0, 0, 0),
	(21701, 2, 0, NULL, 'Sherman Dam', 330000, 0, 0, 0),
	(21801, 1, 0, NULL, 'Valle Ocultado Ville', 5600000, 0, 0, 0);

INSERT OR IGNORE INTO "property_coords" ("id","property_id","type","primary_x","primary_y","primary_z","primary_rot","secondary_x","secondary_y","secondary_z","secondary_rot") VALUES
	(678, 21601, 8, -1304.53, 2491.79, 87.14, 0.0, NULL, NULL, NULL, NULL),
	(679, 21701, 8, -593.66, 2020.36, 60.38, 0.0, NULL, NULL, NULL, NULL),
	(680, 21801, 1, -908.94, 2690.71, 42.37, 0.0, NULL, NULL, NULL, NULL),
	(681, 21801, 6, -911.62, 2686.62, 42.37, 0.0, NULL, NULL, NULL, NULL),
	(682, 21801, 8, -913.58, 2700.68, 42.36, 0.0, NULL, NULL, NULL, NULL),
	(683, 21801, 7, -904.45, 2697.04, 42.37, 315.44, NULL, NULL, NULL, NULL);

-- +goose Down
DELETE FROM "property_skins" WHERE "property_id" IN (21601, 21701, 21801);
DELETE FROM "vehicles" WHERE "id" IN (SELECT "vehicle_id" FROM "properties" WHERE "id" IN (21601, 21701, 21801));
DELETE FROM "property_coords" WHERE "property_id" IN (21601, 21701, 21801);
DELETE FROM "properties" WHERE "id" IN (21601, 21701, 21801);
