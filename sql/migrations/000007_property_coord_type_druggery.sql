-- +goose up
INSERT INTO "property_coord_types" VALUES (11,'BLACK_MARKET_POINT');

-- +goose Down
DELETE FROM "property_coord_types" WHERE "id" = 11;


