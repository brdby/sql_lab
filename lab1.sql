SELECT DISTINCT FullName FROM LS_PSCH;

SELECT FullName FROM LS_PSCH;

SELECT * FROM DepartmentMembers WHERE DepartmentRole = 'РЕАГИРОВАНИЕ';

SELECT DepartmentRole, COUNT(DepartmentMembersID) as DepartmentsCount from DepartmentMembers GROUP BY DepartmentRole;

SELECT DepartmentMembersID, COUNT(EmployeeID) as DepartmentMembersCount from LS_PSCH GROUP BY DepartmentMembersID;

SELECT * FROM DepartmentMembers WHERE DepartmentRole = 'РЕАГИРОВАНИЕ' UNION SELECT * FROM DepartmentMembers WHERE DepartmentRole = 'ТУШЕНИЕ';

SELECT * FROM Fire JOIN Facility ON Fire.FacilityID = Facility.FacilityID;
