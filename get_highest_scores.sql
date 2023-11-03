WITH calculations_with_max_scores AS (SELECT *,
                                             CASE
                                                 WHEN ratio > token_set_ratio THEN ratio
                                                 ELSE token_set_ratio
                                                 END AS maximum_score
                                      FROM calculations)

SELECT *
FROM calculations_with_max_scores
WHERE maximum_score BETWEEN 75 AND 99
ORDER BY maximum_score DESC