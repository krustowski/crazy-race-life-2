-- +goose up
INSERT INTO "high_scores_types" VALUES (6,'TYPE_MISSION_TOW');

-- +goose Down
DELETE FROM "high_scores" WHERE type = 6;
DELETE FROM "high_scores_types" WHERE id = 6;
