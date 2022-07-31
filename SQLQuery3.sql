select *
from PorfolioProject2.[dbo].[CovidDeaths]
order by 3,4

select * 
from PorfolioProject2.[dbo].[CovidVaccinations]

Select *
From PorfolioProject2.[dbo].[CovidDeaths]
Where continent is not null 
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject2.[dbo].[CovidDeaths]
Where continent is not null 
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc






---- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProject2.[dbo].[CovidDeaths]
Where location like '%states%'
and continent is not null 
order by 1,2


---- Total Cases vs Population
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PorfolioProject2.[dbo].[CovidDeaths]
order by 1,2


---- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


---- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



---- BREAKING THINGS DOWN BY CONTINENT
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject2.[dbo].[CovidDeaths]
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



---- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PorfolioProject2.[dbo].[CovidDeaths]
where continent is not null 
Group By date




---- Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PorfolioProject2.[dbo].[CovidDeaths] dea
Join PorfolioProject2.[dbo].[CovidVaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


---- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
From PorfolioProject2.[dbo].[CovidDeaths] dea
Join PorfolioProject2.[dbo].[CovidVaccinations]vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*1000
From PopvsVac


