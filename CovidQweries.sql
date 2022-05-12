



select *
from [Portfolio Project]..['covid deaths']
order by 3,4

/*select *
from [Portfolio Project]..['covid vaccine ]
order by 3,4*/

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercent
from [Portfolio Project]..['covid deaths']
where location= 'India'
order by 1,2

select location,date,total_cases,total_deaths,(total_cases/population)*100 as InfectedPercent
from [Portfolio Project]..['covid deaths']
where location= 'India'
order by 1,2

select location,max(total_cases) as HighestCount,max((total_cases/population))*100 as percentage
from [Portfolio Project]..['covid deaths']
group by location,population
order by percentage

select continent,location,max(total_deaths) as HighestCountdeaths,max((total_deaths/total_cases))*100 as deathpercent
from [Portfolio Project]..['covid deaths']
group by continent,location
order by continent
desc  

select continent,max(cast(total_deaths as int)) as totalCountdeaths,max((total_deaths)/total_cases)*100 as deathpercent
from [Portfolio Project]..['covid deaths']
where continent is not null
group by continent
order by deathpercent
desc

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(new_vaccinations as bigint)) over  (partition by dea.location Order by dea.location,dea.date) as rollingPeopleVaccinated
from [Portfolio Project]..['covid deaths'] dea
join [Portfolio Project]..['covid vaccine ] vac
           on dea.location=vac.location
		   and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3

Select location, date, population, total_cases, total_deaths
From [Portfolio Project]..['covid deaths']
where continent is not null 
order by 1,2

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccine ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..['covid deaths']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccine ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3