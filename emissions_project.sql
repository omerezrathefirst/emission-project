--Crating a new table from the emission high granularity excel folder
CREATE TABLE emission(
  year INTEGER,
  parent_entity VARCHAR(50),
  parent_type VARCHAR(50),
  reporting_entity VARCHAR(50),
  commodity VARCHAR(50),
  production DECIMAL,
  production_unit VARCHAR(50) NOT NULL,
  product_emissions_MtCO2 VARCHAR(50),
  flaring_emissions_MtCO2 DECIMAL,
  venting_emissions_MtCO2 DECIMAL,
  own_fuel_use_emissions_MtCO2 DECIMAL, 
  fugitive_methane_emissions_MtCO2e DECIMAL,
  fugitive_methane_emissions_MtCH4 DECIMAL,
  total_operational_emissions_MtCO2e DECIMAL, 
  total_emissions_MtCO2e DECIMAL, 
  source VARCHAR(500)
);

  
--Finding which commodity emissions ranks the highest in each year.
SELECT year, commodity, MAX(total_emissions_MtCO2e) AS max_emissions
FROM emission
GROUP BY year, commodity
ORDER BY year, max_emissions DESC;



--Filtring out the top 5 parent entities with the lowest average emissions intensity (emissions per unit of production). 
SELECT parent_entity, MIN(total_emissions_mtco2e) AS min_emissions_per_parent_entity
FROM emission 
GROUP BY parent_entity
HAVING AVG(CASE WHEN production != 0 THEN total_emissions_mtco2e / production ELSE NULL END ) < MIN(total_emissions_mtco2e)
ORDER BY min_emissions_per_parent_entity ASC
LIMIT 5;






--Now i would like to find which parent type is more enviorment pro active
SELECT parent_type,
       AVG(CASE WHEN production <> 0 THEN total_emissions_MtCO2e / production ELSE NULL END) AS avg_emissions_intensity
FROM emission
GROUP BY parent_type
ORDER BY avg_emissions_intensity ASC;



--Calculating the total emissions for each year and find the year with the highest total emissions
SELECT year, SUM(total_emissions_MtCO2e) AS total_emissions
FROM emission
GROUP BY year
ORDER BY total_emissions DESC



--Comparing the total flaring and venting emissions for each year and identify the year with the highest total.
SELECT year, SUM(flaring_emissions_MtCO2) AS total_flaring_emissions, 
              SUM(venting_emissions_MtCO2) AS total_venting_emissions,
              SUM(flaring_emissions_MtCO2 + venting_emissions_MtCO2) AS total_flaring_venting_emissions
FROM emission
GROUP BY year
ORDER BY total_flaring_venting_emissions DESC
;

