SELECT *
FROM app_store_apps


SELECT *
FROM play_store_apps

SELECT DISTINCT(name)
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)


WITH avg_rating AS (SELECT AVG(play_store_apps.rating) AS avg_rating
					FROM play_store_apps
					INNER JOIN app_store_apps
					USING (name))
SELECT *
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
INNER JOIN avg_rating
USING (rating)
WHERE play_store_appls.rating > avg_rating

SELECT *
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE play_store_apps.rating >
	(SELECT AVG(play_store_apps.rating) AS avg_rating_play
	FROM play_store_apps
	INNER JOIN app_store_apps
	USING (name))
	AND play_store_apps.price = '0'
	AND play_store_apps.content_rating = 'Everyone'
	OR app_store_apps.rating >
	(SELECT AVG(app_store_apps.rating) AS avg_rating_app
	FROM play_store_apps
	INNER JOIN app_store_apps
	USING (name))
	AND app_store_apps.price = '0'
	AND app_store_apps.content_rating = 'Everyone'
ORDER BY play_store_apps.review_count DESC
	
	
SELECT *
FROM play_store_apps
INNER JOIN app_store_apps
USING (name)
WHERE play_store_apps.rating = 4.7
	AND play_store_apps.price = '0'
	AND play_store_apps.content_rating = 'Everyone'
	OR app_store_apps.rating = 4.7
	AND app_store_apps.price = '0'
	AND app_store_apps.content_rating = 'Everyone'
ORDER BY play_store_apps.review_count DESC
		
		
(SELECT DISTINCT(name), review_count, rating, price::money, content_rating
FROM play_store_apps
WHERE rating >= 4.7
	AND price = '0'
	AND content_rating = 'Everyone'
 	AND category = 'GAME'
ORDER BY review_count DESC)
UNION
(SELECT DISTINCT(name), review_count::integer, rating, price::money, content_rating
FROM app_store_apps
WHERE rating >= 4
	AND price = 0.00
	AND content_rating = '4+'
 	AND primary_genre = 'Games'
ORDER BY review_count DESC)
ORDER BY review_count DESC

SELECT DISTINCT name, app_store_apps.price AS app_store_price,play_store_apps.price AS play_store_price,app_store_apps.content_rating AS app_store_age_rating,
play_store_apps.content_rating AS play_store_age_rating, app_store_apps.review_count AS app_store_review_count,play_store_apps.review_count AS play_store_review_count,
app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)

(SELECT name FROM app_store_apps)
INTERSECT
(SELECT name FROM play_store_apps)

SELECT DISTINCT name, app_store_apps.price AS app_store_price,play_store_apps.price::numeric AS play_store_price,app_store_apps.content_rating AS app_store_age_rating,
play_store_apps.content_rating AS play_store_age_rating, app_store_apps.review_count::integer AS app_store_review_count,play_store_apps.review_count AS play_store_review_count,
app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating, app_store_apps.primary_genre AS app_genre, play_store_apps.category AS play_genre,
			(CASE WHEN app_store_apps.price < 2.50 THEN 25000
		 	WHEN app_store_apps.price >= 2.50 THEN app_store_apps.price * 10000 END) AS 	
				acquire_cost_app, 
			(CASE WHEN play_store_apps.price::numeric < 2.50 THEN 25000
		 	WHEN play_store_apps.price::numeric >= 2.50 THEN play_store_apps.price::numeric * 10000 END) AS 
				acquire_cost_play
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE app_store_apps.price = 0.00
	AND play_store_apps.price::numeric = 0
	AND app_store_apps.content_rating = '4+'
	AND play_store_apps.content_rating = 'Everyone'
	AND app_store_apps.rating > 4.25
	AND play_store_apps.rating > 4.25
	AND app_store_apps.primary_genre = 'Games'
	AND play_store_apps.category = 'GAME'
ORDER BY play_store_apps.review_count DESC



SELECT DISTINCT name, app_store_apps.price AS app_store_price,play_store_apps.price AS play_store_price,app_store_apps.content_rating AS app_store_age_rating,
play_store_apps.content_rating AS play_store_age_rating, app_store_apps.review_count::integer AS app_store_review_count,play_store_apps.review_count AS play_store_review_count,
app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating, app_store_apps.primary_genre AS app_genre, play_store_apps.category AS play_genre
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE app_store_apps.price = 0.00
	AND play_store_apps.price = '0'
	AND app_store_apps.content_rating = '4+'
	AND play_store_apps.content_rating = 'Everyone'
	AND app_store_apps.rating > 4.25
	AND play_store_apps.rating > 4.25
	AND app_store_apps.primary_genre = 'Games'
	AND play_store_apps.category = 'GAME'
ORDER BY play_store_apps.review_count DESC


SELECT * FROM play_store_apps
			WHERE category = 'GAME'
		 	And rating > 4.25
			AND review_count > 2000
			AND content_rating = 'Everyone'
			ORDER BY rating DESC, price


SELECT * FROM app_store_apps
	WHERE primary_genre ILIKE 'games'
	AND rating > 4.25
	AND review_count::NUMERIC > 20000
	AND content_rating = '4+'
	AND price < 2.51
	AND name IN 
		(SELECT name FROM play_store_apps
			WHERE category = 'GAME'
		 	And rating > 4.25
			AND review_count > 20000
			AND content_rating = 'Everyone'
			ORDER BY rating DESC)
ORDER BY rating DESC


-------------------


SELECT *
FROM app_store_apps
WHERE name ILIKE '%usa%'

SELECT *
FROM play_store_apps
WHERE name ILIKE '%usa%'


SELECT DISTINCT name, app_store_apps.price AS app_store_price,play_store_apps.price AS play_store_price,app_store_apps.content_rating AS app_store_age_rating,
play_store_apps.content_rating AS play_store_age_rating, app_store_apps.review_count::integer AS app_store_review_count,play_store_apps.review_count AS play_store_review_count,
app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating, app_store_apps.primary_genre AS app_genre, play_store_apps.category AS play_genre
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE name ILIKE '%USA%'

SELECT *
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE name ILIKE '%USA%'
	OR name ILIKE '%america%'
	OR name ILIKE '%summer%'
	OR name ILIKE '%beach%'
	OR name ILIKE '%firework%'
	
	
-------COUNT BY GENRE
SELECT primary_genre, COUNT(*)
	FROM								
	(SELECT *, 
	ROUND(((((rating/.25)*6)+12)/12),1) AS lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		WHEN price >= 2.50 THEN price * 10000 END) AS acquire_cost
		FROM app_store_apps
		WHERE ROUND(((((rating/.25)*6)+12)/12),1) > 10
		AND (CASE WHEN price < 2.50 THEN 25000
		WHEN price >= 2.50 THEN price * 10000 END) < 35000
		AND content_rating = '4+'
		ORDER BY lifespan_years DESC, acquire_cost ASC) AS desired_apps
GROUP BY primary_genre
ORDER BY count DESC;