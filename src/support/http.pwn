forward WebhookResponse(index, response_code, data[]);

public WebhookResponse(index, response_code, data[])
{
	if (response_code == 200)
	{
		printf("Webhook [idx %d]: OK", index);
	}
	else
	{
		printf("Webhook [idx %d]: %d", index, response_code);
	}
}

static const WEBHOOK_URL[64] = "samp-webhook.n0p.cz/hooks/samp-webhook-player";

stock SendMessageToWebhook(playerid, const message[])
{
	// Send the HTTP message to Webhook
	new stringToSend[128];
	format(stringToSend, sizeof(stringToSend), "payload={\"nickname\":\"%s\",\"state\":\"%s\"}", gPlayers[playerid][Name], message);

	new http = HTTP(playerid, HTTP_POST, WEBHOOK_URL, stringToSend, "WebhookResponse");
	if (!http)
	{
		printf("Failed to send HTTP request: HTTP returns %d, idx %d", http, playerid);
	}
}
