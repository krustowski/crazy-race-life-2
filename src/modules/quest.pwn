#if defined _CRL2_QUEST
	#endinput
#endif
#define _CRL2_QUEST

//
//  quest.pwn
//

#define MAX_QUESTS      64
#define MAX_QUEST_LABEL 128
#define MAX_QUEST_DESC  256

enum QuestEvent
{
    QUEST_EVT_NONE,
    QUEST_EVT_PROPERTY_RENTED,
    QUEST_EVT_PROPERTY_BOUGHT,
    QUEST_EVT_RACE_FINISHED,
    QUEST_EVT_TEAM_JOINED,
    QUEST_EVT_PM_SENT,
    QUEST_EVT_BANK_DEPOSIT,
    QUEST_EVT_DEATHMATCH_PLAYED,
    QUEST_EVT_DEATHMATCH_WON,
    QUEST_EVT_TRUCKING_DONE,
    QUEST_EVT_TAXI_DONE,
    QUEST_EVT_TOW_DONE,
    QUEST_EVT_COMBAT_DONE,
    QUEST_EVT_RAMPAGE_DONE,
    QUEST_EVT_DRUG_DONE
}

enum Quest
{
    ID,
    QuestEvent: Event,
    Target,
    Reward
}

enum PlayerQuest
{
    Progress,
    bool: Completed
}

new
    gQuests[MAX_QUESTS][Quest],
    gQuestCount = 0,
    gPlayerQuests[MAX_PLAYERS][MAX_QUESTS][PlayerQuest];

new
    gQuestLabels[MAX_QUESTS][PlayerLocale][MAX_QUEST_LABEL],
    gQuestDesc[MAX_QUESTS][PlayerLocale][MAX_QUEST_DESC];

//
//
//

stock InitQuests()
{
    new 
        query[512] = "SELECT t.id, t.event, t.target, t.reward, t.seq_no, l.locale, l.label, l.desc FROM quest_types AS t JOIN quest_labels AS l ON l.quest_type = t.id WHERE t.active = 1",
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        
    if (!result)
	{
		printf("Database error: cannot list quests");
		print(query);

		return 0;
	}

    if (!DB_GetRowCount(result))
    {
        DB_FreeResultSet(result);
        print("[debug] no quests to load!");
        return 0;
    }

    do
    {
        new
            id = DB_GetFieldIntByName(result, "id"),
            QuestEvent: event = QuestEvent: DB_GetFieldIntByName(result, "event"),
            target = DB_GetFieldIntByName(result, "target"),
            reward = DB_GetFieldIntByName(result, "reward"),
            //seq_no = DB_GetFieldIntByName(result, "seq_no"),
            PlayerLocale: locale = PlayerLocale: DB_GetFieldIntByName(result, "locale"),
            label[MAX_QUEST_LABEL],
            desc[MAX_QUEST_DESC];

        DB_GetFieldStringByName(result, "label", label, sizeof(label));
        DB_GetFieldStringByName(result, "desc", desc, sizeof(desc));

        strcopy(gQuestLabels[id][locale], label);
        strcopy(gQuestDesc[id][locale], desc);

        if (!gQuests[id][ID])
        {
            gQuestCount++;
        }

        gQuests[id][ID] = id;
        gQuests[id][Event] = event;
        gQuests[id][Target] = target;
        gQuests[id][Reward] = reward;
    }
    while (DB_SelectNextRow(result));

    DB_FreeResultSet(result);

    return 1;

}

stock LoadPlayerQuests(playerid)
{
    new 
        query[512];
        
    format(query, sizeof(query), "SELECT quest_type, progress, completed_at FROM quests WHERE user_id = %d;", gPlayers[playerid][OrmID]);

    new    
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        
    if (!result)
	{
		printf("Database error: cannot list player's quests");
		print(query);

		return 0;
	}

    if (!DB_GetRowCount(result))
    {
        print("[debug] no player quests to load!");
        DB_FreeResultSet(result);
        return 1;
    }

    do
    {
        new
            type = DB_GetFieldIntByName(result, "quest_type"),
            progress = DB_GetFieldIntByName(result, "progress"),
            completed_at = DB_GetFieldIntByName(result, "completed_at");
        
        if (type > gQuestCount || !gQuests[type][ID])
        {
            continue;
        }

        gPlayerQuests[playerid][type][Progress] = progress;
        gPlayerQuests[playerid][type][Completed] = (completed_at > 0) ? true : false;
    }
    while (DB_SelectNextRow(result));

    DB_FreeResultSet(result);

    return 1;
}

stock CompleteQuest(playerid, questid)
{
    new 
        query[256];
        
    format(query, sizeof(query), "INSERT INTO quests (user_id, quest_type, progress, completed_at) VALUES (%d, %d, %d, %d) ON CONFLICT(user_id, quest_type) DO UPDATE SET progress = excluded.progress, completed_at = excluded.completed_at", 
            gPlayers[playerid][OrmID], 
            gQuests[questid][ID], 
            gPlayerQuests[playerid][questid][Progress], 
            gettime()
        );

    new    
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        
    if (!result)
	{
		printf("[error] Database error: cannot finish/complete player's quest");
		print(query);

		return 0;
	}

    gPlayerQuests[playerid][questid][Completed] = true;
    GivePlayerMoney(playerid, gQuests[questid][Reward]);

    DB_FreeResultSet(result);

    return 1;
}

stock SaveQuestProgress(playerid, questid)
{
    new 
        query[256];
        
    format(query, sizeof(query), "INSERT INTO quests (user_id, quest_type, progress) VALUES (%d, %d, %d) ON CONFLICT(user_id, quest_type) DO UPDATE SET progress = excluded.progress",
            gPlayers[playerid][OrmID], 
            gQuests[questid][ID],
            gPlayerQuests[playerid][questid][Progress]
        );
    new    
        DBResult: result = DB_ExecuteQuery(gDbConnectionHandle, query);
        
    if (!result)
	{
		printf("[error] Database error: cannot update player's quest");
		print(query);

		return 0;
	}

    DB_FreeResultSet(result);

    return 1;
}

stock FireQuestEvent(playerid, QuestEvent: event, amount = 1)
{
    if (!IsPlayerConnected(playerid))
    {
        return 0;
    }

    for (new i = 1; i < MAX_QUESTS + 1; i++)
    {
        if (gQuests[i][Event] != event || gPlayerQuests[playerid][i][Completed])
        {
            continue;
        }

        gPlayerQuests[playerid][i][Progress] += amount;

        if (gPlayerQuests[playerid][i][Progress] >= gQuests[i][Target])
        {
            CompleteQuest(playerid, i);
        }
        else
        {
            SaveQuestProgress(playerid, i);
        }
    }

    return 1;
}

stock ShowPlayerQuestListDialog();

stock ShowPlayerQuestDescDialog();
