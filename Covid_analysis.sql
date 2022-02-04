-- Select the data on which we want do analysis

SELECT location,date,total_cases, new_cases,total_deaths,population
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL
ORDER BY 1,2;
-- ORDER BY used arrange data by column location and date 

-- Analysis of total_deaths vs total_cases of India
-- it gives result of percentage of death in a country on specific date
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_percentage
FROM [covid-project]..['covid-deaths$']
WHERE location='India'AND continent IS NOT NULL
ORDER BY 1,2;

-- Analysis of total_cases vs population of a country named as %states%
-- It shows us the rate of infection 
SELECT location,date,total_cases,population,(total_cases/population)*100 AS infection_percentage
FROM [covid-project]..['covid-deaths$']
WHERE location like '%states%' AND continent IS NOT NULL
ORDER BY 1,2;

-- Countries with highest infection rate compared to population
SELECT  location,population,MAX(total_cases) AS highest_infection_count, 
		MAX(total_cases/population)*100 AS Infection_rate
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY Infection_rate DESC;

-- Countries with highest death rates on population
SELECT location,MAX(CAST(total_deaths AS int)) AS death_count,MAX(total_deaths/population)*100 AS death_rate_on_population
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_rate_on_population DESC;

-- Continent with highest_death_count
SELECT continent,MAX(CAST(total_deaths AS int)) AS death_count
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY death_count DESC;

-- Global new_cases and new_deaths on date
SELECT date,SUM(new_cases) AS total_cases_on_date,SUM(CAST(new_deaths AS int)) AS total_deaths_on_date
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL 
GROUP BY date;

-- Covid Vaccination analysis
-- Selecting relevent data from covid vaccination table for analysis
SELECT *
FROM [covid-project]..['covid-vaccination$'];

--Joing covid-vacciantion and covid-deaths table
-- total population vs vaccination

SELECT dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date)
AS total_vaccination_over_date
FROM [covid-project]..['covid-vaccination$'] AS vac 
JOIN [covid-project]..['covid-deaths$'] AS dea
ON vac.location=dea.location AND vac.date=dea.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
;

-- Creating a temp table
Create Table population_vacinated
(
continent nvarchar(200),
location nvarchar(180),
date datetime,
population numeric,
new_vaccinations numeric,
total_vaccination_over_date numeric
)
INSERT INTO population_vacinated
SELECT dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date)
AS total_vaccination_over_date
FROM [covid-project]..['covid-vaccination$'] AS vac 
JOIN [covid-project]..['covid-deaths$'] AS dea
ON vac.location=dea.location AND vac.date=dea.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
;

-- Create a view of population_vaccinated
Create View Population_vaccination_view AS
SELECT dea.continent,dea.location,dea.date,population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION by dea.location ORDER BY dea.location,dea.date)
AS total_vaccination_over_date
FROM [covid-project]..['covid-vaccination$'] AS vac 
JOIN [covid-project]..['covid-deaths$'] AS dea
ON vac.location=dea.location AND vac.date=dea.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
;