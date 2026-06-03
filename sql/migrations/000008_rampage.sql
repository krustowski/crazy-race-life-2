-- +goose up
CREATE TABLE IF NOT EXISTS "rampage_location_types" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "rampages" (
	"id"	INTEGER,
	"name"	TEXT,
	"location_type"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
    FOREIGN KEY("location_type") REFERENCES "rampage_location_types"("id")
);

CREATE TABLE IF NOT EXISTS "rampage_coord_types" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "rampage_coords" (
	"id"	INTEGER,
	"rampage_id"	INTEGER NOT NULL,
	"type"	INTEGER NOT NULL,
	"weapon_id"	INTEGER,
	"ammo"	INTEGER,
	"primary_x"	REAL NOT NULL,
	"primary_y"	REAL NOT NULL,
	"primary_z"	REAL NOT NULL,	
    "secondary_x"	REAL,
	"secondary_y"	REAL,
	"secondary_z"	REAL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("rampage_id") REFERENCES "rampages"("id"),
	FOREIGN KEY("type") REFERENCES "rampage_coord_types"("id")
);

INSERT INTO "high_scores_types" VALUES (7,'TYPE_MISSION_RAMPAGE');
INSERT INTO "high_scores_types" VALUES (8,'TYPE_MISSION_DRUG');

INSERT INTO "rampage_coord_types" VALUES (0,'TYPE_COORD_NONE');
INSERT INTO "rampage_coord_types" VALUES (1,'TYPE_COORD_PICKUP');
INSERT INTO "rampage_coord_types" VALUES (2,'TYPE_COORD_NPC_SPAWN');
INSERT INTO "rampage_coord_types" VALUES (3,'TYPE_COORD_NPC_MOVE');
INSERT INTO "rampage_coord_types" VALUES (4,'TYPE_COORD_WEAPON_SPAWN');
INSERT INTO "rampage_coord_types" VALUES (5,'TYPE_COORD_HEALTH_POINT');

INSERT INTO "rampage_location_types" VALUES (0,'TYPE_LOCATION_NONE');
INSERT INTO "rampage_location_types" VALUES (1,'TYPE_LOCATION_LV');
INSERT INTO "rampage_location_types" VALUES (2,'TYPE_LOCATION_SF');
INSERT INTO "rampage_location_types" VALUES (3,'TYPE_LOCATION_LS');


-- +goose Down
DELETE FROM "high_scores_types" WHERE "id" = 8;
DELETE FROM "high_scores_types" WHERE "id" = 7;

DROP TABLE IF EXISTS "rampage_coords";
DROP TABLE IF EXISTS "rampage_coord_types";
DROP TABLE IF EXISTS "rampages";
DROP TABLE IF EXISTS "rampage_location_types";
