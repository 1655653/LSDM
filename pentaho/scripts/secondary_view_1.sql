SET client_min_messages TO WARNING;  -- reduce verbosity for this transaction

-- Constellation Schema: Country Dimension
create table release_mart.country (id serial primary key, name text);

-- Populating Country Dimension
insert into release_mart.country(name) 
select distinct country 
from release_mart.location_bridge;

-- Creating the Secondary View with the aggregate data
create table release_mart.sv1 (
    country_key integer,
    country_name text,
    release_date integer,
    sales double precision,
    us double precision,
    ms double precision
);

-- Populating the Secondary View
insert into release_mart.sv1 (country_name, release_date, sales, us, ms)
select country, release_date, sum(sales/weight), avg(us), avg(ms)
from (
    select country, release_date, sales, us, ms, weight
    from release_mart.release as x
    join release_mart.location_bridge as y on x.publisher_key = y.softwarehouse_key
    where sales notnull and release_date notnull
) as z
group by country, release_date;

-- Updating the Secondary View with the Surrogate Key for Country
update release_mart.sv1
set country_key = id
from release_mart.country
where name = country_name;

-- Cleaning and Finishing
alter table release_mart.sv1 drop column country_name cascade;
ALTER TABLE release_mart.sv1 ADD PRIMARY KEY (country_key, release_date);
ALTER TABLE release_mart.sv1 ADD CONSTRAINT country_fkey FOREIGN KEY (country_key) REFERENCES release_mart.country(id) MATCH FULL;
