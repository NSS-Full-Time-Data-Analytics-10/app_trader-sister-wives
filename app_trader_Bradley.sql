SELECT *
FROM app_store_apps;
SELECT *
FROM play_store_apps;

SELECT DISTINCT name, play_store_apps.price AS google_price, app_store_apps.price::money AS apple_price, play_store_apps.rating, app_store_apps.rating, app_store_apps.review_count AS apple_reviews, play_store_apps.review_count AS google_reviews
FROM play_store_apps INNER JOIN app_store_apps USING(name)
WHERE app_store_apps.content_rating = '4%' OR play_store_apps.content_rating = 'Everyone'
		--AND app_store_apps.primary_genre = 'Games' OR play_store_apps.category = 'GAME'
		
SELECT DISTINCT name, app_store_apps.price AS apple_store_price,play_store_apps.price AS google_price,app_store_apps.content_rating AS apple_age_rating,
play_store_apps.content_rating AS google_age_rating, app_store_apps.review_count AS apple_review_count,
play_store_apps.review_count AS google_review_count,
app_store_apps.rating AS apple_store_rating,play_store_apps.rating AS google_rating
FROM app_store_apps INNER JOIN play_store_apps USING (name)
WHERE app_store_apps.review_count::integer > 1000 AND play_store_apps.review_count > 1000
		AND play_store_apps.rating > 4.5 
		AND app_store_apps.rating > 4.5
		AND play_store_apps.category = 'Everyone%'  
		AND app_store_apps.content_rating = '4%'
ORDER BY apple_review_count, google_review_count;

(SELECT DISTINCT name, price, rating, content_rating
FROM app_store_apps
WHERE price < 2.50 
	AND rating >= 5
	AND primary_genre = 'Games'
	AND review_count::numeric > 1100
	AND content_rating = '4+')
UNION
(SELECT DISTINCT name, price::MONEY::NUMERIC, rating, content_rating
FROM play_store_apps
WHERE content_rating = 'Everyone'
	AND rating > 4.75
	AND review_count > 2000
 	AND category = 'GAME'
	AND price::MONEY <= '$2.50')
ORDER BY name

----Hunter's Solution
SELECT *,
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

SELECT *, --------------------------------------------------
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






---------------3C:
SELECT *, --------------------------------------------------
		ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
FROM app_store_apps
WHERE ROUND(((((rating/.25)*6)+12)/12),1) > 5
	AND (CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END) < 50000
	AND content_rating = '4+'
	AND primary_genre = 'Games'
	AND name IN (SELECT name FROM play_store_apps)
ORDER BY lifespan_years DESC, acquire_cost ASC

SELECT name, app_store_apps.rating, play_store_apps.rating
FROM app_store_apps FULL JOIN play_store_apps USING (name)
WHERE (name ILIKE '%America%'
	  OR name ILIKE '%summer%'
	  OR name ILIKE '%USA%')
	  AND (primary_genre = 'Games'
		  OR category = 'GAME')
	 (app_store_apps.rating > 4
	OR play_store_apps.rating > 4)






