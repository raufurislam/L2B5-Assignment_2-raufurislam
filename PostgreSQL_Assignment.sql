-- Active: 1747457371350@@127.0.0.1@5432@b2a5
CREATE DATABASE B2A5;

CREATE Table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(150) NOT NULL
);
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');


-- Problem- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');
SELECT * FROM rangers;
DELETE FROM rangers WHERE ranger_id = 4;




-- CREATE Table species (
--     species_id SERIAL PRIMARY KEY,
--     species_id VARCHAR(50) NOT NULL,
--     scientific_name VARCHAR(100) NOT NULL,
--     discovery_date DATE NOT NULL,
--     conservation_status 
-- )