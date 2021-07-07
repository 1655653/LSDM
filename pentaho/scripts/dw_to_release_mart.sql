SET client_min_messages TO WARNING;  -- reduce verbosity for this transaction


ALTER SCHEMA warehouse RENAME TO public;

-- //////////////////////////////////////////
-- RELEASE MART

DROP TABLE esport CASCADE;
DROP TABLE tournament CASCADE;
DROP TABLE date CASCADE;

ALTER SCHEMA public RENAME TO release_mart;
