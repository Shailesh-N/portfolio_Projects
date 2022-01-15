select *
from [portfolio project].dbo.coviddeaths$
where continent is not null
order by 3,4

--select *
--from [portfolio project].dbo.covidvaccination$
--order by 3,4

select Location,date,total_cases,new_cases,total_deaths,population
from [portfolio project].dbo.coviddeaths$
order by 1,2

--Looking at Total cases Vs Total Deaths
-- likelihood of dying of covid for each country 
select Location,date,total_cases,total_deaths,(Total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project].dbo.coviddeaths$
--where location like '%india%' 
order by 1,2


--Looking at the total cases Vs Population
-- percentage of population that got covid
select Location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage
from [portfolio project].dbo.coviddeaths$
--where location like '%india%'
order by 1,2


--looking at countries with highest infection rates compared to total population
select Location,population,max(total_cases) as highest_infection_count,max((total_cases/population))*100 as Percentageofpopaffected
from [portfolio project].dbo.coviddeaths$
--where location like '%india%'
group by Location,population
order by Percentageofpopaffected desc

--BREAKING THINGS BY CONTINENT

--countries with highest death count per population
select continent,MAX(CAST(Total_deaths as bigint)) as TotalDeathcount
from [portfolio project].dbo.coviddeaths$
where continent is not null
group by continent
order by TotalDeathcount desc



-- showing the continents with highest death counts
select continent,MAX(CAST(Total_deaths as bigint)) as TotalDeathcount
from [portfolio project].dbo.coviddeaths$
where continent is not null
group by continent
order by TotalDeathcount desc


--Golabal numbers

select sum(new_cases)as total_cases,sum(cast(new_deaths as bigint)) as Total_deaths, sum(cast(New_deaths as bigint))/sum(New_cases)*100 as DeathPercentage
from [portfolio project].dbo.coviddeaths$
--where location like '%india%' 
where continent is not null
--group by date
order by 1,2

-- looking at total population Vs vaccinated population
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--using a CTE
with pop_vs_vac (continent,location,date, population,New_vaccinations,rolling_people_vaccinated)
as 
(
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
)
select *, (rolling_people_vaccinated / population)*100
from pop_vs_vac




--Temp Table
drop table if exists #percentage_population_vaccinated
create table #percentage_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)




insert into #percentage_population_vaccinated
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date

--order by 2,3

select *, (rolling_people_vaccinated / population)*100 as percentage_vaccinated
from #percentage_population_vaccinated


--creating view

create view percentage_population_vaccinated as 
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as rolling_people_vaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentage_population_vaccinated