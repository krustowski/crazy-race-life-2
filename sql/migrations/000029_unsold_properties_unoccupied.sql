-- +goose up

-- 000001 seeded 125 unsold properties (user_id 0) as occupied: 22 personal and
-- 103 commercial. Nobody could buy the personal ones (the pickup said "already
-- sold"), and the commercial ones offered the takeover from a tenant with no
-- name instead of the rent. Unsold means unoccupied, as selling a property
-- leaves it.
--
-- Where the data is already consistent, as on the running database (going by
-- its copy of 2026-11-24), this changes nothing and only records the version.
-- Rows with an owner and occupied = 0 stay as they are: that is a former
-- tenant's id left behind.
UPDATE "properties" SET "occupied" = 0 WHERE "user_id" = 0 AND "occupied" = 1;

-- +goose Down
-- Nothing to undo: the seeded state was a bug.
