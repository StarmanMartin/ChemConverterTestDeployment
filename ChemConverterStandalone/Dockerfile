# syntax=docker/dockerfile:1

FROM python:3.12.3-slim
ENV DOC_VERSION=0.0.3
ENV LOG_ROOT=/var/log/converter
ENV FLASK_APP=converter_app.app
ENV FLASK_ENV=production
ENV PROFILES_DIR=/var/share/profiles
ENV DATASETS_DIR=/var/share/datasets
ENV HTPASSWD_PATH=/var/share/htpasswd
ENV LOG_LEVEL=INFO
ENV LOG_FILE=$LOG_ROOT/application.log
ENV GUNICORN_BIN=/srv/converter/env/bin/gunicorn
ENV GUNICORN_WORKER=3
ENV GUNICORN_PORT=8000
ENV GUNICORN_TIMEOUT=${TIMEOUT:-500}
ENV GUNICORN_PID_FILE=/run/chemotion-converter/pid
ENV GUNICORN_ACCESS_LOG_FILE=$LOG_ROOT/access.log
ENV GUNICORN_ERROR_LOG_FILE=$LOG_ROOT/error.log
ENV MAX_CONTENT_LENGTH=${MAX_CONTENT_LENGTH:-250G}

RUN apt-get update && apt-get install -y -q --no-install-recommends libmagic1 \
    apache2-utils git nginx build-essential curl jq wget procps ca-certificates

ENV ASDF_DIR=/root/.asdf

RUN git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.14.0

ENV PATH=/root/.asdf/shims:/root/.asdf/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
RUN pip install wheel setuptools pip gunicorn --upgrade

RUN mkdir /shell_scripts
RUN mkdir /srv/converter

COPY etc_doc/nginx/sites-available/default /etc/nginx/sites-available/default
RUN chmod 644 /etc/nginx/sites-available/default


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIDFILE=/srv/converter/pid

WORKDIR /srv/converter


COPY ./etc_doc/*.sh ./
RUN chmod +x ./*.sh

RUN . ./run.sh

CMD bash ./entrypoint.sh