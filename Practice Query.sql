select * from orders_data;

--Check specific Columns
select order_id,order_date,sales
from orders_data;

-- check top 10 columns
select top 10 * from orders_data;

--OR
select top 10 order_id,order_date,sales from orders_data;

--Order in which SQL execution take place
-- FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and finally, LIMIT/OFFSET

--check in ASC order
select * 
from orders_data
order by order_date, profit;

--check in DESC order
select * 
from orders_data
order by order_date desc, profit desc;

--top 5 sales
select top 5 * 
from orders_data
order by sales desc;

-- create new columns ratio (profit/sales)
select *, profit/sales as profit_ratio
from orders_data
order by profit_ratio

--filter data region will be Central
select *
from orders_data
where region = 'Central'

select *
from orders_data
where quantity <= 3

select *
from orders_data
where order_date > '2019-09-17'
order by order_date

--double filter AND

select *
from orders_data
where region = 'Central' AND category = 'Technology'

select *
from orders_data
where region = 'Central' AND category = 'Technology' AND quantity>3

--double filter OR

select *
from orders_data
where (region = 'Central' OR category = 'Technology') AND quantity>6
order by quantity

-- between

select * 
from orders_data
where quantity between 3 and 5 -- 3 and 5 are also included
order by quantity

--IN
select * 
from orders_data
where quantity IN (3,5)
order by quantity

select * 
from orders_data
where city IN ('Los Angeles','Henderson')


-- in Between the lower values should be first in sequence
select * 
from orders_data
where order_date between '2018-08-27' and '2020-06-12'
order by order_date


--Pattern Matching
-- Like operator

select * 
from orders_data
where customer_name like '%a%'

--_ that means that There should be exaclty 1 charater

select * 
from orders_data
where customer_name like '_e%'

-- either e or a can come on 2 position

select * 
from orders_data
where customer_name like '_[ae]%n'

----------------
--Aggregate

-- SUM of sales

select SUM(sales) as Total_Sales from orders_data

select MIN(sales) as Total_Sales from orders_data

select * from orders_data order by sales
select MAX(sales) as Total_Sales 
from orders_data

--COUNT

select COUNT(*) no_of_records
from orders_data

--Average sales
select SUM(sales)/COUNT(*) as Average_sales
from orders_data

-- OR

select avg(sales)as Average_sales_avg
from orders_data

select 
	count(*),
	count(order_id),
	count(city) as no_of_records, 
	count(100), 
	count(DISTINCT category),
	count(DISTINCT city)
from orders_data

--DISTINCT

select DISTINCT category, region
from orders_data

--Summarize data

select 
	category, region,
	SUM(sales) as category_sales,
	SUM(profit) as category_profit
from orders_data
group by category, region

select 
	city,
	SUM(sales) as city_sales
from orders_data
group by city
having SUM(sales)>500

-- The reason for using Having instead of where it runs row by row and becasue of that it can't give me the Answer city wise

select 
	city,
	SUM(sales) as city_sales
from orders_data
where region='West'
group by city
having SUM(sales)>500

--Order in which SQL execution take place
-- FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and finally, LIMIT/OFFSET


select * 
from orders_data od
inner join returns_data rd
ON od.order_id = rd.order_id
order by profit;

select category, SUM(sales) as Total_sales
from orders_data od
inner join returns_data rd
ON od.order_id = rd.order_id
group by category

select category, SUM(sales) as Total_sales 
from orders_data od
inner join returns_data rd
ON od.order_id = rd.order_id
where return_reason = 'Others'
group by category

--INNER JOIN

select *
from orders_data od
inner join returns_data rd
ON od.order_id = rd.order_id
where return_reason = 'Wrong Items' and city='Los Angeles'

select *
from orders_data od
inner join returns_data rd
ON od.order_id = rd.order_id
where rd.order_id = 'CA-2020-109806'

-- LEFT JOIN

select * 
from orders_data od
left join returns_data rd
ON od.order_id = rd.order_id
order by profit;

--All data which is not return

select * 
from orders_data od
left join returns_data rd
ON od.order_id = rd.order_id
where rd.return_reason is null


select rd.* ,od.*
from orders_data od
inner join returns_data rd ON od.order_id = rd.order_id
where rd.return_reason is not null



select rd.return_reason, SUM(od.sales) as Return_sales 
from orders_data od
left join returns_data rd ON od.order_id = rd.order_id
group by rd.return_reason

--Change the label in the data
--CASE

select *,
case when return_reason = 'Wrong Item' then 'Wrong Items' else return_reason end as new_return_reason
from returns_data;

--When profit < 0 its a loss 
--When profit <50 its a low profit
--When profit >50 and < 100 its a high profit
--When profit >100 its a very high profit


select *,
	case when profit < 0 then 'Loss'
	when profit < 50 then 'Loss profit'
	when profit < 100 then 'high profit'
	else 'Very High profit'
	end AS Profit_Bucket
from orders_data;

-- If you change the order of between the profit label won't change and works well as if you change the order in the above query it won't work.


select *,
	case when profit < 0 then 'Loss'
	when profit between 0 and 49 then 'Loss profit'
	when profit between 50 and 99 then 'High profit'
	else 'Very High profit'
	end AS Profit_Bucket
from orders_data;


--LEN function, RIGHT, LEFT, SUB string REPLACE

select order_id,customer_name,
	LEN(customer_name) as Customer_Length
	,LEFT(order_id, 2) as States
	,RIGHT(order_id, 6) as ID
	,SUBSTRING(order_id,4,4) as order_year
	,REPLACE(customer_name,'Cl','PA')
from orders_data

--Date Function

select LEFT(order_date,4), SUM(sales)
from orders_data
group by LEFT(order_date,4)

--Q1,Q2...

select 
	--order_id, order_date,
	DATEPART(MONTH, order_date) as order_month,
	DATEPART(YEAR, order_date) as order_year,
	SUM(sales) AS Total_sales
from orders_data
GROUP BY DATEPART(MONTH,order_date),DATEPART(YEAR,order_date)

select 
	order_id, order_date,
	DATENAME(MONTH,order_date) as Order_Month
from orders_data


select 
	order_id, order_date,ship_date,
	DATEDIFF(DAY,order_date,ship_date) AS Lead_days
from orders_data