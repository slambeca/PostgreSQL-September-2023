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

CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE (
	name VARCHAR(50), 
	game_type_id INT, 
	is_finished BOOLEAN
) 
AS
$$
BEGIN
    RETURN QUERY
    SELECT 
		g.name, 
		g.game_type_id, 
		g.is_finished
    FROM 
		games AS g
    WHERE 
		g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_is_game_over(true);

-- 05. Difficulty Level

CREATE OR REPLACE FUNCTION fn_difficulty_level(
	level INT
) RETURNS VARCHAR(50)
AS
$$
DECLARE
	difficulty_level VARCHAR(50);
BEGIN
	IF (level <= 40) THEN
		difficulty_level := 'Normal Difficulty';
	ELSIF (level BETWEEN 41 AND 60) THEN
		difficulty_level := 'Nightmare Difficulty';
	ELSE 
		difficulty_level := 'Hell Difficulty';
	END IF;
	RETURN difficulty_level;
END;
$$
LANGUAGE plpgsql;

SELECT 
	user_id, 
	level, 
	cash, 
	fn_difficulty_level(level) 
FROM 
	users_games
ORDER BY
	user_id ASC;

-- 06. Cash in User Games Odd Rows

CREATE OR REPLACE FUNCTION fn_cash_in_users_games (
	game_name VARCHAR(50)
) RETURNS TABLE (
	total_cash NUMERIC
) AS
$$
	BEGIN
		RETURN QUERY
		WITH ranked_games AS (
		SELECT
			cash,
			ROW_NUMBER() OVER (ORDER BY cash DESC) AS row_num
		FROM 
			users_games AS ug
		JOIN
			games AS g
		ON
			ug.game_id = g.id
		WHERE
			g.name = game_name
		)
		
	SELECT
		ROUND(SUM(cash), 2) AS total_cash
	FROM
		ranked_games 
	WHERE
		row_num % 2 <> 0;
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_cash_in_users_games('Love in a mist')

-- 07. Retrieving Account Holders (can not be tested in Judge)

CREATE OR REPLACE PROCEDURE 
	sp_retrieving_holders_with_balance_higher_than (
		searched_balance NUMERIC
	)
AS 
$$
DECLARE 
	holder_info RECORD;
BEGIN
	FOR holder_info IN 
		SELECT
			first_name || ' ' || last_name AS full_name,
			SUM(balance) AS total_balance
		FROM 
			account_holders AS ah
		JOIN 
			accounts AS a
		ON
			ah.id = a.account_holder_id
		GROUP BY
			full_name
		HAVING 
			SUM(balance) > searched_balance
		ORDER BY 
			full_name ASC
	LOOP
		RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
	END LOOP;
END;
$$
LANGUAGE plpgsql;


CALL sp_retrieving_holders_with_balance_higher_than(200000);

-- 08. Deposit Money
