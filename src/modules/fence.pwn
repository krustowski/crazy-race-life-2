#if defined _CRL2_FENCE
	#endinput
#endif
#define _CRL2_FENCE

//
//  fence.pwn
//  The fence: the server buys drugz off Dealerz at the druggery points.
//

#define FENCE_UNITS_PER_HOUR	5000
#define FENCE_DOLLARS_PER_HOUR	1000000
// The fence pays this share of the market price, so selling to players stays
// the better deal and the fence is the floor under it
#define FENCE_PRICE_SHARE		0.60
// The limits roll over the last hour of fence_sales rows
#define FENCE_WINDOW_S			(60 * 60)

new
	DrugType: gFenceSelectedDrug[MAX_PLAYERS];

// What the fence pays for a unit of drugid (0-based) right now.
stock Float: GetFenceUnitPrice(drugid)
{
	return float(gDrugz[drugid][DrugPrice]) * gBlackMarketRatio * FENCE_PRICE_SHARE;
}

// What is left of the player's hourly fence limits. Returns 0 when the sales
// cannot be read, and the fence must not buy then.
stock GetFenceAllowance(playerid, &unitsLeft, &dollarsLeft)
{
	new
		query[256];
	format(query, sizeof(query), "SELECT COALESCE(SUM(amount), 0) AS units, COALESCE(SUM(value), 0) AS dollars FROM fence_sales WHERE user_id = %d AND sold_at > %d",
			gPlayers[playerid][OrmID],
			gettime() - FENCE_WINDOW_S
		);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot fetch fence sales!");
		return 0;
	}

	unitsLeft = max(FENCE_UNITS_PER_HOUR - DB_GetFieldIntByName(result, "units"), 0);
	dollarsLeft = max(FENCE_DOLLARS_PER_HOUR - DB_GetFieldIntByName(result, "dollars"), 0);

	DB_FreeResultSet(result);

	return 1;
}

// How many of amount units the fence takes at unitPrice, within the limits left.
stock GetFenceSellableUnits(amount, unitsLeft, dollarsLeft, Float: unitPrice)
{
	if (unitPrice <= 0.0)
	{
		return 0;
	}

	return min(amount, min(unitsLeft, floatround(float(dollarsLeft) / unitPrice, floatround_floor)));
}

stock ProcessFenceSale(playerid, DrugType: type, amount)
{
	if (gPlayers[playerid][TeamID] != TEAM_DEALERS)
	{
		return SendClientMessageLocalized(playerid, I18N_FENCE_DEALERZ_ONLY);
	}

	// The dialog chain starts at a druggery point, so a sale from anywhere else is a forged response
	if (!IsPlayerAtDruggeryPoint(playerid))
	{
		return SendClientMessageLocalized(playerid, I18N_FENCE_NOT_AT_POINT);
	}

	new
		drugid = _: type - 1;

	if (drugid < 0 || drugid >= MAX_DRUG_TYPES || amount <= 0 || amount > gPlayers[playerid][Drugs][drugid])
	{
		return SendClientMessageLocalized(playerid, I18N_FENCE_WRONG_AMOUNT);
	}

	new
		Float: ratio = gBlackMarketRatio,
		Float: unitPrice = GetFenceUnitPrice(drugid);

	if (floatround(float(amount) * unitPrice, floatround_floor) < 1)
	{
		return SendClientMessageLocalized(playerid, I18N_FENCE_WORTHLESS);
	}

	new
		unitsLeft,
		dollarsLeft;

	if (!GetFenceAllowance(playerid, unitsLeft, dollarsLeft))
	{
		return SendClientMessageLocalized(playerid, I18N_FENCE_CLOSED);
	}

	new
		sold = GetFenceSellableUnits(amount, unitsLeft, dollarsLeft, unitPrice),
		value = floatround(float(sold) * unitPrice, floatround_floor),
		stringToPrint[MAX_MESSAGE_LEN];

	if (value < 1)
	{
		GetLocalizedString(playerid, I18N_FENCE_LIMIT_REACHED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, FENCE_UNITS_PER_HOUR, FENCE_DOLLARS_PER_HOUR);
		return SendClientMessage(playerid, COLOR_RED, stringToPrint);
	}

	// Log the sale before paying out, so nothing is paid that the limits do not see
	new
		query[256];
	format(query, sizeof(query), "INSERT INTO fence_sales (user_id, drug_type, amount, value, ratio, sold_at) VALUES (%d, %d, %d, %d, %f, %d)",
			gPlayers[playerid][OrmID],
			_: type,
			sold,
			value,
			ratio,
			gettime()
		);

	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
	if (!result)
	{
		print("Database error: cannot write fence sale!");
		print(query);
		return SendClientMessageLocalized(playerid, I18N_FENCE_CLOSED);
	}

	DB_FreeResultSet(result);

	gPlayers[playerid][Drugs][drugid] -= sold;
	GivePlayerMoney(playerid, value);

	PushBlackMarketRatioDown(sold * gDrugz[drugid][DrugPrice]);

	GetLocalizedString(playerid, I18N_FENCE_SOLD_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, sold, gDrugz[drugid][DrugName], value, ratio);
	SendClientMessage(playerid, COLOR_ORANGE, stringToPrint);

	if (sold < amount)
	{
		GetLocalizedString(playerid, I18N_FENCE_PARTIAL_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, sold, amount, unitsLeft - sold, dollarsLeft - value);
		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
	}

	return 1;
}
