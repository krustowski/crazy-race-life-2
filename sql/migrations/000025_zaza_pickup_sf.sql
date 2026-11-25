-- +goose up

-- One more zaza pickup (drug_types 1, TYPE_ZAZA: a green one, see
-- InitDrugPickups in src/modules/drugz.pwn), south of San Fierro.

INSERT INTO "drug_coords" ("type","x","y","z") VALUES
	(1, -1604.23, -1302.11, 56.17);

-- +goose Down
DELETE FROM "drug_coords" WHERE "type" = 1 AND "x" = -1604.23 AND "y" = -1302.11 AND "z" = 56.17;
