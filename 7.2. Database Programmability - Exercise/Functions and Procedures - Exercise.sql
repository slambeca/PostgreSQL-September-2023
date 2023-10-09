-- 01. User-defined Function Full Name

CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(101) 
AS -- 50 + 50 + space = 101
$$
	BEGIN
		IF first_name IS NOT NULL AND last_name IS NOT NULL THEN
			RETURN INITCAP(CONCAT_WS(' ', first_name, last_name));
		ELSIF first_name IS NOT NULL AND last_name IS NULL THEN
			RETURN INITCAP(first_name);
		ELSIF last_name IS NOT NULL AND first_name IS NULL THEN
			RETURN INITCAP(last_name);
		ELSE
			RETURN NULL;
		END IF;
	END;
$$
LANGUAGE plpgsql;

-- Variant 2

CREATE OR REPLACE FUNCTION fn_full_name(
	first_name VARCHAR(50), 
	last_name VARCHAR(50)
)
RETURNS VARCHAR(101) 
AS -- 50 + 50 + space = 101
$$
DECLARE
	full_name VARCHAR(101);
	BEGIN
		full_name := INITCAP(first_name) || ' ' || INITCAP(last_name);
		RETURN full_name;
	END;
$$
LANGUAGE plpgsql;

-- 02. User-defined Function Future Value

CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum DECIMAL,
	yearly_interest_rate DECIMAL,
	number_of_years INT
)
RETURNS DECIMAL AS
$$
	BEGIN
		RETURN TRUNC(
		initial_sum * POWER(1 + yearly_interest_rate, number_of_years),
		4);
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_calculate_future_value(1000, 0.1, 5);

-- 03. User-defined Function Is Word Comprised

CREATE OR REPLACE FUNCTION fn_is_word_comprised (
	set_of_letters VARCHAR(50),
	word VARCHAR(50)
) RETURNS BOOLEAN
AS
$$
	BEGIN
		RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_is_word_comprised('ois tmiah%f', 'Sofia')

-- 04. Game Over
