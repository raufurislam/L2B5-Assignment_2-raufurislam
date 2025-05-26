-- Active: 1747457371350@@127.0.0.1@5432@b2a5
CREATE DATABASE B2A5;

CREATE Table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(150) NOT NULL
);

CREATE Table species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (conservation_status IN ('Endangered', 'Vulnerable', 'Historic'))
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species(common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- Problem 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');

SELECT * FROM rangers;
DROP TABLE rangers;
DELETE FROM rangers WHERE ranger_id = 4;

-- Problem 2️⃣ Count unique species ever sighted.
SELECT count(DISTINCT species_id) AS unique_species_count FROM sightings;

SELECT * FROM species;
SELECT * FROM sightings;


-- Problem 3️⃣ Find all sightings where the location includes "Pass".
SELECT * FROM sightings 
    WHERE location ILIKE '%pass';


-- Problem 4️⃣ List each ranger's name and their total number of sightings.
SELECT rangers.name, count(sightings.sighting_id) as total_sightings FROM rangers
    LEFT JOIN sightings
    on rangers.ranger_id = sightings.ranger_id
    GROUP BY rangers.name
    ORDER BY rangers.name ASC;
    

SELECT * FROM rangers;
SELECT * FROM sightings;

-- | name        | total_sightings |
-- |-------------|-----------------|
-- | Alice Green | 1               |
-- | Bob White   | 2               |
-- | Carol King  | 1               |


-- Problem 5️⃣ List species that have never been sighted.

SELECT species.common_name, count(sightings.sighting_id) AS total_sightings 
    FROM species
        LEFT JOIN sightings
        ON species.species_id = sightings.species_id
        GROUP BY species.common_name;

SELECT common_name
    FROM species
        LEFT JOIN sightings
        ON species.species_id = sightings.species_id
        WHERE sightings.sighting_id is NULL;


SELECT * FROM species;


-- | common_name      |
-- |------------------|
-- | Asiatic Elephant |


-- Problem 6️⃣ Show the most recent 2 sightings.
SELECT  species.common_name,sightings.sighting_time, rangers.name FROM sightings
    JOIN species ON sightings.species_id = species.species_id
    JOIN rangers ON sightings.ranger_id = rangers.ranger_id
    ORDER BY sightings.sighting_time DESC
    LIMIT 2
;

SELECT * FROM sightings;

-- | common_name   | sighting_time        | name        |
-- |---------------|----------------------|-------------|
-- | Snow Leopard  | 2024-05-18 18:30:00  | Bob White   |
-- | Red Panda     | 2024-05-15 09:10:00  | Carol King  |


-- Problem 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
SELECT * FROM species
    WHERE discovery_date < '1800-01-01';

UPDATE species
    SET conservation_status = 'Historic'
    WHERE discovery_date < '1800-01-01';

-- AffectedRows : 3
-- (No output needed - this is an UPDATE operation)


-- Problem 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
-- • Morning: before 12 PM
-- • Afternoon: 12 PM–5 PM
-- • Evening: after 5 PM

select sighting_id, 
CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning' 
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
    ELSE 'Evening'
END 
from sightings;


-- | sighting_id | time_of_day |
-- |-------------|-------------|
-- | 1           | Morning     |
-- | 2           | Afternoon   |
-- | 3           | Morning     |
-- | 4           | Evening     |


-- Problem 9️⃣ Delete rangers who have never sighted any species

DELETE FROM rangers
    WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);


-- AffectedRows : 1
-- (No output needed - this is a DELETE operation)