# Infrastructure

Five small, focused files providing cross-cutting plumbing for the rest of the gamemode: a network diagnostics helper, outbound HTTP callouts, a central timer registry, the in-game clock display, and periodic server-wide advertisement messages.

## Network Stats (`src/support/net.pwn`, ~30 lines)

A single stock, `GetPlayerPacketLoss`, parses the block of text returned by `GetPlayerNetworkStats` to extract the "packetloss" percentage (via `strfind`/`strmid`/`floatstr`) and writes it out through a by-reference `Float` parameter; it returns `0` without touching the output if the player isn't connected. The comment credits "Fusez" as the original author of the parsing logic.

**Key functions:**

| Function | Description |
|---|---|
| `stock GetPlayerPacketLoss(playerid, &Float: packetLoss)` (`src/support/net.pwn:11`) | Parses `GetPlayerNetworkStats` output to return a player's packet loss percentage. |

## HTTP (`src/support/http.pwn`, ~63 lines)

Wraps the SA-MP/open.mp `HTTP()` native to post player connect/disconnect/kick events to an external webhook. `WEBHOOK_URL` (`"crl2.krusty.space/hooks/samp-webhook-player"`) is the fixed target. `SendMessageToWebhook` builds a `payload={"nickname":...,"state":...,"reason":...}` form body — `reasonid` maps to `""`/`"crash"`/`"left"`/`"kick/ban"`/`"unknown"` — and fires it as an async `HTTP_POST`. `WebhookResponse` is the `HTTP()` result callback, logging the HTTP status to the console. The receiving side of this webhook lives outside the gamemode, in `configs/webhook.json`/`configs/webhook.sh` at the repo root.

**Key functions:**

| Function | Description |
|---|---|
| `public WebhookResponse(index, response_code, data[])` (`src/support/http.pwn:8`) | `HTTP()` callback; logs whether the webhook POST succeeded (200) or not. |
| `public SendMessageToWebhook(playerid, const message[], reasonid)` (`src/support/http.pwn:24`) | Builds and sends the player connect/disconnect/kick webhook payload. |

## Timers (`src/support/timers.pwn`, ~58 lines)

Defines the `ServerTimer` enum — `TIMER_ANTICHEAT_WEAPON`, `TIMER_ANTIFLOOD` (defined but its `SetTimer` call is commented out), `TIMER_ON_RADAR_CHECKPOINT`, `TIMER_AUTOSAVE_DATA`, `TIMER_UPDATE_PLAYER_PLAYTIME`, `TIMER_UPDATE_PLAYER_SCORE`, `TIMER_UPDATE_BLACK_MARKET_RATIO`, `TIMER_SEND_PLAYER_SALARY`, `TIMER_SEND_REAL_ESTATE_COMMISSION`, `TIMER_DRAW_CLOCK_TEXT`, `TIMER_SHOW_ADVERT` — and the backing `gTimers[ServerTimer]` array of `Timer:` handles. `InitTimers()` is the single place every recurring `SetTimer(...)` call in the gamemode is registered: anti-cheat weapon check every 30s, radar checkpoint check every 300ms, autosave every 3 minutes, playtime tick every 10s, score tick every 2s, black market ratio update every 3 minutes, salary/real-estate commission every 5 minutes, clock redraw every 10s, and an advert every 2 minutes. `KillTimers()` iterates `gTimers` and calls `KillTimer` on every handle.

**Key functions:**

| Function | Description |
|---|---|
| `stock InitTimers()` (`src/support/timers.pwn:29`) | Registers every recurring `SetTimer` call for the gamemode's periodic subsystems. |
| `stock KillTimers()` (`src/support/timers.pwn:52`) | Cancels every timer tracked in `gTimers`. |

## Clock (`src/support/clock.pwn`, ~49 lines)

Owns the `gClockText` TextDraw handle (declared here; actually created by `InitTexts()` in `support/texts.pwn`) and `gPreviousHour`, used to avoid redundant world-time updates. `DrawClockText()`, fired every 10 seconds by `TIMER_DRAW_CLOCK_TEXT`, reads the server's real `gettime()` hour/minute/second, formats it as `H:MM`, and re-shows the TextDraw to every connected player. When the hour changes it also calls `SetWorldTime(hour)` once, so the in-game GTA sky/lighting follows the real-world clock without resetting on every tick (per the file's own comment, "a minor hotfix not to change the world time on each tick").

**Key functions:**

| Function | Description |
|---|---|
| `public DrawClockText()` (`src/support/clock.pwn:14`) | Redraws the clock TextDraw for all players and updates `SetWorldTime` on the hour. |

## Advertisement (`src/support/advert.pwn`, ~183 lines)

`advertList[][PlayerLocale][]` is a bilingual (English/Czech) table of roughly 32 tip/info/trivia strings grouped by topic (general tips, racing, drugz, housing, teams, missions, police & wanted, trivia, an "endtip"). `ShowAdvert()`, fired every 2 minutes by `TIMER_SHOW_ADVERT`, picks one random advert index and sends it to every connected player using each player's own `gPlayers[i][Locale]`.

**Key functions:**

| Function | Description |
|---|---|
| `public ShowAdvert()` (`src/support/advert.pwn:167`) | Sends one random localized advertisement/tip message to every connected player. |

## Used By

- `src/support/dcmd.pwn`'s `/packet` admin command and the clicked-player "packet loss" action in `response.pwn` both call `GetPlayerPacketLoss`. See [Player UI & Interaction](player-ui.md).
- `src/main.pwn` calls `SendMessageToWebhook` (via `SetTimerEx`) on player connect and disconnect to notify the external webhook.
- `src/main.pwn`'s `OnGameModeInit`/`OnGameModeExit` call `InitTimers()`/`KillTimers()` exactly once each; every module with a recurring background job — [Anti-Cheat](../modules/anticheat.md), [Player Core](../modules/player.md) (playtime/score/salary), [Drugs](../modules/drugz.md) (black market ratio), [Real Estate](../modules/real.md) (commission), [Radar](../modules/radar.md) — registers its callback name into `gTimers` here rather than calling `SetTimer` itself.
- [World & Visuals](world-and-visuals.md)'s `support/texts.pwn` creates the `gClockText` TextDraw that `clock.pwn` redraws every tick.
