#!/bin/bash

cd /srv/converter/chemotion-converter-client

CONVERTER_APP_URL=${CONVERTER_URL}/api/v1 npm run build:prod
rm -r /var/www/html
mv public /var/www/html


service nginx start

cd /srv/converter

echo "|================================================================================|"
echo "|  Running server "
echo "|================================================================================|"
gunicorn --bind 0.0.0.0:8000 "converter_app.app:create_app()" --timeout "${TIMEOUT:-500}"



