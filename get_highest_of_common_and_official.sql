-- Since official and common are part of the same table, only retrieves the higher of the two and ignores the other.
CREATE OR REPLACE VIEW rest_countries_calculations_aggregated AS
WITH base AS (SELECT * FROM calculations_with_max_scores WHERE left_country_table = 'rest_countries_api_data_names'),
     create_entity_relation_key AS (SELECT *,
                                           (SELECT ARRAY
                                                       [left_country_id::TEXT,
                                                       left_country_table,
                                                       right_country_id::TEXT,
                                                       right_country_id::TEXT,
                                                       right_country_table,
                                                       right_country_table_field_name,
                                                       right_country_name]) AS unique_entity_to_entity_relation_key -- this is the combination of fields that form the primary key to describe the relation being formed. the comparisons were originally made between an entity from rest countries, on two different possible string representations of it 'official' and 'common', on one possible string representation of an "other" entity from any other table.
                                    FROM base),
     with_rank AS (SELECT *,
                          ROW_NUMBER() OVER (
                              PARTITION BY unique_entity_to_entity_relation_key
                              ORDER BY
                                  maximum_score DESC,
                                  (left_country_table_field_name = 'official') DESC
                              ) AS row_number
                   FROM create_entity_relation_key)
SELECT id,
       left_country_table,
       left_country_table_field_name,
       left_country_id,
       left_country_name,
       right_country_table,
       right_country_table_field_name,
       right_country_id,
       right_country_name,
       ratio,
       token_set_ratio,
       maximum_score


FROM with_rank
WHERE row_number = 1