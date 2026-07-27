#if defined _CRL2_NPCS
	#endinput
#endif
#define _CRL2_NPCS

#define DEBUG                   false
#define ENABLE_NPC_MARKER       false

#define NUM_PLAYBACK_FILES      10
#define DRIVER_SEAT             0

#define MAX_TAXI_DRIVERS        16
#define TAXI_VEHICLE_ID         420
#define TAXI_NPC_SKIN           7

#define MAX_TRUCK_DRIVERS       2
#define TRUCK_VEHICLE_ID        515
#define PETROL_VEHICLE_ID       584
#define TRUCK_NPC_SKIN          7

#define MAX_RACE_DRIVERS        2
#define RACE_VEHICLE_ID         503
#define RACE_NPC_SKIN           7

#if ENABLE_NPC_MARKER
	#define RACE_NPC_MARKER_COLOR 0xFF6347FF
	#define TAXI_NPC_MARKER_COLOR 0xFF6347FF
	#define TRUCK_NPC_MARKER_COLOR 0xFF6347FF
#else
	#define RACE_NPC_MARKER_COLOR 0x00000000
	#define TAXI_NPC_MARKER_COLOR 0x00000000
	#define TRUCK_NPC_MARKER_COLOR 0x00000000
#endif

new
    gRaceDriverNPC[MAX_RACE_DRIVERS],
    gRaceVehicle[MAX_RACE_DRIVERS],
    gRacePlaybackNo[MAX_TRUCK_DRIVERS],
    bool: gRacePlaybackStarted[MAX_RACE_DRIVERS];

new 
    gTaxiDriverNPC[MAX_TAXI_DRIVERS],						
    gTaxiVehicle[MAX_TAXI_DRIVERS],
    gTaxiPlaybackNo[MAX_TAXI_DRIVERS],		
    bool: gTaxiPlaybackStarted[MAX_TAXI_DRIVERS];

new
    gTruckDriverNPC[MAX_TRUCK_DRIVERS],
    gTruckVehicle[MAX_TRUCK_DRIVERS],
    gTruckTrailer[MAX_TRUCK_DRIVERS],
    gTruckPlaybackNo[MAX_TRUCK_DRIVERS],
    bool: gTruckPlaybackStarted[MAX_TRUCK_DRIVERS];

new const Float:gRaceSpawnData[][4] = {
    {-2005.57, 320.18, 35.01, 199.93},
    {-2017.07, -2499.41, 32.53, 177.06}
};

new const Float:gTaxiSpawnData[][4] = {
	// X, Y, Z, Angle
    {-1987.08, 300.95, 35.17, 271.88},
    {-2266.39, 109.63, 34.95, 359.94},
    {-2645.32, 1375.58, 6.94, 119.84},
    {-1655.95, 1314.34, 6.81, 359.94},
    {-1411.08, -307.42, 13.84, 48.95},
    {-1971.01, -862.53, 31.89, 359.93},
    {2185.70, 2004.40, 10.59, 359.00},
    {1015.44, 1155.16, 10.26, 268.99},
    {1392.62, 2609.09, 10.52, 110.80},
    {2102.26, 2036.72, 10.59, 46.12},
    {2231.93, 1235.95, 10.53, 258.99},
    {925.35, -964.34, 38.00, 172.99},
    {847.62, -1331.74, 13.35, 225.46},
    {2632.97, -1042.54, 69.23, 0.80},
    {1788.09, -1935.08, 13.19, 0.38},
    {1644.48, -2249.08, 13.24, 53.99}
};

new const Float:gTruckSpawnData[][2][4] = {
    {
        {-2014.98, 128.32, 27.68, 180.47},
        {-2014.13, 139.07, 27.68, 179.28}
    },
    {
        {1438.72, 409.67, 19.88, 250.61},
        {1431.18, 412.63, 19.90, 245.01}
    }
};

stock GetRaceIndexByNPC(npcid)
{
	for (new i = 0; i < MAX_RACE_DRIVERS; i++)
	{
		if (gRaceDriverNPC[i] == npcid)
        {
			return i;
	    }
    }

	return -1;
}

stock GetTaxiIndexByNPC(npcid)
{
	for (new i = 0; i < MAX_TAXI_DRIVERS; i++)
	{
		if (gTaxiDriverNPC[i] == npcid)
        {
			return i;
	    }
    }

	return -1;
}

stock GetTruckIndexByNPC(npcid)
{
	for (new i = 0; i < MAX_TRUCK_DRIVERS; i++)
	{
		if (gTruckDriverNPC[i] == npcid)
        {
			return i;
	    }
    }

	return -1;
}

stock InitNPCs()
{
    print("*** NPC_TAXI Filtrescript loaded!");

	// Create all taxi vehicles and NPCs

    for (new i = 0; i < MAX_RACE_DRIVERS; i++)
    {
        gRaceVehicle[i] = CreateVehicle(
            RACE_VEHICLE_ID, 
            gRaceSpawnData[i][0], 
            gRaceSpawnData[i][1], 
            gRaceSpawnData[i][2], 
            gRaceSpawnData[i][3], 
            -1, -1, -1
        );

        new
            npcname[MAX_PLAYER_NAME];
        format(npcname, sizeof(npcname), "[NPC]race_drv%d", i);
        gRaceDriverNPC[i] = NPC_Create(npcname);

        gRacePlaybackStarted[i] = false;
    }

    for (new i = 0; i < MAX_TAXI_DRIVERS; i++)
	{
        gTaxiVehicle[i] = AddStaticVehicleEx(
            TAXI_VEHICLE_ID,
            gTaxiSpawnData[i][0],  // X
            gTaxiSpawnData[i][1],  // Y
            gTaxiSpawnData[i][2],  // Z
            gTaxiSpawnData[i][3],  // Angle
            -1, -1, -1
        );

        new
            npcname[MAX_PLAYER_NAME];
        format(npcname, sizeof(npcname), "[NPC]taxi_drv%d", i);
        gTaxiDriverNPC[i] = NPC_Create(npcname);

		// Initialize playback tracking
        gTaxiPlaybackStarted[i] = false;
	}

    for (new i = 0; i < MAX_TRUCK_DRIVERS; i++)
	{
        gTruckVehicle[i] = AddStaticVehicleEx(
            TRUCK_VEHICLE_ID,
            gTruckSpawnData[i][0][0],  // X
            gTruckSpawnData[i][0][1],  // Y
            gTruckSpawnData[i][0][2],  // Z
            gTruckSpawnData[i][0][3],  // Angle
            -1, -1, -1
        );

        gTruckTrailer[i] = AddStaticVehicleEx(
            PETROL_VEHICLE_ID,
            gTruckSpawnData[i][1][0],  // X
            gTruckSpawnData[i][1][1],  // Y
            gTruckSpawnData[i][1][2],  // Z
            gTruckSpawnData[i][1][3],  // Angle
            -1, -1, -1
        );

        new
            npcname[MAX_PLAYER_NAME];
        format(npcname, sizeof(npcname), "[NPC]truck_drv%d", i);
        gTruckDriverNPC[i] = NPC_Create(npcname);

        // Initialize playback tracking
        gTruckPlaybackStarted[i] = false;
    }

    return 1;
}

// public OnFilterScriptExit()
// {
// 	// Destroy all train NPCs and vehicles
// 	for (new i = 0; i < MAX_TAXI_DRIVERS; i++)
// 	{
// 		if (NPC_IsValid(gTaxiDriverNPC[i]))
//         {
// 			NPC_Destroy(gTaxiDriverNPC[i]);
//         }

// 		if (gTaxiVehicle[i] != INVALID_VEHICLE_ID)
//         {
// 			DestroyVehicle(gTaxiVehicle[i]);
// 	    }
//     }

//     print("*** NPC_TAXI Filtrescript unloaded!");

// 	return 1;
// }

forward Race_SpawnNPC(npcid);
public Race_SpawnNPC(npcid)
{
	new raceIdx = GetRaceIndexByNPC(npcid);

	if (raceIdx != -1)
	{
		// Set spawn position before spawning
		NPC_SetPos(npcid, gRaceSpawnData[raceIdx][0], gRaceSpawnData[raceIdx][1], gRaceSpawnData[raceIdx][2]);
		NPC_SetFacingAngle(npcid, gRaceSpawnData[raceIdx][3]);
		NPC_SetSkin(npcid, RACE_NPC_SKIN);

		// Spawn the NPC so OnNPCSpawn gets called
		NPC_Spawn(npcid);
	}
}

forward Taxi_SpawnNPC(npcid);
public Taxi_SpawnNPC(npcid)
{
	// Find which taxi this NPC belongs to
	new taxiIdx = GetTaxiIndexByNPC(npcid);

	if (taxiIdx != -1)
	{
		// Set spawn position before spawning
		NPC_SetPos(npcid, gTaxiSpawnData[taxiIdx][0], gTaxiSpawnData[taxiIdx][1], gTaxiSpawnData[taxiIdx][2]);
		NPC_SetFacingAngle(npcid, gTaxiSpawnData[taxiIdx][3]);
		NPC_SetSkin(npcid, TAXI_NPC_SKIN);

		// Spawn the NPC so OnNPCSpawn gets called
		NPC_Spawn(npcid);

		// #if TRAIN_DEBUG
		// printf("[TRAIN NPC]: Spawning train %s (ID: %d)", TrainStationNames[trainIdx], npcid);
		// #endif
	}
}

forward Truck_SpawnNPC(npcid);
public Truck_SpawnNPC(npcid)
{
	// Find which truck this NPC belongs to
	new truckIdx = GetTruckIndexByNPC(npcid);

	if (truckIdx != -1)
	{
        // Set spawn position before spawning
        NPC_SetPos(npcid, gTruckSpawnData[truckIdx][0][0], gTruckSpawnData[truckIdx][0][1], gTruckSpawnData[truckIdx][0][2]);
        NPC_SetFacingAngle(npcid, gTruckSpawnData[truckIdx][0][3]);
        NPC_SetSkin(npcid, TRUCK_NPC_SKIN);

        // Spawn the NPC so OnNPCSpawn gets called
        NPC_Spawn(npcid);

		// #if TRAIN_DEBUG
		// printf("[TRAIN NPC]: Spawning train %s (ID: %d)", TrainStationNames[trainIdx], npcid);
		// #endif
	}
}

forward Race_StartInitialPlayback(npcid);
public Race_StartInitialPlayback(npcid)
{
	new raceIdx = GetRaceIndexByNPC(npcid);

	if (raceIdx != -1 && !gRacePlaybackStarted[raceIdx])
	{
        new
            playbackName[64];
        format(playbackName, sizeof(playbackName), "NPC_TRACK_RACE_%02d_0", raceIdx);

        NPC_StartPlayback(npcid, playbackName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        gRacePlaybackNo[raceIdx] = 1;
        gRacePlaybackStarted[raceIdx] = true;
	}
}

forward Taxi_StartInitialPlayback(npcid);
public Taxi_StartInitialPlayback(npcid)
{
	// Find which taxi this NPC belongs to
	new taxiIdx = GetTaxiIndexByNPC(npcid);

	if (taxiIdx != -1 && !gTaxiPlaybackStarted[taxiIdx])
	{
		// Each train starts with its own first recording
		//NPC_StartPlayback(npcid, gTaxiRecordings[taxiIdx], false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        new
            playbackName[64];
        format(playbackName, sizeof(playbackName), "NPC_TRACK_TAXI_%02d_0", taxiIdx);

        NPC_StartPlayback(npcid, playbackName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        gTaxiPlaybackNo[taxiIdx] = 1;
        gTaxiPlaybackStarted[taxiIdx] = true;

		// #if TRAIN_DEBUG
		// printf("[TRAIN NPC]: Train %s started initial playback", TrainStationNames[trainIdx]);
		// #endif
	}
}

forward Truck_StartInitialPlayback(npcid);
public Truck_StartInitialPlayback(npcid)
{
	// Find which truck this NPC belongs to
	new truckIdx = GetTruckIndexByNPC(npcid);

	if (truckIdx != -1 && !gTruckPlaybackStarted[truckIdx])
	{
        new
            playbackName[64];
        format(playbackName, sizeof(playbackName), "NPC_TRACK_TRUCK_%02d_0", truckIdx);

        NPC_StartPlayback(npcid, playbackName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        gTruckPlaybackNo[truckIdx] = 1;
        gTruckPlaybackStarted[truckIdx] = true;
	}
}

stock RaceNPC_StartNextPlayback(npcid)
{
    new 
        raceIdx = GetRaceIndexByNPC(npcid);
    if (raceIdx == -1) 
    {
        return;
    }

    if (gRacePlaybackNo[raceIdx] >= 1)
    {
	    gRacePlaybackNo[raceIdx] = 0;
    }

    new
        playbackFileName[64];
    format(playbackFileName, sizeof(playbackFileName), "NPC_TRACK_RACE_%02d_%d", raceIdx, gRacePlaybackNo[raceIdx]);

    NPC_StartPlayback(npcid, playbackFileName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

    gRacePlaybackNo[raceIdx]++;
}

stock TaxiNPC_StartNextPlayback(npcid)
{
    new 
        taxiIdx = GetTaxiIndexByNPC(npcid);
    if (taxiIdx == -1) 
    {
        return;
    }

    if (gTaxiPlaybackNo[taxiIdx] >= NUM_PLAYBACK_FILES)
    {
	    gTaxiPlaybackNo[taxiIdx] = 0;
    }

    new
        playbackFileName[64];
    format(playbackFileName, sizeof(playbackFileName), "NPC_TRACK_TAXI_%02d_%d", taxiIdx, gTaxiPlaybackNo[taxiIdx]);

    NPC_StartPlayback(npcid, playbackFileName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

	// #if TRAIN_DEBUG
	// printf("[TRAIN NPC]: Train %s -> next segment (recording: %s)",
	// 	TrainStationNames[trainIdx], TrainRecordings[recordingIdx]);
	// #endif

    gTaxiPlaybackNo[taxiIdx]++;
}

stock TruckNPC_StartNextPlayback(npcid)
{
    new
        truckIdx = GetTruckIndexByNPC(npcid);
    if (truckIdx == -1)
    {
        return;
    }

    if (gTruckPlaybackNo[truckIdx] >= NUM_PLAYBACK_FILES)
    {
	    gTruckPlaybackNo[truckIdx] = 0;
    }

    new
        playbackFileName[64];
    format(playbackFileName, sizeof(playbackFileName), "NPC_TRACK_TRUCK_%02d_%d", truckIdx, gTruckPlaybackNo[truckIdx]);

    NPC_StartPlayback(npcid, playbackFileName, false, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

	// #if TRAIN_DEBUG
	// printf("[TRAIN NPC]: Train %s -> next segment (recording: %s)",
	// 	TrainStationNames[trainIdx], TrainRecordings[recordingIdx]);
	// #endif

    gTruckPlaybackNo[truckIdx]++;
}