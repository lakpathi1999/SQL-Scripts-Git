USE sql_store;
select * from customers
where customer_id=1
order by first_name;

select 1,2 from customers;  -- it adds two new column

select first_name, last_name, points, points * 100 + 10  -- add a points table with addition by 10
from customers;

-- Changing the column name by using AS(alian) command 
select first_name, last_name, points, (points * 100) + 10 AS 'new_ponits' -- add a points table with addition by 10
from customers;

-- Exercise:
-- Return all the products
-- name
-- unit price
-- new price(unit price * 1.1) 
use sql_store;
select name,unit_price, unit_price*1.1 as new_price
from products;

-- Arithematic Operation in sql

select * from customers
where points <= 1000;

select * from customers
where (birth_date > '1990-01-01' or points > 1000) and state ="VA";

select * from order_items
where order_id = 6 and unit_price * quantity > 30;
-- Exercise:
select * from customers
where birth_date between '1990-01-01' and '2000-01-01';

-- % for any number of characters
-- _ a single character
select * from customers
where last_name like "_____y" -- %b,b%,%b%,_y

-- REGEXP, It is a powerful tool for searching for string
use sql_store;
select * from customers
-- where last_name like "%field%"
-- where last_name regexp 'field$' -- ^ represents begining of a string, $ Represents end of a string
-- where last_name regexp 'field|mac|rose'
-- where last_name regexp '[gim]e' -- Name contain ge or ie or me 
where last_name regexp '[a-h]e' -- range value contain in the last_name

-- Exercise:
select * from customers
-- where first_name regexp 'ELKA|AMBUR'
-- where last_name regexp "EY$|ON$"
-- where last_name regexp '^MY|SE'
-- where last_name regexp 'B[RU]'  -- can use br|bu


-- Exercise:
-- Get the orders placed this year
select * from orders
where order_date = '2018-06-08'


-- The IS NULL Operator
select * from customers
where phone IS NULL -- IS NOT NULL for having all P.No
 
select * from orders
where shipper_id is null

-- The ORDER BY clause

-- In sql you can select few columns and give access to manipulate any column.
select first_name,last_name, 10 as points from customers
order by first_name desc

select *,quantity * unit_price * 10 as new_price from order_items
where order_id = 2
order by new_price desc

-- The LIMIT clause

select * from customers
LIMIT 6,3   -- It skip first 6 records and then takes 3 records 

-- Exercise:
-- Get the top three loyal customers
select * from customers
order by points desc
LIMIT 3 

-- The Inner Joins clause
select * from orders o
join customers c on o.customer_id = c.customer_id

-- Exercise:
select order_id, oi.product_id, quantity, oi.unit_price from order_items oi
join products p on oi.product_id = p.product_id

-- Joining across Databases
select * from order_items oi
join sql_inventory.products p
on oi.product_id  = p.product_id

-- self joins
use sql_hr;
select e.employee_id, e.first_name, m.first_name as manager from employees e
join employees m
on e.reports_to = m.employee_id;

-- Joining multiple tables
use sql_store;
select o.customer_id, o.order_date, c.first_name, c.last_name, os.name as status from orders o
join customers c
on o.customer_id = c.customer_id
join order_statuses os
on o.status = os.order_status_id;

-- Exercise:
use sql_invoicing;
select p.client_id, c.name, p.payment_method,pm.name from payments p
join clients c
on p.client_id = c.client_id
join payment_methods pm
on p.payment_method = pm.payment_method_id;

-- Compound Join Conditions
 
use sql_store;
SELECT * FROM order_items oi
join order_item_notes oin
on oi.order_id=oin.order_id and oi.product_id = oin.product_id;

-- Implicit Join Syntax

-- Generally
select * from orders o
inner join customers c
on o.customer_id = c.customer_id;
-- But in implicit join syntax
select * from orders o, customers c 
where o.customer_id = c.customer_id;

-- Outer join:   --> Need Repeat or Revision
select * from customers c
left join orders o
on c.customer_id = o.customer_id 
order by c.customer_id desc;
-- left join gives indicates all the customer_id whether they are ordered or not that are present in customer table
-- right join gives indicates all the customer_id that are present in orders table
-- Write a query in inner join then we will convert it to outer join
 
 
 -- Exercise
 use sql_store;
 select oi.product_id, p.product_id, p.name from products p
 left join order_items oi
 on p.product_id = oi.product_id
 
 -- Self outer Joins:
 use sql_hr;
 select e.employee_id, e.first_name, m.first_name as manager from employees e
 left join employees m
 on e.reports_to = m.employee_id
 
 -- The Using Clause
 use sql_store;
 select oi.product_id, p.product_id, p.name from products p
 left join order_items oi
 -- on p.product_id = oi.product_id 
 using(product_id) -- Here using clause do the same as line number 6 do.
 -- on p.product_id = oi.product_id and p.order_id = oi.order_id
 -- using(product_id,  order_id)

 
-- Exercise: 
use sql_invoicing;
SELECT  p.date, c.name as client, p.amount, pm.name as payment_method FROM payments p
join clients c using (client_id)
join payment_methods pm
on p.payment_method = pm.payment_method_id;
 
-- Natural Joins
 -- In natural joins no need to explicitily mention the column name, 
 -- natural join verify two mentioned table and join the table based on same column ( Column name should be the same)

use sql_store;
SELECT * FROM  orders o
natural join customers c

-- Cross joins:
-- To combine every record from first table and every record from second table
select 
	c.first_name as customer,
	p.name as product
from customers c
cross join products p
order by c.first_name

-- Unions:
-- To combine rows from multiple table we use unions
select order_id,order_date,'Active' as status from orders 
where order_date >= '2019-01-01'
union  -- Using union we can combine multiple queries
select order_id,order_date,'Archived' as status from orders 
where order_date < '2019-01-01';

-- Write a query to combine first_name from from customers table and name from shippers table--
-- Note that this union should take same size of column name from both the tables.
select first_name from customers
union
select name from shippers;

-- Exercise:

select customer_id, first_name,
		points,'Bronze' as Type
from customers
where points < 2000
union
select customer_id, first_name,
		points,'Silver' as Type
from customers
where points between 2000 and 3000
union
select customer_id, first_name,
		points,'Gold' as Type
from customers
where points > 3000
order by first_name;

-- Column Attributes
-- How to insert delete and update data

-- Inserting a Single Row
insert into customers(first_name,
                      last_name,
					   birth_date,
                       address,
                       city,
                       state)
values ('John', 'Smith', '1990-01-01',
			'address', 'city','CA')


-- Insert multiple rows

insert into shippers(name)
values ('Lucky1'),
	   ('Lucky2'),
       ('Lucky3')
       
-- Exercise:
-- Insert three rows in the products table
insert into products(name, quantity_in_stock, unit_price)
values ('Product1', 13, 1.45),
	   ('Product2', 67, 3.8),
       ('Product3', 72, 2.93)

-- Inserting Hierarchical Rows
-- Inserting data into multiple tables

insert into orders (customer_id, order_date, status)
values (1, '2019-01-01',1);

insert into order_items
values (last_insert_id(), 1,1,2.95),
		(last_insert_id(), 2,1,3.95);

-- Creating a copy of a table:
-- How to copy data from one table to another table
-- Creating a duplicate table of order table and copying all the rows from order table into new table

create table orders_archieved as
select * from orders;
-- Now it contains same values as orders table, let's delete all the values and create new values
-- To delete all the data in the table we use 'truncate'

insert into orders_archieved
select * from orders
where order_date < '2019-01-01';

-- Exercise:
use sql_invoicing;
-- create table invoices_archieved as
-- select * from invoices

create table invoices_archieved as
select 
     i.invoice_id,
     i.number,
     c.name as client,
     i.invoice_total,
     i.payment_total,
     i.invoice_date,
     i.payment_date,
     i.due_date
from invoices i
join clients c using(client_id)
where payment_date is not null;

-- Updating a single row
update invoices
set payment_total = invoice_total*0.5,
payment_date = due_date
where invoice_id = 3

-- Updating multiple rows

update invoices
set payment_total = invoice_total*0.5,
payment_date = due_date
where client_id = 3

-- Update all the rows where cliend_id contain numbers 3 and 4

update invoices
set payment_total = invoice_total*0.5,
payment_date = due_date
where client_id in (3,5);

-- Write a SQL statement to 
-- give any customers born before 1990
-- 50 extra points

use sql_store;
select first_name, last_name, birth_date, points + 50 as points from customers
where birth_date < '1990-01-01';

-- OR
-- Update multiple rows approach
use sql_store;
update customers
set points = points+50
where birth_date < '1990-01-01'

-- Using subqueries in Updates
use sql_invoicing;
update invoices
set
	payment_date=invoice_total*0.5
    payment_date = due_date 
where cliend_id in
				(select client_id from clients
                where state in ('CA','NY'))

-- Deleting operation:

delete from invoices
where client_id = (select * 
					from clients
                    where name = 'Myworks')
-- Restore database










