#if defined _CRL2_COMBAT
	#endinput
#endif
#define _CRL2_COMBAT

//
//  combat.pwn
//

#define MAX_COMBAT_NPCS		10
#define MAX_COMBAT_PICKUPS	10

enum 
{
	COMBAT_COORD_NONE,
	COMBAT_COORD_BRIEFCASE,
	COMBAT_COORD_NPC,
	COMBAT_COORD_HEALTH
}

enum CombatPickupType
{
	TYPE_NONE,
	TYPE_BRIEFCASE,
	TYPE_HEALTH
}

enum CombatPickup
{
	Pickup,
	CombatPickupType: Type
}

enum CombatMission
{
	bool: Active,
	BriefcaseCount,

	Text: InfoText,

	TimeElapsed,
	Timer: TimerUpdate
}

new gCombatNPC[MAX_COMBAT_NPCS];
new gCombatMission[MAX_PLAYERS][CombatMission];
new gCombatPickups[MAX_COMBAT_PICKUPS][CombatPickup];

forward UpdateCombatMissionInfoText(playerid);

public UpdateCombatMissionInfoText(playerid)
{
	new stringToPrint[256];

	gCombatMission[playerid][TimeElapsed] += 1000;

	switch (gPlayers[playerid][Locale]) 
	{
		case LOCALE_CZ:
			//
			{}

		default:
			format(stringToPrint, sizeof(stringToPrint), "~w~Briefcase:_~g~%d~n~~w~Time:______~b~%d~y~:~b~%2d", gCombatMission[playerid][BriefcaseCount], floatround(floatround(gCombatMission[playerid][TimeElapsed] / 1000) / 60), floatround(gCombatMission[playerid][TimeElapsed] / 1000) % 60);
	}

	TextDrawSetString(gCombatMission[playerid][InfoText], stringToPrint);
	TextDrawShowForPlayer(playerid, gCombatMission[playerid][InfoText]);

	return 1;
}


stock CheckCombatPickup(playerid, pickupid)
{
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

					new stringToPrint[128];
					format(stringToPrint, sizeof(stringToPrint), "[ COMBAT ] You found a briefcase no. %d", gCombatMission[playerid][BriefcaseCount]);
					SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
				}
			case TYPE_HEALTH:
				{
					SetPlayerHealth(playerid, 100.0);
				}
		}
	}

	return 1;
}

stock PrepareCombatInterior(playerid)
{
	new query[256] = "SELECT type, x, y, z FROM combat_coords";

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot list combat coords");
		print(query);
		return 0;
	}

	new npcid = 0;
	new pickupid = 0;

	do
	{
		new type = DB_GetFieldIntByName(result, "type");
		new Float: X, Float: Y, Float: Z;

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
					new npc_name[MAX_PLAYER_NAME];
					format(npc_name, sizeof(npc_name), "[NPC]combat%d", npcid);
					gCombatNPC[npcid] = NPC_Create(npc_name);

					NPC_Spawn(gCombatNPC[npcid]);
					NPC_SetInterior(gCombatNPC[npcid], 3);
					NPC_SetPos(gCombatNPC[npcid], X, Y, Z);

					NPC_SetWeapon(gCombatNPC[npcid], 29);
					NPC_SetAmmo(gCombatNPC[npcid], 1000);
					NPC_EnableInfiniteAmmo(gCombatNPC[npcid], true);
					NPC_SetWeaponAccuracy(gCombatNPC[npcid], 29, 0.1);

					new Float: pX, Float: pY, Float: pZ;
					GetPlayerPos(playerid, pX, pY, pZ);

					NPC_AimAtPlayer(gCombatNPC[npcid], playerid, true, 0, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
					NPC_Shoot(gCombatNPC[npcid], 29, playerid, 0, pX, pY, pZ, 0.0, 0.0, 0.0, true);

					npcid++;
				}
			case COMBAT_COORD_HEALTH:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_HEART, PICKUP_TYPE_RESPAWN_30_SECONDS, X, Y, Z);
					gCombatPickups[pickupid][Type] = TYPE_HEALTH;
					pickupid++;
				}
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	return 1;
}

stock SetCombatMission(playerid)
{
	if (gCombatMission[playerid][Active])
	{
		return AbortCombatMission(playerid);
	}

	if (!PrepareCombatInterior(playerid))
	{
		return SendClientMessage(playerid, COLOR_RED, "[ COMBAT ] Error setting new combat mission!");
	}

	gCombatMission[playerid][Active] = true;
	gCombatMission[playerid][BriefcaseCount] = 0;

	gCombatMission[playerid][TimerUpdate] = Timer: SetTimerEx("UpdateCombatMissionInfoText", 1000, true, "i", playerid);

	gCombatMission[playerid][InfoText] = TextDrawCreate(460.0, 400.0, "");
	TextDrawLetterSize(gCombatMission[playerid][InfoText], 0.5, 1.5);
	TextDrawFont(gCombatMission[playerid][InfoText], t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gCombatMission[playerid][InfoText], 1);

	GameTextForPlayer(playerid, "~w~Combat Mission ~g~Started", 3000, 3); 

	SetPlayerInterior(playerid, 3);
	SetPlayerPos(playerid, 374.6708, 173.8050, 1008.3893);

	return 1;
}

stock AbortCombatMission(playerid)
{
	gCombatMission[playerid][Active] = false;
	gCombatMission[playerid][BriefcaseCount] = 0;

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		DestroyPickup(gCombatPickups[i][Pickup]);
	}

	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		NPC_Destroy(i);
	}

	KillTimer(_: gCombatMission[playerid][TimerUpdate]);

	TextDrawHideForPlayer(playerid, gCombatMission[playerid][InfoText]);
	GameTextForPlayer(playerid, "~w~Combat Mission ~r~Aborted", 3000, 3); 

	SetPlayerInterior(playerid, 0);
	SpawnPlayer(playerid);

	return 1;
}
