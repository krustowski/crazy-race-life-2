# Fence (Server Drug Buyer)

The fence is the server's own buyer for drugz. A Dealerz member at a druggery point (the skull pickups) can sell any amount from their pockets to the fence. The fence pays out cash at the current black market ratio, up to an hourly limit in units and in dollars, and every sale pushes the ratio down a little.

**Source:** `src/modules/fence.pwn` (~155 lines), included at the end of [`drugz.pwn`](drugz.md). The dialogs are in `src/support/dialogs.pwn` and their responses in `src/support/response.pwn`.

## Why it exists

Before the fence, the drug economy created no money. `/deal` and black market offers only moved cash between players, and drugs had no use (the "Use" button in `/drugz` has no handler). Drugs still come in for free and without limit (world pickups, 0–9 units each, respawning every 30 s), so a server buyer turns them into new money. Everything below is there to keep that faucet bounded:

| Guard | Default | Why |
|---|---|---|
| `FENCE_PRICE_SHARE` | `0.6` | The fence pays 60% of the market price (`drug_prices.price × gBlackMarketRatio`, the "Market price" column in the black market and deal dialogs). Selling to players stays the better deal; the fence acts as a guaranteed minimum. |
| `FENCE_UNITS_PER_HOUR` | `5000` | Units per player per rolling hour. This limit binds at low ratios and on cheap drugs. |
| `FENCE_DOLLARS_PER_HOUR` | `$1000000` | Dollars per player per rolling hour. This limit binds at high ratios and on expensive drugs. At the boom peak (ratio 100) a unit of fent pays $24000, so about 41 units use up the hour. |
| Druggery points only | `DRUGGERY_POINT_RANGE` 5.0 | Selling means travelling to one of the 5 skull pickups. The sale itself checks the player is in range, so a forged dialog response from anywhere else gets nothing. |
| Dealerz only | — | `TeamID == TEAM_DEALERS`, checked when the fence list opens and again at the sale. |
| Ratio push-down | `MARKET_SALE_IMPACT_LOG` 0.005 | Each $1000 of list-price value sold (`units × drug_prices.price`, not the ratio-adjusted value) lowers the ratio by 0.005 in log10 space, i.e. by about 1.1%. Selling 100 fent ($40000 list value) costs everyone about 37% of the price. See [Market ratio](drugz.md#market-ratio). |

The limits are a rolling window over the `fence_sales` table (sales with `sold_at` in the last `FENCE_WINDOW_S` = 3600 s), not counters in memory, so reconnecting or a server restart does not reset them.

## Flow

1. Touching a druggery point opens `ShowBlackMarketMainDialog(playerid, true)`. The `true` adds a third entry, "Sell to the fence (Dealerz)". The Hackerz interior and property `BLACK_MARKET_POINT` pickups open the same menu without it.
2. `ShowFenceDialog` lists every drug type with the amount in the player's pockets and what the fence pays per unit right now. The caption shows what is left of this hour's limits.
3. `ShowFenceAmountDialog` asks how many units to sell. `ProcessFenceSale` then does the sale:
    - rejects non-dealers, players away from a druggery point, and amounts that are not positive or not in the player's pockets;
    - rejects the sale if the whole amount would pay less than $1 at the current ratio (cheap drugs at a very low ratio);
    - reads the hourly allowance (`GetFenceAllowance`). If the read fails the fence is "closed" and buys nothing;
    - sells as many units as both limits allow (`GetFenceSellableUnits`). This can be fewer than asked; the player is told how many were sold and what is left of the hour;
    - writes the `fence_sales` row **before** paying out, so nothing is paid that the limits don't see; if the write fails, nothing changes;
    - takes the drugs, gives the cash (`GivePlayerMoney`), and calls `PushBlackMarketRatioDown`.

The fence's price is the ratio at the moment of sale. The ratio stored in the row is the value before the sale pushed it down.

## Key Functions

| Function | Description |
|---|---|
| `stock Float: GetFenceUnitPrice(drugid)` (`src/modules/fence.pwn:23`) | What the fence pays for one unit of a 0-based drug index right now. |
| `stock GetFenceAllowance(playerid, &unitsLeft, &dollarsLeft)` (`src/modules/fence.pwn:30`) | What is left of the player's hourly limits, summed from `fence_sales`. Returns 0 if the query fails. |
| `stock GetFenceSellableUnits(amount, unitsLeft, dollarsLeft, Float: unitPrice)` (`src/modules/fence.pwn:56`) | How many of `amount` units fit within both limits at `unitPrice`. A pure function, covered by `FencePricing` in `tests/test_drugz.pwn`. |
| `stock ProcessFenceSale(playerid, DrugType: type, amount)` (`src/modules/fence.pwn:66`) | Validates, caps, logs, pays and pushes the ratio down. `type` is the 1-based `DrugType`. |
| `stock ShowFenceDialog(playerid)` (`src/support/dialogs.pwn:2270`) | The drug list with fence prices and the hourly allowance in the caption. |
| `stock ShowFenceAmountDialog(playerid)` (`src/support/dialogs.pwn:2304`) | Asks for the amount of `gFenceSelectedDrug[playerid]` to sell. |

## Data & Integration

- **Table:** `fence_sales` (`id`, `user_id` → `users.id`, `drug_type` → `drug_types.id`, `amount`, `value` in dollars, `ratio`, `sold_at` unix seconds), indexed on (`user_id`, `sold_at`). Created by migration `000024_fence_sales.sql`. See [Database Schema](../database.md).
- **Reads/writes `gPlayers[]`:** `TeamID`, `OrmID`, `Drugs[]`, plus `gDrugz[]` (prices, names) and `gBlackMarketRatio` from [`drugz.pwn`](drugz.md).
- **Dialogs:** `DIALOG_FENCE_LIST` and `DIALOG_FENCE_AMOUNT`, next to the `DIALOG_BLACK_MARKET_*` ids (0x60 block). Main-menu entry 2 routes to `ShowFenceDialog`.
- **Localized strings:** the `// Fence` section of `src/support/i18n.pwn` (`I18N_FENCE_*`), including `I18N_FENCE_RATIO_PEAK_FMT`, which is broadcast to Dealerz when the daily boom peaks.

## Tuning

All the numbers are `#define`s at the top of `fence.pwn` (limits, price share, window) and `drugz.pwn` (ratio dynamics, sale impact, boom). `fence_sales` holds what is needed to tune them, for example the money paid out per hour across all players:

```sql
SELECT strftime('%Y-%m-%d %H:00', sold_at, 'unixepoch', 'localtime') AS hour,
       COUNT(*) AS sales, SUM(amount) AS units, SUM(value) AS dollars, AVG(ratio) AS avg_ratio
FROM fence_sales GROUP BY hour ORDER BY hour DESC LIMIT 48;
```
