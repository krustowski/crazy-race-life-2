-- +goose up
ALTER TABLE "users" ADD COLUMN "playtime" INTEGER DEFAULT 0;

-- +goose Down
ALTER TABLE "users" DROP COLUMN "playtime";

