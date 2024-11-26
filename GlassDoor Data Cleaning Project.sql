--Creating database for project
CREATE DATABASE GlassDoor

--General data overview for distinct values and for future reference
Select DISTINCT index_ FROM Door_Data
Select DISTINCT Job_Title FROM Door_Data
Select DISTINCT Job_Description FROM Door_Data
Select DISTINCT Rating FROM Door_Data
Select DISTINCT Company_Name FROM Door_Data
Select DISTINCT Location FROM Door_Data
Select DISTINCT Headquarters FROM Door_Data
Select DISTINCT Size FROM Door_Data
Select DISTINCT Founded FROM Door_Data
Select DISTINCT Type_of_Ownership FROM Door_Data
Select DISTINCT Industry FROM Door_Data
Select DISTINCT Sector FROM Door_Data
Select DISTINCT Revenue FROM Door_Data
Select DISTINCT Competitors FROM Door_Data
--Converting -1 data points to Null
UPDATE Door_Data
SET Competitors = NULL 
WHERE competitors = -1

UPDATE Door_Data
SET Revenue = NULL 
WHERE Revenue = '-1'

UPDATE Door_Data
SET Sector = NULL 
WHERE Sector = '-1'

UPDATE Door_Data
SET Industry = NULL 
WHERE Industry = '-1'

UPDATE Door_Data
SET Type_of_Ownership = NULL 
WHERE Type_of_Ownership = '-1'

UPDATE Door_Data
SET Type_of_Ownership = NULL 
WHERE Type_of_Ownership = '-1'

UPDATE Door_Data
SET Founded = NULL 
WHERE Founded = '-1'

UPDATE Door_Data
SET Size = NULL 
WHERE Size = '-1'

UPDATE Door_Data
SET Headquarters = NULL 
WHERE Headquarters = '-1'

UPDATE Door_Data
SET Rating = NULL 
WHERE Rating = '-1'

--Standardizing and cleaning Job title column 
Select DISTINCT Job_Title FROM Door_Data

--Making everything uppercase to account for Non Uniform Capitalization
UPDATE Door_Data
SET Job_Title = UPPER(Job_Title)

--Replacing abbreviations to make the titles more uniform
UPDATE Door_Data
SET Job_Title = REPLACE(Job_Title, 'SR.', 'SENIOR')

UPDATE Door_Data
SET Job_Title = REPLACE(Job_Title, 'SR', 'SENIOR')

UPDATE Door_Data
SET Job_Title = REPLACE(Job_Title, '(SENIOR)','SENIOR')

UPDATE Door_Data
SET Job_Title = REPLACE(Job_Title, 'JR.','JUNIOR')

UPDATE Door_Data
SET Job_Title = REPLACE(Job_Title, 'VP,','VICE PRESIDENT')


--Generalizing Job Titles to make the column more data friendly

--Removing Unnessary specificity to jobs_titles 
SELECT Job_Title, count(job_title) as total
FROM Door_Data
GROUP BY Job_Title

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('DATA SCIENTIST', Job_Title) + LEN('DATA SCIENTIST') - 1)
WHERE Job_Title LIKE 'DATA SCIENTIST%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('SENIOR DATA SCIENTIST', Job_Title) + LEN('SENIOR DATA SCIENTIST') - 1)
WHERE Job_Title LIKE 'SENIOR DATA SCIENTIST%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('DATA ANALYST', Job_Title) + LEN('DATA ANALYST') - 1)
WHERE Job_Title LIKE 'DATA ANALYST%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('SENIOR DATA ANALYST', Job_Title) + LEN('SENIOR DATA ANALYST') - 1)
WHERE Job_Title LIKE 'SENIOR DATA ANALYST%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('SENIOR DATA ANALYST', Job_Title) + LEN('SENIOR DATA ANALYST') - 1)
WHERE Job_Title LIKE 'SENIOR DATA ANALYST%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('DATA ENGINEER', Job_Title) + LEN('DATA ENGINEER') - 1)
WHERE Job_Title LIKE 'DATA ENGINEER%';

UPDATE Door_Data
SET Job_Title = LEFT(Job_Title, CHARINDEX('COMPUTER SCIENTIST', Job_Title) + LEN('COMPUTER SCIENTIST') - 1)
WHERE Job_Title LIKE 'COMPUTER SCIENTIST%';

-- Deleting data that does not belong in this dataset (non-tech jobs)

DELETE FROM Door_Data
WHERE Job_Title NOT LIKE '%DATA%'
  AND Job_Title NOT LIKE '%ENGINEER%'
  AND Job_Title NOT LIKE '%SOFTWARE%'
  AND Job_Title NOT LIKE '%AI%'
  AND Job_Title NOT LIKE '%MACHINE%'
  AND Job_Title NOT LIKE '%ANALYST%'
  AND Job_Title NOT LIKE '%COMPUTER%'
  AND Job_Title NOT LIKE '%COMPUTATIONAL%';


-- Again removing specificity from job_titles, but more efficiently (probably should have done this first)
UPDATE Door_Data
SET Job_Title = 
    CASE 
        WHEN Job_Title LIKE '%DATA SCIENTIST%' 
             AND Job_Title NOT LIKE '%JUNIOR%' 
             AND Job_Title NOT LIKE '%SENIOR%' 
        THEN 'DATA SCIENTIST'
        ELSE Job_Title
    END
WHERE Job_Title LIKE '%DATA SCIENTIST%'

UPDATE Door_Data
SET Job_Title = 
    CASE 
        WHEN Job_Title LIKE '%DATA ANALYST%' 
             AND Job_Title NOT LIKE '%JUNIOR%' 
             AND Job_Title NOT LIKE '%SENIOR%' 
        THEN 'DATA ANALYST'
        ELSE Job_Title
    END
WHERE Job_Title LIKE '%DATA ANALYST%'

UPDATE Door_Data
SET Job_Title = 
    CASE 
        WHEN Job_Title LIKE '%MACHINE LEARNING SCIENTIST%' 
             AND Job_Title NOT LIKE '%JUNIOR%' 
             AND Job_Title NOT LIKE '%SENIOR%' 
        THEN 'DATA ANALYST'
        ELSE Job_Title
    END
WHERE Job_Title LIKE '%MACHINE LEARNING SCIENTIST%'

UPDATE Door_Data
SET Job_Title = 
    CASE 
        WHEN Job_Title LIKE '%MACHINE LEARNING ENGINEER%' 
             AND Job_Title NOT LIKE '%JUNIOR%' 
             AND Job_Title NOT LIKE '%SENIOR%' 
        THEN 'DATA ANALYST'
        ELSE Job_Title
    END
WHERE Job_Title LIKE '%MACHINE LEARNING ENGINEER%'

--Gonna move on from this portion for now, if I decide to provide Analysis then I will most likely just use 
--The 4-5 largest groups

SELECT DISTINCT Salary_Estimate FROM Door_Data
 
 -- Plan is to create a minimum and maximum column for the Salary_Estimate
 --Then remove the Salary_Estimate COLUMN

 --Remove 'K' characters from column to later change data type to INTEGER
 UPDATE Door_Data
 Set Salary_Estimate = REPLACE(Salary_Estimate, 'K','')
 --Remove employer estimate 
  UPDATE Door_Data
 Set Salary_Estimate = REPLACE(Salary_Estimate, '(Employer est.)','')

 --Create new columns for minimum and maximum salaries 
 ALTER TABLE Door_Data
 ADD COLUMN Maximum_Salary INT,
 Minumum_Salary INT


 --Seperating Data at the Hyphen and placing them into respective columns
UPDATE Door_Data
SET Minimum_Salary = LEFT(Salary_Estimate, CHARINDEX('-', Salary_Estimate) - 1),
    Maximum_Salary = LTRIM(SUBSTRING(Salary_Estimate, CHARINDEX('-', Salary_Estimate) + 1, LEN(Salary_Estimate)))

SELECT DISTINCT Maximum_Salary, Minimum_Salary 
FROM Door_Data

--Multipy data by 1000 to get actual value
UPDATE Door_Data
SET Minimum_Salary = Minimum_Salary * 1000

UPDATE Door_Data
SET Maximum_Salary = Maximum_Salary * 1000

--Remove unnessary column
ALTER TABLE Door_Data
DROP COLUMN Salary_Estimate

--The rating column seems to be inserted into the company names
--Removing last 3 characters if the third from last number begins with a number
Select DISTINCT Company_Name FROM Door_Data

UPDATE Door_Data
SET Company_Name = LEFT(Company_Name, LEN(Company_Name) - 3)
WHERE PATINDEX('%[0-9]%', SUBSTRING(Company_Name, LEN(Company_Name) - 2, 1)) > 0;

--Checking location 
SELECT DISTINCT State State FROM Door_Data

--I'm seperating the state and city into different columns 
ALTER TABLE Door_Data
ADD City NVARCHAR(255),
State NVARCHAR(255)

UPDATE Door_Data
SET City = LEFT(Location, CHARINDEX(',', Location) - 1),
    State = LTRIM(RIGHT(Location, LEN(Location) - CHARINDEX(',', Location)))
WHERE CHARINDEX(',', Location) > 0;

-- There was a straggler after the update
UPDATE Door_Data
SET State = 'MD',
	City = 'Anne Arundel'
WHERE State = 'Anne Arundel, MD'


--Checking on Headquarters column
SELECT Distinct Headquarters 
FROM Door_Data

--Literally going to be the exact same thing done as with Location
ALTER TABLE Door_Data
ADD City_HQ NVARCHAR(255),
State_HQ NVARCHAR(255)

UPDATE Door_Data
SET City_HQ = LEFT(Headquarters, CHARINDEX(',', Headquarters) - 1),
    State_HQ = LTRIM(RIGHT(Headquarters, LEN(Headquarters) - CHARINDEX(',', Headquarters)))
WHERE CHARINDEX(',', Headquarters) > 0;

--Checking on Size column 
SELECT Distinct Size 
FROM Door_Data

--Very similar to the Salary_range column except 'to' is the delimiter

--Gonna manually change one distinct value first to make the column more uniform
UPDATE Door_Data
SET Size = '10000 to 11000 employees'
Where Size = '10000+ employees'

--And change 'unknown' values to NULL
UPDATE Door_Data
SET Size = NULL
Where Size = 'Unknown'

-- Now I remove the 'employees' so I can make the new column INT data types
UPDATE Door_Data
SET Size = REPLACE(Size, 'employees', '')
--Now I make the new columns 
ALTER TABLE Door_Data
ADD Minimum_Employees INT,
Maximum_Employees INT
-- Splitting the data into different columns
UPDATE Door_Data
SET Minimum_Employees = LEFT(Size, CHARINDEX('to', Size) - 1),
    Maximum_Employees = LTRIM(SUBSTRING(Size, CHARINDEX('to', Size) + 2, LEN(Size)))
WHERE CHARINDEX('to', Size) > 0;

select Distinct Minimum_Employees FROM Door_Data
--Dropping unecessary column
ALTER TABLE  Door_Data
DROP COLUMN Size

-- Checking Founded Column
SELECT DISTINCT Founded From Door_Data
--All good
--Checking Type_of_ownership Column
SELECT DISTINCT type_of_ownership FROM Door_Data
--Mostly good, but need to change 'unknown values to Null'
UPDATE Door_Data
SET Type_of_ownership = NULL
Where Type_of_ownership = 'Unknown'

--Checking Sector Column
SELECT DISTINCT Sector FROM Door_Data
--Nothing wrong with it

--Checking Revenue Column
SELECT DISTINCT Revenue FROM Door_Data
--Gonna be very similar to the salary_estimate process
--Removing the 'Unknown' values first
UPDATE Door_Data
SET Revenue = NULL
Where Revenue = 'Unknown / Non-Applicable'
--Now removing (USD)
UPDATE Door_Data
SET Revenue = REPLACE(Revenue, '(USD)','')
--Just Gonna manually change a couple things to make everything uniform
UPDATE Door_Data
SET Revenue = REPLACE(Revenue, '10-11 billion', '10 to 11 billion')
WHERE Revenue = '10-11 billion'


UPDATE Door_Data
SET Revenue = REPLACE(Revenue, 'Less than 1 million ', '0 to 1 million')
WHERE Revenue = 'Less than 1 million '

-- Now I will add the needed zeros to each of the values
UPDATE Door_Data 
SET Revenue = REPLACE(REPLACE(Revenue, ' million', '000000'), ' billion', '000000000')
WHERE Revenue like '%million%' or Revenue  like '%billion%'

--Now I can make minimum and maximum columns using the same query from the Size column
ALTER TABLE Door_Data
ADD Minimum_Revenue BIGINT,
	Maximum_Revenue BIGINT

UPDATE Door_Data
SET Minimum_Revenue = LEFT(Revenue, CHARINDEX('to', Revenue) - 1),
    Maximum_Revenue = LTRIM(SUBSTRING(Revenue, CHARINDEX('to', Revenue) + 2, LEN(Revenue)))
WHERE CHARINDEX('to', Revenue) > 0;

--Checking to see if everything worked
Select DISTINCT Minimum_Revenue, Maximum_Revenue FROM Door_Data
-- Now i have to mulitply the minimum values to correspond with the actual intended values
UPDATE Door_Data
SET Minimum_Revenue = Minimum_Revenue *1000000
WHERE Maximum_revenue < 1000000000

UPDATE Door_Data
SET Minimum_Revenue = Minimum_Revenue *1000000000
WHERE Maximum_revenue > 1000000000
--Confirmed everything was done right and now deleting unneeded column
ALTER TABLE Door_Data
DROP COLUMN Revenue

--Checking Competitors Column 
Select Distinct Competitors From Door_Data
--Nothing wrong there

--Couldn't find relevant data in Job_Description Column, so I am
--Dropping it for readability 
ALTER TABLE Door_Data
DROP COLUMN Job_Description
