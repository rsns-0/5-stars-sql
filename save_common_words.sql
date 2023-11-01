WITH word_cte AS (SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(LOWER(original_value), '\s+')) AS word
                  FROM country_names_cleaned),
     word_frequency AS (SELECT word, COUNT(*) AS frequency
                        FROM word_cte
                        WHERE word <> '' -- Exclude empty strings
                        GROUP BY word
                        ORDER BY frequency DESC
                        LIMIT 500),
     updated AS (
         UPDATE unstructured_storage
             SET json = (SELECT JSONB_AGG(JSONB_BUILD_OBJECT('word', word, 'frequency', frequency))
                         FROM word_frequency)
             WHERE name = 'unsaved_word_frequency'
             RETURNING *)
INSERT
INTO unstructured_storage (name, json)
SELECT 'uncleaned_word_frequency',
       (SELECT JSONB_AGG(JSONB_BUILD_OBJECT('word', word, 'frequency', frequency))
        FROM word_frequency)
WHERE NOT EXISTS (SELECT 1 FROM updated);

