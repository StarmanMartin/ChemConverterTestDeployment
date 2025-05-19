#!/bin/bash

echo $$ > pidfile.txt

clone_repo () {
  LOCALREPO_VC_DIR=$3/.git
  if [ -d "$LOCALREPO_VC_DIR" ]
  then
    cd "$3"
    cd ..
    rm -r "$3"
    mkdir "$3"
  fi
  git clone -b $2 "$1" "$3"
}

REPO=https://github.com/ComPlat/chemotion-converter-client.git
LOCALREPO=/srv/converter/chemotion-converter-client
CLIENT_BRANCH=${CLIENT_BRANCH:-master}



echo "|================================================================================|"
echo "|  Cloning chemotion-converter-client Branch: ${CLIENT_BRANCH}  "
echo "|================================================================================|"
clone_repo $REPO ${CLIENT_BRANCH} $LOCALREPO
echo "|================================================================================|"
echo "|  Build Client  "
echo "|================================================================================|"
cd $LOCALREPO
asdf install nodejs
npm install
CONVERTER_APP_URL=${CONVERTER_URL}/api/v1 npm run build:prod
rm -r /var/www/html
mv public /var/www/html

REPO=https://github.com/ComPlat/chemotion-converter-app.git
LOCALREPO=/srv/converter/chemotion-converter-app
APP_BRANCH=${APP_BRANCH:-main}

echo "|================================================================================|"
echo "|  Cloning chemotion-converter-app Branch: ${APP_BRANCH}  "
echo "|================================================================================|"
clone_repo $REPO ${APP_BRANCH} $LOCALREPO


echo "|================================================================================|"
echo "|  Setting environment  "
echo "|================================================================================|"

service nginx start

LOG_ROOT=/var/log/converter

if [ -d "$LOG_ROOT" ]
  then
    cd "$LOG_ROOT"
    rm "*"
  fi

cd $LOCALREPO

mkdir $LOG_ROOT
touch $LOG_ROOT/application.log
touch $LOG_ROOT/access.log
touch $LOG_ROOT/error.log

export FLASK_APP=converter_app.app
export FLASK_ENV=production
export PROFILES_DIR=/var/share/profiles
export DATASETS_DIR=/var/share/datasets
export HTPASSWD_PATH=/var/share/htpasswd
export LOG_LEVEL=INFO
export LOG_FILE=$LOG_ROOT/application.log
export GUNICORN_BIN=/srv/converter/env/bin/gunicorn
export GUNICORN_WORKER=3
export GUNICORN_PORT=8000
export GUNICORN_TIMEOUT=${TIMEOUT:-500}
export GUNICORN_PID_FILE=/run/chemotion-converter/pid
export GUNICORN_ACCESS_LOG_FILE=$LOG_ROOT/access.log
export GUNICORN_ERROR_LOG_FILE=$LOG_ROOT/error.log
export MAX_CONTENT_LENGTH=250G


echo "|================================================================================|"
echo "|  Installing dependencies "
echo "|================================================================================|"

pip install -r requirements/dev.txt

echo "|================================================================================|"
echo "|  Running server "
echo "|================================================================================|"

# tail -f /dev/null
gunicorn --bind 0.0.0.0:8000 "converter_app.app:create_app()" --timeout "${TIMEOUT:-500}" &

# Save PID (optional, if you want to track)
echo "Script PID: $$"
echo "Gunicorn PID: $!"

wait
