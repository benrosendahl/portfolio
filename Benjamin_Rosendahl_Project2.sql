Use AdventureWorks2019

--1
--For Products NOT bought: ProductID, ProductName, Color, ListPrice, Size, order by: ProductID

Select p.ProductID, p.Name, p.Color, p.ListPrice, p.Size
from Production.Product as p 
			LEFT OUTER JOIN Sales.SalesOrderDetail AS sod  
			--left outer join shows all Product columns (left) but only matching Orders (right)
		on p.ProductID = sod.ProductID
Where SalesOrderID is NULL --if SalesOrderID is null, product was not ordered


--2
--Customers that did NOT order: LastName, CustomerID, Order by CustomerID asc
--If Customer has not Last Name or no First Name: Unknown

Select  c.CustomerID
    ,CASE WHEN p.FirstName IS NULL AND p.LastName IS NULL THEN 'Unknown' ELSE p.LastName END AS LastName
    ,CASE WHEN p.FirstName IS NULL AND p.LastName IS NULL THEN 'Unknown' ELSE p.FirstName END FirstName
	--to have "Unknown" for no fname or lname
from  [Sales].[Customer] c
left join [Person].[Person] p
on c.CustomerID = p.BusinessEntityID 
--left  join shows all Customers (left) but only matching Persons (right)
WHERE 
    NOT EXISTS (SELECT 1 
                FROM 
                    Sales.SalesOrderHeader AS ord
                WHERE 
                    ord.CustomerID = c.CustomerID) 
--if CustomerID in Sales Order not equal to CustomerID in Customer table, customer did not order
ORDER BY c.CustomerID

 
 --3
 --10 Customers with most orders: CustomerID, FirstName, LastName, CountofOrders

WITH CustomerByOrder -- CTE function that returns  CustomerID, FirstName, LastName, CountofOrders
AS
(
Select DISTINCT c.CustomerID, p.FirstName, p.LastName, 
Count (s.SalesOrderID) OVER (PARTITION BY s.CUSTOMERID) AS CountofOrders --counts number of orders per customer
 from   [Sales].[Customer] c
left join [Person].[Person] p
on c.PersonID = p.BusinessEntityID
--left  join shows all Customers (left) but only matching Persons (right)
join Sales.SalesOrderHeader s
on s.CustomerID = c.CustomerID
) 
Select TOP 10 --shows only top 10
* from CustomerByOrder
Order by CountofOrders desc
 

--4
--Employees, their Job titles and number of employees with same job title
--First Name, Last Name, Job Title, Hire Date, CountofTitle

Select p.FirstName, p.LastName, e.JobTitle, 
Count (Jobtitle) OVER (Partition by Jobtitle) CountofTitle --function that counts how often a job title appears
 from [HumanResources].[Employee] e
 left join [Person].[Person] p
 --left  join shows all Employees (left) but only matching Persons (right)
  on e.BusinessEntityID = p.BusinessEntityID
  Order by JobTitle


--5 for each customer: date of last order, date of order before last order
--SalesOrderID, CustomerID, LastName, FirstName, LastOrder, PreviousOrder

WITH Last_Before_Order ---details of customer, orderdate, order before 
AS
(
SELECT h.SalesOrderID, c.CustomerID, p.LastName, p.FirstName, h.OrderDate LastOrder,
lag(orderdate,1)OVER(PARTITION By c.personid ORDER BY orderdate ) PreviousOrder 
FROM sales.SalesOrderHeader h JOIN Sales.Customer c
ON h.CustomerID =c.CustomerID
JOIN Person.Person p
ON P.BusinessEntityID=C.PersonID
),
Only_last --CTE that returns only 
AS
(
Select *,  
RANK () OVER (Partition by CustomerID ORDER BY LastOrder desc)  rn
from Last_Before_Order
)  
Select SalesOrderID, CustomerID, LastName, FirstName, LastOrder, PreviousOrder
from Only_last
Where rn=1
 

--6 
--Sum (total) of most expensive products per year and which customers bought them
--Year (order year), SalesOrderID, last name and first name of customer, total = unitprice * (1-UnitpriceDiscount) * OrderQty

 WITH Salesperyear --CTE of sales per year
 AS
 (Select year (h.OrderDate) Year,
    h.salesorderid SalesOrderID, 
 p.FirstName,
 p.LastName,
 SUM (d.UnitPrice * (1-d.UnitPriceDiscount)* d.OrderQty) as total
 from  Sales.SalesOrderHeader h ---Order date
	join Sales.SalesOrderDetail d --Order details: Unitprice, Discount, Order Quantity
	on h.SalesOrderID = d.SalesOrderID 
		join Sales.Customer c --need customer in order to connect to person (first and last name of customer)
		on h.CustomerID = c.CustomerID
			join person.Person p --first and last name of customer
			on c.PersonID = p.BusinessEntityID
Group by h.SalesOrderID, p.FirstName, p.LastName, year (h.OrderDate)		
			) --will get person details from customers 
, Sales_ranking
AS
(
Select *,  
ROW_NUMBER () OVER (Partition by  year ORDER BY total desc)  rn
from Salesperyear
)
Select
YEAR,
SalesOrderID,
LastName,
FirstName,
Total 
from Sales_ranking
Where rn = 1
Order by Year


--7
--Number of orders every year

Select  *
from
(
Select   Year (h.OrderDate) as yy, Month (h.OrderDate) as MONTH, h.SalesOrderID as ID
from Sales.SalesOrderHeader h
	) as x
PIVOT (Count (ID) FOR YY IN ([2011], [2012], [2013], [2014])) as pvt
order by MONTH
 
--8 later
--Sum of orders for each month and total sum per year, at end - total of all years
--Columns: Year, Month, Sum_Price, CumSUm
 
Select CAST (Year(h.OrderDate) as varchar) Year,  CAST(Month (h.OrderDate) as varchar) Month, 
CAST (SUM (d.UnitPrice * (1-d.UnitPriceDiscount))as varchar) as Sum_Price,
Case when grouping(month(h.orderdate)) = 0
          then sum (case when month(h.orderdate) is not null 
		  then sum (d.UnitPrice * (1-d.UnitPriceDiscount)) end) 
		  over (partition by year(orderdate) order by month(orderdate))
          end as CumSum
		  from Sales.SalesOrderDetail d --line total (sum of orders)
join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
Group by year (h.orderdate), month (h.orderdate)

UNION

 --2011 grand_total for year
Select  CAST (Year(h.OrderDate) as varchar) Year,  Month = 'grand_total', 
'NULL' as Sum_Price,
Case when grouping(year(h.orderdate)) = 0
          then sum(case when year(h.orderdate) is not null 
		  then sum (d.UnitPrice * (1-d.UnitPriceDiscount)) end) 
		  over (partition by year(orderdate) order by year(orderdate))
          end as CumSum
		  from Sales.SalesOrderDetail d --line total (sum of orders)
join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
Where year (h.OrderDate) = 2011
Group by Year (h.orderdate) 

UNION

--2012 grand_total for year
Select  CAST (Year(h.OrderDate) as varchar) Year,  Month = 'grand_total', 
'NULL' as Sum_Price,
Case when grouping(year(h.orderdate)) = 0
          then sum(case when year(h.orderdate) is not null 
		  then sum (d.UnitPrice * (1-d.UnitPriceDiscount)) end) 
		  over (partition by year(orderdate) order by year(orderdate))
          end as CumSum
		  from Sales.SalesOrderDetail d --line total (sum of orders)
join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
Where year (h.OrderDate) = 2012
Group by Year (h.orderdate) 

UNION

--2013 grand_total for year
Select  CAST (Year(h.OrderDate) as varchar) Year,  Month = 'grand_total', 
'NULL' as Sum_Price,
Case when grouping(year(h.orderdate)) = 0
          then sum(case when year(h.orderdate) is not null 
		  then sum (d.UnitPrice * (1-d.UnitPriceDiscount)) end) 
		  over (partition by year(orderdate) order by year(orderdate))
          end as CumSum
		  from Sales.SalesOrderDetail d --line total (sum of orders)
join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
Where year (h.OrderDate) = 2013
Group by Year (h.orderdate) 

UNION

--2014 grand_total for year
Select  CAST (Year(h.OrderDate) as varchar) Year,  Month = 'grand_total', 
'NULL' as Sum_Price,
Case when grouping(year(h.orderdate)) = 0
          then sum(case when year(h.orderdate) is not null 
		  then sum (d.UnitPrice * (1-d.UnitPriceDiscount)) end) 
		  over (partition by year(orderdate) order by year(orderdate))
          end as CumSum
		  from Sales.SalesOrderDetail d --line total (sum of orders)
join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
Where year (h.OrderDate) = 2014
Group by Year (h.orderdate) 

UNION 

--Total_of_all_years
Select 'total_of_all_years' as Year,  'NULL' as Month, 
'NULL' as Sum_Price,
Sum (d.UnitPrice * (1-d.UnitPriceDiscount))  as CumSum
		  from Sales.SalesOrderDetail d
 join
Sales.SalesOrderHeader h --order date (year, month)
on d.SalesOrderID = h.SalesOrderID
 

--9
--Employees ordered by hiring date in each dept, from newest to most veteran employee
--DepartmentName, EmployeeID, Employee's Full Name, HireDate, Seniority, 
--PreviousEmployeeName, PreviousEmployeeHireDate, DiffDays


Select d.Name DepartmentName, h.BusinessEntityID EmployeeID, 
CONCAT (p.firstname, ' ',p.LastName) EmployeesFullName,
e.HireDate,
DATEDIFF (day, e.hiredate, Getdate()) Seniority,
Lead (CONCAT (p.firstname, ' ',p.LastName), 1) OVER (partition by d.name ORDER BY d.Name, DATEDIFF (day, e.hiredate, Getdate())) PreviousEmpName,
Lead (e.Hiredate) OVER (partition by d.name ORDER BY d.Name, DATEDIFF (day, e.hiredate, Getdate())) PreviousEmpHDate,
Datediff (day, Lead (e.Hiredate) OVER (partition by d.name ORDER BY d.Name, DATEDIFF (day, e.hiredate, Getdate())), e.hiredate) Diffdays
from
HumanResources.Employee e
	join HumanResources.EmployeeDepartmentHistory h --employee details employee, hire info from empl-dep-history
	on e.BusinessEntityID = h.BusinessEntityID --Department
		join HumanResources.Department d
		on h.DepartmentID = d.DepartmentID
			join person.Person p --full name
			on e.BusinessEntityID = p.BusinessEntityID
Order by DepartmentName, Seniority

--10
--Employee details of employees that were accepted to the same department at the same date
--HireDate, 
--DepartmentID, 
--TeamEmployees (in same field): EmployeeID LastName FirstName ',' EmployeeID LastName FirstName
--order by hiredate descending

Select e.HireDate, 
d.DepartmentID,
STRING_AGG (CONVERT(nvarchar(4000), CONCAT(e.BusinessEntityID, ' ', p.lastname, ' ', p.firstname, ' ')), ',') AS TeamEmployees 
from
HumanResources.Employee e
	join HumanResources.EmployeeDepartmentHistory h --employee details employee, hire info from empl-dep-history
	on e.BusinessEntityID = h.BusinessEntityID --Department
		join HumanResources.Department d
		on h.DepartmentID = d.DepartmentID
			join person.Person p --full name
			on e.BusinessEntityID = p.BusinessEntityID
Group by e.hiredate, d.DepartmentID
Order by e.HireDate desc 