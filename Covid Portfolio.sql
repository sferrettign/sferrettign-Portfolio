/*
Covid 19 Data Exploration 

Select *
FROM PortfolioProject.dbo.coviddeaths

--------
SELECT Location,Date, total_cases, Population , (total_cases/population)*100 as Percentinfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent is not null
Order by 1,2

--------
Select location, Max(total_cases) as Total_Cases, Population, MAX((total_cases/Population))as PercentPopulationInfected
FROM PortfolioProject..Coviddeaths
GROUP BY Location, population
Order by PercentPopulationInfected Desc

--------
SELECT Location,Date, total_cases, Population , (total_cases/population) as Percentinfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE Continent is not null
Order by 1,2

--------
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2



Select location, Max(total_cases) as Total_Cases, Population
FROM PortfolioProject..Coviddeaths
GROUP BY Location, population
Order by total_cases Desc

-- Quiero ver la cantidad de muertos, y si esta disminuye a medida que aumentan las vacunas.
-- mas simple primero solo death/population.
select location, sum(cast(new_deaths as int)) as total_deaths
FROM PortfolioProject..CovidDeaths
Where location = 'Chile'
GROUP BY Location



Select Location, population, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int)/population) as DeathRatio
FROM PortfolioProject..CovidDeaths
WHERE Location = 'Chile'
GROUP by Location, Population
Order by DeathRatio Desc


----- Casos Totales, Población, DeathRatio, %depoblacion infectada.
Select location, Max(total_cases) as Total_Cases, Population
, sum(cast(new_deaths as int)/population) as DeathRatio
, MAX((total_cases/Population))as PercentPopulationInfected
FROM PortfolioProject..Coviddeaths
GROUP BY Location, population
Order by DeathRatio Desc

------ Casos Totales, Población, DeathRatio, %depoblacion infectada y Comparacion de Casos Totales vs Muertes.
SELECT location, population, max(total_cases) as total_cases
, sum(cast(new_deaths as int)) as total_deaths
, sum(cast(new_deaths as int))/sum(new_cases) as DeathRatio
, MAX((total_cases/Population))as PercentPopulationInfected 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP by Location, Population
Order by DeathRatio Desc




SELECT *
FROM PortfolioProject.dbo.CovidVaccinations

SELECT *
FROM PortfolioProject.dbo.CovidDeaths
Where Location = 'Chile'


