#if defined _CRL2_ANTICHEAT_LEDGER
	#endinput
#endif
#define _CRL2_ANTICHEAT_LEDGER

//
//  anticheat_ledger.pwn
//
//  The server's own record of every weapon and ammo it has handed out, which
//  the anticheat scan compares against what the client reports. The natives
//  that change a player's weapons are hooked below, so this file has to be
//  included before any module calling them: i18n.pwn pulls player.pwn and
//  most of the modules in, hence includes.pwn loads it first. It depends on
//  nothing but the natives for the same reason.
//

// GetPlayerWeaponData isn't trusted this long (plus the player's ping) after the
// server changed someone's weapons: the client has to apply the change and sync
// it back first.
#define AC_WEAPON_GRACE_MS		3000

#define AC_WEAPON_SLOTS			13
#define AC_MAX_WEAPON_ID		46

enum WeaponLedger
{
	// Bit per weapon id handed out since the last reset.
	GrantedWeapons[2],
	// Ammo handed out per slot since the last reset. Weapons sharing a slot may
	// share ammo too, so the sum is the most the slot can legitimately hold.
	GrantedAmmo[AC_WEAPON_SLOTS],
	LastChangeTick
}

new
	gWeaponLedger[MAX_PLAYERS][WeaponLedger];

// Slot of every weapon id, -1 for the ids GTA doesn't use (19-21).
static const sWeaponSlots[AC_MAX_WEAPON_ID + 1] =
{
	0, 0,
	1, 1, 1, 1, 1, 1, 1, 1,
	10, 10, 10, 10, 10, 10,
	8, 8, 8,
	-1, -1, -1,
	2, 2, 2,
	3, 3, 3,
	4, 4,
	5, 5,
	4,
	6, 6,
	7, 7, 7, 7,
	8, 12,
	9, 9, 9,
	11, 11, 11
};

stock GetWeaponSlotIndex(weaponid)
{
	if (weaponid < 0 || weaponid > AC_MAX_WEAPON_ID)
	{
		return -1;
	}

	return sWeaponSlots[weaponid];
}

stock ResetWeaponLedger(playerid)
{
	gWeaponLedger[playerid][GrantedWeapons][0] = 0;
	gWeaponLedger[playerid][GrantedWeapons][1] = 0;

	for (new i = 0; i < AC_WEAPON_SLOTS; i++)
	{
		gWeaponLedger[playerid][GrantedAmmo][i] = 0;
	}

	gWeaponLedger[playerid][LastChangeTick] = GetTickCount();
}

stock RecordWeaponGrant(playerid, weaponid, ammo)
{
	new
		slot = GetWeaponSlotIndex(weaponid);

	if (slot < 0)
	{
		return 0;
	}

	gWeaponLedger[playerid][GrantedWeapons][weaponid / 32] |= (1 << (weaponid % 32));

	if (ammo > 0)
	{
		gWeaponLedger[playerid][GrantedAmmo][slot] += ammo;
	}

	gWeaponLedger[playerid][LastChangeTick] = GetTickCount();

	return 1;
}

stock bool: IsWeaponGranted(playerid, weaponid)
{
	if (GetWeaponSlotIndex(weaponid) < 0)
	{
		return false;
	}

	return (gWeaponLedger[playerid][GrantedWeapons][weaponid / 32] & (1 << (weaponid % 32))) != 0;
}

stock GetGrantedSlotAmmo(playerid, slot)
{
	return gWeaponLedger[playerid][GrantedAmmo][slot];
}

stock bool: IsWeaponLedgerSettling(playerid, graceMs)
{
	return (GetTickCount() - gWeaponLedger[playerid][LastChangeTick]) < graceMs;
}

//
//  Hooks
//

stock bool: AC_GivePlayerWeapon(playerid, WEAPON: weaponid, ammo)
{
	if (playerid >= 0 && playerid < MAX_PLAYERS)
	{
		RecordWeaponGrant(playerid, _: weaponid, ammo);
	}

	return GivePlayerWeapon(playerid, weaponid, ammo);
}

#if defined _ALS_GivePlayerWeapon
	#undef GivePlayerWeapon
#else
	#define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon AC_GivePlayerWeapon

stock bool: AC_ResetPlayerWeapons(playerid)
{
	if (playerid >= 0 && playerid < MAX_PLAYERS)
	{
		ResetWeaponLedger(playerid);
	}

	return ResetPlayerWeapons(playerid);
}

#if defined _ALS_ResetPlayerWeapons
	#undef ResetPlayerWeapons
#else
	#define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons AC_ResetPlayerWeapons

// Sets the ammo outright, so the slot's ceiling follows it. The weapon itself is
// not granted by this: the native only touches a weapon the player already has.
stock bool: AC_SetPlayerAmmo(playerid, WEAPON: weaponid, ammo)
{
	new
		slot = GetWeaponSlotIndex(_: weaponid);

	if (playerid >= 0 && playerid < MAX_PLAYERS && slot >= 0)
	{
		gWeaponLedger[playerid][GrantedAmmo][slot] = (ammo > 0) ? ammo : 0;
		gWeaponLedger[playerid][LastChangeTick] = GetTickCount();
	}

	return SetPlayerAmmo(playerid, weaponid, ammo);
}

#if defined _ALS_SetPlayerAmmo
	#undef SetPlayerAmmo
#else
	#define _ALS_SetPlayerAmmo
#endif
#define SetPlayerAmmo AC_SetPlayerAmmo
