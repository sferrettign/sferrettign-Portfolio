/*

--- Viendo la tabla por primera vez, para comenzar con el data cleaning ---
SELECT * 
FROM Netflix
--- revisamos Nulls/Blanks ---
SELECT 
    SUM(CASE WHEN Show_id = '' THEN 1 ELSE 0 END) AS show_id_blanks,
    SUM(CASE WHEN Type = '' THEN 1 ELSE 0 END) AS Type_blanks,
	SUM(CASE WHEN Title = '' THEN 1 ELSE 0 END) AS Title_blanks,
	SUM(CASE WHEN director = '' THEN 1 ELSE 0 END) AS director_blanks,
	SUM(CASE WHEN cast_ = '' THEN 1 ELSE 0 END) AS cast_blanks,
	SUM(CASE WHEN country = '' THEN 1 ELSE 0 END) AS country_blanks,
	SUM(CASE WHEN date_added = '' THEN 1 ELSE 0 END) AS date_added_blanks,
	SUM(CASE WHEN release_year = '' THEN 1 ELSE 0 END) AS release_year_blanks,
	SUM(CASE WHEN rating = '' THEN 1 ELSE 0 END) AS rating_blanks,
	SUM(CASE WHEN duration = '' THEN 1 ELSE 0 END) AS duration_blanks,
	SUM(CASE WHEN listed_in = '' THEN 1 ELSE 0 END) AS listed_in_blanks,
	SUM(CASE WHEN description = '' THEN 1 ELSE 0 END) AS description_blanks
FROM Netflix;

--- Luego de ver la tabla a primera vista nos dimos cuenta de que habia nulls o casillas en blanco, por ende con CASE comenzamos a revisar.
---											Director    Cast	Country    date_added	release_year	Duration
---Lo cual arroja la siguiente informacion:   2634		 825	  831			10			4				3	


--- Curiosidad Propia ---
SELECT Title, Director, Country
FROM Netflix
WHERE Director = 'Quentin Tarantino'

--- Realizando Conteos de Nulls para ver si dropeamos alguna columna, pero luego de analizar nos dimos cuenta que no eran tantos.

SELECT director, country, date_added
FROM netflix
WHERE country = NULL

UPDATE Netflix
SET Director = NULL
WHERE Director = ''

UPDATE Netflix
SET Country = NULL
WHERE Country = ''


UPDATE Netflix
SET Cast_ = NULL
WHERE Cast_ = ''

UPDATE Netflix
SET release_year = NULL
WHERE release_year = ''

UPDATE Netflix
SET Date_added = NULL
WHERE Date_added = ''

UPDATE Netflix
SET Duration = NULL
WHERE Duration = ''

Select Director, Country
FROM Netflix

SELECT Title, Director, Country
FROM Netflix
WHERE Director = 'Quentin Tarantino'


SELECT * 
FROM Netflix


--- Ahora usamos JOIN para popular la columna "Country" 
--- Donde se pide que si dos Show tienen un mismo director, es muy problabe que ambos shows hayan sido hechos en el mismo país.
--- La logica no es completamente acertada ya que Director <> País donde se realizar dicha pelicula, pero podemos tomar "Country" 
--- Como origen de creación de la idea en vez de donde se filmo. 
UPDATE a
SET a.country = b.country
FROM netflix a
JOIN netflix b 
ON a.director = b.director 
AND a.show_id <> b.show_id
WHERE a.country IS NULL;

--- Se confirma que quedo información NULL. Debido a que estos Directores no han realizado otras peliculas,
--- Por ende no se puede inventar información y se dejara la información Null.


SELECT director, country, date_added
FROM netflix
WHERE country IS NULL;

--- Confirmamos que ahora hay 683 Nulls de anteriormente 831. 

SELECT COUNT(CASE WHEN Country IS NULL THEN 1 END) AS NullCountry
FROM Netflix

SELECT *
FROM Netflix


--- Separamos los paises para poder visualizar de mejor manera en el grafico a continuación. ---
SELECT
PARSENAME(REPLACE(Country, ',', '.'), 3) as Country3
, PARSENAME(REPLACE(Country, ',', '.'), 2) as Country2 
, PARSENAME(REPLACE(Country, ',', '.'), 1) as Country1
FROM PortfolioProject.dbo.Netflix

Alter Table Netflix
Add Country1 Nvarchar(255);
Alter Table Netflix
Add Country2 Nvarchar(255);
Alter Table Netflix
Add Country3 Nvarchar(255);
Update Netflix
SET Country1 = PARSENAME(REPLACE(Country, ',', '.'), 1)
Update Netflix
SET Country2 = PARSENAME(REPLACE(Country, ',', '.'), 2)
Update Netflix
SET Country3 = PARSENAME(REPLACE(Country, ',', '.'), 3)


ALTER TABLE Netflix
DROP COLUMN Country

SELECT *
FROM portfolioproject.dbo.Netflix
--- al realizar conteo por país nos dimos cuentas q al separar las ',' 
---quedaron algunos espacios al inicio o despues de los nombres por lo que contaba un mismo país varias veces.
--- Debido a esto aplicamos la siguiente Query.


UPDATE Netflix
SET Country = LTRIM(RTRIM(Country))
WHERE Country IS NOT NULL

Select *
FROM PortfolioProject.dbo.Netflix




Alter Table Netflix
Add Genre1 Nvarchar(255);
Alter Table Netflix
Add Genre2 Nvarchar(255);
Alter Table Netflix
Add Genre3 Nvarchar(255);
Update Netflix
SET Genre1 = PARSENAME(REPLACE(listed_in, ',', '.'), 1)
Update Netflix
SET Genre2 = PARSENAME(REPLACE(listed_in, ',', '.'), 2)
Update Netflix
SET Genre3 = PARSENAME(REPLACE(listed_in, ',', '.'), 3)


UPDATE Netflix
SET Genre1 = LTRIM(RTRIM(Genre1))
WHERE Genre1 IS NOT NULL

UPDATE Netflix
SET Genre2 = LTRIM(RTRIM(Genre2))
WHERE Genre2 IS NOT NULL

UPDATE Netflix
SET Genre3 = LTRIM(RTRIM(Genre3))
WHERE Genre3 IS NOT NULL

SELECT distinct(genre1) as Genre, Count(*) as #
FROM PortfolioProject.dbo.Netflix
Group by Genre1
ORDER by # desc

Select Genre1, Genre2, Genre3
FROM PortfolioProject.dbo.Netflix


SELECT Genre, COUNT(*) AS #
FROM (
    SELECT Genre1 AS genre FROM portfolioproject.dbo.Netflix
    UNION ALL
    SELECT Genre2 FROM portfolioproject.dbo.Netflix
    UNION ALL
    SELECT Genre3 FROM portfolioproject.dbo.Netflix
) AS CombinedGenres
WHERE Genre IS NOT NULL
GROUP BY genre
ORDER BY # DESC

Select * 
FROM PortfolioProject.dbo.Netflix

--- Comenzaremos a crear tablas para subir a tableau y hacer el analisis que buscamos.
--- En este informe veremos: 
		--- 1 Cantidad de estrenos cada año
		--- 2 Tipo de Rating y su proporcion en relacion a la cantidad total: TV-MA/TV-PG/R
		--- 3 Cantidad de Peliculas/Series
		--- 4 Que paises son los mas populares a la hora de crear series y/o peliculas.
		--- 5 Top Directores





--- 1
SELECT Type, Date_added, Director, Country, release_year
FROM portfolioproject.dbo.Netflix
--- 2
Select  Rating, count(*) as Qty,
Cast(Count(*) * 1.0 / (Select Count(*) FROM portfolioproject.dbo.Netflix) as Decimal (5, 3)) as Proportion
FROM portfolioproject.dbo.Netflix
Group by Rating
Order by 2 Desc
--- Sabemos que no es necesario conseguir la "proportion" para Tableau ya que lo hace por si mismo.
--- 3 
Select Distinct(type), count(type) as TypeQty
FROM portfolioproject.dbo.Netflix
Group by Type
Order by 2 Desc
--- 4
Select  Country, Type, count(type) as Qty, 
		SUM(Count(Type)) Over (Partition BY Country) as Total
FROM portfolioproject.dbo.Netflix
Group by  Country, type
ORDER BY Total Desc

SELECT Country, Type, COUNT(Type) as Qty,
    SUM(COUNT(Type)) OVER (PARTITION BY Country) as TotalQty
FROM portfolioproject.dbo.Netflix
GROUP BY Country, Type
ORDER BY Qty DESC;




 
Select *
FROM portfolioproject.dbo.Netflix

 
--- 5
SELECT Distinct(director), Count(Director) as #Movies
FROM portfolioproject.dbo.Netflix
Group by Director
Order By 2 desc

SELECT director, 
       COUNT(CASE WHEN type = 'TV Show' THEN 1 ELSE NULL END) AS tv_show_count,
       COUNT(CASE WHEN type = 'Movie' THEN 1 ELSE NULL END) AS movie_count
FROM portfolioproject.dbo.Netflix
GROUP BY director
Order by Movie_count desc

SELECT Director, Type ,count(director) as #
FROM portfolioproject.dbo.Netflix
Group by Director, Type




SELECT director, type
FROM portfolioproject.dbo.Netflix




SELECT Director
FROM portfolioproject.dbo.Netflix
where director = 'Raúl Campos, Jan Suter'
--- Por lo visto en la data, Raúl Campos y Jan Suter siempre trabajan juntos.
SELECT *
FROM portfolioproject.dbo.Netflix



