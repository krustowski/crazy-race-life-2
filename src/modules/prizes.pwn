#if defined _CRL2_PRIZES
	#endinput
#endif
#define _CRL2_PRIZES

//
//  prizes.pwn
//  Hidden treasure pickups (tiki / pumpkin) scattered around the map.
//
//  Rows live in prize_coords; the `hidden` column is the source of truth for
//  whether a prize is currently placed in the world. Every state change goes
//  through SetPrizeHidden(), which writes the column and creates/destroys the
//  live pickup together, so the world and the database never drift apart.
//

#define MAX_PRIZES			16

#include "support/helpers.pwn"

enum PrizeType
{
	PRIZE_NONE,
	PRIZE_TIKI,
	PRIZE_PUMPKIN
}

enum Prize
{
	ID,
	PrizeType: Type,
	PICKUP: Pickup,

	bool: Hidden,

	PrizeName[64],
	Point[Coords]
}

new
	gPrizes[MAX_PRIZES][Prize],
	gPrizeCount = 0;

// Model + reward per prize type, kept together so adding a type is one edit.
stock GetPrizeModel(PrizeType: type)
{
	switch (type)
	{
		case PRIZE_TIKI:	return PICKUP_TIKI;
		case PRIZE_PUMPKIN:	return PICKUP_PUMPKIN;
		default:		return 0;
	}

	return 0;
}

stock GetPrizeReward(PrizeType: type)
{
	switch (type)
	{
		case PRIZE_TIKI:	return 10000000;
		case PRIZE_PUMPKIN:	return 1500000;
		default:		return 0;
	}

	return 0;
}

stock GetPrizeTypeName(PrizeType: type, name[], size)
{
	switch (type)
	{
		case PRIZE_TIKI:	format(name, size, "Tiki");
		case PRIZE_PUMPKIN:	format(name, size, "Pumpkin");
		default:		format(name, size, "None");
	}

	return 1;
}

// Creates the world pickup for a prize, if it doesn't already have one.
stock CreatePrizePickup(prizeid)
{
	if (prizeid < 0 || prizeid >= gPrizeCount)
	{
		return 0;
	}

	if (gPrizes[prizeid][Pickup] != PICKUP: 0)
	{
		return 1;
	}

	new
		model = GetPrizeModel(gPrizes[prizeid][Type]);

	if (!model)
	{
		return 0;
	}

	gPrizes[prizeid][Pickup] = PICKUP: EnsurePickupCreated(
			model,
			PICKUP_TYPE_NO_RESPAWN,
			gPrizes[prizeid][Point][CoordX],
			gPrizes[prizeid][Point][CoordY],
			gPrizes[prizeid][Point][CoordZ]
	);

	return 1;
}

// Removes the world pickup for a prize, if it has one.
stock DestroyPrizePickup(prizeid)
{
	if (prizeid < 0 || prizeid >= gPrizeCount)
	{
		return 0;
	}

	if (gPrizes[prizeid][Pickup] == PICKUP: 0)
	{
		return 1;
	}

	DestroyPickup(_: gPrizes[prizeid][Pickup]);
	gPrizes[prizeid][Pickup] = PICKUP: 0;

	return 1;
}

// The single entry point for changing a prize's state: writes prize_coords
// and brings the live pickup in line with it, so a show/hide is immediately
// visible in-game and survives the next restart.
stock SetPrizeHidden(prizeid, bool: hidden)
{
	if (prizeid < 0 || prizeid >= gPrizeCount)
	{
		return 0;
	}

	new
		query[128];

	format(query, sizeof(query), "UPDATE prize_coords SET hidden = %d WHERE id = %d", _: hidden, gPrizes[prizeid][ID]);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		print("Database error: cannot write prize update!");
		print(query);

		return 0;
	}

	DB_FreeResultSet(result);

	gPrizes[prizeid][Hidden] = hidden;

	if (hidden)
	{
		DestroyPrizePickup(prizeid);
	}
	else
	{
		CreatePrizePickup(prizeid);
	}

	return 1;
}

stock TogglePrizeHidden(prizeid)
{
	if (prizeid < 0 || prizeid >= gPrizeCount)
	{
		return 0;
	}

	return SetPrizeHidden(prizeid, !gPrizes[prizeid][Hidden]);
}

stock InitPrizes()
{
	// Every row is loaded, hidden or not, so an editor can list and un-hide
	// them; only the visible ones get a world pickup.
	new
		query[128] = "SELECT id, type, name, x, y, z, hidden FROM prize_coords ORDER BY id ASC";

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		print("Database error: cannot load prize coords!");
		print(query);

		return 0;
	}

	gPrizeCount = 0;

	if (!DB_GetRowCount(result))
	{
		DB_FreeResultSet(result);
		print("Prizes initialized! (none defined)");

		return 1;
	}

	do
	{
		if (gPrizeCount >= MAX_PRIZES)
		{
			printf("Database warning: too many prizes (max %d), stopping", MAX_PRIZES);
			break;
		}

		new
			i = gPrizeCount;

		gPrizes[i][ID] = DB_GetFieldIntByName(result, "id");
		gPrizes[i][Type] = PrizeType: DB_GetFieldIntByName(result, "type");
		gPrizes[i][Hidden] = bool: DB_GetFieldIntByName(result, "hidden");
		gPrizes[i][Pickup] = PICKUP: 0;

		DB_GetFieldStringByName(result, "name", gPrizes[i][PrizeName], 64);

		gPrizes[i][Point][CoordX] = DB_GetFieldFloatByName(result, "x");
		gPrizes[i][Point][CoordY] = DB_GetFieldFloatByName(result, "y");
		gPrizes[i][Point][CoordZ] = DB_GetFieldFloatByName(result, "z");

		gPrizeCount++;

		if (!gPrizes[i][Hidden])
		{
			CreatePrizePickup(i);
		}
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	printf("Prizes initialized! (%d loaded)", gPrizeCount);

	return 1;
}

// Drops every live pickup and re-reads prize_coords — for picking up changes
// made to the table outside the game.
stock ReloadPrizes()
{
	for (new i = 0; i < gPrizeCount; i++)
	{
		DestroyPrizePickup(i);
	}

	return InitPrizes();
}

// A player walked into a prize: pay out and hide it for good.
stock UpdatePrize(playerid, prizeid)
{
	if (prizeid < 0 || prizeid >= gPrizeCount)
	{
		return 0;
	}

	new
		reward = GetPrizeReward(gPrizes[prizeid][Type]);

	if (!reward)
	{
		return 0;
	}

	SetPrizeHidden(prizeid, true);

	new
		stringToPrint[128];

	new
		typeName[16];

	GetPrizeTypeName(gPrizes[prizeid][Type], typeName, sizeof(typeName));

	format(stringToPrint, sizeof(stringToPrint), "[ PRIZE ] You have found the %s prize ($%d)! Cg", typeName, reward);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, stringToPrint);

	GivePlayerMoney(playerid, reward);

	return 1;
}

// Called from CheckGenericPickup; returns 1 if the pickup was a prize.
stock CheckPrizePickup(playerid, pickupid)
{
	for (new i = 0; i < gPrizeCount; i++)
	{
		if (gPrizes[i][Pickup] == PICKUP: 0 || PICKUP: pickupid != gPrizes[i][Pickup])
		{
			continue;
		}

		return UpdatePrize(playerid, i);
	}

	return 0;
}

//
//  Admin editor
//

stock ShowPrizeEditorMainDialog(playerid)
{
	if (!gPrizeCount)
	{
		return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] No prizes are defined in prize_coords!");
	}

	new
		stringToPrint[1536] = "ID\tType\tState\tLocation";

	for (new i = 0; i < gPrizeCount; i++)
	{
		new
			typeName[16],
			location[48];

		GetPrizeTypeName(gPrizes[i][Type], typeName, sizeof(typeName));

		// The name column is blank for most rows, so fall back to coordinates --
		// an admin deciding what to toggle wants to know where it is.
		if (strlen(gPrizes[i][PrizeName]))
		{
			format(location, sizeof(location), "%s", gPrizes[i][PrizeName]);
		}
		else
		{
			format(location, sizeof(location), "%.0f, %.0f, %.0f", gPrizes[i][Point][CoordX], gPrizes[i][Point][CoordY], gPrizes[i][Point][CoordZ]);
		}

		format(stringToPrint, sizeof(stringToPrint), "%s\n%d\t%s\t%s\t%s",
				stringToPrint,
				gPrizes[i][ID],
				typeName,
				gPrizes[i][Hidden] ? ("{FF0000}Hidden") : ("{00FF00}Shown"),
				location
		);
	}

	return ShowPlayerDialog(playerid, DIALOG_PRIZE_EDITOR_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "Prize Editor", stringToPrint, "Toggle", "Close");
}
