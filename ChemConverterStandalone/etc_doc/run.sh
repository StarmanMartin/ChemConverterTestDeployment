#!/bin/bash

CLIENT_REPO="ComPlat/chemotion-converter-client"

APP_REPO="ComPlat/chemotion-converter-app"

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
CLIENT_BRANCH=master

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

REPO=https://github.com/ComPlat/chemotion-converter-app.git
LOCALREPO=/srv/converter/chemotion-converter-app
APP_BRANCH=master

echo "|================================================================================|"
echo "|  Cloning chemotion-converter-app Branch: ${APP_BRANCH}  "
echo "|================================================================================|"
clone_repo $REPO ${APP_BRANCH} $LOCALREPO


echo "|================================================================================|"
echo "|  Setting environment  "
echo "|================================================================================|"


if [ -d "$LOG_ROOT" ]
  then
    cd "$LOG_ROOT"
    rm ./*
  fi

cd $LOCALREPO

mkdir $LOG_ROOT
touch $LOG_ROOT/application.log
touch $LOG_ROOT/access.log
touch $LOG_ROOT/error.log


echo "|================================================================================|"
echo "|  Installing dependencies "
echo "|================================================================================|"

pip install ".[dev]"
