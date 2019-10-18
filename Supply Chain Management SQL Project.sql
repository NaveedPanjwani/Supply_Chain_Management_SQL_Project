DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE SalesPerson CASCADE CONSTRAINTS;
DROP TABLE Territory CASCADE CONSTRAINTS;
DROP TABLE DoesBusinessIn CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE ProductLine CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE OrderLine CASCADE CONSTRAINTS;
DROP TABLE PriceUpdate CASCADE CONSTRAINTS;
DROP VIEW Comparison;
DROP VIEW Sales;
DROP VIEW Shipment;
DROP VIEW PurchaseHistory;
DROP VIEW ViewOrdered;

/* Create the Customer table. */
CREATE TABLE Customer (CustomerID         INTEGER,
                       CustomerName       VARCHAR(30),
                       CustomerAddress    VARCHAR(30),
                       CustomerCity       VARCHAR(30),
                       CustomerState      VARCHAR(5),
                       CustomerPostalCode VARCHAR(10),
                       CustomerEmail      VARCHAR(100),
                       CustomerUserName   VARCHAR(30),
                       CustomerPassword   VARCHAR(30),
                       PRIMARY KEY (CustomerID));
                    
-------------------------------------------------------------------------
/* Create the Territory table. */
CREATE TABLE Territory (TerritoryID INTEGER,
                        TerritoryName VARCHAR(30),
                        PRIMARY KEY (TerritoryID));
                        
 -------------------------------------------------------------------------
/* Create the ProductLine. */
CREATE TABLE ProductLine (ProductLineID INTEGER,
                          ProductLineName VARCHAR(30),
                          PRIMARY KEY (ProductLineID));
                          
--------------------------------------------------------------------------
/* Create the PriceUpdate table. */
CREATE TABLE PriceUpdate (PriceUpdateID INTEGER,
                          DateChanged DATE,
                          OldPrice REAL,
                          NewPrice REAL,
                          PRIMARY KEY (PriceUpdateID));
                       
-------------------------------------------------------------------------
/* Create the SalesPerson table. */
CREATE TABLE SalesPerson (SalespersonID       INTEGER,
                          SalespersonName     VARCHAR(30),
                          SalespersonPhone    VARCHAR(30),
                          SalespersonEmail    VARCHAR(100),
                          SalespersonUserName VARCHAR(30),
                          SalespersonPassword VARCHAR(30),
                          TerritoryID         INTEGER,
                          PRIMARY KEY (SalespersonID),
                          FOREIGN KEY (TerritoryID) REFERENCES Territory);
                          
                        
-------------------------------------------------------------------------
/* Create the DoesBusinessIn table. */
CREATE TABLE DoesBusinessIn (CustomerID  INTEGER,
                             TerritoryID INTEGER,
                             FOREIGN KEY (CustomerID) REFERENCES Customer,
                             FOREIGN KEY (TerritoryID) REFERENCES Territory);
                
-------------------------------------------------------------------------
/* Create the Product table. */
CREATE TABLE Product (ProductID     INTEGER,
                      ProductName   VARCHAR(30),
                      ProductFinish VARCHAR(30),
                      ProductStandardPrice REAL,
                      ProductLineID INTEGER,
                      Photo CLOB,
                      PRIMARY KEY (ProductID),
                      FOREIGN KEY (ProductLineID) REFERENCES ProductLine);
 


--------------------------------------------------------------------------
/* Create the Orders table. */     
CREATE TABLE Orders (OrderID INTEGER,
                     OrderDate DATE,
                     CustomerID  INTEGER,
                     PRIMARY KEY (OrderID),
                     FOREIGN KEY (CustomerID) REFERENCES Customer);
                     
--------------------------------------------------------------------------
/* Create the OrderLine table. */   
CREATE TABLE OrderLine (OrderID INTEGER,
                        ProductID INTEGER,
                        OrderedQuantity INTEGER,
                        SalePrice REAL,
                        FOREIGN KEY (OrderId) REFERENCES Orders,
                        FOREIGN KEY (ProductID) REFERENCES Product);
                        
                          

--------------------------------------------------------------------------
/* Create Views */
--------------------------------------------------------------------------

/* Create View #1 Comparison. */
CREATE VIEW Comparison (ProductId, ProductName, OrderQuantity)
AS SELECT DISTINCT P.ProductID, P.ProductName, SUM(OL.OrderedQuantity)
   FROM Product P, OrderLine OL
   WHERE P.ProductID = OL.ProductID
   GROUP BY P.ProductID, P.ProductName;

--------------------------------------------------------------------------

/* Create View #2 Sales. */
CREATE VIEW Sales (ProductID, ProductName, totalValue)
AS SELECT P.ProductID, P.ProductName, SUM(P.ProductStandardPrice * OL.OrderedQuantity)
   FROM Product P, OrderLine OL
   WHERE P.ProductID = OL.ProductID
   GROUP BY P.ProductID, P.ProductName;

--------------------------------------------------------------------------

/* Create View #3 CustomerData. */
CREATE VIEW CustomerData (CustomerID, ProductID, ProductName, StandardPrice)
AS SELECT O.CustomerID, P.ProductID, P.ProductName, P.ProductStandardPrice
   FROM Orders O, Product P, OrderLine OL
   WHERE OL.ProductID = P.ProductID AND O.OrderID = OL.OrderID
   GROUP BY O.CustomerID, P.ProductID, P.ProductName, P.ProductStandardPrice;

--------------------------------------------------------------------------

/* Create View #4 Shipment. */
CREATE VIEW Shipment (StateShip, NumberOfCustomers)
AS SELECT DISTINCT C.CustomerState, COUNT(C.CustomerAddress)
   FROM Customer C
   GROUP BY C.CustomerState;

--------------------------------------------------------------------------

/* Create View #5 PurchaseHistory. */
CREATE VIEW PurchaseHistory (CustomerID, OrderDate, Quantity, Price, ProductName, ProductID)
AS SELECT C.CustomerID, O.OrderDate, OL.OrderedQuantity, P.ProductStandardPrice, P.ProductName, P.ProductID
   FROM Orders O, OrderLine OL, Product P, Customer C
   WHERE O.OrderID = OL.OrderID AND O.CustomerID = C.CustomerID AND OL.ProductID = P.ProductID
   GROUP BY C.CustomerID, O.OrderDate, OL.OrderedQuantity, P.ProductStandardPrice, P.ProductName, P.ProductID; 
   
--------------------------------------------------------------------------

/* Create View #6 ViewOrdered. */
CREATE VIEW ViewOrdered (OrdredDate, CustomerID, ProductID, Quantity)
AS SELECT O.OrderDate, C.CustomerID, P.ProductID, OL.OrderedQuantity
   FROM Orders O, Customer C, Product P, OrderLine OL
   WHERE O.CustomerID = C.CustomerID AND P.ProductID = OL.ProductID AND O.OrderID = OL.OrderID
   GROUP BY O.OrderDate, C.CustomerID, P.ProductID, OL.OrderedQuantity;
   
--------------------------------------------------------------------------------------------------------------------------------
/* Insert values into customer table. */    
INSERT INTO Customer VALUES (1, 'Contemporary Casuals', '1355 S Hines Blvd', 'Gainesville', 'FL', '32601-2871','','','');
INSERT INTO Customer VALUES (2, 'Value Furnitures', '15145 S.W. 17th St.', 'Plano', 'TX', '75094-7734','','','');
INSERT INTO Customer VALUES (3, 'Home Furnishings', '1900 Allard Ave', 'Albany', 'NY', '12209-1125', 'homefurnishings?@gmail.com', 'CUSTOMER1', 'CUSTOMER1#');
INSERT INTO Customer VALUES (4, 'Eastern Furniture', '1925 Beltline Rd.', 'Carteret', 'NJ', '07008-3188','','','');
INSERT INTO Customer VALUES (5, 'Impressions', '5585 Westcott Ct.', 'Sacramento', 'CA', '94206-4056','','','');
INSERT INTO Customer VALUES (6, 'Furniture Gallery', '325 Flatiron Dr.', 'Boulder', 'CO', '80514-4432','','','');
INSERT INTO Customer VALUES (7, 'New Furniture', 'Palace Ave', 'Farmington', 'NM', '','','','');
INSERT INTO Customer VALUES (8, 'Dunkins Furniture', '7700 Main St', 'Syracuse', 'NY', '31590','','','');
INSERT INTO Customer VALUES (9, 'A Carpet', '434 Abe Dr', 'Rome', 'NY', '13440','','','');
INSERT INTO Customer VALUES (12, 'Flanigan Furniture', 'Snow Flake Rd', 'Ft Walton Beach', 'FL', '32548','','','');
INSERT INTO Customer VALUES (13, 'Ikards', '1011 S. Main St', 'Las Cruces', 'NM', '88001','','','');
INSERT INTO Customer VALUES (14, 'Wild Bills', 'Four Horse Rd', 'Oak Brook', 'Il', '60522','','','');
INSERT INTO Customer VALUES (15, 'Janet''s Collection', 'Janet Lane', 'Virginia Beach', 'VA', '10012','','','');
INSERT INTO Customer VALUES (16, 'ABC Furniture Co.', '152 Geramino Drive', 'Rome', 'NY', '13440','','','');

/* Insert values into Territory table. */
INSERT INTO Territory VALUES (1, 'SouthEast');
INSERT INTO Territory VALUES (2, 'SouthWest');
INSERT INTO Territory VALUES (3, 'NorthEast');
INSERT INTO Territory VALUES (4, 'NorthWest');
INSERT INTO Territory VALUES (5, 'Central');

/* Insert values into  ProductLine table. */
INSERT INTO ProductLine VALUES (1, 'Cherry Tree');
INSERT INTO ProductLine VALUES (2, 'Scandinavia');
INSERT INTO ProductLine VALUES (3, 'Country Look');

/* Insert values into SalesPerson table */
INSERT INTO SalesPerson VALUES (1, 'Doug Henny', '8134445555', 'salesperson?@gmail.com','SALESPERSON', 'SALESPERSON#',1);
INSERT INTO SalesPerson VALUES (2, 'Robert Lewis', '8139264006', '', '', '', 2);
INSERT INTO SalesPerson VALUES (3, 'William Strong', '5053821212', '', '', '', 3);
INSERT INTO SalesPerson VALUES (4, 'Julie Dawson', '4355346677', '', '', '', 4);
INSERT INTO SalesPerson VALUES (5, 'Jacob Winslow', '2238973498', '', '', '', 5);

/* Insert values into DoesBusinessIn table. */
INSERT INTO DoesBusinessIn VALUES (1, 1);
INSERT INTO DoesBusinessIn VALUES (2, 2);
INSERT INTO DoesBusinessIn VALUES (3, 3);
INSERT INTO DoesBusinessIn VALUES (4, 4);
INSERT INTO DoesBusinessIn VALUES (5, 5);
INSERT INTO DoesBusinessIn VALUES (6, 1);
INSERT INTO DoesBusinessIn VALUES (7, 2);

/* Insert values into Product table. */
INSERT INTO Product VALUES (1, 'End Table', 'Cherry', 175, 1, 'table.jpg');
INSERT INTO Product VALUES (2, 'Coffee Table', 'Natural Ash', 200, 2, '');
INSERT INTO Product VALUES (3, 'Computer Desk', 'Natural Ash', 375, 2, '');
INSERT INTO Product VALUES (4, 'Entertainment Center', 'Natural Maple', 650, 3, '');
INSERT INTO Product VALUES (5, 'Writers Desk', 'Cherry', 325, 1, '');
INSERT INTO Product VALUES (6, '8-Drawer Desk', 'White Ash', 750, 2, '');
INSERT INTO Product VALUES (7, 'Dining Table', 'Natural Ash', 800, 2, '');
INSERT INTO Product VALUES (8, 'Computer Desk', 'Walnut', 250, 3, '');


/* Insert values into Orders table. */
INSERT INTO Orders VALUES (1001, '21/Aug/16', 1);
INSERT INTO Orders VALUES (1002, '21/Jul/16', 8);
INSERT INTO Orders VALUES (1003, '22/ Aug/16', 15);
INSERT INTO Orders VALUES (1004, '22/Oct/16', 5);
INSERT INTO Orders VALUES (1005, '24/Jul/16', 3);
INSERT INTO Orders VALUES (1006, '24/Oct/16', 2);
INSERT INTO Orders VALUES (1007, '27/ Aug/16', 5);
INSERT INTO Orders VALUES (1008, '30/Oct/16', 12);
INSERT INTO Orders VALUES (1009, '05/Nov/16', 4);
INSERT INTO Orders VALUES (1010, '05/Nov/16', 1);

/* Insert values into OrderLine table. */
INSERT INTO OrderLine VALUES (1001, 1, 2, '');
INSERT INTO OrderLine VALUES (1001, 2, 2, '');
INSERT INTO OrderLine VALUES (1001, 4, 1, '');
INSERT INTO OrderLine VALUES (1002, 3, 5, '');
INSERT INTO OrderLine VALUES (1003, 3, 3, '');
INSERT INTO OrderLine VALUES (1004, 6, 2, '');
INSERT INTO OrderLine VALUES (1004, 8, 2, '');
INSERT INTO OrderLine VALUES (1005, 4, 4, '');
INSERT INTO OrderLine VALUES (1006, 4, 1, '');
INSERT INTO OrderLine VALUES (1006, 5, 2, '');
INSERT INTO OrderLine VALUES (1006, 7, 2, '');
INSERT INTO OrderLine VALUES (1007, 1, 3, '');
INSERT INTO OrderLine VALUES (1007, 2, 2, '');
INSERT INTO OrderLine VALUES (1008, 3, 3, '');
INSERT INTO OrderLine VALUES (1008, 8, 3, '');
INSERT INTO OrderLine VALUES (1009, 4, 2, '');
INSERT INTO OrderLine VALUES (1009, 7, 3, '');
INSERT INTO OrderLine VALUES (1010, 8, 10, '');

--------------------------------------------------------------------------

/* Which products have a standard price of less than $ 275? */
SELECT P.ProductName
FROM Product P
WHERE P.ProductStandardPrice < 275;
/*Query Results
    PRODUCTNAME
    -----------
 1   End Table
 2   Coffee Table
 3   Computer Desk                                              
*/
--------------------------------------------------------------------------

/* List the unit price, product name, and product ID for all products in the Product table. */
SELECT P.ProductStandardPrice AS "unit price", P.ProductName AS "product name", P.ProductID AS "product ID"
FROM Product P;
/* Query Results
unit Price | product name        | product ID
-----------|---------------------|------------
175        |  End Table	         |  1
200	       |  Coffee Table	     |  2
375  	   |  Computer Desk	     |  3
650	       | Entertainment Center|  4
325        |	 Writers Desk	 |  5
750        |	 8-Drawer Desk   |  6
800	       |  Dining Table	     |  7
250	       |  Computer Desk	     |  8
*/
--------------------------------------------------------------------------

/* What is the average standard price for all products in inventory? */
SELECT AVG(P.ProductStandardPrice)
FROM Product P;
/* Query Results: 
    AVG(P.PRODUCTSTANDARDPRICE)
    --------------------------
                      440.625                                          
*/
--------------------------------------------------------------------------

/* How many different items were ordered on order number 1004? */
SELECT COUNT(*)
FROM OrderLine OL
WHERE OL.OrderID = 1004;
/* Query Results: 
    COUNT(*)
    -------
          2                                                             
*/
--------------------------------------------------------------------------

/* Which orders have been placed since 10/ 24/ 2010? */
SELECT O.OrderID
FROM Orders O
WHERE O.OrderDate > '24/Oct/10';
/* Query Results: 
    ORDERID
    ------
    1001
    1002
    1003
    1004
    1005
    1006
    1007
    1008
    1009
    1010                                               
*/
--------------------------------------------------------------------------

/* What furniture does COSC3380 carry that isn’t made of cherry? */
SELECT P.ProductID
FROM Product P
WHERE P.ProductFinish != 'Cherry';
/* Query Results: 
   PRODUCTID
   ---------
   2
   3
   4
   6
   7
   8                                                                 
*/
--------------------------------------------------------------------------

/* List product name, finish, and standard price for all desks 
       and all tables that cost more than $ 300 in the Product table. 
 */ 
SELECT P.ProductName AS "product name", P.ProductFinish AS "finish", P.ProductStandardPrice AS "standard price"
FROM Product P
WHERE P.ProductStandardPrice > 300;
/*     Query Results: 
       and all tables that cost more than $ 300 in the Product table. 
       PRODUCT NAME        |   FINSIH    | STANDARD PRICE
       --------------------|-------------|----------------
       Computer Desk       |Natural Ash  |            375
       Entertainment Center|Natural Maple|            650
       Writers Desk        |Cherry       |            325
       8-Drawer Desk       |White Ash    |            750
       Dining Table        |Natural Ash  |            800           
*/ 
--------------------------------------------------------------------------

/* Which products in the Product table have a standard price between $ 200 and $ 300? */
SELECT P.ProductID
FROM Product P
WHERE P.ProductStandardPrice BETWEEN 200 AND 300;
/* Query Results:
    PRODUCTID
    --------
    2
    8
*/
--------------------------------------------------------------------------

/* List customer, city, and state for all customers in the Customer table
    whose address is Florida, Texas, California, or Hawaii. List the
    customers alphabetically by state and alphabetically by customer within each state.
 */
SELECT Cu.CustomerName AS "customer", Cu.CustomerCity AS "city", Cu.CustomerState AS "state"
FROM Customer Cu
WHERE Cu.CustomerState = 'FL' OR Cu.CustomerState = 'TX' OR Cu.CustomerState = 'CA' OR Cu.CustomerState = 'HI'
ORDER BY Cu.CustomerState;
/*  Query Results:
    whose address is Florida, Texas, California, or Hawaii. List the
    customers alphabetically by state and alphabetically by customer within each state.
          CUSTOMER      |     CITY      | STATE
    ---------------------------------------------
    Impressions         |Sacramento     |CA
    Contemporary Casuals|Gainesville    |FL
    Flanigan Furniture  |Ft Walton Beach|FL
    Value Furnitures    |Plano          |TX                                           
*/
--------------------------------------------------------------------------

/* Count the number of customers with addresses in each state to which we ship. */ 
SELECT C.CustomerState,COUNT(*)
FROM Customer C
GROUP BY C.CustomerState;
/*  Query Results:  
    CustomerState | COUNT(*)
    --------------|---------
    NJ	          |  1
    CA	          |  1
    NM	          |  2
    VA	          |  1
    Il	          |  1
    NY	          |  4
    CO	          |  1
    FL	          |  2
    TX	          |  1
*/
--------------------------------------------------------------------------
/* Count the number of customers with addresses in each city to which we ship. List the cities by state. */
SELECT C.CustomerState, C.CustomerCity, COUNT(*)
FROM Customer C
GROUP BY C.CustomerCity,C.CustomerState
ORDER BY C.CustomerState;
/* Query Results: 
    CustomerState | CustomerCity  | COUNT(*)
    --------------|-------------- |---------
    CA	          |Sacramento	  |   1
    CO            |Boulder	      |   1
    FL	          |Ft Walton Beach|	  1
    FL	          |Gainesville    |	  1
    Il	          |Oak Brook	  |   1
    NJ	          |Carteret	      |   1
    NM	          |Farmington     |	  1
    NM            |Las Cruces	  |   1
    NY	          |Albany	      |   1
    NY	          |Rome	          |   2
    NY	          |Syracuse       |	  1
    TX	          |Plano	      |   1
    VA	          |Virginia Beach |	  1                  
*/
--------------------------------------------------------------------------

/* Find only states with more than one customer. */
SELECT C.CustomerState
FROM Customer C
GROUP BY C.CustomerState
HAVING COUNT(*) > 1;
/* Query Results: 
    CustomerState
    -------------
    NM	              
    NY	              
    FL                
*/
--------------------------------------------------------------------------

/* List, in alphabetical order, the product finish and the average standard 
price for each finish for selected finishes having an average standard price less than 750.  */
SELECT P.ProductFinish, AVG(P.ProductStandardPrice)
FROM Product P
GROUP BY P.ProductFinish
HAVING AVG(P.ProductStandardPrice) < 750
ORDER BY P.ProductFinish;
/* Query Results: 
    ProductFinish | AVG(ProductStandardPrice)
    --------------|---------------------------
    Cherry	      |  250
    Natural Ash	  |  458.333333333333333333333333333333333333
    Natural Maple |	 650
    Walnut	      |  250
*/
--------------------------------------------------------------------------

/* What is the total value of orders placed for each furniture product? */
SELECT Ol.ProductID, SUM(Ol.OrderedQuantity * P.ProductStandardPrice)
FROM OrderLine Ol, Product P
WHERE Ol.ProductID = P.ProductID
GROUP BY Ol.ProductID;
/* Query Results: 
    ProductID | SUM(OrderedQuantity * ProductStandardPrice)
    ----------|-------------------------------------------------
    1	      |   875
    2	      |   800
    3	      |  4125
    4         |  5200
    5         |   650
    6	      |  1500
    7	      |  4000
    8	      |  3750                                                       
*/



