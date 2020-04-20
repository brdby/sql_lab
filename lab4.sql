--Functions

CREATE FUNCTION one() RETURNS integer AS $$
    SELECT 1 AS result;
    $$ LANGUAGE SQL;

CREATE FUNCTION sum_fire_danger(FirePower SMALLINT, FireArea SMALLINT)
    RETURNS SMALLINT AS 'SELECT FirePower*FireArea;'
    LANGUAGE SQL;

CREATE FUNCTION getLS(id SMALLINT) RETURNS SETOF LS_PSCH AS $$
    SELECT * FROM LS_PSCH WHERE DepartmentMembersID = id;
    $$ LANGUAGE SQL;

--Triggers
CREATE TABLE LS_PSCH_log(
    Operation text,
    TimeOfOperation timestamp without time zone
);


CREATE FUNCTION LS_PSCH_logAction() RETURNS trigger AS $$
    BEGIN
    INSERT INTO LS_PSCH_log VALUES (TG_OP, NOW());
    END;
    $$ LANGUAGE plpgsql;

CREATE FUNCTION Fire_id_changed() RETURNS trigger AS $$
    BEGIN
    RAISE NOTICE 'Fire ID was changed!';
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER lspsch_modification
    AFTER INSERT OR UPDATE OR DELETE ON LS_PSCH
    EXECUTE PROCEDURE LS_PSCH_logAction();

CREATE OR REPLACE FUNCTION forbid_more_than() RETURNS trigger
    LANGUAGE plpgsql AS
    $$
    DECLARE
        n bigint := TG_ARGV[0];
    BEGIN
        IF (SELECT count(*) FROM deleted_rows) <= n IS NOT TRUE
    THEN
        RAISE EXCEPTION 'More than % rows deleted', n;
    END IF;
        RETURN OLD;
    END;
    $$;

CREATE TRIGGER forbid_more_than_1
    AFTER DELETE ON Fire
    REFERENCING OLD TABLE AS deleted_rows
    FOR EACH STATEMENT
    EXECUTE PROCEDURE forbid_more_than(1);

CREATE TRIGGER fire_update
    BEFORE UPDATE ON Fire
    FOR EACH ROW
    WHEN (OLD.FireID IS DISTINCT FROM NEW.FireID)
    EXECUTE PROCEDURE Fire_id_changed();

--Event trigger

CREATE OR REPLACE FUNCTION abort_any_command()
    RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
        RAISE EXCEPTION 'command % not allowed', tg_tag;
        END;
    $$;

CREATE EVENT TRIGGER abort_ddl ON ddl_command_start
   EXECUTE PROCEDURE abort_any_command();

--Drop unnecessary
DROP EVENT TRIGGER IF EXISTS abort_ddl;
DROP TRIGGER IF EXISTS lspsch_modification ON LS_PSCH;
DROP TRIGGER IF EXISTS fire_update ON Fire;
DROP TRIGGER IF EXISTS forbid_more_than_1 ON Fire;
DROP FUNCTION IF EXISTS one();
DROP FUNCTION IF EXISTS sum_fire_danger(FirePower SMALLINT, FireArea SMALLINT);
DROP FUNCTION IF EXISTS getLS(id SMALLINT);
DROP FUNCTION IF EXISTS LS_PSCH_logAction();
DROP FUNCTION IF EXISTS Fire_id_changed();
DROP FUNCTION IF EXISTS forbid_more_than();
DROP FUNCTION IF EXISTS abort_any_command();
DROP TABLE LS_PSCH_log;
