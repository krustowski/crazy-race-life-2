#if defined _CRL2_INCLUDES
	#endinput
#endif
#define _CRL2_INCLUDES

//
//  includes.pwn
//


//#include <a_mysql>
#include <core>
#include <float>
#include <file>
#include <string>

#pragma tabsize 8

//
//  Basic definitions.
//

#define DEBUG_ENABLED 	true
#define SECOND_MS	1000

#define SOUND_MUSIC10
#define SOUND_OFF

new const GAMEMODE_NAME[] = "CrazyRaceLife2";

new const MINIMAP_TEXT[] = "~g~Crazy~r~Race~b~Life~y~2";

#include "db/sql.pwn"
#include "support/i18n.pwn"
#include "support/net.pwn"
#include "support/http.pwn"

#include "includes/crazy_race_life_2_version.inc"
#include "includes/sampctl_build_file.inc"

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
#include "modules/drugz.pwn"
#include "modules/team.pwn"
#include "modules/auth.pwn"
#include "modules/real.pwn"
#include "modules/taxi.pwn"
#include "modules/combat.pwn"
#include "modules/tutorial.pwn"
#include "modules/bribe.pwn"
#include "modules/tow.pwn"

//
//  Trucking subsystem.
//

#include "modules/trucking.pwn"

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
//  Pickups, Objects, Vehicles, Texts, Mapicons...
//

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

