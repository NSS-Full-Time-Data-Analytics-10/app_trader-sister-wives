SELECT * FROM app_store_apps
WHERE name = 'Candy Crush Saga';
SELECT * FROM play_store_apps
WHERE name = 'Candy Crush Saga';

---1. high rating, free is best, casual game genre







SELECT name, app_store_apps.rating, play_store_apps.rating FROM app_store_apps
INNER JOIN play_store_apps
	USING(name);
	
SELECT primary_genre AS app_store_genre, --------------------------------Avg Rating by genre
		COUNT(primary_genre) AS app_store_genre_count,
		genres AS play_store_genre, 
		COUNT(genres) AS play_store_genre_count, 
		ROUND(AVG(app_store_apps.rating),2) AS app_store_rating, 
		ROUND(AVG(play_store_apps.rating),2) AS play_store_rating
	FROM app_store_apps
INNER JOIN play_store_apps
	USING(name)	
GROUP BY app_store_genre, play_store_genre
ORDER BY app_store_genre, play_store_genre;


SELECT primary_genre AS app_store_genre, --------------------------------Avg Rating ranked for app store
		COUNT(primary_genre) AS app_store_genre_count,
		ROUND(AVG(app_store_apps.rating),2) AS app_store_rating,
		genres AS play_store_genre, 
		COUNT(genres) AS play_store_genre_count,  
		ROUND(AVG(play_store_apps.rating),2) AS play_store_rating
	FROM app_store_apps
INNER JOIN play_store_apps
	USING(name)	
GROUP BY app_store_genre, play_store_genre
	HAVING COUNT(primary_genre) > 5
		AND COUNT(genres) > 5
ORDER BY app_store_rating DESC;


SELECT primary_genre AS app_store_genre, --------------------------------Avg Rating ranked for play store
		COUNT(primary_genre) AS app_store_genre_count,
		ROUND(AVG(app_store_apps.rating),2) AS app_store_rating,
		genres AS play_store_genre, 
		COUNT(genres) AS play_store_genre_count,  
		ROUND(AVG(play_store_apps.rating),2) AS play_store_rating
	FROM app_store_apps
INNER JOIN play_store_apps
	USING(name)	
GROUP BY app_store_genre, play_store_genre
	HAVING COUNT(primary_genre) > 5
		AND COUNT(genres) > 5
ORDER BY play_store_rating DESC;


-----------------ONLY FREE APPS in app store by genre
SELECT primary_genre, COUNT(primary_genre), ROUND(AVG(rating),2) FROM app_store_apps
WHERE price = 0.00
GROUP BY primary_genre
ORDER BY round DESC;


-----------------ONLY FREE APPS in play store by genre
SELECT genres, COUNT(genres), ROUND(AVG(rating),2) FROM play_store_apps
--WHERE price::MONEY = $0.00
GROUP BY genres
ORDER BY round DESC;

---------------- union with apps in both stores
(SELECT name FROM app_store_apps)
INTERSECT
(SELECT name FROM play_store_apps);

---------------- 
SELECT * FROM app_store_apps
INNER JOIN play_store_apps
	USING(name)
ORDER BY name;

-----------------JARED CODE
SELECT DISTINCT TRIM(name), app_store_apps.price::MONEY AS app_store_price,
play_store_apps.price::MONEY AS play_store_price,
app_store_apps.content_rating AS app_store_age_rating,
play_store_apps.content_rating AS play_store_age_rating, 
app_store_apps.review_count AS app_store_review_count,
play_store_apps.review_count AS play_store_review_count,
app_store_apps.rating AS app_store_rating,
play_store_apps.rating AS play_store_rating
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE  app_store_apps.price::MONEY = '$0.00'
AND play_store_apps.price::MONEY = '$0.00'
AND app_store_apps.content_rating ='4+'
AND play_store_apps.content_rating='Everyone'
AND app_store_apps.rating >= 4.5
AND play_store_apps.rating >=4.5
AND name IN ((SELECT name FROM app_store_apps)
INTERSECT
(SELECT name FROM play_store_apps));

--------app store W/ FILTERS

SELECT * FROM app_store_apps
WHERE rating = 5.0
	AND price BETWEEN 0.00 AND 2.50
	AND review_count::NUMERIC > 2000
	AND content_rating = '4+'
ORDER BY rating DESC;

--------play store W/ FILTERS

SELECT * FROM play_store_apps
WHERE rating = (SELECT MAX(rating) FROM play_store_apps)
	AND price::MONEY <= '$2.50'
	AND review_count > 2000
	AND content_rating = 'Everyone'
ORDER BY rating DESC;

----------App store apps with lifespan and cost to acquire 
SELECT *, 
		ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
FROM app_store_apps
WHERE ROUND(((((rating/.25)*6)+12)/12),1) > 10
	AND (CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) < 35000
	AND content_rating = '4+'
ORDER BY lifespan_years DESC, acquire_cost ASC;





SELECT primary_genre, COUNT(*)--------------------------------COUNT BY GENRE
	FROM								(SELECT *, 
										ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
										(CASE WHEN price < 2.50 THEN 25000
											WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
								FROM app_store_apps
								WHERE ROUND(((((rating/.25)*6)+12)/12),1) >= 10
									AND (CASE WHEN price < 2.50 THEN 25000
											WHEN price >= 2.50 THEN price * 10000 END) < 25001
									AND content_rating = '4+'
								ORDER BY lifespan_years DESC, acquire_cost ASC) AS desired_apps
GROUP BY primary_genre
ORDER BY count DESC;


SELECT *, -------------------------------------------------- TOP 10 GAMES WITH ABOVE FILTERS (SIMPLE)
		ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
FROM app_store_apps
WHERE ROUND(((((rating/.25)*6)+12)/12),1) > 9
	AND (CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) < 50000
	AND content_rating = '4+'
	AND primary_genre = 'Games'
	AND name IN (SELECT name FROM play_store_apps)
ORDER BY lifespan_years DESC, acquire_cost ASC
LIMIT 10;


SELECT name FROM play_store_apps----------------------------------CURRENT TOP 10 (COMPLICATED)
WHERE name IN (SELECT name FROM (SELECT *,
		ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
FROM app_store_apps
WHERE ROUND(((((rating/.25)*6)+12)/12),1) > 9
	AND (CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) < 25001
	AND content_rating = '4+'
	AND primary_genre = 'Games'
ORDER BY lifespan_years DESC, acquire_cost ASC) AS apps)
LIMIT 10;


SELECT * FROM app_store_apps
FULL JOIN play_store_apps
	USING(name)
WHERE (name ILIKE '%America%'
	OR name ILIKE '%summer%'
	OR name LIKE '%USA%')
	AND (primary_genre = 'Games'
	OR category = 'GAME');

SELECT * FROM app_store_apps
FULL JOIN play_store_apps
	USING(name)
WHERE (name ILIKE '%America%'
	OR name ILIKE '%summer%'
	OR name LIKE '%USA%')
	AND (primary_genre = 'Games'
		OR category = 'GAME')
	AND (app_store_apps.rating > 4.0
		 OR play_store_apps.rating > 4.0)
ORDER BY app_store_apps.price;



--------------3C-top 10 list---------------------FINAL
SELECT name,  
		ROUND(((((rating/.25)*6)+12)/12),1) as lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END)::MONEY AS acquire_cost,
		((ROUND(((((rating/.25)*6)+12)/12),1)) * 12 * 5000)::MONEY AS potential_profit
	FROM app_store_apps
		WHERE primary_genre ILIKE 'games'
		AND rating > 4.25
		AND review_count::NUMERIC > 8000
		AND content_rating = '4+'
		AND price < 2.51
		AND name IN 
			(SELECT name FROM play_store_apps
				WHERE category = 'GAME'
				AND rating > 4.25
				AND review_count > 8000
				AND content_rating = 'Everyone'
				ORDER BY rating DESC)
ORDER BY rating DESC
LIMIT 10;






































