#if defined _CRL2_RAMPAGE
	#endinput
#endif
#define _CRL2_RAMPAGE

//
//  rampage.pwn
//

#define MAX_RAMPAGE_MISSION_COUNT           16
#define MAX_RAMPAGE_NPC_COUNT               16
#define MAX_RAMPAGE_WEAPON_COUNT            16
#define MAX_RAMPAGE_HEALTH_POINTS_COUNT     16

#define RAMPAGE_NPC_HEALTH                  50.0
#define RAMPAGE_NPC_AMMO                    500
#define RAMPAGE_NPC_ACCURACY                0.15
#define RAMPAGE_NPC_SHOOT_DELAY             500
// Recreate delay for a mission NPC killed by its own player vs. anyone else.
#define RAMPAGE_RECREATE_DELAY_OWNER_KILL   60000
#define RAMPAGE_RECREATE_DELAY_CROSSFIRE    250

enum RMType
{
    RM_NONE,
    RM_LV,
    RM_SF,
    RM_LS
}

enum RMEditType
{
    RMET_NONE,
    RMET_PICKUP_COORDS,
    RMET_NPC_COORDS_PRIMARY,
    RMET_NPC_COORDS_SECONDARY,
    RMET_WEAPON_COORDS,
    RMET_HEALTH_COORDS
}

enum RMPickupType
{
    RMPT_NONE,
    RMPT_START,
    RMPT_WEAPON,
    RMPT_HEALTH
}

enum RampageNPC
{
    ID,
    Primary[Coords],
    Secondary[Coords],
    WeaponID,
    Ammo,

    bool: Spawned,
    bool: Killed,
    bool: Set
}

enum RampageEditor
{
    bool: Active,
    RMEditType: EditType,

    MissionID,
    MissionName[64],

    NPCCount,
    WeaponNo,
    HealthNo,

    RMType: Location,

    PickupCoords[Coords]
}

enum RampageMission
{
    ID,
    bool: Active,
    RMType: Type,

    Text: InfoText,

    KilledCount,
    TimeElapsed,

    TimerElapsed
}

enum RampagePickup
{
    PickupID,
    MissionID,
    WeaponID,
    RMPickupType: PickupType,
    Text3D: Text3D
}

enum RampageWeapon
{
    WeaponID,
    Ammo,
    Position[Coords],

    bool: Set
}

enum HealthPoint
{
    Position[Coords],

    bool: Set
}

new
    gRampageHealthPoints[MAX_RAMPAGE_MISSION_COUNT][MAX_RAMPAGE_HEALTH_POINTS_COUNT][HealthPoint],
    gRampageWeapons[MAX_RAMPAGE_MISSION_COUNT][MAX_RAMPAGE_WEAPON_COUNT][RampageWeapon],
    gRampagePickups[MAX_RAMPAGE_MISSION_COUNT][3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT][RampagePickup],
    gRampageNPCs[MAX_RAMPAGE_MISSION_COUNT][MAX_RAMPAGE_NPC_COUNT][RampageNPC],
    gRampageEdit[MAX_PLAYERS][RampageEditor],
    gRampageMission[MAX_PLAYERS][RampageMission],
    gRampageNPCSeq = 0;

//  
//  Rampage NPCs are spawned randomly up to 8 (out of 16 max) per rampage mission. 
//  NPCs are equipped with random weapons or with weapons defined in the database (picked in Rampage Editor).
//

forward UpdateRampageMissionInfoText(playerid);
forward RecreateRampageNPC(playerid, missionid, npcindex);
forward bool: IsValidRampageWeapon(weaponid);
forward bool: IsRampageMissionRunning(missionid);

public UpdateRampageMissionInfoText(playerid)
{
    new 
        stringToPrint[256];

    gRampageMission[playerid][TimeElapsed] -= 1000;

    if (gRampageMission[playerid][TimeElapsed] <= 0)
    {
        return AbortRampageMission(playerid);
    }

    GetLocalizedString(playerid, I18N_RAMPAGE_MISS_INFO, stringToPrint, sizeof(stringToPrint));
    format(stringToPrint, sizeof(stringToPrint), stringToPrint,
            gRampageMission[playerid][KilledCount], 
            floatround(floatround(gRampageMission[playerid][TimeElapsed] / 1000) / 60), 
            floatround(gRampageMission[playerid][TimeElapsed] / 1000) % 60
        );

    TextDrawSetString(gRampageMission[playerid][InfoText], stringToPrint);
    TextDrawShowForPlayer(playerid, gRampageMission[playerid][InfoText]);

    return 1;
}

// Gives a mission NPC its health, skin, a random weapon and, in the same
// breath, the accuracy for that weapon. Accuracy is stored per weapon, so a
// weapon change that does not go through here leaves the NPC on the
// component's default (full) accuracy.
stock ArmRampageNPC(npcid)
{
    NPC_SetHealth(npcid, RAMPAGE_NPC_HEALTH);
    NPC_SetInvulnerable(npcid, false);
    NPC_SetSkin(npcid, random(300));
    NPC_SetWeapon(npcid, WEAPON: (random(13) + 22));
    NPC_SetAmmo(npcid, RAMPAGE_NPC_AMMO);
    NPC_EnableInfiniteAmmo(npcid, true);
    NPC_SetWeaponAccuracy(npcid, NPC_GetWeapon(npcid), RAMPAGE_NPC_ACCURACY);

    return 1;
}

// Finds the active mission that owns `npcid`. Returns the owning player's id
// and fills missionid/npcindex, or INVALID_PLAYER_ID when none does.
stock FindRampageNPC(npcid, &missionid, &npcindex)
{
    if (npcid == INVALID_NPC_ID)
    {
        return INVALID_PLAYER_ID;
    }

    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (!gRampageMission[playerid][Active])
        {
            continue;
        }

        new
            mission = gRampageMission[playerid][ID];

        for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
        {
            if (gRampageNPCs[mission][i][ID] == npcid)
            {
                missionid = mission;
                npcindex = i;
                return playerid;
            }
        }
    }

    return INVALID_PLAYER_ID;
}

// Picks who a mission NPC shoots at: a random other live NPC of the same
// mission, or the player when there is none. NPCs outside the mission
// (drivers, customers) are never targets.
stock GetRampageNPCTarget(playerid, missionid, selfid)
{
    new
        candidates[MAX_RAMPAGE_NPC_COUNT],
        count = 0;

    for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
    {
        new
            otherid = gRampageNPCs[missionid][i][ID];

        if (otherid == INVALID_NPC_ID || otherid == selfid || !NPC_IsValid(otherid) || NPC_IsDead(otherid))
        {
            continue;
        }

        candidates[count++] = otherid;
    }

    if (!count)
    {
        return playerid;
    }

    return candidates[random(count)];
}

// Points a mission NPC at a target and lets its aim loop fire at the
// configured accuracy. Deliberately no scripted NPC_Shoot(): with
// isHit = true that is a guaranteed hit that bypasses accuracy entirely.
stock RampageNPCEngage(npcid, targetid)
{
    NPC_AimAtPlayer(npcid, targetid, true, RAMPAGE_NPC_SHOOT_DELAY, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NPC_ENTITY_CHECK_PLAYER);

    return 1;
}

public RecreateRampageNPC(playerid, missionid, npcindex)
{
    new
        oldid = gRampageNPCs[missionid][npcindex][ID];

    if (oldid != INVALID_NPC_ID && NPC_IsValid(oldid))
    {
        NPC_Destroy(oldid);
    }

    gRampageNPCs[missionid][npcindex][ID] = INVALID_NPC_ID;

    if (!gRampageMission[playerid][Active])
    {
        return 1;
    }

    if (!SetRampageNPC(playerid, missionid, npcindex))
    {
        return 1;
    }

    new
        npcid = gRampageNPCs[missionid][npcindex][ID];

    NPC_SetPos(npcid,
        gRampageNPCs[missionid][npcindex][Primary][CoordX],
        gRampageNPCs[missionid][npcindex][Primary][CoordY],
        gRampageNPCs[missionid][npcindex][Primary][CoordZ]);

    ArmRampageNPC(npcid);

    NPC_Move(npcid, 
        gRampageNPCs[missionid][npcindex][Secondary][CoordX],
        gRampageNPCs[missionid][npcindex][Secondary][CoordY],
        gRampageNPCs[missionid][npcindex][Secondary][CoordZ], 
        NPC_MOVE_TYPE_JOG, NPC_MOVE_SPEED_JOG, 0.05);

    RampageNPCEngage(npcid, GetRampageNPCTarget(playerid, missionid, npcid));

    // Point the other surviving mission NPCs back at the player.
    for (new k = 0; k < MAX_RAMPAGE_NPC_COUNT; k++)
    {
        if (k == npcindex)
        {
            continue;
        }

        new
            otherid = gRampageNPCs[missionid][k][ID];

        if (otherid == INVALID_NPC_ID || !NPC_IsValid(otherid))
        {
            continue;
        }

        RampageNPCEngage(otherid, playerid);
    }

    return 1;
}


stock bool: CheckRampagePickup(playerid, pickupid)
{
    for (new i = 0; i < MAX_RAMPAGE_MISSION_COUNT; i++)
    {
        for (new j = 0; j < 3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT; j++)
        {
            if (gRampagePickups[i][j][PickupID] == pickupid)
            {
                switch (gRampagePickups[i][j][PickupType])
                {
                    case RMPT_START:
                        {
                            new
                                missionid = gRampagePickups[i][j][MissionID];

                            // Already on a rampage (or in another minigame):
                            // this start pickup is scenery. Taking its id would
                            // switch the running rampage over, and its abort
                            // would then tear down the wrong gunmen.
                            if (gRampageMission[playerid][Active] || gPlayers[playerid][InMinigame])
                            {
                                return true;
                            }

                            // One run per rampage at a time, see SetRampageMission()
                            if (IsRampageMissionRunning(missionid))
                            {
                                SendClientMessageLocalized(playerid, I18N_RAMPAGE_MISS_TAKEN);
                                return true;
                            }

                            gRampageMission[playerid][ID] = missionid;
                            SetRampageMission(playerid);

                            if (gRampageMission[playerid][Active])
                            {
                                SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Rampage started!");
                            }
                        }
                    case RMPT_HEALTH:
                        {
                            SetPlayerHealth(playerid, 100.0);
                            SetPlayerArmour(playerid, 100.0);

                            SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Health 100.0 + armour 100.0!");

                            // Forget the id too: the server hands it to the
                            // next pickup made, which would then count as this
                            // one, and the abort would destroy it
                            DestroyPickup(gRampagePickups[i][j][PickupID]);
                            gRampagePickups[i][j][PickupID] = INVALID_PICKUP;
                        }
                    case RMPT_WEAPON:
                        {
                            new
                                weaponid = gRampagePickups[i][j][WeaponID];

                            GivePlayerWeapon(playerid, WEAPON: weaponid, 500);
                            SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Weapon picked!");

                            DestroyPickup(gRampagePickups[i][j][PickupID]);
                            gRampagePickups[i][j][PickupID] = INVALID_PICKUP;
                        }
                    default:
                        {}
                }

                return true;
            }
        }
    }

    return false;
}

// Slots start out (and NPC slots are reset to) their INVALID_* sentinels.
// Zeroed slots are not "empty": 0 is a real NPC id, a real pickup id and a
// real label id, so a zeroed slot would match or destroy somebody else's.
stock InitRampageSlots()
{
    for (new m = 0; m < MAX_RAMPAGE_MISSION_COUNT; m++)
    {
        for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
        {
            gRampageNPCs[m][i][ID] = INVALID_NPC_ID;
        }

        for (new k = 0; k < 3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT; k++)
        {
            gRampagePickups[m][k][PickupID] = INVALID_PICKUP;
            gRampagePickups[m][k][Text3D] = INVALID_3DTEXT_ID;
        }
    }

    return 1;
}

// Creates the start pickup and name label of every saved rampage. Runs at
// startup and again after each save, replacing what it created last time.
stock InitRampagePickups()
{
    new 
        query[256] = "SELECT r.id, r.name, c.primary_x, c.primary_y, c.primary_z FROM rampages AS r JOIN rampage_coords AS c ON c.rampage_id = r.id WHERE c.type = 1",
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        print("Database error: cannot list rampage pickups");
        print(query);

        return 0;
    }

    if (!DB_GetRowCount(result))
    {
        DB_FreeResultSet(result);

        return 1;
    }

    do
    {
        new
            id = DB_GetFieldIntByName(result, "id"),
            name[64],
            Float: X = DB_GetFieldFloatByName(result, "primary_x"),
            Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
            Float: Z = DB_GetFieldFloatByName(result, "primary_z");

        if (id < 0 || id >= MAX_RAMPAGE_MISSION_COUNT)
        {
            printf("Rampage %d skipped: id is beyond MAX_RAMPAGE_MISSION_COUNT (%d)", id, MAX_RAMPAGE_MISSION_COUNT);
        }
        else
        {
            DB_GetFieldStringByName(result, "name", name, sizeof(name));

            if (gRampagePickups[id][0][PickupID] != INVALID_PICKUP)
            {
                DestroyPickup(gRampagePickups[id][0][PickupID]);
            }

            if (gRampagePickups[id][0][Text3D] != INVALID_3DTEXT_ID)
            {
                Delete3DTextLabel(gRampagePickups[id][0][Text3D]);
            }

            gRampagePickups[id][0][MissionID] = id;
            gRampagePickups[id][0][PickupType] = RMPT_START;
            gRampagePickups[id][0][PickupID] = EnsurePickupCreated(PICKUP_RAMPAGE, 1, X, Y, Z);
            gRampagePickups[id][0][Text3D] = Create3DTextLabel("%s", COLOR_ORANGE, X, Y, Z, 15.0, -1, false, name);
        }
    }
    while (DB_SelectNextRow(result));

    DB_FreeResultSet(result);

    return 1;
}

stock AbortRampageMission(playerid)
{
    if (!gRampageMission[playerid][Active])
    {
        return 1;
    }

    if (gRampageMission[playerid][KilledCount])
    {
        FireQuestEvent(playerid, QUEST_EVT_RAMPAGE_DONE);
        SaveRampageMissionScore(playerid);
    }
    
    new
        missionid = gRampageMission[playerid][ID];

    for (new j = 0; j < MAX_RAMPAGE_NPC_COUNT; j++)
    {
        if (NPC_IsValid(gRampageNPCs[missionid][j][ID]))
        {
            NPC_Destroy(gRampageNPCs[missionid][j][ID]);
        }

        gRampageNPCs[missionid][j][ID] = INVALID_NPC_ID;
        gRampageNPCs[missionid][j][Set] = false;
    }

    // Every slot a run can fill: weapons and then health points, from 1 on
    for (new k = 0; k < 3 * MAX_RAMPAGE_HEALTH_POINTS_COUNT; k++)
    {
        if (gRampagePickups[missionid][k][PickupType] == RMPT_START || gRampagePickups[missionid][k][PickupID] == INVALID_PICKUP)
        {
            continue;
        }

        DestroyPickup(gRampagePickups[missionid][k][PickupID]);
        gRampagePickups[missionid][k][PickupID] = INVALID_PICKUP;
    }

    KillTimer(gRampageMission[playerid][TimerElapsed]);

    gRampageMission[playerid][KilledCount] = 0;

    gPlayers[playerid][InMinigame] = false;
    gRampageMission[playerid][Active] = false;    

    TextDrawHideForPlayer(playerid, gRampageMission[playerid][InfoText]);

    GameTextForPlayer(playerid, gI18nMessages[I18N_RAMPAGE_MISS_ABORT][ gPlayers[playerid][Locale] ], 3000, 3); 

    if (IsPlayerAlive(playerid))
    {
        SetTimerEx("SpawnPlayerDelayed", 250, false, "i", playerid);
    }

    return 1;
}

stock SetRampageMission(playerid)
{
    if (gRampageMission[playerid][Active])
    {
        return 1;
    }

    if (gPlayers[playerid][InMinigame])
    {
        return 1;
    }

    // The gunmen and pickups are one set per rampage, so a second run of one
    // under way would overwrite the first run's and leave them behind
    if (IsRampageMissionRunning(gRampageMission[playerid][ID]))
    {
        return 0;
    }

    new
        pickupcount = 1,
        missionid = gRampageMission[playerid][ID],
        query[256];

    // Create and spawn weapons
    format(query, sizeof(query), "SELECT * FROM rampage_coords WHERE type = 4 AND rampage_id = %d", missionid);

    new
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        print("Database error: unable to fetch rampage_coords for weapons!");
        print(query);
        return 0;
    }

    if (DB_GetRowCount(result))
    {
        do
        {
            new
                id = DB_GetFieldIntByName(result, "rampage_id"),
                weaponid = DB_GetFieldIntByName(result, "weapon_id"),
                Float: X = DB_GetFieldFloatByName(result, "primary_x"),
                Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
                Float: Z = DB_GetFieldFloatByName(result, "primary_z");

            if (!IsValidRampageWeapon(weaponid))
            {
                weaponid = random(13) + 22;
            }

            gRampagePickups[id][pickupcount][MissionID] = id;
            gRampagePickups[id][pickupcount][PickupType] = RMPT_WEAPON;
            gRampagePickups[id][pickupcount][WeaponID] = weaponid;
            gRampagePickups[id][pickupcount][PickupID] = EnsurePickupCreated(GetWeaponModel(weaponid), 1, X, Y, Z);            

            pickupcount++;
        }
        while (DB_SelectNextRow(result));
    }

    DB_FreeResultSet(result);

    // Create and spawn health points
    format(query, sizeof(query), "SELECT * FROM rampage_coords WHERE type = 5 AND rampage_id = %d", missionid);

    result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        print("Database error: unable to fetch rampage_coords for health points!");
        print(query);
        return 0;
    }

    if (DB_GetRowCount(result))
    {
        do
        {
            new
                id = DB_GetFieldIntByName(result, "rampage_id"),
                Float: X = DB_GetFieldFloatByName(result, "primary_x"),
                Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
                Float: Z = DB_GetFieldFloatByName(result, "primary_z");

            gRampagePickups[id][pickupcount][MissionID] = id;
            gRampagePickups[id][pickupcount][PickupType] = RMPT_HEALTH;
            gRampagePickups[id][pickupcount][PickupID] = EnsurePickupCreated(PICKUP_HEART, 1, X, Y, Z);
            
            pickupcount++;
        }
        while (DB_SelectNextRow(result));
    }

    DB_FreeResultSet(result);

    // Create and spawn NPCs
    format(query, sizeof(query), "SELECT * FROM rampage_coords WHERE type = 2 AND rampage_id = %d", missionid);

    result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        print("Database error: unable to fetch rampage_coords for NPCs!");
        print(query);
        return 0;
    }

    if (DB_GetRowCount(result))
    {
        new
            i = 0;

        do
        {
            new
                Float: pX = DB_GetFieldFloatByName(result, "primary_x"),
                Float: pY = DB_GetFieldFloatByName(result, "primary_y"),
                Float: pZ = DB_GetFieldFloatByName(result, "primary_z"),             
                Float: sX = DB_GetFieldFloatByName(result, "secondary_x"),
                Float: sY = DB_GetFieldFloatByName(result, "secondary_y"),
                Float: sZ = DB_GetFieldFloatByName(result, "secondary_z");

            if (SetRampageNPC(playerid, missionid, i))
            {
                new
                    npcid = gRampageNPCs[missionid][i][ID];

                gRampageNPCs[missionid][i][Primary][CoordX] = pX;
                gRampageNPCs[missionid][i][Primary][CoordY] = pY;
                gRampageNPCs[missionid][i][Primary][CoordZ] = pZ;
            
                gRampageNPCs[missionid][i][Secondary][CoordX] = sX;
                gRampageNPCs[missionid][i][Secondary][CoordY] = sY;
                gRampageNPCs[missionid][i][Secondary][CoordZ] = sZ;

                NPC_SetPos(npcid, pX, pY, pZ);

                ArmRampageNPC(npcid);

                NPC_Move(npcid, sX, sY, sZ, NPC_MOVE_TYPE_JOG, NPC_MOVE_SPEED_JOG, 0.05);

                // Half open on the player, the rest on a mission mate spawned
                // before them (the player while there is none yet).
                RampageNPCEngage(npcid, random(2) ? playerid : GetRampageNPCTarget(playerid, missionid, npcid));

                i++;
            }
        }
        while (DB_SelectNextRow(result));
    }

    DB_FreeResultSet(result);

    gPlayers[playerid][InMinigame] = true;

    gRampageMission[playerid][Active] = true;
    gRampageMission[playerid][KilledCount] = 0;
    gRampageMission[playerid][TimeElapsed] = 300000;

    gRampageMission[playerid][TimerElapsed] = SetTimerEx("UpdateRampageMissionInfoText", 1000, true, "i", playerid);

    //SendClientMessage(playerid, COLOR_ORANGE, "[ RAMPAGE ] Rampage mission started!");

    return 1;
}

stock SetRampageNPC(playerid, missionid, npcarrayid)
{
#pragma unused playerid
    const NPC_COUNT = 128;

    new
        npcs[NPC_COUNT];

    NPC_GetAll(npcs, sizeof(npcs));

    new preid = -1;
    for (new i = 0; i < NPC_COUNT; i++)
    {
        if (!NPC_IsValid(npcs[i]))
		{
			preid = i;
			break;
		}
	}

    if (preid == -1)
    {
        return 0;
    }

    new
        npc_name[MAX_PLAYER_NAME];
    format(npc_name, sizeof(npc_name), "[NPC]rmg%d", gRampageNPCSeq++);

    new 
        npcid = NPC_Create(npc_name);

    if (npcid == INVALID_NPC_ID)
    {
        print(npc_name);
        //return SendClientMessageLocalized(playerid, I18N_TAXI_MISS_TOO_MANY_CUSTOMERS);
        return 0;
    }

    NPC_Spawn(npcid);

    gRampageNPCs[missionid][npcarrayid][ID] = npcid;

    return 1;
}

stock SaveRampageMissionScore(playerid)
{
	if (!gRampageMission[playerid][KilledCount])
	{
		return 1;
	}

	new
		query[256];
	format(query, sizeof(query), "INSERT INTO high_scores (type, spec_id, value, user_id, time) VALUES (%d, '%d', %d, %d, %d)",
			7,
			gRampageMission[playerid][ID],
			gRampageMission[playerid][KilledCount],
			gPlayers[playerid][OrmID],
            gRampageMission[playerid][TimeElapsed]
	      );

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write high scores data for rampage");
		print(query);
		return 0;
	}

	DB_FreeResultSet(result);

	return 1;
}

// Rampage weapon pickups accept any real weapon id; 0 means "random gun on
// every run" and is what an empty or invalid editor input becomes.
stock bool: IsValidRampageWeapon(weaponid)
{
    return (weaponid >= 1 && weaponid <= 46 && (weaponid < 19 || weaponid > 21));
}

stock bool: IsRampageMissionRunning(missionid)
{
    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (gRampageMission[playerid][Active] && gRampageMission[playerid][ID] == missionid)
        {
            return true;
        }
    }

    return false;
}

// Wipes a player's editor session: their cached fields plus every slot
// recorded under the prospective mission id, which is how an abandoned
// session used to leak into the next one. The shared slots are skipped if a
// live run happens to use that id.
stock ResetRampageEditor(playerid)
{
    new
        missionid = gRampageEdit[playerid][MissionID];

    if (missionid >= 0 && missionid < MAX_RAMPAGE_MISSION_COUNT && !IsRampageMissionRunning(missionid))
    {
        for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
        {
            gRampageNPCs[missionid][i][Set] = false;
        }

        for (new i = 0; i < MAX_RAMPAGE_WEAPON_COUNT; i++)
        {
            gRampageWeapons[missionid][i][Set] = false;
            gRampageWeapons[missionid][i][WeaponID] = 0;
        }

        for (new i = 0; i < MAX_RAMPAGE_HEALTH_POINTS_COUNT; i++)
        {
            gRampageHealthPoints[missionid][i][Set] = false;
        }
    }

    gRampageEdit[playerid][Active] = false;
    gRampageEdit[playerid][EditType] = RMET_NONE;
    gRampageEdit[playerid][MissionID] = 0;
    gRampageEdit[playerid][MissionName][0] = EOS;
    gRampageEdit[playerid][NPCCount] = 0;
    gRampageEdit[playerid][WeaponNo] = 0;
    gRampageEdit[playerid][HealthNo] = 0;
    gRampageEdit[playerid][Location] = RM_NONE;
    gRampageEdit[playerid][PickupCoords][CoordX] = 0.0;
    gRampageEdit[playerid][PickupCoords][CoordY] = 0.0;
    gRampageEdit[playerid][PickupCoords][CoordZ] = 0.0;

    return 1;
}


// Logs the failed step, tells the editing player, and returns 0 so the
// caller can bail out with it.
stock RampageSaveFailed(playerid, const what[], const query[])
{
    printf("Database error: cannot write rampage %s!", what);
    print(query);

    new
        stringToPrint[128];

    format(stringToPrint, sizeof(stringToPrint), "[ EDIT ] Saving the rampage failed at the %s, see the server log!", what);
    SendClientMessage(playerid, COLOR_RED, stringToPrint);

    return 0;
}

stock SaveRampageMission(playerid)
{
    // Recordings live under the slot the editor picked; rows are written
    // under the id the database actually hands out (see below).
    new
        slotid = gRampageEdit[playerid][MissionID],
        query[512],
        stringToPrint[144];

    if (!gRampageEdit[playerid][Active] || slotid < 0 || slotid >= MAX_RAMPAGE_MISSION_COUNT)
    {
        SendClientMessage(playerid, COLOR_RED, "[ EDIT ] There is no rampage editor session to save!");
        return 0;
    }

    if (!strlen(gRampageEdit[playerid][MissionName]))
    {
        SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Set the rampage name before saving!");
        return 0;
    }

    if (gRampageEdit[playerid][PickupCoords][CoordX] == 0.0 && gRampageEdit[playerid][PickupCoords][CoordY] == 0.0 && gRampageEdit[playerid][PickupCoords][CoordZ] == 0.0)
    {
        SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Record the rampage start pickup position before saving!");
        return 0;
    }

    // %q: the name is typed in by an admin and may contain an apostrophe
    format(query, sizeof(query), "INSERT INTO rampages (name, location_type) VALUES ('%q', %d)",
            gRampageEdit[playerid][MissionName],
            _: gRampageEdit[playerid][Location]
        );

    new
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        return RampageSaveFailed(playerid, "mission row", query);
    }

    DB_FreeResultSet(result);

    // AUTOINCREMENT never reuses a deleted id, so the id the editor guessed
    // (highest + 1) can be lower than the one just assigned. Coordinates
    // written under the guess would belong to no mission.
    new
        missionid = 0;

    format(query, sizeof(query), "SELECT last_insert_rowid() AS id");
    result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (result)
    {
        if (DB_GetRowCount(result))
        {
            missionid = DB_GetFieldIntByName(result, "id");
        }

        DB_FreeResultSet(result);
    }

    if (missionid <= 0)
    {
        return RampageSaveFailed(playerid, "mission id lookup", query);
    }

    // Start pickup
    format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z) VALUES (%d, %d, %.2f, %.2f, %.2f)",
            missionid,
            1,
            gRampageEdit[playerid][PickupCoords][CoordX],
            gRampageEdit[playerid][PickupCoords][CoordY],
            gRampageEdit[playerid][PickupCoords][CoordZ]
        );

    result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
        return RampageSaveFailed(playerid, "start pickup", query);
    }

    DB_FreeResultSet(result);

    new
        healths = 0,
        weapons = 0,
        npcs = 0;

    for (new i = 0; i < MAX_RAMPAGE_HEALTH_POINTS_COUNT; i++)
    {
        if (!gRampageHealthPoints[slotid][i][Set])
        {
            continue;
        }

        format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z) VALUES (%d, %d, %.2f, %.2f, %.2f)",
                missionid,
                5,
                gRampageHealthPoints[slotid][i][Position][CoordX],
                gRampageHealthPoints[slotid][i][Position][CoordY],
                gRampageHealthPoints[slotid][i][Position][CoordZ]
            );

        result = DB_ExecuteQuery(gDbConnectionHandle, query);

        if (!result)
        {
            return RampageSaveFailed(playerid, "health point", query);
        }

        DB_FreeResultSet(result);
        healths++;
    }

    for (new i = 0; i < MAX_RAMPAGE_WEAPON_COUNT; i++)
    {
        if (!gRampageWeapons[slotid][i][Set])
        {
            continue;
        }

        // weapon_id 0 means "random gun each run" (see SetRampageMission).
        format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, weapon_id, primary_x, primary_y, primary_z) VALUES (%d, %d, %d, %.2f, %.2f, %.2f)",
                missionid,
                4,
                gRampageWeapons[slotid][i][WeaponID],
                gRampageWeapons[slotid][i][Position][CoordX],
                gRampageWeapons[slotid][i][Position][CoordY],
                gRampageWeapons[slotid][i][Position][CoordZ]
            );

        result = DB_ExecuteQuery(gDbConnectionHandle, query);

        if (!result)
        {
            return RampageSaveFailed(playerid, "weapon pickup", query);
        }

        DB_FreeResultSet(result);
        weapons++;
    }

    for (new i = 0; i < MAX_RAMPAGE_NPC_COUNT; i++)
    {
        if (!gRampageNPCs[slotid][i][Set])
        {
            continue;
        }

        format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z, secondary_x, secondary_y, secondary_z) VALUES (%d, %d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f)",
                missionid,
                2,
                gRampageNPCs[slotid][i][Primary][CoordX],
                gRampageNPCs[slotid][i][Primary][CoordY],
                gRampageNPCs[slotid][i][Primary][CoordZ],
                gRampageNPCs[slotid][i][Secondary][CoordX],
                gRampageNPCs[slotid][i][Secondary][CoordY],
                gRampageNPCs[slotid][i][Secondary][CoordZ]
            );

        result = DB_ExecuteQuery(gDbConnectionHandle, query);

        if (!result)
        {
            return RampageSaveFailed(playerid, "NPC", query);
        }

        DB_FreeResultSet(result);
        npcs++;
    }

    format(stringToPrint, sizeof(stringToPrint), "[ EDIT ] Rampage '%s' saved as mission #%d with %d NPC(s), %d weapon(s), %d health pack(s).",
            gRampageEdit[playerid][MissionName], missionid, npcs, weapons, healths);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

    if (missionid >= MAX_RAMPAGE_MISSION_COUNT)
    {
        format(stringToPrint, sizeof(stringToPrint), "[ EDIT ] Mission #%d is beyond MAX_RAMPAGE_MISSION_COUNT (%d) and cannot load until that limit is raised!", missionid, MAX_RAMPAGE_MISSION_COUNT);
        SendClientMessage(playerid, COLOR_RED, stringToPrint);
    }
    else if (InitRampagePickups())
    {
        SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Rampage pickups reloaded, the new mission is live now.");
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Saved, but reloading the rampage pickups failed, see the server log!");
    }

    gPlayers[playerid][EditingMode] = false;
    ResetRampageEditor(playerid);

    return 1;
}
