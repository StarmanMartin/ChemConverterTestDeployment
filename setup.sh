#!/bin/bash

echo "Make sure docker and curl is installed"
# Prompt the user for each environment variable, with default values

read -p "Enter public URL [https://0.0.0.0:8071/]: " CONVERTER_URL
CONVERTER_URL=${CONVERTER_URL:-https://0.0.0.0:8071/}

read -p "Enter open docker-compose prot [8071]: " PROJECT_WEB_PORT
PROJECT_WEB_PORT=${PROJECT_WEB_PORT:-8071}

read -p "Enter converter app LOG_LEVEL DEBUG, ERROR or INFO [DEBUG]: " LOG_LEVEL
LOG_LEVEL=${LOG_LEVEL:-DEBUG}

read -p "Enter converter app TIMEOUT [500]: " TIMEOUT
TIMEOUT=${TIMEOUT:-500}

read -p "Enter UPDATE_INTERVAL [600]: " UPDATE_INTERVAL
UPDATE_INTERVAL=${UPDATE_INTERVAL:-600}

# Write to .env file
cat > .env <<EOF
CONVERTER_URL=$CONVERTER_URL
PROJECT_WEB_PORT=$PROJECT_WEB_PORT
LOG_LEVEL=$LOG_LEVEL
TIMEOUT=$TIMEOUT
UPDATE_INTERVAL=$UPDATE_INTERVAL
EOF

echo ".env file created with the following content:"
cat .env

echo "create shared folder"

mkdir converter
mkdir converter/profiles
mkdir converter/logs
mkdir converter/datasets
mkdir converter/shell_scripts

echo "Downloading missing files!"

curl -O https://raw.githubusercontent.com/StarmanMartin/ChemConverterTestDeployment/main/docker-compose.yml
cd converter/shell_scripts
curl -O https://raw.githubusercontent.com/StarmanMartin/ChemConverterTestDeployment/main/converter/shell_scripts/example.sh

curl -O https://raw.githubusercontent.com/StarmanMartin/ChemConverterTestDeployment/main/converter/APP_BRANCH.txt
curl -O https://raw.githubusercontent.com/StarmanMartin/ChemConverterTestDeployment/main/converter/shell_scripts/CLIENT_BRANCH.txt

cd ..
read -p "Enter converter htpasswd user: " HTPASSWD_USER
echo
read -s -p "Enter $HTPASSWD_USER password: " HTPASSWD_PASS
echo
sha1=$(printf "$HTPASSWD_PASS" | openssl sha1 -binary | base64)
echo "$HTPASSWD_USER:{SHA}$sha1" >> htpasswd
