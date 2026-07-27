-- +goose up
CREATE TABLE IF NOT EXISTS "druggery_points" (
	"id"	INTEGER,
	"x"	    REAL NOT NULL,
	"y"	    REAL NOT NULL,
	"z"	    REAL NOT NULL,
    "note"  TEXT,	
	PRIMARY KEY("id" AUTOINCREMENT)
);

INSERT INTO "druggery_points" VALUES (0, 645.68, -510.51, 16.33, "Dillimore");
INSERT INTO "druggery_points" VALUES (1, 1280.85, 304.07, 19.55, "Montgomery");
INSERT INTO "druggery_points" VALUES (2, 2836.32, -2137.32, 0.19, "Hackerz spot");
INSERT INTO "druggery_points" VALUES (3, 2263.64, -755.60, 38.04, "LS Train Tunnel");
INSERT INTO "druggery_points" VALUES (4, 1488.97, -1720.46, 8.23, "LS Drainage Tunnel");

-- +goose Down
DROP TABLE IF EXISTS "druggery_points";
