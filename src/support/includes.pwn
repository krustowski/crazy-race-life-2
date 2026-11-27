#if defined _CRL2_INCLUDES
	#endinput
#endif
#define _CRL2_INCLUDES

//
//  includes.pwn
//

#define MAX_OBJECTS		2000
#define MAX_PLAYERS 	100
#define MAX_VEHICLES	2000

#define MAX_DRUG_TYPES	10

#define STRONG_TAGS

// Hotfix for the OOM errors
#pragma dynamic 		1000000

#include <open.mp>

//#include <a_mysql>
#include <core>
#include <float>
#include <file>
#include <string>

#pragma tabsize 8

//
//  Basic definitions.
//

// Build the gamemode with features only available when running on the r2 samp
// server.
#define R2_SERVER			false

// Debug output: DebugPrint() and trace lines such as [wanted]. Off unless the
// build turns it on: `make build DEBUG=1` (the sampctl "debug" build) or
// `make tests DEBUG=1`, both of which pass DEBUG_ENABLED=1 to pawncc.
#if !defined DEBUG_ENABLED
	#define DEBUG_ENABLED	false
#endif

#define SECOND_MS			1000

#define SOUND_MUSIC10
#define SOUND_OFF

new const GAMEMODE_NAME[] = "CrazyRaceLife2";

new const MINIMAP_TEXT[] = "~g~Crazy~r~Race~b~Life~y~2";

new const GAMEMODE_CREDITS_OG[] = "krusty, kompry, DRaGsTeR (2008-2010)";
new const GAMEMODE_CREDITS_NEW[] = "amdulka, cranyy, neosung, tack (2025-2026)";

#include "includes/crazy_race_life_2_version.inc"
#include "includes/sampctl_build_file.inc"

//
//  Anticheat weapon ledger. It hooks GivePlayerWeapon & co., so it has to come
//  before anything that hands out weapons (i18n.pwn pulls most modules in).
//

#include "modules/anticheat_ledger.pwn"

#include "db/sqlite.pwn"
#include "support/i18n.pwn"
#include "support/net.pwn"
#include "support/http.pwn"

//
//  Advertisement.
//

#include "support/advert.pwn"

//
//  Anticheating.
//

#include "modules/anticheat.pwn"

//
//  Clock text (re)drawing.
//

#include "support/clock.pwn"

//
//  Racing subsystem.
//

#include "modules/race.pwn"

//
//  Deathmatch minigame.
//

#include "modules/deathmatch.pwn"

//
//  Player data management + team management.
//

#include "modules/player.pwn"
#include "modules/team.pwn"
#include "modules/auth.pwn"
#include "modules/real.pwn"
#include "modules/taxi.pwn"
#include "modules/combat.pwn"
#include "modules/bribe.pwn"
#include "modules/tow.pwn"
#include "modules/npcs.pwn"
#include "modules/pizza.pwn"
#include "modules/taxistop.pwn"
#include "modules/quest.pwn"

//
//  Trucking subsystem.
//

#include "modules/trucking.pwn"

//
//  Petrol stations topped up by NPC tankers.
//

#include "modules/fuel.pwn"

//
//  Radar + Vehicle velocity/props.
//

#include "support/helpers.pwn"
#include "modules/radar.pwn"

//
//  Banking.
//

#include "modules/bank.pwn"

//
//  Hidden prize pickups.
//

#include "modules/prizes.pwn"

//
//  Pickups, Objects, Vehicles, Texts, Mapicons...
//

//#include "support/models.pwn"

#include "support/pickups.pwn"
#include "support/objects.pwn"
#include "support/vehicles.pwn"
#include "support/texts.pwn"
#include "support/mapicons.pwn"
#include "support/dialogs.pwn"
#include "support/response.pwn"
#include "support/timers.pwn"

//
//  DCMDs = command set definitions.
//

#include "support/dcmd.pwn"

