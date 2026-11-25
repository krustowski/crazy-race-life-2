-- +goose up
ALTER TABLE "users" ADD COLUMN "hd_version" INTEGER DEFAULT 0;

-- +goose Down
ALTER TABLE "users" DROP COLUMN "hd_version";
