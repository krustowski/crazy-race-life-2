#if defined _CRL2_ROB
	#endinput
#endif
#define _CRL2_ROB

//
//  rob.pwn
//  Rob Mission: Robberz hold up commercial properties for cash.
//

// Either key robs on foot: LALT (walk) or LSHIFT (jump).
#define ROB_KEYS						(KEY_WALK | KEY_JUMP)

// How close to a commercial property's offer pickup a robber has to stand.
#define ROB_PROPERTY_RANGE				6.0

// One robbery lasts at most this long, as long as the key is held.
#define ROB_DURATION_MS					20000

// Once a robbery ends, nobody can rob that property again for this long.
#define ROB_PROPERTY_LOCK_SECONDS		300

// A robbed property pays its tenant no commission for this long. Commission
// goes out every 5 minutes, so this skips exactly one payout.
#define ROB_COMMISSION_BLOCK_SECONDS	300

// The mission ends this long after the last successful robbery.
#define ROB_MISSION_COUNTDOWN_MS		300000

// Loot per second is cost / 80 plus up to cost / 160 on top, which averages
// about $980/s on a typical (~$63k) commercial property.
#define ROB_RATE_BASE_DIVISOR			80
#define ROB_RATE_VOLATILE_DIVISOR		160

#define TYPE_MISSION_ROB				9

enum RobMission
{
	bool: Active,
	bool: Robbing,

	// gProperties[] index of the property being robbed
	PropertyArrayID,

	RobbedCount,
	Earned,
	TimeLeft,

	// The robbery in progress
	Loot,
	RobTimeElapsed,

	TimerElapsed,
	TimerRobbery,

	Text: InfoText
}

new
	gRobMission[MAX_PLAYERS][RobMission],
	gRobPropertyLockedUntil[MAX_PROPERTIES];

forward UpdateRobMissionInfoText(playerid);
forward UpdateRobbery(playerid);
forward bool: IsPlayerAbleToRob(playerid);
forward bool: IsPlayerAtRobbableProperty(playerid, arrayid);
forward bool: IsPropertyBeingRobbed(arrayid);

// The mission's 1s clock. The countdown holds while a robbery is in progress,
// so a run cannot expire halfway through one; a successful robbery resets it.
public UpdateRobMissionInfoText(playerid)
{
	// Leaving the team (or joining another one) ends the run.
	if (!IsPlayerInTeam(playerid, TEAM_ROBBERS))
	{
		return AbortRobMission(playerid);
	}

	if (!gRobMission[playerid][Robbing])
	{
		gRobMission[playerid][TimeLeft] -= 1000;

		if (gRobMission[playerid][TimeLeft] <= 0)
		{
			return AbortRobMission(playerid);
		}
	}

	return RedrawRobMissionInfoText(playerid);
}

// The robbery's 1s tick: pays out one second of loot.
public UpdateRobbery(playerid)
{
	if (!gRobMission[playerid][Robbing])
	{
		return 1;
	}

	new
		arrayid = gRobMission[playerid][PropertyArrayID];

	// Walking off or getting into a vehicle ends it the same as letting go.
	if (!IsPlayerAbleToRob(playerid) || !IsPlayerAtRobbableProperty(playerid, arrayid))
	{
		return StopRobbery(playerid);
	}

	new
		loot = GetRobberyRate(arrayid),
		gameText[64];

	gRobMission[playerid][Loot] += loot;
	gRobMission[playerid][Earned] += loot;
	gRobMission[playerid][RobTimeElapsed] += 1000;

	GivePlayerMoney(playerid, loot);

	GetLocalizedString(playerid, I18N_ROB_PROGRESS_GAMETEXT_FMT, gameText, sizeof(gameText));
	format(gameText, sizeof(gameText), gameText,
			gRobMission[playerid][Loot],
			(ROB_DURATION_MS - gRobMission[playerid][RobTimeElapsed]) / 1000
		);
	GameTextForPlayer(playerid, gameText, 1500, 4);

	if (gRobMission[playerid][RobTimeElapsed] >= ROB_DURATION_MS)
	{
		return StopRobbery(playerid);
	}

	return RedrawRobMissionInfoText(playerid);
}

stock RedrawRobMissionInfoText(playerid)
{
	new
		stringToPrint[256];

	GetLocalizedString(playerid, I18N_ROB_MISS_INFO, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint,
			gRobMission[playerid][RobbedCount],
			gRobMission[playerid][Earned],
			gRobMission[playerid][TimeLeft] / 1000 / 60,
			gRobMission[playerid][TimeLeft] / 1000 % 60
		);

	TextDrawSetString(gRobMission[playerid][InfoText], stringToPrint);
	TextDrawShowForPlayer(playerid, gRobMission[playerid][InfoText]);

	return 1;
}

// Called from HandlePlayerKeyStateChange. Returns 1 when the key change started,
// refused or stopped a robbery, 0 to let the other key handlers have it.
stock HandleRobberyKeys(playerid, KEY: newkeys, KEY: oldkeys)
{
	new
		bool: wasHeld = ((oldkeys & ROB_KEYS) != KEY_NONE),
		bool: isHeld = ((newkeys & ROB_KEYS) != KEY_NONE);

	if (gRobMission[playerid][Robbing])
	{
		if (wasHeld && !isHeld)
		{
			StopRobbery(playerid);
			return 1;
		}

		return 0;
	}

	if (!isHeld || wasHeld || !IsPlayerInTeam(playerid, TEAM_ROBBERS) || !IsPlayerAbleToRob(playerid))
	{
		return 0;
	}

	new
		arrayid = GetRobbablePropertyInRange(playerid);

	if (arrayid == INVALID_PROPERTY_ID)
	{
		return 0;
	}

	StartRobbery(playerid, arrayid);

	return 1;
}

stock StartRobbery(playerid, arrayid)
{
	if (gRobMission[playerid][Robbing])
	{
		return 1;
	}

	if (!gRobMission[playerid][Active] && gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_ROB_IN_MINIGAME_BLOCK);
	}

	if (IsPlayerOwnerOfArrayID(playerid, arrayid))
	{
		return SendClientMessageLocalized(playerid, I18N_ROB_OWN_PROPERTY_BLOCK);
	}

	if (IsPropertyBeingRobbed(arrayid))
	{
		return SendClientMessageLocalized(playerid, I18N_ROB_PROPERTY_BUSY);
	}

	new
		lockedFor = gRobPropertyLockedUntil[arrayid] - gettime(),
		stringToPrint[144];

	if (lockedFor > 0)
	{
		GetLocalizedString(playerid, I18N_ROB_PROPERTY_LOCKED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, lockedFor / 60, lockedFor % 60);

		return SendClientMessage(playerid, COLOR_RED, stringToPrint);
	}

	if (!gRobMission[playerid][Active])
	{
		StartRobMission(playerid);
	}

	gRobMission[playerid][Robbing] = true;
	gRobMission[playerid][PropertyArrayID] = arrayid;
	gRobMission[playerid][Loot] = 0;
	gRobMission[playerid][RobTimeElapsed] = 0;

	gRobMission[playerid][TimerRobbery] = SetTimerEx("UpdateRobbery", 1000, true, "i", playerid);

	ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, true, false, false, false, 0);

	GetLocalizedString(playerid, I18N_ROB_STARTED_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, gProperties[arrayid][Label], ROB_DURATION_MS / 1000);
	SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

	return RedrawRobMissionInfoText(playerid);
}

// Ends the robbery in progress, whichever way it ended: the key was released,
// the 20 seconds ran out, or the player wandered off. Either way the property
// gets locked.
stock StopRobbery(playerid)
{
	if (!gRobMission[playerid][Robbing])
	{
		return 1;
	}

	new
		arrayid = gRobMission[playerid][PropertyArrayID],
		loot = gRobMission[playerid][Loot],
		stringToPrint[144];

	KillTimer(gRobMission[playerid][TimerRobbery]);

	gRobMission[playerid][Robbing] = false;
	gRobMission[playerid][PropertyArrayID] = INVALID_PROPERTY_ID;
	gRobMission[playerid][Loot] = 0;
	gRobMission[playerid][RobTimeElapsed] = 0;

	gRobPropertyLockedUntil[arrayid] = gettime() + ROB_PROPERTY_LOCK_SECONDS;

	// Not on a dead player: it would cut into the death animation.
	if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		ClearAnimations(playerid);
	}

	if (!loot)
	{
		SendClientMessageLocalized(playerid, I18N_ROB_NOTHING_TAKEN);
		return RedrawRobMissionInfoText(playerid);
	}

	gRobMission[playerid][RobbedCount]++;
	gRobMission[playerid][TimeLeft] = ROB_MISSION_COUNTDOWN_MS;

	// Every robbery puts the police on to the robber, like a kill does (see
	// RaisePlayerWantedLevel); a bribe takes it down again.
	SetPlayerWantedLevel(playerid, ++gPlayers[playerid][WantedLevel]);

	FireQuestEvent(playerid, QUEST_EVT_PROPERTY_ROBBED);

	gPropertyCommissionBlockedUntil[arrayid] = gettime() + ROB_COMMISSION_BLOCK_SECONDS;
	NotifyRobbedPropertyOwner(arrayid);

	GetLocalizedString(playerid, I18N_ROB_DONE_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, loot, gProperties[arrayid][Label]);
	SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

	return RedrawRobMissionInfoText(playerid);
}

// Tells the tenant, if online, that one of their properties has been robbed,
// without saying which one.
stock NotifyRobbedPropertyOwner(arrayid)
{
	new
		ownerid = gProperties[arrayid][UserID];

	if (!gProperties[arrayid][Occupied] || ownerid <= 0)
	{
		return 0;
	}

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || !gPlayers[i][IsLogged] || gPlayers[i][OrmID] != ownerid)
		{
			continue;
		}

		return SendClientMessageLocalized(i, I18N_ROB_OWNER_NOTICE);
	}

	return 0;
}

stock StartRobMission(playerid)
{
	gRobMission[playerid][Active] = true;
	gRobMission[playerid][RobbedCount] = 0;
	gRobMission[playerid][Earned] = 0;
	gRobMission[playerid][TimeLeft] = ROB_MISSION_COUNTDOWN_MS;

	gPlayers[playerid][InMinigame] = true;

	gRobMission[playerid][TimerElapsed] = SetTimerEx("UpdateRobMissionInfoText", 1000, true, "i", playerid);

	GameTextForPlayer(playerid, gI18nMessages[I18N_ROB_MISS_START][ gPlayers[playerid][Locale] ], 3000, 3);

	return 1;
}

// The single exit path: the countdown ran out, the player died, left the team
// or disconnected. Saves the run when it earned anything.
stock AbortRobMission(playerid)
{
	if (!gRobMission[playerid][Active])
	{
		return 1;
	}

	StopRobbery(playerid);

	KillTimer(gRobMission[playerid][TimerElapsed]);

	if (gRobMission[playerid][Earned] > 0)
	{
		SaveRobMissionScore(playerid);

		new
			stringToPrint[144];

		GetLocalizedString(playerid, I18N_ROB_MISS_SUMMARY_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gRobMission[playerid][RobbedCount], gRobMission[playerid][Earned]);
		SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
	}

	gRobMission[playerid][Active] = false;
	gRobMission[playerid][RobbedCount] = 0;
	gRobMission[playerid][Earned] = 0;
	gRobMission[playerid][TimeLeft] = 0;

	gPlayers[playerid][InMinigame] = false;

	TextDrawHideForPlayer(playerid, gRobMission[playerid][InfoText]);

	GameTextForPlayer(playerid, gI18nMessages[I18N_ROB_MISS_ABORT][ gPlayers[playerid][Locale] ], 3000, 3);

	return 1;
}

stock SaveRobMissionScore(playerid)
{
	if (gRobMission[playerid][Earned] <= 0)
	{
		return 1;
	}

	new
		query[256];
	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id) VALUES (%d, %d, %d, %d)",
			TYPE_MISSION_ROB,
			gRobMission[playerid][RobbedCount],
			gRobMission[playerid][Earned],
			gPlayers[playerid][OrmID]
		);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data for rob mission");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

// Robbing from a vehicle, or while wasted, is not a thing.
stock bool: IsPlayerAbleToRob(playerid)
{
	return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT);
}

stock GetRobberyRate(arrayid)
{
	new
		cost = gProperties[arrayid][Cost],
		rate = cost / ROB_RATE_BASE_DIVISOR,
		spread = cost / ROB_RATE_VOLATILE_DIVISOR;

	if (spread > 0)
	{
		rate += random(spread);
	}

	return rate;
}

// Returns the gProperties[] index of the commercial property whose offer
// pickup the player stands by, or INVALID_PROPERTY_ID.
stock GetRobbablePropertyInRange(playerid)
{
	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (IsPlayerAtRobbableProperty(playerid, i))
		{
			return i;
		}
	}

	return INVALID_PROPERTY_ID;
}

stock bool: IsPlayerAtRobbableProperty(playerid, arrayid)
{
	if (arrayid < 0 || arrayid >= MAX_PROPERTIES)
	{
		return false;
	}

	if (!gProperties[arrayid][ID] || gProperties[arrayid][Type] != PROPERTY_TYPE_COMMERCIAL)
	{
		return false;
	}

	for (new j = 0; j < MAX_PROPERTY_PICKUPS; j++)
	{
		if (gPropertyCoords[arrayid][j][PickupType] != OFFER_POINT)
		{
			continue;
		}

		if (IsPlayerInRangeOfPoint(playerid, ROB_PROPERTY_RANGE,
				gPropertyCoords[arrayid][j][Primary][CoordX],
				gPropertyCoords[arrayid][j][Primary][CoordY],
				gPropertyCoords[arrayid][j][Primary][CoordZ]))
		{
			return true;
		}
	}

	return false;
}

stock bool: IsPropertyBeingRobbed(arrayid)
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (gRobMission[i][Robbing] && gRobMission[i][PropertyArrayID] == arrayid)
		{
			return true;
		}
	}

	return false;
}
