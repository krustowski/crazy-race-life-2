// 
//  Real Estate stuff.
//

#define MAX_PROPERTIES		128
#define MAX_PLAYER_PROPERTIES	3

enum Property
{
	ID,
	Label[64],
	Cost,

	Objects[5],
	Menu[5],
	Pickups[5]
}

// The structure of the object+pickups system shown to a player when entering a house.
// Those references are set for the elements to be destroyed afterwards (when player leaves).
enum PlayerPropertyObject
{
	
}

new gProperties[MAX_PROPERTIES][Property];

public InitRealEstateProperties()
{
	/*for (new i = 0; i < MAX_DRUGS; i++)
	{
		gPlayers[playerid][Drugs][i] = readcfgvalue(gPlayers[playerid][Name], "drugz", gDrugz[i][DrugIniName]);
	}*/

}
