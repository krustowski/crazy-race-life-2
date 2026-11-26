#if defined _CRL2_COMBAT
	#endinput
#endif
#define _CRL2_COMBAT

//
//  combat.pwn
//

#define MAX_COMBAT_NPCS				25
#define MAX_COMBAT_PICKUPS			20
#define MAX_COMBAT_VEHICLES			5
#define COMBAT_ACCURACY				0.15
#define COMBAT_BRIEFCASE_DOLLARS	50000

enum 
{
	COMBAT_COORD_NONE,
	COMBAT_COORD_BRIEFCASE,
	COMBAT_COORD_NPC,
	COMBAT_COORD_HEALTH,
	COMBAT_COORD_HELI,
	COMBAT_COORD_EXIT,
	COMBAT_COORD_ROOF,
	COMBAT_COORD_CP,
	COMBAT_COORD_NPC_MAN,
	COMBAT_COORD_DOOR,
	COMBAT_COORD_SPAWN
}

enum CombatPickupType
{
	TYPE_NONE,
	TYPE_BRIEFCASE,
	TYPE_HEALTH,
	TYPE_EXIT,
	TYPE_CP,
	TYPE_DOOR
}

enum CombatPickup
{
	Pickup,
	CombatPickupType: Type,
	Point[Coords],
	// Where a TYPE_DOOR pickup leads: Point in this interior, or -1 for a
	// door with no target, which is only scenery.
	Interior
}

enum CombatMission
{
	bool: Active,
	bool: Dead,
	// The race checkpoint toward the briefcase man has been shown, by the
	// exit pickup or by taking the helicopter. Stays set once it is reached.
	bool: CheckpointShown,
	MissionID,
	BriefcaseCount,

	// Start position from the mission's SPAWN row. SpawnInterior is -1 when
	// the mission has none, and the player then stays where they are.
	Spawn[Coords],
	SpawnInterior,

	Text: InfoText,

	TimeElapsed,
	Timer: TimerUpdate,
	Timer: TimerBriefcaseMan
}

new 
	gCombatNPC[MAX_COMBAT_NPCS] = {INVALID_NPC_ID, ...},
	gCombatMission[MAX_PLAYERS][CombatMission],
	gCombatPickups[MAX_COMBAT_PICKUPS][CombatPickup],
	gCombatVehicles[MAX_COMBAT_VEHICLES] = {INVALID_VEHICLE_ID, ...},
	// The pickup, NPC and vehicle arrays above are shared by the whole server
	// and every mission uses the same interior, so only one player can run a
	// combat mission at a time. This is who holds it.
	gCombatOccupant = INVALID_PLAYER_ID,
	// Monotonic suffix for NPC names. NPC_Create() fails on a name that is
	// still taken, so a name is never reused.
	gCombatNPCSeq = 0;

forward CheckBriefcaseManProximity(playerid, npcid);
forward UpdateCombatMissionInfoText(playerid);

public CheckBriefcaseManProximity(playerid, npcid)
{
	new 
		Float: pX, 
		Float: pY, 
		Float: pZ;

	GetPlayerPos(npcid, pX, pY, pZ);

	new 
		interior = GetPlayerInterior(playerid);

	if (interior == 0 && IsPlayerInSphere(playerid, pX, pY, pZ, 4.0))
	{
		KillTimer(_: gCombatMission[playerid][TimerBriefcaseMan]);

		new 
			prize = gCombatMission[playerid][BriefcaseCount] * COMBAT_BRIEFCASE_DOLLARS, 
			stringToPrint[128];

		GetLocalizedString(playerid, I18N_COMBAT_BRIEFCASES_EXCHANGED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, prize);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint); 

		GivePlayerMoney(playerid, prize);
		PlayerPlaySound(playerid, 1147, 0, 0, 0);

		AbortCombatMission(playerid, true);
	}

	return 1;
}

public UpdateCombatMissionInfoText(playerid)
{
	new 
		stringToPrint[256];

	gCombatMission[playerid][TimeElapsed] += 1000;

	GetLocalizedString(playerid, I18N_COMBAT_INFO_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint,
			gCombatMission[playerid][BriefcaseCount], 
			floatround(floatround(gCombatMission[playerid][TimeElapsed] / 1000) / 60), 
			floatround(gCombatMission[playerid][TimeElapsed] / 1000) % 60
		);

	TextDrawSetString(gCombatMission[playerid][InfoText], stringToPrint);
	TextDrawShowForPlayer(playerid, gCombatMission[playerid][InfoText]);

	return 1;
}

stock CheckCombatCheckpoint(playerid)
{
	if (!gCombatMission[playerid][Active])
	{
		return 0;
	}

	DisablePlayerRaceCheckpoint(playerid);

	SendClientMessageLocalized(playerid, I18N_COMBAT_FOLLOW_MARKER_BRIEFCASEMAN);

	return 1;
}

// Shows the race checkpoint at the mission's CP point, the helicopter's
// destination by the briefcase man.
stock ShowCombatCheckpoint(playerid)
{
	for (new j = 0; j < MAX_COMBAT_PICKUPS; j++)
	{
		if (gCombatPickups[j][Type] != TYPE_CP)
		{
			continue;
		}

		gCombatMission[playerid][CheckpointShown] = true;

		SendClientMessageLocalized(playerid, I18N_COMBAT_HELICOPTER_INSTRUCTIONS);

		SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, gCombatPickups[j][Point][CoordX], gCombatPickups[j][Point][CoordY], gCombatPickups[j][Point][CoordZ], 0.0, 0.0, 0.0, 10.0);
	}

	return 1;
}

// A mission played outdoors has no exit pickup to show the checkpoint, so
// taking its helicopter does. Called on entering any vehicle as the driver.
stock CheckCombatVehicle(playerid, vehicleid)
{
	if (!gCombatMission[playerid][Active] || gCombatMission[playerid][CheckpointShown])
	{
		return 0;
	}

	for (new i = 0; i < MAX_COMBAT_VEHICLES; i++)
	{
		if (gCombatVehicles[i] == vehicleid)
		{
			return ShowCombatCheckpoint(playerid);
		}
	}

	return 0;
}

stock CheckCombatPickup(playerid, pickupid)
{
	if (!gCombatMission[playerid][Active])
	{
		return 0;
	}

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		if (gCombatPickups[i][Pickup] != pickupid)
		{
			continue;
		}

		switch (gCombatPickups[i][Type])
		{
			case TYPE_BRIEFCASE:
				{
					gCombatMission[playerid][BriefcaseCount]++;

					new 
						stringToPrint[128];

					GetLocalizedString(playerid, I18N_COMBAT_FOUND_BRIEFCASE_FMT, stringToPrint, sizeof(stringToPrint));
					format(stringToPrint, sizeof(stringToPrint), stringToPrint, 
							gCombatMission[playerid][BriefcaseCount]
						);

					return SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
				}
			case (CombatPickupType: TYPE_HEALTH):
				{
					return SetPlayerHealth(playerid, 100.0);
				}
			case TYPE_EXIT:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerPos(playerid, gCombatPickups[i][Point][CoordX], gCombatPickups[i][Point][CoordY], gCombatPickups[i][Point][CoordZ]);

					return ShowCombatCheckpoint(playerid);
				}
			case TYPE_DOOR:
				{
					if (gCombatPickups[i][Interior] < 0)
					{
						return 1;
					}

					SetPlayerInterior(playerid, gCombatPickups[i][Interior]);
					SetPlayerPos(playerid, gCombatPickups[i][Point][CoordX], gCombatPickups[i][Point][CoordY], gCombatPickups[i][Point][CoordZ]);

					return 1;
				}
			default:
				{}
		}
	}

	return 0;
}

// Creates one armed combat NPC for array slot `slot`. Returns INVALID_NPC_ID
// (leaving the slot untouched) when the slots are exhausted or the NPC
// component refuses the create.
stock CreateCombatNPC(slot, const prefix[], interior, Float: X, Float: Y, Float: Z)
{
	if (slot >= MAX_COMBAT_NPCS)
	{
		printf("Combat: NPC slots exhausted (%d), skipping %s NPC", MAX_COMBAT_NPCS, prefix);
		return INVALID_NPC_ID;
	}

	new 
		npc_name[MAX_PLAYER_NAME];

	format(npc_name, sizeof(npc_name), "[NPC]%s%d", prefix, gCombatNPCSeq++);

	new 
		npcid = NPC_Create(npc_name);

	if (npcid == INVALID_NPC_ID)
	{
		printf("Combat: NPC_Create failed for %s", npc_name);
		return INVALID_NPC_ID;
	}

	NPC_Spawn(npcid);
	NPC_SetInterior(npcid, interior);
	NPC_SetPos(npcid, X, Y, Z);

	NPC_SetWeapon(npcid, WEAPON: 29);
	NPC_SetAmmo(npcid, 1000);
	NPC_EnableInfiniteAmmo(npcid, true);
	NPC_SetWeaponAccuracy(npcid, WEAPON: 29, COMBAT_ACCURACY);

	return npcid;
}

// Forgets an NPC id that was destroyed elsewhere (OnNPCDeath), so a later
// teardown cannot destroy whatever NPC has since inherited that id.
stock ReleaseCombatNPC(npcid)
{
	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		if (gCombatNPC[i] == npcid)
		{
			gCombatNPC[i] = INVALID_NPC_ID;
			return 1;
		}
	}

	return 0;
}

stock PrepareCombatInterior(playerid, missionid)
{
	if (!missionid)
	{
		print("Combat mission ID 0!");
		return 0;
	}

	new 
		query[256];

	// ORDER BY id: a ROOF row fills in the EXIT pickups created before it.
	format(query, sizeof(query), "SELECT type, x, y, z, interior, target_x, target_y, target_z, IFNULL(target_interior, -1) AS target_interior FROM combat_coords WHERE mission_id = %d ORDER BY id", missionid);

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot list combat coords");
		print(query);
		return 0;
	}

	// No layout for this id: starting it would leave the player in a mission
	// with nothing in it, which they could only abort
	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		printf("Combat mission %d has no layout!", missionid);
		return 0;
	}

	new 
		npcid = 0,
		pickupid = 0,
		vehicleid = 0;

	gCombatMission[playerid][SpawnInterior] = -1;

	do
	{
		new 
			type = DB_GetFieldIntByName(result, "type"),
			interior = DB_GetFieldIntByName(result, "interior"),
			Float: X, 
			Float: Y, 
			Float: Z;

		X = DB_GetFieldFloatByName(result, "x");
		Y = DB_GetFieldFloatByName(result, "y");
		Z = DB_GetFieldFloatByName(result, "z");

		switch (type)
		{
			case COMBAT_COORD_BRIEFCASE:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_BRIEFCASE, PICKUP_TYPE_NO_RESPAWN, X, Y, Z);
					gCombatPickups[pickupid][Type] = TYPE_BRIEFCASE;
					pickupid++;
				}
			case COMBAT_COORD_NPC:
				{
					new 
						id = CreateCombatNPC(npcid, "combat", interior, X, Y, Z);

					if (id != INVALID_NPC_ID)
					{
						new 
							Float: pX, 
							Float: pY, 
							Float: pZ;

						GetPlayerPos(playerid, pX, pY, pZ);

						NPC_AimAtPlayer(id, playerid, true, 0, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						NPC_Shoot(id, WEAPON:29, playerid, 0, pX, pY, pZ, 0.0, 0.0, 0.0, true);

						gCombatNPC[npcid++] = id;
					}
				}
			case COMBAT_COORD_HEALTH:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_HEART, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
					gCombatPickups[pickupid][Type] = CombatPickupType: TYPE_HEALTH;
					pickupid++;
				}
			case COMBAT_COORD_HELI:
				{
					gCombatVehicles[vehicleid] = CreateVehicle(487, X, Y, Z, 0.0, 12, 0, -1);
					SetVehicleParamsForPlayer(gCombatVehicles[vehicleid], playerid, true, false);
					vehicleid++;
				}
			case COMBAT_COORD_EXIT:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_ARROW, 1, X, Y, Z);
					gCombatPickups[pickupid][Type] = CombatPickupType: TYPE_EXIT;
					pickupid++;
				}
			case COMBAT_COORD_ROOF:
				{
					for (new j = 0; j < MAX_COMBAT_PICKUPS; j++)
					{
						if (gCombatPickups[j][Type] != TYPE_EXIT)
						{
							continue;
						}

						gCombatPickups[j][Point][CoordX] = X;
						gCombatPickups[j][Point][CoordY] = Y;
						gCombatPickups[j][Point][CoordZ] = Z;
					}
				}
			case COMBAT_COORD_CP:
				{
					gCombatPickups[pickupid][Type] = TYPE_CP;
					gCombatPickups[pickupid][Point][CoordX] = X;
					gCombatPickups[pickupid][Point][CoordY] = Y;
					gCombatPickups[pickupid][Point][CoordZ] = Z;
					pickupid++;
				}
			case COMBAT_COORD_NPC_MAN:
				{
					new 
						id = CreateCombatNPC(npcid, "bcman", interior, X, Y, Z);

					if (id != INVALID_NPC_ID)
					{
						SetPlayerMarkerForPlayer(playerid, id, COLOR_YELLOW);

						gCombatMission[playerid][TimerBriefcaseMan] = Timer: SetTimerEx("CheckBriefcaseManProximity", 2000, true, "i,i", playerid, id);

						gCombatNPC[npcid++] = id;
					}
				}
			case COMBAT_COORD_DOOR:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_ARROW, 1, X, Y, Z);
					gCombatPickups[pickupid][Type] = CombatPickupType: TYPE_DOOR;
					gCombatPickups[pickupid][Point][CoordX] = DB_GetFieldFloatByName(result, "target_x");
					gCombatPickups[pickupid][Point][CoordY] = DB_GetFieldFloatByName(result, "target_y");
					gCombatPickups[pickupid][Point][CoordZ] = DB_GetFieldFloatByName(result, "target_z");
					gCombatPickups[pickupid][Interior] = DB_GetFieldIntByName(result, "target_interior");
					pickupid++;
				}
			case COMBAT_COORD_SPAWN:
				{
					gCombatMission[playerid][Spawn][CoordX] = X;
					gCombatMission[playerid][Spawn][CoordY] = Y;
					gCombatMission[playerid][Spawn][CoordZ] = Z;
					gCombatMission[playerid][SpawnInterior] = interior;
				}
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	return 1;
}

stock SetCombatMission(playerid, missionid)
{
	if (gCombatMission[playerid][Active])
	{
		return AbortCombatMission(playerid, false);
	}

	if (gPlayers[playerid][InMinigame])
	{
		return SendClientMessageLocalized(playerid, I18N_COMBAT_IN_MINIGAME_BLOCK);
	}

	// One mission at a time server-wide (see gCombatOccupant). A holder who
	// is gone or no longer active is a stale lock, not a live mission.
	if (gCombatOccupant != INVALID_PLAYER_ID && gCombatOccupant != playerid
		&& IsPlayerConnected(gCombatOccupant) && gCombatMission[gCombatOccupant][Active])
	{
		return SendClientMessageLocalized(playerid, I18N_COMBAT_OCCUPIED_BLOCK);
	}

	if (!PrepareCombatInterior(playerid, missionid))
	{
		return SendClientMessageLocalized(playerid, I18N_COMBAT_GENERIC_ERROR_NEW_MISS);
	}

	gCombatOccupant = playerid;
	gPlayers[playerid][InMinigame] = true;

	gCombatMission[playerid][Active] = true;
	gCombatMission[playerid][CheckpointShown] = false;
	gCombatMission[playerid][TimeElapsed] = 0;
	gCombatMission[playerid][BriefcaseCount] = 0;
	gCombatMission[playerid][MissionID] = missionid;

	gCombatMission[playerid][InfoText] = TextDrawCreate(460.0, 400.0, "");
	TextDrawLetterSize(gCombatMission[playerid][InfoText], 0.5, 1.5);
	TextDrawFont(gCombatMission[playerid][InfoText], TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gCombatMission[playerid][InfoText], 1);

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, WEAPON: 26, 200);
	GivePlayerWeapon(playerid, WEAPON: 31, 500);

	gCombatMission[playerid][TimerUpdate] = Timer: SetTimerEx("UpdateCombatMissionInfoText", 1000, true, "i", playerid);

	new 
		gameText[32];

	GetLocalizedString(playerid, I18N_COMBAT_MISS_START, gameText, sizeof(gameText));
	GameTextForPlayer(playerid, gameText, 3000, 3); 

	if (gCombatMission[playerid][SpawnInterior] >= 0)
	{
		SetPlayerInterior(playerid, gCombatMission[playerid][SpawnInterior]);
		SetPlayerPos(playerid, gCombatMission[playerid][Spawn][CoordX], gCombatMission[playerid][Spawn][CoordY], gCombatMission[playerid][Spawn][CoordZ]);
	}

	return 1;
}

stock SaveCombatMissionScore(playerid)
{
	if (!gCombatMission[playerid][BriefcaseCount])
	{
		return 1;
	}

	new 
		query[256];

	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id) VALUES (%d, %d, %d, %d)",
			5,
			gCombatMission[playerid][MissionID],
			gCombatMission[playerid][BriefcaseCount],
			gPlayers[playerid][OrmID]
	      );

	new 
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data for combat!");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

stock AbortCombatMission(playerid, bool: success)
{
	if (!gCombatMission[playerid][Active])
	{
		return 1;
	}

	// Same reasoning as EndDeathmatch(): a destroyed id goes straight back into
	// the pool. Leaving it here means the next abort destroys whatever pickup
	// has since inherited the id -- slots this run never filled still hold ids
	// from the run before.
	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		if (gCombatPickups[i][Pickup] > 0)
		{
			DestroyPickup(gCombatPickups[i][Pickup]);
		}

		gCombatPickups[i][Pickup] = INVALID_PICKUP;
		gCombatPickups[i][Type] = CombatPickupType: TYPE_NONE;
	}

	// Same again for NPCs: only destroy ids we still own, then forget them.
	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		if (NPC_IsValid(gCombatNPC[i]))
		{
			NPC_Destroy(gCombatNPC[i]);
		}

		gCombatNPC[i] = INVALID_NPC_ID;
	}

	for (new i = 0; i < MAX_COMBAT_VEHICLES; i++)
	{
		if (gCombatVehicles[i] != INVALID_VEHICLE_ID)
		{
			DestroyVehicle(gCombatVehicles[i]);
		}

		gCombatVehicles[i] = INVALID_VEHICLE_ID;
	}

	DisablePlayerRaceCheckpoint(playerid);

	if (gCombatMission[playerid][TimerUpdate] != Timer: INVALID_TIMER)
	{
		KillTimer(_: gCombatMission[playerid][TimerUpdate]);
	}

	// Only armed when the layout has an NPC_MAN row; on other missions the
	// field would still hold the id from the last run.
	if (gCombatMission[playerid][TimerBriefcaseMan] != Timer: INVALID_TIMER)
	{
		KillTimer(_: gCombatMission[playerid][TimerBriefcaseMan]);
	}

	gCombatMission[playerid][TimerUpdate] = Timer: INVALID_TIMER;
	gCombatMission[playerid][TimerBriefcaseMan] = Timer: INVALID_TIMER;

	TextDrawHideForPlayer(playerid, gCombatMission[playerid][InfoText]);

	new 
		gameText[32];

	if (success)
	{
		GetLocalizedString(playerid, I18N_COMBAT_MISS_FINISHED, gameText, sizeof(gameText));
		GameTextForPlayer(playerid, gameText, 3000, 3); 

		FireQuestEvent(playerid, QUEST_EVT_COMBAT_DONE);

		SaveCombatMissionScore(playerid);
	}
	else
	{
		GetLocalizedString(playerid, I18N_COMBAT_MISS_ABORT, gameText, sizeof(gameText));

		GameTextForPlayer(playerid, gameText, 3000, 3); 
	}

	gPlayers[playerid][InMinigame] = false;

	if (gCombatOccupant == playerid)
	{
		gCombatOccupant = INVALID_PLAYER_ID;
	}

	gCombatMission[playerid][Active] = false;
	gCombatMission[playerid][CheckpointShown] = false;
	gCombatMission[playerid][TimeElapsed] = 0;
	gCombatMission[playerid][BriefcaseCount] = 0;

	if (!gCombatMission[playerid][Dead])
	{
		SetPlayerInterior(playerid, 0);
		SpawnPlayer(playerid);
	}

	gCombatMission[playerid][Dead] = false;

	return 1;
}
