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

public RecreateRampageNPC(playerid, missionid, npcindex)
{
    NPC_Destroy(gRampageNPCs[missionid][npcindex][ID]);

    if (!SetRampageNPC(playerid, missionid, npcindex))
        return 1;

    new
        npcid = gRampageNPCs[missionid][npcindex][ID];

    NPC_SetPos(npcid,
        gRampageNPCs[missionid][npcindex][Primary][CoordX],
        gRampageNPCs[missionid][npcindex][Primary][CoordY],
        gRampageNPCs[missionid][npcindex][Primary][CoordZ]);

    NPC_SetHealth(npcid, 50.0);
    NPC_SetInvulnerable(npcid, false);
    NPC_SetSkin(npcid, random(300));
    NPC_SetWeapon(npcid, WEAPON: (random(13) + 22));
    NPC_SetAmmo(npcid, 500);
    NPC_EnableInfiniteAmmo(npcid, true);
    NPC_SetWeaponAccuracy(npcid, WEAPON: NPC_GetWeapon(npcid), 0.15);

    NPC_Move(npcid, 
        gRampageNPCs[missionid][npcindex][Secondary][CoordX],
        gRampageNPCs[missionid][npcindex][Secondary][CoordY],
        gRampageNPCs[missionid][npcindex][Secondary][CoordZ], 
        NPC_MOVE_TYPE_JOG, NPC_MOVE_SPEED_JOG, 0.05);

    const NPC_COUNT = 128;

    new
        targetid = playerid,
        npcs[NPC_COUNT];

    NPC_GetAll(npcs, sizeof(npcs));

    for (new j = 0; j < NPC_COUNT; j++)
    {
        if (NPC_IsValid(npcs[j]) && npcs[j] != npcid)
        {
            targetid = npcs[j];
            break;
        }
    }

    new 
        Float: tX, 
        Float: tY, 
        Float: tZ;

    GetPlayerPos(targetid, tX, tY, tZ);

    NPC_AimAtPlayer(npcid, targetid, true, 500, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NPC_ENTITY_CHECK_ALL);
    NPC_Shoot(npcid, WEAPON: NPC_GetWeapon(npcid), targetid, true, tX, tY, tZ, 0.0, 0.0, 0.0, true, NPC_ENTITY_CHECK_ALL);

    // Redirect all other surviving mission NPCs back to the player
    new Float: pX, Float: pY, Float: pZ;
    GetPlayerPos(playerid, pX, pY, pZ);

    for (new k = 0; k < MAX_RAMPAGE_NPC_COUNT; k++)
    {
        if (k == npcindex)
            continue;

        new otherid = gRampageNPCs[missionid][k][ID];

        if (!NPC_IsValid(otherid))
            continue;

        NPC_AimAtPlayer(otherid, playerid, true, 500, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NPC_ENTITY_CHECK_PLAYER);
        NPC_Shoot(otherid, WEAPON: NPC_GetWeapon(otherid), playerid, true, pX, pY, pZ, 0.0, 0.0, 0.0, true, NPC_ENTITY_CHECK_ALL);
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
                            gRampageMission[playerid][ID] = gRampagePickups[i][j][MissionID];
                            SetRampageMission(playerid);

                            SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Rampage started!");
                        }
                    case RMPT_HEALTH:
                        {
                            SetPlayerHealth(playerid, 100.0);
                            SetPlayerArmour(playerid, 100.0);

                            SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Health 100.0 + armour 100.0!");

                            DestroyPickup(gRampagePickups[i][j][PickupID]);
                        }
                    case RMPT_WEAPON:
                        {
                            new
                                weaponid = gRampagePickups[i][j][WeaponID];

                            GivePlayerWeapon(playerid, WEAPON: weaponid, 500);
                            SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RAMPAGE ] Weapon picked!");

                            DestroyPickup(gRampagePickups[i][j][PickupID]);
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

stock InitRampagePickups()
{
    new 
		query[256] = "SELECT r.id, r.name, c.primary_x, c.primary_y, c.primary_z FROM rampages AS r JOIN rampage_coords AS c ON c.rampage_id = r.id WHERE c.type = 1",	
        i = 0,	
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        
    if (!result)
	{
		printf("Database error: cannot list rampage pickups");
		print(query);

		return 0;
	}

    if (!DB_GetRowCount(result))
    {
        return 1;
    }

    do
    {
        if (i >= MAX_RAMPAGE_MISSION_COUNT)
        {
            break;
        }

        new
            id = DB_GetFieldIntByName(result, "id"),
            name[64],
            Float: X = DB_GetFieldFloatByName(result, "primary_x"),
            Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
            Float: Z = DB_GetFieldFloatByName(result, "primary_z");

        DB_GetFieldStringByName(result, "name", name, sizeof(name));

        if (gRampagePickups[id][0][PickupID] > -1)
        {
            DestroyPickup(gRampagePickups[id][0][PickupID]);
            Delete3DTextLabel(gRampagePickups[id][0][Text3D]);
        }

        gRampagePickups[id][0][MissionID] = id;
        gRampagePickups[id][0][PickupType] = RMPT_START;
        gRampagePickups[id][0][PickupID] = EnsurePickupCreated(PICKUP_RAMPAGE, 1, X, Y, Z);
        gRampagePickups[id][0][Text3D] = Create3DTextLabel("%s", COLOR_ORANGE, X, Y, Z, 15.0, -1, false, name);

        i++;
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

    for (new i = 0; i < MAX_RAMPAGE_MISSION_COUNT; i++)
    {
        for (new j = 0; j < MAX_RAMPAGE_NPC_COUNT; j++)
        {
            NPC_Destroy(gRampageNPCs[i][j][ID]);
        }

        for (new k = 0; k < MAX_RAMPAGE_WEAPON_COUNT; k++)
        {
            DestroyPickup(gRampagePickups[i][k][PickupID]);
        }
    }

    KillTimer(gRampageMission[playerid][TimerElapsed]);

    gRampageMission[playerid][KilledCount] = 0;

    gPlayers[playerid][InMinigame] = false;
    gRampageMission[playerid][Active] = false;

    TextDrawHideForPlayer(playerid, gRampageMission[playerid][InfoText]);

    GameTextForPlayer(playerid, gI18nMessages[I18N_RAMPAGE_MISS_ABORT][ gPlayers[playerid][Locale] ], 3000, 3); 

    SetTimerEx("SpawnPlayerDelayed", 250, false, "i", playerid);
    return 1;
}

stock SetRampageMission(playerid)
{
    if (gRampageMission[playerid][Active])
    {
        return 1;
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

            if (!weaponid)
            {
                weaponid = random(13) + 22;
            }

            gRampagePickups[id][pickupcount][MissionID] = id;
            gRampagePickups[id][pickupcount][PickupType] = RMPT_WEAPON;
            gRampagePickups[id][pickupcount][WeaponID] = weaponid;
            gRampagePickups[id][pickupcount][PickupID] = EnsurePickupCreated(324 + weaponid, 1, X, Y, Z);            

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
                NPC_SetWeapon(npcid, WEAPON: (random(13) + 22));
                NPC_SetAmmo(npcid, 500);
                NPC_SetSkin(npcid, random(300));
                NPC_EnableInfiniteAmmo(npcid, true);
                NPC_SetWeaponAccuracy(npcid, WEAPON: NPC_GetWeapon(npcid), 0.15);
                NPC_SetHealth(npcid, 50.0);
                NPC_SetInvulnerable(npcid, false); 

                NPC_Move(npcid, sX, sY, sZ, NPC_MOVE_TYPE_JOG, NPC_MOVE_SPEED_JOG, 0.05);

                const NPC_COUNT = 128;

                new
                    targetid = playerid,
                    npcs[NPC_COUNT];

                NPC_GetAll(npcs, sizeof(npcs));
                
                for (new j = 0; j < NPC_COUNT; j++)
                {
                    if (NPC_IsValid(npcs[j]))
                    {
                        targetid = npcs[j];
                        break;
                    }
                }

                new
                    Float: tX,
                    Float: tY,
                    Float: tZ;                   

                switch (random(1))
                {
                    case 0:
                        {
                            GetPlayerPos(targetid, tX, tY, tZ);
                            NPC_AimAtPlayer(npcid, targetid, true, 500, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NPC_ENTITY_CHECK_PLAYER);
                            NPC_Shoot(npcid, WEAPON: NPC_GetWeapon(npcid), targetid, true, tX, tY, tZ, 0.0, 0.0, 0.0, true, NPC_ENTITY_CHECK_ALL);
                        }
                    case 1:
                        {
                            GetPlayerPos(playerid, tX, tY, tZ);
                            NPC_AimAtPlayer(npcid, playerid, true, 500, true, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NPC_ENTITY_CHECK_PLAYER);
                            NPC_Shoot(npcid, WEAPON: NPC_GetWeapon(npcid), playerid, true, tX, tY, tZ, 0.0, 0.0, 0.0, true, NPC_ENTITY_CHECK_ALL);
                        }
                }

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
	    //return SendClientMessageLocalized(playerid, I18N_TAXI_MISS_TOO_MANY_CUSTOMERS);
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

stock SaveRampageMission(playerid)
{
    new
        missionid = gRampageEdit[playerid][MissionID],
        query[512];

    format(query, sizeof(query), "INSERT INTO rampages (name, location_type) VALUES ('%s', %d)",
            gRampageEdit[playerid][MissionName],
            _: gRampageEdit[playerid][Location]
        );

    new
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

    if (!result)
    {
		print("Database error: cannot write rampage data!");
		print(query);
		return 0;
	}
    
    DB_FreeResultSet(result);

    // Pickup

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
		print("Database error: cannot write rampage pickup data!");
		print(query);
		return 0;
	}
    
    DB_FreeResultSet(result);

    for (new i = 0; i < MAX_RAMPAGE_MISSION_COUNT; i++)
    {
        // Save all health points
        if (gRampageHealthPoints[missionid][i][Set])
        {
            format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z) VALUES (%d, %d, %.2f, %.2f, %.2f)",
                    missionid,
                    5,
                    gRampageHealthPoints[missionid][i][Position][CoordX],
                    gRampageHealthPoints[missionid][i][Position][CoordY],
                    gRampageHealthPoints[missionid][i][Position][CoordZ]
                );

            result = DB_ExecuteQuery(gDbConnectionHandle, query);

            if (!result)
            {
                print("Database error: cannot write rampage health point data!");
                print(query);
                return 0;
    	    }   

            DB_FreeResultSet(result); 
        }

        if (gRampageWeapons[missionid][i][Set])
        {
            format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z) VALUES (%d, %d, %.2f, %.2f, %.2f)",
                    missionid,
                    4,
                    gRampageWeapons[missionid][i][Position][CoordX],
                    gRampageWeapons[missionid][i][Position][CoordY],
                    gRampageWeapons[missionid][i][Position][CoordZ]
                );

            result = DB_ExecuteQuery(gDbConnectionHandle, query);

            if (!result)
            {
                print("Database error: cannot write rampage weapon data!");
                print(query);
                return 0;
    	    }   

            DB_FreeResultSet(result); 
        }

        if (gRampageNPCs[missionid][i][Set])
        {
            format(query, sizeof(query), "INSERT INTO rampage_coords (rampage_id, type, primary_x, primary_y, primary_z, secondary_x, secondary_y, secondary_z) VALUES (%d, %d, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f)",
                    missionid,
                    2,
                    gRampageNPCs[missionid][i][Primary][CoordX],
                    gRampageNPCs[missionid][i][Primary][CoordY],
                    gRampageNPCs[missionid][i][Primary][CoordZ],
                    gRampageNPCs[missionid][i][Secondary][CoordX],
                    gRampageNPCs[missionid][i][Secondary][CoordY],
                    gRampageNPCs[missionid][i][Secondary][CoordZ]
                );

            result = DB_ExecuteQuery(gDbConnectionHandle, query);

            if (!result)
            {
                print("Database error: cannot write rampage weapon data!");
                print(query);
                return 0;
    	    }   

            DB_FreeResultSet(result); 
        }
    }

    InitRampagePickups();

    gPlayers[playerid][EditingMode] = false;
    gRampageMission[playerid][Active] = false;

    return 1;
}