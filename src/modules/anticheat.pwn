#if defined _CRL2_ANTICHEAT
	#endinput
#endif
#define _CRL2_ANTICHEAT

//
//  anticheat.pwn
//
//  Periodic scan for states the gamemode can never produce: a weapon or ammo the
//  server never handed out (see anticheat_ledger.pwn), health or armour over 100,
//  a jetpack. Every finding goes to the server log and to the admins online.
//

#define AC_SCAN_INTERVAL_MS		(3 * SECOND_MS)

// Warnings for a correctable finding (it gets reverted) before the kick.
#define AC_MAX_STRIKES			3

// Nothing in the gamemode sets health or armour above this.
#define AC_MAX_VITALS			100.0

forward AntiCheatScan();
forward AntiFlood();

enum AntiCheatViolation
{
	AC_VIOLATION_NONE,
	AC_VIOLATION_WEAPON,
	AC_VIOLATION_AMMO,
	AC_VIOLATION_HEALTH,
	AC_VIOLATION_ARMOUR
}

enum AntiCheatState
{
	Strikes,
	// Last scan's finding, acted upon only when the next scan sees it again.
	AntiCheatViolation: PendingViolation,
	PendingDetail,
	bool: Kicked
}

new
	gAntiCheat[MAX_PLAYERS][AntiCheatState];

stock ResetAntiCheatState(playerid)
{
	ResetWeaponLedger(playerid);

	gAntiCheat[playerid][Strikes] = 0;
	gAntiCheat[playerid][PendingViolation] = AC_VIOLATION_NONE;
	gAntiCheat[playerid][PendingDetail] = 0;
	gAntiCheat[playerid][Kicked] = false;
}

// Fists, the detonator that comes with satchels and the parachute GTA hands out
// on bailing from an aircraft never go through GivePlayerWeapon.
stock bool: IsWeaponAlwaysAllowed(weaponid)
{
	return (weaponid == _: WEAPON_FIST || weaponid == _: WEAPON_BOMB || weaponid == _: WEAPON_PARACHUTE);
}

// Ammo only counts for guns and throwables. The minigun is left out, as Nex-AC does.
stock bool: IsAmmoCheckedWeapon(weaponid)
{
	new
		slot = GetWeaponSlotIndex(weaponid);

	return (slot >= 2 && slot <= 8 && weaponid != _: WEAPON_MINIGUN);
}

// Banned by the server rules, so having one unasked skips the warnings.
stock bool: IsBannedHeavyWeapon(weaponid)
{
	return (weaponid == _: WEAPON_HEATSEEKER || weaponid == _: WEAPON_FLAMETHROWER || weaponid == _: WEAPON_MINIGUN);
}

// One weapon slot as the client reports it, judged against the ledger.
stock AntiCheatViolation: JudgeReportedWeapon(playerid, weaponid, ammo)
{
	// Spent guns linger in their slot with no ammo, and ids GTA doesn't use are
	// sync noise rather than anything a player can fire.
	if (ammo <= 0 || GetWeaponSlotIndex(weaponid) < 0 || IsWeaponAlwaysAllowed(weaponid))
	{
		return AC_VIOLATION_NONE;
	}

	if (!IsWeaponGranted(playerid, weaponid))
	{
		return AC_VIOLATION_WEAPON;
	}

	if (IsAmmoCheckedWeapon(weaponid) && ammo > GetGrantedSlotAmmo(playerid, GetWeaponSlotIndex(weaponid)))
	{
		return AC_VIOLATION_AMMO;
	}

	return AC_VIOLATION_NONE;
}

// detail is the weapon id (0 for health/armour), amount its ammo or the value.
stock AntiCheatViolation: FindPlayerViolation(playerid, &detail, &amount)
{
	new
		Float: health,
		Float: armour;

	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);

	detail = 0;
	amount = 0;

	if (health > AC_MAX_VITALS)
	{
		amount = floatround(health);
		return AC_VIOLATION_HEALTH;
	}

	if (armour > AC_MAX_VITALS)
	{
		amount = floatround(armour);
		return AC_VIOLATION_ARMOUR;
	}

	if (IsWeaponLedgerSettling(playerid, AC_WEAPON_GRACE_MS + GetPlayerPing(playerid)))
	{
		return AC_VIOLATION_NONE;
	}

	for (new slot = 0; slot < AC_WEAPON_SLOTS; slot++)
	{
		new
			WEAPON: weapon,
			ammo;

		GetPlayerWeaponData(playerid, WEAPON_SLOT: slot, weapon, ammo);

		new
			AntiCheatViolation: violation = JudgeReportedWeapon(playerid, _: weapon, ammo);

		if (violation != AC_VIOLATION_NONE)
		{
			detail = _: weapon;
			amount = ammo;

			return violation;
		}
	}

	// The weapon in hand comes with every sync, so it is never stale.
	new
		armed = _: GetPlayerWeapon(playerid);

	if (armed > 0 && JudgeReportedWeapon(playerid, armed, 1) == AC_VIOLATION_WEAPON)
	{
		detail = armed;
		return AC_VIOLATION_WEAPON;
	}

	return AC_VIOLATION_NONE;
}

public AntiCheatScan()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i) || IsPlayerNPC(i) || NPC_IsValid(i))
		{
			continue;
		}

		if (!gPlayers[i][IsLogged] || gAntiCheat[i][Kicked] || IsPlayerAdmin(i) || gPlayers[i][AdminLevel] > 0)
		{
			continue;
		}

		// Dead, spectating or not spawned yet: there is no live state to judge.
		if (!IsPlayerAlive(i))
		{
			continue;
		}

		if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
		{
			ReportCheatViolation(i, "jetpack", "kicked");
			KickForCheating(i, I18N_JETPACK_VIOLATION_FMT);
			continue;
		}

		new
			detail,
			amount,
			AntiCheatViolation: violation = FindPlayerViolation(i, detail, amount);

		if (violation == AC_VIOLATION_NONE)
		{
			gAntiCheat[i][PendingViolation] = AC_VIOLATION_NONE;
			continue;
		}

		// A finding only counts once the next scan sees it too, so a single sync
		// hiccup never costs anyone a warning.
		if (gAntiCheat[i][PendingViolation] != violation || gAntiCheat[i][PendingDetail] != detail)
		{
			gAntiCheat[i][PendingViolation] = violation;
			gAntiCheat[i][PendingDetail] = detail;
			continue;
		}

		gAntiCheat[i][PendingViolation] = AC_VIOLATION_NONE;

		PunishCheatViolation(i, violation, detail, amount);
	}

	return 1;
}

stock PunishCheatViolation(playerid, AntiCheatViolation: violation, detail, amount)
{
	new
		description[64];

	DescribeCheatViolation(playerid, violation, detail, amount, description, sizeof(description));

	if (violation == AC_VIOLATION_WEAPON && IsBannedHeavyWeapon(detail))
	{
		ReportCheatViolation(playerid, description, "kicked");
		return KickForCheating(playerid, I18N_WEAPON_CHEAT_VIOLATION_FMT);
	}

	switch (violation)
	{
		case AC_VIOLATION_WEAPON, AC_VIOLATION_AMMO:
			{
				StripUngrantedWeapons(playerid);
			}
		case AC_VIOLATION_HEALTH:
			{
				SetPlayerHealth(playerid, AC_MAX_VITALS);
			}
		case AC_VIOLATION_ARMOUR:
			{
				SetPlayerArmour(playerid, AC_MAX_VITALS);
			}
		default:
			{}
	}

	gAntiCheat[playerid][Strikes]++;

	new
		outcome[32];

	format(outcome, sizeof(outcome), "reverted, warning %d/%d", gAntiCheat[playerid][Strikes], AC_MAX_STRIKES);
	ReportCheatViolation(playerid, description, outcome);

	if (gAntiCheat[playerid][Strikes] >= AC_MAX_STRIKES)
	{
		return KickForCheating(playerid, I18N_ANTICHEAT_KICK_FMT);
	}

	new
		stringToPrint[144];

	GetLocalizedString(playerid, I18N_ANTICHEAT_STRIKE_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, gAntiCheat[playerid][Strikes], AC_MAX_STRIKES);
	SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

	return 1;
}

stock DescribeCheatViolation(playerid, AntiCheatViolation: violation, detail, amount, dest[], size)
{
	new
		weaponName[32];

	switch (violation)
	{
		case AC_VIOLATION_WEAPON:
			{
				GetWeaponName(WEAPON: detail, weaponName, sizeof(weaponName));
				format(dest, size, "%s (%d) x%d never given", weaponName, detail, amount);
			}
		case AC_VIOLATION_AMMO:
			{
				GetWeaponName(WEAPON: detail, weaponName, sizeof(weaponName));
				format(dest, size, "%s ammo %d, given %d", weaponName, amount, GetGrantedSlotAmmo(playerid, GetWeaponSlotIndex(detail)));
			}
		case AC_VIOLATION_HEALTH:
			{
				format(dest, size, "health %d over 100", amount);
			}
		case AC_VIOLATION_ARMOUR:
			{
				format(dest, size, "armour %d over 100", amount);
			}
		default:
			{}
	}

	return 1;
}

// Takes back whatever the server never handed out and trims ammo to what it did,
// giving the rest of the loadout (and the weapon in hand) straight back.
stock StripUngrantedWeapons(playerid)
{
	new
		keepWeapon[AC_WEAPON_SLOTS],
		keepAmmo[AC_WEAPON_SLOTS],
		armed = _: GetPlayerWeapon(playerid);

	for (new slot = 0; slot < AC_WEAPON_SLOTS; slot++)
	{
		new
			WEAPON: weapon,
			ammo,
			weaponid;

		GetPlayerWeaponData(playerid, WEAPON_SLOT: slot, weapon, ammo);
		weaponid = _: weapon;

		// Guns with no ammo are spent; melee weapons and gadgets may report none.
		if (weaponid <= 0 || (ammo <= 0 && slot >= 2 && slot <= 9))
		{
			continue;
		}

		if (!IsWeaponGranted(playerid, weaponid) && weaponid != _: WEAPON_PARACHUTE)
		{
			continue;
		}

		keepWeapon[slot] = weaponid;
		keepAmmo[slot] = IsAmmoCheckedWeapon(weaponid) ? min(ammo, GetGrantedSlotAmmo(playerid, slot)) : max(ammo, 1);
	}

	// Hooked, so the ledger starts over from what is given back below.
	ResetPlayerWeapons(playerid);

	for (new slot = 0; slot < AC_WEAPON_SLOTS; slot++)
	{
		// The detonator comes back along with the satchels.
		if (keepWeapon[slot] && keepWeapon[slot] != _: WEAPON_BOMB)
		{
			GivePlayerWeapon(playerid, WEAPON: keepWeapon[slot], keepAmmo[slot]);
		}
	}

	new
		armedSlot = GetWeaponSlotIndex(armed);

	if (armed > 0 && armedSlot >= 0 && keepWeapon[armedSlot] == armed)
	{
		SetPlayerArmedWeapon(playerid, WEAPON: armed);
	}

	return 1;
}

// Monitoring: every finding goes to the server log and to the admins online.
stock ReportCheatViolation(playerid, const description[], const outcome[])
{
	new
		team[64] = "none",
		report[192],
		alert[144];

	if (gPlayers[playerid][TeamID])
	{
		format(team, sizeof(team), "%s", gTeams[ _: gPlayers[playerid][TeamID] - 1 ][TeamName]);
	}

	format(report, sizeof(report), "%s (ID: %d): %s | team %s, minigame %s | %s",
		gPlayers[playerid][Name], playerid, description, team,
		(gPlayers[playerid][InMinigame] || gDeathmatch[playerid][InGame]) ? ("yes") : ("no"), outcome);

	printf("[anticheat] %s", report);

	format(alert, sizeof(alert), "[ AC ] %s", report);

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i) && (gPlayers[i][AdminLevel] > 0 || IsPlayerAdmin(i)))
		{
			SendClientMessage(i, COLOR_ORANGE, alert);
		}
	}

	return 1;
}

stock KickForCheating(playerid, msg_id)
{
	new
		stringToPrint[128];

	gAntiCheat[playerid][Kicked] = true;

	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		GetLocalizedString(i, msg_id, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gPlayers[playerid][Name]);
		SendClientMessage(i, COLOR_RED, stringToPrint);
	}

	PlayerPlaySound(playerid, 1056);

	return DelayedKick(playerid);
}

public AntiFlood()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (!IsPlayerConnected(i))
		{
			continue;
		}

		if (GetPlayerPing(i) > 0)
		{
			continue;
		}

		if (IsPlayerNPC(i) || NPC_IsValid(i))
		{
			continue;
		}

		new
			ipAddress[128],
			stringToPrint[128];

		GetPlayerIp(i, ipAddress, sizeof(ipAddress));

		for (new j = 0; j < MAX_PLAYERS; j++)
		{
			if (!IsPlayerConnected(j))
			{
				continue;
			}

			GetLocalizedString(j, I18N_IP_FLOOD_VIOLATION_FMT, stringToPrint, sizeof(stringToPrint));
			format(stringToPrint, sizeof(stringToPrint), stringToPrint, ipAddress);
			SendClientMessage(j, COLOR_RED, stringToPrint);
		}

		PlayerPlaySound(i, 1056, 0, 0, 0);
		Ban(i);

		// Log to the server's console log.
		print(stringToPrint);
	}

	return 1;
}
