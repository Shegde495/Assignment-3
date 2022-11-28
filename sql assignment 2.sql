-- create a table
CREATE TABLE customer(
  customer_id INTEGER PRIMARY KEY,
  customer_name VARCHAR(30)
);
-- insert some values
INSERT INTO customer VALUES (1, 'John');
INSERT INTO customer VALUES (2, 'Smith');
INSERT INTO customer VALUES (3, 'Ricky');
INSERT INTO customer VALUES (4, 'Walsh');
INSERT INTO customer VALUES (5, 'stephen');
INSERT INTO customer VALUES (6, 'fleming');
INSERT INTO customer VALUES (7, 'thompson');
INSERT INTO customer VALUES (8, 'David');
-- fetch some values
create TABLE product(
 product_id INTEGER primary key,
 product_name varchar(30),
 product_price INTEGER
);
INSERT INTO product VALUES(1,'tele vision',19000);
INSERT INTO product VALUES(2,'dvd',3600);
INSERT INTO product VALUES(3,'washing machine',7600);
INSERT INTO product VALUES(4,'computer',35900);
INSERT INTO product VALUES(5,'ipod',3210);
INSERT INTO product VALUES(6,'panasonic phone',2100);
INSERT INTO product VALUES(7,'chair',360);
INSERT INTO product VALUES(8,'table',490);
INSERT INTO product VALUES(9,'sound system',12050);
INSERT INTO product VALUES(10,'home theater',19000);

CREATE TABLE orders(
order_id INTEGER primary key,
customer_id INTEGER,
ordered_date date ,
foreign key (customer_id) references customer(customer_id) on delete set null
);
INSERT INTO orders VALUES(1,4,'2005-06-05');
INSERT INTO orders VALUES(2,2,'2006-02-06');
INSERT INTO orders VALUES(3,3,'2005-03-05');
INSERT INTO orders VALUES(4,3,'2006-03-10');
INSERT INTO orders VALUES(5,1,'2007-04-05');
INSERT INTO orders VALUES(6,7,'2006-12-13');
INSERT INTO orders VALUES(7,6,'2008-03-13');
INSERT INTO orders VALUES(8,6,'2004-11-29');
INSERT INTO orders VALUES(9,5,'2005-01-13');
INSERT INTO orders VALUES(10,1,'2007-12-12');

CREATE TABLE order_details(
order_detail_id INTEGER primary key,
order_id INTEGER ,
product_id INTEGER,
quantity INTEGER ,
foreign key (order_id) references orders(order_id) on delete set null,
foreign key (product_id) references product(product_id) on delete set null
);
INSERT INTO order_details VALUES(1,1,3,1);
INSERT INTO order_details VALUES(2,1,2,3);
INSERT INTO order_details VALUES(3,2,10,2);
INSERT INTO order_details VALUES(4,3,7,10);
INSERT INTO order_details VALUES(5,3,4,2);
INSERT INTO order_details VALUES(6,3,5,4);
INSERT INTO order_details VALUES(7,4,3,1);
INSERT INTO order_details VALUES(8,5,1,2);
INSERT INTO order_details VALUES(9,5,2,1);
INSERT INTO order_details VALUES(10,6,5,1);
INSERT INTO order_details VALUES(11,7,6,1);
INSERT INTO order_details VALUES(12,8,10,2);
INSERT INTO order_details VALUES(13,8,3,1);
INSERT INTO order_details VALUES(14,9,10,3);
INSERT INTO order_details VALUES(15,10,1,1);

--1)
select customer_name,product_name
from customer
inner join orders on customer.customer_id=orders.order_id
inner join order_details on orders.order_id=order_details.order_id
inner join product on product.product_id=order_details.product_id
order by customer_name;

--2)
select order_detail_id,orders.order_id,product.product_id,ordered_date,product_price*quantity as total
from orders
inner join order_details on order_details.order_id=orders.order_id
inner join product on product.product_id=order_details.product_id
order by order_id;

--3)
select customer.customer_name
from customer
where customer.customer_id=(select customer.customer_id
from customer
left join orders on customer.customer_id=orders.customer_id
where orders.order_id is null);

--4)
select product.*,count(order_details.order_id) as total
from product
left join order_details on order_details.product_id=product.product_id
group by product.product_id 
order by total asc limit 2;

--5)
select customer.customer_name,customer.customer_id,sum(product.product_price) as total
from customer
left join orders on customer.customer_id=orders.order_id
left join order_details on orders.order_id=order_details.order_id
left join product on product.product_id=order_details.product_id
group by customer.customer_id
order by customer.customer_id;

--6)
select  *
from customer
inner join orders on orders.customer_id=customer.customer_id
where ordered_date=(select min(ordered_date) 
from orders)
union all
select *
from customer
inner join orders on orders.customer_id=customer.customer_id
where ordered_date=(select max(ordered_date) 
from orders);

--7)
select customer.*,count(*) as valuess
from orders
left join customer on customer.customer_id=orders.customer_id
group by customer.customer_id
order by valuess desc limit 3;

--8)
select orders.customer_id , 
customer_name
,count(orders.order_id) as orders_placed,
count( distinct year(ordered_date)) as same_year
from orders
left join customer on customer.customer_id=orders.customer_id
group by orders.customer_id 
order by same_year asc,orders_placed desc limit 1;


--9)
select count(customer.customer_id) as total ,
month(ordered_date) as months
from orders
left join customer on customer.customer_id=orders.customer_id
group by years
order by total desc ;


--10)
select *
from product
where product_price=(select max(product_price)
from product);



