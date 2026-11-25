-- +goose up

-- Fuel stock of the petrol stations (trucking_points of type 2 GAS_STATION):
-- NPC tankers top the tanks up, players buy fuel from them (modules/fuel.pwn).
-- Litres and $ per litre. Every station starts half full, at a price of its
-- own between $3 and $7.
CREATE TABLE IF NOT EXISTS "gas_stations" (
	"trucking_id"	INTEGER NOT NULL,
	"fuel"	INTEGER NOT NULL DEFAULT 0,
	"capacity"	INTEGER NOT NULL DEFAULT 10000,
	"price"	INTEGER NOT NULL DEFAULT 5,
	PRIMARY KEY("trucking_id"),
	FOREIGN KEY("trucking_id") REFERENCES "trucking_points"("id")
);

INSERT OR IGNORE INTO "gas_stations" ("trucking_id","fuel","capacity","price")
	SELECT "id", 5000, 10000, 3 + ("id" * 7) % 5 FROM "trucking_points" WHERE "type" = 2;

-- +goose Down
DROP TABLE IF EXISTS "gas_stations";
