

SELECT *
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



--Data Selection
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Population
SELECT location, date, population, total_cases,  (total_cases/population)*100 as CasePercentage
FROM PortfolioProject..CovidDeaths
where location like '%phil%'
order by 1,2

-- Countries with Highest Infection Rate Compared to Population
SELECT location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as CasePercentage
FROM PortfolioProject..CovidDeaths
Group by Location, Population
order by CasePercentage desc

-- Countries with Highest Death Count per Population
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Continents with Highest Death Count
SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
SELECT date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2 

--Total Population vs Vaccinations
with PopVsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select* , (RollingPeopleVaccinated/population)*100
From PopVsVac


--Create View for Data Storage
Create View	CovidDeathsCount as
Select *
FROM PortfolioProject..CovidDeaths
where continent is not null


 