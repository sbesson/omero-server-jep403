#! /bin/bash

source OMERO.venv/bin/activate
export PGPASSWORD=omero

dropdb -h pg jdk17 --if-exists
createdb -h pg -O omero jdk17
omero db script --password omero -f OMERO.sql
psql -h pg -U omero jdk17 -f OMERO.sql

omero config set omero.db.host pg
omero config set omero.db.name jdk17
# See https://docs.oracle.com/en/java/javase/17/migrate/migrating-jdk-8-later-jdk-releases.html#GUID-7BB28E4D-99B3-4078-BDC4-FC24180CE82B
omero config set omero.jvmcfg.append '--add-opens java.base/java.lang=ALL-UNNAMED --add-exports java.naming/com.sun.jndi.ldap=ALL-UNNAMED'
omero certificates

omero config get
omero admin start
