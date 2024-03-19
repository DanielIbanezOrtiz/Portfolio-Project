SELECT *
FROM [CO2 Portfolio Project].dbo.['annual-co2-emissions-list-count$']

-- First clean, We organize by countries and filter the amount of information order by countries 


-- Create ExcludedEntities table
CREATE TABLE ExcludedEntities (
    EntityName VARCHAR(255) PRIMARY KEY);

--Double checking that the duplicates dont interfeer

SELECT Entity, COUNT(*) AS Count
FROM [CO2 Portfolio Project].dbo.['annual-co2-emissions-list-count$']
WHERE Year > 1924
AND (Entity LIKE '%(%' OR Entity LIKE '%income%' OR Entity IN ('Antarctica', 'Spain'))
GROUP BY Entity
HAVING COUNT(*) > 1;


-- Populate ExcludedEntities table with data interfeering with the future table 
INSERT INTO ExcludedEntities (EntityName)
SELECT DISTINCT Entity
FROM (
    SELECT Entity
    FROM [CO2 Portfolio Project].dbo.['annual-co2-emissions-list-count$']
    WHERE Year > 1924
    AND (Entity LIKE '%(%' OR Entity LIKE '%income%'OR Entity LIKE '%Asia%' OR Entity LIKE '%Europe%' OR Entity LIKE '%International%' OR Entity LIKE '%South%'OR Entity IN ('Antarctica','Asia','Africa','Europe','World'))
) AS subquery;

--SELECT EntityName
--FROM ExcludedEntities

-- Final table 
SELECT 
    Entity, Year, [Annual COâ‚‚ emissions] AS AnnualEmissions
FROM 
    [CO2 Portfolio Project].dbo.['annual-co2-emissions-list-count$']
WHERE 
    Year > 1924
    AND Entity NOT IN (SELECT EntityName FROM ExcludedEntities);

--Creating table for Tableau 

CREATE VIEW CO2_Emissions_View AS
SELECT 
    Entity, Year, [Annual COâ‚‚ emissions] AS AnnualEmissions
FROM 
    [CO2 Portfolio Project].dbo.['annual-co2-emissions-list-count$']
WHERE 
    Year > 1924
    AND Entity NOT IN (SELECT EntityName FROM ExcludedEntities);

	




