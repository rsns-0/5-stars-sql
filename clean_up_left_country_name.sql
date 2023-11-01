CREATE OR REPLACE FUNCTION clean_country_name(input_string TEXT)
    RETURNS TEXT AS
$$

	const regex = [
		"federation",
		"of",
		"and",
		"democratic",
		"republic",
		"the",
		"people",
		"people's",
		"islands",
		"island",
		"northern",
		"commonwealth",
		",",
	];
	const regexPattern = new RegExp(`\\b(${regex.join("|")})\\b`, "gi");
	const cleanedString = input_string
		.replace(",", "") // remove commas
		.replace(regexPattern, "") // main regex
		.replace(`'s`, "") // remove "'s"
		.trim() // trim outer whitespace
		.replace(/ +(?= )/g, ""); // remove extra spaces

	return cleanedString;
$$ LANGUAGE plv8 IMMUTABLE;

CREATE OR REPLACE VIEW country_names_cleaned AS

WITH cte AS (SELECT DISTINCT left_country_name AS original_value
             FROM calculations
             LIMIT 5000)
SELECT original_value,
       clean_country_name(original_value) AS new_value
FROM cte;