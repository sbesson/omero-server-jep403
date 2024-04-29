OMERO.server on JDK 17+
=======================

This repository is a minimal Docker-based example of the issues
associated with running OMERO.server up to 5.6.10 against JDK 17
LTS and later.

See https://github.com/ome/openmicroscopy/issues/6383 for more
details


    docker compose build
    docker compose up -d


See also:

* [Migrating from JDK 8](https://docs.oracle.com/en/java/javase/17/migrate/migrating-jdk-8-later-jdk-releases.html#GUID-7BB28E4D-99B3-4078-BDC4-FC24180CE82B)
* [JEP 403](https://openjdk.org/jeps/403)
