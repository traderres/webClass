Sample DOS Batch Script to Generate Schema for an existing MySql Database
-------------------------------------------------------------------------

Assumptions:
 A) You have graphviz installed
 B) The graphviz libraries are installed here:
 C) You have downloaded the mysql-java-connector.jar
 D) You have downloaded the schemaspy5.0 jar
 

Sample DOS Batch Script
-----------------------
@echo off

set DEST_DIR=c:\somewhere\to\out\output

set PATH=%PATH%;c:\progra~2\Graphviz\bin

rd /s /q "%DEST_DIR%"

java -jar schemaspy_5.0jar -t mysql -u <username> -p password....

