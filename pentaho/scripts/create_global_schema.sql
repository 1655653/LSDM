DROP SCHEMA IF EXISTS infint CASCADE;
CREATE SCHEMA infint;

-- =============================================================

CREATE TABLE infint.SoftwareHouse
(
	name varchar(300) NOT NULL,
	website varchar(300),
	PRIMARY KEY (name)
);
CREATE INDEX idx_SoftwareHouse_lookup ON infint.SoftwareHouse(name);

-- =============================================================

CREATE TABLE infint.Developer
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name),
	FOREIGN KEY (name) REFERENCES infint.SoftwareHouse(name)
);
CREATE INDEX idx_Developer_lookup ON infint.Developer(name);

-- =============================================================

CREATE TABLE infint.Publisher
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name),
	FOREIGN KEY (name) REFERENCES infint.SoftwareHouse(name)
);
CREATE INDEX idx_Publisher_lookup ON infint.Publisher(name);

-- =============================================================

CREATE TABLE infint.Videogame
(
	title VARCHAR(300) NOT NULL,
	PRIMARY KEY (title)
);
CREATE INDEX idx_Videogame_lookup ON infint.Videogame(title);

-- =============================================================

CREATE TABLE infint.City
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name)
);
CREATE INDEX idx_City_lookup ON infint.City(name);

-- =============================================================

CREATE TABLE infint.Country
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name)
);
CREATE INDEX idx_Country_lookup ON infint.Country(name);

-- =============================================================

CREATE TABLE infint.Publish
(
	videogame VARCHAR(300) NOT NULL,
	publisher VARCHAR(300) NOT NULL,
	PRIMARY KEY (videogame, publisher),
	FOREIGN KEY (videogame) REFERENCES infint.Videogame(title),
	FOREIGN KEY (publisher) REFERENCES infint.Publisher(name)
);

-- =============================================================

CREATE TABLE infint.Develop
(
	videogame VARCHAR(300) NOT NULL,
	developer VARCHAR(300) NOT NULL,
	PRIMARY KEY (videogame, developer),
	FOREIGN KEY (videogame) REFERENCES infint.Videogame(title),
	FOREIGN KEY (developer) REFERENCES infint.Developer(name)
);

-- =============================================================

CREATE TABLE infint.LocatedIn
(
	softwareHouse VARCHAR(300),
	city VARCHAR(300),
	x_coord NUMERIC(20, 8),
	y_coord NUMERIC(20, 8),
	PRIMARY KEY (softwareHouse, city),
	FOREIGN KEY (softwareHouse) REFERENCES infint.SoftwareHouse(name),
	FOREIGN KEY (city) REFERENCES infint.City(name)
);

-- =============================================================

CREATE TABLE infint.HasCountry
(
	city VARCHAR(300),
	country VARCHAR(300),
	PRIMARY KEY (city, country),
	FOREIGN KEY (city) REFERENCES infint.City(name),
	FOREIGN KEY (country) REFERENCES infint.Country(name)
);
