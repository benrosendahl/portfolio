

use master


Create database Sales

Use Sales

  

--1
 
CREATE TABLE SpecialOfferProduct --2 PK: SpecialOfferID and ProductID, connected to SalesOrderDetail where both are FK
(
SpecialOfferID INT, 
ProductID INT,
ModifiedDate datetime Default GETDATE(),
CONSTRAINT SOP_PK_SOPID_PID PRIMARY KEY (SpecialOfferID, ProductID)
) --ADD FOREIGN KEYS LATER --

--2  
 
CREATE TABLE SalesOrderDetail -- 2 PK: SalesOrderID, SalesOrderDetailID, connected to SalesOrderHead by SalesOrderID, SalesOrderNumber 
(
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber nvarchar(25) null,
OrderQTY smallint not null,
ProductID  INT not null,
SpecialOfferID int not null,
UnitPrice money not null,
UnitPriceDiscount money not null,
ModifiedDate datetime default Getdate(),
CONSTRAINT SOD_PK_SOID_SODID PRIMARY KEY (SalesOrderID, SalesOrderDetailID)
) --ADD FOREIGN KEYS LATER -- 

--3
CREATE TABLE CurrencyRate
(
CurrencyRateID int PRIMARY KEY,
FromCurrencyCode nchar (3) not null,
ToCurrencyCode nchar (3) not null,
AverageRate money not null,
EndOfDayRate money not null,
ModifiedDate datetime not null
)  --ADD FOREIGN KEYS LATER

--4
CREATE TABLE ShipMethod
(
ShipMethodId int Primary Key,
Name nvarchar (50) not null,
ShipBase money not null,
ShipRate money not null,
ModifiedDate datetime not null
) -- ADD FOREIGN KEYS LATER

--5
Create table Address
(
AddressID int PRIMARY KEY,
AddressLine1 nvarchar (60) not null,
AddressLine2 nvarchar (60),
City nvarchar (30) not null,
StateProvinceID int not null,
PostalCode nvarchar (15) not null,
ModifiedDate datetime not null
)
 ---ADD FOREIGN KEYS LATER

--6
CREATE TABLE CreditCard
(
CreditCardID int PRIMARY KEY,
CardType nvarchar (50) not null,
CardNumber nvarchar (25) not null,
ExpMonth tinyint not null,
ExpYear smallint not null,
ModifiedDate datetime not null
) --ADD FOREIGN KEYS LATER

--7
 Create table SalesPerson
(
BusinessEntityID int Primary Key,
TerritoryID int,
SalesQuota money,
Bonus money,
CommisionPct smallmoney not null,
SalesYTD money not null,
SalesLastYear money not null,
ModifiedDate datetime not null
)
--ADD FOREIGN KEYS LATER

--8
Create table SalesTerritory
(
TerritoryID int Primary key,
Name nvarchar (50) not null,
CountryRegionCode nvarchar (3) not null,
SalesGroup nvarchar (50) not null,
SalesYTD money not null,
SalesLastYear money not null,
CostYTD money not null,
CostLastYear money not null,
ModifiedDate datetime not null
)--ADD FOREIGN KEYS LATER

--9
Create table Customer
(
CustomerID int Primary Key,
PersonID int,
StoreID int,
TerritoryID int,
AccountNumber int not null,
ModifiedDate datetime not null
)--ADD FOREIGN KEYS LATER

--10
 
Create table SalesOrderHeader
(
SalesOrderID int Primary Key,
RevisionNumber tinyint not null,
OrderDate datetime not null,
DueDate datetime not null,
ShipDate datetime default GetDate (),
Status tinyint not null,
SalesOrderNumber int not null,
CustomerID int not null,
SalesPersonID int,
TerritoryID int,
BillToAddressID int not null,
ShipToAddressID int not null,
ShipMethodID int not null,
CreditCardID int not null,
CreditCardApprovalCode varchar (15),
CurrencyRateID int,
SubTotal money not null,
TaxAmt money not null,
Freight money not null
)

 
 --Insert into 1
 
 Insert into SpecialOfferProduct
 Values 
  (1, 2, 2020-01-01),
  (2, 1, 2021-01-01),
  (2, 3, 2021-01-01),
  (3, 1, 2021-01-01),
  (3, 2, 2021-01-01),
  (4, 3, 2021-01-01),
  (4, 2, 2022-01-01),
  (5, 1, 2022-01-01),
  (5, 2, 2022-01-01),
  (5, 3, 2022-01-01),
  (5, 4, 2022-01-01),
  (5, 6, 2022-01-01)
 
 --Insert into 2
 
 Insert into SalesOrderDetail
 Values
 (1,1, 123456789, 1, 2, 1, 25.5, 5.5, 2020-01-01),
 (2,2, 234567891, 1, 1, 2, 35.5, 7.5, 2020-01-02),
 (3,3, 345678912, 1, 3, 2, 45.5, 9.5, 2020-01-03),
 (4,4, 456789123, 1, 1, 3, 55.5, 10.5, 2020-01-04),
 (5,5, 567891234, 1, 2, 3, 25.5, 5.5, 2020-01-05),
 (6,6, 678912345, 2, 3, 4, 25.5, 5.5, 2020-01-06),
 (7,7, 789123456, 2, 2, 4, 25.5, 5.5, 2020-01-07),
 (8,8, 891234567, 2, 1, 5, 25.5, 5.5, 2020-01-08),
 (9,9, 912345678, 3, 2, 5, 25.5, 5.5, 2020-01-09),
 (10,10, 912345678, 3, 3, 5, 25.5, 5.5, 2020-01-10),
 (11,11, 123456789, 3, 4, 5, 25.5, 5.5, 2020-01-11),
 (12,12, 123456789, 4, 6, 5, 25.5, 5.5, 2020-01-12)
 
  
 
 --Insert 3
 Insert into CurrencyRate
 Values
 (1, 'USD', 'EUR', 1.5, 2, 2020-01-01),
 (2, 'EUR', 'USD', 0.75, 1, 2020-01-02),
 (3, 'USD', 'CAD', 1.2, 1, 2020-01-03),
 (4, 'CAD', 'USD', 0.9, 1, 2020-01-03),
 (5, 'CNY', 'USD', 0.14, 0.1, 2020-01-04),
 (6, 'USD', 'CNY', 7.16, 7, 2020-01-05),
 (7, 'EUR', 'CNY', 7.82, 8, 2020-01-06),
 (8, 'CNY', 'EUR', 0.13, 0.1, 2020-01-07),
 (9, 'EUR', 'NIS', 4.15, 4, 2020-01-08),
 (10, 'NIS', 'EUR', 0.13, 0.1, 2020-01-09),
 (11, 'USD', 'NIS', 3.85, 4, 2020-01-10),
 (12, 'NIS', 'USD', 0.26, 0.3, 2020-01-10)
  
 --Insert into 4
Insert into ShipMethod
Values
(1, 'מקומי', 0.00, 0.00, 2024-01-01),
(2, 'מקומי 2', 0.00, 0.00, 2024-01-02),
(3, 'מקומי אקספרס', 2.5, 1.50, 2024-01-01),
(4, 'מקומי 24 אחה"צ', 3.0, 1.50, 2024-01-02),
(5, 'מקומי 24 בוקר', 3.5, 1.99, 2024-01-02),
(6, 'חו"ל אוניה', 29.95, 2.99, 2024-01-03),
(7, 'חול רכבת', 29.95, 2.99, 2024-01-03),
(8, 'חו"ל מטוס רגיל', 39.95, 4.99, 2024-01-04),
(9, 'חו"ל מטוס מהיר', 49.95, 5.99, 2024-01-03),
(10, 'חו"ל פדאקס', 129.95, 12.99, 2024-01-04)

--Insert into 5
Insert into Address
Values
(1, 'רחוב ארלוזורוב', null, 'ירושלים', 11, 9100000, 2024-01-01),
(2, 'רחוב יפו', null, 'ירושלים', 11, 9101000, 2024-01-01),
(3, 'רחוב שלומציון המלכה ', null, 'ירושלים', 11, 9110000, 2024-01-01),
(4, 'רחוב ביאליק', null, 'תל אביב', 12, 6300000, 2024-01-01),
(5, 'רחוב ארלוזורוב', null, 'תל אביב', 11, 6100000, 2024-01-01),
(6, 'רחוב מלכי ישראל', 'כיכר רבין', 'תל אביב', 12, 6300000, 2024-01-01),
(7, 'רחוב ביאליק', null, 'חיפה', 13, 3800000, 2024-01-01),
(8, 'אבא חושי', null, 'חיפה', 13, 3300000, 2024-01-01),
(9, 'דניה', 'שכונת דניה', 'חיפה', 13, 3840000, 2024-01-01),
(10, 'רחוב ביאליק', null, 'חיפה', 13, 3845000, 2024-01-01)


 ---Insert into 6
 
Insert into CreditCard
Values
(1, 'ויזה דיסקונט', '4580-1600-1234-4321', 01, 28, 2024-01-01),
(2, 'ויזה פועלים', '4580-1600-1233-4321', 02, 29, 2024-01-02),
(3, 'ויזה בינלאומי', '4580-1600-1224-4321', 03, 30, 2024-01-03),
(4, 'ויזה לאומי', '4580-1600-1234-4321', 01, 32, 2024-01-04),
(5, 'ויזה חו"ל', '4580-1601-1234-4321', 01, 33, 2024-01-05),
(6, 'מאסטר', '5555-5555-5555-4444 ', 01, 28, 2024-01-01),
(7, 'מאסטר', '5555-1600-1234-4321', 01, 32, 2024-01-02),
(8, 'דיינרס', '3852-0000-023-237', 01, 28, 2024-01-01),
(9, 'אמריקן אקספרס', ' 3799-9999-9999-994', 01, 33, 2024-01-03),
(10, 'ישראכרט', '4580-1600-1111-4321', 05, 28, 2024-01-01),
(11, 'ויזה סופרסל', '4580-1600-4321-4321', 08, 30, 2024-01-07)



--Insert into 7 
Insert into SalesPerson
Values
(111, NULL, NULL, 0.00, 0.01, 11111.50, 0.00, 2024-06-06),
(222, 1, 20000.00, 200.00, 0.01, 2000000.50, 200000.00, 2024-06-06),
(333, 1, 30000.00, 300.00, 0.01, 3000000.50, 300000.00, 2024-06-06),
(444, NULL, NULL, 200.00, 0.01, 2000000.50, 200000.00, 2024-06-06),
(555, 2, 25000.00, 250.00, 0.01, 2500000.50, 250000.00, 2024-06-06),
(666, 3, 320000.00, 300.00, 0.01, 32000000.50, 2200000.00, 2024-06-06),
(777, NULL, NULL, 200.00, 0.01, 2000000.50, 200000.00, 2024-06-06),
(888, 5, 50000.00, 500.00, 0.01, 5000000.50, 500000.00, 2024-06-06),
(999, 6, 60000.00, 600.00, 0.01, 6000000.50, 600000.00, 2024-06-06),
(123, 7, 80000.00, 800.00, 0.01, 8000000.50, 800000.00, 2024-06-06),
(321, 8, NULL, NULL, 0.01, 2000000.50, 200000.00, 2024-06-06),
(210, 9, NULL, NULL, 0.01, 2000000.50, 200000.00, 2024-06-06)

 
--Insert into 8
Insert into SalesTerritory
Values
(1, 'גרמניה', 'DE', 'אירופה', 300000.00, 32986.45, 0.00, 0.00, 2023-01-01),
(2, 'אוסטריה', 'A', 'אירופה', 100000.00, 12986.45, 0.00, 0.00, 2023-01-01),
(3, 'איטליה', 'IT', 'אירופה', 800000.00, 2986.45, 0.00, 0.00, 2023-01-01),
(4, 'ספרד', 'ES', 'אירופה', 70000.00, 3986.45, 0.00, 0.00, 2023-01-01),
(5, 'פולין', 'PL', 'אירופה', 150000.00, 42986.45, 0.00, 0.00, 2023-01-01),
(10, 'צרפת', 'FR', 'אירופה', 850000.00, 45000.45, 0.00, 0.00, 2023-01-01),
(6, 'אנגליה', 'UK', 'אירופה', 120000.00, 52986.45, 0.00, 0.00, 2023-01-01),
(7, 'אוסטרליה', 'AU', 'PACIFIC', 110000.00, 33333.45, 0.00, 0.00, 2023-01-01),
(8, 'חוף מערבי', 'US', 'צפון אמריקה', 300000.00, 50000.45, 0.00, 0.00, 2023-01-01),
(9, 'חוף המזרחי', 'US', 'צפון אמריקה', 250000.00, 40000.45, 0.00, 0.00, 2023-01-01),
(11, 'קנדה', 'CA', 'צפון אמריקה', 130000.00, 55555.45, 0.00, 0.00, 2023-01-01),
(12, 'סין', 'CH', 'אסיה', 999999.00, 99999.45, 0.00, 0.00, 2023-01-01)
 

 --Insert into 9
 Insert into  Customer
 Values
 (1, NULL,  1234, 1, 12345678, 2024-08-08),
 (2, NULL,  1235, 6, 23456781, 2024-08-08),
 (3, NULL,  1236, 7, 34567812, 2024-08-08),
 (4, NULL,  1237, 8, 45678123, 2024-08-08),
 (5, NULL,  1238, 2, 56781234, 2024-08-08),
 (6, NULL,  1239, 4, 67812345, 2024-08-08),
 (7, NULL,  1345, 3, 67123458, 2024-08-08),
 (8, NULL,  1346, 2, 78123456, 2024-08-08),
 (9, NULL,  1347, 1, 12456783, 2024-08-08),
 (10, NULL, 1348, 1, 14567823, 2024-08-08),
 (11, NULL, 1414, 1, 14567238, 2024-08-08),
 (12, NULL, 1515, 1, 81234567, 2024-08-08)
   
--Insert into 10
 
 Insert into SalesOrderHeader
Values 
(1, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 1, 22221, 123, 1, 1, 1, 5,  1, 'אישור 123', NULL, 20656.345,  97.514, 38.50),
(2, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 2, 22221, 123, 1, 2, 2, 5,  2, 'אישור 122', NULL, 20556.345,  97.514, 38.50),
(3, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 3, 22221, 123, 1, 2, 1, 5,  3, 'אישור 121', 4,	 20776.345, 50.514, 38.50),
(4, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 4, 22222, 122, 1, 3, 3, 3,  3, 'אישור 120', 4,    20886.345, 50.514, 38.50),
(5, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 5, 22222, 122, 1, 4, 4, 3,  4, 'אישור 133', NULL, 20996.345, 50.514, 38.50),
(6, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 6, 22222, 122, 1, 5, 5, 3,  5, 'אישור 134', NULL, 20006.345, 30.514, 38.50),
(7, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 7, 22223, 124, 1, 6, 6, 7,  6, 'אישור 135', NULL, 18600.345, 30.514, 38.50),
(8, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 8, 22223, 124, 1, 7, 7, 7,  7, 'אישור 136', 3,	  120.345,   35.514, 38.50),
(9, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 9, 22223, 124, 1, 8, 8, 1,  8, 'אישור 137', 3,    30000.345,  45.514, 38.50),
(10, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 10, 22224, 124, 1, 9, 8, 1,  8, 'אישור 138', NULL, 35050.345, 55.514, 38.50),
(11, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 11, 22224, 125, 1, 9, 9, 6,  9, 'אישור 139', NULL, 78900.345, 100.514, 38.50),
(12, 8, 2024-01-02, 2024-03-04, 2024-02-02, 5, 12, 22224, 125, 1, 10, 10, 3,  10, 'אישור 140', NULL, 12345.345, 100.514, 38.50)
  
--Add Foreign Keys:
 
--1 SalesOrderHeader
 
--SOH_CreditCard
ALTER TABLE SalesOrderHeader  
ADD  CONSTRAINT FK_SOH_CC_CCID FOREIGN KEY(CreditCardID)
REFERENCES CreditCard (CreditCardID)

--SOH_SalesPerson
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_SP_BEID FOREIGN KEY (SalesPersonID)
REFERENCES SalesPerson (BusinessEntityID)
 
--SOH_SalesTerritory
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_ST_TID FOREIGN KEY (TerritoryID)
REFERENCES SalesTerritory (TerritoryID)

--SOH_Customer
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_C_CID FOREIGN KEY (CustomerID)
REFERENCES Customer (CustomerID) 

--SOH_SalesOrderDetail --BOTH DIRECTIONS INSTEAD OF ONE

ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_SOD_SOID FOREIGN KEY (SalesOrderID, SalesOrderNumber)
REFERENCES SalesOrderDetail (SalesOrderID, SalesOrderDetailID) 

--SOH_CurrencyRate
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_CR_CRID FOREIGN KEY (CurrencyRateID)
REFERENCES CurrencyRate (CurrencyRateID) 

--SOH_ShipMethod
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_SM_SMID FOREIGN KEY (ShipMethodID)
REFERENCES ShipMethod (ShipMethodID) 
 

--SOH_Address_Ship
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_ADD_ADDID_SID FOREIGN KEY (ShipToAddressID)
REFERENCES Address (AddressID) 

--SOH_Address_Bill
ALTER TABLE SalesOrderHeader
ADD CONSTRAINT FK_SOH_ADD_ADDID_BID FOREIGN KEY (BillToAddressID)
REFERENCES Address (AddressID) 


--2 SalesPerson

--ST_SalesPerson
ALTER TABLE SalesPerson
ADD CONSTRAINT FK_SP_ST_TID FOREIGN KEY (TerritoryID)
REFERENCES SalesTerritory (TerritoryID)

--3 Customer
--C_ST
ALTER TABLE Customer
ADD CONSTRAINT FK_C_ST_CID FOREIGN KEY (TerritoryID)
REFERENCES SalesTerritory (TerritoryID)

--4 SalesOrderDetail
--SOD_SpecialOfferProduct  
ALTER TABLE SalesOrderDetail
ADD CONSTRAINT FK_SOD_SOP_SOffID_ProdID FOREIGN KEY (SpecialOfferID, ProductID)
REFERENCES SpecialOfferProduct (SpecialOfferID, ProductID)
 

 
 
