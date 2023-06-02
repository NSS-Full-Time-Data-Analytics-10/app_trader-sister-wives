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
FULL JOIN play_store_apps
USING (name)
WHERE app_store_apps.name ILIKE '%summer%'
AND play_store_apps.name ILIKE '%summer%'
OR app_store_apps.name ILIKE '%USA%'
OR play_store_apps.name ILIKE '%USA'
OR app_store_apps.name ILIKE '%america%'
OR play_store_apps.name ILIKE '%america%'




SELECT *
FROM app_store_apps
WHERE name ILIKE '%summer%'

SELECT *
FROM play_store_apps
WHERE name ILIKE '%summer%'






