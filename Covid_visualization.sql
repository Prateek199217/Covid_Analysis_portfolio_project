-- Select data for visualization 
SELECT *
FROM [covid-project]..['covid-deaths$'];

-- Tableau data visualization on covid table extraction from dataset

--total_cases VS total_deaths and death_percentage
SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS int)) AS total_deaths,
SUM(CAST(new_deaths AS int))*100/ SUM(new_cases) AS death_percentage
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NOT NULL ;

--location VS total_death_count
SELECT location,SUM(CAST(new_deaths AS int)) AS total_deaths
FROM [covid-project]..['covid-deaths$']
WHERE continent IS NULL and location NOT IN ('Lower middle income','World','Low income',
'European Union','International','Upper middle income','High income')
GROUP BY location;

--total infected people country wise
SELECT location,population,MAX(total_cases) AS total_cases,
MAX(total_cases)*100/MAX(population) AS percent_population_infected
FROM [covid-project]..['covid-deaths$']
GROUP BY location,population;

--Infection vs date on a location 
SELECT location,population,date,MAX(total_cases) AS highest_infection_count,
MAX(total_cases)/MAX(population)*100 AS infection_percentage
FROM [covid-project]..['covid-deaths$']
GROUP BY location,population,date
ORDER BY infection_percentage desc;



 