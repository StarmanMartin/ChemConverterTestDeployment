# syntax=docker/dockerfile:1

FROM python:3.12.3-slim

RUN apt-get update && apt-get install -y -q --no-install-recommends libmagic1 apache2-utils git nginx build-essential curl jq
RUN pip install wheel setuptools pip pybind11 gunicorn --upgrade

RUN mkdir /shell_scripts
RUN mkdir /srv/converter

COPY etc_doc/nginx/sites-available/default /etc/nginx/sites-available/default
RUN chmod 644 /etc/nginx/sites-available/default


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIDFILE=/srv/converter/pid

WORKDIR /srv/converter

ENV ASDF_DIR=/root/.asdf
ENV PATH=/root/.asdf/shims:/root/.asdf/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY ./etc_doc/entrypoint.sh ./entrypoint.sh
COPY ./etc_doc/prepare-asdf.sh ./prepare-asdf.sh
COPY ./etc_doc/prepare-nodejs.sh ./prepare-nodejs.sh
RUN chmod +x ./entrypoint.sh
RUN chmod +x ./prepare-asdf.sh
RUN chmod +x ./prepare-nodejs.sh

CMD bash ./entrypoint.sh