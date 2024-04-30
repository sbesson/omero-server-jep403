#! /bin/bash

source OMERO.venv/bin/activate
export PGPASSWORD=omero

dropdb -h pg jdk17 --if-exists
createdb -h pg -O omero jdk17
omero db script --password omero -f OMERO.sql
psql -h pg -U omero jdk17 -f OMERO.sql

omero config set omero.db.host pg
omero config set omero.db.name jdk17
omero certificates
