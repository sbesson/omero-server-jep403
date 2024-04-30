OMERO.server on JDK 17+
=======================

This repository is a minimal Docker-based example of the issues
associated with running OMERO.server up to 5.6.10 against JDK 17
LTS and later.

The Docker compose defines 4 containers: a PSQL database container
and 3 containers with OMERO.server running on Java 11, 17 and 21.
These containers can be built and started using the standard
``docker compose`` commands:

    docker compose build
    docker compose up -d

Within each container, the ``init.sh`` script will initialize the database
and sets a minimal OMERO configuration including self-signed certificates.

Java 11
-------

On the Java 11 container, it should be possible to start OMERO.server
immediately after running the initialization script

    docker compose exec jdk11 bash
    (OMERO.venv) omero@e85df0ecd93b:~$ ./init.sh
    ...
    UPDATE 1
    COMMIT
    OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)
    certificates created: /OMERO/certs/server.key /OMERO/certs/server.pem /OMERO/certs/server.p12
    (OMERO.venv) omero@e85df0ecd93b:~$ omero admin start
    WARNING: Your server has not been configured for production use.
    See https://docs.openmicroscopy.org/omero/latest/sysadmins/server-performance.html?highlight=poolsize
    for more information.
    Creating /opt/omero/OMERO.current/var/master
    Initializing /opt/omero/OMERO.current/var/log
    Creating /opt/omero/OMERO.current/var/registry
    No descriptor given. Using etc/grid/default.xml
    Waiting on startup. Use CTRL-C to exit


Java 17+
--------

On the Java 17 and 21 container, running `omero admin start` immediately
after running the initialization script will lead to a startup failure due
to the strong encapsulation enforcement in Java 17 and later
A workaround is to set ``--add-opens`` and ``--add-exports`` using the
``omero.jvmcfg.append`` configuration:

    docker compose exec jdk17 bash
    (OMERO.venv) omero@72b42ffbf2c3:~$ ./init.sh
    ...
    UPDATE 1
    COMMIT
    OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)
    certificates created: /OMERO/certs/server.key /OMERO/certs/server.pem /OMERO/certs/server.p12
    (OMERO.venv) omero@72b42ffbf2c3:~$ omero config set omero.jvmcfg.append '--add-opens java.base/java.lang=ALL-UNNAMED --add-exports java.naming/com.sun.jndi.ldap=ALL-UNNAMED'
    (OMERO.venv) omero@72b42ffbf2c3:~$ omero admin start
    WARNING: Your server has not been configured for production use.
    See https://docs.openmicroscopy.org/omero/latest/sysadmins/server-performance.html?highlight=poolsize
    for more information.
    Creating /opt/omero/OMERO.current/var/master
    Initializing /opt/omero/OMERO.current/var/log
    Creating /opt/omero/OMERO.current/var/registry
    No descriptor given. Using etc/grid/default.xml
    Waiting on startup. Use CTRL-C to exit
    (OMERO.venv) omero@72b42ffbf2c3:~$

References
----------

See also:

* [Migrating from JDK 8](https://docs.oracle.com/en/java/javase/17/migrate/migrating-jdk-8-later-jdk-releases.html#GUID-7BB28E4D-99B3-4078-BDC4-FC24180CE82B)
* [JEP 403](https://openjdk.org/jeps/403)
* https://github.com/ome/openmicroscopy/issues/6383
