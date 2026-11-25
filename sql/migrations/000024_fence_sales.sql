-- +goose up

-- The fence (src/modules/fence.pwn): Dealerz sell drugz to the server at the
-- druggery points, one row per sale. The gamemode sums a player's rows of the
-- last hour for the hourly unit and dollar limits, so the rows must stay; they
-- are also the data for tuning those limits and the market ratio.
--
-- drug_type is drug_types.id (the DrugType tag, 1-based). value is what the
-- fence paid in dollars, ratio the market ratio the sale was priced at (before
-- the sale pushed it down), sold_at a unix timestamp from gettime().

CREATE TABLE IF NOT EXISTS "fence_sales" (
	"id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"drug_type"	INTEGER NOT NULL,
	"amount"	INTEGER NOT NULL,
	"value"	INTEGER NOT NULL,
	"ratio"	REAL NOT NULL,
	"sold_at"	INTEGER NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "users"("id"),
	FOREIGN KEY("drug_type") REFERENCES "drug_types"("id")
);

-- Every fence dialog and sale reads one player's last hour
CREATE INDEX IF NOT EXISTS "fence_sales_user_sold_at" ON "fence_sales" ("user_id", "sold_at");

-- +goose Down
DROP INDEX IF EXISTS "fence_sales_user_sold_at";
DROP TABLE IF EXISTS "fence_sales";
