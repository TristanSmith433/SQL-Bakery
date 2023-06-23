/*******************************************************
Script: co859.sql/bakery 
Author: tristan smith
Date: September 7, 2021
,Tristan smith, student number 000825589, certify that this material is
my original work. No other person's work has been used without due acknowledgment and I have not made my work available to anyone else.
********************************************************/
-- Setting NOCOUNT ON suppresses completion messages for each INSERT


-- Set date format to year, month, day
SET DATEFORMAT ymd;

-- Make the master database the current database
USE master

-- If database co859 exists, drop it

-- If database co859 exists, drop it
IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'co859')
  DROP DATABASE co859;
GO
CREATE DATABASE  co859;
GO
use co859

-- Create the co859 database

-- Create Bakery  table
CREATE TABLE Bakery_items  (
	item_ID INT PRIMARY KEY, 
  Item_description VARCHAR(30), 
  Category CHAR(1) CHECK (Category IN ('P', 'D', 'M')), 
  Quantity_on_hand INT,
 Year_t0_date_sales MONEY); 

-- Create sales table
CREATE TABLE Bakery_Sales (
	sales_id INT PRIMARY KEY, 
	sales_Date DATE, 
	Sales_amount MONEY, 
	item_ID INT FOREIGN KEY REFERENCES Bakery_items(item_ID));


-- Insert  records
INSERT INTO Bakery_items VALUES(100, 'Cookie', 'P', 72, 450);
INSERT INTO Bakery_items VALUES(200, 'Coffee ', 'D', 34, 750);
INSERT INTO Bakery_items VALUES(300, 'Tea', 'D', 83, 360);
INSERT INTO Bakery_items VALUES(400, 'sandwitch ', 'M', 48, 870);
INSERT INTO Bakery_items VALUES(500, 'Puff pastry ', 'P', 14, 900);
INSERT INTO Bakery_items VALUES(600, 'Donut', 'P', 94, 300);
-- Insert sales records
INSERT INTO Bakery_Sales VALUES(1, '2021-08-10', 350, 200);
INSERT INTO Bakery_Sales VALUES(2, '2021-08-18', 100, 100);
INSERT INTO Bakery_Sales VALUES(3, '2021-08-18', 120, 400);
INSERT INTO Bakery_Sales VALUES(4, '2021-08-26', 305, 300);
INSERT INTO Bakery_Sales VALUES(5, '2021-08-28', 100, 400);
INSERT INTO Bakery_Sales VALUES(6, '2021-8-28', 120, 600);
INSERT INTO Bakery_Sales VALUES(7, '2021-9-2', 350, 200);
INSERT INTO Bakery_Sales VALUES(8, '2021-09-06', 120, 500);
INSERT INTO Bakery_Sales VALUES(9, '2021-09-07', 200, 300);
INSERT INTO Bakery_Sales VALUES(10, '2021-09-07', 250, 100);
INSERT INTO Bakery_Sales VALUES(11, '2021-09-09', 280, 200);
INSERT INTO Bakery_Sales VALUES(12, '2021-09-09', 125, 600);
INSERT INTO Bakery_Sales VALUES(13, '2021-9-10', 290, 400);
INSERT INTO Bakery_Sales VALUES(14, '2021-9-15', 300, 500);
INSERT INTO Bakery_Sales VALUES(15, '2021-9-17', 120, 300);
INSERT INTO Bakery_Sales VALUES(16, '2021-9-17', 175, 400);
INSERT INTO Bakery_Sales VALUES(17, '2021-9-19', 150, 100);
INSERT INTO Bakery_Sales VALUES(18, '2021-9-20', 75, 600);
GO
CREATE UNIQUE INDEX IX_items_item_description
ON Bakery_items (item_description);
GO


CREATE VIEW good_items
AS
SELECT item_id, SUBSTRING(item_description, 1,15) AS item_description, Year_t0_date_sales
FROM Bakery_items
WHERE Year_t0_date_sales >
(SELECT AVG(Year_t0_date_sales) FROM Bakery_items);
GO

-- Verify inserts
CREATE TABLE verify (
  table_name varchar(30), 
  actual INT, 
  expected INT);
GO

INSERT INTO verify VALUES('Bakery_Items ', (SELECT COUNT(*) FROM Bakery_items), 6);
INSERT INTO verify VALUES('Bakery_Sales', (SELECT COUNT(*) FROM Bakery_Sales), 18);
PRINT 'Verified';
SELECT table_name, actual, expected, expected - actual discrepancy FROM verify;
DROP TABLE verify;
GO
-- Verify inserts
CREATE TABLE verify (
  table_name varchar(30), 
  actual INT, 
  expected INT)
GO

PRINT 'Verification';
SELECT table_name, actual, expected, expected - actual discrepancy FROM verify;
DROP TABLE verify;
GO

/* I, Tristan Smith , student number 000825589,
certify that this material is my original work. No other person's work has been used 
without due acknowledgment and I have not made my work available to anyone else.
co859.sql Tristan Smith 2021-11-16 
Creating a Script to purge any records that are not active for the last 3 years  */
ALTER TABLE Bakery_Items ADD last_activity_date DATE NULL ;
GO
UPDATE Bakery_items 
SET 
last_activity_date = '2020-03-14'
WHERE item_ID = 100;
UPDATE Bakery_Items  
SET 
last_activity_date = '2020-11-14'
WHERE Item_id = 200;
UPDATE Bakery_Items 
SET 
last_activity_date = '2021-03-18'
WHERE Item_id = 300;
UPDATE Bakery_Items 
SET 
last_activity_date = '2021-08-28'
WHERE Item_id = 400;
UPDATE Bakery_Items 
SET 
last_activity_date = '2021-10-08'
WHERE Item_id = 500;
UPDATE Bakery_Items 
SET 
last_activity_date = '2021-11-21'
WHERE Item_id = 600;
go


-- Insert  records

INSERT INTO Bakery_items VALUES(700, 'Cronut', 'P', 94, 300,'1999-01-02');
select * from Bakery_items
go

create procedure Bakery_view
as begin
select * from Bakery_items
end 
go


create procedure Purge_Items   @cut_off_date DATE, @update INT = 0
AS begin


if @update = 1

	begin
	delete from Bakery_items where last_activity_date < @cut_off_date
	end

	
if @update != 1

	begin 
	print 'Record(s) that would be deleted'
	select * from Bakery_items where last_activity_date < @cut_off_date
	end 
	
end

go

-- Verification
PRINT 'Verify procedure'
PRINT 'Master Table Before Changes'
SELECT * from Bakery_items
/*SELECT DATEADD(YEAR,-3,GETDATE()) as DATEADD
*/
DECLARE @past_date AS DATE = DATEADD(yy, -3, getdate());

Execute Purge_Items @cut_off_date = @past_date

PRINT 'After 1st Call To Procedure'
SELECT * from Bakery_items
Execute Purge_Items @cut_off_date = @past_date , @update = 1

PRINT 'After 2nd Call To Procedure'
SELECT * from Bakery_items
GO

/* I, Tristan Smith , student number 000825589,
certify that this material is my original work. No other person's work has been used 
without due acknowledgment and I have not made my work available to anyone else.
co859.sql Tristan Smith 2021-11-23 
 create 3 triggers, one for INSERT, one for UPDATE and one for DELETE.  */

 

 
CREATE TRIGGER sales_insert
    ON Bakery_Sales
    AFTER INSERT,UPDATE,DELETE 
AS
DECLARE @Year_t0_date_sales MONEY;

BEGIN
	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 100 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 100;

	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 200 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 200;

	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 300 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 300;

	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 400 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 400;

	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 500 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 500;

	SET @Year_t0_date_sales = (SELECT SUM(Sales_amount)FROM Bakery_Sales WHERE item_ID = 600 )
	UPDATE Bakery_items
    SET 
    Year_t0_date_sales = @Year_t0_date_sales
    WHERE item_ID = 600;

END
GO



go

 Select * from Bakery_items 
INSERT INTO Bakery_Sales VALUES(19, '2021-10-30', 100, 600);
 PRINT 'After 2nd Call To Procedure'
 SELECT * from Bakery_items 


 -- Verification
PRINT 'Verify triggers'
PRINT 'Master Table Before Changes'
 Select * from Bakery_items 

INSERT INTO Bakery_Sales VALUES(20, '2021-10-30', 100, 600);
 PRINT 'After insert '
 SELECT * from Bakery_items
 GO

DELETE From Bakery_Sales where sales_id = 20;
PRINT 'After DELETE'
SELECT * from Bakery_items 
GO

UPDATE Bakery_Sales set Sales_amount = 1000 where sales_id = 19;
PRINT 'After UPDATE'
SELECT * from Bakery_items 
GO