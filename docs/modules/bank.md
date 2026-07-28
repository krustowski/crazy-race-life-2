# Banking

Loads and checks proximity to the in-world ATM pickup locations that gate the `/bank` command's deposit/withdraw/balance actions. The module itself only owns location bookkeeping; the actual money-moving logic lives in `player.pwn`.

**Source:** `src/modules/bank.pwn` (~79 lines)

## Overview

A fixed-size array `gBankLocation[MAX_ATM_PICKUPS][4]` (`MAX_ATM_PICKUPS = 19`) stores `x, y, z` and a fixed proximity radius of `15.0` for each ATM. `InitBankLocations` loads all rows from the `atm_coords` table into this array at startup, stopping (with a console warning) if more than `MAX_ATM_PICKUPS` rows are found. `CheckPlayerBankLocation` iterates the loaded locations and returns whether the player is within radius of any of them, using `IsPlayerInSphere`.

The companion pickup array `gBankPickups[MAX_ATM_PICKUPS]` is declared here but populated elsewhere (`src/support/pickups.pwn`), and the visual map icons are drawn from `src/support/mapicons.pwn` using the same `gBankLocation` array.

## Key Functions

| Function | Description |
|---|---|
| `stock InitBankLocations()` (`src/modules/bank.pwn:16`) | Loads ATM coordinates from the `atm_coords` table into `gBankLocation`. |
| `stock CheckPlayerBankLocation(playerid)` (`src/modules/bank.pwn:67`) | Returns whether the player is currently standing within range of any ATM. |

## Commands

The `/bank` command (`dcmd_bank`, `src/support/dcmd.pwn:172`) is available to all players and supports `/bank depo [amount]`, `/bank draw [amount]`, and `/bank balance`. It requires `CheckPlayerBankLocation(playerid)` to succeed before allowing a deposit or withdrawal, and delegates the actual balance changes to `DepositMoneyToBankAccount`/`WithdrawMoneyFromBankAccount` (defined in `src/modules/player.pwn`, not in this file). See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **gPlayers[] fields:** none read/written directly in this file (the `/bank` command itself reads/writes `gPlayers[playerid][Bank]`, but that logic lives in `dcmd.pwn`/`player.pwn`).
- **Database:** the `atm_coords` table (read-only, id/x/y/z columns). See [../database.md](../database.md).
- **Integration:** `InitBankLocations` is called once from `main.pwn` on startup. `gBankLocation` is also consumed by `src/support/pickups.pwn` (to spawn the ATM pickup objects into `gBankPickups`) and `src/support/mapicons.pwn` (to draw the robbery/ATM map icons, `E_MAPICON_ID_ROBBERY`). `CheckPlayerBankLocation` is called from `dcmd_bank` in `src/support/dcmd.pwn`.

## Notes

- This module is intentionally thin — it holds no money logic at all, purely location data and a proximity check. Anyone changing deposit/withdraw behavior should look in `src/modules/player.pwn` instead.
