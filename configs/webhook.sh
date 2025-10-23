#!/bin/bash

TELEGRAM_TOKEN="" 
TELEGRAM_GROUP=""

get_chatid() {
        local TELEGRAM_URL="https://api.telegram.org/bot${TELEGRAM_TOKEN}/getUpdates"

        curl -sL ${TELEGRAM_URL} | jq .
}

TEXT=""

[ -z ${3} ] && { 
        TEXT="<b>CrazyRaceLife2%20Informer</b>%0A%0APlayer:%20%09<b>${1}</b>%0AState:%20%09<b>${2}</b>"
} || {
        TEXT="<b>CrazyRaceLife2%20Informer</b>%0A%0APlayer:%20%09<b>${1}</b>%0AState:%20%09<b>${2}</b>%0AReason:%20%09<b>${3}</b>"
}

curl -sL "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage?chat_id=${TELEGRAM_GROUP}&parse_mode=HTML&text=${TEXT}"
