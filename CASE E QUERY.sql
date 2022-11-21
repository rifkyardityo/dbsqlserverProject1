USE UniDlox
GO
--1
SELECT st.StaffID, StaffName, StaffAddress, SupplierName, Quantity AS [Total Purchases]
FROM Staff st JOIN PurchaseTransaction pt ON
st.StaffID = pt.StaffID JOIN Supplier su ON
su.SupplierID = pt.SupplierID
WHERE MONTH(pt.PurchaseDate) = 11 AND CAST(RIGHT(st.StaffID,1) AS INT) % 2 = 0 

--2
SELECT st.SalesID, CustomerName, 
SUM(st.Quantity*cl.ClothPrice) AS [Total Sales Price]
FROM SalesTransaction st JOIN Customer cs ON
st.CustomerID = cs.CustomerID JOIN Cloth cl ON
cl.ClothID = st.ClothID
WHERE CHARINDEX('m', cs.CustomerName) > 0 AND st.Quantity*cl.ClothPrice > 2000000
GROUP BY st.SalesID, cs.CustomerName

--3
SELECT DATENAME(MONTH,pt.PurchaseDate) AS [Month],
SUM(pt.Quantity*mt.MaterialPrice) AS [Transaction Count],
SUM(pt.Quantity) AS [Material Sold Count]
FROM PurchaseTransaction pt JOIN Material mt ON
pt.MaterialID = mt.MaterialID JOIN Staff st ON
st.StaffID = pt.StaffID
WHERE st.StaffAge between 25 AND 30 AND mt.MaterialPrice*pt.Quantity > 150000
GROUP BY pt.PurchaseDate

--4
SELECT LOWER(cs.CustomerName) AS CustomerName, CustomerEmail, 
CustomerAddress, Quantity AS [Cloth Bought Count], 
'IDR ' + CAST(SUM(st.Quantity*cl.ClothPrice) AS VARCHAR) AS [Total Price]
FROM Customer cs JOIN SalesTransaction st ON
cs.CustomerID = st.CustomerID JOIN Cloth cl ON
st.ClothID = cl.ClothID JOIN Payment pa ON
st.PaymentID = pa.PaymentID
GROUP BY cs.CustomerName, cs.CustomerEmail, cs.CustomerAddress, st.Quantity, cl.ClothPrice

--5
SELECT RIGHT(pt.PurchaseID,3) AS PurchaseID, PurchaseDate, StaffName, PaymentType AS PaymentTypeName
FROM PurchaseTransaction pt JOIN Staff st ON
pt.StaffID = st.StaffID JOIN Payment pa ON
pa.PaymentID = pt.PaymentID,
(
SELECT AVG(st.StaffSalary) AS StaffSalary
FROM Staff st
)x
WHERE st.StaffGender LIKE 'Female' AND st.StaffSalary > x.StaffSalary 
AND st.StaffAge > 2022 - 1996

--6
SELECT SalesID, FORMAT(TransactionDate, 'MM dd, yyyy') AS SalesDate,
CustomerName, CustomerGender
FROM SalesTransaction st JOIN Customer cs ON
st.CustomerID = cs.CustomerID,
(
	SELECT MIN(st.Quantity) AS MinimumQuantity
	FROM SalesTransaction st
)x
WHERE YEAR(st.TransactionDate) = 2021 AND st.Quantity < x.MinimumQuantity 
AND DAY(st.TransactionDate) = 15
-- Tidak ada data karena tidak ada insert data yang memiliki Quantity < minimumQuantity

--7
SELECT PurchaseID, SupplierName, REPLACE(SupplierPhone,'0','+62') AS SupplierPhone,
DATENAME(weekday,pt.PurchaseDate) AS PurchaseDate, Quantity
FROM PurchaseTransaction pt JOIN Supplier sp ON
pt.SupplierID = sp.SupplierID,
(
	SELECT AVG(pt.Quantity) AS TotalQuantity
	FROM PurchaseTransaction pt
)x
WHERE DATENAME(weekday,pt.PurchaseDate) IN ('Friday','Saturday','Sunday') AND Quantity > x.TotalQuantity

--8
SELECT
CASE
	WHEN CustomerGender LIKE 'Male' THEN 'Mr. ' + CustomerName
	ELSE 'Mrs. ' + CustomerName
END AS CustomerName, CustomerPhone, CustomerAddress, FORMAT(CustomerDOB, 'dd/MM/yyyy') AS CustomerDOB,
SUM(st.Quantity) AS ClothCount
FROM Customer cs JOIN SalesTransaction st ON
cs.CustomerID = st.CustomerID,
(
	SELECT MAX(st.Quantity) AS TotalCloth
	FROM SalesTransaction st
)x
WHERE st.Quantity = x.TotalCloth AND CHARINDEX('o', cs.CustomerName) > 0
GROUP BY cs.CustomerGender, cs.CustomerName, cs.CustomerPhone, cs.CustomerAddress, cs.CustomerDOB

--9
CREATE VIEW ViewCustomerTransaction AS
SELECT cs.CustomerID, CustomerName, CustomerEmail, CustomerDOB, MIN(st.Quantity) AS [Minimum Quantity], 
MAX(st.Quantity) AS [Maximum Quantity]
FROM Customer cs JOIN SalesTransaction st ON
cs.CustomerID = st.CustomerID 
WHERE YEAR(cs.CustomerDOB) >= 2000 AND cs.CustomerEmail LIKE '%@yahoo.com'
GROUP BY cs.CustomerID, cs.CustomerName, cs.CustomerEmail, cs.CustomerDOB

SELECT * FROM ViewCustomerTransaction

--10
CREATE VIEW ViewFemaleStaffTransaction AS
SELECT st.StaffID, UPPER(StaffName) AS [StaffName], 'Rp. ' + CAST(st.StaffSalary AS VARCHAR) + ',00' AS [StaffSalary],
CAST(pt.Quantity AS VARCHAR) + 'Pc(s)' AS [Material Bought Count]
FROM Staff st JOIN PurchaseTransaction pt ON
st.StaffID = pt.StaffID,
(
SELECT AVG(st.StaffSalary) AS StaffSalary
FROM Staff st
)x
WHERE st.StaffGender LIKE 'Female' AND st.StaffSalary > x.StaffSalary

SELECT * FROM ViewFemaleStaffTransaction