--Utilisateurs
CREATE TABLE login_session (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL REFERENCES user_info(username),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_cas TEXT,
    token TEXT
);

CREATE TABLE user_info (
	username	TEXT PRIMARY KEY,
	password_hash	TEXT,
	nom	TEXT NOT NULL,
	prenom	TEXT NOT NULL,
	tel	TEXT,
	courriel TEXT,
	groupe	INTEGER,
	connexion	TIMESTAMP DEFAULT Null,
	activation	TEXT DEFAULT Null,
	consentement	INTEGER,
	creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE permissions(
    groupes TEXT,
    groupes_id INTEGER UNIQUE
);
---------------------------------------
-- Trajets
CREATE TABLE trajets (
    id INTEGER PRIMARY KEY,
    user_id TEXT,
    jour TIMESTAMP,
    heure TIMESTAMP,
    depart TEXT,
    dep_Lon DECIMAL,
    dep_Lat DECIMAL,
    arrivee TEXT,
    arr_Lon DECIMAL,
    arr_Lat DECIMAL,
    places INTEGER NOT NULL,
    reserves INTEGER,
    infos TEXT
);

CREATE TABLE arrets (
	trajet_id INTEGER REFERENCES trajets(id),
	aire_id INTEGER REFERENCES aires(id)
);

---------------------------------------
-- Réservations
CREATE TABLE resa (
    id INTEGER PRIMARY KEY,
    user_id TEXT,
    trajet_id INTEGER REFERENCES trajets(id),
    places INTEGER NOT NULL,
    aire INTEGER REFERENCES aires(id),
    tel	TEXT,
    courriel TEXT,
    infos TEXT,
    validation INTEGER
);

---------------------------------------
-- Divers

CREATE TABLE aires (
    id INTEGER PRIMARY KEY,
    covoit TEXT,
    covoit_Lon DECIMAL,
    covoit_Lat DECIMAL
);

CREATE TABLE besoins (
    id INTEGER PRIMARY KEY,
    user_id TEXT,
    courriel TEXT,
    besoin TEXT,
    jour TIMESTAMP,
    heure TIMESTAMP,    
    besoin_Lon DECIMAL,
    besoin_Lat DECIMAL,
    precisions TEXT
);

CREATE TABLE localisation (
    id INTEGER PRIMARY KEY,
    loc TEXT,
    loc_Lon DECIMAL,
    loc_Lat DECIMAL
);
