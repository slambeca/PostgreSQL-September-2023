-- 01. User-defined Function Full Name

CREATE OR REPLACE FUNCTION fn_full_name(first_name text, last_name text)
RETURNS text AS
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