-- Simple SQL Customer Database

CREATE DATABASE customers;

\c customers

-- CREATE STATE TABLE
CREATE TABLE state (statecode varchar PRIMARY KEY, name varchar);

-- POPULATE STATE TABLE
INSERT INTO state VALUES ('AL', 'Alabama'),
('AK', 'Alaska'),
('AZ', 'Arizona'),
('AR', 'Arkansas'),
('CA', 'California'),
('CO', 'Colorado'),
('CT', 'Connecticut'),
('DE', 'Delaware'),
('DC', 'District of Columbia'),
('FL', 'Florida'),
('GA', 'Georgia'),
('HI', 'Hawaii'),
('ID', 'Idaho'),
('IL', 'Illinois'),
('IN', 'Indiana'),
('IA', 'Iowa'),
('KS', 'Kansas'),
('KY', 'Kentucky'),
('LA', 'Louisiana'),
('ME', 'Maine'),
('MD', 'Maryland'),
('MA', 'Massachusetts'),
('MI', 'Michigan'),
('MN', 'Minnesota'),
('MS', 'Mississippi'),
('MO', 'Missouri'),
('MT', 'Montana'),
('NE', 'Nebraska'),
('NV', 'Nevada'),
('NH', 'New Hampshire'),
('NJ', 'New Jersey'),
('NM', 'New Mexico'),
('NY', 'New York'),
('NC', 'North Carolina'),
('ND', 'North Dakota'),
('OH', 'Ohio'),
('OK', 'Oklahoma'),
('OR', 'Oregon'),
('PA', 'Pennsylvania'),
('PR', 'Puerto Rico'),
('RI', 'Rhode Island'),
('SC', 'South Carolina'),
('SD', 'South Dakota'),
('TN', 'Tennessee'),
('TX', 'Texas'),
('UT', 'Utah'),
('VT', 'Vermont'),
('VA', 'Virginia'),
('WA', 'Washington'),
('WV', 'West Virginia'),
('WI', 'Wisconsin'),
('WY', 'Wyoming');

-- CREATE ADDRESS TABLE
CREATE TABLE address (id int PRIMARY KEY, street varchar, city varchar, zip varchar, state varchar REFERENCES state(statecode), country varchar);

-- POPULATE ADDRESS TABLE
INSERT INTO address (id, street, city, zip, state, country) VALUES (0, '1337 Pine Ave', 'Hanover', '21076', 'MD', 'USA'),
(1, '13067 Coronation St', 'Annapolis', '21111', 'MD', 'USA'),
(2, '35 Longview Dr', 'Davis', '26115', 'WV', 'USA'),
(3, '21000 Hollywood Blvd', 'Beverly Hills', '91210', 'CA', 'USA');

-- Lets try inserting an address with a state code that doesn't exist
INSERT INTO address (id, street, city, zip, state, country) VALUES (4, 'Avenida Acapulco #99', 'Tijuana', '21400', 'BC', 'Mexico');

-- CREATE CUSTOMER TABLE
CREATE TABLE customer (id int PRIMARY KEY, name varchar NOT NULL, primary_address int REFERENCES address(id) NOT NULL);

-- POPULATE CUSTOMER TABLE
INSERT INTO customer (id, name, primary_address) VALUES (0, 'Paul McDonald', 0),
(1, 'Ellie McDonald', 0),
(2, 'Marc Donahue', 1),
(3, 'Allison Smith', 2),
(4, 'James Taylor', 3);

-- CREATE ORDERS BRIDGE TABLE
CREATE TABLE cust_order (order_id int PRIMARY KEY, customer_id int REFERENCES customer(id) NOT NULL);

-- CREATE ITEM TABLE
CREATE TABLE item (id int PRIMARY KEY, isbn varchar, itemname varchar NOT NULL, price float NOT NULL);

--POPULATE ITEM TABLE
INSERT INTO item (id, isbn, itemname, price) VALUES (0, NULL, 'toothbrush', 1.99),
(1, '12739182479', 'Hacking Exposed', 27.99),
(2, NULL, 'Red Bull', 2.49);

-- CREATE ORDER_ITEM TABLE
CREATE TABLE order_item (id int PRIMARY KEY, order_id int REFERENCES cust_order(order_id), item_id int REFERENCES item(id));

-- CREATE SOME ORDERS
BEGIN;
INSERT INTO cust_order (order_id, customer_id) VALUES (0, 0), (1,1), (2,1), (3,2);
INSERT INTO order_item (id, order_id, item_id) VALUES (0, 0, 0), (1, 0, 2), (2, 1, 1), (3, 2, 2), (4, 2, 0), (5, 3, 0); 
COMMIT;

-- LETS CREATE ONE MORE
BEGIN;
INSERT INTO cust_order (order_id, customer_id) VALUES (4, 17);
INSERT INTO order_item(id, order_id, item_id) VALUES (6, 4, 0);
ROLLBACK;

-- GET ALL CUSTOMERS WITH THEIR ADDRESS
select customer.name, address.street, address.city, address.zip, address.state, address.country FROM customer LEFT JOIN address ON customer.primary_address = address.id;

-- GET ALL CUSTOMERS WITH THEIR ORDERS AND THE ITEMS IN EACH ORDER
SELECT item.itemname, customer.name 
FROM customer 
JOIN cust_order ON customer.id = cust_order.customer_id 
JOIN order_item ON cust_order.order_id = order_item.order_id 
JOIN item ON item.id = order_item.item_id;