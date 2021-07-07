@ECHO OFF

:: Data Integration Process: Reconciled Schema
ECHO Starting Integration Process (Pentaho Job)
call kitchen.bat /file:..\jobs\j1_main.kjb > gen_warehouse.log
ECHO Reconciled Database Materialized.

:: Dump Reconciled Schema
pg_dump --format=c postgresql://infint:infint@localhost:5432/infint > ..\dumps\reconciled.sql


:: Reconciled Schema -> Warehouse Schema
psql -f reconciled_to_dw.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log
ECHO Warehouse Schema Materialized.

:: Restore Reconciled Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\reconciled.sql
psql -d postgresql://infint:infint@localhost:5432/infint -c "alter schema public rename to reconciled" >> gen_warehouse.log

:: Dump Warehouse Schema
pg_dump --format=c -n warehouse postgresql://infint:infint@localhost:5432/infint > ..\dumps\warehouse.sql


:: Warehouse Schema -> Tournament Mart
psql -f dw_to_tournament_mart.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log
ECHO Tournament Mart Materialized.

:: Restore Warehouse Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\warehouse.sql


:: Warehouse Schema -> Release Mart
psql -f dw_to_release_mart.sql postgresql://infint:infint@localhost:5432/infint >> gen_warehouse.log
ECHO Release Mart Materialized.

:: Restore Warehouse Schema
pg_restore -d postgresql://infint:infint@localhost:5432/infint ..\dumps\warehouse.sql

ECHO Process terminated.
pause
