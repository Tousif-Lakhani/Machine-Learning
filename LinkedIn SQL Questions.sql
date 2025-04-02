create database LinkedIn_Questions;
use LinkedIn_Questions;

SELECT * FROM airbnb_apartments;
SELECT * FROM airbnb_hosts;

/* 
Question-1 - Meta/Facebook - https://lnkd.in/gWZ_WD8m
A table named “famous” has two columns called user id and follower id. It represents each user ID has a particular follower ID. 
These follower IDs are also users of hashtag#Facebook / hashtag#Meta. Then, find the famous percentage of each user. 
Famous Percentage = number of followers a user has / total number of users on the platform. 
*/

CREATE TABLE famous (user_id INT, follower_id INT);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);



WITH 
distinct_users AS 
(
	SELECT user_id, COUNT(follower_id) AS Total_Followers FROM famous
	GROUP BY user_id
),
follower_count AS 
(    
	SELECT user_id AS combined_id
	FROM famous
	UNION
	SELECT follower_id
	FROM famous
)
SELECT 
	user_id,
    (Total_Followers / (SELECT COUNT(DISTINCT(combined_id)) AS Total_Users FROM follower_count)) * 100 AS Famous_Percentage
FROM distinct_users
GROUP BY user_id;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question-2 - Amazon - https://lnkd.in/gW63hRvU
Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year. 
The percentage change column will be populated from the 2nd month forward and calculated as ((this month’s revenue — last month’s revenue) / last month’s revenue)*100. 
*/

CREATE TABLE sf_transactions(id INT, created_at datetime, value INT, purchase_id INT);

INSERT INTO sf_transactions VALUES
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),
(4, '2019-01-13 00:00:00',  164911, 30),(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),
(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),(9, '2019-02-02 00:00:00',  140032, 25), 
(10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), 
(13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), 
(16, '2019-03-02 00:00:00', 157548, 19), (17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), 
(19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), (21, '2019-03-22 00:00:00', 151688, 47), 
(22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);


WITH monthly_revenue AS 
(
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS Year_Months,
    SUM(value) AS Total_Revenue
FROM 
    sf_transactions
GROUP BY 
    DATE_FORMAT(created_at, '%Y-%m')
)

SELECT 
	Year_Months,
    Total_Revenue,
    LAG(Total_Revenue) OVER (ORDER BY Year_Months) AS Previous_Month_Revenue,
    ROUND((((Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Year_Months)) / LAG(Total_Revenue) OVER (ORDER BY Year_Months)) * 100),2) AS 'month-over-month percentage change'
FROM monthly_revenue;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question-3 - Google - https://lnkd.in/gmHfrmWE
You are analyzing a social network dataset at Google. 
Your task is to find mutual friends between two users, Karl and Hans. 
There is only one user named Karl and one named Hans in the dataset.
The output should contain 'user_id' and 'user_name' columns. 
*/

CREATE TABLE users(user_id INT, user_name varchar(30));
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE friends(user_id INT, friend_id INT);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);



with karl_friends as (
with cte as (
SELECT friend_id FROM friends WHERE 
user_id = (SELECT user_id FROM users WHERE user_name = "Karl")
)
select c.friend_id, u.user_name from cte as c
join users as u
on c.friend_id = u.user_id)
,

Hans_friends as (
with cte2 as (
SELECT friend_id FROM friends WHERE 
user_id = (SELECT user_id FROM users WHERE user_name = "Hans")
)
select c2.friend_id, u.user_name from cte2 as c2
join users as u
on c2.friend_id = u.user_id)

SELECT K.friend_id AS user_id, K.user_name FROM Karl_friends AS K
INNER JOIN Hans_friends AS H
ON K.friend_id = H.friend_id;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 4 - Uber - https://lnkd.in/g6h5Nj5Q
Some forecasting methods are extremely simple and surprisingly effective. Naïve forecast is one of them. 
To create a naïve forecast for "distance per dollar" (defined as distance_to_travel/monetary_cost), first sum the "distance to travel" and "monetary cost" values monthly. 
This gives the actual value for the current month. For the forecasted value, use the previous month's value. 
After obtaining both actual and forecasted values, calculate the root mean squared error (RMSE) using the formula RMSE = sqrt(mean(square(actual - forecast))). 
Report the RMSE rounded to two decimal places. 
*/

CREATE TABLE uber_request_logs(request_id int, request_date datetime, request_status varchar(10), distance_to_travel float, monetary_cost float, driver_to_client_distance float);

INSERT INTO uber_request_logs VALUES 
(1,'2020-01-09','success', 70.59, 6.56,14.36), (2,'2020-01-24','success', 93.36, 22.68,19.9), 
(3,'2020-02-08','fail', 51.24, 11.39,21.32), (4,'2020-02-23','success', 61.58,8.04,44.26), 
(5,'2020-03-09','success', 25.04,7.19,1.74), (6,'2020-03-24','fail', 45.57, 4.68,24.19), 
(7,'2020-04-08','success', 24.45,12.69,15.91), (8,'2020-04-23','success', 48.22,11.2,48.82), 
(9,'2020-05-08','success', 56.63,4.04,16.08), (10,'2020-05-23','fail', 19.03,16.65,11.22), 
(11,'2020-06-07','fail', 81,6.56,26.6), (12,'2020-06-22','fail', 21.32,8.86,28.57), 
(13,'2020-07-07','fail', 14.74,17.76,19.33), (14,'2020-07-22','success',66.73,13.68,14.07), 
(15,'2020-08-06','success',32.98,16.17,25.34), (16,'2020-08-21','success',46.49,1.84,41.9), 
(17,'2020-09-05','fail', 45.98,12.2,2.46), (18,'2020-09-20','success',3.14,24.8,36.6), 
(19,'2020-10-05','success',75.33,23.04,29.99), (20,'2020-10-20','success', 53.76,22.94,18.74);

WITH RMSE AS (
WITH cte AS (
SELECT 
    DATE_FORMAT(request_date, '%Y-%m') AS Year_Months,
    Round((SUM(distance_to_travel)),2) AS Total_distance_to_travel,
    Round((SUM(monetary_cost)),2) AS Total_monetary_cost,
    Round((SUM(driver_to_client_distance)),2) AS Total_driver_to_client_distance,
    Round((SUM(distance_to_travel) / SUM(monetary_cost)),2) AS Actual_distance_Per_Dollar
FROM 
    uber_request_logs
GROUP BY 
    DATE_FORMAT(request_date, '%Y-%m'))

SELECT 
	*,  
    LAG(Actual_distance_Per_Dollar) Over(ORDER BY Year_Months) AS Forecasted_distance_Per_Dollar
FROM cte)

SELECT ROUND(sqrt(avg(POWER((Actual_distance_Per_Dollar-Forecasted_distance_Per_Dollar),2))),2) AS Root_Mean_Squared_Error FROM RMSE;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 5 - Microsoft - https://lnkd.in/gXPMAD48
Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee. 
The output should include the project title and the project budget rounded to the closest integer. 
Order your list by projects with the highest budget per employee first. 
*/

CREATE TABLE ms_projects(id int, title varchar(15), budget int);
INSERT INTO ms_projects VALUES 
(1, 'Project1',  29498),(2, 'Project2',  32487),(3, 'Project3',  43909),(4, 'Project4',  15776),
(5, 'Project5',  36268),(6, 'Project6',  41611),(7, 'Project7',  34003),(8, 'Project8',  49284),
(9, 'Project9',  32341),(10, 'Project10',    47587),(11, 'Project11',    11705),(12, 'Project12', 10468),
(13, 'Project13',    43238),(14, 'Project14',    30014),(15, 'Project15',    48116),(16, 'Project16',19922),
(17, 'Project17',    19061),(18, 'Project18',    10302),(19, 'Project19',    44986),(20, 'Project20',19497);

CREATE TABLE ms_emp_projects(emp_id int, project_id int);
INSERT INTO ms_emp_projects VALUES 
(10592,  1),(10593,  2),(10594,  3),(10595,  4),(10596,  5),(10597,  6),(10598,  7),
(10599,  8),(10600,  9),(10601,  10),(10602, 11),(10603, 12),(10604, 13),(10605, 14),
(10606, 15),(10607, 16),(10608, 17),(10609, 18),(10610, 19),(10611, 20);


SELECT title, budget FROM ms_projects
ORDER BY budget DESC;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 6 - AirBnb - https://lnkd.in/gep8Td4w
Find the total number of available beds per hosts' nationality.
Output the nationality along with the corresponding total number of available beds. 
Sort records by the total available beds in descending order.
. 
*/

CREATE TABLE airbnb_apartments(host_id int,apartment_id varchar(5),apartment_type varchar(10),n_beds int,n_bedrooms int,country varchar(20),city varchar(20));
INSERT INTO airbnb_apartments VALUES
(0,'A1','Room',1,1,'USA','NewYork'),(0,'A2','Room',1,1,'USA','NewJersey'),(0,'A3','Room',1,1,'USA','NewJersey'),
(1,'A4','Apartment',2,1,'USA','Houston'),(1,'A5','Apartment',2,1,'USA','LasVegas'),(3,'A7','Penthouse',3,3,'China','Tianjin'),
(3,'A8','Penthouse',5,5,'China','Beijing'),(4,'A9','Apartment',2,1,'Mali','Bamako'),(5,'A10','Room',3,1,'Mali','Segou');

CREATE TABLE airbnb_hosts(host_id int,nationality  varchar(15),gender varchar(5),age int);
INSERT INTO airbnb_hosts  VALUES(0,'USA','M',28),(1,'USA','F',29),(2,'China','F',31),(3,'China','M',24),(4,'Mali','M',30),(5,'Mali','F',30);

SELECT 
	country AS Nationality,
    SUM(n_beds) AS Total_Available_Beds
FROM 
	airbnb_apartments
GROUP BY
	country
ORDER BY 
	Total_Available_Beds DESC;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 7 - IBM - https://lnkd.in/gqx8mFNs
IBM is working on a new feature to analyze user purchasing behavior for all Fridays in the first quarter of the year. 
For each Friday separately, calculate the average amount users have spent per order. 
The output should contain the week number of that Friday and average amount spent. 
*/

CREATE TABLE user_purchases(user_id int, date date, amount_spent float, day_name varchar(15));

INSERT INTO user_purchases VALUES
(1047,'2023-01-01',288,'Sunday'),(1099,'2023-01-04',803,'Wednesday'),(1055,'2023-01-07',546,'Saturday'),
(1040,'2023-01-10',680,'Tuesday'),(1052,'2023-01-13',889,'Friday'),(1052,'2023-01-13',596,'Friday'),
(1016,'2023-01-16',960,'Monday'),(1023,'2023-01-17',861,'Tuesday'),(1010,'2023-01-19',758,'Thursday'),
(1013,'2023-01-19',346,'Thursday'),(1069,'2023-01-21',541,'Saturday'),(1030,'2023-01-22',175,'Sunday'),
(1034,'2023-01-23',707,'Monday'),(1019,'2023-01-25',253,'Wednesday'),(1052,'2023-01-25',868,'Wednesday'),
(1095,'2023-01-27',424,'Friday'),(1017,'2023-01-28',755,'Saturday'),(1010,'2023-01-29',615,'Sunday'),
(1063,'2023-01-31',534,'Tuesday'),(1019,'2023-02-03',185,'Friday'),(1019,'2023-02-03',995,'Friday'),
(1092,'2023-02-06',796,'Monday'),(1058,'2023-02-09',384,'Thursday'),(1055,'2023-02-12',319,'Sunday'),
(1090,'2023-02-15',168,'Wednesday'),(1090,'2023-02-18',146,'Saturday'),(1062,'2023-02-21',193,'Tuesday'),
(1023,'2023-02-24',259,'Friday');


SELECT 
WEEK(date) AS Week_Number,
AVG(amount_spent) AS Average_Amount_Spent
FROM user_purchases
WHERE day_name = 'Friday'
GROUP BY Week_Number;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 8 - Tesla - https://lnkd.in/gJwdGBtN
You are given a table of product launches by company by year. 
Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year. 
Output the name of the companies and a net difference of net products released for 2020 compared to the previous year. 
*/

CREATE TABLE car_launches(year int, company_name varchar(15), product_name varchar(30));

INSERT INTO car_launches VALUES
(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),
(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),
(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),
(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),(2020,'Jeep','Wrangler');


WITH cte3 AS (
WITH cte2 AS (
WITH cte AS (
select 
	year,
    company_name,
	COUNT(product_name) OVER(PARTITION BY company_name, year ORDER BY year) AS No_of_products_launched,
    ROW_NUMBER() OVER(PARTITION BY company_name, year ORDER BY year) AS Row_No
from car_launches )

SELECT  *
FROM cte 
WHERE Row_No = 1)
SELECT *, LAG(No_of_products_launched) Over(PARTITION BY company_name ORDER BY year) AS Previous_months_no_of_products_launched FROM cte2)

SELECT 
	company_name,
    (No_of_products_launched - Previous_months_no_of_products_launched) AS net_difference_of_net_products
FROM 
	cte3
WHERE
	year = 2020;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 9 - Netflix - https://lnkd.in/guCXi8k9
Find the genre of the person with the most number of oscar winnings.
If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. 
Use the names as keys when joining the tables.. 
*/


CREATE TABLE nominee_information(name varchar(20), amg_person_id varchar(10), top_genre varchar(10), birthday datetime, id int);

INSERT INTO nominee_information VALUES
('Jennifer Lawrence','P562566','Drama','1990-08-15',755),('Jonah Hill','P418718','Comedy','1983-12-20',747),
('Anne Hathaway', 'P292630','Drama', '1982-11-12',744),('Jennifer Hudson','P454405','Drama', '1981-09-12',742),
('Rinko Kikuchi', 'P475244','Drama', '1981-01-06', 739);

CREATE TABLE oscar_nominees(year int, category varchar(30), nominee varchar(20), movie varchar(30), winner int, id int);

INSERT INTO oscar_nominees VALUES
(2008,'actress in a leading role','Anne Hathaway','Rachel Getting Married',0,77),
(2012,'actress in a supporting role','Anne Hathaway','Mis_rables',1,78),
(2006,'actress in a supporting role','Jennifer Hudson','Dreamgirls',1,711),
(2010,'actress in a leading role','Jennifer Lawrence','Winters Bone',1,717),
(2012,'actress in a leading role','Jennifer Lawrence','Silver Linings Playbook',1,718),
(2011,'actor in a supporting role','Jonah Hill','Moneyball',0,799),
(2006,'actress in a supporting role','Rinko Kikuchi','Babel',0,1253);

with cte as (
SELECT N.name, N.top_genre, O.winner, COUNT(winner) OVER(PARTITION BY name) AS Win_Count FROM
nominee_information AS N
INNER JOIN
oscar_nominees AS O
ON N.name = O.nominee
WHERE winner = 1)

SELECT top_genre FROM cte
WHERE Win_Count = 2 LIMIT 1;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 10 - Amazon - https://lnkd.in/gs-3sX6V
Write a query that'll identify returning active users. 
A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. 
Output a list of user_ids of these returning active users. 
*/

CREATE TABLE amazon_transactions(id int, user_id int, item varchar(15), created_at datetime, revenue int);

INSERT INTO amazon_transactions VALUES 
(1,109,'milk','2020-03-03 00:00:00',123),(2,139,'biscuit','2020-03-18 00:00:00', 421), (3,120,'milk','2020-03-18 00:00:00',176), 
(4,108,'banana','2020-03-18 00:00:00',862), (5,130,'milk','2020-03-28 00:00:00',333), (6,103,'bread','2020-03-29 00:00:00',862), 
(7,122,'banana','2020-03-07 00:00:00',952), (8,125,'bread','2020-03-13 00:00:00',317), (9,139,'bread','2020-03-30 00:00:00',929), 
(10,141,'banana','2020-03-17 00:00:00',812), (11,116,'bread','2020-03-31 00:00:00',226), (12,128,'bread','2020-03-04 00:00:00',112), 
(13,146,'biscuit','2020-03-04 00:00:00',362), (14,119,'banana','2020-03-28 00:00:00',127), (15,142,'bread','2020-03-09 00:00:00',503), 
(16,122,'bread','2020-03-06 00:00:00',593), (17,128,'biscuit','2020-03-24 00:00:00',160), (18,112,'banana','2020-03-24 00:00:00',262), 
(19,149,'banana','2020-03-29 00:00:00',382), (20,100,'banana','2020-03-18 00:00:00',599);


with cte as (
SELECT*,
DAY(created_at) AS Days ,
COUNT(user_id) OVER(PARTITION BY user_id) AS count_id,
LAG(DAY(created_at)) Over(PARTITION BY user_id ORDER BY DAY(created_at)) AS Previous_purchase_date
FROM
amazon_transactions
ORDER BY created_at ASC)

SELECT user_id
FROM cte
WHERE count_id > 1 AND ((Days - Previous_purchase_date) < 7)
ORDER BY user_id;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 11 - Nvidia - https://lnkd.in/gGPkEV35
Find the number of transactions that occurred for each product. 
Output the product name along with the corresponding number of transactions and order records by the product id in ascending order. 
You can ignore products without transactions. 
*/

CREATE TABLE excel_sql_inventory_data (product_id INT,product_name VARCHAR(50),product_type VARCHAR(50),unit VARCHAR(20),price_unit FLOAT,wholesale FLOAT,current_inventory INT);

INSERT INTO excel_sql_inventory_data (product_id, product_name, product_type, unit, price_unit, wholesale, current_inventory) 
VALUES
(1, 'strawberry', 'produce', 'lb', 3.28, 1.77, 13),(2, 'apple_fuji', 'produce', 'lb', 1.44, 0.43, 2),(3, 'orange', 'produce', 'lb', 1.02, 0.37, 2),
(4, 'clementines', 'produce', 'lb', 1.19, 0.44, 44),(5, 'blood_orange', 'produce', 'lb', 3.86, 1.66, 19);

CREATE TABLE excel_sql_transaction_data (transaction_id INT PRIMARY KEY,time DATETIME,product_id INT);

INSERT INTO excel_sql_transaction_data (transaction_id, time, product_id) 
VALUES
(153, '2016-01-06 08:57:52', 1),(91, '2016-01-07 12:17:27', 1),(31, '2016-01-05 13:19:25', 1),
(24, '2016-01-03 10:47:44', 3),(4, '2016-01-06 17:57:42', 3),(163, '2016-01-03 10:11:22', 3),
(92, '2016-01-08 12:03:20', 2),(32, '2016-01-04 19:37:14', 4),(253, '2016-01-06 14:15:20', 5),
(118, '2016-01-06 14:27:33', 5);

with cte as (
SELECT 
	I.product_name, 
    T.transaction_id, 
    T.product_id ,
    COUNT(T.transaction_id) OVER(PARTITION BY I.product_name) AS count_id
FROM
	excel_sql_transaction_data AS T 
INNER JOIN
	excel_sql_inventory_data AS I
ON
T.product_id = I.product_id)

select DISTINCT(product_name), count_id from cte;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 12 - LinkedIn - https://lnkd.in/g9tZsSmJ
Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. 
Output just the absolute difference in salaries. 
*/

CREATE TABLE db_employee (id INT,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,department_id INT);

INSERT INTO db_employee (id, first_name, last_name, salary, department_id) VALUES
(10306, 'Ashley', 'Li', 28516, 4),(10307, 'Joseph', 'Solomon', 19945, 1),(10311, 'Melissa', 'Holmes', 33575, 1),
(10316, 'Beth', 'Torres', 34902, 1),(10317, 'Pamela', 'Rodriguez', 48187, 4),(10320, 'Gregory', 'Cook', 22681, 4),
(10324, 'William', 'Brewer', 15947, 1),(10329, 'Christopher', 'Ramos', 37710, 4),(10333, 'Jennifer', 'Blankenship', 13433, 4),
(10339, 'Robert', 'Mills', 13188, 1);

CREATE TABLE db_dept (id INT,department VARCHAR(50));

INSERT INTO db_dept (id, department) VALUES(1, 'engineering'),(2, 'human resource'),(3, 'operation'),(4, 'marketing');


with cte as (
SELECT D.department, E.salary FROM
db_employee AS E
INNER JOIN
db_dept AS D
ON E.department_id = D.id)
select 
(select max(salary) from cte where department = "marketing")
-
(select max(salary) from cte where department = "engineering")
AS Salary_Difference ;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 13 - Google -https://lnkd.in/g_vzRNwq
Find all records from days when the number of distinct users receiving emails was greater than the number of distinct users sending emails.
*/
CREATE TABLE google_gmail_emails (id INT PRIMARY KEY,from_user VARCHAR(50),to_user VARCHAR(50),day INT);

INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES
(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),
(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),
(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),
(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),
(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),(9, '6edf0be4b2267df1fa', 'd63386c884aeb9f71d', 3),
(10, '6edf0be4b2267df1fa', '5b8754928306a18b68', 2),(11, '6edf0be4b2267df1fa', '6edf0be4b2267df1fa', 8),
(12, '6edf0be4b2267df1fa', '406539987dd9b679c0', 9),(13, '6edf0be4b2267df1fa', '114bafadff2d882864', 5),
(14, '6edf0be4b2267df1fa', '157e3e9278e32aba3e', 2),(15, '75d295377a46f83236', '75d295377a46f83236', 6),
(16, '75d295377a46f83236', 'd63386c884aeb9f71d', 8),(17, '75d295377a46f83236', '55e60cfcc9dc49c17e', 3),
(18, '75d295377a46f83236', '47be2887786891367e', 10),(19, '75d295377a46f83236', '5b8754928306a18b68', 10),
(20, '75d295377a46f83236', '850badf89ed8f06854', 7);

SELECT 
	*, 
	COUNT(day) OVER(PARTITION BY day) AS count_id
FROM google_gmail_emails;

select count(distinct(to_user)) over(partition by day) from google_gmail_emails;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 16 - JP Morgan - https://lnkd.in/gWVVPrjP
Bank of Ireland has requested that you detect invalid transactions in December 2022. 
An invalid transaction is one that occurs outside of the bank's normal business hours. The following are the hours of operation for all branches:

Monday - Friday 09:00 - 16:00
Saturday & Sunday Closed
Irish Public Holidays 25th and 26th December
Determine the transaction ids of all invalid transactions.
*/

CREATE TABLE boi_transactions (transaction_id INT PRIMARY KEY,time_stamp DATETIME NOT NULL);

INSERT INTO boi_transactions (transaction_id, time_stamp) VALUES
(1051, '2022-12-03 10:15'),(1052, '2022-12-03 17:00'),(1053, '2022-12-04 10:00'),(1054, '2022-12-04 14:00'),
(1055, '2022-12-05 08:59'),(1056, '2022-12-05 16:01'),(1057, '2022-12-06 09:00'),(1058, '2022-12-06 15:59'),
(1059, '2022-12-07 12:00'),(1060, '2022-12-08 09:00'),(1061, '2022-12-09 10:00'),(1062, '2022-12-10 11:00'),
(1063, '2022-12-10 17:30'),(1064, '2022-12-11 12:00'),(1065, '2022-12-12 08:59'),(1066, '2022-12-12 16:01'),
(1067, '2022-12-25 10:00'),(1068, '2022-12-25 15:00'),(1069, '2022-12-26 09:00'),(1070, '2022-12-26 14:00'),
(1071, '2022-12-26 16:30'),(1072, '2022-12-27 09:00'),(1073, '2022-12-28 08:30'),(1074, '2022-12-29 16:15'),    -- 5-6
(1075, '2022-12-30 14:00'),(1076, '2022-12-31 10:00');


with cte as (
SELECT *, HOUR(time_stamp) AS hour, DAY(time_stamp) AS day, weekday(time_stamp) as weekday
from boi_transactions)
select * 
from cte
where (hour not between 9 and 16) or(day  in (25,26)) or (weekday in (5,6))
order by transaction_id asc ;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 17 - Uber - https://lnkd.in/gQphbD4M
You’re given a table of Uber rides that contains the mileage and the purpose for the business expense. 
You’re asked to find business purposes that generate the most miles driven for passengers that use Uber for their business transportation. 
Find the top 3 business purpose categories by total mileage.
*/

CREATE TABLE my_uber_drives (start_date DATETIME,end_date DATETIME,category VARCHAR(50),start VARCHAR(50),stop VARCHAR(50),miles FLOAT,purpose VARCHAR(50));

INSERT INTO my_uber_drives (start_date, end_date, category, start, stop, miles, purpose) VALUES
('2016-01-01 21:11', '2016-01-01 21:17', 'Business', 'Fort Pierce', 'Fort Pierce', 5.1, 'Meal/Entertain'),
('2016-01-02 01:25', '2016-01-02 01:37', 'Business', 'Fort Pierce', 'Fort Pierce', 5, NULL),
('2016-01-02 20:25', '2016-01-02 20:38', 'Business', 'Fort Pierce', 'Fort Pierce', 4.8, 'Errand/Supplies'),
('2016-01-05 17:31', '2016-01-05 17:45', 'Business', 'Fort Pierce', 'Fort Pierce', 4.7, 'Meeting'),
('2016-01-06 14:42', '2016-01-06 15:49', 'Business', 'Fort Pierce', 'West Palm Beach', 63.7, 'Customer Visit'),
('2016-01-06 17:15', '2016-01-06 17:19', 'Business', 'West Palm Beach', 'West Palm Beach', 4.3, 'Meal/Entertain'),
('2016-01-06 17:30', '2016-01-06 17:35', 'Business', 'West Palm Beach', 'Palm Beach', 7.1, 'Meeting');


select 
	purpose,
    ROUND(sum(miles),2) as total_miles
from my_uber_drives
group by purpose
order by sum(miles) desc
limit 3;
    
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 18 - Amazon - https://lnkd.in/gKgdfP6c
You have been asked to find the job titles of the highest-paid employees.
Your output should include the highest-paid title or multiple titles with the same salary.
*/

CREATE TABLE worker(worker_id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,joining_date DATETIME,department VARCHAR(50));

INSERT INTO worker(worker_id, first_name, last_name, salary, joining_date, department) VALUES
(1, 'John', 'Doe', 80000, '2020-01-15', 'Engineering'),(2, 'Jane', 'Smith', 120000, '2019-03-10', 'Marketing'),
(3, 'Alice', 'Brown', 120000, '2021-06-21', 'Sales'),(4, 'Bob', 'Davis', 75000, '2018-04-30', 'Engineering'),
(5, 'Charlie', 'Miller', 95000, '2021-01-15', 'Sales');

CREATE TABLE title(worker_ref_id INT,worker_title VARCHAR(50),affected_from DATETIME);

INSERT INTO title(worker_ref_id, worker_title, affected_from) VALUES
(1, 'Engineer', '2020-01-15'),(2, 'Marketing Manager', '2019-03-10'),(3, 'Sales Manager', '2021-06-21'),(4, 'Junior Engineer', '2018-04-30'),(5, 'Senior Salesperson', '2021-01-15');


select t.worker_title
from
title as t
inner join
worker as w
on t.worker_ref_id = w.worker_id
where w.salary = (select max(salary) from worker);


-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 19 - walmart - https://lnkd.in/gzqv3f-R
Identify users who started a session and placed an order on the same day. 
For these users, calculate the total number of orders and the total order value for that day. 
Your output should include the user, the session date, the total number of orders, and the total order value for that day.
SELECT * FROM xx;
*/

CREATE TABLE sessions(session_id INT PRIMARY KEY,user_id INT,session_date DATETIME);

INSERT INTO sessions(session_id, user_id, session_date) VALUES 
(1, 1, '2024-01-01 00:00:00'),(2, 2, '2024-01-02 00:00:00'),(3, 3, '2024-01-05 00:00:00'),(4, 3, '2024-01-05 00:00:00'),
(5, 4, '2024-01-03 00:00:00'),(6, 4, '2024-01-03 00:00:00'),(7, 5, '2024-01-04 00:00:00'),(8, 5, '2024-01-04 00:00:00'),
(9, 3, '2024-01-05 00:00:00'),(10, 5, '2024-01-04 00:00:00');

CREATE TABLE order_summary (order_id INT PRIMARY KEY,user_id INT,order_value INT,order_date DATETIME);

INSERT INTO order_summary (order_id, user_id, order_value, order_date) VALUES 
(1, 1, 152, '2024-01-01 00:00:00'),(2, 2, 485, '2024-01-02 00:00:00'),(3, 3, 398, '2024-01-05 00:00:00'),(4, 3, 320, '2024-01-05 00:00:00'),
(5, 4, 156, '2024-01-03 00:00:00'),(6, 4, 121, '2024-01-03 00:00:00'),(7, 5, 238, '2024-01-04 00:00:00'),(8, 5, 70, '2024-01-04 00:00:00'),
(9, 3, 152, '2024-01-05 00:00:00'),(10, 5, 171, '2024-01-04 00:00:00');


with cte as (
select 
	o.order_id,
    o.user_id,
    o.order_value,
    o.order_date,
    s.session_id,
    s.session_date,
    sum(o.order_value) OVER(PARTITION BY o.user_id) AS Total_Value,
    count(o.order_value) OVER(PARTITION BY o.user_id) AS Total_Orders,
    row_number() OVER(PARTITION BY o.user_id) AS Row_No
from
sessions as s
Inner join
order_summary as o
on s.user_id = o.user_id
where s.session_date = o.order_date )

select
	session_date,user_id, Total_Orders, Total_Value
from 
	cte
where
	Row_no = 1; 

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 21 - Microsoft - https://shorturl.at/r2FiB
Find the total number of downloads for paying and non-paying users by date. 
Include only records where non-paying customers have more downloads than paying customers. 
The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads. 

Note: In Oracle you should use "date" when referring to date column (reserved keyword).
SELECT * FROM xx;
*/

CREATE TABLE ms_user_dimension (user_id INT PRIMARY KEY,acc_id INT);
INSERT INTO ms_user_dimension (user_id, acc_id) VALUES (1, 101),(2, 102),(3, 103),(4, 104),(5, 105);

CREATE TABLE ms_acc_dimension (acc_id INT PRIMARY KEY,paying_customer VARCHAR(10));
INSERT INTO ms_acc_dimension (acc_id, paying_customer) VALUES (101, 'Yes'),(102, 'No'),(103, 'Yes'),(104, 'No'),(105, 'No');

CREATE TABLE ms_download_facts (date DATETIME,user_id INT,downloads INT);
INSERT INTO ms_download_facts (date, user_id, downloads) VALUES 
('2024-10-01', 1, 10),('2024-10-01', 2, 15),('2024-10-02', 1, 8),('2024-10-02', 3, 12),('2024-10-02', 4, 20),('2024-10-03', 2, 25),('2024-10-03', 5, 18);


with cte as (
SELECT U.user_id, U.acc_id, A.paying_customer, D.date, D.downloads, weekday(D.date) as days, count(paying_customer) over (partition by  weekday(D.date) order by  weekday(D.date) ) AS Date_Group
FROM ms_user_dimension as U, ms_acc_dimension as A, ms_download_facts as D
WHERE D.user_id = U.user_id AND U.acc_id = A.acc_id
ORDER BY weekday(D.date))

select 
	*
from
	cte
where
	
order by
	days;

SELECT U.user_id, U.acc_id, A.paying_customer, D.date, D.downloads, weekday(D.date) as days, 
    sum(D.downloads) over (partition by weekday(D.date), A.paying_customer order by  weekday(D.date) ) AS Total_Amount
FROM ms_user_dimension as U, ms_acc_dimension as A, ms_download_facts as D
WHERE D.user_id = U.user_id AND U.acc_id = A.acc_id
ORDER BY weekday(D.date);

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 23 - Oracle - https://shorturl.at/R9cZD
Write a query that compares each employee's salary to their manager's and the average department salary (excluding the manager's salary). 
Display the department, employee ID, employee's salary, manager's salary, and department average salary. 
Order by department, then by employee salary (highest to lowest).

SELECT * FROM xx;
*/

CREATE TABLE employee_o (id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),age INT,gender VARCHAR(10),employee_title VARCHAR(50),department VARCHAR(50),salary INT,manager_id INT);

INSERT INTO employee_o (id, first_name, last_name, age, gender, employee_title, department, salary, manager_id) VALUES
(1, 'Alice', 'Smith', 45, 'F', 'Manager', 'HR', 9000, 1),(2, 'Bob', 'Johnson', 34, 'M', 'Assistant', 'HR', 4500, 1),(3, 'Charlie', 'Williams', 28, 'M', 'Coordinator', 'HR', 4800, 1),
(4, 'Diana', 'Brown', 32, 'F', 'Manager', 'IT', 12000, 4),(5, 'Eve', 'Jones', 27, 'F', 'Analyst', 'IT', 7000, 4),(6, 'Frank', 'Garcia', 29, 'M', 'Developer', 'IT', 7500, 4),
(7, 'Grace', 'Miller', 30, 'F', 'Manager', 'Finance', 10000, 7),(8, 'Hank', 'Davis', 26, 'M', 'Analyst', 'Finance', 6200, 7),(9, 'Ivy', 'Martinez', 31, 'F', 'Clerk', 'Finance', 5900, 7),
(10, 'John', 'Lopez', 36, 'M', 'Manager', 'Marketing', 11000, 10),(11, 'Kim', 'Gonzales', 29, 'F', 'Specialist', 'Marketing', 6800, 10),(12, 'Leo', 'Wilson', 27, 'M', 'Coordinator', 'Marketing', 6600, 10);



with cte2 as (
with cte as (
select 
	b.id,
	a.first_name as M_first_name,
	a.last_name as M_last_name,
	a.department,
	a.salary as M_salary,
	a.manager_id,
	b.first_name,
	b.last_name,
	b.employee_title,
	b.salary,
    row_number() OVER (Partition BY a.department) AS Row_Numberr
from
employee_o as a
join employee_o as b
on a.id = b.manager_id)

select * ,
		ROUND(AVG(CASE WHEN Row_Numberr > 1 THEN salary END) OVER (PARTITION BY department),1) AS Average_Department_Salary
from cte)

select 
	id as employee_id,
    department,
    salary,
    M_salary,
    Average_Department_Salary
from cte2
where Row_numberr > 1
order by id;
    
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 24 - Amazon - https://shorturl.at/OebkH
Find products which are exclusive to only Amazon and therefore not sold at Top Shop and Macy's. Your output should include the product name, brand name, price, and rating.

Two products are considered equal if they have the same product name and same maximum retail price (mrp column).

SELECT * FROM xx;
*/

CREATE TABLE innerwear_amazon_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count INT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));
INSERT INTO innerwear_amazon_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES 
('ProductA', '100', '80', 'url1', 'BrandA', 'Category1', 'Amazon', 'DescriptionA', 4.5, 100, 'StyleA', 'M,L', 'M', 'Red'),('ProductB', '200', '180', 'url2', 'BrandB', 'Category1', 'Amazon', 'DescriptionB', 4.2, 150, 'StyleB', 'S,M,L', 'S', 'Blue'),
('ProductC', '300', '250', 'url3', 'BrandC', 'Category2', 'Amazon', 'DescriptionC', 4.8, 200, 'StyleC', 'L,XL', 'L', 'Green');

CREATE TABLE innerwear_macys_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count FLOAT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));
INSERT INTO innerwear_macys_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES 
('ProductA', '100', '85', 'url4', 'BrandA', 'Category1', 'Macys', 'DescriptionA', 4.5, 90, 'StyleA', 'M,L', 'M', 'Red'),('ProductD', '150', '130', 'url5', 'BrandD', 'Category3', 'Macys', 'DescriptionD', 4.0, 80, 'StyleD', 'S,M', 'S', 'Yellow'),
('ProductE', '250', '210', 'url6', 'BrandE', 'Category4', 'Macys', 'DescriptionE', 3.9, 60, 'StyleE', 'M,L', 'L', 'Black');

CREATE TABLE innerwear_topshop_com (product_name VARCHAR(255),mrp VARCHAR(50),price VARCHAR(50),pdp_url VARCHAR(255),brand_name VARCHAR(100),product_category VARCHAR(100),retailer VARCHAR(100),description VARCHAR(255),rating FLOAT,review_count FLOAT,style_attributes VARCHAR(255),total_sizes VARCHAR(50),available_size VARCHAR(50),color VARCHAR(50));
INSERT INTO innerwear_topshop_com (product_name, mrp, price, pdp_url, brand_name, product_category, retailer, description, rating, review_count, style_attributes, total_sizes, available_size, color) VALUES 
('ProductB', '200', '190', 'url7', 'BrandB', 'Category1', 'TopShop', 'DescriptionB', 4.1, 95, 'StyleB', 'S,M,L', 'M', 'Blue'),('ProductF', '100', '90', 'url8', 'BrandF', 'Category3', 'TopShop', 'DescriptionF', 3.5, 50, 'StyleF', 'XS,S', 'S', 'Pink'),
('ProductG', '300', '270', 'url9', 'BrandG', 'Category5', 'TopShop', 'DescriptionG', 4.3, 70, 'StyleG', 'M,L,XL', 'M', 'Purple');

SELECT * FROM innerwear_amazon_com;
SELECT * FROM innerwear_macys_com;
SELECT * FROM innerwear_topshop_com;

with cte as (
select 
	i_a.product_name, i_a.mrp, i_a.brand_name, i_a.price, i_a.rating , 
	i_a.product_name as m_product_name, i_a.mrp as m_mrp, i_a.brand_name as m_brand_name, i_a.price as m_price, i_a.rating as m_rating 
from 
innerwear_amazon_com as i_a
left join
innerwear_macys_com as i_m
on i_a.product_name = i_m.product_name)
select  sum(case when mrp is null then 1 else 0 end) as NumberOfNulls from cte;

with cte2 as(
with cte as (
select 
 *
from 
innerwear_amazon_com 
union all
select * from
innerwear_macys_com 
union all
select * from
innerwear_topshop_com)

select 
	*,
    count(product_name) over (partition by product_name order by product_name) as row_no
from cte)

select product_name, product_name, price, rating
from cte2
where retailer = "Amazon" and row_no = 1;

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

/* 
Question - 25 - American Express - https://lnkd.in/gF_mmRsN
American Express is reviewing their customers' transactions, and you have been tasked with locating the customer who has the third highest total transaction amount. 
The output should include the customer's id, as well as their first name and last name. For ranking the customers, use type of ranking with no gaps between subsequent ranks.

SELECT * FROM xx;
*/

CREATE TABLE customers (id INT,first_name VARCHAR(50),last_name VARCHAR(50),city VARCHAR(100),address VARCHAR(200),phone_number VARCHAR(20));

INSERT INTO customers (id, first_name, last_name, city, address, phone_number) VALUES
(1, 'Jill', 'Doe', 'New York', '123 Main St', '555-1234'),(2, 'Henry', 'Smith', 'Los Angeles', '456 Oak Ave', '555-5678'),(3, 'William', 'Johnson', 'Chicago', '789 Pine Rd', '555-8765'),
(4, 'Emma', 'Daniel', 'Houston', '321 Maple Dr', '555-4321'),(5, 'Charlie', 'Davis', 'Phoenix', '654 Elm St', '555-6789');

CREATE TABLE card_orders (order_id INT,cust_id INT,order_date DATETIME,order_details VARCHAR(255),total_order_cost INT);

INSERT INTO card_orders (order_id, cust_id, order_date, order_details, total_order_cost) VALUES
(1, 1, '2024-11-01 10:00:00', 'Electronics', 200),(2, 2, '2024-11-02 11:30:00', 'Groceries', 150),(3, 1, '2024-11-03 15:45:00', 'Clothing', 120),(4, 3, '2024-11-04 09:10:00', 'Books', 90),
(8, 3, '2024-11-08 10:20:00', 'Groceries', 130),(9, 1, '2024-11-09 12:00:00', 'Books', 180),(10, 4, '2024-11-10 11:15:00', 'Electronics', 200),(11, 5, '2024-11-11 14:45:00', 'Furniture', 150),
(12, 2, '2024-11-12 09:30:00', 'Furniture', 180);

SELECT * FROM customers;
SELECT * FROM card_orders;


with cte2 as (
with cte as (
select * ,
	sum(total_order_cost) over (partition by first_name order by cust_id) as total_transaction
 from 
customers as cu
join
card_orders as co
on cu.id = co.cust_id)

select 
	id, first_name, last_name, total_transaction,
    dense_rank() over (order by total_transaction DESC) as ranking
from cte)

select id, first_name, last_name
from cte2 where ranking = 3
limit 1;


-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



















