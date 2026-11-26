#if defined _CRL2_DRUGZ
	#endinput
#endif
#define _CRL2_DRUGZ

//
//  drugz.pwn
//  Drug types, the black market and the Drug Mission.
//

#define MAX_DRUG_PICKUPS		64
#define MAX_MARKET_ITEMS		128
#define MAX_DRUGGERY_POINTS		16

#define DRUGGERY_POINT_RANGE	5.0

#define MARKET_RATIO_MIN		0.01
#define MARKET_RATIO_MAX		100.0
#define MARKET_RATIO_EQULIBRIUM	1.0

// The ratio walks in log10 space, where MIN..MAX is -2..+2 around the
// equilibrium at 0, so a step up is as likely as the same step down. A tick is
// one UpdateBlackMarketRatio call, every 3 minutes (support/timers.pwn).
#define MARKET_STEP_LOG			0.08	// a plain tick moves the ratio by up to x1.2 either way
#define MARKET_REVERSION_RATE	0.08	// share of the way back to equilibrium per tick (half-life ~8 ticks)
#define MARKET_SHOCK_CHANCE		5		// percent of ticks that also get a shock
#define MARKET_SHOCK_LOG		0.6		// a shock moves the ratio by up to x4 either way
#define MARKET_SALE_IMPACT_LOG	0.005	// drop per $1000 of drug_prices value sold to the fence

// Once a game day (world time follows the real clock, support/clock.pwn) the
// market booms: the ratio climbs every tick until it hits MARKET_RATIO_MAX,
// holds there for MARKET_BOOM_HOLD_TICKS (only fence sales move it), then
// reverts as usual.
#define MARKET_BOOM_STEP_LOG	0.4	// x2.5 per tick, 5 ticks from equilibrium to the max
#define MARKET_BOOM_MAX_TICKS	12	// fence sales can slow the climb, this tick peaks it anyway
#define MARKET_BOOM_HOLD_TICKS	3
#define MARKET_BOOM_LATEST_S	(23 * 60 * 60)	// latest start, so the boom peaks the same day

#include "support/helpers.pwn"
#include "support/pickups.pwn"

enum BlackMarketItem
{
	OrmID,
	SettlerID,
	Float: Amount,
	Value,
	DrugType: Type
};

new
	gBlackMarketItems[MAX_MARKET_ITEMS][BlackMarketItem],
	gBlackMarketItemOffer[MAX_PLAYERS][BlackMarketItem],
	Float: gBlackMarketRatio = 1.0;

enum MarketBoomPhase
{
	BOOM_NONE,
	BOOM_RISING,
	BOOM_PEAK
}

new
	MarketBoomPhase: gMarketBoomPhase = BOOM_NONE,
	// Ticks spent in the current boom phase
	gMarketBoomTicks,
	// Day of the year the boom schedule is for, and the second of that day the
	// boom starts at (-1: none left that day)
	gMarketBoomDay = -1,
	gMarketBoomAt = -1;

enum
{
	ZAZA,
	TOBACCO,
	PAPER,
	JOINT,
	LIGHTER,
	COCAINE,
	HEROIN,
	METH,
	FENT,
	PCP
}

enum DrugType
{
	TYPE_NONE,
	TYPE_ZAZA,
	TYPE_TOBACCO,
	TYPE_PAPER,
	TYPE_JOINT,
	TYPE_LIGHTER,
	TYPE_COCAINE,
	TYPE_HEROIN,
	TYPE_METH,
	TYPE_FENT,
	TYPE_PCP
}

enum Drug
{
	DrugName[64],
	DrugIniName[64],
	DrugAmount,
	DrugPrice
}

enum DrugPickup
{
	Pickup,
	DrugType: Type,
	Point[Coords]
}

enum DrugMission
{
	bool: Active,

	Count,
	TimeElapsed,

	TimerElapsed,

	Text: InfoText
}

enum DruggeryPoint
{
	ID,
	Pickup,
	PointCoords[Coords]
}

new
	gDruggeryPoints[MAX_DRUGGERY_POINTS][DruggeryPoint],
	gDruggeryPointCount;

new 
	gDrugMission[MAX_PLAYERS][DrugMission],
	gDrugPickups[MAX_DRUG_PICKUPS][DrugPickup],
	gDrugz[MAX_DRUG_TYPES][Drug];

stock InitDrugValues()
{
	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT name, name_alt, price FROM drug_prices ORDER BY id ASC");
	if (!result) 
	{
		print("Database error: cannot fetch drug prices!");
		return;
	}

	if (!DB_GetRowCount(result))
	{
		print("Database error: drug_prices table is empty!");
		DB_FreeResultSet(result);
		return;
	}

	new
		i = 1,
		name[64], 
		name_alt[64], 
		price;

	DB_GetFieldStringByName(result, "name", name, sizeof(name));
	DB_GetFieldStringByName(result, "name_alt", name_alt, sizeof(name_alt));
	price = DB_GetFieldIntByName(result, "price");

	gDrugz[0][DrugName] = name_alt;
	gDrugz[0][DrugIniName] = name;
	gDrugz[0][DrugAmount] = 0;
	gDrugz[0][DrugPrice] = price;

	while (DB_SelectNextRow(result))
	{
		DB_GetFieldStringByName(result, "name", name, sizeof(name));
		DB_GetFieldStringByName(result, "name_alt", name_alt, sizeof(name_alt));
		price = DB_GetFieldIntByName(result, "price");

		gDrugz[i][DrugName] = name_alt;
		gDrugz[i][DrugIniName] = name;
		gDrugz[i][DrugAmount] = 0;
		gDrugz[i][DrugPrice] = price;

		i++;
	}

	print("Drug prices initialized!");
	DB_FreeResultSet(result);
}

stock InitDrugPickups()
{
	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT type, x, y, z FROM drug_coords");
	if (!result) 
	{
		print("Database error: cannot fetch drug coords!");
		return;
	}

	new 
		i = 0;

	do
	{
		new 
			DrugType: type = DrugType: DB_GetFieldIntByName(result, "type"),
			Float: X,
			Float: Y,
			Float: Z;

		X = DB_GetFieldFloatByName(result, "x");
		Y = DB_GetFieldFloatByName(result, "y");
		Z = DB_GetFieldFloatByName(result, "z");

		gDrugPickups[i][Type] = DrugType: type;
		gDrugPickups[i][Point][CoordX] = X;
		gDrugPickups[i][Point][CoordY] = Y;
		gDrugPickups[i][Point][CoordZ] = Z;

		switch (type)
		{
			case TYPE_ZAZA:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_GREEN, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_COCAINE:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_WHITE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_HEROIN:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_YELLOW, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_METH:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_BLUE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_FENT:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_RED, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
			case TYPE_PCP:
				{
					gDrugPickups[i][Pickup] = EnsurePickupCreated(PICKUP_DRUG_ORANGE, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
				}
		}

		i++;
	}
	while(DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	print("Drug pickups initialized!");
}

stock InitDruggeryPoints()
{
	new
		query[] = "SELECT id, x, y, z FROM druggery_points";

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		return 1;
	}

	new
		i = 0;

	do
	{
		new
			id = DB_GetFieldIntByName(result, "id"),
			Float: X = DB_GetFieldFloatByName(result, "x"),
			Float: Y = DB_GetFieldFloatByName(result, "y"),
			Float: Z = DB_GetFieldFloatByName(result, "z");

		gDruggeryPoints[i][ID] = id;
		gDruggeryPoints[i][Pickup] = EnsurePickupCreated(PICKUP_SKULL, 1, X, Y, Z);

		gDruggeryPoints[i][PointCoords][CoordX] = X;
		gDruggeryPoints[i][PointCoords][CoordY] = Y;
		gDruggeryPoints[i][PointCoords][CoordZ] = Z;

		i++;
	}
	while (DB_SelectNextRow(result) && i < MAX_DRUGGERY_POINTS);

	DB_FreeResultSet(result);

	gDruggeryPointCount = i;

	print("Druggery points initialized!");

	return 1;
}

stock CheckDruggeryPointPickup(playerid, pickupid)
{
	for (new i = 0; i < gDruggeryPointCount; i++)
	{
		if (gDruggeryPoints[i][Pickup] != pickupid)
		{
			continue;
		}

		if (GetPlayerDialogID(playerid) != INVALID_DIALOG_ID)
		{
			return 0;
		}

		// Only the druggery points have the fence
		return ShowBlackMarketMainDialog(playerid, true);
	}

	return 0;
}

stock bool: IsPlayerAtDruggeryPoint(playerid)
{
	for (new i = 0; i < gDruggeryPointCount; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, DRUGGERY_POINT_RANGE,
				gDruggeryPoints[i][PointCoords][CoordX],
				gDruggeryPoints[i][PointCoords][CoordY],
				gDruggeryPoints[i][PointCoords][CoordZ]))
		{
			return true;
		}
	}

	return false;
}

//
//  Market ratio.
//

forward UpdateBlackMarketRatio();

// Converts a log10 level back into the ratio. Hitting a bound sets it exactly,
// so a boom peaks at MARKET_RATIO_MAX and not a rounding error below it.
stock SetBlackMarketRatioLevel(Float: level)
{
	if (level >= floatlog(MARKET_RATIO_MAX))
	{
		gBlackMarketRatio = MARKET_RATIO_MAX;
	}
	else if (level <= floatlog(MARKET_RATIO_MIN))
	{
		gBlackMarketRatio = MARKET_RATIO_MIN;
	}
	else
	{
		gBlackMarketRatio = floatpower(10.0, level);
	}
}

// A fence sale floods the market a little: every $1000 of drug_prices value
// sold lowers the ratio by MARKET_SALE_IMPACT_LOG.
stock PushBlackMarketRatioDown(baseValue)
{
	SetBlackMarketRatioLevel(floatlog(gBlackMarketRatio) - MARKET_SALE_IMPACT_LOG * float(baseValue) / 1000.0);
}

// When today's boom starts, somewhere between now and MARKET_BOOM_LATEST_S (in
// seconds since midnight), or -1 when it is too late for one today.
stock PickMarketBoomTime(now)
{
	if (now >= MARKET_BOOM_LATEST_S)
	{
		return -1;
	}

	return now + random(MARKET_BOOM_LATEST_S - now);
}

// Schedules a boom for every new day and starts it once its time has come. A
// restart schedules a fresh one for the rest of the day.
stock UpdateMarketBoomSchedule()
{
	new
		hour,
		minute,
		second,
		today = getdate();

	gettime(hour, minute, second);

	new
		now = hour * 60 * 60 + minute * 60 + second;

	if (today != gMarketBoomDay)
	{
		gMarketBoomDay = today;
		gMarketBoomAt = PickMarketBoomTime(now);
	}

	if (gMarketBoomAt != -1 && now >= gMarketBoomAt && gMarketBoomPhase == BOOM_NONE)
	{
		gMarketBoomAt = -1;
		gMarketBoomPhase = BOOM_RISING;
		gMarketBoomTicks = 0;
	}
}

// A random number in -1.0..1.0, in steps of 0.01
stock Float: RandomMarketUnit()
{
	return float(random(201) - 100) / 100.0;
}

public UpdateBlackMarketRatio()
{
	UpdateMarketBoomSchedule();

	new
		Float: level = floatlog(gBlackMarketRatio),
		bool: peaked = false;

	switch (gMarketBoomPhase)
	{
		case BOOM_RISING:
			{
				level += MARKET_BOOM_STEP_LOG;

				if (++gMarketBoomTicks >= MARKET_BOOM_MAX_TICKS)
				{
					level = floatlog(MARKET_RATIO_MAX);
				}

				if (level >= floatlog(MARKET_RATIO_MAX))
				{
					gMarketBoomPhase = BOOM_PEAK;
					gMarketBoomTicks = 0;
					peaked = true;
				}
			}
		case BOOM_PEAK:
			{
				if (++gMarketBoomTicks >= MARKET_BOOM_HOLD_TICKS)
				{
					gMarketBoomPhase = BOOM_NONE;
				}
			}
		default:
			{
				// Symmetric step, plus a pull toward equilibrium proportional to the distance
				level += MARKET_STEP_LOG * RandomMarketUnit();
				level += MARKET_REVERSION_RATE * (floatlog(MARKET_RATIO_EQULIBRIUM) - level);

				// An occasional shock for the faster swings
				if (random(100) < MARKET_SHOCK_CHANCE)
				{
					level += MARKET_SHOCK_LOG * RandomMarketUnit();
				}
			}
	}

	SetBlackMarketRatioLevel(level);

	// Ratio update message broadcasting
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || gPlayers[i][TeamID] != TEAM_DEALERS)
		{
			continue;
		}

		new
			msg[MAX_MESSAGE_LEN];
		GetLocalizedString(i, I18N_BLACK_MARKET_RATIO_UPDATE, msg, sizeof(msg));

		format(msg, sizeof(msg), msg,
				gBlackMarketRatio
			);

		SendClientMessage(i, COLOR_ORANGE, msg);

		if (peaked)
		{
			GetLocalizedString(i, I18N_FENCE_RATIO_PEAK_FMT, msg, sizeof(msg));
			format(msg, sizeof(msg), msg, MARKET_RATIO_MAX);
			SendClientMessage(i, COLOR_ORANGE, msg);
		}
	}

	return 1;
}

//
//  Drug Mission.
//

forward UpdateDrugMissionInfoText(playerid);

public UpdateDrugMissionInfoText(playerid)
{
	new stringToPrint[256];

	gDrugMission[playerid][TimeElapsed] += 1000;

	format(stringToPrint, sizeof(stringToPrint), gI18nMessages[I18N_DRUG_MISS_INFO][ gPlayers[playerid][Locale] ], 
		gDrugMission[playerid][Count], 
		floatround(floatround(gDrugMission[playerid][TimeElapsed] / 1000) / 60), 
		floatround(gDrugMission[playerid][TimeElapsed] / 1000) % 60
	);

	TextDrawSetString(gDrugMission[playerid][InfoText], stringToPrint);
	TextDrawShowForPlayer(playerid, gDrugMission[playerid][InfoText]);

	return 1;
}

stock CheckDrugzPickup(playerid, pickupid)
{
	for (new i = 0; i < MAX_DRUG_PICKUPS; i++)
	{
		if (pickupid != gDrugPickups[i][Pickup])
		{
			continue;
		}

		new 
			amount = random(10), 
			type = _: gDrugPickups[i][Type], 
			stringToPrint[128];

		gPlayers[playerid][Drugs][type - 1] += amount;

		if (gDrugMission[playerid][Active])
		{
			gDrugMission[playerid][Count] += amount;
		}

		GetLocalizedString(playerid, I18N_DRUGZ_PICKUP_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, amount, gDrugz[type - 1][DrugName]);
		return SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}

	return 0;
}

stock SaveDrugMissionScore(playerid)
{
	if (!gDrugMission[playerid][Count])
	{
		return 1;
	}

	new
		query[256];
	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id, time) VALUES (%d, '%d', %d, %d, %d)",
			8,
			1,
			gDrugMission[playerid][Count],
			gPlayers[playerid][OrmID],
			gDrugMission[playerid][TimeElapsed]
	      );

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data!");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

#include "modules/quest.pwn"

stock AbortPlayerDrugMission(playerid)
{
	if (!gDrugMission[playerid][Active])
	{
		return 1;
	}

	KillTimer(gDrugMission[playerid][TimerElapsed]);

	if (gDrugMission[playerid][Count])
	{
		FireQuestEvent(playerid, QUEST_EVT_DRUG_DONE);
		SaveDrugMissionScore(playerid);
	}

	gPlayers[playerid][InMinigame] = false;

	gDrugMission[playerid][Active] = false;
	gDrugMission[playerid][Count] = 0;
	gDrugMission[playerid][TimeElapsed] = 0;

	TextDrawHideForPlayer(playerid, gDrugMission[playerid][InfoText]);

	//SendClientMessageLocalized(playerid, I18N_DRUG_MISS_ABORTED);

	new
		gameText[32];

	GetLocalizedString(playerid, I18N_DRUG_MISS_ABORTED, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 3000, 3);

	return 1;
}

stock ToggleDrugMission(playerid)
{
	if (gDrugMission[playerid][Active])
	{
		return AbortPlayerDrugMission(playerid);
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_DRUG_MISS_INMINIGAME_CONFLICT);
	}

	if (gPlayers[playerid][TeamID] != TEAM_DEALERS)
	{
		return SendClientMessageLocalized(playerid, I18N_DRUG_MISS_UNMET_TEAM);
	}

	gDrugMission[playerid][Active] = true;
	gPlayers[playerid][InMinigame] = true;

	gDrugMission[playerid][Count] = 0;
	gDrugMission[playerid][TimeElapsed] = 0;

	gDrugMission[playerid][TimerElapsed] = SetTimerEx("UpdateDrugMissionInfoText", 1000, true, "i", playerid);

	//SendClientMessageLocalized(playerid, I18N_DRUG_MISS_STARTED);

	new
		gameText[32];

	GetLocalizedString(playerid, I18N_DRUG_MISS_STARTED, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 3000, 3);

	return 1;
}

#include "modules/fence.pwn"
