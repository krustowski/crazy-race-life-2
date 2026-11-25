-- +goose up

-- Truckerz were plain red (FF0000), the colour of mission checkpoints, so a
-- trucker's blip read as a target. Yellow is taken by taxi/pizza customers and
-- combat targets, so they move to light magenta, a hue no other team uses.
-- NPC truck drivers pick it up too (TRUCK_NPC_MARKER_COLOR in npcs.pwn), and so
-- do real zones owned by truckers (RedrawRealZones in real.pwn).
--
-- Keep the hex digits upper case: HexToInt() in team.pwn only parses those.
UPDATE "teams" SET "color" = 'FF66FFAA' WHERE "id" = 4;

-- +goose Down
UPDATE "teams" SET "color" = 'FF0000AA' WHERE "id" = 4;
