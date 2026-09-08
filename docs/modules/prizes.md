# Prizes (Hidden Treasure Pickups)

Rare "treasure" pickups scattered around the map — a Tiki worth $10M and a Pumpkin worth $1.5M. Each one is a row in `prize_coords`; the `hidden` column decides whether it is currently placed in the world. Walking into one pays out and hides it permanently, and admins can show or hide any of them from an in-game editor.

**Source:** `src/modules/prizes.pwn` (~356 lines)

## Overview

The module owns everything prize-related: the type/reward table, the world pickups, the database writes, and the admin editor.

`hidden` in `prize_coords` is the single source of truth. Every state change goes through `SetPrizeHidden()`, which writes the column **and** creates or destroys the live pickup in the same call — so the map and the table cannot drift apart, and a change made in-game survives a restart without a reload step.

`InitPrizes()` loads **every** row, hidden or not, into `gPrizes[MAX_PRIZES]` (16 slots) so the editor can list hidden prizes in order to un-hide them; only non-hidden rows get an actual world pickup. Prizes that exceed `MAX_PRIZES` are skipped with a warning.

Two enumerations describe a prize: `PrizeType` (`PRIZE_NONE`, `PRIZE_TIKI`, `PRIZE_PUMPKIN`, mirroring the `prize_types` table) and the `Prize` field enum backing `gPrizes[]` (`ID`, `Type`, `Pickup`, `Hidden`, `PrizeName`, `Point[Coords]`).

Per-type data — pickup model, cash reward, display name — lives in three small lookup functions rather than being duplicated across `switch` blocks, so adding a prize type is one edit in each.

## Admin editor

Reached through `/edit` → **Prize Editor**, so it inherits that command's gating (`IsPlayerAdmin` or `AdminLevel >= 4`) exactly like the property, trucking, race, bribe and rampage editors. There is no separate command.

The dialog (`DIALOG_PRIZE_EDITOR_MAIN`, `0xE0`) is a `DIALOG_STYLE_TABLIST_HEADERS` list of every prize:

```text
ID   Type      State     Location
1    Tiki      Hidden    2254, -2262, 14
3    Pumpkin   Shown     1091, -72, 54
```

Selecting a row toggles it via `TogglePrizeHidden()`, confirms in chat, and reopens the dialog so the new state is visible and toggling can continue. `State` is colour-coded (green shown / red hidden). The `Location` column shows `prize_coords.name` when set and falls back to coordinates otherwise — most rows have no name, and an admin deciding what to toggle needs to know where it is.

!!! note "Where the dialog function lives"
    `ShowPrizeEditorMainDialog` is defined in `prizes.pwn`, not in `support/dialogs.pwn` where every other dialog lives. `dialogs.pwn` is compiled very early — pulled in by `modules/real.pwn` long before `includes.pwn` reaches the module block — so it cannot see `gPrizes` yet. `prizes.pwn` sits after `dialogs.pwn` (so the `DIALOG_*` constant exists) and before `support/response.pwn` (which drives the handler), which is the only position where both halves resolve.

    The `DIALOG_PRIZE_EDITOR_MAIN` constant itself is still declared in `dialogs.pwn` with the rest. Note that dialog ids are split across **two** enums there and the second starts at `0xD0` with the taxi dialogs — which is why this one is `0xE0`.

## Key Functions

| Function | Description |
|---|---|
| `stock InitPrizes()` (`src/modules/prizes.pwn:183`) | Loads all `prize_coords` rows into `gPrizes[]` and creates world pickups for the non-hidden ones. Called from `InitPickups()`. |
| `stock ReloadPrizes()` (`src/modules/prizes.pwn:251`) | Destroys every live pickup and re-reads the table — for changes made outside the game. |
| `stock SetPrizeHidden(prizeid, bool:hidden)` (`src/modules/prizes.pwn:134`) | The single entry point for a state change: writes `prize_coords.hidden` and creates/destroys the live pickup together. |
| `stock TogglePrizeHidden(prizeid)` (`src/modules/prizes.pwn:173`) | Flips one prize's state; what the editor calls. |
| `stock CreatePrizePickup(prizeid)` / `DestroyPrizePickup(prizeid)` (`src/modules/prizes.pwn:81`, `:113`) | Idempotent world-pickup create/destroy, so a double show or hide is harmless. |
| `stock UpdatePrize(playerid, prizeid)` (`src/modules/prizes.pwn:262`) | A player collected a prize: pays the reward and hides it for good. |
| `stock CheckPrizePickup(playerid, pickupid)` (`src/modules/prizes.pwn:296`) | Matches a touched pickup against `gPrizes[]`; returns 1 if it was a prize. Called from `CheckGenericPickup`. |
| `stock GetPrizeModel(PrizeType:type)` / `GetPrizeReward` / `GetPrizeTypeName` (`src/modules/prizes.pwn:44`, `:56`, `:68`) | Per-type lookups: pickup model, cash reward, display name. |
| `stock ShowPrizeEditorMainDialog(playerid)` (`src/modules/prizes.pwn:317`) | The admin editor dialog described above. |

## Commands

`/prizes` (all players) shows static info about the two prize types via `ShowPrizesInfoDialog` in `support/dialogs.pwn` — it reads nothing from `gPrizes[]` and is unrelated to the editor. The editor is reached through `/edit`. See [Commands Reference](../commands.md).

## Data & Integration

- **Database tables:** `prize_coords` (id, type, name, comment, x/y/z, hidden) and `prize_types` (`1 PRIZE_TIKI`, `2 PRIZE_PUMPKIN`). See [Database Schema](../database.md).
- **Reads/writes `gPlayers[]`:** none. The module only needs a `playerid` to pay out and to show the dialog.
- **Calls into:** `support/helpers.pwn` (`EnsurePickupCreated`, the `Coords` enum).
- **Called from:** `support/pickups.pwn` — `InitPickups()` calls `InitPrizes()`, and `CheckGenericPickup()` calls `CheckPrizePickup()`. `support/response.pwn` handles `DIALOG_PRIZE_EDITOR_MAIN` and routes the `/edit` menu entry.
- **Include position:** `src/support/includes.pwn:127`, after `modules/bank.pwn`. It must precede `support/response.pwn`; see the note above.

## Notes

- **All 11 seeded prizes are currently `hidden = 1`**, so none are in the world. The editor is how you turn them back on.
- `InitPrizes()` used to query `WHERE hidden = 0`, which returned zero rows — but the `do…while` ran once anyway and wrote fields from an empty result set into `gPrizes[0]`. The pickup dispatcher then compared incoming pickup ids against that garbage slot. There is now a `DB_GetRowCount` guard and an explicit "has a pickup" check in `CheckPrizePickup`.
- The `Prize` field enum reuses names (`Pickup`, `Point`) that other enums define at **different** offsets — `DrugPickup` in `drugz.pwn` has `Pickup` at cell 0 and `Point` at cell 2, while `Prize` has them at cells 2 and 68. Pawn resolves these through the tagged array (`gPrizes[i][Pickup]` knows its tag is `Prize:`) and reports `error 091: ambiguous constant` only where the tag cannot be inferred. This was verified against the generated assembly, not just a clean build.
- `prize_coords.x`/`y`/`z` are declared `INTEGER` in the schema despite holding float coordinates; SQLite's dynamic typing makes this harmless, but it is inconsistent with every other coordinate table.
