SET client_min_messages TO WARNING;  -- reduce verbosity for this transaction


ALTER SCHEMA warehouse RENAME TO public;

-- //////////////////////////////////////////
-- TOURNAMENT MART

DROP TABLE location_bridge CASCADE;
DROP TABLE softwarehouse CASCADE;
DROP TABLE release CASCADE;

ALTER TABLE esport ADD column title varchar(340);
ALTER TABLE esport ADD column genre varchar(200);
UPDATE esport SET title = videogame.title, genre = videogame.genre FROM videogame WHERE videogame.id = videogame_key;

DROP TABLE videogame CASCADE;


ALTER SCHEMA public RENAME TO tournament_mart;
