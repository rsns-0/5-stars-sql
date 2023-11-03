CREATE OR REPLACE VIEW calculations_with_max_scores_v2 AS
WITH no_rest_countries AS (SELECT *
                           FROM calculations_with_max_scores cwms
                           WHERE left_country_table != 'rest_countries_api_data_names'),

     with_new_data AS (SELECT *
                       FROM no_rest_countries
                       UNION ALL
                       SELECT *
                       FROM rest_countries_calculations_aggregated)
SELECT *
FROM with_new_data