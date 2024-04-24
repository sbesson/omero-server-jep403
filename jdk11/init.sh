#! /bin/bash

source OMERO.venv/bin/activate
export PGPASSWORD=omero

dropdb -h pg jdk11 --if-exists
createdb -h pg -O omero jdk11
omero db script --password omero -f OMERO.sql
psql -h pg -U omero jdk11 -f OMERO.sql

omero config set omero.db.host pg
omero config set omero.db.name jdk11
omero certificates

omero config get
omero admin start
