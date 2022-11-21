USE UniDlox
GO
--1 (INSERT)
BEGIN TRAN
	INSERT INTO PurchaseTransaction VALUES
	('PU026', 
	(SELECT StaffID FROM Staff WHERE StaffID = 'SF003'),
	(SELECT SupplierID FROM Supplier WHERE SupplierID = 'SU006'),
	(SELECT PaymentID FROM Payment WHERE PaymentID = 'PA002'),
	(SELECT MaterialID FROM Material WHERE MaterialID = 'MA004'),
	'20200806',212)
ROLLBACK
SELECT * FROM PurchaseTransaction
BEGIN TRAN
	INSERT INTO PurchaseTransaction VALUES
	('PU027', 
	(SELECT StaffID FROM Staff WHERE StaffID = 'SF002'),
	(SELECT SupplierID FROM Supplier WHERE SupplierID = 'SU002'),
	(SELECT PaymentID FROM Payment WHERE PaymentID = 'PA007'),
	(SELECT MaterialID FROM Material WHERE MaterialID = 'MA008'),
	'20200818',100)
ROLLBACK
SELECT * FROM PurchaseTransaction
BEGIN TRAN
	INSERT INTO SalesTransaction VALUES
	('SA026', 
	(SELECT StaffID FROM Staff WHERE StaffID = 'SF003'),
	(SELECT CustomerID FROM Customer WHERE CustomerID = 'CU001'),
	(SELECT PaymentID FROM Payment WHERE PaymentID = 'PA002'),
	(SELECT ClothID FROM Cloth WHERE ClothID = 'CL004'),
	'20200910',5)
ROLLBACK
SELECT * FROM SalesTransaction

--2 (UPDATE)
BEGIN TRAN
	UPDATE Material
	SET MaterialName = 'Metal', MaterialPrice = 40000
	WHERE MaterialID = 'MA001'
ROLLBACK
SELECT * FROM Material
BEGIN TRAN
	UPDATE Cloth
	SET ClothStock -= SalesTransaction.Quantity, ClothSold += SalesTransaction.Quantity
	FROM Cloth, SalesTransaction
	WHERE Cloth.ClothID = SalesTransaction.ClothID
	AND SalesTransaction.SalesID = 'SA005'
ROLLBACK
SELECT * FROM Cloth
--3 (DELETE)
BEGIN TRAN
	DELETE FROM SalesTransaction WHERE SalesID = 'SA012'
ROLLBACK
SELECT * FROM SalesTransaction
BEGIN TRAN
	DELETE FROM PurchaseTransaction	WHERE PurchaseID = 'PU007'
ROLLBACK
SELECT * FROM PurchaseTransaction
