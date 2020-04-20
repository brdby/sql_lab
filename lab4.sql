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

--Test functions

SELECT one();

SELECT FireID, sum_fire_danger(FirePower, FireArea) FROM Fire;

SELECT getLS(1);

--Trigger
CREATE TABLE LS_PSCH_log(
    Operation text,
    TimeOfOperation timestamp without time zone
);


CREATE FUNCTION LS_PSCH_logAction() RETURNS trigger AS $$
    BEGIN
    INSERT INTO LS_PSCH_log VALUES (TG_OP, NOW());
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER lspsch_modification
    AFTER INSERT OR UPDATE OR DELETE ON LS_PSCH
    EXECUTE PROCEDURE LS_PSCH_logAction();

--Test trigger

INSERT INTO LS_PSCH VALUES (18, 'Боширов А.А.', '01-01-1973', 18, 3, 6);
DELETE FROM LS_PSCH WHERE EmployeeID = 18;

SELECT * FROM LS_PSCH_log;

--Trigger

CREATE FUNCTION Fire_id_changed() RETURNS trigger AS $$
    BEGIN
    RAISE NOTICE 'Fire power was changed!';
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER fire_update
    AFTER UPDATE ON Fire
    FOR EACH ROW
    WHEN (OLD.FirePower IS DISTINCT FROM NEW.FirePower)
    EXECUTE PROCEDURE Fire_power_changed();

--Test trigger

UPDATE Fire SET FireID=10  WHERE FireID=3;
UPDATE Fire SET FirePower=1  WHERE FireID=3;

--Trigger

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

--Test trigger

INSERT INTO PSCH
    VALUES  (11, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый')
            (12, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый')
            (13, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый')
            (14, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый')
            (15, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый');

DELETE FROM PSCH WHERE PSCHID>10;

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

--Trigger Test

CREATE TABLE aaa
(
    bbb SMALLINT
);

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

DELETE FROM PSCH WHERE PSCHID>10;
