-- +goose up
CREATE TABLE IF NOT EXISTS "police_bribe_coords" (
	"id"	INTEGER,
	"x"	REAL,
	"y"	REAL,
	"z"	REAL,
	"note"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "police_bribe_coords" VALUES (3,-213.49,2717.62,62.68,'Las Payasadas');
INSERT INTO "police_bribe_coords" VALUES (4,610.16,2832.4,23.94,'Bone County top north');
INSERT INTO "police_bribe_coords" VALUES (5,599.22,2125.88,39.11,'Bone County near Area51');
INSERT INTO "police_bribe_coords" VALUES (6,206.59,1095.63,16.52,'Fort Carson');
INSERT INTO "police_bribe_coords" VALUES (8,-424.67,1386.42,14.26,'The Big Ear tunnel');
INSERT INTO "police_bribe_coords" VALUES (9,2095.88,1285.42,10.82,'LV: Pyramid');
INSERT INTO "police_bribe_coords" VALUES (10,2520.79,-2441.05,13.18,'LS: Docks north');
INSERT INTO "police_bribe_coords" VALUES (11,1106.19,-709.86,104.6,'LS: Mulholland');
