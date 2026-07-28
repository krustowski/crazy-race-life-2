# Player UI & Interaction

`dialogs.pwn` builds and shows every `ShowPlayerDialog` window in the gamemode; `response.pwn` is the single dispatcher that receives `OnDialogResponse` and reacts per dialog id. `helpers.pwn` is the general-purpose utility grab-bag used throughout the codebase, and `parkour.pwn` is a small standalone object-placement helper for one map location.

## Dialogs (`src/support/dialogs.pwn`, ~2086 lines)

Defines the `DIALOG_*` enum used as the `dialogid` argument to every `ShowPlayerDialog` call in the gamemode, laid out in blocks by feature (core/admin dialogs at the top, `0x10` property, `0x20` trucking, `0x30` bank, `0x40` high scores, `0x50` race editor/list, `0x60` black market, `0x70` locale/drugz/deal, `0x80` assorted lists and help/editor menus, `0x90` clicked-player admin actions, `0xA0` help topics, `0xB0` phone, `0xC0` rampage editor). These constants are exactly what `response.pwn` switches on. The file also `#include`s several gameplay modules partway through (`modules/real.pwn`, `modules/race.pwn`, `modules/trucking.pwn`, `modules/deathmatch.pwn`, `modules/taxi.pwn`, `modules/rampage.pwn`) — harmless given the include-guard convention (each module is already, or will be, pulled in once via `support/includes.pwn` or `modules/player.pwn`), but worth knowing when tracing what depends on what.

Every function follows the same shape: build a formatted string — often by querying SQLite (`DB_ExecuteQuery`/`DB_GetFieldStringByName`/`DB_GetFieldIntByName`) for dynamic content like property lists, race lists, high scores, or black market offers — then call `ShowPlayerDialog` with a `DIALOG_*` id and a `DIALOG_STYLE_*` (`MSGBOX`, `LIST`, `INPUT`, `TABLIST_HEADERS`, `PASSWORD`).

**Key functions:**

| Function | Description |
|---|---|
| `stock ShowHighScoresRacesDialog(playerid, offset)` (`src/support/dialogs.pwn:162`) | Paginated (10/page) top-3-per-race high score list. |
| `stock ShowAdminCommandsDialog(playerid)` (`src/support/dialogs.pwn:215`) | Admin command reference, revealing more sections as `AdminLevel` increases (1-4). |
| `stock ShowCommonCommandsDialog(playerid)` (`src/support/dialogs.pwn:285`) | Full player-facing `/command` cheatsheet. |
| `stock ShowAdminsOnlineDialog(playerid)` (`src/support/dialogs.pwn:342`) | Lists connected admins (`AdminLevel > 0` or RCON) and their level. |
| `stock ShowPlayerPocketDrugzDialog(playerid)` (`src/support/dialogs.pwn:377`) | Tabular view of the player's carried substance amounts. |
| `stock ShowRaceListDialog(playerid)` (`src/support/dialogs.pwn:394`) | Lists all named races with entry cost/prize, to join one. |
| `stock ShowPropertyListDialog(playerid)` (`src/support/dialogs.pwn:412`) | Lists the player's owned personal properties (DB query, `type = 1`). |
| `stock ShowBankOptionsDialog(playerid)` (`src/support/dialogs.pwn:458`) | Deposit / Withdraw / Balance menu. |
| `stock ShowBankDepositDialog(playerid)` (`src/support/dialogs.pwn:463`) | Input prompt for a deposit amount. |
| `stock ShowBankWithdrawDialog(playerid)` (`src/support/dialogs.pwn:468`) | Input prompt for a withdrawal amount. |
| `stock ShowPortListDialog(playerid)` (`src/support/dialogs.pwn:473`) | Menu of fixed teleport destinations (LV escalators, SF WangCars, LS Airport, parkour parks). |
| `stock ShowTruckingPointListDialog(playerid)` (`src/support/dialogs.pwn:492`) | Lists named trucking points for the trucking editor. |
| `stock ShowRaceEditorListDialog(playerid)` (`src/support/dialogs.pwn:514`) | Lists all named races for the race editor. |
| `stock ShowRaceOptionsDialog(playerid, raceid)` (`src/support/dialogs.pwn:536`) | In-race menu (currently only "Exit race"). |
| `stock ShowGetPlayerListDialog(playerid)` (`src/support/dialogs.pwn:545`) | Admin player picker backing `/get` (teleport target to admin). |
| `stock ShowGotoPlayerListDialog(playerid)` (`src/support/dialogs.pwn:574`) | Admin player picker backing `/goto` (teleport admin to target). |
| `stock ShowPlayerClickedDialog(playerid, clickedplayerid)` (`src/support/dialogs.pwn:603`) | Per-clicked-player admin action menu, options unlocked progressively by `AdminLevel` (1-4). |
| `stock ShowPlayerSkinIDSetDialog(playerid)` (`src/support/dialogs.pwn:668`) | Input prompt to set the clicked player's skin id. |
| `stock ShowPlayerDrunkLevelSetDialog(playerid)` (`src/support/dialogs.pwn:681`) | Input prompt to set the clicked player's drunk level. |
| `stock ShowPlayerAdminLevelSetDialog(playerid)` (`src/support/dialogs.pwn:694`) | Input prompt to set the clicked player's admin level. |
| `stock ShowPlayerGiveWeaponDialog(playerid)` (`src/support/dialogs.pwn:707`) | Input prompt to give the clicked player a specific weapon. |
| `stock ShowPlayerFakechatDialog(playerid)` (`src/support/dialogs.pwn:720`) | Input prompt to send fake chat text as the clicked player. |
| `stock ShowDeathmatchOptionsDialog(playerid)` (`src/support/dialogs.pwn:735`) | Register / leave the deathmatch minigame. |
| `stock ShowPhoneOptionsDialog(playerid)` (`src/support/dialogs.pwn:756`) | In-game phone menu (balance, vehicle lock, PM, call taxi/mechanic/pizza). |
| `stock ShowPhonePMPlayerListDialog(playerid)` (`src/support/dialogs.pwn:773`) | Player picker for sending a phone PM. |
| `stock ShowPhonePMTextDialog(playerid, clickedplayerid)` (`src/support/dialogs.pwn:799`) | Input prompt for the PM text body. |
| `stock ShowPlayerAccountDialog(playerid)` (`src/support/dialogs.pwn:824`) | Read-only account summary (cash, team, skin, admin/wanted level, playtime, client version). |
| `stock ShowServerHelpListDialog(playerid)` (`src/support/dialogs.pwn:861`) | Top-level help topic menu. |
| `stock ShowServerRulesDialog(playerid)` (`src/support/dialogs.pwn:882`) | Static server rules text. |
| `stock ShowGameEditorListDialog(playerid)` (`src/support/dialogs.pwn:891`) | Admin menu linking to the property/trucking/race/bribe/rampage editors. |
| `stock ShowBribeEditorMainDialog(playerid)` (`src/support/dialogs.pwn:906`) | Add / delete police bribe pickup menu. |
| `stock ShowBribeEditorNoteDialog(playerid)` (`src/support/dialogs.pwn:915`) | Input prompt for a new bribe pickup's note text. |
| `stock ShowPropertyEditorMainDialog(playerid)` (`src/support/dialogs.pwn:924`) | Draft new / list personal / list commercial property menu. |
| `stock ShowPropertyEditorNewIDDialog(playerid)` (`src/support/dialogs.pwn:937`) | Input prompt for a new property's numeric id. |
| `stock ShowRaceEditorMainDialog(playerid)` (`src/support/dialogs.pwn:942`) | Draft new race / list existing races menu. |
| `stock ShowRaceEditorOptionsDialog(playerid, raceid)` (`src/support/dialogs.pwn:954`) | Per-race editor menu (name/cost/prize/start coords/record track/save). |
| `stock ShowRaceEditorNameChangeDialog(playerid)` (`src/support/dialogs.pwn:974`) | Input prompt for a race's new name. |
| `stock ShowRaceEditorCostChangeDialog(playerid)` (`src/support/dialogs.pwn:979`) | Input prompt for a race's entry cost. |
| `stock ShowRaceEditorPrizeChangeDialog(playerid)` (`src/support/dialogs.pwn:984`) | Input prompt for a race's prize. |
| `stock ShowTruckingEditorMainDialog(playerid)` (`src/support/dialogs.pwn:989`) | New point / list points menu. |
| `stock ShowTruckingEditorOptionsDialog(playerid)` (`src/support/dialogs.pwn:1002`) | Per-point editor menu (name/type/checkpoint/pickup/truck/trailer coords/save). |
| `stock ShowTruckingEditorNameDialog(playerid)` (`src/support/dialogs.pwn:1027`) | Input prompt for a trucking point's name. |
| `stock ShowTruckingEditorTypeDialog(playerid)` (`src/support/dialogs.pwn:1039`) | Petrol Station vs. Generic Freight Point picker. |
| `stock ShowPrizesInfoDialog(playerid)` (`src/support/dialogs.pwn:1057`) | Static info text about tiki/pumpkin prizes. |
| `stock ShowCreditsDialog(playerid)` (`src/support/dialogs.pwn:1069`) | Gamemode credits and version string. |
| `stock ShowWantedListDialog(playerid)` (`src/support/dialogs.pwn:1087`) | Lists online players with a nonzero wanted level. |
| `stock ShowTaxiHelpDialog` / `ShowTowHelpDialog` / `ShowTruckingHelpDialog` / `ShowCombatHelpDialog` / `ShowPropertyHelpDialog` / `ShowRaceHelpDialog(playerid)` (`src/support/dialogs.pwn:1108-1153`) | Six near-identical static help-text dialogs, one per mission/feature (mechanics, commission calculation, etc.). |
| `stock ShowTaxiMissionOptionsDialog(playerid)` (`src/support/dialogs.pwn:1156`) | Area picker (LV/SF/LS/Whole map) for starting a taxi mission. |
| `stock ShowHighScoresOptionsDialog(playerid)` (`src/support/dialogs.pwn:1170`) | Top-level high-scores category menu. |
| `stock ShowHighScoresPlayTimeDialog(playerid)` (`src/support/dialogs.pwn:1186`) | Top 15 players by playtime. |
| `stock ShowHighScoresPropertiesDialog(playerid)` (`src/support/dialogs.pwn:1237`) | Top 3 property owners per map area, via a window-function query. |
| `stock ShowHighScoresDeathmatchDialog(playerid)` (`src/support/dialogs.pwn:1329`) | Top 5 deathmatch scores (`high_scores` type 2). |
| `stock ShowHighScoresMissionsDialog(playerid)` (`src/support/dialogs.pwn:1375`) | Combined taxi/trucking/tow mission leaderboards (`high_scores` types 3/4/6). |
| `stock ShowHighScoresCombatDialog(playerid)` (`src/support/dialogs.pwn:1595`) | Per-combat-mission top-3 briefcase counts (`high_scores` type 5). |
| `stock ShowCombatListDialog(playerid)` (`src/support/dialogs.pwn:1659`) | Lists combat missions from the `combat_mission` table. |
| `stock ShowTutorialMainDialog(playerid)` (`src/support/dialogs.pwn:1698`) | Activate tutorial / view stats / next task menu. |
| `stock ShowTutorialStatsDialog(playerid)` (`src/support/dialogs.pwn:1715`) | Dumps the player's tutorial-progress stats. |
| `stock ShowPlayerLocaleListDialog(playerid)` (`src/support/dialogs.pwn:1755`) | Lists available languages from `locale_types`. |
| `stock ShowBlackMarketItemListDialog(playerid)` (`src/support/dialogs.pwn:1792`) | Lists current black market offers (joined query across items/users/drug types/prices). |
| `stock ShowBlackMarketMainDialog(playerid)` (`src/support/dialogs.pwn:1862`) | List items / place new offer menu. |
| `stock ShowBlackMarketNewDialog(playerid)` (`src/support/dialogs.pwn:1870`) | Tabular picker of the player's own drug types/amounts/prices to list for sale. |
| `stock ShowBlackMarketAmountDialog(playerid)` (`src/support/dialogs.pwn:1911`) | Input prompt for a new market offer's amount. |
| `stock ShowBlackMarketValueDialog(playerid)` (`src/support/dialogs.pwn:1919`) | Input prompt for a new market offer's per-unit price. |
| `stock ShowDealMainDialog(playerid)` (`src/support/dialogs.pwn:1927`) | Tabular picker of drug types to offer directly to another player. |
| `stock ShowDealAmountDialog(playerid)` (`src/support/dialogs.pwn:1968`) | Input prompt for a direct deal's amount. |
| `stock ShowDealValueDialog(playerid)` (`src/support/dialogs.pwn:1976`) | Input prompt for a direct deal's per-unit value. |
| `stock ShowDealPlayerListDialog(playerid)` (`src/support/dialogs.pwn:1984`) | Player picker for a direct deal's target. |
| `stock ShowDealConfirmationDialog(playerid)` (`src/support/dialogs.pwn:2013`) | Accept/decline confirmation shown to the deal's target. |
| `stock ShowRampageEditorMainDialog(playerid)` (`src/support/dialogs.pwn:2033`) | Rampage mission editor top menu; also precomputes the next mission id from `rampages`. |
| `stock ShowRampageEditorNameDialog(playerid)` (`src/support/dialogs.pwn:2060`) | Input prompt for a rampage mission's name. |
| `stock ShowRampageEditorWeaponDialog(playerid)` (`src/support/dialogs.pwn:2068`) | Input prompt for a rampage weapon id (blank = random). |
| `stock ShowRampageEditorLocationTypeDialog(playerid)` (`src/support/dialogs.pwn:2076`) | None/LV/SF/LS location-type picker. |
| `stock ShowNPCRecordingDialog(playerid)` (`src/support/dialogs.pwn:2084`) | Input prompt for an NPC route-recording file suffix. |

## Dialog Responses (`src/support/response.pwn`, ~2012 lines)

The entire file is one function: `HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])` — a roughly 2000-line `switch (dialogid)` with one `case DIALOG_*:` per constant defined in `dialogs.pwn`. `main.pwn:815` defines `public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])` whose entire body is `return HandleDialogResponse(...)`, so this file is the de facto implementation of that SA-MP/open.mp callback.

The switch cases fall into recognizable groups, in file order:

- **Auth** (`DIALOG_LOGIN`/`DIALOG_REGISTER`, lines 20/47): password retry counting and `DelayedKick` on cancel/failure.
- **Property** (`DIALOG_PROPERTY_*`, lines 66-390): buy/rent/sell by id, drug deposit/withdraw at a property, and the full property editor form (name/type/cost/spawn/entrance/offer/money/shirt/vehicle coords, occupied/custom-interior toggles, save).
- **Banking** (`DIALOG_BANK_*`, lines 391-451): deposit/withdraw amount validation via `IsNumeric`, delegating to `DepositMoneyToBankAccount`/`WithdrawMoneyFromBankAccount`.
- **Racing** (`DIALOG_RACE_*`, lines 452-491): join-by-listitem and the in-race "exit race" option.
- **Port** (`DIALOG_PORT_LIST`, line 493): fixed `SetPlayerPos` teleports for each port list entry.
- **Admin player actions** (`DIALOG_GET_LIST`/`GOTO_LIST`/`PLAYER_CLICKED_LIST` and the follow-up input dialogs, lines 546-885): HP/nitro/get/goto/skin/drunk-level/kick/packet-loss/reset-cash/spectate/give-weapons/ban/fakechat/admin-level actions on a clicked player, each gated by the acting admin's level.
- **Phone** (`DIALOG_PHONE_*`, lines 910-1062): balance check, vehicle lock/unlock (with a Hackers-team "lock hack" chance), PM composition, and taxi/mechanic/pizza online-checks.
- **Help & editor menus** (`DIALOG_HELP_LIST`/`EDITOR_LIST`, lines 1063-1152): pure dispatch to the matching `Show*Dialog`/`Show*EditorMainDialog`.
- **Rampage / Property / Race / Trucking editors** (lines 1153-1605): each editor's main dialog routes `listitem` to a sub-dialog or an in-progress edit-mode flag (`gRampageEdit`, `gPropertyEdit`, ...), and a final "Save" listitem calls the module's persistence function (e.g. `SaveRampageMission`).
- **Property skins, high scores, taxi options, combat list, tutorial, bribe editor, locale** (lines 1606-1808): mostly single-purpose dispatch or DB writes.
- **Black Market & Deal** (`DIALOG_BLACK_MARKET_*`/`DIALOG_DEAL_*`, lines 1809-1976): a matching multi-step amount → value → (player list, for Deal) flow that ends in `ProcessNewBlackMarketOffer`/`ProcessDealOffer`; `DIALOG_DEAL_CONFIRMATION` is shown to the *other* player and round-trips through `gPlayers[playerid][DealPlayerTargetID]`.
- **NPC recording** (`DIALOG_NPC_RECORD_SUFFIX`, line 1977): starts a `StartRecordingPlayerData` capture used to author new NPC routes (see `npcmodes/`).

**Key functions:**

| Function | Description |
|---|---|
| `stock HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])` (`src/support/response.pwn:11`) | Single dispatcher for every `ShowPlayerDialog` response in the gamemode; called from `OnDialogResponse` in `src/main.pwn:817`. |

## Helpers (`src/support/helpers.pwn`, ~432 lines)

A general-purpose collection of `stock` utilities pulled in by nearly every module (`#include`d directly by `support/includes.pwn:101`, and by several modules individually). There are too many small helpers to list exhaustively; they group roughly as:

- **Player/session utilities** — `SystemMsg`, `InvalidCommand`, `BanAll`/`KickAll`, and `DelayedKick`/`DoDelayedKick` (kicks via a short timer rather than immediately, so a prior message/dialog reaches the client and the disconnect settles before the slot is reused).
- **String helpers** — `chrfind`, `IsNumeric`, `SplitIntoTwo` (splits a command's parameter string on a delimiter), `SanitizeString` (escapes single quotes for safe SQL string literals).
- **Math/vector helpers** — `GetPlayerDistanceToPointEx`, `IsPlayerInSphere`, `GetVehicleWithinDistance`.
- **Vehicle helpers** — `IsPlayerInValidNosVehicle` (blacklist of ~31 models that can't take NOS), `IsVehicleRcTram` (checks against the tram/RC-vehicle model set).
- **World-building helper** — `EnsurePickupCreated`, a retry loop (up to 50 attempts) around `CreatePickup`; this is what every pickup-spawning module — and `support/pickups.pwn` itself — actually calls to place a pickup. See [World & Visuals](world-and-visuals.md).
- **Misc** — `UnixToDateTime` (manual epoch-to-calendar conversion, commented "GPT-generated"), `PrintAsciiLogoToLogs` (startup banner), `BroadcastMessage`, `SendUsageMessage` (localized "usage: ..." message).
- **Timer-driven callbacks** — `AutosaveData` (`BatchSavePlayerData` + `SaveRealEstateData`, wired to `TIMER_AUTOSAVE_DATA`) and `StartServerReset` (issues the `gmx` RCON command).

**Key functions (representative):**

| Function | Description |
|---|---|
| `public AutosaveData()` (`src/support/helpers.pwn:28`) | Periodic timer callback: saves all player data and real estate state. |
| `public StartServerReset()` (`src/support/helpers.pwn:34`) | Issues an RCON `gmx` to restart the game mode. |
| `stock DelayedKick(playerid, delay = 1000)` (`src/support/helpers.pwn:95`) | Schedules `Kick(playerid)` via a timer so pending messages/dialogs reach the client first. |
| `stock IsNumeric(const input[])` (`src/support/helpers.pwn:112`) | Checks whether a string is all digits (used to validate dialog input). |
| `stock IsPlayerInSphere(playerid, Float:x, Float:y, Float:z, Float:radius)` (`src/support/helpers.pwn:130`) | Radius check against a player's current position. |
| `stock EnsurePickupCreated(model, type, Float:X, Float:Y, Float:Z)` (`src/support/helpers.pwn:226`) | Retries `CreatePickup` up to 50 times and returns the resulting pickup id. |
| `stock IsVehicleRcTram(vehicleid)` (`src/support/helpers.pwn:253`) | True if the vehicle's model is a tram or one of the RC vehicle models. |
| `stock SplitIntoTwo(const input[], token1[], token2[], tokenSize, const delimiter[2] = " ")` (`src/support/helpers.pwn:273`) | Splits a command parameter string into two tokens on a delimiter. |
| `stock SanitizeString(const input[], output[], size)` (`src/support/helpers.pwn:413`) | Escapes single quotes for embedding a string in a SQL literal. |

## Parkour (`src/support/parkour.pwn`, ~97 lines)

A single-function file. `InitParkour()` issues roughly 90 `CreateObject()` calls that place a fixed sequence of sloped platforms (model 984) and barrier/scenery objects climbing a course near Mount Chiliad (from around `(-257, 2194, 110)` up to `(43, 2239, 141)`) — the "San Fierro Ship Parkour" destination offered in `ShowPortListDialog` and teleported to from `DIALOG_PORT_LIST` in `response.pwn`. It is `#include`d directly by `support/objects.pwn:10` and invoked once, at the end of `InitObjects()`. The file contains no pickups, checkpoints, timers, or reward logic — purely static geometry. The other port-list entry, "Bone County Parkour (experimental)", has a teleport coordinate in `response.pwn`'s `DIALOG_PORT_LIST` case but no matching object-placement code in this file.

**Key functions:**

| Function | Description |
|---|---|
| `stock InitParkour()` (`src/support/parkour.pwn:1`) | Places all static geometry for the San Fierro Ship Parkour course. |

## Used By

- [Authentication](../modules/auth.md) drives the `DIALOG_LOGIN`/`DIALOG_REGISTER` cases in `response.pwn`.
- [Real Estate](../modules/real.md), [Racing](../modules/race.md), [Trucking Missions](../modules/trucking.md), [Taxi Missions](../modules/taxi.md), and [Rampage Missions](../modules/rampage.md) are each `#include`d both from `support/includes.pwn` and (defensively, via the include-guard convention) from inside `dialogs.pwn`, and their editors are entirely driven by `dialogs.pwn`/`response.pwn`.
- [Drugs](../modules/drugz.md) supplies the black market and direct-deal flow's data (`gDrugz`, `gPlayers[][Drugs]`) consumed by the black market/deal dialogs and their responses.
- [Police Bribes](../modules/bribe.md), [Combat Missions](../modules/combat.md), [Banking](../modules/bank.md), [Tow Missions](../modules/tow.md), [Teams](../modules/team.md), and [Radar](../modules/radar.md) all call into `helpers.pwn` utilities (`EnsurePickupCreated`, distance/sphere checks, string helpers) as general-purpose plumbing.
