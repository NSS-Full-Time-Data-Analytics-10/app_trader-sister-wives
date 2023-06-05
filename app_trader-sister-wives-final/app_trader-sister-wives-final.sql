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




-----Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

SELECT name,  
	ROUND(((((rating/.25)*6)+12)/12),1) as lifespan_years,
	(CASE WHEN price < 2.50 THEN 25000
	WHEN price >= 2.50 THEN price * 10000 END)::MONEY AS acquire_cost,
	((ROUND(((((rating/.25)*6)+12)/12),1)) * 12 * 5000)::MONEY AS 	
	potential_profit
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


-----Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming Fourth of July themed campaign.

---TOP 3

SELECT * FROM app_store_apps
FULL JOIN play_store_apps
	USING(name)
WHERE (name ILIKE '%America%'
	OR name ILIKE '%summer%'
	OR name LIKE '%USA%'
	OR name ILIKE '%beach%')
	AND (primary_genre = 'Games'
		OR category = 'GAME')
	AND (app_store_apps.rating > 4.0
		 OR play_store_apps.rating > 4.0)
ORDER BY app_store_apps.price;

	
----Our 4th we chose based on wanting to include an app that would cater to people's desire to travel during the Fourth of July holiday. 

SELECT *
FROM app_store_apps
FULL JOIN play_store_apps
USING (name)
WHERE app_store_apps.name ILIKE '%america%'
	OR play_store_apps.name ILIKE '%america%'
	AND primary_genre = 'Travel'
ORDER BY primary_genre
	
	
