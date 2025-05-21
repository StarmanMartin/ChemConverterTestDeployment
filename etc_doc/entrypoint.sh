#!/bin/bash

./prepare-asdf.sh

CLIENT_REPO="ComPlat/chemotion-converter-client"

APP_REPO="ComPlat/chemotion-converter-app"

INTERVAL=${UPDATE_INTERVAL:-600}            # Seconds between checks

echo "" > client_last_commit.txt
echo "" > app_last_commit.txt
echo "" > $PIDFILE

while true; do
    source ./set_git_branch.sh
    client_new_commit=$(git ls-remote https://github.com/$CLIENT_REPO.git refs/heads/$CLIENT_BRANCH)
    app_new_commit=$(git ls-remote https://github.com/$APP_REPO.git refs/heads/$APP_BRANCH)
    PID=$(cat $PIDFILE)
    if ! ps -p $PID > /dev/null || [[ "$client_new_commit" != $(cat client_last_commit.txt) ]] || [[ "$app_new_commit" != $(cat app_last_commit.txt) ]]; then
        echo "[$(date)] New commit detected: CLIENT: $client_new_commit & APP: $app_new_commit"

        echo "$client_new_commit" > client_last_commit.txt
        echo "$app_new_commit" > app_last_commit.txt


        source ./run_scripts.sh
        kill -TERM -$PID
        setsid ./run.sh &
    fi
    sleep $INTERVAL
done



