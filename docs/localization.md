# Localization

Player-facing text is not hardcoded per call site; it's looked up by an `I18N_*` key against the player's locale in a single parallel-array table defined in `src/support/i18n.pwn` (~1600 lines). The file also defines the `PlayerLocale` enum, the ~25 `COLOR_*` constants used for `SendClientMessage` color-coding across the whole gamemode, and the two lookup/send helpers documented below.

## Locales

```pawn
enum PlayerLocale
{
	LOCALE_EN,
	LOCALE_CZ
}
```

(`src/support/i18n.pwn:38`) Exactly two locales are defined: `LOCALE_EN` (index 0) and `LOCALE_CZ` (index 1). A player's active locale is stored as `gPlayers[playerid][Locale]` (declared `PlayerLocale:` in `src/modules/player.pwn:64`), loaded from the `locale` DB column on connect (`src/modules/player.pwn:229`), and used to index every localized lookup.

### Color constants

`src/support/i18n.pwn:10` defines the message colors, e.g. `COLOR_GREEN`, `COLOR_RED`, `COLOR_BLUE`, `COLOR_YELLOW`, `COLOR_GREY`, `COLOR_ORANGE`, `COLOR_LIGHTGREEN`, `COLOR_WHITE`, `COLOR_INVISIBLE`, and a handful of numbered variants (`COLOR_RED2`, `COLOR_BLUE2`/`3`, `COLOR_ORANGE2`, `COLOR_BROWN2`) — 25 in total. These are used directly in raw `SendClientMessage(...)` calls throughout the codebase, and one is pre-assigned per `I18N_*` key (see below).

## Key naming and grouping

All localized strings are keys in one large anonymous `enum` starting at `src/support/i18n.pwn:44` and running to `src/support/i18n.pwn:301` — **237 keys** in total (`grep -c` on the `I18N_` enum entries). There is no central registry file per module; instead the single enum is grouped by feature, in the order the underlying systems were added, marked with inline `// Section` comments — e.g. `// Rampages`, `// Private messages`, `// Radar (vehicle stats)`, `// Admin elevator`, `// Deals`, `// Drug Mission`, `// Black Market`, `// User data load`, `// Autosave`, `// Racing`, `// Deathmatch`, `// Player`, `// Real estate`, `// Combat`, `// Taxi`, `// Trucking`, `// Tow`. The first ~65 keys (before the first section comment) are ungrouped core/admin/common-command strings.

Keys loosely follow a `I18N_<FEATURE>_<EVENT>[_FMT]` shape. The `_FMT` suffix is a **convention, not a strict rule**: 56 of the 237 keys end in `_FMT`, but 17 non-`_FMT` keys still contain `printf`-style placeholders (`%s`, `%d`, `%.2f`, ...) and 5 `_FMT`-suffixed keys (all trucking/tow "mission started/aborted" GameText strings) contain no placeholders at all. In practice: if the string needs runtime substitution, code always goes through `GetLocalizedString` + `format()` regardless of whether the key happens to be named `_FMT`.

## Key Functions

| Function | Description |
|---|---|
| `SendClientMessageLocalized(playerid, msg_id)` (`src/support/i18n.pwn:1591`) | `forward`/`public` pair. Sends `gI18nMessages[msg_id][gPlayers[playerid][Locale]]` to `playerid` via `SendClientMessage`, using the pre-assigned `gI18nMessageColor[msg_id]` as the message color. Only suitable for strings with **no** placeholders — it does not call `format()`, so any `%s`/`%d` in the string would be sent literally. |
| `GetLocalizedString(playerid, msg_id, str[], size)` (`src/support/i18n.pwn:1596`) | `stock`. Copies the localized string for `playerid`'s locale into the caller-provided buffer `str` (via `format(str, size, "%s", ...)`), for the caller to then `format()` again with real arguments before sending. This is the required pattern for any `_FMT`-style key. |

Both functions — and the `gI18nMessages`/`gI18nMessageColor` arrays they read — are defined at the very end of `i18n.pwn`, after a `#include "modules/player.pwn"` (`src/support/i18n.pwn:1587`) that pulls in the `gPlayers`/`PlayerLocale` field definition the two functions depend on.

Not every call site goes through these two helpers: several modules (e.g. `src/modules/taxi.pwn`, `src/modules/rampage.pwn`, `src/modules/player.pwn`, `src/support/dcmd.pwn`) index `gI18nMessages[msg_id][gPlayers[playerid][Locale]]` directly, mainly to feed `GameTextForPlayer(...)` (which has no localized wrapper of its own) or a manual `format()` call.

## Adding a New String

1. Add a new `I18N_<FEATURE>_<EVENT>` entry to the anonymous enum in `src/support/i18n.pwn` (around line 44-298) — place it in (or start a new) `// Section` comment block matching the feature it belongs to, to keep the grouping meaningful.
2. Add a matching `{ "English text", "Czech text" }` pair to `gI18nMessages` (`src/support/i18n.pwn:562`) **at the same array index** — the enum ordering and the array ordering must stay in lockstep, since there are no named keys, only positional ones.
3. Add a color to `gI18nMessageColor` (`src/support/i18n.pwn:303`), also at the same index — this is what `SendClientMessageLocalized` uses. **This step is the easiest one to forget**, and forgetting it is silent (see the gotcha below).
4. If the string takes runtime values, include the `printf`-style placeholders in **both** the EN and CZ variants (and keep argument order identical between them, since some grammatical reorderings won't be possible with positional `%s`/`%d`) — naming the key with a trailing `_FMT` is customary but not enforced.
5. Use `SendClientMessageLocalized(playerid, I18N_KEY)` for static strings, or `GetLocalizedString(...)` + `format(...)` + `SendClientMessage(...)` for anything needing substitution.

!!! danger "The three tables must stay the same length"
    Because the enum, `gI18nMessages` and `gI18nMessageColor` are all positional, inserting a key in the middle without inserting at the same index in the other two silently misaligns **every key after it** — wrong colors, wrong text, and an out-of-bounds read on the last entry. Nothing catches this at compile time.

    This has already happened once: `I18N_KILL_CMD_UNAVAILABLE` was added to the enum and the message table but not to the color table, leaving 237 messages against 236 colors, so every message from index 51 onward drew its predecessor's color.

    After adding a key, verify all three lengths match. A quick check:

    ```bash
    grep -cE '^\s*I18N_[A-Z0-9_]+,?$'  src/support/i18n.pwn   # enum keys
    grep -cE '^\s*COLOR_[A-Z0-9_]+,?$' src/support/i18n.pwn   # colors
    ```

    Appending within a section is safer than reordering, but even an append needs all three.

Setting a player's locale is done via the `/locale` command (see [Commands Reference](commands.md)) — it opens a dialog whose response handler (`src/support/response.pwn:1806`) writes the chosen index straight into `gPlayers[playerid][Locale]`.

## Coverage Notes

The README describes localization as "English + Czech (partly, WIP)". Checking this against the actual data:

- **Within the `i18n.pwn` table itself, coverage is complete.** All 237 `I18N_*` keys were parsed programmatically from `gI18nMessages`, and every single one has both a non-empty, non-placeholder EN string and a distinct, genuine CZ string — including in the later "Real Estate", "Combat", "Taxi", "Trucking", and "Tow" sections, which were spot-checked in full alongside the earlier sections. No key was found with an empty CZ string, a CZ string byte-identical to its EN counterpart, or an obvious "TODO"/placeholder value. (One minor duplication: `I18N_DEAL_ACCPTED_TARGET` and `I18N_DEAL_ACCPTED_DEALER` share the exact same EN and CZ text — not a missing translation, just two keys with identical wording.)
- **The "WIP" caveat more likely refers to strings that never made it into the `i18n` system at all.** A large number of player-facing messages bypass `I18N_*` entirely and are sent as raw hardcoded English literals: `src/support/dcmd.pwn` alone has 12 such `SendClientMessage(playerid, COLOR_..., "...")` calls (e.g. the `/bank`, `/lock`, `/unlock` usage and status messages) against 96 calls to `SendClientMessageLocalized` in the same file. Across all of `src/`, roughly 156 `SendClientMessage(...)` calls use a literal string versus 229 calls to `SendClientMessageLocalized`. Those hardcoded messages are English-only regardless of the player's `Locale` setting, and this is the real, honest gap — not missing translations for defined keys, but message text that was never wired into the localization system to begin with.
