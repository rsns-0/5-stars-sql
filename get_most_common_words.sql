WITH word_cte AS (SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(LOWER(original_value), '\s+')) AS word
                  FROM country_names_cleaned)
SELECT word, COUNT(*) AS frequency
FROM word_cte
WHERE word <> ''
GROUP BY word
ORDER BY frequency DESC
LIMIT 500