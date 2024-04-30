#! /bin/bash

source OMERO.venv/bin/activate
export PGPASSWORD=omero

dropdb -h pg jdk21 --if-exists
createdb -h pg -O omero jdk21
omero db script --password omero -f OMERO.sql
psql -h pg -U omero jdk21 -f OMERO.sql

omero config set omero.db.host pg
omero config set omero.db.name jdk21
omero certificates
