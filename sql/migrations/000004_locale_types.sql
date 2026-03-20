-- +goose up
CREATE TABLE IF NOT EXISTS "locale_types" (
	"id"	INTEGER,
	"name"	TEXT UNIQUE,
	"lang_name"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "locale_types" VALUES (0,'LOCALE_EN','English');
INSERT INTO "locale_types" VALUES (1,'LOCALE_CZ','Czech');

ALTER TABLE "users" ADD COLUMN "locale" INTEGER DEFAULT 0;
CREATE TABLE "users_copy" AS SELECT * FROM "users";
DROP TABLE "users";

CREATE TABLE IF NOT EXISTS "users" (
	"id"	INTEGER,
	"nickname"	TEXT NOT NULL,
	"pwdhash"	TEXT NOT NULL,
	"salt"	TEXT NOT NULL,
	"cash"	INTEGER NOT NULL,
	"bank"	INTEGER NOT NULL,
	"adminlvl"	INTEGER NOT NULL DEFAULT 0,
	"wanted"	INTEGER NOT NULL DEFAULT 0,
	"team"	INTEGER NOT NULL,
	"class"	INTEGER NOT NULL,
	"health"	INTEGER NOT NULL,
	"armour"	INTEGER NOT NULL,
	"spawn"	INTEGER NOT NULL,
	"properties"	TEXT,
	"locale" INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("locale") REFERENCES "locale_types"("id")
);

INSERT INTO "users" SELECT * FROM "users_copy";
DROP TABLE "users_copy";

-- +goose Down
ALTER TABLE "users" DROP COLUMN "locale";
DROP TABLE IF EXISTS "locale_types";
