CREATE DATABASE UniDlox
GO
USE UniDlox
GO
CREATE TABLE [Staff](
	StaffID CHAR(5) PRIMARY KEY
		check(StaffID like 'SF[0-9][0-9][0-9]'),
	StaffName VARCHAR(225) not null,
	StaffPhone VARCHAR(16)  not null,
	StaffAddress VARCHAR(15) 
		check(LEN(StaffAddress) between 10 and 15),
	StaffAge INT not null ,
	StaffGender VARCHAR(6) not null check(StaffGender in('Male', 'Female')),
	StaffSalary INT not null
)
go
CREATE TABLE [Supplier](
	SupplierID CHAR(5) PRIMARY KEY
		check(SupplierID like 'SU[0-9][0-9][0-9]'),
	SupplierName VARCHAR(225)
		check(len(SupplierName)>6) not null,
	SupplierPhone VARCHAR(16)  not null,
	SupplierAddress VARCHAR(255) not null
)
go
CREATE TABLE [Material](
	MaterialID CHAR(5) PRIMARY KEY
		check(MaterialID like 'MA[0-9][0-9][0-9]'),
    MaterialName VARCHAR(255) not null,
    MaterialPrice INT not null
)
go
CREATE TABLE [Payment](
	PaymentID CHAR(5) PRIMARY KEY
		check(PaymentID like 'PA[0-9][0-9][0-9]'), 
	PaymentType VARCHAR(20) CHECK(PaymentType in('DANA', 'OVO','Go-Pay','Shopee-Pay','Cash', 'Debit Card','Virtual Account','Credit Card','Cryptocurrency','Flazz'))
)
go
CREATE TABLE [Customer](
     CustomerID CHAR(5) PRIMARY KEY 
        check(CustomerID like 'CU[0-9][0-9][0-9]'),
    CustomerName VARCHAR(255) not null,
    CustomerPhone VARCHAR(16) not null,
    CustomerAddress VARCHAR(255) not null,
    CustomerEmail VARCHAR(255) check(CustomerEmail like '%@gmail.com' OR CustomerEmail like '%@yahoo.com'),
    CustomerGender VARCHAR(6) check(CustomerGender in('Male', 'Female')),
    CustomerDOB DATE not null
)
go
CREATE TABLE [Cloth](
     ClothID CHAR(5) PRIMARY KEY
		check(ClothID like 'CL[0-9][0-9][0-9]'),
    ClothName VARCHAR (255) not null,
    ClothStock INT not null,
    ClothPrice INT not null,
    ClothSold INT not null
)
go
CREATE TABLE [PurchaseTransaction](
    PurchaseID CHAR(5) PRIMARY KEY 
		check(PurchaseID like 'PU[0-9][0-9][0-9]'),
    StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) not null,
    SupplierID CHAR(5) FOREIGN KEY REFERENCES Supplier(SupplierID) not null,
    PaymentID CHAR(5) FOREIGN KEY REFERENCES Payment(PaymentID) not null,
    MaterialID CHAR(5) FOREIGN KEY REFERENCES Material(MaterialID) not null,
    PurchaseDate DATE not null,
    Quantity INT not null
)
go
CREATE TABLE [SalesTransaction](
    SalesID CHAR(5) PRIMARY KEY
		check(SalesID like 'SA[0-9][0-9][0-9]'),
    StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) not null,
    CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) not null,
    PaymentID CHAR(5) FOREIGN KEY REFERENCES Payment(PaymentID) not null,
    ClothID CHAR(5) FOREIGN KEY REFERENCES Cloth(ClothID) not null,
    TransactionDate DATE not null,
    Quantity INT not null
)
go