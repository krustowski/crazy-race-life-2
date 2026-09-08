# Pizza Delivery

An animation-driven pizza delivery minigame for the Pizzaboyz team: pick up a pizza box, drive it to a randomly chosen customer NPC in Los Santos, and hand it over through a scripted sequence of animations on both sides.

**Source:** `src/modules/pizza.pwn` (~315 lines)

!!! warning "Unfinished"
    The delivery sequence runs end to end, but the final step pays nothing and never closes the mission out — see [Incomplete behaviour](#incomplete-behaviour). Treat this module as work in progress rather than a shipped feature.

## Overview

There is no command. The minigame is bound to `KEY_SUBMISSION` in `HandlePlayerKeyStateChange` (`src/modules/player.pwn:1116`), behind an `IsPlayerInTeam(playerid, TEAM_PIZZAGUYS)` check — the same key that starts trucking, taxi and tow work for their respective teams. Pressing it starts a delivery, or aborts one already in progress.

State lives in `gPizzaMission[MAX_PLAYERS][PizzaMission]`: an `Active` flag, the customer `NPCid`, the current `DeliveryState`, one reused `DeliveryTimer` handle, and the customer's position.

`PizzaDeliveryState` tracks where in the handover the player is — `PIZZA_DELIVERY_NONE`, `CARRY`, `WAIT`, `HANDOVER`, `PAYMENT`. It is written at each step but nothing currently reads it; it exists for the sequence to be resumable or inspectable later.

## Delivery sequence

The whole flow is a chain of one-shot timers, each firing the next stage. Every stage re-checks `IsPlayerConnected` before touching the player.

```text
KEY_SUBMISSION (Pizzaboyz)
  → Pizza_StartMinigame        freeze, play CARRY/liftup
  → 1100ms  Pizza_OnPizzaLifted     attach pizza box (model 1582, slot 9),
                                    SPECIAL_ACTION_CARRY, unfreeze, state = CARRY,
                                    pick a customer and set the checkpoint
  → player reaches the checkpoint
  → Pizza_CheckCheckpoint      freeze, DEALER_IDLE on player,
                                    SHP_Serve_Idle on the NPC, state = WAIT
  → 3000ms  Pizza_OnPizzaHandover   SHP_Serve_Give / SHP_Thank, state = HANDOVER
  →  700ms  Pizza_OnPizzaReleased   detach the box, SHP_Rob_GiveCash / EAT_Pizza,
                                    state = PAYMENT
  → 1500ms  Pizza_OnPizzaFinished   unfreeze  ← and nothing else
```

The checkpoint is a plain `SetPlayerCheckpoint` (3.0 radius), routed in from `OnPlayerEnterCheckpoint` in `main.pwn`.

## Choosing a customer

`Pizza_SetMissionCustomer` allocates an NPC named `[NPC]pizza_custN` from the first free slot below `MAX_PIZZA_NPC_COUNT` (50), spawns it, then calls `Pizza_SetCustomerPos`.

`Pizza_SetCustomerPos` picks a random type-8 `property_coords` row belonging to a Los Santos property, **within `PIZZA_CUSTOMER_MAX_DIST` (175 units) of the courier**, and moves the NPC there with a random skin and a yellow radar marker.

That distance rule is part of the query — a squared-distance clause — rather than a retry loop:

```sql
... WHERE c.type = 8 AND p.name LIKE 'LS:%'
  AND ((c.primary_x - px)*(c.primary_x - px)
     + (c.primary_y - py)*(c.primary_y - py)
     + (c.primary_z - pz)*(c.primary_z - pz)) <= 30625.0   -- 175²
ORDER BY random() LIMIT 1
```

It previously re-rolled a random LS point **up to 250 times** hoping to land near the player, each attempt a blocking query. Nearby points are the rare case, so it routinely ran dozens of them to place one customer. If nothing is in range it now falls back to any LS point — which is where the old loop ended up once it exhausted its attempts. See [Architecture — every database call blocks the server](../architecture.md#conventions-worth-knowing-before-editing-code).

## Key Functions

| Function | Description |
|---|---|
| `stock Pizza_StartMinigame(playerid)` (`src/modules/pizza.pwn:73`) | Begins a delivery: freezes the player, plays the lift animation, schedules `Pizza_OnPizzaLifted`. No-op if one is already active. |
| `stock Pizza_ResetMinigame(playerid)` (`src/modules/pizza.pwn:40`) | Tears a delivery down: kills the timer, destroys the NPC, clears the checkpoint, detaches the box, clears animations, unfreezes. |
| `stock Pizza_CheckCheckpoint(playerid)` (`src/modules/pizza.pwn:90`) | Called from `OnPlayerEnterCheckpoint`; starts the handover animation pair. Returns 0 if no delivery is active. |
| `public Pizza_OnPizzaLifted(playerid)` (`src/modules/pizza.pwn:115`) | Attaches the pizza box, picks the customer, sets the checkpoint. |
| `public Pizza_OnPizzaHandover(playerid)` (`src/modules/pizza.pwn:137`) | Give/thank animation pair. |
| `public Pizza_OnPizzaReleased(playerid)` (`src/modules/pizza.pwn:157`) | Detaches the box, pays/eats animation pair. |
| `public Pizza_OnPizzaFinished(playerid)` (`src/modules/pizza.pwn:179`) | Final stage — currently only unfreezes the player. |
| `stock Pizza_SetMissionCustomer(playerid)` (`src/modules/pizza.pwn:269`) | Allocates and spawns the customer NPC, then positions it. |
| `stock Pizza_SetCustomerPos(playerid)` (`src/modules/pizza.pwn:197`) | Picks a nearby LS delivery point in one query and moves the NPC there. |

## Commands

None. The minigame is key-driven only (`KEY_SUBMISSION`). The in-game phone has a "call pizza" option (`src/support/response.pwn:1022`), but it is gated on `CheckPizzaguysOnline()` — an unimplemented stub in `modules/team.pwn` that always returns 0 — so that path is inert. See [Teams](team.md).

## Data & Integration

- **Database tables:** reads `property_coords` (type 8) joined to `properties` for delivery points. Writes nothing — no `high_scores` row, unlike every other mission module.
- **`gPlayers[]`:** touched only via `IsPlayerInTeam` at the key handler. Notably it does **not** set `InMinigame`, so a pizza delivery does not block the player from starting a taxi, trucking or tow mission at the same time.
- **Calls into:** `modules/npcs.pwn` (`NPC_Create`/`NPC_Spawn`/`NPC_SetPos`/`NPC_SetSkin`/`NPC_Destroy`), `support/helpers.pwn` (`Coords`).
- **Called from:** `main.pwn`'s `OnPlayerEnterCheckpoint`, and `HandlePlayerKeyStateChange` in `modules/player.pwn`.
- **Include position:** `src/support/includes.pwn:102`, and again from `modules/player.pwn:1014` (the second include is a no-op — see [Architecture](../architecture.md#include-order-srcsupportincludespwn)).

## Incomplete behaviour

These are gaps in the feature, not incidental bugs:

- **`Pizza_OnPizzaFinished` does nothing but unfreeze.** Its body carries the comment `// Give commission to player, end the delivery` and implements neither: no payout, no `Active = false`, no next delivery, no score. After one delivery the player stays flagged as active, and pressing `KEY_SUBMISSION` again runs `Pizza_ResetMinigame` — so it is recoverable, just unfinished.
- **No teardown on death or disconnect.** `AbortPlayerTaxiMission`, `AbortTruckingMission` and `AbortTowMission` are all called from `OnPlayerDeath`/`OnPlayerDisconnect`; `Pizza_ResetMinigame` is not called from anywhere except the key handler. A courier who dies or quits mid-delivery leaves the attached object, the customer NPC and a pending timer behind.

## Notes

- **`Pizza_SetMissionCustomer` never reuses its NPC.** The guard reads `if (gPizzaMission[playerid][NPCid] > INVALID_PLAYER_ID)`, and `INVALID_PLAYER_ID` is `65535` while NPC ids are player slots (0–`MAX_PLAYERS`), so the condition can never be true. The taxi module's equivalent uses `> -1`. Combined with the missing teardown above, repeated deliveries allocate a fresh NPC each time.
- **Two error paths send a taxi string.** Both "too many customers" branches use `I18N_TAXI_MISS_TOO_MANY_CUSTOMERS`; there is no pizza-specific key. See [Localization](../localization.md).
- `PizzaDeliveryState` is written at every stage but never read.
- `Float: DeliveryPos[Coords]` double-tags the array — the `Coords` enum members are already `Float:`. Harmless, but inconsistent with how other modules declare a `Coords` field.
