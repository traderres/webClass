How to Backup your Postgres Database
------------------------------------


References
----------
https://stackoverflow.com/questions/12836312/postgresql-9-2-pg-dump-version-mismatch

Assumptions:
 A) The version of pg_dump in your postgres client matches the pg_dump in your postgres database server
    If you get this error running pg_dumpall
      pg_dumpall version: 9.2.23
      aborting because of server version mismatch

    Then, here's how you fix it:

    1) Find where pg_dump is located on your box
       unix> sudo find / -name pg_dump -type f 2>/dev/null
       /usr/bin/pg_dump
       /usr/pgsql-9.5/bin/pg_dump
 
    2) Change /usr/bin/pg_dump to point to /usr/pgsql-9.5/bin/pg_dump
       unix> sudo ln -s /usr/pgsql-9.5/bin/pg_dump /usr/bin/pg_dump --force

    3) Find where pg_dumpall is located on your box
       unix> sudo sudo find / -name pg_dumpall -type f
       /usr/bin/pg_dumpall
       /usr/pgsql-9.5/bin/pg_dumpall

    4) Change /usr/bin/pg_dumpall to point to /usr/pgsql-9.5/bin/pg_dumpall
       unix> sudo ln -s /usr/pgsql-9.5/bin/pg_dumpall /usr/bin/pg_dumpall --force
    

Backup all schemas in the database
----------------------------------
 1. Backup all schemas in the databases
    unix> sudo -s
    unix> su - postgres
    unix> pg_dumpall > /tmp/all.sql     # Export all databases without being prompted for password

Restore all schemas in the database
-----------------------------------
 1. Approach #1:  Use psql
    unix> sudo -s
    unix> su - postgres
    unix> psql -h localhost -p 5432 -U postgres < /tmp/all.sql



Backup one schema in the database
---------------------------------
 1. Backup one schema found in the databases
    unix> sudo -s
    unix> su - postgres
    unix> pg_dump --create -h localhost -U postgres cde -f /tmp/cde.sql   # Backup the cde schema
    
Restore one schema within the database
--------------------------------------
 1. Drop the old cde database (on your local postgres)
    unix> psql -U postgres -h localhost

	  drop database cde;
	  \q

 2. Create the cde_user  (on your local postgres)
    unix> psql -U postgres -h localhost
 
	  CREATE USER cde_user WITH PASSWORD 'secret';
	  \q

 3. Restore the CDE database (on your local postgres)
    unix> sudo -s
    unix> su - postgres
    unix> psql -h localhost -p 5432 -U postgres < /tmp/cde.sql
    
 4. Make sure your cde_user exists and has permissions to your *local* cde database
    unix> psql -U postgres -h localhost

	  CREATE USER cde_user WITH PASSWORD 'secret';
	  GRANT ALL PRIVILEGES ON DATABASE cde to cde_user;
	  ALTER DATABASE cde  SET search_path=cde;
	  ALTER ROLE cde_user SET search_path=cde;
	  \q

