--SELECT *
--FROM PortfolioProject..COVIDDEATHS


--SELECT *
--FROM PortfolioProject..COVIDVACCINATIONS


--SELECT COUNTRY, DATE, TOTAL_CASES, TOTAL_DEATHS, (Total_Deaths/TOTAL_CASES)*100 AS DEATHPERCENTAGE
--FROM PORTFOLIOPROjECT..COVIDDEATHS
--WHERE COUNTRY = 'usa'

--SELECT COUNTRY, POPULATION, MAX(TOTAL_CASES) AS HIGHESTINFECTIONCOUNT,  MAX((Total_CASES/POPULATION))*100 AS INFECTEDPERCENTAGE
--FROM PORTFOLIOPROjECT.DBO.COVIDDEATHS
--GROUP BY COUNTRY,POPULATION
--ORDER BY INFECTEDPERCENTAGE DESC


--SELECT COUNTRY, MAX(TOTAL_DEATHS) AS TOTALDEATHCOUNT
--FROM PORTFOLIOPROjECT.DBO.COVIDDEATHS
--WHERE total_deaths IS NOT NULL
--GROUP BY COUNTRY
--ORDER BY TOTALDEATHCOUNT DESC

--SELECT
--  DATE,
--  SUM(NEW_CASES) AS TOTALCASES,
--  SUM(new_deaths_per_million) AS TOTALDEATHS,
--  CASE
--    WHEN SUM(NEW_CASES) = 0 THEN NULL
--    ELSE SUM(new_deaths_per_million) / SUM(NEW_CASES)*100
--  END AS DEATHS_PER_CASES
--FROM PORTFOLIOPROJECT.dbo.CovidDeaths
--GROUP BY DATE
--ORDER BY DATE;









--LOOKING AT TOTAL POPULATION VS TOTAL VACCINATIONS

--SELECT deaths.country, deaths.date, deaths.population, vaccinations.new_vaccinations
--, SUM(CAST (VACCINATIONS.NEW_VACCINATIONS AS INT)) OVER (PARTITION BY DEATHS.COUNTRY ORDER BY DEATHS.COUNTRY,
--DEATHS.DATE) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths DEATHS
--JOIN PORTFOLIOPROJECT..COVIDVACCINATIONS VACCINATIONS
--ON DEATHS.COUNTRY = VACCINATIONS.COUNTRY
--AND DEATHS.DATE = VACCINATIONS.date
--WHERE DEATHS.COUNTRY IS NOT NULL
--order by 2,3  


--CTE TABLE BELOW

--WITH POPvsVAC (COUNTRY, DATE , POPULATION, NEW_VACCINATIONS, ROLLINGPEOPLEVACCINATED)
--AS 
--(
--SELECT deaths.country, deaths.date, deaths.population, vaccinations.new_vaccinations
--, SUM(CAST (VACCINATIONS.NEW_VACCINATIONS AS INT)) OVER (PARTITION BY DEATHS.COUNTRY ORDER BY DEATHS.COUNTRY,
--DEATHS.DATE) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths DEATHS
--JOIN PORTFOLIOPROJECT..COVIDVACCINATIONS VACCINATIONS
--ON DEATHS.COUNTRY = VACCINATIONS.COUNTRY
--AND DEATHS.DATE = VACCINATIONS.date
--WHERE DEATHS.COUNTRY IS NOT NULL
--)
--SELECT *, (ROLLINGPEOPLEVACCINAted/population)*100
--FROM POPVSVAC


--TEMPTABLE BELOW
-- DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED
--  CREATE TABLE #PERCENTPOPULATIONVACCINATED
--  (
--  COUNTRY NVARCHAR (255),
--  DATE DATETIME,
--  POPULATION NUMERIC,
--  NEW_VACCINATIONS NUMERIC,
--  ROLLINGPEOPLEVACCINATED NUMERIC
--  )
--  INSERT INTO #PERCENTPOPULATIONVACCINATED
--  SELECT deaths.country, deaths.date, deaths.population, vaccinations.new_vaccinations
--, SUM(CAST (VACCINATIONS.NEW_VACCINATIONS AS INT)) OVER (PARTITION BY DEATHS.COUNTRY ORDER BY DEATHS.COUNTRY,
--DEATHS.DATE) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths DEATHS
--JOIN PORTFOLIOPROJECT..COVIDVACCINATIONS VACCINATIONS
--ON DEATHS.COUNTRY = VACCINATIONS.COUNTRY
--AND DEATHS.DATE = VACCINATIONS.date
--WHERE DEATHS.COUNTRY IS NOT NULL
 
-- SELECT *, (ROLLINGPEOPLEVACCINAted/population)*100
--FROM #PERCENTPOPULATIONVACCINATED

  
  --CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PERCENTPOPULATIONVACCINATED AS
SELECT deaths.country, deaths.date, deaths.population, vaccinations.new_vaccinations,
  SUM(CAST(VACCINATIONS.NEW_VACCINATIONS AS INT)) OVER (PARTITION BY DEATHS.COUNTRY ORDER BY DEATHS.COUNTRY, DEATHS.DATE) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths deaths
JOIN PortfolioProject..CovidVaccinations vaccinations
  ON deaths.country = vaccinations.country
  AND deaths.date = vaccinations.date
WHERE deaths.country IS NOT NULL;
-- ORDER BY 2, 3


