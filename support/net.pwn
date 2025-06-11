//
//  net.pwn
//

// NetStats_PacketLossPercent
stock GetPlayerPacketLoss(playerid, &Float:packetLoss)
{
    /* Returns the packetloss percentage of the given playerid - Made by Fusez */

    if(!IsPlayerConnected(playerid))
    {
        return 0;
    }

    new nstats[400+1], nstats_loss[20], start, end;
    GetPlayerNetworkStats(playerid, nstats, sizeof (nstats));

    start = strfind(nstats, "packetloss", true);
    end = strfind(nstats, "%", true, start);

    strmid(nstats_loss, nstats, start+12, end, sizeof (nstats_loss));
    packetLoss = floatstr(nstats_loss);
    return 1;
}
