--INSERT

INSERT INTO PSCH VALUES  (5, 'Хорошая', 'Николаевка 3Б',  '799999999', 'Сидоров В.В.', 'Седьмой');

INSERT INTO Mechanism VALUES (7, 'Погрузчик', 5, '01-01-2018', 5, 5, 'SCANIA', 'Хорошее', 1);

--UPDATE

UPDATE PSCH SET PSCHName='Отличная' WHERE PSCHID=5;

UPDATE Mechanism SET MechanismName='Большой погрузчик' WHERE MechanismID=7;

--DELETE

DELETE FROM PSCH WHERE PSCHName='Отличная';

DELETE FROM Mechanism WHERE MechanismName='Большой погрузчик';

--SELECT

SELECT * FROM Mechanism;

SELECT * FROM LS_PSCH WHERE DepartmentMembersID=2;

SELECT EmployeeID, FullName FROM LS_PSCH WHERE DepartmentMembersID=3;

--Big queries

SELECT EmployeeID, FullName, COUNT(*) FROM LS_PSCH WHERE PSCHID=1
    UNION ALL SELECT EmployeeID, FullName, COUNT(*) WHERE PSCHID=2
    GROUP BY DepartmentMembersID;

SELECT FirePower, FireArea, COUNT(*) FROM Fire WHERE FacilityID='Крутой обьект'
    UNION ALL SELECT FirePower, FireArea, COUNT(*) FROM Fire WHERE FacilityID='Крутой обьект 2'
    GROUP BY FacilityID
    ORDER BY FirePower;
