SET client_min_messages TO WARNING;  -- reduce verbosity for this transaction


-- //////////////////////////////////////////
-- VIDEOGAME SURROGATE KEY

ALTER TABLE videogame ADD column id serial;
ALTER TABLE released_for ADD column videogame_key integer;
UPDATE released_for SET videogame_key = videogame.id FROM videogame WHERE videogame.title = released_for.title;
ALTER TABLE released_for DROP CONSTRAINT released_for_pkey;
ALTER TABLE released_for DROP COLUMN title cascade;
ALTER TABLE released_for ADD PRIMARY KEY (videogame_key, platform);
ALTER TABLE videogame DROP CONSTRAINT videogame_pkey CASCADE;
ALTER TABLE videogame ADD PRIMARY KEY (id);
ALTER TABLE released_for ADD CONSTRAINT released_for_videogame_fkey FOREIGN KEY (videogame_key) REFERENCES videogame(id) MATCH FULL;


-- //////////////////////////////////////////
-- SOFTWAREHOUSE SURROGATE KEY

ALTER TABLE softwarehouse ADD column id serial;
ALTER TABLE softwarehouse DROP CONSTRAINT softwarehouse_pkey CASCADE;
ALTER TABLE softwarehouse ADD PRIMARY KEY (id);

-- correct released_for: developer
ALTER TABLE released_for ADD column developer_key integer;
UPDATE released_for SET developer_key = softwarehouse.id FROM softwarehouse WHERE softwarehouse.name = released_for.developer;
ALTER TABLE released_for DROP CONSTRAINT released_for_developer_fkey CASCADE;
ALTER TABLE released_for ADD CONSTRAINT released_for_developer_fkey FOREIGN KEY (developer_key) REFERENCES softwarehouse(id);
ALTER TABLE released_for DROP COLUMN developer;
DROP TABLE developer;

-- correct released_for: publisher
ALTER TABLE released_for ADD column publisher_key integer;
UPDATE released_for SET publisher_key = softwarehouse.id FROM softwarehouse WHERE softwarehouse.name = released_for.publisher;
ALTER TABLE released_for DROP CONSTRAINT released_for_publisher_fkey CASCADE;
ALTER TABLE released_for ADD CONSTRAINT released_for_publisher_fkey FOREIGN KEY (publisher_key) REFERENCES softwarehouse(id);
ALTER TABLE released_for DROP COLUMN publisher;
DROP TABLE publisher;
 
 -- correct locatedin
ALTER TABLE locatedin ADD column softwarehouse_key integer;
UPDATE locatedin SET softwarehouse_key = softwarehouse.id FROM softwarehouse WHERE softwarehouse.name = locatedin.softwarehouse;
ALTER TABLE locatedin DROP COLUMN softwarehouse cascade;
ALTER TABLE locatedin ADD PRIMARY KEY (softwarehouse_key, city, country);
ALTER TABLE locatedin 
ADD CONSTRAINT locatedin_softwarehouse_fkey FOREIGN KEY (softwarehouse_key) REFERENCES softwarehouse(id);


-- //////////////////////////////////////////
-- DROP CONSOLE, LOCATION (not needed)

DROP TABLE console cascade;
ALTER TABLE released_for RENAME COLUMN platform TO console;

DROP TABLE location cascade;


-- //////////////////////////////////////////
-- ESPORT

ALTER TABLE esport ADD column videogame_key integer;
UPDATE esport SET videogame_key = videogame.id FROM videogame WHERE videogame.title = esport.title;
ALTER TABLE esport DROP COLUMN title cascade;
ALTER TABLE esport ADD PRIMARY KEY (videogame_key);
ALTER TABLE esport ADD CONSTRAINT esport_videogame_fkey FOREIGN KEY (videogame_key) REFERENCES videogame(id) MATCH FULL;

ALTER TABLE esport ADD column tot_Online_Earnings float;
ALTER TABLE esport ADD column tot_Offline_Earnings float;
ALTER TABLE esport ADD column tot_Earnings float;
UPDATE esport SET tot_Online_Earnings= cast(onlineearnings as float);
UPDATE esport SET tot_Offline_Earnings= cast(totalearnings as float) - tot_Online_Earnings; 
UPDATE esport SET tot_Earnings = tot_Offline_Earnings + tot_Online_Earnings;
ALTER TABLE esport DROP COLUMN onlineearnings;
ALTER TABLE esport DROP COLUMN totalearnings;


-- //////////////////////////////////////////
-- TOURNAMENT

ALTER TABLE tournament ADD column esport_key integer;
UPDATE tournament SET esport_key = videogame.id FROM videogame WHERE videogame.title = tournament.title;
ALTER TABLE tournament DROP COLUMN title cascade;
ALTER TABLE tournament ADD PRIMARY KEY (esport_key, date);
ALTER TABLE tournament ADD CONSTRAINT tournament_esport_fkey FOREIGN KEY (esport_key) REFERENCES esport(videogame_key) MATCH FULL;
ALTER TABLE tournament RENAME COLUMN nevents TO num_events;
ALTER TABLE tournament RENAME COLUMN priced_players TO num_players;


-- //////////////////////////////////////////
-- TOURNAMENT DATE

CREATE TABLE date (id serial PRIMARY KEY, month timestamp, year timestamp);
INSERT INTO date(month) SELECT date FROM tournament;
UPDATE date SET year = date_trunc('year', month);
ALTER TABLE tournament ADD column date_key integer;
UPDATE tournament SET date_key = date.id FROM date WHERE date.month = tournament.date;
ALTER TABLE tournament DROP COLUMN date cascade;
ALTER TABLE tournament ADD PRIMARY KEY (esport_key, date_key);
ALTER TABLE tournament ADD CONSTRAINT tournament_date_fkey FOREIGN KEY (date_key) REFERENCES date(id) MATCH FULL;


-- //////////////////////////////////////////
-- FINAL MODIFICATIONS AND RENAMING

ALTER TABLE released_for RENAME TO release;
ALTER TABLE locatedin RENAME TO location_bridge;
ALTER SCHEMA public RENAME TO warehouse;
CREATE SCHEMA public;
