// 
//  Real Estate stuff.
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	3

enum 
{
	PICKUP_OFFER,
	PICKUP_ENTRANCE,
	PICKUP_EXIT,
	PICKUP_HEALTH,
	PICKUP_PILL,
	PICKUP_INFO
}

enum Coords
{
Float: CoordX,
       Float: CoordY,
       Float: CoordZ
}

enum Property
{
	ID,
	Label[64],
	Cost,
	LocationOffer[Coords],
	LocationEntrance[Coords],
	bool:Occupied,

	Objects[5],
	Menu[5],
	Pickups[6]
}

// The structure of the object+pickups system shown to a player when entering a house.
// Those references are set for the elements to be destroyed afterwards (when player leaves).
enum PlayerPropertyObject
{
	Objects[2],
	Pickups[4]
}

new gPlayerInteriors[MAX_PLAYERS][PlayerPropertyObject];

//
//
//

new gPropertySF0101[Property] =
{
	10101,
	"SF The Very First House for Sell",
	1500000,
	{-2685.81, 201.33, 4.33},
	{-2688.66, 198.50, 7.15},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},

// El Quebrados
gPropertyDE0101[Property] = 
{
	20101,
	"El Quebrados prop no. 1",
	750000,
	{-1469.00, 2686.69, 55.83},
	{-1466.22, 2693.31, 56.26},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0102[Property] = 
{
	20102,
	"El Quebrados prop no. 2",
	650000,
	{-1482.20, 2698.43, 55.83},
	{-1482.59, 2702.20, 56.25},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0103[Property] = 
{
	20103,
	"El Quebrados prop no. 3",
	600000,
	{-1491.39, 2685.03, 55.85},
	{-1491.39, 2685.03, 55.85},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0104[Property] = 
{
	20104,
	"El Quebrados prop no. 4",
	600000,
	{-1554.95, 2692.75, 55.84},
	{-1550.51, 2699.88, 56.26},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyDE0105[Property] = 
{
	20105,
	"El Quebrados prop no. 5",
	900000,
	{-1600.46, 2679.16, 55.10},
	{-1603.47, 2689.46, 55.28},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0101[Property] = 
{
	50101,
	"Trailer park no. 1",
	900000,
	{-1600.46, 2679.16, 55.10},
	{-1603.47, 2689.46, 55.28},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	// Trailer park btw LS/SF
	gPropertyOT0102[Property] = 
{
	50102,
	"Trailer park no. 2",
	900000,
	{755.21, 378.67, 23.17},
	{758.40, 375.05, 23.19},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0103[Property] = 
{
	50103,
	"Trailer park no. 3",
	900000,
	{800.38, 360.85, 19.39},
	{804.85, 359.52, 19.76},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0104[Property] = 
{
	501004,
	"Trailer park no. 4",
	900000,
	{767.57, 346.78, 19.99},
	{771.79, 347.46, 20.15},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0105[Property] = 
{
	50105,
	"Trailer park no. 5",
	900000,
	{751.35, 270.73, 27.12},
	{748.03, 277.72, 27.22},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	gPropertyOT0106[Property] = 
{
	50106,
	"El Quebrados prop no. 5",
	900000,
	{752.73, 261.89, 27.08},
	{748.40, 257.87, 27.08},
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
},
	// LS
	gPropertyLS0101[Property] = 
{
	40101,
	"LS Vinewood Ville",
	2000000,
	false,
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1},
	{-1, -1, -1, -1, -1, -1}
};

//

new gProperties[MAX_PROPERTIES][Property];

public InitRealEstateProperties()
{
	gProperties[0] = gPropertySF0101;
	gProperties[1] = gPropertyDE0101;
	gProperties[2] = gPropertyDE0102;
	gProperties[3] = gPropertyDE0103;
	gProperties[4] = gPropertyDE0104;
	gProperties[5] = gPropertyDE0105;

	for (new i = 0; i < MAX_PROPERTIES; i++)
	{
		if (!gProperties[i][ID])
			continue;

		if (!gProperties[i][Occupied])
			gProperties[i][Pickups][0] = CreatePickup(1273, 1, Float:gProperties[i][LocationOffer][CoordX], Float:gProperties[i][LocationOffer][CoordY], Float:gProperties[i][LocationOffer][CoordZ]);
		else
			gProperties[i][Pickups][0] = CreatePickup(1318, 1, Float:gProperties[i][LocationEntrance][CoordX], Float:gProperties[i][LocationEntrance][CoordY], Float:gProperties[i][LocationEntrance][CoordZ]);
	}
}

public IsPlayerOwner(playerid, property[Property])
{
	for (new i = 0; i < MAX_PLAYER_PROPERTIES; i++)
	{
		if (gPlayers[playerid][Properties][i] == property[ID])
			return true;
	}

	return false;
}
