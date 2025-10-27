#if defined _CRL2_COMBAT
	#endinput
#endif
#define _CRL2_COMBAT

//
//  combat.pwn
//

#define MAX_COMBAT_NPCS			25
#define MAX_COMBAT_PICKUPS		20
#define MAX_COMBAT_VEHICLES		5
#define COMBAT_ACCURACY			0.15
#define COMPAT_BRIEFCASE_DOLLARS	50000

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
	Point[Coords]
}

enum CombatMission
{
	bool: Active,
	bool: Dead,
	BriefcaseCount,

	Text: InfoText,

	TimeElapsed,
	Timer: TimerUpdate,
	Timer: TimerBriefcaseMan
}

new gCombatNPC[MAX_COMBAT_NPCS];
new gCombatMission[MAX_PLAYERS][CombatMission];
new gCombatPickups[MAX_COMBAT_PICKUPS][CombatPickup];
new gCombatVehicles[MAX_COMBAT_VEHICLES];

forward CheckBriefcaseManProximity(playerid, npcid);
forward UpdateCombatMissionInfoText(playerid);

public CheckBriefcaseManProximity(playerid, npcid)
{
	new Float: pX, Float: pY, Float: pZ;

	GetPlayerPos(npcid, pX, pY, pZ);
	new interior = GetPlayerInterior(playerid);

	if (interior == 0 && IsPlayerInSphere(playerid, pX, pY, pZ, 4.0))
	{
		KillTimer(_: gCombatMission[playerid][TimerBriefcaseMan]);

		new prize = gCombatMission[playerid][BriefcaseCount] * COMPAT_BRIEFCASE_DOLLARS, stringToPrint[128];
		format(stringToPrint, sizeof(stringToPrint), "[ COMBAT ] Briefcases exchanged for money ($%d)!", prize);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint); 

		GivePlayerMoney(playerid, prize);
		PlayerPlaySound(playerid, 1147, 0, 0, 0);

		AbortCombatMission(playerid, true);
	}

	return 1;
}

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

stock CheckCombatCheckpoint(playerid)
{
	if (!gCombatMission[playerid][Active])
	{
		return 1;
	}

	DisablePlayerRaceCheckpoint(playerid);

	SendClientMessage(playerid, COLOR_ORANGE, "[ COMBAT ] Follow the yellow marker on map to give the briefcase man the briefcases!");

	return 1;
}

stock CheckCombatPickup(playerid, pickupid)
{
	
	if (!gCombatMission[playerid][Active])
	{
		return 1;
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

					new stringToPrint[128];
					format(stringToPrint, sizeof(stringToPrint), "[ COMBAT ] You found a briefcase no. %d", gCombatMission[playerid][BriefcaseCount]);
					SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);
				}
			case (CombatPickupType: TYPE_HEALTH):
				{
					SetPlayerHealth(playerid, 100.0);
				}
			case TYPE_EXIT:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerPos(playerid, gCombatPickups[i][Point][CoordX], gCombatPickups[i][Point][CoordY], gCombatPickups[i][Point][CoordZ]);

					for (new j = 0; j < MAX_COMBAT_PICKUPS; j++)
					{
						if (gCombatPickups[j][Type] != TYPE_CP)
						{
							continue;
						}

						SendClientMessage(playerid, COLOR_ORANGE, "[ COMBAT ] Take the helicopter and follow the checkpoint on the minimap!");
						SetPlayerRaceCheckpoint(playerid, CP_TYPE_GROUND_FINISH, gCombatPickups[j][Point][CoordX], gCombatPickups[j][Point][CoordY], gCombatPickups[j][Point][CoordZ], 0.0, 0.0, 0.0, 10.0);
					}
				}
		}
	}

	return 1;
}

stock PrepareCombatInterior(playerid, missionid)
{
	if (!missionid)
	{
		print("Combat mission ID 0!");
		return 0;
	}

	new query[256];
	format(query, sizeof(query), "SELECT type, x, y, z FROM combat_coords WHERE mission_id = %d", missionid);

	new DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot list combat coords");
		print(query);
		return 0;
	}

	new npcid = 0;
	new pickupid = 0;
	new vehicleid = 0;

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
					NPC_SetWeaponAccuracy(gCombatNPC[npcid], 29, COMBAT_ACCURACY);

					new Float: pX, Float: pY, Float: pZ;
					GetPlayerPos(playerid, pX, pY, pZ);

					NPC_AimAtPlayer(gCombatNPC[npcid], playerid, true, 0, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
					NPC_Shoot(gCombatNPC[npcid], 29, playerid, 0, pX, pY, pZ, 0.0, 0.0, 0.0, true);

					npcid++;
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
					new npc_name[MAX_PLAYER_NAME];
					format(npc_name, sizeof(npc_name), "[NPC]bcman%d", npcid);
					gCombatNPC[npcid] = NPC_Create(npc_name);

					NPC_Spawn(gCombatNPC[npcid]);
					NPC_SetInterior(gCombatNPC[npcid], 0);
					NPC_SetPos(gCombatNPC[npcid], X, Y, Z);

					NPC_SetWeapon(gCombatNPC[npcid], 29);
					NPC_SetAmmo(gCombatNPC[npcid], 1000);
					NPC_EnableInfiniteAmmo(gCombatNPC[npcid], true);
					NPC_SetWeaponAccuracy(gCombatNPC[npcid], 29, COMBAT_ACCURACY);

					SetPlayerMarkerForPlayer(playerid, gCombatNPC[npcid], COLOR_YELLOW);

					gCombatMission[playerid][TimerBriefcaseMan] = Timer: SetTimerEx("CheckBriefcaseManProximity", 2000, true, "i,i", playerid, gCombatNPC[npcid]);

					npcid++;
				}
			case COMBAT_COORD_DOOR:
				{
					gCombatPickups[pickupid][Pickup] = EnsurePickupCreated(PICKUP_ARROW, 1, X, Y, Z);
					gCombatPickups[pickupid][Type] = CombatPickupType: TYPE_DOOR;
					pickupid++;
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

	if (!PrepareCombatInterior(playerid, missionid))
	{
		return SendClientMessage(playerid, COLOR_RED, "[ COMBAT ] Error setting new combat mission!");
	}

	gCombatMission[playerid][Active] = true;
	gCombatMission[playerid][TimeElapsed] = 0;
	gCombatMission[playerid][BriefcaseCount] = 0;

	gCombatMission[playerid][InfoText] = TextDrawCreate(460.0, 400.0, "");
	TextDrawLetterSize(gCombatMission[playerid][InfoText], 0.5, 1.5);
	TextDrawFont(gCombatMission[playerid][InfoText], t_TEXT_DRAW_FONT: 3);
	TextDrawSetOutline(gCombatMission[playerid][InfoText], 1);

	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, t_WEAPON: 26, 200);
	GivePlayerWeapon(playerid, t_WEAPON: 31, 500);

	gCombatMission[playerid][TimerUpdate] = Timer: SetTimerEx("UpdateCombatMissionInfoText", 1000, true, "i", playerid);

	GameTextForPlayer(playerid, "~w~Combat Mission ~g~Started", 3000, 3); 

	switch (missionid)
	{
		case 1:
			{
				SetPlayerInterior(playerid, 3);
				SetPlayerPos(playerid, 376.27, 186.46, 1008.38);
			}
		case 2:
			{
				SetPlayerPos(playerid, 20.900000, 2233.000000, 101.100000);
			}
	}

	return 1;
}

stock AbortCombatMission(playerid, bool: success)
{
	gCombatMission[playerid][Active] = false;
	gCombatMission[playerid][TimeElapsed] = 0;
	gCombatMission[playerid][BriefcaseCount] = 0;

	for (new i = 0; i < MAX_COMBAT_PICKUPS; i++)
	{
		DestroyPickup(gCombatPickups[i][Pickup]);
	}

	for (new i = 0; i < MAX_COMBAT_NPCS; i++)
	{
		NPC_Destroy(gCombatNPC[i]);
	}

	DisablePlayerRaceCheckpoint(playerid);

	KillTimer(_: gCombatMission[playerid][TimerUpdate]);
	KillTimer(_: gCombatMission[playerid][TimerBriefcaseMan]);

	TextDrawHideForPlayer(playerid, gCombatMission[playerid][InfoText]);

	if (success)
	{
		GameTextForPlayer(playerid, "~w~Combat Mission ~g~Done", 3000, 3); 
	}
	else
	{
		GameTextForPlayer(playerid, "~w~Combat Mission ~r~Aborted", 3000, 3); 
	}

	if (!gCombatMission[playerid][Dead])
	{
		SetPlayerInterior(playerid, 0);
		SpawnPlayer(playerid);
	}

	gCombatMission[playerid][Dead] = false;

	return 1;
}
