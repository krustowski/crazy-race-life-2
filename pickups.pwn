// https://www.open.mp/docs/scripting/resources/pickuptypes
#define PICKUP_TYPE_NONE			0
#define PICKUP_TYPE_ALWAYS			1
#define PICKUP_TYPE_RESPAWN_30_SECONDS		2
#define PICKUP_TYPE_RESPAWN_AFTER_DEATH		3
#define PICKUP_TYPE_NO_RESPAWN			19 

//
//  Global static team objects.
//

new gAdminRoomHealth;

new gHackerzInteriorEntrance;
new gHackerzInteriorExit;
new gHackerzMoneyBag;

new gAdminDoorDown;
new gAdminDoorUp;

// ????
new picktunel;

// Drugz
new gHeroinPackage;
new gCocainePackage;

new gPlayerMoneyPickup[MAX_PLAYERS];
new gPlayerMoneyPickupAmount[MAX_PLAYERS];

new gPlayerWeaponPickup[MAX_PLAYERS];

//
//
//

public AddPlayerDeathPickups(playerid, Float:X, Float:Y, Float:Z)
{
	if (GetPlayerMoney(playerid) > 0)
	{
		gPlayerMoneyPickup[playerid] = CreatePickup(1212, 19, Float:X, Float:Y, Float:Z);
		gPlayerMoneyPickupAmount[playerid] = GetPlayerMoney(playerid);

		SendClientMessage(playerid, COLOR_ZLUTA, "[ i ] Tve penize zustaly na miste umrti!");
	}

	return 1;
}

public InitPickups()
{
	gAdminRoomHealth = CreatePickup(1240, 1, 2302.85, 1155.93, 85.94);

	gHackerzInteriorEntrance = CreatePickup(1318, 1, 2866.62, -2125.24, 5.72);
	gHackerzInteriorExit = CreatePickup(1318, 1, 2853.09, -2125.16, 0.19);
	gHackerzMoneyBag = CreatePickup(1550, 1, 2838.59, -2141.25, 0.19);

	// ???
	picktunel = CreatePickup(1318, 1, 2263.41, -755.52, 38.04);

	//------------------------
	//CreatePickup(1274, 1,2029.54, 1320.78, 10.82);
	//	CreatePickup(362, 1,2017.58,1338.44,10.82);

	//CreatePickup(xxx, 1, -1669.09, 1009.93, 7.75);

	gCocainePackage = CreatePickup(1575, 8, -2044.38, 975.56, 54.24);
	gHeroinPackage = CreatePickup(1580, 8, -1664.19, 1010.74, 7.49);

	//
	//
	//

	gTeamPickup[E_PLAYER_TEAM_LAME] = CreatePickup(1239, 1, 2252.11, 1285.30, 19.17);
	gTeamMenu[E_PLAYER_TEAM_LAME] = CreateMenu("Lamerz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_LAME], 0, "Lamka");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_LAME], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_ADMINZ] = CreatePickup(1239, 1, 2304.43, 1151.95, 85.94);
	gTeamMenu[E_PLAYER_TEAM_ADMINZ] = CreateMenu("Adminz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_ADMINZ], 0, "Admin borec");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_ADMINZ], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_POLICE] = CreatePickup(1239, 1, 229.4, 167.4, 1003.0);
	gTeamMenu[E_PLAYER_TEAM_POLICE] = CreateMenu("Police LV", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_POLICE], 0, "Policajt");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_POLICE], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_GASMAN] = CreatePickup(1239, 1, 2637.36, 1127.04, 11.18);
	gTeamMenu[E_PLAYER_TEAM_GASMAN] = CreateMenu("Benzina", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GASMAN], 0, "Benzinak");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GASMAN], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_DRAGSTER] = CreatePickup(1239, 1, 2620.14, 1195.76, 10.81);
	gTeamMenu[E_PLAYER_TEAM_DRAGSTER] = CreateMenu("Dragsterz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_DRAGSTER], 0, "DRaGsTeR");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_DRAGSTER], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_GARBAGE] = CreatePickup(1581, 1, 2892.8, -2127.9, 3.2);
	gTeamMenu[E_PLAYER_TEAM_GARBAGE] = CreateMenu("Garbage men", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GARBAGE], 0, "Tulak");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_GARBAGE], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_PIZZABOY] = CreatePickup(1581, 1, 2101.70, -1810.05, 13.55);
	gTeamMenu[E_PLAYER_TEAM_PIZZABOY] = CreateMenu("Pizzaboyz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PIZZABOY], 0, "Pizza boy");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PIZZABOY], 0, "Opustit tym");

	gTeamPickup[E_PLAYER_TEAM_HACKER] = CreatePickup(1581, 1, 2838.10, -2130.26, 0.19);
	gTeamMenu[E_PLAYER_TEAM_HACKER] = CreateMenu("Hackerz",  1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_HACKER], 0, "Hacker");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_HACKER], 0, "Opustit tym");

	//gTeamPickup[E_PLAYER_TEAM_CAR_REPAIR] = CreatePickup(1581,1, );
	gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR] = CreateMenu("Servicemen", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR], 0, "Technik");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_CAR_REPAIR], 0, "Opustit tym");

	//gTeamPickup[E_PLAYER_TEAM_PYRO] = CreatePickup(1581,1, );
	gTeamMenu[E_PLAYER_TEAM_PYRO] = CreateMenu("Pyroz", 1, 150.0, 100.0, 250.0, 150.0);
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PYRO], 0, "Pyrotechnik");
	AddMenuItem(gTeamMenu[E_PLAYER_TEAM_PYRO], 0, "Opustit tym");
}
