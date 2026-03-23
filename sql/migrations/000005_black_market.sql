-- +goose up
CREATE TABLE IF NOT EXISTS "black_market_items" (
	"id"	INTEGER,
	"settler_id"	INTEGER NOT NULL,
	"drug_type"	INTEGER NOT NULL,
	"amount"	REAL NOT NULL,
	"value"	REAL NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("drug_type") REFERENCES "drug_types"("id"),
	FOREIGN KEY("settler_id") REFERENCES "users"("id")
);

-- +goose Down
DROP TABLE IF EXISTS "black_market_items"
