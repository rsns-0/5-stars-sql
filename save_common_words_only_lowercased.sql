WITH cte AS (SELECT DISTINCT calculations.left_country_name AS names
             FROM calculations
             LIMIT 5000),
     word_cte AS (SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(LOWER(names), '\s+')) AS word
                  FROM cte),
     word_frequency AS (SELECT word, COUNT(*) AS frequency
                        FROM word_cte
                        GROUP BY word
                        ORDER BY frequency DESC
                        LIMIT 5000)
INSERT
INTO unstructured_storage (name, json)
SELECT 'uncleaned_word_frequency',
       (SELECT JSONB_AGG(JSONB_BUILD_OBJECT('word', word, 'frequency', frequency))
        FROM word_frequency)