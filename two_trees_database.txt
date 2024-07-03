-- Create the Two Trees Database 

----------------------------------------------------------
-- EMPTY THE TWO TREES DATABASE IN CASE IT CONTAINS CONTENT
----------------------------------------------------------

DROP TABLE IF EXISTS inventory.products;
DROP TABLE IF EXISTS inventory.categories;
DROP SCHEMA IF EXISTS inventory;
DROP TABLE IF EXISTS sales.order_lines;
DROP TABLE IF EXISTS sales.orders;
DROP TABLE IF EXISTS sales.customers;
DROP SCHEMA IF EXISTS sales;

-----------------------------------
-- CREATE THE TABLE STRUCTURE
-----------------------------------

-- Create the database schemas
CREATE SCHEMA inventory;
CREATE SCHEMA sales;


-- Create a table for the Two Trees category data
CREATE TABLE inventory.categories (
    category_id          INT NOT NULL PRIMARY KEY,
    category_description VARCHAR(50),
    product_line         VARCHAR(25)
);

-- Create a table for the Two Trees product data
CREATE TABLE inventory.products (
    sku             VARCHAR(7) NOT NULL PRIMARY KEY,
    product_name    VARCHAR(50) NOT NULL,
    category_id     INT,
    size            INT,
    price           DECIMAL(5,2) NOT NULL
);

ALTER TABLE inventory.products
ADD CONSTRAINT fk_products_category_id FOREIGN KEY (category_id)
    REFERENCES inventory.categories (category_id)
;

-- Create a table for the Two Trees customer data
CREATE TABLE sales.customers (
    customer_id CHAR(5) NOT NULL PRIMARY KEY,
    company     VARCHAR(100),
    address     VARCHAR(100),
    city        VARCHAR(50),
    state       CHAR(2),
    zip         CHAR(5),
    newsletter  BOOLEAN
);

-- Create a table for the Two Trees order data
CREATE TABLE sales.orders (
    order_id     INT GENERATED ALWAYS AS IDENTITY (START WITH 100 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    order_date   DATE,
    customer_id  CHAR(5)
);

ALTER TABLE sales.orders
ADD CONSTRAINT fk_customers_customer_id FOREIGN KEY (customer_id)
    REFERENCES sales.customers (customer_id)
;

-- Create a table for the order's line-item data
CREATE TABLE sales.order_lines (
    order_id    INT,
    line_id     INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    sku         VARCHAR(7),
    quantity    INT
);

ALTER TABLE sales.order_lines
ADD CONSTRAINT fk_orders_order_id FOREIGN KEY (order_id)
    REFERENCES sales.orders (order_id)
;


-----------------------------------
-- INSERT DATA INTO TABLES 
-----------------------------------

-- Add data to the categories table
INSERT INTO inventory.categories
    (category_id, category_description, product_line)
VALUES
    (1, 'Olive Oils', 'Gourmet Chef'),
    (2, 'Flavor Infused Oils', 'Gourmet Chef'),
    (3, 'Bath and Beauty', 'Cosmetics')
;

-- Add data to the customers table
INSERT INTO sales.customers VALUES
    ('FV418', 'Flavorville', '798 Ravinia Road', 'Des Moines', 'IA', '50320', TRUE),
    ('WR421', 'Wild Rose', '222 Dakota Lane', 'Kalamazoo', 'MI', '49001', TRUE),
    ('BX305', 'Bread Express', '3362 Ute Loop', 'Tiffin', 'OH', '44883', FALSE),
    ('BV446', 'Blue Vine', '40675 Raymond Curve', 'Columbus', 'GA', '31901', TRUE),
    ('GR208', 'Green Gardens', '394 Mesa Palms Avenue', 'Atlanta', 'GA', '15742', FALSE),
    ('DF600', 'Delish Food', '809 Weathersfield Ctr Park', 'Madisonville', 'OH', '45227', FALSE)
;

-- Add data to the products table
INSERT INTO inventory.products
    (sku, product_name, category_id, size, price)
VALUES
    ('ALB008', 'Delicate', 1, 8, 10.99),
    ('ALB032', 'Delicate', 1, 32, 18.99),
    ('ALB064', 'Delicate', 1, 64, 22.99),
    ('ALB128', 'Delicate', 1, 128, 26.99),
    ('EV008', 'Extra Virgin', 1, 8, 8.99),
    ('EV016', 'Extra Virgin', 1, 16, 12.99),
    ('EV032', 'Extra Virgin', 1, 32, 16.99),
    ('EV064', 'Extra Virgin', 1, 64, 20.99),
    ('EV128', 'Extra Virgin', 1, 128, 24.99),
    ('FCP008', 'First Cold Press', 1, 8, 8.99),
    ('FCP016', 'First Cold Press', 1, 16, 12.99),
    ('FCP032', 'First Cold Press', 1, 32, 16.99),
    ('FCP064', 'First Cold Press', 1, 64, 20.99),
    ('FCP128', 'First Cold Press', 1, 128, 24.99),
    ('FR008', 'Frantoio', 1, 8, 10.99),
    ('FR016', 'Frantoio', 1, 16, 14.99),
    ('FR032', 'Frantoio', 1, 32, 18.99),
    ('FR064', 'Frantoio', 1, 64, 22.99),
    ('FR128', 'Frantoio', 1, 128, 26.99),
    ('HOJ008', 'Bold', 1, 8, 11.99),
    ('HOJ016', 'Bold', 1, 16, 15.99),
    ('HOJ032', 'Bold', 1, 32, 19.99),
    ('HOJ064', 'Bold', 1, 64, 23.99),
    ('HOJ128', 'Bold', 1, 128, 27.99),
    ('KRN008', 'Koroneiki', 1, 8, 10.99),
    ('KRN016', 'Koroneiki', 1, 16, 14.99),
    ('KRN032', 'Koroneiki', 1, 32, 18.99),
    ('KRN064', 'Koroneiki', 1, 64, 22.99),
    ('KRN128', 'Koroneiki', 1, 128, 26.99),
    ('LEC008', 'Leccino', 1, 8, 10.99),
    ('LEC016', 'Leccino', 1, 16, 14.99),
    ('LEC032', 'Leccino', 1, 32, 18.99),
    ('LEC064', 'Leccino', 1, 64, 22.99),
    ('LEC128', 'Leccino', 1, 128, 26.99),
    ('LGT008', 'Light', 1, 8, 8.99),
    ('LGT016', 'Light', 1, 16, 12.99),
    ('LGT032', 'Light', 1, 32, 16.99),
    ('LGT064', 'Light', 1, 64, 20.99),
    ('LGT128', 'Light', 1, 128, 24.99),
    ('MAN008', 'Manzanilla', 1, 8, 10.99),
    ('MAN016', 'Manzanilla', 1, 16, 14.99),
    ('MAN032', 'Manzanilla', 1, 32, 18.99),
    ('MAN064', 'Manzanilla', 1, 64, 22.99),
    ('MAN128', 'Manzanilla', 1, 128, 26.99),
    ('MIS008', 'Mission', 1, 8, 10.99),
    ('MIS016', 'Mission', 1, 16, 14.99),
    ('MIS032', 'Mission', 1, 32, 18.99),
    ('MIS064', 'Mission', 1, 64, 22.99),
    ('MIS128', 'Mission', 1, 128, 26.99),
    ('MOR008', 'Moraiolo', 1, 8, 10.99),
    ('MOR016', 'Moraiolo', 1, 16, 14.99),
    ('MOR032', 'Moraiolo', 1, 32, 18.99),
    ('MOR064', 'Moraiolo', 1, 64, 22.99),
    ('MOR128', 'Moraiolo', 1, 128, 26.99),
    ('OBL008', 'Oblica', 1, 8, 11.99),
    ('OBL016', 'Oblica', 1, 16, 15.99),
    ('OBL032', 'Oblica', 1, 32, 19.99),
    ('OBL064', 'Oblica', 1, 64, 22.99),
    ('OBL128', 'Oblica', 1, 128, 27.99),
    ('PEN008', 'Pendolino', 1, 8, 10.99),
    ('PEN016', 'Pendolino', 1, 16, 14.99),
    ('PEN032', 'Pendolino', 1, 32, 18.99),
    ('PEN064', 'Pendolino', 1, 64, 22.99),
    ('PEN128', 'Pendolino', 1, 128, 26.99),
    ('PCH008', 'Picholine', 1, 8, 11.99),
    ('PCH016', 'Picholine', 1, 16, 15.99),
    ('PCH032', 'Picholine', 1, 32, 19.99),
    ('PCH064', 'Picholine', 1, 64, 23.99),
    ('PCH128', 'Picholine', 1, 128, 27.99),
    ('PIC008', 'Picual', 1, 8, 10.99),
    ('PIC016', 'Picual', 1, 16, 14.99),
    ('PIC032', 'Picual', 1, 32, 18.99),
    ('PIC064', 'Picual', 1, 64, 22.99),
    ('PIC128', 'Picual', 1, 128, 26.99),
    ('PUR008', 'Pure', 1, 8, 8.99),
    ('PUR016', 'Pure', 1, 16, 12.99),
    ('PUR032', 'Pure', 1, 32, 16.99),
    ('PUR064', 'Pure', 1, 64, 20.99),
    ('PUR128', 'Pure', 1, 128, 24.99),
    ('REF008', 'Refined', 1, 8, 8.99),
    ('REF016', 'Refined', 1, 16, 12.99),
    ('REF032', 'Refined', 1, 32, 16.99),
    ('REF064', 'Refined', 1, 64, 20.99),
    ('REF128', 'Refined', 1, 128, 24.99),
    ('V008', 'Virgin', 1, 8, 8.99),
    ('V016', 'Virgin', 1, 16, 12.99),
    ('V032', 'Virgin', 1, 32, 16.99),
    ('V064', 'Virgin', 1, 64, 20.99),
    ('V128', 'Virgin', 1, 128, 24.99),
    ('MI008', 'Mandarin-Infused EVO', 2, 8, 8.99),
    ('MI016', 'Mandarin-Infused EVO', 2, 16, 12.99),
    ('MI032', 'Mandarin-Infused EVO', 2, 32, 16.99),
    ('LI008', 'Lemon-Infused EVO', 2, 8, 8.99),
    ('LI016', 'Lemon-Infused EVO', 2, 16, 12.99),
    ('LI032', 'Lemon-Infused EVO', 2, 32, 16.99),
    ('BI008', 'Basil-Infused EVO', 2, 8, 10.99),
    ('BI016', 'Basil-Infused EVO', 2, 16, 14.99),
    ('BI032', 'Basil-Infused EVO', 2, 32, 18.99),
    ('RI008', 'Rosemary-Infused EVO', 2, 8, 10.99),
    ('RI016', 'Rosemary-Infused EVO', 2, 16, 14.99),
    ('RI032', 'Rosemary-Infused EVO', 2, 32, 18.99),
    ('GI008', 'Garlic-Infused EVO', 2, 8, 11.99),
    ('GI016', 'Garlic-Infused EVO', 2, 16, 15.99),
    ('GI032', 'Garlic-Infused EVO', 2, 32, 19.99),
    ('JI008', 'Chili-Infused EVO', 2, 8, 11.99),
    ('JI016', 'Chili-Infused EVO', 2, 16, 15.99),
    ('JI032', 'Chili-Infused EVO', 2, 32, 19.99),
    ('OGEC004', 'Olive Glow eye cream', 3, 4, 18.99),
    ('OGFL006', 'Olive Glow face lotion', 3, 6, 14.99),
    ('OGBL012', 'Olive Glow body lotion', 3, 12, 12.99),
    ('OGFT006', 'Olive Glow foot treatment', 3, 6, 7.99),
    ('OGNR004', 'Olive Glow night repair', 3, 4, 21.99),
    ('OGBG016', 'Olive Glow bath gel', 3, 16, 9.99),
    ('OGHS006', 'Olive Glow hand soap', 3, 6, 6.99)
;

-- Add data to the orders table
INSERT INTO sales.orders (order_date, customer_id) VALUES
    ('2021-03-15', 'BX305'),
    ('2021-03-17', 'GR208'),
    ('2021-03-19', 'BV446'),
    ('2021-03-19', 'BV446'),
    ('2021-03-20', 'FV418'),
    ('2021-03-21', 'DF600'),
    ('2021-03-22', 'FV418'),
    ('2021-03-23', 'WR421'),
    ('2021-03-24', 'WR421'),
    ('2021-03-25', 'GR208'),
    ('2021-03-25', 'BX305'),
    ('2021-03-26', 'GR208'),
    ('2021-03-26', 'BV446'),
    ('2021-03-27', 'FV418'),
    ('2021-03-28', 'WR421'),
    ('2021-03-28', 'BV446'),
    ('2021-03-28', 'DF600'),
    ('2021-03-29', 'DF600'),
    ('2021-03-29', 'BX305'),
    ('2021-03-30', 'GR208'),
    ('2021-03-31', 'BX305'),
    ('2021-04-01', 'BX305'),
    ('2021-04-03', 'GR208'),
    ('2021-04-05', 'BV446'),
    ('2021-04-05', 'BV446'),
    ('2021-04-06', 'FV418'),
    ('2021-04-07', 'DF600'),
    ('2021-04-08', 'FV418'),
    ('2021-04-09', 'WR421'),
    ('2021-04-10', 'WR421'),
    ('2021-04-11', 'GR208'),
    ('2021-04-11', 'BX305'),
    ('2021-04-12', 'GR208'),
    ('2021-04-12', 'BV446'),
    ('2021-04-13', 'FV418'),
    ('2021-04-14', 'WR421'),
    ('2021-04-14', 'BV446'),
    ('2021-04-14', 'DF600'),
    ('2021-04-15', 'DF600'),
    ('2021-04-15', 'BX305'),
    ('2021-04-16', 'GR208'),
    ('2021-04-16', 'BX305'),
    ('2021-04-17', 'GR208'),
    ('2021-04-19', 'BV446'),
    ('2021-04-19', 'BV446'),
    ('2021-04-20', 'FV418'),
    ('2021-04-21', 'DF600'),
    ('2021-04-22', 'FV418'),
    ('2021-04-23', 'WR421'),
    ('2021-04-24', 'WR421'),
    ('2021-04-25', 'GR208'),
    ('2021-04-25', 'BX305'),
    ('2021-04-26', 'GR208'),
    ('2021-04-26', 'BV446'),
    ('2021-04-27', 'FV418'),
    ('2021-04-28', 'WR421'),
    ('2021-04-28', 'BV446'),
    ('2021-04-28', 'DF600'),
    ('2021-04-29', 'DF600'),
    ('2021-04-29', 'BX305'),
    ('2021-04-30', 'GR208')
;

-- Add data to the order_lines table
INSERT INTO sales.order_lines (order_id, sku, quantity) VALUES
    (100,  'HOJ016',  2),
    (101,  'MAN128',  2),
    (101,  'MIS032',  1),
    (101,  'PEN008',  1),
    (101,  'RI016',  1),
    (102,  'FCP128',  2),
    (102,  'FCP128',  3),
    (102,  'LGT016',  3),
    (102,  'MIS064',  1),
    (102,  'OBL008',  3),
    (103,  'FCP016',  4),
    (104,  'MIS016',  1),
    (105,  'HOJ128',  2),
    (105,  'KRN128',  4),
    (105,  'LEC008',  4),
    (106,  'JI032',  1),
    (106,  'MOR032',  2),
    (106,  'PIC016',  1),
    (106,  'RI032',  4),
    (107,  'LI016',  3),
    (107,  'PIC008',  4),
    (107,  'PIC064',  3),
    (107,  'V032',  4),
    (108,  'FCP008',  4),
    (108,  'RI008',  1),
    (109,  'EV008',  3),
    (109,  'OBL128',  2),
    (110,  'FCP008',  5),
    (110,  'LGT008',  3),
    (110,  'PUR016',  4),
    (110,  'V064',  1),
    (111,  'KRN128',  3),
    (112,  'JI032',  3),
    (112,  'OBL128',  1),
    (112,  'PCH032',  4),
    (113,  'HOJ008',  2),
    (113,  'PUR064',  2),
    (113,  'PUR128',  3),
    (113,  'REF008',  3),
    (114,  'EV128',  5),
    (115,  'FR128',  5),
    (115,  'PCH064',  4),
    (115,  'PUR064',  4),
    (116,  'FCP128',  2),
    (116,  'PEN064',  4),
    (117,  'ALB064',  3),
    (117,  'ALB128',  2),
    (117,  'GI032',  4),
    (117,  'HOJ064',  2),
    (117,  'JI016',  1),
    (117,  'PIC016',  4),
    (118,  'FR008',  2),
    (118,  'PIC016',  2),
    (118,  'REF008',  2),
    (119,  'JI016',  3),
    (119,  'MI008',  3),
    (120,  'BI008',  4),
    (120,  'EV032',  4),
    (120,  'FR064',  1),
    (120,  'PEN032',  2),
    (121,  'HOJ016',  3),
    (122,  'MAN128',  5),
    (122,  'MIS032',  4),
    (122,  'PEN008',  4),
    (122,  'RI016',  3),
    (123,  'FCP128',  1),
    (123,  'FCP128',  4),
    (123,  'LGT016',  2),
    (123,  'MIS064',  2),
    (123,  'OBL008',  3),
    (124,  'FCP016',  1),
    (125,  'MIS016',  1),
    (126,  'HOJ128',  4),
    (126,  'KRN128',  1),
    (126,  'LEC008',  4),
    (127,  'JI032',  2),
    (127,  'MOR032',  4),
    (127,  'PIC016',  2),
    (127,  'RI032',  1),
    (128,  'LI016',  2),
    (128,  'PIC008',  4),
    (128,  'PIC064',  2),
    (128,  'V032',  2),
    (129,  'FCP008',  1),
    (129,  'RI008',  2),
    (130,  'EV008',  3),
    (130,  'OBL128',  2),
    (131,  'FCP008',  3),
    (131,  'LGT008',  4),
    (131,  'PUR016',  1),
    (131,  'V064',  3),
    (132,  'KRN128',  2),
    (133,  'JI032',  3),
    (133,  'OBL128',  4),
    (133,  'PCH032',  4),
    (134,  'HOJ008',  1),
    (134,  'PUR064',  2),
    (134,  'PUR128',  1),
    (134,  'REF008',  3),
    (135,  'EV128',  2),
    (136,  'FR128',  1),
    (136,  'PCH064',  2),
    (136,  'PUR064',  2),
    (137,  'FCP128',  3),
    (137,  'PEN064',  5),
    (138,  'ALB064',  4),
    (138,  'ALB128',  4),
    (138,  'GI032',  4),
    (138,  'HOJ064',  1),
    (138,  'JI016',  2),
    (138,  'PIC016',  5),
    (139,  'FR008',  3),
    (139,  'PIC016',  4),
    (139,  'REF008',  4),
    (140,  'JI016',  3),
    (140,  'MI008',  1),
    (141,  'BI008',  1),
    (141,  'EV032',  4),
    (141,  'FR064',  1),
    (141,  'PEN032',  2),
    (141,  'HOJ016',  1),
    (142,  'MAN128',  3),
    (142,  'MIS032',  4),
    (142,  'PEN008',  3),
    (142,  'RI016',  2),
    (143,  'FCP128',  4),
    (143,  'FCP128',  4),
    (143,  'LGT016',  1),
    (143,  'MIS064',  3),
    (143,  'OBL008',  4),
    (144,  'FCP016',  4),
    (145,  'MIS016',  2),
    (146,  'HOJ128',  5),
    (146,  'KRN128',  3),
    (146,  'LEC008',  3),
    (147,  'JI032',  3),
    (147,  'MOR032',  3),
    (147,  'PIC016',  1),
    (147,  'RI032',  2),
    (148,  'LI016',  1),
    (148,  'PIC008',  2),
    (148,  'PIC064',  2),
    (148,  'V032',  1),
    (149,  'FCP008',  2),
    (149,  'RI008',  3),
    (150,  'EV008',  3),
    (150,  'OBL128',  2),
    (151,  'FCP008',  4),
    (151,  'LGT008',  2),
    (151,  'PUR016',  4),
    (151,  'V064',  5),
    (152,  'KRN128',  2),
    (153,  'JI032',  2),
    (153,  'OBL128',  5),
    (153,  'PCH032',  4),
    (154,  'HOJ008',  4),
    (154,  'PUR064',  4),
    (154,  'PUR128',  3),
    (154,  'REF008',  2),
    (155,  'EV128',  1),
    (156,  'FR128',  1),
    (156,  'PCH064',  4),
    (156,  'PUR064',  3),
    (157,  'FCP128',  3),
    (157,  'PEN064',  3),
    (158,  'ALB064',  3),
    (158,  'ALB128',  3),
    (158,  'GI032',  4),
    (158,  'HOJ064',  1),
    (158,  'JI016',  4),
    (158,  'PIC016',  1),
    (159,  'FR008',  3),
    (159,  'PIC016',  2),
    (159,  'REF008',  3),
    (160,  'JI016',  2),
    (160,  'MI008',  4)
;

--------------------------
-- REVIEW THE ENTERED DATA
--------------------------

SELECT * FROM inventory.categories;
SELECT * FROM inventory.products;
SELECT * FROM sales.customers;
SELECT * FROM sales.orders;
SELECT * FROM sales.order_lines;