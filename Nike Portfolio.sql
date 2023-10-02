/*
-- Checking Data --
SELECT *
FROM Niketable

SELECT DISTINCT(Product_type)
FROM Niketable
--- ---

SELECT Nike_Inc_Brands, Product_Type
FROM Niketable
WHERE Nike_Inc_Brands = 'Converse'
	AND Product_Type = 'Footwear' 

	--- Checking how many factories per brand and its production --- 
SELECT Nike_Inc_Brands, Product_Type, Count(Nike_Inc_Brands) as TotalProductType
FROM Niketable
WHERE Nike_Inc_Brands = 'Converse'
GROUP BY Nike_Inc_Brands, Product_Type

SELECT Nike_Inc_Brands, Product_Type, Count(Nike_Inc_Brands) as TotalProductType
FROM Niketable
WHERE Nike_Inc_Brands = 'Nike'
GROUP BY Nike_Inc_Brands, Product_Type


	   

	----- Factory Quantity per Brand, Production per Product Type and its Proportion ------
WITH NikeBrandsProduction AS (
SELECT Nike_Inc_Brands, Product_Type, Count(Nike_Inc_Brands) as TotalProductType,
  	SUM(Count(Nike_inc_Brands)) OVER (Partition BY Nike_Inc_Brands) as TotalFactoriesxBrand
FROM Niketable
WHERE Nike_Inc_Brands IN ('Converse', 'Nike')
GROUP BY Nike_Inc_Brands, Product_Type
  )
  SELECT *, CAST(TotalProductType as int) * 1.0 / TotalFactoriesxBrand as Proportion
  FROM NikeBrandsProduction
-----------------------------------------------------------------------------


---- Analysis of Factories by Countries ---- 

SELECT Country_Region,Product_Type,  Count(*) as FactoryPerCountry,
count(*) *1.0/ (Select count(*) 
				From Niketable	
				Where Country_Region = T.Country_Region) as Proportion
FROM Niketable T
GROUP by Product_type, Country_Region
Order by Country_Region

------ Total Factories per Country and its Proportion of Product Type--------- 
SELECT Country_Region,Product_Type, Count(*) as FactoryPerApparel,
    (Select Count(*) From Niketable Where Country_Region = T.Country_Region) as TotalFactories,
	  Count(*) * 1.0 / (Select Count(*) From Niketable Where Country_Region = T.Country_Region) as Proportion
FROM Niketable T
GROUP BY Product_type, Country_Region
ORDER BY Country_Region


--------  # Factory Type Per Country and its distribution

Select Country_region, Factory_type, Count(*) as Total,
COUNT(*) * 1.0 / (Select Count(*) FROM NikeTable Where Country_region = T.Country_region) as Proportion
FROM Niketable T
GROUP by Factory_type, Country_Region
Order by Country_Region 



------- Top Ten Countries by Amount of Factories and Factory Type ---------
WITH Totals AS (
    SELECT Factory_type, Country_region, Count(*) as Total_Factories,
           COUNT(*) * 1.0 / (Select Count(*) FROM NikeTable Where Country_region = T.Country_region) as Proportion
    FROM Niketable T
    GROUP by Factory_type, Country_Region
)
SELECT TOP 10 *
FROM Totals
ORDER BY Total_Factories DESC

------------ Amount of Factories per Country, divided by Factory Type and its Proportion of Factory Type.

With CountryFactoryCounts AS ( 
SELECT Country_Region, Count(*) AS Total_Factories
From Niketable
GROUP BY Country_Region
)
SELECT Factory_type, a.Country_Region, Count(*) as TypeFactoryQty, b.Total_factories, Count(*) * 1.0 /b.Total_Factories AS Proportion
FROM Niketable a
JOIN CountryFactoryCounts b ON A.Country_region = b.Country_Region
GROUP BY Factory_type, a.Country_region, b.Total_Factories
ORDER BY Total_factories Desc
---- We can see that in Asia is where the most quantity of Factories are by far.



-------   Amount of Factories by Continents, its Factory Type ---------
Select Region, Factory_type, Count(*) as Total_Factories,
		Count(*) * 1.0 / (Select Count(*) FROM NikeTable Where Region = b.Region) as Proportion
		FROM Niketable B
		Group by Factory_Type, Region
		Order by Total_Factories desc
		---Order by Total_factories


--- We can see that North Asia is the one with the most Factories producing Components,
--- also has the most balanced ratio between factory types, probably being the most important axis in production.

