DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- =============================================================

CREATE TABLE SoftwareHouse
(
	name varchar(300) NOT NULL,
	website varchar(300),
	PRIMARY KEY (name)
);
CREATE INDEX idx_SoftwareHouse_lookup ON SoftwareHouse(name);

-- =============================================================

CREATE TABLE Developer
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name),
	FOREIGN KEY (name) REFERENCES SoftwareHouse(name)
);
CREATE INDEX idx_Developer_lookup ON Developer(name);

-- =============================================================

CREATE TABLE Publisher
(
	name varchar(300) NOT NULL,
	PRIMARY KEY (name),
	FOREIGN KEY (name) REFERENCES SoftwareHouse(name)
);
CREATE INDEX idx_Publisher_lookup ON Publisher(name);

-- =============================================================

CREATE TABLE Videogame
(
  title VARCHAR(340),
  genre VARCHAR(200),
  PRIMARY KEY (title)
);
CREATE INDEX idx_videogame_lookup ON Videogame(title);

-- =============================================================

CREATE TABLE Publish
(
	videogame VARCHAR(300) NOT NULL,
	publisher VARCHAR(300) NOT NULL,
	PRIMARY KEY (videogame, publisher),
	FOREIGN KEY (videogame) REFERENCES Videogame(title),
	FOREIGN KEY (publisher) REFERENCES Publisher(name)
);

-- =============================================================

CREATE TABLE Develop
(
	videogame VARCHAR(300) NOT NULL,
	developer VARCHAR(300) NOT NULL,
	PRIMARY KEY (videogame, developer),
	FOREIGN KEY (videogame) REFERENCES Videogame(title),
	FOREIGN KEY (developer) REFERENCES Developer(name)
);

-- =============================================================

CREATE TABLE Location
(
	city varchar(300) NOT NULL,
	country varchar(300) NOT NULL,
	PRIMARY KEY (city, country)
);

-- =============================================================

CREATE TABLE LocatedIn
(
	softwareHouse VARCHAR(300),
	city VARCHAR(300),
	country VARCHAR(300),
	x_coord NUMERIC(20, 8),
	y_coord NUMERIC(20, 8),
	PRIMARY KEY (softwareHouse, city, country),
	FOREIGN KEY (softwareHouse) REFERENCES SoftwareHouse(name),
	FOREIGN KEY (city,country) REFERENCES Location(city,country)
);

-- =============================================================

CREATE TABLE Console
(
	platform VARCHAR(10),
	PRIMARY KEY (platform)
);

-- =============================================================

CREATE TABLE Released_for
(
	title VARCHAR(340),
	platform VARCHAR(10),
	release_date DOUBLE PRECISION,
	us DOUBLE PRECISION,
	ms DOUBLE PRECISION,
	sales DOUBLE PRECISION,
	PRIMARY KEY (title,platform),
	FOREIGN KEY (title) REFERENCES Videogame(title),
	FOREIGN KEY (platform) REFERENCES Console(platform)
);

-- =============================================================

CREATE TABLE Esport
(
	title VARCHAR(530), 
	TotalEarnings VARCHAR(120), 
	OnlineEarnings VARCHAR(120), 
	PRIMARY KEY (title), 
	FOREIGN KEY (title) REFERENCES Videogame(title)
);

-- =============================================================

CREATE TABLE Tournament
(
	title VARCHAR(300), 
	date TIMESTAMP, 
	Earnings BIGINT, 
	priced_players BIGINT, 
	Nevents BIGINT, 
	PRIMARY KEY (date,title), 
	FOREIGN KEY (title) REFERENCES Videogame(title)
);