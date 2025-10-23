CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "drug_prices" (
	"id"	INTEGER,
	"name"	TEXT,
	"name_alt"	TEXT,
	"amount"	INTEGER,
	"price"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "race_coords" (
	"id"	INTEGER,
	"race_id"	INTEGER,
	"seq_no"	INTEGER,
	"x"	REAL,
	"y"	REAL,
	"z"	REAL,
	"rot"	REAL,
	PRIMARY KEY("id"),
	FOREIGN KEY("race_id") REFERENCES "races"("id")
);
CREATE TABLE IF NOT EXISTS "race_types" (
	"id"	INTEGER,
	"label"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "races" (
	"id"	INTEGER,
	"name"	TEXT,
	"type"	INTEGER,
	"cost_dollars"	INTEGER,
	"prize_dollars"	INTEGER,
	"start_x"	REAL,
	"start_y"	REAL,
	"start_z"	REAL,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "race_types"("id")
);
CREATE TABLE IF NOT EXISTS "teams" (
	"id"	INTEGER,
	"name"	TEXT,
	"color"	TEXT,
	"skins"	TEXT,
	"weapons"	TEXT,
	"ammu"	TEXT,
	"salary_base_dollars"	INTEGER NOT NULL,
	"salary_volatile_dollars"	INTEGER NOT NULL,
	"pickups"	TEXT,
	"menus"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "drug_owner_type" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "drugz" (
	"id"	INTEGER,
	"owner_type"	INTEGER NOT NULL DEFAULT 2,
	"owner_id"	INTEGER NOT NULL UNIQUE,
	"cocaine"	INTEGER DEFAULT 0,
	"heroin"	INTEGER DEFAULT 0,
	"meth"	INTEGER DEFAULT 0,
	"fent"	INTEGER DEFAULT 0,
	"zaza"	INTEGER DEFAULT 0,
	"tobacco"	INTEGER DEFAULT 0,
	"pcp"	INTEGER DEFAULT 0,
	"paper"	INTEGER DEFAULT 0,
	"lighter"	INTEGER DEFAULT 0,
	"joint"	INTEGER DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("owner_type") REFERENCES "drug_owner_type"("id")
);
CREATE TABLE IF NOT EXISTS "users" (
	"id"	INTEGER,
	"nickname"	TEXT NOT NULL,
	"pwdhash"	TEXT NOT NULL,
	"salt"	TEXT NOT NULL,
	"cash"	INTEGER NOT NULL,
	"bank"	INTEGER NOT NULL,
	"adminlvl"	INTEGER NOT NULL,
	"wanted"	INTEGER NOT NULL DEFAULT 0,
	"team"	INTEGER NOT NULL,
	"class"	INTEGER NOT NULL,
	"health"	INTEGER NOT NULL,
	"armour"	INTEGER NOT NULL,
	"spawn"	INTEGER NOT NULL,
	"properties"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "truck_type" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "trucking_coord_types" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT
);
CREATE TABLE IF NOT EXISTS "trucking_coords" (
	"id"	INTEGER NOT NULL,
	"type"	INTEGER NOT NULL,
	"x"	REAL NOT NULL,
	"y"	REAL NOT NULL,
	"z"	REAL NOT NULL,
	"rot"	REAL NOT NULL,
	"trucking_id"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("trucking_id") REFERENCES "trucking_points"("id"),
	FOREIGN KEY("type") REFERENCES "trucking_coord_types"("id")
);
CREATE TABLE IF NOT EXISTS "trucking_points" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT,
	"type"	INTEGER NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "trucking_facility_types"("id")
);
CREATE TABLE IF NOT EXISTS "trucking_facility_types" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "high_scores" (
	"id"	INTEGER,
	"race_id"	INTEGER NOT NULL,
	"nickname"	TEXT NOT NULL,
	"time"	INTEGER NOT NULL,
	"car_model"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("nickname") REFERENCES "users"("nickname"),
	FOREIGN KEY("race_id") REFERENCES "races"("id")
);
CREATE TABLE IF NOT EXISTS "property_coord_types" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "property_coords" (
	"id"	INTEGER NOT NULL,
	"property_id"	INTEGER NOT NULL,
	"type"	INTEGER,
	"primary_x"	REAL,
	"primary_y"	REAL,
	"primary_z"	REAL,
	"primary_rot"	REAL,
	"secondary_x"	REAL,
	"secondary_y"	REAL,
	"secondary_z"	REAL,
	"secondary_rot"	REAL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("property_id") REFERENCES "properties"("id"),
	FOREIGN KEY("type") REFERENCES "property_coord_types"("id")
);
CREATE TABLE IF NOT EXISTS "vehicles" (
	"id"	INTEGER,
	"model"	INTEGER,
	"color1"	INTEGER,
	"color2"	INTEGER,
	"components"	TEXT,
	"paintjob"	INTEGER,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "property_skins" (
	"id"	INTEGER,
	"property_id"	INTEGER NOT NULL,
	"skin_id"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("property_id") REFERENCES "properties"("id")
);
CREATE TABLE IF NOT EXISTS "property_types" (
	"id"	INTEGER,
	"name"	TEXT UNIQUE,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "properties" (
	"id"	INTEGER,
	"type"	INTEGER NOT NULL DEFAULT 1,
	"user_id"	INTEGER NOT NULL,
	"vehicle_id"	INTEGER,
	"name"	TEXT NOT NULL,
	"cost"	INTEGER NOT NULL,
	"occupied"	INTEGER DEFAULT 0,
	"custom_interior"	INTEGER DEFAULT 0,
	"locked_until_timestamp"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "property_types"("id"),
	FOREIGN KEY("user_id") REFERENCES "users"("id"),
	FOREIGN KEY("vehicle_id") REFERENCES "vehicles"("id")
);
CREATE TABLE IF NOT EXISTS "atm_coords" (
	"id"	INTEGER,
	"x"	REAL NOT NULL,
	"y"	REAL NOT NULL,
	"z"	REAL NOT NULL,
	"comment"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "prize_types" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "prize_coords" (
	"id"	INTEGER NOT NULL,
	"type"	INTEGER NOT NULL DEFAULT 0,
	"name"	TEXT,
	"comment"	TEXT,
	"x"	INTEGER NOT NULL DEFAULT 0.0,
	"y"	INTEGER NOT NULL DEFAULT 0.0,
	"z"	INTEGER NOT NULL DEFAULT 0.0,
	"hidden"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "prize_types"("id")
);
CREATE TABLE IF NOT EXISTS "drug_types" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "drug_coords" (
	"id"	INTEGER,
	"type"	INTEGER NOT NULL,
	"x"	REAL,
	"y"	REAL,
	"z"	REAL,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "drug_types"("id")
);
CREATE TABLE IF NOT EXISTS "team_coords" (
	"id"	INTEGER,
	"team_id"	INTEGER NOT NULL,
	"x"	REAL,
	"y"	REAL,
	"z"	REAL,
	PRIMARY KEY("id"),
	FOREIGN KEY("team_id") REFERENCES "teams"("id")
);
CREATE TABLE IF NOT EXISTS "combat_coord_types" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "combat_coords" (
	"id"	INTEGER,
	"type"	INTEGER NOT NULL DEFAULT 0,
	"x"	REAL NOT NULL,
	"y"	REAL NOT NULL,
	"z"	REAL NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("type") REFERENCES "combat_coord_types"("id")
);
