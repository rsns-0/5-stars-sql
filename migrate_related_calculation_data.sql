WITH rest_to_cia AS (SELECT id,
                            left_country_table             AS self_country_table,
                            left_country_table_field_name  AS self_country_table_field_name,
                            left_country_id                AS self_country_id,
                            left_country_name              AS self_country_name,
                            right_country_table            AS other_country_table,
                            right_country_table_field_name AS other_country_table_field_name,
                            right_country_id               AS other_country_id,
                            right_country_name             AS other_country_name,
                            ratio,
                            token_set_ratio,
                            maximum_score
                     FROM calculations_with_max_scores_v2
                     WHERE left_country_table = 'rest_countries_api_data_names'
                       AND right_country_table = 'newCiaLanguageData'),
     rest_to_wiki AS (SELECT id,
                             left_country_table             AS self_country_table,
                             left_country_table_field_name  AS self_country_table_field_name,
                             left_country_id                AS self_country_id,
                             left_country_name              AS self_country_name,
                             right_country_table            AS other_country_table,
                             right_country_table_field_name AS other_country_table_field_name,
                             right_country_id               AS other_country_id,
                             right_country_name             AS other_country_name,
                             ratio,
                             token_set_ratio,
                             maximum_score
                      FROM calculations_with_max_scores_v2
                      WHERE left_country_table = 'rest_countries_api_data_names'
                        AND right_country_table = 'wikiData'),


     cia_to_wiki AS (SELECT id,
                            left_country_table             AS self_country_table,
                            left_country_table_field_name  AS self_country_table_field_name,
                            left_country_id                AS self_country_id,
                            left_country_name              AS self_country_name,
                            right_country_table            AS other_country_table,
                            right_country_table_field_name AS other_country_table_field_name,
                            right_country_id               AS other_country_id,
                            right_country_name             AS other_country_name,
                            ratio,
                            token_set_ratio,
                            maximum_score
                     FROM calculations_with_max_scores_v2
                     WHERE left_country_table = 'newCiaLanguageData'
                       AND right_country_table = 'wikiData')

INSERT
INTO related_calculation_data(id,
                              self_country_table,
                              self_country_table_field_name,
                              self_country_id,
                              self_country_name,
                              other_country_table,
                              other_country_table_field_name,
                              other_country_id,
                              other_country_name,
                              ratio,
                              token_set_ratio,
                              maximum_score)

SELECT id,
       self_country_table,
       self_country_table_field_name,
       self_country_id,
       self_country_name,
       other_country_table,
       other_country_table_field_name,
       other_country_id,
       other_country_name,
       ratio,
       token_set_ratio,
       maximum_score
FROM (SELECT id,
             self_country_table,
             self_country_table_field_name,
             self_country_id,
             self_country_name,
             other_country_table,
             other_country_table_field_name,
             other_country_id,
             other_country_name,
             ratio,
             token_set_ratio,
             maximum_score
      FROM rest_to_cia

      UNION ALL
      -- to have the the operation 100% fail or pass

      SELECT id,
             self_country_table,
             self_country_table_field_name,
             self_country_id,
             self_country_name,
             other_country_table,
             other_country_table_field_name,
             other_country_id,
             other_country_name,
             ratio,
             token_set_ratio,
             maximum_score
      FROM rest_to_wiki

      UNION ALL

      SELECT id,
             self_country_table,
             self_country_table_field_name,
             self_country_id,
             self_country_name,
             other_country_table,
             other_country_table_field_name,
             other_country_id,
             other_country_name,
             ratio,
             token_set_ratio,
             maximum_score
      FROM cia_to_wiki) AS combined_relations;