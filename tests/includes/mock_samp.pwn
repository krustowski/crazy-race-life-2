#if defined _CRL2_TEST_BUILD

//
//  mock_samp.pwn
//  Mock SA-MP natives for testing
//

new gMockPlayerMoney[MAX_PLAYERS] = 0;

// Mock implementations for testing
stock Mock_GetPlayerMoney(playerid) 
{
	return gMockPlayerMoney[playerid];
}
    
stock Mock_GivePlayerMoney(playerid, money)
{
	gMockPlayerMoney[playerid] += money;
	return 1;
}

stock DBResult: Mock_DB_ExecuteQuery(DB: handle, const query[])
{
#pragma unused handle, query
	return DBResult: 1;
}

stock Mock_DB_SelectNextRow(DBResult: result)
{
#pragma unused result
	return 1;
}

stock Mock_DB_GetFieldString(DBResult: result, id, str[], size = sizeof(str))
{
#pragma unused result, id, str, size
	return 1
}

stock Mock_DB_GetFieldStringByName(DBResult: result, const name[], str[], size = sizeof(str))
{
#pragma unused result, name, str, size
	return 1
}

stock Mock_DB_GetFieldInt(DBResult: result, id)
{
#pragma unused result, id
	return 1;
}
    
stock Mock_DB_GetFieldIntByName(DBResult: result, const name[])
{
#pragma unused result, name
	return 1
}
    
stock Float: Mock_DB_GetFieldFloatByName(DBResult: result, const name[])
{
#pragma unused result, name
	return Float: 1
}
    
stock Mock_DB_FreeResultSet(DBResult: result)
{
#pragma unused result
	return 1;
}

stock Mock_DB_GetRowCount(DBResult: result)
{
#pragma unused result
	return 1;
}

stock Mock_HideGameTextForPlayer(playerid, gameText)
{
#pragma unused playerid, gameText
	return 1;
}

stock Mock_CreatePlayerGangZone(playerid, coord1, coord2, coord3, coord4)
{
#pragma unused playerid, coord1, coord2, coord3, coord4
	return 1;
}

stock Mock_PlayerGangZoneShow(playerid, gangzoneid, col)
{
#pragma unused playerid, gangzoneid, col
	return 1;
}

stock Mock_UsePlayerGangZoneCheck(playerid, gangzoneid, bool: idk)
{
#pragma unused playerid, gangzoneid, idk
	return 1;
}

stock Mock_PlayerGangZoneHide(playerid, gangzoneid)
{
#pragma unused playerid, gangzoneid
	return 1;
}

stock Mock_PlayerGangZoneDestroy(playerid, gangzoneid)
{
#pragma unused playerid, gangzoneid
	return 1;
}

stock Mock_NPC_Destroy(npcid)
{
#pragma unused npcid
	return 1;
}

stock Mock_GetVehicleDriver(vehicleid)
{
#pragma unused vehicleid
	return 1;
}

stock Mock_NPC_EnterVehicle(npcid, vehicleid, seatid)
{
#pragma unused npcid, vehicleid, seatid
	return 1;
}

stock bool: Mock_IsValidTimer(timer)
{
#pragma unused timer
	return false;
}

stock bool: Mock_NPC_IsEnteringVehicle(npcid, vehicleid)
{
#pragma unused npcid, vehicleid
	return false;
}

stock Mock_NPC_GetVehicleID(npcid)
{
#pragma unused npcid
	return 1;
}

stock Mock_NPC_SetPos(npcid, Float: x, Float: y, Float: z)
{
#pragma unused npcid, x, y, z
	return 1;
}

stock Mock_NPC_SetSkin(npcid, skinid)
{
#pragma unused npcid, skinid
	return 1;
}

stock Mock_NPC_GetAll(arr[], size = sizeof(arr))
{
#pragma unused arr, size
	return 1;
}

stock bool: Mock_NPC_IsValid(npcid)
{
#pragma unused npcid
	return false;
}

stock Mock_NPC_Create(const name[])
{
#pragma unused name
	return 0;
}

stock Mock_NPC_Spawn(npcid)
{
#pragma unused npcid
	return 1;
}

// Redirect natives to mocks
#define 	GetPlayerMoney 		Mock_GetPlayerMoney
#define 	GivePlayerMoney 	Mock_GivePlayerMoney

#define 	DB_ExecuteQuery 	Mock_DB_ExecuteQuery
#define		DB_SelectNextRow 	Mock_DB_SelectNextRow
#define		DB_GetFieldStringByName	Mock_DB_GetFieldStringByName
#define 	DB_GetFieldIntByName	Mock_DB_GetFieldIntByName
#define 	DB_FreeResultSet	Mock_DB_FreeResultSet
#define		DB_GetFieldFloatByName 	Mock_DB_GetFieldFloatByName
#define  	DB_GetRowCount		Mock_DB_GetRowCount
#define 	HideGameTextForPlayer	Mock_HideGameTextForPlayer
#define 	CreatePlayerGangZone	Mock_CreatePlayerGangZone
#define		PlayerGangZoneShow	Mock_PlayerGangZoneShow
#define 	UsePlayerGangZoneCheck	Mock_UsePlayerGangZoneCheck
#define 	PlayerGangZoneHide	Mock_PlayerGangZoneHide
#define 	PlayerGangZoneDestroy	Mock_PlayerGangZoneDestroy
#define 	NPC_Destroy		Mock_NPC_Destroy
#define		GetVehicleDriver	Mock_GetVehicleDriver
#define		NPC_EnterVehicle	Mock_NPC_EnterVehicle
#define 	IsValidTimer		Mock_IsValidTimer
#define		NPC_IsEnteringVehicle	Mock_NPC_IsEnteringVehicle
#define		NPC_GetVehicleID	Mock_NPC_GetVehicleID
#define		NPC_SetPos		Mock_NPC_SetPos
#define		NPC_SetSkin		Mock_NPC_SetSkin
#define		NPC_GetAll		Mock_NPC_GetAll
#define		NPC_IsValid		Mock_NPC_IsValid
#define		NPC_Create		Mock_NPC_Create
#define		NPC_Spawn		Mock_NPC_Spawn
#define		DB_GetFieldString	Mock_DB_GetFieldString
#define		DB_GetFieldInt		Mock_DB_GetFieldInt
    
#else
// Use real SA-MP functions
native GetPlayerMoney(playerid);
native GivePlayerMoney(playerid, money);

#endif
