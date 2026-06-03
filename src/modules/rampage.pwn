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
    RMType: Type
}

enum RampagePickup
{
    PickupID,
    MissionID,
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
    gRampagePickups[MAX_RAMPAGE_MISSION_COUNT][RampagePickup],
    gRampageNPCs[MAX_RAMPAGE_MISSION_COUNT][MAX_RAMPAGE_NPC_COUNT][RampageNPC],
    gRampageEdit[MAX_PLAYERS][RampageEditor],
    gRampageMission[MAX_PLAYERS][RampageMission];

//  
//  Rampage NPCs are spawned randomly up to 8 (out of 16 max) per rampage mission. 
//  NPCs are equipped with random weapons or with weapons defined in the database (picked in Rampage Editor).
//

stock bool: CheckRampagePickup(playerid, pickupid)
{
    for (new i = 0; i < MAX_RAMPAGE_MISSION_COUNT; i++)
    {
        if (gRampagePickups[i][PickupID] == pickupid)
        {
            gRampageMission[playerid][ID] = gRampagePickups[i][MissionID];

            return true;
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

        if (gRampagePickups[i][PickupID] > -1)
        {
            DestroyPickup(gRampagePickups[i][PickupID]);
            Delete3DTextLabel(gRampagePickups[i][Text3D]);
        }

        gRampagePickups[i][MissionID] = id;
        gRampagePickups[i][PickupID] = EnsurePickupCreated(PICKUP_RAMPAGE, 1, X, Y, Z);
        gRampagePickups[i][Text3D] = Create3DTextLabel("%s", COLOR_ORANGE, X, Y, Z, 15.0, -1, false, name);

        i++;
    }
    while (DB_SelectNextRow(result));

    DB_FreeResultSet(result);

    return 1;
}

stock SetRampageMission(playerid)
{
    if (gRampageMission[playerid][Active])
    {
        return 1;
    }

    new
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
                weaponid = DB_GetFieldIntByName(result, "weapon_id"),
                Float: X = DB_GetFieldFloatByName(result, "primary_x"),
                Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
                Float: Z = DB_GetFieldFloatByName(result, "primary_z");

            if (!weaponid)
            {
                weaponid = random(37) + 1;
            }

            // TODO: Assign to some pickup array to check against on pick up
            EnsurePickupCreated(320 + weaponid, 1, X, Y, Z);
            
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
                Float: X = DB_GetFieldFloatByName(result, "primary_x"),
                Float: Y = DB_GetFieldFloatByName(result, "primary_y"),
                Float: Z = DB_GetFieldFloatByName(result, "primary_z");

            // TODO: Assign to some pickup array to check against on pick up
            EnsurePickupCreated(PICKUP_HEART, 1, X, Y, Z);
            
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

                NPC_SetPos(npcid, pX, pY, pZ);
                NPC_SetWeapon(npcid, WEAPON: (random(37) + 1));
                NPC_SetSkin(npcid, random(300));

                NPC_Move(npcid, sX, sY, sZ, NPC_MOVE_TYPE_JOG, NPC_MOVE_SPEED_JOG, 0.05);
            }
                        
        }
        while (DB_SelectNextRow(result));
    }

    DB_FreeResultSet(result);

    gRampageMission[playerid][Active] = true;

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
    format(npc_name, sizeof(npc_name), "[NPC]rampage_npc%d", preid);

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