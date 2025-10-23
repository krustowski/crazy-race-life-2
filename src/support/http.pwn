#if defined _CRL2_HTTP
	#endinput
#endif
#define _CRL2_HTTP

forward WebhookResponse(index, response_code, data[]);

public WebhookResponse(index, response_code, data[])
{
	if (response_code == 200)
	{
		printf("Webhook [playerid %d]: HTTP OK", index);
	}
	else
	{
		printf("Webhook [playerid %d]: HTTP %d", index, response_code);
	}
}

static const WEBHOOK_URL[] = "samp-webhook.n0p.cz/hooks/samp-webhook-player";

stock SendMessageToWebhook(playerid, const message[], reasonid)
{
	new reason[32];

	switch (reasonid)
	{
		case -1:
			{
				format(reason, sizeof(reason), "");
			}
		case 0: 
			{
				format(reason, sizeof(reason), "crash");
			}
		case 1: 
			{
				format(reason, sizeof(reason), "left");
			}
		case 2: 
			{
				format(reason, sizeof(reason), "kick/ban");
			}
		default: 
			{
				format(reason, sizeof(reason), "unknown");
			}
	}

	// Send the HTTP message to Webhook
	new stringToSend[128];
	format(stringToSend, sizeof(stringToSend), "payload={\"nickname\":\"%s\",\"state\":\"%s\",\"reason\":\"%s\"}", gPlayers[playerid][Name], message, reason);

	new http = HTTP(playerid, HTTP_POST, WEBHOOK_URL, stringToSend, "WebhookResponse");
	if (!http)
	{
		printf("Failed to send HTTP request: HTTP returns %d, idx %d", http, playerid);
	}
}
