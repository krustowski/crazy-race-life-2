#if defined _CRL2_RESPONSE
	#endinput
#endif
#define _CRL2_RESPONSE

//
//  response.pwn
//  Custom responses mapped to dialogs
//

stock HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_UNUSED: 
			return 1; // Useful for dialogs that contain only information and we do nothing depending on whether they responded or not

		case DIALOG_LOGIN:
			{
				if (!response) 
				{
					return Kick(playerid);
				}

				if (SetPlayerAccountLogin(playerid, inputtext))
				{
					//return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "Logged in successfully!", "Ok", "");
					return 1;
				}

				gPlayers[playerid][LoginAttempts]++;

				if (gPlayers[playerid][LoginAttempts] >= 3)
				{
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "Failed to enter the password (3 times).", "Ok", "");
					Kick(playerid);
				}
				else 
				{
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nEnter a valid password please!", "Login", "Cancel");
				}

				return 1;
			}
		case DIALOG_REGISTER:
			{
				if (!response) 
				{
					return Kick(playerid);
				}

				if (strlen(inputtext) <= 5) 
				{
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Enter a password longer than 5 characters!", "Register", "Cancel");
				}

				if (SetPlayerAccountRegistration(playerid, inputtext))
				{
					return 1;
				}

				return 1;
			}
		case DIALOG_PROPERTY_BUY:
			{
				if (!response)
				{
					return 1;
				}

				BuyPlayerProperty(playerid, strval(inputtext));

				return 1;
			}
		case DIALOG_PROPERTY_RENT:
			{
				if (!response)
				{
					return 1;
				}

				return RentProperty(playerid, strval(inputtext));
			}
		case DIALOG_PROPERTY_SELL:
			{
				if (!response)
				{
					return 1;
				}

				SellPlayerProperty(playerid, strval(inputtext));

				return 1;
			}
		case DIALOG_PROPERTY_DRUGZ:
			{
				if (!response)
				{
					return 1;
				}

				if (!strlen(inputtext))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ DRUGZ ] Invalid option.");
				}

				// Save to the temporary user's var.
				gPlayers[playerid][SelectedDrugID] = listitem;

				ShowPlayerDialog(playerid, DIALOG_PROPERTY_DRUGZ_TRANS, DIALOG_STYLE_LIST, "Drugz", "Deposit at home\nWithdraw the whole amount", "Confirm", "Cancel");

				return 1;
			}
		case DIALOG_PROPERTY_DRUGZ_TRANS:
			{
				if (!response)
				{
					return 1;
				}

				new drugID = gPlayers[playerid][SelectedDrugID], propertyID = gPlayerInteriors[playerid][PropertyArrayID];

				switch (listitem)
				{
					case 0:
						{
							// Save all at home
							gProperties[propertyID][Drugs][drugID] += gPlayers[playerid][Drugs][drugID];
							gPlayers[playerid][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Saved at home");
						}
					case 1:
						{
							// Withdraw all to pockets
							gPlayers[playerid][Drugs][drugID] += gProperties[propertyID][Drugs][drugID];
							gProperties[propertyID][Drugs][drugID] = 0;

							SendClientMessage(playerid, COLOR_ORANGE, "[ DRUGZ ] Saved to your pockets");
						}
				}

				return 1;
			}
		case DIALOG_PROPERTY_EDIT_MAIN:
			{
				if (!response)
				{
					gPropertyEdit[playerid] = gNullProperty;
					gPlayers[playerid][EditingMode] = false;

					SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Property edit cancelled.");
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Name
						{
							ShowPropertyEditDialogName(playerid);
						}
					case 1:
						// Type
						{
							ShowPropertyEditDialogType(playerid);
						}
					case 2:
						// Cost
						{
							ShowPropertyEditDialogCost(playerid);
						}
					case 3:
						// Spawn point coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_SPAWN_POINT;
							SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record spawn coords using the KEY_NO (N) key.");
						}
					case 4:
						// Entrance pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_ENTRANCE_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record entrance coords using the KEY_NO (N) key.");
						}
					case 5:
						// Offer pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_OFFER_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record offer coords using the KEY_NO (N) key.");
						}
					case 6:
						// Money pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_MONEY_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record money coords using the KEY_NO (N) key.");
						}
					case 7:
						// Shirt pickup coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_SHIRT_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record shirt coords using the KEY_NO (N) key.");
						}
					case 8:
						// Vehicle coords
						{
							gPropertyEdit[playerid][EditingMode] = PREDIT_VEHICLE_POINT;
							SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Record vehicle coords using the KEY_NO (N) key.");
						}
					case 9:
						// Occupied state
						{
							gPropertyEdit[playerid][Occupied] = !gPropertyEdit[playerid][Occupied];
							SendClientMessage(playerid, COLOR_GREEN, "[ EDIT ] Occupied state of the property toggled");

							ShowPropertyEditDialogMain(playerid);
						}
					case 10:
						// Custom interior state
						{
							gPropertyEdit[playerid][CustomInterior] = !gPropertyEdit[playerid][CustomInterior];
							SendClientMessage(playerid, COLOR_GREEN, "[ EDIT ] Custom interior state of the property toggled");

							ShowPropertyEditDialogMain(playerid);
						}
					case 11:
						// Save property
						{
							EditProperty(playerid);
						}
				}

				return 1;
			}
		case DIALOG_PROPERTY_EDIT_NAME:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				new label[64];
				format(label, sizeof(label), "%s", inputtext);

				gPropertyEdit[playerid][Label] = label;
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property name changed!");

				ShowPropertyEditDialogMain(playerid);
				return 1;
			}
		case DIALOG_PROPERTY_EDIT_TYPE:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				switch (listitem)
				{
					case 0:
						// Personal
						{
							gPropertyEdit[playerid][Type] = PROPERTY_TYPE_PERSONAL;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property type set to personal!");
						}
					case 1:
						// Commercial
						{
							gPropertyEdit[playerid][Type] = PROPERTY_TYPE_COMMERCIAL;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property type set to commercial!");
						}
				}

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_EDIT_COST:
			{
				if (!response)
				{
					return ShowPropertyEditDialogMain(playerid);
				}

				if (!IsNumeric(inputtext))
				{
					SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Invalid value!");

					ShowPropertyEditDialogMain(playerid);
					return 1;
				}

				gPropertyEdit[playerid][Cost] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property cost changed!");

				ShowPropertyEditDialogMain(playerid);
				return 1;
			}
		case DIALOG_PROPERTY_EDITOR_LIST_PER:
			{
				if (!response)
				{
					return 1;
				}

				gPlayers[playerid][EditingMode] = true;
				gPropertyEdit[playerid][ID] = gProperties[listitem][ID];
				gPropertyEdit[playerid][Type] = PROPERTY_TYPE_PERSONAL;

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_EDITOR_LIST_COM:
			{
				if (!response)
				{
					return 1;
				}

				gPlayers[playerid][EditingMode] = true;
				gPropertyEdit[playerid][ID] = gProperties[listitem][ID];
				gPropertyEdit[playerid][Type] = PROPERTY_TYPE_COMMERCIAL;

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_PROPERTY_LIST:
			{
				if (!response)
				{
					return 1;
				}

				new propertyid = gPlayers[playerid][Properties][listitem];

				if (!propertyid)
				{
					return 1;
				}

				gPlayers[playerid][PropertyOwnedID] = propertyid;

				ShowPropertyOptionsDialog(playerid);

				return 1;
			}
		case DIALOG_PROPERTY_OPTIONS:
			{
				if (!response)
				{
					gPlayers[playerid][PropertyOwnedID] = 0;
					return 1;
				}

				new propertyid = gPlayers[playerid][PropertyOwnedID];

				switch (listitem)
				{
					// Spawn point setup
					case 0:
						{
							SetSpawnPointAtProperty(playerid, propertyid);
						}
						// New vehicle attachment
					case 1:
						{
							AttachVehicleToProperty(playerid, propertyid);
						}
						// Respawn attached car
					case 2: 
						{
							RespawnPropertyVehicle(playerid, propertyid);
						}
						// Property selling
					case 3: 
						{
							SellPlayerProperty(playerid, propertyid);
						}
				}

				return 1;
			}
		case DIALOG_BANK_OPTIONS:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					// Deposit
					case 0:
						{
							gPlayers[playerid][DialogShown] = true;
							return ShowBankDepositDialog(playerid);
						}
					case 1:
						{
							gPlayers[playerid][DialogShown] = true;
							return ShowBankWithdrawDialog(playerid);
						}
					case 2: 
						{
							new stringToPrint[256];

							format(stringToPrint, sizeof(stringToPrint), "[ ATM ] Account balance: $%d!", gPlayers[playerid][Bank]);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

							gPlayers[playerid][DialogShown] = false;
							return 1;
						}
				}
			}
		case DIALOG_BANK_DEPOSIT:
			{
				if (!response || !IsNumeric(inputtext) || !strval(inputtext))
				{
					gPlayers[playerid][DialogShown] = false;
					return 1;
				}

				DepositMoneyToBankAccount(playerid, strval(inputtext));
				gPlayers[playerid][DialogShown] = false;

				return 1;

			}
		case DIALOG_BANK_WITHDRAW:
			{
				if (!response || !IsNumeric(inputtext) || !strval(inputtext))
				{
					gPlayers[playerid][DialogShown] = false;
					return 1;
				}

				WithdrawMoneyFromBankAccount(playerid, strval(inputtext));
				gPlayers[playerid][DialogShown] = false;

				return 1;

			}
		case DIALOG_RACE_LIST:
			{
				if (!response)
				{
					return 1;
				}

				SetPlayerRaceState(playerid, listitem + 1);

				if (!gPlayerRace[playerid][listitem + 1])
				{
					return 1;
				}

				/*if (!CheckPlayerRaceState(playerid))
				  return 1;*/

				if (SetPlayerRaceStartPos(playerid))
				{
					return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ RACE ] Warp near the race start used successfully");
				}

				return 1;
			}
		case DIALOG_RACE_OPTIONS:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							ResetPlayerRaceState(playerid, 0, false);
						}
				}

				return 1;
			}
		case DIALOG_PORT_LIST: 
			{
				if (!response)
				{
					return 1;
				}

				if (IsPlayerInAnyVehicle(playerid))
				{
					RemovePlayerFromVehicle(playerid);
				}

				switch (listitem)
				{
					case 0:
						{
							SetPlayerInterior(playerid, 0);
							SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Las Venturas Escalators");
						}
					case 1:
						{
							SetPlayerInterior(playerid, 0);
							SetPlayerPos(playerid, -1951.58, 296.77, 41.04);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] San Fierro WangCars");
						}
					case 2:
						{
							SetPlayerInterior(playerid, 0);
							SetPlayerPos(playerid, 1896.13, -2393.53, 13.11);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Los Santos Airport");
						}
					case 3: 
						{
							SetPlayerInterior(playerid, 0);
							SetPlayerPos(playerid, -2366.65, 1538.78, 2.11);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] San Fierro Ship Parkour Park");
						}
					case 4: 
						{
							SetPlayerInterior(playerid, 0);
							SetPlayerPos(playerid, -281.000000, 2170.899900, 112.100000);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Bone County Parkour Park");
						}
					case 5: 
						{
							//SetCombatMission(playerid, 2);
							SendClientMessage(playerid, COLOR_YELLOW, "[ PORT ] Combat #2 (disabled)");
						}
				}

				return 1;
			}
		case DIALOG_GET_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return MovePlayerToPlayer(playerid, listitem, true);
			}
		case DIALOG_GOTO_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return MovePlayerToPlayer(playerid, listitem, false);
			}
		case DIALOG_PLAYER_CLICKED_LIST:
			{
				if (!response)
				{
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessageLocalized(playerid, I18N_PLAYER_NOT_CONNECTED);
				}

				switch (listitem)
				{
					case 0:
						// Set HP
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							SetPlayerHealth(clickedplayerid, 100.0);
							SetPlayerArmour(clickedplayerid, 100.0);

							SendClientMessage(clickedplayerid, COLOR_LIGHTGREEN, "[ HP ] Health: 100.0, Armour: 100.0");
						}
					case 1:
						// Install nitro
						{
							SetPlayerVehicleNitro(playerid, clickedplayerid);
						}
					case 2:
						// Get the player (port)
						{
							MovePlayerToPlayer(playerid, clickedplayerid, true);
						}
					case 3:
						// Goto player (port)
						{
							MovePlayerToPlayer(playerid, clickedplayerid, false);
						}
					case 4:
						// Set skin ID
						{
							ShowPlayerSkinIDSetDialog(playerid);
						}
					case 5:
						// Set drunk drunk level
						{
							ShowPlayerDrunkLevelSetDialog(playerid);
						}
					case 6:
						// Kick from server
						{
							new adminName[MAX_PLAYER_NAME], kickedName[MAX_PLAYER_NAME], stringToPrint[128];

							GetPlayerName(playerid, adminName, sizeof(adminName));
							GetPlayerName(clickedplayerid, kickedName, sizeof(kickedName));

							format(stringToPrint, sizeof(stringToPrint), "[ KICK ] Admin %s [ID: %d] kicked player %s [ID: %d] from server! ", adminName, playerid, kickedName, clickedplayerid);

							SendClientMessageToAll(COLOR_YELLOW, stringToPrint);
							Kick(clickedplayerid);
						}
					case 7:
						// Packet loss
						{
							new 
								Float: loss = 0.0, 
								stringToPrint[128];

							GetPlayerPacketLoss(clickedplayerid, loss);

							format(stringToPrint, sizeof(stringToPrint), "[ NET ] Player ID: %d, packet loss: %.2f %%", clickedplayerid, loss);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);
						}
					case 8:
						// Reset cach money
						{
							ResetPlayerMoney(clickedplayerid);
						}
					case 9:
						// Spectate
						{
							if (gPlayers[playerid][Spectating])
							{
								TogglePlayerSpectating(playerid, false);

								gPlayers[playerid][Spectating] = false;
								return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode disabled!");
							}

							if (playerid == clickedplayerid)
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Invalid player!");
							}

							TogglePlayerSpectating(playerid, true);
							PlayerSpectatePlayer(playerid, clickedplayerid);

							gPlayers[playerid][Spectating] = true;
							return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ SPECTATE ] Mode enabled!");
						}
					case 10:
						// Give weapons
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							GivePlayerWeapon(clickedplayerid, t_WEAPON: 26, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 28, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 31, 400);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 43, 1);
							GivePlayerWeapon(clickedplayerid, t_WEAPON: 46, 1);

							SendClientMessage(clickedplayerid, COLOR_ORANGE, "[ WEAPON ] Received a weapons pack");
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Weapons sent");
						}
					case 11:
						// Give a specific weapon
						{
							if (gDeathmatch[clickedplayerid][IsRegistered] || gDeathmatch[clickedplayerid][InGame])
							{
								return SendClientMessage(playerid, COLOR_RED, "[ ! ] Target ID is playing a minigame!");
							}

							ShowPlayerGiveWeaponDialog(playerid);
						}
					case 12:
						// Ban
						{
							new adminName[MAX_PLAYER_NAME], bannedName[MAX_PLAYER_NAME], stringToPrint[128];

							GetPlayerName(playerid, adminName, sizeof(adminName));
							GetPlayerName(clickedplayerid, bannedName, sizeof(bannedName));

							format(stringToPrint, sizeof(stringToPrint), "[ BAN ] Admin %s [ID: %d] banned player %s [ID: %d] from server!", adminName, playerid, bannedName, clickedplayerid);
							SendClientMessageToAll(COLOR_CYAN, stringToPrint);

							Ban(clickedplayerid);
						}
					case 13:
						// Send fakechat
						{
							ShowPlayerFakechatDialog(playerid);
						}
					case 14:
						// Set admin level
						{
							ShowPlayerAdminLevelSetDialog(playerid);
						}
				}

				return 1;
			}
		case DIALOG_PLAYER_SKIN_ID_SET:
			{
				if (!response)
				{
					gPlayers[playerid][SelectedSkinID] = INVALID_PLAYER_ID;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];
				gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");
				}

				new skinid = strval(inputtext);

				if (!IsNumeric(inputtext) || skinid < 0 || skinid > 311)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Skin ID must be between 0 and 311!");
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Skin ID changed");

				gPlayers[clickedplayerid][Skin] = skinid;
				return SetPlayerSkin(clickedplayerid, skinid);
			}
		case DIALOG_PLAYER_DRUNK_LEVEL_SET:
			{
				if (!response)
				{
					gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];
				gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");
				}

				new level = strval(inputtext);

				if (!IsNumeric(inputtext) || level < 0 || level > 50000)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Drunk level must be between 0 and 50000!");
				}

				SendClientMessage(clickedplayerid, COLOR_ORANGE, "[ DRUGZ ] Drunk level changed");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Drunk level changed");

				return SetPlayerDrunkLevel(clickedplayerid, level);
			}
		case DIALOG_PLAYER_WEAPON_SET:
			{
				if (!response)
				{
					gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];
				gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");
				}

				new weaponid = strval(inputtext);

				if (!IsNumeric(inputtext) || weaponid < 0 || weaponid > 46)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Weapon Model ID must be between 0 and 46!");
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ ADMIN ] Weapon sent");
				return GivePlayerWeapon(clickedplayerid, t_WEAPON: weaponid, 1000);
			}
		case DIALOG_PLAYER_FAKECHAT:
			{
				if (!response)
				{
					gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];
				gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");
				}

				SendPlayerMessageToAll(clickedplayerid, inputtext);

				return SendClientMessage(playerid, COLOR_WHITE, "[ FAKE ] Fake client message sent!");
			}
		case DIALOG_PLAYER_ADMIN_LEVEL_SET:
			{
				if (!response)
				{
					gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;
					return 1;
				}

				new clickedplayerid = gPlayers[playerid][ClickedPlayerID];
				gPlayers[playerid][ClickedPlayerID] = INVALID_PLAYER_ID;

				if (!IsPlayerConnected(clickedplayerid))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ! ] Player not connected!");
				}

				new level = strval(inputtext);

				if (!IsNumeric(inputtext) || level < 0 || level > 5)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIN ] Admin level must between 0 and 5!");
				}

				if (gPlayers[playerid][AdminLevel] > level || gPlayers[playerid][AdminLevel] < gPlayers[clickedplayerid][AdminLevel])
				{
					return SendClientMessage(playerid, COLOR_RED, "[ ADMIM ] Admin level must be lower or equal to one you possess yourself!");
				}

				new adminName[MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME], stringToPrint[128];

				GetPlayerName(playerid, adminName, sizeof(adminName));
				GetPlayerName(clickedplayerid, playerName, sizeof(playerName));

				format(stringToPrint, sizeof(stringToPrint), "[ i ] Admin %s set player %s [ ID: %d ] an Admin (level %d)!", adminName, playerName, clickedplayerid, level);

				gPlayers[clickedplayerid][AdminLevel] = level;
				SavePlayerData(clickedplayerid);

				return SendClientMessageToAll(COLOR_GREY, stringToPrint);
			}
		case DIALOG_DEATHMATCH_OPTIONS:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							if (gDeathmatch[playerid][IsRegistered] || gDeathmatch[playerid][InGame])
							{
								LeaveDeathmatch(playerid);
							}
							else
							{
								RegisterToDeathmatch(playerid);
							}
						}
				}

				return 1;
			}
		case DIALOG_PHONE_OPTIONS:
			{
				if (!response)
				{
					ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
					//ClearAnimations(playerid);
					RemovePlayerAttachedObject(playerid, 3);
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Account balance
						{
							new stringToPrint[256];

							format(stringToPrint, sizeof(stringToPrint), "[ PHONE ] Account balance: $%d!", gPlayers[playerid][Bank]);
							SendClientMessage(playerid, COLOR_YELLOW, stringToPrint);

							return ShowPhoneOptionsDialog(playerid);
						}
					case 1:
						// Vehicle lock
						{
							for (new i = 0; i < MAX_PROPERTIES; i++)
							{
								new vehicleid = gProperties[i][Vehicle][ID];
								new isowner = IsPlayerOwner(playerid, gProperties[i][ID]);
								new ishacker = gPlayers[playerid][TeamID] ? gTeams[ gPlayers[playerid][TeamID] - 1 ][ID] == TEAM_HACKERS : false;

								if (!vehicleid) 
								{
									continue;
								}

								if (!isowner && !ishacker)
								{
									continue;
								}

								new Float: X, Float: Y, Float: Z;
								GetVehiclePos(vehicleid, X, Y, Z);

								if (IsPlayerInSphere(playerid, X, Y, Z, 7.5))
								{
									new engine, lights, alarm, doors, bonnet, boot, objective;
									GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

									if (!isowner && ishacker && (alarm || random(4) == 3))
									{
										SetVehicleParamsEx(vehicleid, true, false, true, true, false, true, false);
										SendClientMessage(playerid, COLOR_YELLOW, "[ LOCK ] Car lock hack failed! Alarm has been activated! Run");
										break;
									}	

									if ((doors && !alarm) || (doors && alarm && isowner))
									{
										SetVehicleParamsEx(vehicleid, true, true, false, false, false, false, false);
										SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ LOCK ] Your car is now unlocked and started up");
									}
									else
									{
										SetVehicleParamsEx(vehicleid, true, false, false, true, false, false, false);
										SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ LOCK ] Your car is now locked");
									}

									PlayerPlaySound(playerid, 1056, X, Y, Z);
									break;
								}
							}
						}
					case 2:
						// PM to player
						{
							return ShowPhonePMPlayerListDialog(playerid);
						}
					case 3:
						// Taxi
						{
							if (!CheckTaxiDriversOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Taxi drivers online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
					case 4:
						// Car mechanic
						{
							if (!CheckCarMechanicsOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Car mechanics online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
					case 5:
						// Pizza delivery
						{
							if (!CheckPizzaguysOnline())
							{
								SendClientMessage(playerid, COLOR_YELLOW, "[ PHONE ] No Pizzaguys online!");
							}

							return ShowPhoneOptionsDialog(playerid);
						}
				}

				ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
				//ClearAnimations(playerid);
				RemovePlayerAttachedObject(playerid, 3);
				return 1;
			}
		case DIALOG_PHONE_PM_PLAYER_LIST:
			{
				if (!response)
				{
					ApplyAnimation(playerid, "ped", "phone_out", 4.1, false, false, false, false, 0);
					//ClearAnimations(playerid);
					RemovePlayerAttachedObject(playerid, 3);
					return 1;
				}

				return ShowPhonePMTextDialog(playerid, listitem);
			}
		case DIALOG_PHONE_PM_TEXT:
			{
				if (!response || !strlen(inputtext))
				{
					return ShowPhoneOptionsDialog(playerid);
				}

				OnPlayerPrivMsg(playerid, gPlayers[playerid][PMTargetID], inputtext);
				gPlayers[playerid][PMTargetID] = INVALID_PLAYER_ID;

				return ShowPhoneOptionsDialog(playerid);
			}
		case DIALOG_HELP_LIST:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							return ShowCommonCommandsDialog(playerid);
						}
					case 1:
						{
							return ShowAdminCommandsDialog(playerid);
						}
					case 2:
						{
							return ShowServerRulesDialog(playerid);
						}
					case 3:
						{
							return ShowCreditsDialog(playerid);
						}
					case 4:
						{
							return ShowTaxiHelpDialog(playerid);
						}
					case 5:
						{
							return ShowTowHelpDialog(playerid);
						}
					case 6:
						{
							return ShowTruckingHelpDialog(playerid);
						}
					case 7:
						{
							return ShowCombatHelpDialog(playerid);
						}
					case 8:
						{
							return ShowPropertyHelpDialog(playerid);
						}
					case 9:
						{
							return ShowRaceHelpDialog(playerid);
						}
					case 10:
						{
							return ShowPrizesInfoDialog(playerid);
						}
				}
			}
		case DIALOG_EDITOR_LIST:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							return ShowPropertyEditorMainDialog(playerid);
						}
					case 1:
						{
							return ShowTruckingEditorMainDialog(playerid);
						}
					case 2:
						{
							return ShowRaceEditorMainDialog(playerid);
						}
					case 3:
						{
							return ShowBribeEditorMainDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Draft new property
						{
							return ShowPropertyEditorNewIDDialog(playerid);
						}
					case 1:
						// List existing properties (personal)
						{
							return ShowPropertyEditorListPerDialog(playerid);
						}
					case 2:
						// List existing properties (commercial)
						{
							return ShowPropertyEditorListComDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_EDITOR_NEW_ID:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return 1;
				}

				if (GetPropertyArrayIDfromID(strval(inputtext)) != -1)
				{
					// Existing property
					return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] The entered property ID already exists!");
				}

				new propertyid = strval(inputtext);

				if (propertyid < 10101 || propertyid > 59999)
				{
					return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Invalid property ID (10101-59999)!");
				}

				gPlayers[playerid][EditingMode] = true;

				gPropertyEdit[playerid] = gNullProperty;
				gPropertyEdit[playerid][ID] = propertyid;

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Property edit enabled.");

				return ShowPropertyEditDialogMain(playerid);
			}
		case DIALOG_RACE_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Draft new race
						{
							new newraceid = -1;
							for (new i = 1; i < MAX_RACE_COUNT; i++)
							{
								if (!strcmp(gRaces[i][Name], ""))
								{
									newraceid = i;
									break;
								}
							}

							if (newraceid == -1)
							{
								return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Max race count reached!");
							}

							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Editting mode enabled");
							gPlayers[playerid][EditingMode] = true;
							gPlayers[playerid][NewRaceID] = newraceid;

							gPlayerRaceEdit[playerid][ID] = newraceid;

							return ShowRaceEditorOptionsDialog(playerid, gPlayers[playerid][NewRaceID]);
						}
					case 1:
						// List existing races
						{
							return ShowRaceEditorListDialog(playerid);
						}
				}
			}
		case DIALOG_RACE_EDITOR_LIST:
			{
				if (!response)
				{
					return 1;
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Editting mode enabled");
				gPlayers[playerid][EditingMode] = true;
				gPlayers[playerid][NewRaceID] = gRaces[listitem + 1][ID];

				return ShowRaceEditorOptionsDialog(playerid, gPlayers[playerid][NewRaceID]);
			}
		case DIALOG_RACE_EDITOR_OPTIONS:
			{
				if (!response)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Editting mode disabled");
					gPlayers[playerid][EditingMode] = false;
					gPlayers[playerid][NewRaceID] = -1;

					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Change Name
						{
							return ShowRaceEditorNameChangeDialog(playerid);
						}
					case 1:
						// Change Cost in Dollars
						{
							return ShowRaceEditorCostChangeDialog(playerid);
						}
					case 2:
						// Change Prize in Dollars
						{
							return ShowRaceEditorPrizeChangeDialog(playerid);
						}
					case 3:
						// Change Start Coords
						{
							gPlayerRaceEdit[playerid][EditType] = RACE_EDITOR_START_COORDS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record start coords using the KEY_NO (N)");
						}
					case 4:
						// Record New Race Track/Path
						{
							gPlayerRaceEdit[playerid][EditType] = RACE_EDITOR_TRACK_COORDS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record track coords using the KEY_NO (N)");
						}
					case 5:
						// Save race
						{
							return SaveRaceData(playerid);
						}

				}

				return 1;
			}
		case DIALOG_RACE_EDITOR_NAME:
			{
				if (!response)
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				format(gPlayerRaceEdit[playerid][Name], 64, "%s", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race name changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_RACE_EDITOR_COST:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				gPlayerRaceEdit[playerid][CostDollars] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race cost in dollars changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_RACE_EDITOR_PRIZE:
			{
				if (!response || !IsNumeric(inputtext))
				{
					return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
				}

				gPlayerRaceEdit[playerid][PrizeDollars] = strval(inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Race prize in dollars changed!");

				return ShowRaceEditorOptionsDialog(playerid, gPlayerRaceEdit[playerid][ID]);
			}
		case DIALOG_TRUCKING_EDITOR_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// New trucking point
						{
							new truckingid = -1;
							for (new i = 1; i < MAX_TRUCKING_POINTS; i++)
							{
								if (!strcmp(gTruckingPoints[i][Name], ""))
								{
									truckingid = i;
									break;
								}
							}

							if (truckingid == -1)
							{
								return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Max trucking point count reached!");
							}

							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point editor mode enabled!");
							gPlayers[playerid][EditingMode] = true;
							gTruckingEdit[playerid][ID] = truckingid;
							gTruckingVehiclesIndex = 0;

							return ShowTruckingEditorOptionsDialog(playerid);
						}
					case 1:
						// List existing trucking points
						{
							return ShowTruckingPointListDialog(playerid);
						}
				}
			}
		case DIALOG_TRUCKING_POINT_LIST:
			{
				if (!response)
				{
					return 1;
				}

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point editor enabled!");
				gPlayers[playerid][EditingMode] = true;
				gTruckingEdit[playerid][ID] = listitem + 1;
				gTruckingVehiclesIndex = 0;

				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_TRUCKING_EDITOR_OPTIONS:
			{
				if (!response)
				{
					gTruckingEdit[playerid][ID] = -1;
					gPlayers[playerid][EditingMode] = false;
					gTruckingVehiclesIndex = 0;
					return SendClientMessage(playerid, COLOR_YELLOW, "[ EDIT ] Trucking editor mode disabled!");
				}

				switch (listitem)
				{
					case 0:
						// Name
						{
							return ShowTruckingEditorNameDialog(playerid);
						}
					case 1:
						// Type
						{
							return ShowTruckingEditorTypeDialog(playerid);
						}
					case 2:
						// Checkpoint
						{
							gTruckingEdit[playerid][EditType] = TREDIT_CHECKPOINT;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new checkpoint coords using the KEY_NO (N) key.");
						}
					case 3:
						// Info pickup
						{
							gTruckingEdit[playerid][EditType] = TREDIT_INFO_PICKUP;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new info pickup coords using the KEY_NO (N) key.");
						}
					case 4:
						// Truck
						{
							gTruckingEdit[playerid][EditType] = TREDIT_TRUCK;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new truck coords using the KEY_NO (N) key.");
						}
					case 5:
						// Gas
						{
							gTruckingEdit[playerid][EditType] = TREDIT_GAS;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new gas trailer coords using the KEY_NO (N) key.");
						}
					case 6:
						// Freight
						{
							gTruckingEdit[playerid][EditType] = TREDIT_FREIGHT;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new freight trailer coords using the KEY_NO (N) key.");
						}
					case 7:
						// Save
						{
							if (SetTruckingPoint(playerid))
								return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point and vehicles saved successfully!");

							return SendClientMessage(playerid, COLOR_RED, "[ EDIT ] Database error occured while saving trucking data!");
						}
				}

				return 1;
			}
		case DIALOG_TRUCKING_EDITOR_NAME:
			{
				if (!response || !strlen(inputtext))
				{
					return ShowTruckingEditorOptionsDialog(playerid);
				}

				format(gTruckingEdit[playerid][Name], 64, "%s", inputtext);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point name changed!");
				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_TRUCKING_EDITOR_TYPE:
			{
				if (!response)
				{
					return ShowTruckingEditorOptionsDialog(playerid);
				}

				switch (listitem)
				{
					case 0:
						// Petrol station
						{
							gTruckingEdit[playerid][Type] = FT_GAS_STATION;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point type set to petrol station!");
						}
					case 1:
						{
							gTruckingEdit[playerid][Type] = FT_FREIGHT;
							SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ EDIT ] Trucking point type set to freight point!");
						}
				}

				return ShowTruckingEditorOptionsDialog(playerid);
			}
		case DIALOG_PROPERTY_SKIN_MAIN:
			{
				if (!response)
				{
					gPlayers[playerid][SkinOp] = SKIN_OP_NONE;
					return 1;
				}

				switch (listitem)
				{
					case 0:
						// Save new skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_NEW;
							return SavePropertySkin(playerid);
						}
					case 1:
						// Select skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_SELECT;
							return ShowPropertySkinListDialog(playerid);
						}
					case 2:
						// Delete skin
						{
							gPlayers[playerid][SkinOp] = SKIN_OP_DELETE;
							return ShowPropertySkinListDialog(playerid);
						}
				}
			}
		case DIALOG_PROPERTY_SKIN_LIST:
			{
				if (!response)
				{
					gPlayers[playerid][SkinOp] = SKIN_OP_NONE;
					return 1;
				}

				switch (gPlayers[playerid][SkinOp])
				{
					case SKIN_OP_SELECT:
						{
							return SelectPropertySkin(playerid, listitem);
						}
					case SKIN_OP_DELETE:
						{
							return DeletePropertySkin(playerid, listitem);
						}
					default:
						{
							return 1;
						}
				}
			}
		case DIALOG_HIGH_SCORES_RACES:
			{
				if (!response)
				{
					gPlayers[playerid][RacesHSOffset] = -1;
					return 1;
				}

				if (gPlayers[playerid][RacesHSOffset] > 9)
				{
					gPlayers[playerid][RacesHSOffset] += 10;
				}
				else
				{
					gPlayers[playerid][RacesHSOffset] = 10;
				}

				return ShowHighScoresRacesDialog(playerid, gPlayers[playerid][RacesHSOffset]);
			}
		case DIALOG_TAXI_OPTIONS:
			{
				if (!response)
				{
					return 1;
				}

				return SetPlayerTaxiMission(playerid, listitem);
			}
		case DIALOG_HIGH_SCORES_OPTIONS:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							gPlayers[playerid][RacesHSOffset] = 0;
							return ShowHighScoresRacesDialog(playerid, 0);
						}
					case 1:
						{
							return ShowHighScoresDeathmatchDialog(playerid);
						}
					case 2:
						{
							return ShowHighScoresMissionsDialog(playerid);
						}
					case 3:
						{
							return ShowHighScoresCombatDialog(playerid);
						}
					case 4:
						{
							return ShowHighScoresPlayTimeDialog(playerid);
						}
					case 5:
						{
							return ShowHighScoresPropertiesDialog(playerid);
						}
				}

			}
		case DIALOG_COMBAT_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return SetCombatMission(playerid, listitem + 1);
			}
		case DIALOG_TUTORIAL_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0: 
						{
							if (gPlayers[playerid][TutorialStats][Active])
							{
								return ShowTutorialStatsDialog(playerid);
							}
							
							gPlayers[playerid][TutorialStats][Active] = bool: true;
							return SendClientMessage(playerid, COLOR_LIGHTGREEN, "[ TUT ] Tutorial mode activated!");
						}
					case 1: {
							if (gPlayers[playerid][TutorialStats][Active])
							{
								// Next task
								return 1;
							}
						}
				}
			}
		case DIALOG_BRIBE_MAIN:
			{
				if (!response)
				{
					gPlayers[playerid][EditingMode] = false;
					gBribeEdit[playerid][Type] = BREDIT_NONE;
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							gPlayers[playerid][EditingMode] = true;
							gBribeEdit[playerid][Type] = BREDIT_NEW;
							return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new police bribe pickup coords using the KEY_NO (N) key.");
						}
					case 1: 
						{
							gPlayers[playerid][EditingMode] = true;
							gBribeEdit[playerid][Type] = BREDIT_DELETE;
							//return SendClientMessage(playerid, COLOR_ORANGE, "[ EDIT ] Record new police bribe pickup coords using the KEY_NO (N) key.");
							return 1;
						}
				}
				
			}
		case DIALOG_BRIBE_NOTE:
			{
				if (!response)
				{
					gPlayers[playerid][EditingMode] = false;
					gBribeEdit[playerid][Type] = BREDIT_NONE;
					return 1;
				}

				format(gBribeEdit[playerid][Note], 64, "%s", inputtext);
				return SaveNewPoliceBribePickup(playerid);
			}
		case DIALOG_LOCALE_LIST:
			{
				if (!response)
				{
					return 1;
				}

				gPlayers[playerid][Locale] = PlayerLocale: listitem;
				return SendClientMessage(playerid, COLOR_YELLOW, "[ LOCALE ] Game language changed!");
			}
		case DIALOG_BLACK_MARKET_MAIN:
			{
				if (!response)
				{
					return 1;
				}

				switch (listitem)
				{
					case 0:
						{
							return ShowBlackMarketItemListDialog(playerid);
						}
					case 1:
						{
							return ShowBlackMarketNewDialog(playerid);
						}
				}
			}
		case DIALOG_BLACK_MARKET_LIST:
			{
				if (!response)
				{
					return 1;
				}

				return ProcessBlackMarketOffer(playerid, listitem);
			}
		case DIALOG_BLACK_MARKET_NEW:
			{
				if (!response)
				{
					return 1;
				}

				gBlackMarketItemOffer[playerid][Type] = DrugType: (listitem + 1);
				SendClientMessage(playerid, COLOR_YELLOW, "[ MARKET ] Item selected!");

				return ShowBlackMarketAmountDialog(playerid);
			}
		case DIALOG_BLACK_MARKET_AMOUNT:
			{
				if (!response)
				{
					return 1;
				}

				if (!IsNumeric(inputtext) || strval(inputtext) < 0)
				{
					SendClientMessage(playerid, COLOR_RED, "[ MARKET ] Wrong amount set!");
					return ShowBlackMarketAmountDialog(playerid);
				}

				if (gPlayers[playerid][Drugs][_: gBlackMarketItemOffer[playerid][Type] - 1 ] < strval(inputtext))
				{
					return SendClientMessage(playerid, COLOR_RED, "[ MARKET ] Not such amount of such item in pockets!");
				}

				gBlackMarketItemOffer[playerid][Amount] = strval(inputtext);
				SendClientMessage(playerid, COLOR_YELLOW, "[ MARKET ] Amount set!");

				return ShowBlackMarketValueDialog(playerid);
			}
		case DIALOG_BLACK_MARKET_VALUE:
			{
				if (!response)
				{
					return 1;
				}

				if (!IsNumeric(inputtext) || strval(inputtext) < 0)
				{
					SendClientMessage(playerid, COLOR_RED, "[ MARKET ] Wrong value set!");
					return ShowBlackMarketValueDialog(playerid);
				}

				gBlackMarketItemOffer[playerid][Value] = strval(inputtext);
				SendClientMessage(playerid, COLOR_YELLOW, "[ MARKET ] Value set!");

				return ProcessNewBlackMarketOffer(playerid);
			}

		default: 
			{
				return 0; // dialog ID was not found, search in other scripts
			}
	}

	return 1;
}

