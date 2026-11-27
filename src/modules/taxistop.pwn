#if defined _CRL2_TAXISTOP
	#endinput
#endif
#define _CRL2_TAXISTOP

//
//  taxistop.pwn
//  Rides in the ambient NPC taxis (npcs.pwn): calling a taxi on the phone
//  navigates the player to the nearest stop, and the driver tells a passenger
//  where he pulls up next.
//

#define MAX_TAXI_STOPS				256

// taxi_stops lists every spot a taxi stands still for at least 5s along its
// recordings (see utils/taxistops). One serves the nearest commercial property
// within this range; the rest are left out.
#define TAXI_STOP_PROPERTY_RANGE	40.0

// Stops of the same property this close together are one stop to a player,
// whichever taxi pulls up there.
#define TAXI_STOP_MERGE_RANGE		25.0

// The checkpoint goes on the curb beside the cab, on the property's side,
// rather than on the road where the cab pulls up.
#define TAXI_STOP_CURB_OFFSET		3.5
#define TAXI_STOP_CP_SIZE			3.0

#define TAXI_RIDE_TICK_MS			1000

enum TaxiStop
{
	// gTaxiDriverNPC[] slot of the taxi that stops here
	TaxiIdx,

	// When the cab pulls up, in ms into its loop of recordings, and for how long
	LoopMs,
	Duration,

	// The curb beside the cab
	Curb[Coords],

	// The commercial property the stop serves
	PropertyID,
	Name[64]
}

enum TaxiPassenger
{
	// gTaxiStops[] index the phone navigates to, or -1
	CalledStop,

	// The taxi being ridden, the stop its driver announced and how far off
	// that was on the last tick
	RideTaxi,
	RideNextStop,
	RideLastETA,

	Timer: RideTimer
}

new
	gTaxiStops[MAX_TAXI_STOPS][TaxiStop],
	gTaxiStopCount = 0,

	// Per taxi: its stops are gTaxiStops[first .. first + total - 1], in the
	// order it drives to them
	gTaxiFirstStop[MAX_TAXI_DRIVERS],
	gTaxiStopTotal[MAX_TAXI_DRIVERS],

	// Per taxi: where each recording segment starts in its loop, and how
	// long the loop is (0: unknown, the taxi cannot be followed)
	gTaxiSegmentStart[MAX_TAXI_DRIVERS][NUM_PLAYBACK_FILES],
	gTaxiLoopMs[MAX_TAXI_DRIVERS],

	gTaxiPassenger[MAX_PLAYERS][TaxiPassenger];

forward UpdateTaxiRide(playerid);
forward bool: IsSameTaxiStop(stopid, otherid);
forward bool: IsTaxiStandingAtStop(stopid);

// The 1s tick of a passenger: once the cab pulls up at the stop announced
// last, the driver says so and announces the next one.
public UpdateTaxiRide(playerid)
{
	new
		taxiIdx = gTaxiPassenger[playerid][RideTaxi];

	if (taxiIdx == -1 || GetPlayerState(playerid) != PLAYER_STATE_PASSENGER || GetPlayerVehicleID(playerid) != gTaxiVehicle[taxiIdx])
	{
		return StopTaxiRide(playerid);
	}

	new
		stopid = gTaxiPassenger[playerid][RideNextStop],
		eta = GetTaxiStopETA(stopid);

	// The driver is gone
	if (eta == -1)
	{
		return StopTaxiRide(playerid);
	}

	// Counting down until the cab gets there, then a whole loop again
	if (eta - gTaxiPassenger[playerid][RideLastETA] > gTaxiLoopMs[taxiIdx] / 2)
	{
		new
			stringToPrint[144];

		GetLocalizedString(playerid, I18N_TAXI_RIDE_ARRIVED_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gTaxiStops[stopid][Name]);
		SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

		FireQuestEvent(playerid, QUEST_EVT_TAXI_RIDE_STOP);

		stopid = GetTaxiNextStop(taxiIdx);
		eta = GetTaxiStopETA(stopid);

		gTaxiPassenger[playerid][RideNextStop] = stopid;

		SendTaxiNextStopMessage(playerid, stopid);
	}

	gTaxiPassenger[playerid][RideLastETA] = eta;

	return 1;
}

// How far into its loop of recordings the taxi is, in ms, or -1 when it does
// not drive it (not spawned yet, or its taxi_tracks rows are missing).
stock GetTaxiLoopTime(taxiIdx)
{
	if (!gTaxiLoopMs[taxiIdx] || !gTaxiPlaybackStarted[taxiIdx] || !NPC_IsValid(gTaxiDriverNPC[taxiIdx]))
	{
		return -1;
	}

	// gTaxiPlaybackNo is the segment to play next
	new
		segment = gTaxiPlaybackNo[taxiIdx] - 1;

	if (segment < 0 || segment >= NUM_PLAYBACK_FILES)
	{
		return -1;
	}

	return (gTaxiSegmentStart[taxiIdx][segment] + GetTickCount() - gTaxiPlaybackTick[taxiIdx]) % gTaxiLoopMs[taxiIdx];
}

// How long until the taxi pulls up at the stop next, in ms, or -1.
stock GetTaxiStopETA(stopid)
{
	new
		taxiIdx = gTaxiStops[stopid][TaxiIdx],
		now = GetTaxiLoopTime(taxiIdx);

	if (now == -1)
	{
		return -1;
	}

	new
		eta = gTaxiStops[stopid][LoopMs] - now;

	return (eta < 0) ? eta + gTaxiLoopMs[taxiIdx] : eta;
}

// The stop the taxi pulls up at next, or -1.
stock GetTaxiNextStop(taxiIdx)
{
	new
		now = GetTaxiLoopTime(taxiIdx);

	if (now == -1 || !gTaxiStopTotal[taxiIdx])
	{
		return -1;
	}

	new
		first = gTaxiFirstStop[taxiIdx];

	for (new i = first; i < first + gTaxiStopTotal[taxiIdx]; i++)
	{
		if (gTaxiStops[i][LoopMs] > now)
		{
			return i;
		}
	}

	// Past the last one: the loop starts over
	return first;
}

stock bool: IsSameTaxiStop(stopid, otherid)
{
	if (gTaxiStops[stopid][PropertyID] != gTaxiStops[otherid][PropertyID])
	{
		return false;
	}

	return VectorSize(
			gTaxiStops[stopid][Curb][CoordX] - gTaxiStops[otherid][Curb][CoordX],
			gTaxiStops[stopid][Curb][CoordY] - gTaxiStops[otherid][Curb][CoordY],
			gTaxiStops[stopid][Curb][CoordZ] - gTaxiStops[otherid][Curb][CoordZ]
		) <= TAXI_STOP_MERGE_RANGE;
}

// How long until any taxi pulls up at the stop next, in ms, or -1.
stock GetTaxiStopSoonestETA(stopid)
{
	new
		soonest = -1;

	for (new i = 0; i < gTaxiStopCount; i++)
	{
		if (!IsSameTaxiStop(stopid, i))
		{
			continue;
		}

		new
			eta = GetTaxiStopETA(i);

		if (eta != -1 && (soonest == -1 || eta < soonest))
		{
			soonest = eta;
		}
	}

	return soonest;
}

stock bool: IsTaxiStandingAtStop(stopid)
{
	for (new i = 0; i < gTaxiStopCount; i++)
	{
		if (!IsSameTaxiStop(stopid, i))
		{
			continue;
		}

		new
			taxiIdx = gTaxiStops[i][TaxiIdx],
			now = GetTaxiLoopTime(taxiIdx);

		if (now == -1)
		{
			continue;
		}

		new
			since = now - gTaxiStops[i][LoopMs];

		if (since < 0)
		{
			since += gTaxiLoopMs[taxiIdx];
		}

		if (since < gTaxiStops[i][Duration])
		{
			return true;
		}
	}

	return false;
}

// The stop nearest to the point that a taxi drives to now, or -1.
stock GetNearestTaxiStop(Float: X, Float: Y, Float: Z, &Float: distance)
{
	new
		stopid = -1;

	distance = 0.0;

	for (new i = 0; i < gTaxiStopCount; i++)
	{
		if (GetTaxiLoopTime(gTaxiStops[i][TaxiIdx]) == -1)
		{
			continue;
		}

		new
			Float: d = VectorSize(
				X - gTaxiStops[i][Curb][CoordX],
				Y - gTaxiStops[i][Curb][CoordY],
				Z - gTaxiStops[i][Curb][CoordZ]
			);

		if (stopid == -1 || d < distance)
		{
			stopid = i;
			distance = d;
		}
	}

	return stopid;
}

stock SendTaxiNextStopMessage(playerid, stopid)
{
	new
		eta = max(GetTaxiStopETA(stopid), 0) / SECOND_MS,
		stringToPrint[144];

	GetLocalizedString(playerid, I18N_TAXI_RIDE_NEXT_STOP_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, gTaxiStops[stopid][Name], eta / 60, eta % 60);
	SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

	// The same banner the taxi mission shows its driver
	format(stringToPrint, sizeof(stringToPrint), gI18nMessages[I18N_TAXI_MISS_NEXT_DESTINATION][ gPlayers[playerid][Locale] ], gTaxiStops[stopid][Name]);
	GameTextForPlayer(playerid, stringToPrint, 4000, 3);

	return 1;
}

// The phone's "Call Taxi": a checkpoint at the nearest stop and when the
// next cab gets there.
stock CallTaxi(playerid)
{
	// Pizza delivery uses the checkpoint too
	if (gPlayers[playerid][InMinigame] || gPizzaMission[playerid][Active])
	{
		return SendClientMessageLocalized(playerid, I18N_TAXI_CALL_MINIGAME_BLOCK);
	}

	new
		Float: X,
		Float: Y,
		Float: Z;

	GetPlayerPos(playerid, X, Y, Z);

	new
		Float: distance,
		stopid = GetNearestTaxiStop(X, Y, Z, distance);

	if (stopid == -1)
	{
		return SendClientMessageLocalized(playerid, I18N_TAXI_CALL_NO_TAXI);
	}

	gTaxiPassenger[playerid][CalledStop] = stopid;

	SetPlayerCheckpoint(playerid, gTaxiStops[stopid][Curb][CoordX], gTaxiStops[stopid][Curb][CoordY], gTaxiStops[stopid][Curb][CoordZ], TAXI_STOP_CP_SIZE);

	new
		eta = max(GetTaxiStopSoonestETA(stopid), 0) / SECOND_MS,
		stringToPrint[144];

	GetLocalizedString(playerid, I18N_TAXI_CALL_STOP_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, gTaxiStops[stopid][Name], floatround(distance), eta / 60, eta % 60);

	return SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
}

stock CheckTaxiStopCheckpoint(playerid)
{
	new
		stopid = gTaxiPassenger[playerid][CalledStop];

	if (stopid == -1 || !IsPlayerInSphere(playerid, gTaxiStops[stopid][Curb][CoordX], gTaxiStops[stopid][Curb][CoordY], gTaxiStops[stopid][Curb][CoordZ], TAXI_STOP_CP_SIZE * 2))
	{
		return 0;
	}

	DisablePlayerCheckpoint(playerid);
	gTaxiPassenger[playerid][CalledStop] = -1;

	FireQuestEvent(playerid, QUEST_EVT_TAXI_STOP_REACHED);

	new
		stringToPrint[144];

	if (IsTaxiStandingAtStop(stopid))
	{
		GetLocalizedString(playerid, I18N_TAXI_CALL_CAB_WAITING_FMT, stringToPrint, sizeof(stringToPrint));
		format(stringToPrint, sizeof(stringToPrint), stringToPrint, gTaxiStops[stopid][Name]);

		return SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
	}

	new
		eta = max(GetTaxiStopSoonestETA(stopid), 0) / SECOND_MS;

	GetLocalizedString(playerid, I18N_TAXI_CALL_ARRIVED_FMT, stringToPrint, sizeof(stringToPrint));
	format(stringToPrint, sizeof(stringToPrint), stringToPrint, gTaxiStops[stopid][Name], eta / 60, eta % 60);

	return SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
}

// OnPlayerStateChange: the player got in a vehicle as a passenger. Returns 0
// when it is not an NPC taxi.
stock StartTaxiRide(playerid, vehicleid)
{
	new
		taxiIdx = GetTaxiIndexByVehicle(vehicleid);

	if (taxiIdx == -1)
	{
		return 0;
	}

	StopTaxiRide(playerid);

	// Picked up, so the way to the stop is not needed any more
	if (gTaxiPassenger[playerid][CalledStop] != -1)
	{
		gTaxiPassenger[playerid][CalledStop] = -1;

		// Unless a pizza delivery has taken the checkpoint over since
		if (!gPizzaMission[playerid][Active])
		{
			DisablePlayerCheckpoint(playerid);
		}
	}

	new
		stopid = GetTaxiNextStop(taxiIdx);

	// Not driving (yet), or none of its stops serves a property
	if (stopid == -1)
	{
		return 1;
	}

	gTaxiPassenger[playerid][RideTaxi] = taxiIdx;
	gTaxiPassenger[playerid][RideNextStop] = stopid;
	gTaxiPassenger[playerid][RideLastETA] = GetTaxiStopETA(stopid);
	gTaxiPassenger[playerid][RideTimer] = Timer: SetTimerEx("UpdateTaxiRide", TAXI_RIDE_TICK_MS, true, "i", playerid);

	SendClientMessageLocalized(playerid, I18N_TAXI_RIDE_WELCOME);
	SendTaxiNextStopMessage(playerid, stopid);

	return 1;
}

stock StopTaxiRide(playerid)
{
	if (gTaxiPassenger[playerid][RideTimer] != Timer: INVALID_TIMER)
	{
		KillTimer(_: gTaxiPassenger[playerid][RideTimer]);
		gTaxiPassenger[playerid][RideTimer] = Timer: INVALID_TIMER;
	}

	gTaxiPassenger[playerid][RideTaxi] = -1;
	gTaxiPassenger[playerid][RideNextStop] = -1;

	return 1;
}

stock ResetTaxiPassenger(playerid)
{
	gTaxiPassenger[playerid][CalledStop] = -1;

	return StopTaxiRide(playerid);
}

// Loads the taxi routes and the stops that serve a commercial property, each
// paired with the nearest one in range.
stock InitTaxiStops()
{
	new
		DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, "SELECT taxi_no, segment_no, duration_ms FROM taxi_tracks ORDER BY taxi_no, segment_no");

	if (!result)
	{
		print("Database error: cannot read taxi tracks data");

		return 0;
	}

	new
		durations[MAX_TAXI_DRIVERS][NUM_PLAYBACK_FILES],
		segments[MAX_TAXI_DRIVERS];

	if (DB_GetRowCount(result))
	{
		do
		{
			new
				taxiIdx = DB_GetFieldIntByName(result, "taxi_no"),
				segment = DB_GetFieldIntByName(result, "segment_no");

			if (taxiIdx < 0 || taxiIdx >= MAX_TAXI_DRIVERS || segment < 0 || segment >= NUM_PLAYBACK_FILES)
			{
				continue;
			}

			durations[taxiIdx][segment] = DB_GetFieldIntByName(result, "duration_ms");
			segments[taxiIdx]++;
		}
		while (DB_SelectNextRow(result));
	}

	DB_FreeResultSet(result);

	for (new i = 0; i < MAX_TAXI_DRIVERS; i++)
	{
		gTaxiLoopMs[i] = 0;
		gTaxiStopTotal[i] = 0;

		// Missing a segment, the taxi cannot be followed along its loop
		if (segments[i] != NUM_PLAYBACK_FILES)
		{
			printf("Taxi stops: no complete taxi_tracks for taxi %d, its stops are not loaded", i);
			continue;
		}

		for (new j = 0; j < NUM_PLAYBACK_FILES; j++)
		{
			gTaxiSegmentStart[i][j] = gTaxiLoopMs[i];
			gTaxiLoopMs[i] += durations[i][j];
		}
	}

	// MIN() picks the nearest property: SQLite takes the bare columns of an
	// aggregate query from the row that has the minimum
	new
		query[1024];

	format(query, sizeof(query), "SELECT s.taxi_no, s.segment_no, s.time_ms, s.duration_ms, s.x, s.y, s.z, s.rot, p.id AS property_id, p.name, c.primary_x AS property_x, c.primary_y AS property_y, MIN((c.primary_x - s.x) * (c.primary_x - s.x) + (c.primary_y - s.y) * (c.primary_y - s.y) + (c.primary_z - s.z) * (c.primary_z - s.z)) AS distance FROM taxi_stops AS s JOIN property_coords AS c ON c.type = %d JOIN properties AS p ON p.id = c.property_id AND p.type = %d WHERE ((c.primary_x - s.x) * (c.primary_x - s.x) + (c.primary_y - s.y) * (c.primary_y - s.y) + (c.primary_z - s.z) * (c.primary_z - s.z)) <= %.1f GROUP BY s.id ORDER BY s.taxi_no, s.segment_no, s.time_ms",
			_: OFFER_POINT,
			_: PROPERTY_TYPE_COMMERCIAL,
			TAXI_STOP_PROPERTY_RANGE * TAXI_STOP_PROPERTY_RANGE
		);

	result = DB_ExecuteQuery(gDbConnectionHandle, query);

	if (!result)
	{
		print("Database error: cannot read taxi stops data");
		print(query);

		return 0;
	}

	if (!DB_GetRowCount(result))
	{
		print("Database warning: no taxi stops to load");

		DB_FreeResultSet(result);
		return 0;
	}

	gTaxiStopCount = 0;

	do
	{
		if (gTaxiStopCount >= MAX_TAXI_STOPS)
		{
			print("Taxi stops: MAX_TAXI_STOPS reached, the rest is not loaded");
			break;
		}

		new
			taxiIdx = DB_GetFieldIntByName(result, "taxi_no"),
			segment = DB_GetFieldIntByName(result, "segment_no");

		if (taxiIdx < 0 || taxiIdx >= MAX_TAXI_DRIVERS || segment < 0 || segment >= NUM_PLAYBACK_FILES || !gTaxiLoopMs[taxiIdx])
		{
			continue;
		}

		new
			i = gTaxiStopCount,
			name[64];

		DB_GetFieldStringByName(result, "name", name, sizeof(name));

		// Rows come grouped by taxi, in the order it drives to them
		if (!gTaxiStopTotal[taxiIdx])
		{
			gTaxiFirstStop[taxiIdx] = i;
		}

		gTaxiStops[i][TaxiIdx] = taxiIdx;
		gTaxiStops[i][LoopMs] = (gTaxiSegmentStart[taxiIdx][segment] + DB_GetFieldIntByName(result, "time_ms")) % gTaxiLoopMs[taxiIdx];
		gTaxiStops[i][Duration] = DB_GetFieldIntByName(result, "duration_ms");
		gTaxiStops[i][PropertyID] = DB_GetFieldIntByName(result, "property_id");
		gTaxiStops[i][Name] = name;

		new
			Float: X = DB_GetFieldFloatByName(result, "x"),
			Float: Y = DB_GetFieldFloatByName(result, "y"),
			Float: rot = DB_GetFieldFloatByName(result, "rot"),
			// The cab's right-hand side (a heading of 0 faces north)
			Float: sideX = floatcos(rot, degrees),
			Float: sideY = floatsin(rot, degrees);

		// The property is on its left
		if ((DB_GetFieldFloatByName(result, "property_x") - X) * sideX + (DB_GetFieldFloatByName(result, "property_y") - Y) * sideY < 0.0)
		{
			sideX = -sideX;
			sideY = -sideY;
		}

		gTaxiStops[i][Curb][CoordX] = X + sideX * TAXI_STOP_CURB_OFFSET;
		gTaxiStops[i][Curb][CoordY] = Y + sideY * TAXI_STOP_CURB_OFFSET;
		gTaxiStops[i][Curb][CoordZ] = DB_GetFieldFloatByName(result, "z");

		gTaxiStopTotal[taxiIdx]++;
		gTaxiStopCount++;
	}
	while (DB_SelectNextRow(result));

	DB_FreeResultSet(result);

	printf("Taxi stops initialized: %d", gTaxiStopCount);

	return 1;
}
