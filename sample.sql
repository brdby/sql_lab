CREATE TABLE PSCH
(
    PSCHID SMALLINT,
    PSCHName VARCHAR(15),
    PSCHAddress VARCHAR(50),
    PSCHContactNumbers VARCHAR(11),
    PSCHHeadName VARCHAR(30),
    ControlledRegion VARCHAR(20),

    PRIMARY KEY (PSCHID)
);

CREATE TABLE Facility
(
    FacilityID VARCHAR(20),
    FacilityAddress VARCHAR(25),
    Phone TEXT,
    WorkingHours TEXT,
    Men VARCHAR(5),
    EmployeeNumber VARCHAR(5),
    FacilityAssignment VARCHAR(35),
    FacilityFireResistance VARCHAR(20),
    FacilitySize VARCHAR(7),
    Attic VARCHAR(4),
    Basement VARCHAR(4),
    FloorNumber VARCHAR(5),
    WallMaterial VARCHAR(30),
    PartitionsMaterial VARCHAR(30),
    OverlapMaterial VARCHAR(30),
    RoofMaterial VARCHAR(30),
    ChairMaterial VARCHAR(30),
    EscapeRoutes VARCHAR(50),
    PowerOutage VARCHAR(30),
    DangerPlaces VARCHAR(50),
    FireWaterSupply VARCHAR(70),
    FireEquipment VARCHAR(70),
    FireAlarm VARCHAR(50),
    Squad VARCHAR(100),
    SquadRoute VARCHAR(100),

    PRIMARY KEY (FacilityID)
);

CREATE TABLE Fire
(
    FireID SMALLINT,
    FirePower SMALLINT,
    FireArea SMALLINT,
    FireForm VARCHAR(35),
    FacilityID VARCHAR(20),

    PRIMARY KEY (FireID),

    FOREIGN KEY (FacilityID) REFERENCES Facility (FacilityID)
);


CREATE TABLE Mechanism
(
    MechanismID SMALLINT,
    MechanismName VARCHAR(15),
    MechanismStateNumber SMALLINT,
    MechanismReleaseYear DATE,
    Mileage SMALLINT,
    PSCHID SMALLINT,
    Manufacturer VARCHAR(30),
    Status VARCHAR(20),
    PlacesNumber SMALLINT,

    PRIMARY KEY (MechanismID),

    FOREIGN KEY (PSCHID) REFERENCES PSCH (PSCHID)
);

CREATE TABLE Department
(
    DepartmentID SMALLINT,
    MechanismID SMALLINT,
    RecieptDate DATE,
    MembersNumber INTEGER,

    PRIMARY KEY (DepartmentID),

    FOREIGN KEY (MechanismID) REFERENCES Mechanism (MechanismID)
);

CREATE TABLE DepartmentMembers
(
    DepartmentMembersID SMALLINT,
    DepartmentRole CHAR(20),
    DepartmentID INTEGER,

    PRIMARY KEY (DepartmentMembersID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);

CREATE TABLE LS_PSCH
(
    EmployeeID SMALLINT,
    FullName VARCHAR(30),
    Birthday DATE,
    WorkExperience SMALLINT,
    PSCHID SMALLINT,
    DepartmentMembersID SMALLINT,

    PRIMARY KEY (EmployeeID),

    FOREIGN KEY (PSCHID) REFERENCES PSCH (PSCHID),
    FOREIGN KEY (DepartmentMembersID) REFERENCES DepartmentMembers (DepartmentMembersID)
);

CREATE TABLE PTViO
(
    EquipmentID SMALLINT,
    PTVName VARCHAR(20),
    ControlNumber INTEGER,
    ActualNumber INTEGER,
    Missing INTEGER,
    PSCHID SMALLINT,

    PRIMARY KEY (EquipmentID),

    FOREIGN KEY (PSCHID) REFERENCES PSCH (PSCHID)
);

CREATE TABLE DepartmentEquipment
(
    DepartmentEquipmentID SMALLINT,
    EquipmentID SMALLINT,
    FireID SMALLINT,
    DepartmentID SMALLINT,

    PRIMARY KEY (DepartmentEquipmentID),

    FOREIGN KEY (EquipmentID) REFERENCES PTViO (EquipmentID),
    FOREIGN KEY (FireID) REFERENCES Fire (FireID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);

CREATE TABLE Liquidation
(
    LiquidationID SMALLINT,
    FireID SMALLINT,
    DepartmentID SMALLINT,
    StartTime TIMESTAMP,
    FinishTime TIMESTAMP,

    PRIMARY KEY (LiquidationID),

    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID),
    FOREIGN KEY (FireID) REFERENCES Fire (FireID)
);

INSERT INTO PSCH
    VALUES  (1, 'Крутая', 'Первая верхняя 3А',  '74955553535', 'Иванов В.В.', 'Первый'),
            (2, 'Супер', 'Улица Винница 6Б', '8321932193', 'Крутой В.А.', 'Пятый'),
            (3, 'Пупер', 'Проспект уаааа 12Ц', '7319236129', 'Вор Б.В.', 'Новый');

INSERT INTO Facility
    VALUES  ('Крутой обьект', 'Адрес крутого обьекта', '8132731912', '9:00 - 19:00', 'МНОГА', 'МНОГА', 'ЧТО', 'ЧТО', '123','321', '231','что', 'что','что','что','что','что','что','что','что','что','что','что','что'),
            ('Крутой обьект 2', 'Адрес крутого обьекта 2', '812327231312', '10:00 - 19:00', 'МНОГА', 'МНОГА', 'ЧТО', 'ЧТО', '123','321', '231','что', 'что','что','что','что','что','что','что','что','что','что','что','что');

INSERT INTO Fire
    VALUES (1, 2, 13, 'чего', 'Крутой обьект'),
           (2, 4, 20, 'кого', 'Крутой обьект'),
           (3, 1, 5, 'эээ', 'Крутой обьект 2'),
           (4, 7, 55, 'ух', 'Крутой обьект 2');

INSERT INTO Mechanism
    VALUES (1, 'Какая-то машина', 213, '01-01-2010', 200, 1, 'ЛАДА', 'Норм', 4),
           (2, 'Еще машина', 213, '01-01-2010', 150, 1, 'ЛАДА', 'Норм', 4),
           (3, 'Грузовик', 200, '05-01-2010', 300, 1, 'Майкрософт', 'Так себе', 10),
           (4, 'Какая-то машина', 250, '01-01-2015', 100, 2, 'УЭА', 'Норм', 4),
           (5, 'Еще машина', 213,' 01-01-2010', 200, 2, 'ЛАДА', 'Норм', 5),
           (6, 'Газель', 240, '01-01-2015', 300, 3, 'ЛАДА', 'Норм', 8);

INSERT INTO Department
    VALUES (1, 1, '01-01-2010', 2),
           (2, 2, '01-01-2010', 4),
           (3, 3, '01-01-2010', 5),
           (4, 4, '01-01-2010', 2),
           (5, 5, '01-01-2010', 2),
           (6, 6, '01-01-2010', 2);


INSERT INTO DepartmentMembers
    VALUES (1, 'РЕАГИРОВАНИЕ', 1),
           (2, 'ТУШЕНИЕ', 2),
           (3, 'ТРАНСПОРТ', 3),
           (4, 'РЕАГИРОВАНИЕ', 4),
           (5, 'ТУШЕНИЕ', 5),
           (6, 'ТРАНСПОРТ', 6);

INSERT INTO LS_PSCH
    VALUES (1, 'Петров А.А.', '01-01-1990', 12, 1, 1),
           (2, 'Иванов А.А.', '01-01-1989', 10, 1, 1),
           (3, 'Сидоров А.А.', '01-01-1980', 1, 1, 2),
           (4, 'Робертов А.А.', '01-01-1985', 0, 1, 2),
           (5, 'Бабушкин А.А.', '01-01-1976', 13, 1, 2),
           (6, 'Белов А.А.', '01-01-1995', 16, 1, 2),
           (7, 'Калугин А.А.', '01-01-1991', 3, 1, 3),
           (8, 'Фадеев А.А.', '01-01-1991', 20, 2, 3),
           (9, 'Фишер А.А.', '01-01-1991', 40, 2, 3),
           (10, 'Максимов А.А.', '01-01-1990', 21, 2, 3),
           (11, 'Мурадов А.А.', '01-01-1992', 30, 2, 3),
           (12, 'Шкловский А.А.', '01-01-1994', 12, 3, 4),
           (13, 'Джеймс А.А.', '01-01-1987', 10, 3, 4),
           (14, 'Даль А.А.', '01-01-1975', 32, 3, 5),
           (15, 'Дарвин А.А.', '01-01-1979', 26, 3, 5),
           (16, 'Григорьев А.А.', '01-01-1970', 33, 3, 6),
           (17, 'Иванов А.А.', '01-01-1973', 18, 3, 6);

INSERT INTO PTViO
    VALUES (1, 'Вешалки', 30, 29, 1, 1),
           (2, 'Шайбы', 40, 29, 11, 1),
           (3, 'Гвозди', 100, 100, 0, 1),
           (4, 'Колеса', 5, 5, 0, 2),
           (5, 'Ложки', 50, 49, 1, 2),
           (6, 'Вилки', 30, 29, 1, 2),
           (7, 'Шляпы', 10, 9, 1, 3),
           (8, 'Важные предметы', 21, 21, 0, 3);

INSERT INTO DepartmentEquipment
    VALUES (1, 1, 1, 1),
           (2, 2, 1, 1),
           (3, 3, 2, 2),
           (4, 4, 2, 3),
           (5, 5, 3, 4),
           (6, 6, 3, 5),
           (7, 7, 4, 5),
           (8, 8, 4, 6);

INSERT INTO Liquidation
    VALUES (1, 1, 1, TIMESTAMP '2010-01-08 04:05:06',TIMESTAMP '2010-01-08 11:05:06'),
           (2, 2, 3, TIMESTAMP '2015-01-08 14:05:06', TIMESTAMP '2015-01-08 18:05:06'),
           (3, 3, 4, TIMESTAMP '2017-01-08 12:05:06', TIMESTAMP '2017-01-08 13:05:06'),
           (4, 4, 3, TIMESTAMP '2018-01-08 19:05:06', TIMESTAMP '2018-01-08 22:05:06');

SELECT DISTINCT FullName FROM LS_PSCH

SELECT FullName FROM LS_PSCH

SELECT * FROM DepartmentMembers WHERE DepartmentRole = 'РЕАГИРОВАНИЕ'

SELECT DepartmentRole, COUNT(DepartmentMembersID) as DepartmentsCount from DepartmentMembers GROUP BY DepartmentRole

SELECT DepartmentMembersID, COUNT(EmployeeID) as DepartmentMembersCount from LS_PSCH GROUP BY DepartmentMembersID
