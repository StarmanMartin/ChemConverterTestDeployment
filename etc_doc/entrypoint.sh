#!/bin/bash

./prepare-asdf.sh
source ./run_scripts.sh

#!/bin/bash

CLIENT_REPO="ComPlat/chemotion-converter-client"
CLIENT_BRANCH=${CLIENT_BRANCH:-master}

APP_REPO="ComPlat/chemotion-converter-app"
APP_BRANCH=${APP_BRANCH:-main}

INTERVAL=${UPDATE_INTERVAL:-600}            # Seconds between checks

echo "" > client_last_commit.txt
echo "" > app_last_commit.txt
echo "" > pidfile.txt
last_process=""

while true; do
    client_new_commit=$(curl -s "https://api.github.com/repos/$CLIENT_REPO/commits/$CLIENT_BRANCH" | jq -r .sha)
    app_new_commit=$(curl -s "https://api.github.com/repos/$APP_REPO/commits/$APP_BRANCH" | jq -r .sha)

    if [[ "$client_new_commit" != $(cat client_last_commit.txt) ]] || [[ "$app_new_commit" != $(cat app_last_commit.txt) ]]; then
        echo "[$(date)] New commit detected: CLIENT: $client_new_commit & APP: $app_new_commit"

        echo "$client_new_commit" > client_last_commit.txt
        echo "$app_new_commit" > app_last_commit.txt


        source ./run_scripts.sh
        kill -TERM -$(cat pidfile.txt)
        setsid ./run.sh &
    fi
    sleep $INTERVAL
done



