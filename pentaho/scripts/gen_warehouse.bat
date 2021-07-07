@ECHO OFF


ECHO Starting Pentaho Job
:: Data Integration Transformation
call kitchen.bat /file:..\jobs\j1_main.kjb > gen_warehouse.log
ECHO Reconciled Database Materialized.


:: Dumping Reconciled Schema for future restore
pg_dump --format=c postgresql://infint:infint@localhost:5432/infint > ..\dumps\reconciled.sql

:: Transforming the reconciled schema into the warehouse schema.
psql -f gen_warehouse.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log
ECHO Data Warehouse Materialized.

:: Restoring Reconciled Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\reconciled.sql
psql -d postgresql://infint:infint@localhost:5432/infint -c "alter schema public rename to reconciled" >> gen_warehouse.log

:: Dumping Warehouse Schema for future restore
pg_dump --format=c -n warehouse postgresql://infint:infint@localhost:5432/infint > ..\dumps\warehouse.sql

:: Converting Warehouse to Tournament Mart
psql -f gen_tournament_mart.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log

:: Restoring Warehouse Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\warehouse.sql

:: Converting Warehouse to Release Mart
psql -f gen_release_mart.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log

:: Restoring Warehouse Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\warehouse.sql

ECHO Generation Process terminated.
pause
