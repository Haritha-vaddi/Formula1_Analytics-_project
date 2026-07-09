# drivers
SELECT driverId, COUNT(*)
FROM drivers
GROUP BY driverId
HAVING COUNT(*) > 1; #check for duplicate values

ALTER TABLE drivers
ADD PRIMARY KEY (driverId); #create primary key

SHOW CREATE TABLE drivers; #show the primary key
DESCRIBE TABLE drivers;

#circuits
SELECT circuitId, COUNT(*)
FROM circuits
GROUP BY circuitId
HAVING COUNT(*) > 1;

ALTER TABLE circuits
ADD PRIMARY KEY (circuitId);

SHOW CREATE TABLE circuits;
DESCRIBE TABLE circuits;

# constructors
SELECT constructorId, COUNT(*)
FROM constructors
GROUP BY constructorId
HAVING COUNT(*) > 1;

ALTER TABLE constructors
ADD PRIMARY KEY (constructorId);

SHOW CREATE TABLE constructors;
DESCRIBE TABLE constructors;

# constructor_results
SELECT constructorResultsId, COUNT(*)
FROM constructor_results
GROUP BY constructorResultsId
HAVING COUNT(*) > 1;

ALTER TABLE constructor_results
ADD PRIMARY KEY (constructorResultsId);

SHOW CREATE TABLE constructor_results;
DESCRIBE TABLE constructor_results;

# consrtuctor_standings
SELECT constructorStandingsId, COUNT(*)
FROM constructor_standings
GROUP BY constructorStandingsId
HAVING COUNT(*) > 1;

ALTER TABLE constructor_standings
ADD PRIMARY KEY (constructorStandingsId);

SHOW CREATE TABLE constructor_standings;
DESCRIBE TABLE constructor_standings;

#  races
SELECT raceId, COUNT(*)
FROM races
GROUP BY raceId
HAVING COUNT(*) > 1;

ALTER TABLE races
ADD PRIMARY KEY (raceId);

ShOW CREATE TABLE races;
DESCRIBE races;

#  results
SELECT resultId, COUNT(*)
FROM results
GROUP BY resultId
HAVING COUNT(*) > 1;

ALTER TABLE results
ADD PRIMARY KEY (resultId);

DESCRIBE results;

# qualifying
SELECT qualifyId, COUNT(*)
FROM qualifying
GROUP BY qualifyId
HAVING COUNT(*) > 1;

ALTER TABLE qualifying
ADD PRIMARY KEY (qualifyId);

DESCRIBE qualifying;

# seasons
SELECT year, COUNT(*)
FROM seasons
GROUP BY year
HAVING COUNT(*) > 1;

ALTER TABLE seasons
ADD PRIMARY KEY (year);

DESCRIBE seasons;

#status
SELECT statusId, COUNT(*)
FROM status
GROUP BY statusId
HAVING COUNT(*) > 1;

ALTER TABLE status
ADD PRIMARY KEY (statusId);

DESCRIBE status;

# sprint_results
SELECT resultId, COUNT(*)
FROM sprint_results
GROUP BY resultId
HAVING COUNT(*) > 1;

ALTER TABLE sprint_results
ADD PRIMARY KEY (resultId);

DESCRIBE sprint_results;

# lap_times
SELECT raceId, driverId, lap, COUNT(*)
FROM lap_times
GROUP BY raceId, driverId, lap
HAVING COUNT(*) > 1;

ALTER TABLE lap_times
ADD PRIMARY KEY (raceId, driverId, lap);

DESCRIBE lap_times;

# pit_stops
SELECT raceId, driverId, stop, COUNT(*)
FROM pit_stops
GROUP BY raceId, driverId, stop
HAVING COUNT(*) > 1;

ALTER TABLE pit_stops
ADD PRIMARY KEY (raceId, driverId, stop);

DESCRIBE pit_stops;





-- Foreign keys
# races
ALTER TABLE races
ADD CONSTRAINT fk_races_circuit
FOREIGN KEY (circuitId)
REFERENCES circuits(circuitId);

ALTER TABLE races
ADD CONSTRAINT fk_races_year
FOREIGN KEY (year)
REFERENCES seasons(year);

SHOW CREATE TABLE races;

# results
ALTER TABLE results
ADD CONSTRAINT fk_results_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE results
ADD CONSTRAINT fk_results_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

ALTER TABLE results
ADD CONSTRAINT fk_results_constructor
FOREIGN KEY (constructorId)
REFERENCES constructors(constructorId);

ALTER TABLE results
ADD CONSTRAINT fk_results_status
FOREIGN KEY (statusId)
REFERENCES status(statusId);

SHOW CREATE TABLE results;

# qualifying
ALTER TABLE qualifying
ADD CONSTRAINT fk_qualifying_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE qualifying
ADD CONSTRAINT fk_qualifying_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

ALTER TABLE qualifying
ADD CONSTRAINT fk_qualifying_constructor
FOREIGN KEY (constructorId)
REFERENCES constructors(constructorId);

SHOW CREATE TABLE qualifying;

# driver_standings
ALTER TABLE driver_standings
ADD CONSTRAINT fk_driverstandings_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE driver_standings
ADD CONSTRAINT fk_driverstandings_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

SHOW CREATE TABLE driver_standings;

# consrtuctor_results
ALTER TABLE constructor_results
ADD CONSTRAINT fk_constructorresults_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE constructor_results
ADD CONSTRAINT fk_constructorresults_constructor
FOREIGN KEY (constructorId)
REFERENCES constructors(constructorId);

SHOW CREATE TABLE constructor_results;

# constructor_standings
ALTER TABLE constructor_standings
ADD CONSTRAINT fk_constructorstandings_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE constructor_standings
ADD CONSTRAINT fk_constructorstandings_constructor
FOREIGN KEY (constructorId)
REFERENCES constructors(constructorId);

SHOW CREATE TABLE constructor_standings;

# lap_times
ALTER TABLE lap_times
ADD CONSTRAINT fk_laptimes_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE lap_times
ADD CONSTRAINT fk_laptimes_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

SHOW CREATE TABLE lap_times;

# pit_stops
ALTER TABLE pit_stops
ADD CONSTRAINT fk_pitstops_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE pit_stops
ADD CONSTRAINT fk_pitstops_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

SHOW CREATE TABLE pit_stops;

# sprint_results
ALTER TABLE sprint_results
ADD CONSTRAINT fk_sprintresults_race
FOREIGN KEY (raceId)
REFERENCES races(raceId);

ALTER TABLE sprint_results
ADD CONSTRAINT fk_sprintresults_driver
FOREIGN KEY (driverId)
REFERENCES drivers(driverId);

ALTER TABLE sprint_results
ADD CONSTRAINT fk_sprintresults_constructor
FOREIGN KEY (constructorId)
REFERENCES constructors(constructorId);

ALTER TABLE sprint_results
ADD CONSTRAINT fk_sprintresults_status
FOREIGN KEY (statusId)
REFERENCES status(statusId);

SHOW CREATE TABLE sprint_results;






-- DATA VALIDATION
# check the number of rows

SELECT COUNT(*) FROM seasons;

SELECT COUNT(*) FROM circuits;

SELECT COUNT(*) FROM constructors;

SELECT COUNT(*) FROM drivers;

SELECT COUNT(*) FROM races;

SELECT COUNT(*) FROM results;

SELECT COUNT(*) FROM qualifying;

SELECT COUNT(*) FROM constructor_results;

SELECT COUNT(*) FROM constructor_standings;

SELECT COUNT(*) FROM driver_standings;

SELECT COUNT(*) FROM lap_times;

SELECT COUNT(*) FROM pit_stops;

SELECT COUNT(*) FROM sprint_results;

SELECT COUNT(*) FROM status;


# DATA QUALITY check table
# drivers
SELECT *
FROM drivers
WHERE driverId IS NULL;

# races
SELECT *
FROM races
WHERE raceId IS NULL;

# results
SELECT *
FROM results
WHERE resultId IS NULL;


# understand the database before solving the business case questions

SELECT *
FROM drivers
LIMIT 10;

SELECT *
FROM races
LIMIT 10;

SELECT *
FROM results
LIMIT 10;

SELECT *
FROM constructors
LIMIT 10;



-- SQL BUSINESS ANALYSIS
#1.Which driver has won the most Formula 1 races?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    COUNT(*) AS Total_Wins
FROM results r
JOIN drivers d
    ON r.driverId = d.driverId
WHERE r.positionOrder = 1
GROUP BY d.driverId, d.forename, d.surname
ORDER BY Total_Wins DESC
LIMIT 10;

#2.Which Formula 1 constructor (team) has won the most races?
SELECT
    c.constructorId,
    c.name AS Constructor_Name,
    COUNT(*) AS Total_Wins
FROM results r
JOIN constructors c
    ON r.constructorId = c.constructorId
WHERE r.positionOrder = 1
GROUP BY c.constructorId, c.name
ORDER BY Total_Wins DESC
LIMIT 10;

#3.Which countries have produced the highest number of Formula 1 drivers?

SELECT
    nationality,
    COUNT(driverId) AS Total_Drivers
FROM drivers
GROUP BY nationality
ORDER BY Total_Drivers DESC
LIMIT 10;

#4.Which circuits have hosted the highest number of Formula 1 races?
SELECT
    c.circuitId,
    c.name AS Circuit_Name,
    c.country,
    COUNT(r.raceId) AS Total_Races
FROM races r
JOIN circuits c
    ON r.circuitId = c.circuitId
GROUP BY c.circuitId, c.name, c.country
ORDER BY Total_Races DESC
LIMIT 10;

#5.Which drivers have achieved the highest number of podium finishes (Top 3 positions)?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    COUNT(*) AS Total_Podiums
FROM results r
JOIN drivers d
    ON r.driverId = d.driverId
WHERE r.positionOrder IN (1, 2, 3)
GROUP BY d.driverId, d.forename, d.surname
ORDER BY Total_Podiums DESC
LIMIT 10;

#6 Which drivers have scored the highest career points in Formula 1?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    ROUND(SUM(r.points), 2) AS Total_Points
FROM results r
JOIN drivers d
    ON r.driverId = d.driverId
GROUP BY d.driverId, d.forename, d.surname
ORDER BY Total_Points DESC
LIMIT 10;

#7.Which Formula 1 seasons had the highest number of races?
SELECT
    year,
    COUNT(raceId) AS Total_Races
FROM races
GROUP BY year
ORDER BY Total_Races DESC
LIMIT 10;

#8.Which countries have hosted the highest number of Formula 1 Grand Prix races?
SELECT
    c.country,
    COUNT(r.raceId) AS Total_Grand_Prix
FROM races r
JOIN circuits c
    ON r.circuitId = c.circuitId
GROUP BY c.country
ORDER BY Total_Grand_Prix DESC
LIMIT 10;

#9.Which drivers have the best average finishing position in Formula 1?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    ROUND(AVG(r.positionOrder), 2) AS Average_Finish
FROM results r
JOIN drivers d
    ON r.driverId = d.driverId
WHERE r.positionOrder IS NOT NULL
GROUP BY d.driverId, d.forename, d.surname
HAVING COUNT(r.resultId) >= 20
ORDER BY Average_Finish ASC
LIMIT 10;

#10.Which constructors (teams) have the highest race finish rate (fewest retirements)?
SELECT
    c.constructorId,
    c.name AS Constructor_Name,
    COUNT(*) AS Total_Races,
    SUM(CASE
            WHEN s.status = 'Finished' THEN 1
            ELSE 0
        END) AS Finished_Races,
    ROUND(
        (SUM(CASE
                WHEN s.status = 'Finished' THEN 1
                ELSE 0
            END) * 100.0) / COUNT(*),
        2
    ) AS Finish_Rate_Percentage
FROM results r
JOIN constructors c
    ON r.constructorId = c.constructorId
JOIN status s
    ON r.statusId = s.statusId
GROUP BY c.constructorId, c.name
HAVING COUNT(*) >= 100
ORDER BY Finish_Rate_Percentage DESC
LIMIT 10;

#11.Which drivers gained the most positions during races on average?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    ROUND(AVG(r.grid - r.positionOrder), 2) AS Avg_Positions_Gained
FROM results r
JOIN drivers d
ON r.driverId = d.driverId
WHERE r.grid > 0
AND r.positionOrder > 0
GROUP BY d.driverId, d.forename, d.surname
HAVING COUNT(r.resultId) >= 20
ORDER BY Avg_Positions_Gained DESC
LIMIT 10;

#12.Which circuits have the highest average points awarded per race?
SELECT 
    c.circuitId,
    c.name AS Circuit_Name,
    c.country,
    ROUND(AVG(r.points), 2) AS Avg_Points
FROM results r
JOIN races ra
    ON r.raceId = ra.raceId
JOIN circuits c
    ON ra.circuitId = c.circuitId
GROUP BY c.circuitId, c.name, c.country
ORDER BY Avg_Points DESC
LIMIT 10;

#13.Which drivers have scored more career points than the average career points of all drivers?
SELECT
    d.driverId,
    CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
    ROUND(SUM(r.points), 2) AS Total_Points
FROM results r
JOIN drivers d
    ON r.driverId = d.driverId
GROUP BY d.driverId, d.forename, d.surname
HAVING SUM(r.points) >
(
    SELECT AVG(driver_points)
    FROM
    (
        SELECT SUM(points) AS driver_points
        FROM results
        GROUP BY driverId
    ) AS avg_points
)
ORDER BY Total_Points DESC;

#14.Which driver scored the highest total points in each Formula 1 season?
WITH DriverSeasonPoints AS
(
    SELECT
        ra.year,
        d.driverId,
        CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
        SUM(r.points) AS Total_Points
    FROM results r
    JOIN drivers d
        ON r.driverId = d.driverId
    JOIN races ra
        ON r.raceId = ra.raceId
    GROUP BY ra.year, d.driverId, d.forename, d.surname
)

SELECT dsp.year,
       dsp.Driver_Name,
       dsp.Total_Points
FROM DriverSeasonPoints dsp
JOIN
(
    SELECT
        year,
        MAX(Total_Points) AS Max_Points
    FROM DriverSeasonPoints
    GROUP BY year
) top_driver
ON dsp.year = top_driver.year
AND dsp.Total_Points = top_driver.Max_Points
ORDER BY dsp.year;

#15.Rank the top 10 drivers based on their total career points in Formula 1.
WITH DriverPoints AS
(
    SELECT
        d.driverId,
        CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
        ROUND(SUM(r.points), 2) AS Total_Points
    FROM results r
    JOIN drivers d
        ON r.driverId = d.driverId
    GROUP BY d.driverId, d.forename, d.surname
)

SELECT
    RANK() OVER (ORDER BY Total_Points DESC) AS Driver_Rank,
    Driver_Name,
    Total_Points
FROM DriverPoints
LIMIT 10;

#16.Rank the top constructors in each Formula 1 season based on total points scored.
WITH ConstructorSeasonPoints AS
(
    SELECT
        ra.year,
        c.constructorId,
        c.name AS Constructor_Name,
        SUM(r.points) AS Total_Points
    FROM results r
    JOIN constructors c
        ON r.constructorId = c.constructorId
    JOIN races ra
        ON r.raceId = ra.raceId
    GROUP BY
        ra.year,
        c.constructorId,
        c.name
)

SELECT
    year,
    Constructor_Name,
    Total_Points,
    DENSE_RANK() OVER
    (
        PARTITION BY year
        ORDER BY Total_Points DESC
    ) AS Season_Rank
FROM ConstructorSeasonPoints
ORDER BY
    year,
    Season_Rank;
    
#17.Who was the highest-scoring driver for each constructor in Formula 1 history?
WITH DriverConstructorPoints AS
(
    SELECT
        c.constructorId,
        c.name AS Constructor_Name,
        d.driverId,
        CONCAT(d.forename, ' ', d.surname) AS Driver_Name,
        SUM(r.points) AS Total_Points
    FROM results r
    JOIN drivers d
        ON r.driverId = d.driverId
    JOIN constructors c
        ON r.constructorId = c.constructorId
    GROUP BY
        c.constructorId,
        c.name,
        d.driverId,
        d.forename,
        d.surname
)

SELECT
    Constructor_Name,
    Driver_Name,
    Total_Points
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY Constructor_Name
               ORDER BY Total_Points DESC
           ) AS rn
    FROM DriverConstructorPoints
) ranked
WHERE rn = 1
ORDER BY Total_Points DESC;

#18.Which constructors have the fastest average pit stop duration?
SELECT
    c.constructorId,
    c.name AS Constructor_Name,
    ROUND(AVG(ps.milliseconds) / 1000, 2) AS Avg_Pit_Stop_Seconds
FROM pit_stops ps
JOIN results r
    ON ps.raceId = r.raceId
   AND ps.driverId = r.driverId
JOIN constructors c
    ON r.constructorId = c.constructorId
WHERE ps.milliseconds IS NOT NULL
GROUP BY
    c.constructorId,
    c.name
HAVING COUNT(*) >= 50
ORDER BY Avg_Pit_Stop_Seconds ASC
LIMIT 10;

#19.Which circuits have the highest retirement (DNF) rate in Formula 1?
SELECT
    c.circuitId,
    c.name AS Circuit_Name,
    c.country,
    COUNT(*) AS Total_Results,
    SUM(
        CASE
            WHEN s.status <> 'Finished' THEN 1
            ELSE 0
        END
    ) AS Total_DNFs,
    ROUND(
        SUM(
            CASE
                WHEN s.status <> 'Finished' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS DNF_Rate_Percentage
FROM results r
JOIN races ra
    ON r.raceId = ra.raceId
JOIN circuits c
    ON ra.circuitId = c.circuitId
JOIN status s
    ON r.statusId = s.statusId
GROUP BY
    c.circuitId,
    c.name,
    c.country
HAVING COUNT(*) >= 100
ORDER BY DNF_Rate_Percentage DESC
LIMIT 10;

#20.Which constructor achieved the highest average finishing position in each Formula 1 season?
WITH ConstructorSeasonPerformance AS
(
    SELECT
        ra.year,
        c.constructorId,
        c.name AS Constructor_Name,
        ROUND(AVG(r.positionOrder),2) AS Avg_Finish_Position
    FROM results r
    JOIN constructors c
        ON r.constructorId = c.constructorId
    JOIN races ra
        ON r.raceId = ra.raceId
    WHERE r.positionOrder > 0
    GROUP BY
        ra.year,
        c.constructorId,
        c.name
)

SELECT
    year,
    Constructor_Name,
    Avg_Finish_Position
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY year
               ORDER BY Avg_Finish_Position ASC
           ) AS rn
    FROM ConstructorSeasonPerformance
) RankedTeams
WHERE rn = 1
ORDER BY year;





-- KPI's

#1. How many drivers are in the dataset?
SELECT COUNT(*) AS Total_Drivers
FROM drivers;

#2.Total consrtuctors
SELECT COUNT(*) AS Total_Constructors
FROM constructors;

#3.Total circuits
SELECT COUNT(*) AS Total_Circuits
FROM circuits;

#4.Total races
SELECT COUNT(*) AS Total_Races
FROM races;

#5.Total seasons
SELECT COUNT(*) AS Total_Seasons
FROM seasons;

#6.Total race winners
SELECT COUNT(*) AS Total_Wins
FROM results
WHERE positionOrder = 1;

#7.Total podium finishes
SELECT COUNT(*) AS Total_Podiums
FROM results
WHERE positionOrder IN (1,2,3);

#8.Total Championship Points Awarded
SELECT ROUND(SUM(points),2) AS Total_Points
FROM results;

#9.Total Pole Positions
SELECT COUNT(*) AS Total_Pole_Positions
FROM qualifying
WHERE position = 1;

#10.Total Fastest Laps
SELECT COUNT(*) AS Total_Fastest_Laps
FROM results
WHERE fastestLap IS NOT NULL;

#11.Average Points Per Race
SELECT ROUND(AVG(points),2) AS Avg_Points
FROM results;

#12.Average Grid Position
SELECT ROUND(AVG(grid),2) AS Avg_Grid_Position
FROM results
WHERE grid > 0;

#13.Average Finish Position
SELECT ROUND(AVG(positionOrder),2) AS Avg_Finish_Position
FROM results
WHERE positionOrder > 0;

#14.Total Pit Stops
SELECT COUNT(*) AS Total_Pit_Stops
FROM pit_stops;

#15.Total Qualifying Sessions
SELECT COUNT(*) AS Total_Qualifying_Entries
FROM qualifying;




