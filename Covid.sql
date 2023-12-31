Select *
From PortProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--from PortProject..CovidVaccinations
--order by 3,4

--Select Data To Use

Select location, date, total_cases,new_cases,total_deaths,population
From PortProject..CovidDeaths
order by 1,2

--Analyzing Total Cases vs Total Deaths
--Covid impact in South Africa from 2020 to 2021

Select location, date, total_cases,total_deaths, (total_deaths/total_cases) *100 as Deathpercentage
From PortProject..CovidDeaths
where location like '%South Africa%'
order by 1,2

--Analyzing Total Cases vs Population
--Displays what percentage of the population got covid

Select location, date,population, total_cases,(total_cases/population) *100 as PercentPopulationInfected
From PortProject..CovidDeaths
--where location like '%South Africa%'
Order by 1,2

--Countries with Highest Infection Rate compared to Population

Select location, population,MAX(total_cases) as HighestInfectionCount , MAX ((total_cases/population)) *100 as PercentPopulationInfected
From PortProject..CovidDeaths
--Where location like '%South Africa%'
Group by location , population
Order by PercentPopulationInfected desc



--Display Continets

Select location, MAX(cast (Total_deaths as int)) as TotalDeathCount
From PortProject..CovidDeaths
--where location like '%South Africa%'
where continent is null
Group by location
Order by TotalDeathCount desc




--Global Numbers

Select Sum(new_cases)as total_cases, Sum( cast (new_deaths as int))as total_deaths, Sum( cast(new_deaths as int))/Sum(new_cases) *100 as DeathPercentage
From PortProject..CovidDeaths
--where location like '%South Africa%'
Where continent is not null
--Group by date
Order by 1,2


-- Total Population that vaccinated

Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations ,
Sum(convert (int,vac.new_vaccinations)) Over (partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated  
From PortProject..CovidVaccinations vac
Join PortProject..CovidDeaths dea
     on  dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3


-- Use CTE

With PopvsVac (Continent , location , date , population ,RollingPeopleVaccinated ,new_vaccinations)
as

(
Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations ,
Sum(Convert (int,vac.new_vaccinations)) Over (partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated  
From PortProject..CovidVaccinations vac
Join PortProject..CovidDeaths dea
     on  dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--Order by 1,2,3
)

Select*, (RollingPeopleVaccinated/ population)* 100
From PopvsVac



--Temp Table

Drop Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated

Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations ,
Sum(Convert (int,vac.new_vaccinations)) Over (partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated  
From PortProject..CovidVaccinations vac
Join PortProject..CovidDeaths dea
     on  dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--Order by 1,2,3


Select*, (RollingPeopleVaccinated/ population)* 100
From #PercentagePopulationVaccinated



-- Creating view for visualizations

Create View PercentagePopulationVaccinated as
Select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations ,
Sum(Convert (int,vac.new_vaccinations)) Over (partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated  
From PortProject..CovidVaccinations vac
Join PortProject..CovidDeaths dea
     on  dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--Order by 1,2,3

Select*
From PercentagePopulationVaccinated


