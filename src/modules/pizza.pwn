#if defined _CRL2_PIZZA
	#endinput
#endif
#define _CRL2_PIZZA

//
//  pizza.pwn
//

#define PIZZA_OBJECT_SLOT       9
#define MAX_PIZZA_NPC_COUNT     50

enum PizzaDeliveryState
{
    PIZZA_DELIVERY_NONE,
    PIZZA_DELIVERY_CARRY,
    PIZZA_DELIVERY_WAIT,
    PIZZA_DELIVERY_HANDOVER,
    PIZZA_DELIVERY_PAYMENT
}

enum PizzaMission
{
    bool: Active,

    NPCid,

    PizzaDeliveryState: DeliveryState,
    Timer: DeliveryTimer,

    Float: DeliveryPos[Coords]
}

new
    gPizzaMission[MAX_PLAYERS][PizzaMission];

stock Pizza_ResetMinigame(playerid)
{
    if (!gPizzaMission[playerid][Active])
    {
        return 1;
    }

    if (gPizzaMission[playerid][DeliveryTimer] != Timer: INVALID_TIMER)
    {
        KillTimer(_: gPizzaMission[playerid][DeliveryTimer]);
        gPizzaMission[playerid][DeliveryTimer] = Timer: INVALID_TIMER;
    }

    if (gPizzaMission[playerid][NPCid] != INVALID_PLAYER_ID)
    {
        NPC_Destroy(gPizzaMission[playerid][NPCid]);
        gPizzaMission[playerid][NPCid] = INVALID_PLAYER_ID;    
    }

    gPizzaMission[playerid][DeliveryState] = PIZZA_DELIVERY_NONE;

    DisablePlayerCheckpoint(playerid);

    RemovePlayerAttachedObject(playerid, PIZZA_OBJECT_SLOT);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    ClearAnimations(playerid, FORCE_SYNC: 1);
    TogglePlayerControllable(playerid, true);

    gPizzaMission[playerid][Active] = false;

    return 1;
}

stock Pizza_StartMinigame(playerid)
{
    if (gPizzaMission[playerid][Active])
    {
        return 1;
    }

    gPizzaMission[playerid][Active] = true;

    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, false, false, false, false, 0, FORCE_SYNC: 1);

    gPizzaMission[playerid][DeliveryTimer] = Timer: SetTimerEx("Pizza_OnPizzaLifted", 1100, false, "i", playerid);

    return 1;
}

stock Pizza_CheckCheckpoint(playerid)
{
    if (!gPizzaMission[playerid][Active])
    {
        return 0;
    }

    DisablePlayerCheckpoint(playerid);
    //RemovePlayerFromVehicle(playerid);
    gPizzaMission[playerid][DeliveryState] = PIZZA_DELIVERY_WAIT;

    TogglePlayerControllable(playerid, false);
    //SetPlayerFacingAngle(playerid, 0.0);

    ClearAnimations(playerid, FORCE_SYNC: 1);
    ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, true, false, false, false, 3000, FORCE_SYNC: 1);

    ApplyAnimation(gPizzaMission[playerid][NPCid], "SHOP", "SHP_Serve_Idle", 4.0, true, false, false, false, 3000, FORCE_SYNC: 1);

    gPizzaMission[playerid][DeliveryTimer] = Timer: SetTimerEx("Pizza_OnPizzaHandover", 3000, false, "i", playerid);

    return 1;
}

forward Pizza_OnPizzaLifted(playerid);
public Pizza_OnPizzaLifted(playerid)
{
    gPizzaMission[playerid][DeliveryTimer] = Timer: INVALID_TIMER;

    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    SetPlayerAttachedObject(playerid, PIZZA_OBJECT_SLOT, 1582, 6, 0.09, 0.03, 0.0, 90.0, 0.0);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    TogglePlayerControllable(playerid, true);

    gPizzaMission[playerid][DeliveryState] = PIZZA_DELIVERY_CARRY;

    Pizza_SetMissionCustomer(playerid);
    SetPlayerCheckpoint(playerid, gPizzaMission[playerid][DeliveryPos][CoordX], gPizzaMission[playerid][DeliveryPos][CoordY], gPizzaMission[playerid][DeliveryPos][CoordZ], 3.0);

    return 1;
}

forward Pizza_OnPizzaHandover(playerid);
public Pizza_OnPizzaHandover(playerid)
{
    gPizzaMission[playerid][DeliveryTimer] = Timer: INVALID_TIMER;

    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    gPizzaMission[playerid][DeliveryState] = PIZZA_DELIVERY_HANDOVER;

    ApplyAnimation(playerid, "SHOP", "SHP_Serve_Give", 4.1, false, false, false, false, 0, FORCE_SYNC: 1);
    ApplyAnimation(gPizzaMission[playerid][NPCid], "SHOP", "SHP_Thank", 4.1, false, false, false, false, 0, FORCE_SYNC: 1);

    gPizzaMission[playerid][DeliveryTimer] = Timer: SetTimerEx("Pizza_OnPizzaReleased", 700, false, "i", playerid);

    return 1;
}

forward Pizza_OnPizzaReleased(playerid);
public Pizza_OnPizzaReleased(playerid)
{
    gPizzaMission[playerid][DeliveryTimer] = Timer: INVALID_TIMER;

    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    RemovePlayerAttachedObject(playerid, PIZZA_OBJECT_SLOT);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    gPizzaMission[playerid][DeliveryState] = PIZZA_DELIVERY_PAYMENT;

    ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.1, false, false, false, false, 0, FORCE_SYNC: 1);
    ApplyAnimation(gPizzaMission[playerid][NPCid], "FOOD", "EAT_Pizza", 4.0, true, false, false, false, 4000, FORCE_SYNC: 1);

    gPizzaMission[playerid][DeliveryTimer] = Timer: SetTimerEx("Pizza_OnPizzaFinished", 1500, false, "i", playerid);

    return 1;
}

forward Pizza_OnPizzaFinished(playerid);
public Pizza_OnPizzaFinished(playerid)
{
    gPizzaMission[playerid][DeliveryTimer] = Timer: INVALID_TIMER;

    if (!IsPlayerConnected(playerid))
    {
        return 1;
    }

    // Give commission to player, end the delivery
    
    TogglePlayerControllable(playerid, true);

    return 1;
}

//

stock Pizza_SetCustomerPos(playerid)
{
    new
        Float: X,
        Float: Y,
        Float: Z,
        query[256];

    format(query, sizeof(query), "SELECT c.primary_x, c.primary_y, c.primary_z FROM property_coords AS c JOIN properties AS p ON c.property_id = p.id WHERE c.type = 8 AND p.name LIKE 'LS:%%' ORDER BY random() LIMIT 1");

    // Set iteration limit to 250, so the last is used if not anything closer appears...
    for (new i = 0; i < 250; i++)
    {
        new 
            DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        if (!result) 
        {
		    //SendClientMessageLocalized(playerid, I18N_TAXI_MISS_DB_READ_ERROR);

            print("Database error: cannot get random row from property_coords!");
            print(query);
            return 0;
        }

        X = DB_GetFieldFloatByName(result, "primary_x");
        Y = DB_GetFieldFloatByName(result, "primary_y");
        Z = DB_GetFieldFloatByName(result, "primary_z");

        DB_FreeResultSet(result);

        if (!IsPlayerInSphere(playerid, X, Y, Z, 175.0))
        {
            continue;
        }

        break;
    }
    
    gPizzaMission[playerid][DeliveryPos][CoordX] = X;
    gPizzaMission[playerid][DeliveryPos][CoordY] = Y;
    gPizzaMission[playerid][DeliveryPos][CoordZ] = Z;

    NPC_SetPos(gPizzaMission[playerid][NPCid], X, Y, Z);
    NPC_SetSkin(gPizzaMission[playerid][NPCid], random(311) + 1);
    SetPlayerMarkerForPlayer(playerid, gPizzaMission[playerid][NPCid], COLOR_YELLOW);

    return 1;
}

stock Pizza_SetMissionCustomer(playerid)
{
	if (gPizzaMission[playerid][NPCid] > INVALID_PLAYER_ID)
	{
		return Pizza_SetCustomerPos(playerid);
	}

	new 
		npcs[MAX_PIZZA_NPC_COUNT];
	NPC_GetAll(npcs, sizeof(npcs));

	new
		preid = -1;
	for (new i = 0; i < MAX_PIZZA_NPC_COUNT; i++)
	{
		if (!NPC_IsValid(npcs[i]))
		{
			preid = i;
			break;
		}
	}

	if (preid == -1)
	{
		SendClientMessageLocalized(playerid, I18N_TAXI_MISS_TOO_MANY_CUSTOMERS);
		return 0;
	}

	new
		npc_name[MAX_PLAYER_NAME];
	format(npc_name, sizeof(npc_name), "[NPC]pizza_cust%d", preid);

	new
		npcid = NPC_Create(npc_name);

	if (npcid == INVALID_NPC_ID)
	{
		print(npc_name);
		SendClientMessageLocalized(playerid, I18N_TAXI_MISS_TOO_MANY_CUSTOMERS);
		return 0;
	}

	NPC_Spawn(npcid);

	gPizzaMission[playerid][NPCid] = npcid;

	return Pizza_SetCustomerPos(playerid);
}