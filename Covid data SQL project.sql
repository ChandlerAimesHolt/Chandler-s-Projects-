SELECT *
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
order by 3,4 

--SELECT *
--FROM [Portfolio Project]..CovidVaccinations
--order by 3,4 

-- Select Data that we are going to be using 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
order by 1, 2

--Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage 
FROM [Portfolio Project]..CovidDeaths
where location like '%states%'

--Looking at Total Cases vs Population
SELECT Location, date, total_cases, total_deaths, population, (total_cases/population)*100 as SickPercentage
FROM [Portfolio Project]..CovidDeaths
--where location like '%states%'
order by 1,2

--Looking at countries with Highest Infection Rate compated to Population
SELECT Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population)*100) as HighestInfectionPercentage 
FROM [Portfolio Project]..CovidDeaths
GROUP BY Location, Population
ORDER by HighestInfectionPercentage desc

-- Showing Countries with Highest Death Count per Population
SELECT Location, Max(CAST(total_deaths as INT)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
GROUP BY Location, Population
ORDER by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, Max(CAST(total_deaths as INT)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER by TotalDeathCount desc


-- showing continents with the highest death count per population

SELECT continent, Max(CAST(total_deaths as INT)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER by TotalDeathCount desc


-- Global numbers 

SELECT SUM(new_cases) as total_cases, SUM(CAST(total_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/Sum(new_cases)*100 as 
DeathPercentage
FROM [Portfolio Project].. CovidDeaths
where continent is not null
--GROUP BY date 
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_people_vaccinated
FROM [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


--USE CTE

WITH pop_vs_Vac (Continent, Location, Date, population, New_Vaccinations, Rolling_people_vaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_people_vaccinated
FROM [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT *, (Rolling_people_vaccinated/population)*100
FROM pop_vs_Vac

--TEMP TABLE

Drop TABLE IF EXISTS #percentPopulationvaccinated
Create Table #percentPopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
new_vaccinations numeric, 
Rolling_people_vaccinated numeric
)

Insert into #percentPopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_people_vaccinated
FROM [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

SELECT *, (Rolling_people_vaccinated/population)*100
FROM #percentPopulationvaccinated


-- Creating View to store data for later visualizations
CREATE VIEW percentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) 
as Rolling_people_vaccinated
FROM [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
