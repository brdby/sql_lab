--Functions

CREATE FUNCTION one() RETURNS integer AS $$
    SELECT 1 AS result;
    $$ LANGUAGE SQL;

CREATE FUNCTION sum_fire_danger(FirePower SMALLINT, FireArea SMALLINT)
    RETURNS INTEGER AS 'SELECT FirePower*FireArea;'
    LANGUAGE SQL;

CREATE FUNCTION getLS(id SMALLINT) RETURNS SETOF LS_PSCH AS $$
    SELECT * FROM LS_PSCH WHERE DepartmentMembersID = id;
    $$ LANGUAGE SQL;

--Triggers

CREATE FUNCTION delete_error() RETURNS TEXT AS $$
    SELECT 'Delete is not allowed here' AS Error;
    $$ LANGUAGE SQL;

CREATE TABLE LS_PSCH_log(
    Operation text,
    TimeOfOperation timestamp without time zone
);


CREATE FUNCTION LS_PSCH_logAction() RETURNS TRIGGER AS $$
    INSERT INTO LS_PSCH_log VALUES (TG_OP, NOW());
    $$ LANGUAGE SQL;

CREATE TRIGGER lspsch_modification
    AFTER INSERT OR UPDATE OR DELETE ON LS_PSCH
    EXECUTE PROCEDURE add_to_log ();

CREATE TRIGGER fire_delete
    INSTEAD OF DELETE ON Fire
    EXECUTE PROCEDURE delete_error();

CREATE TRIGGER fire_update
    INSTEAD OF UPDATE ON Fire ;

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
/*
DROP EVENT TRIGGER IF EXISTS abort_ddl;
DROP TRIGGER IF EXISTS fire_delete;
DROP TRIGGER IF EXISTS fire_update;
*/
