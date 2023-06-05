---app store filtered----

(SELECT DISTINCT name,price::MONEY,review_count::INTEGER,rating,content_rating
FROM app_store_apps
WHERE price::MONEY <= '$2.50'
AND rating = 5.0
AND review_count::INTEGER >=2000
AND content_rating = '4+')
ORDER BY NAME ASC

INTERSECT

(SELECT DISTINCT name,price::MONEY,review_count::INTEGER, rating,content_rating
FROM play_store_apps
WHERE rating >=4.75
AND price::MONEY <= '$2.50'
AND review_count >=2000
AND content_rating = 'Everyone'
ORDER BY NAME ASC)

SELECT *
FROM play_store_apps

SELECT *
FROM app_store_apps


---join showing app store and play store---no games filter

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


---INTERSECT AND LEFT JOIN WITH GAMES FILTER

(SELECT DISTINCT name,app_store_apps.price AS app_store_price,play_store_apps.price::MONEY AS play_store_price, 
 app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating,app_store_apps.content_rating AS app_store_content_rating,
 play_store_apps.content_rating AS play_store_content_rating,app_store_apps.review_count::INTEGER AS app_store_review_count,
 play_store_apps.review_count AS play_store_review_count,
 play_store_apps.genres AS play_store_apps_genre,
 app_store_apps.primary_genre AS app_store_genre
FROM app_store_apps
	LEFT JOIN play_store_apps
	USING (name)
WHERE  app_store_apps.price<=2.50
AND play_store_apps.price::MONEY <= '$2.50'
AND app_store_apps.content_rating ='4+'
AND play_store_apps.content_rating='Everyone'
AND app_store_apps.rating >= 4.25
AND play_store_apps.rating >=4.25
AND app_store_apps.primary_genre = 'Games'
AND app_store_apps.review_count::INTEGER >=2000
AND play_store_apps.review_count >=2000)
INTERSECT
(SELECT DISTINCT name,app_store_apps.price AS app_store_price,play_store_apps.price::MONEY AS play_store_price,
 app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating,
 app_store_apps.content_rating AS app_store_content_rating, play_store_apps.content_rating AS play_store_content_rating,
 app_store_apps.review_count::INTEGER AS app_store_review_count,play_store_apps.review_count AS play_store_review_count,
 play_store_apps.genres AS play_store_apps_genre,
 app_store_apps.primary_genre AS app_store_genre
FROM play_store_apps
 	LEFT JOIN app_store_apps
 	USING (name)
WHERE  app_store_apps.price<=2.50
AND play_store_apps.price::MONEY <= '$2.50'
AND app_store_apps.content_rating ='4+'
AND play_store_apps.content_rating='Everyone'
AND app_store_apps.rating >= 4.25
AND play_store_apps.rating >=4.25
AND app_store_apps.primary_genre = 'Games'
AND app_store_apps.review_count::INTEGER >=2000
AND play_store_apps.review_count >=2000)



---3---


SELECT *
FROM app_store_apps
LEFT JOIN play_store_apps
USING (name)
WHERE app_store_apps.name ILIKE '%america%'
OR play_store_apps.name ILIKE '%america%'
OR app_store_apps.name ILIKE '%summer%'
OR play_store_apps.name ILIKE '%summer%'
OR app_store_apps.name ILIKE '%beach%'
OR play_store_apps.name ILIKE '%beach%'



SELECT *
FROM app_store_apps
WHERE name ILIKE '%summer%'

SELECT *
FROM play_store_apps
WHERE name ILIKE '%summer%'



---Question 1 redo---
--Filtered games available on both the app store and the play store.
--Filtered pirce between $0 and $2.50 as the purchase price will be cheapest at $25,000
--Filtered content rating to Everyone and 4+ to have the largest possible consumer base
--Filtered rating to >4.25 to maximize profitability
--Filtered review count to >2000 to exclude outlier reviews that can significantly affect rating

SELECT DISTINCT name,app_store_apps.price AS app_store_price,play_store_apps.price::MONEY AS play_store_price, 
 app_store_apps.rating AS app_store_rating,play_store_apps.rating AS play_store_rating,app_store_apps.content_rating AS app_store_content_rating,
 play_store_apps.content_rating AS play_store_content_rating,app_store_apps.review_count::INTEGER AS app_store_review_count,
 play_store_apps.review_count AS play_store_review_count,
 play_store_apps.genres AS play_store_apps_genre,
 app_store_apps.primary_genre AS app_store_genre
FROM app_store_apps
		LEFT JOIN play_store_apps
	USING (name)
WHERE  app_store_apps.price<=2.50
AND play_store_apps.price::MONEY <= '$2.50'
AND app_store_apps.content_rating ='4+'
AND play_store_apps.content_rating='Everyone'
AND app_store_apps.rating >= 4.25
AND play_store_apps.rating >=4.25
AND app_store_apps.primary_genre = 'Games'
AND app_store_apps.review_count::INTEGER >=2000
AND play_store_apps.review_count >=2000


---Cleaner---

SELECT name,
		ROUND(((((rating/.25)*6)+12)/12),1) as lifespan_years,
		(CASE WHEN price < 2.50 THEN 25000
		 	WHEN price >= 2.50 THEN price * 10000 END)::MONEY AS acquire_cost,
		((ROUND(((((rating/.25)*6)+12)/12),1)) * 12 * 5000)::MONEY AS potential_profit
FROM app_store_apps
	WHERE primary_genre ILIKE 'games'
	AND rating > 4.25
	AND review_count::NUMERIC > 8000
	AND price <=2.50
	AND content_rating = '4+'
	AND name IN
		(SELECT name FROM play_store_apps
		 WHERE category='GAME'
		 AND review_count>8000
		 AND content_rating = 'Everyone'
		 ORDER BY rating DESC)
ORDER BY rating DESC, price
LIMIT 10


---Why did we select games?

SELECT primary_genre, COUNT(*)--------------------------------COUNT BY GENRE
	FROM								(SELECT *, 
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

