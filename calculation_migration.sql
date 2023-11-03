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
                       AND right_country_table = 'newCiaLanguageData')

INSERT
INTO rest_countries_to_cia_calculation_data (id,
                                             rest_countries_name_id,
                                             cia_country_id,
                                             ratio,
                                             token_set_ratio)
SELECT id,
       self_country_id,
       other_country_id,
       ratio,
       token_set_ratio
FROM rest_to_cia;

WITH rest_to_wiki AS (SELECT id,
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
                        AND right_country_table = 'wikiData')


INSERT
INTO rest_countries_to_wiki_calculation_data (id,
                                              rest_countries_name_id,
                                              wiki_country_id,
                                              ratio,
                                              token_set_ratio)
SELECT id,
       self_country_id,
       other_country_id,
       ratio,
       token_set_ratio
FROM rest_to_wiki;


WITH cia_to_wiki AS (SELECT id,
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
INTO cia_to_wiki_calculation_data (id,
                                   cia_country_id,
                                   wiki_country_id,
                                   ratio,
                                   token_set_ratio)
SELECT id,
       self_country_id,
       other_country_id,
       ratio,
       token_set_ratio
FROM cia_to_wiki;
