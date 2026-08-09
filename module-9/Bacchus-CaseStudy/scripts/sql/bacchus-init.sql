/*
    Bacchus Winery Database
    MySQL Schema
*/

DROP DATABASE IF EXISTS bacchus_winery;

CREATE DATABASE bacchus_winery;

USE bacchus_winery;

DROP USER IF EXISTS 'bacchus_user'@'%'; -- Lane: I use docker and so it's not considered 'localhost'
CREATE USER 'bacchus_user'@'%' IDENTIFIED BY 'wine123';
GRANT SELECT, INSERT, UPDATE, DELETE ON bacchus_winery.* TO 'bacchus_user'@'%';

FLUSH PRIVILEGES;

/* =========================================================
   SUPPLIER
   ========================================================= */

CREATE TABLE SUPPLIER
(
    SUPPLIER_ID INT          NOT NULL AUTO_INCREMENT,
    NAME        VARCHAR(100) NOT NULL,
    PHONE       VARCHAR(20),
    EMAIL       VARCHAR(100),

    PRIMARY KEY (SUPPLIER_ID)
);


/* =========================================================
   ITEM
   CATEGORY should be either SUPPLY or PRODUCT.
   PRODUCT represents wine sold by Bacchus Winery.
   ========================================================= */

CREATE TABLE ITEM
(
    ITEM_ID          INT          NOT NULL AUTO_INCREMENT,
    NAME             VARCHAR(100) NOT NULL,
    CATEGORY         VARCHAR(50)  NOT NULL,
    QUANTITY_ON_HAND INT          NOT NULL DEFAULT 0,
    REORDER_LEVEL    INT NULL,

    PRIMARY KEY (ITEM_ID),

    CONSTRAINT CHK_ITEM_CATEGORY
        CHECK (CATEGORY IN ('SUPPLY', 'PRODUCT')),

    CONSTRAINT CHK_ITEM_QUANTITY
        CHECK (QUANTITY_ON_HAND >= 0),

    CONSTRAINT CHK_ITEM_REORDER_LEVEL
        CHECK (REORDER_LEVEL IS NULL OR REORDER_LEVEL >= 0)
);


/* =========================================================
   SUPPLIER_ITEM
   ========================================================= */

CREATE TABLE SUPPLIER_ITEM
(
    SUPPLIER_ID INT            NOT NULL,
    ITEM_ID     INT            NOT NULL,
    UNIT_COST   DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (SUPPLIER_ID, ITEM_ID),

    CONSTRAINT FK_SUPPLIER_ITEM_SUPPLIER
        FOREIGN KEY (SUPPLIER_ID)
            REFERENCES SUPPLIER (SUPPLIER_ID),

    CONSTRAINT FK_SUPPLIER_ITEM_ITEM
        FOREIGN KEY (ITEM_ID)
            REFERENCES ITEM (ITEM_ID),

    CONSTRAINT CHK_SUPPLIER_ITEM_UNIT_COST
        CHECK (UNIT_COST >= 0)
);


/* =========================================================
   PURCHASE_ORDER
   =========================================================
*/

CREATE TABLE PURCHASE_ORDER
(
    PURCHASE_ORDER_ID INT         NOT NULL AUTO_INCREMENT,
    SUPPLIER_ID       INT         NOT NULL,
    ORDER_DATE        DATE        NOT NULL,
    STATUS            VARCHAR(30) NOT NULL,

    PRIMARY KEY (PURCHASE_ORDER_ID),

    CONSTRAINT FK_PURCHASE_ORDER_SUPPLIER
        FOREIGN KEY (SUPPLIER_ID)
            REFERENCES SUPPLIER (SUPPLIER_ID)
);


/* =========================================================
   PURCHASE_ORDER_DETAIL
   ========================================================= */

CREATE TABLE PURCHASE_ORDER_DETAIL
(
    PURCHASE_ORDER_DETAIL_ID INT NOT NULL AUTO_INCREMENT,
    PURCHASE_ORDER_ID        INT NOT NULL,
    ITEM_ID                  INT NOT NULL,
    QUANTITY                 INT NOT NULL,

    PRIMARY KEY (PURCHASE_ORDER_DETAIL_ID),

    CONSTRAINT FK_PURCHASE_ORDER_DETAIL_ORDER
        FOREIGN KEY (PURCHASE_ORDER_ID)
            REFERENCES PURCHASE_ORDER (PURCHASE_ORDER_ID),

    CONSTRAINT FK_PURCHASE_ORDER_DETAIL_ITEM
        FOREIGN KEY (ITEM_ID)
            REFERENCES ITEM (ITEM_ID),

    CONSTRAINT CHK_PURCHASE_ORDER_DETAIL_QUANTITY
        CHECK (QUANTITY > 0),

    CONSTRAINT UQ_PURCHASE_ORDER_DETAIL_ITEM
        UNIQUE (PURCHASE_ORDER_ID, ITEM_ID)
);


/* =========================================================
   PURCHASE_ORDER_DELIVERY
   Allows a purchase order to have multiple deliveries.
   ========================================================= */

CREATE TABLE PURCHASE_ORDER_DELIVERY
(
    PURCHASE_ORDER_DELIVERY_ID INT  NOT NULL AUTO_INCREMENT,
    PURCHASE_ORDER_ID          INT  NOT NULL,
    EXPECTED_DATE              DATE NOT NULL,
    ACTUAL_DATE                DATE NULL,

    PRIMARY KEY (PURCHASE_ORDER_DELIVERY_ID),

    CONSTRAINT FK_PURCHASE_ORDER_DELIVERY_ORDER
        FOREIGN KEY (PURCHASE_ORDER_ID)
            REFERENCES PURCHASE_ORDER (PURCHASE_ORDER_ID)
);


/* =========================================================
   DISTRIBUTOR
   ========================================================= */

CREATE TABLE DISTRIBUTOR
(
    DISTRIBUTOR_ID INT          NOT NULL AUTO_INCREMENT,
    NAME           VARCHAR(100) NOT NULL,
    PHONE          VARCHAR(20),
    EMAIL          VARCHAR(100),
    ADDRESS        VARCHAR(255),

    PRIMARY KEY (DISTRIBUTOR_ID)
);


/* =========================================================
   DISTRIBUTOR_ITEM
   Resolves many-to-many relationship between
   DISTRIBUTOR and ITEM.
   Normally these ITEM records should be CATEGORY = PRODUCT.
   ========================================================= */

CREATE TABLE DISTRIBUTOR_ITEM
(
    DISTRIBUTOR_ID INT NOT NULL,
    ITEM_ID        INT NOT NULL,

    PRIMARY KEY (DISTRIBUTOR_ID, ITEM_ID),

    CONSTRAINT FK_DISTRIBUTOR_ITEM_DISTRIBUTOR
        FOREIGN KEY (DISTRIBUTOR_ID)
            REFERENCES DISTRIBUTOR (DISTRIBUTOR_ID),

    CONSTRAINT FK_DISTRIBUTOR_ITEM_ITEM
        FOREIGN KEY (ITEM_ID)
            REFERENCES ITEM (ITEM_ID)
);


/* =========================================================
   SALES_ORDER
   ========================================================= */

CREATE TABLE SALES_ORDER
(
    SALES_ORDER_ID INT         NOT NULL AUTO_INCREMENT,
    DISTRIBUTOR_ID INT         NOT NULL,
    ORDER_DATE     DATE        NOT NULL,
    STATUS         VARCHAR(30) NOT NULL,

    PRIMARY KEY (SALES_ORDER_ID),

    CONSTRAINT FK_SALES_ORDER_DISTRIBUTOR
        FOREIGN KEY (DISTRIBUTOR_ID)
            REFERENCES DISTRIBUTOR (DISTRIBUTOR_ID)
);


/* =========================================================
   SALES_ORDER_DETAIL
   ========================================================= */

CREATE TABLE SALES_ORDER_DETAIL
(
    SALES_ORDER_DETAIL_ID INT NOT NULL AUTO_INCREMENT,
    SALES_ORDER_ID        INT NOT NULL,
    ITEM_ID               INT NOT NULL,
    QUANTITY              INT NOT NULL,

    PRIMARY KEY (SALES_ORDER_DETAIL_ID),

    CONSTRAINT FK_SALES_ORDER_DETAIL_ORDER
        FOREIGN KEY (SALES_ORDER_ID)
            REFERENCES SALES_ORDER (SALES_ORDER_ID),

    CONSTRAINT FK_SALES_ORDER_DETAIL_ITEM
        FOREIGN KEY (ITEM_ID)
            REFERENCES ITEM (ITEM_ID),

    CONSTRAINT CHK_SALES_ORDER_DETAIL_QUANTITY
        CHECK (QUANTITY > 0),

    CONSTRAINT UQ_SALES_ORDER_DETAIL_ITEM
        UNIQUE (SALES_ORDER_ID, ITEM_ID)
);


/* =========================================================
   SALES_ORDER_SHIPMENT
   Allows a sales order to be split into multiple shipments.
   ========================================================= */

CREATE TABLE SALES_ORDER_SHIPMENT
(
    SALES_ORDER_SHIPMENT_ID INT         NOT NULL AUTO_INCREMENT,
    SALES_ORDER_ID          INT         NOT NULL,
    SHIPMENT_DATE           DATE NULL,
    DELIVERY_DATE           DATE NULL,
    STATUS                  VARCHAR(30) NOT NULL,

    PRIMARY KEY (SALES_ORDER_SHIPMENT_ID),

    CONSTRAINT FK_SALES_ORDER_SHIPMENT_ORDER
        FOREIGN KEY (SALES_ORDER_ID)
            REFERENCES SALES_ORDER (SALES_ORDER_ID)
);


/* =========================================================
   EMPLOYEE
   ========================================================= */

CREATE TABLE EMPLOYEE
(
    EMPLOYEE_ID INT          NOT NULL AUTO_INCREMENT,
    FIRST_NAME  VARCHAR(50)  NOT NULL,
    LAST_NAME   VARCHAR(50)  NOT NULL,
    JOB_TITLE   VARCHAR(100) NOT NULL,

    PRIMARY KEY (EMPLOYEE_ID)
);


/* =========================================================
   TIME_ENTRY
   ========================================================= */

CREATE TABLE TIME_ENTRY
(
    TIME_ENTRY_ID INT           NOT NULL AUTO_INCREMENT,
    EMPLOYEE_ID   INT           NOT NULL,
    WORK_DATE     DATE          NOT NULL,
    HOURS_WORKED  DECIMAL(5, 2) NOT NULL,

    PRIMARY KEY (TIME_ENTRY_ID),

    CONSTRAINT FK_TIME_ENTRY_EMPLOYEE
        FOREIGN KEY (EMPLOYEE_ID)
            REFERENCES EMPLOYEE (EMPLOYEE_ID),

    CONSTRAINT CHK_TIME_ENTRY_HOURS
        CHECK (HOURS_WORKED >= 0)
);

/* =========================================================
   BACCHUS WINERY SAMPLE DATA
   ========================================================= */


/* =========================================================
   SUPPLIER
   ========================================================= */

INSERT INTO SUPPLIER (NAME, PHONE, EMAIL)
VALUES
    ('California Bottle & Cork Co.', '707-555-0101', 'sales@calbottlecork.com'),
    ('Premier Labels & Packaging', '707-555-0102', 'orders@premierlabels.com'),
    ('Wine Equipment Supply', '707-555-0103', 'sales@wineequipment.com');


/* =========================================================
   ITEM

   SUPPLY  = items used by Bacchus Winery
   PRODUCT = wines produced and sold by Bacchus Winery
   ========================================================= */

INSERT INTO ITEM
    (NAME, CATEGORY, QUANTITY_ON_HAND, REORDER_LEVEL)
VALUES
    ('Bottle',     'SUPPLY',  2500, 500),
    ('Cork',       'SUPPLY',  3000, 750),
    ('Label',      'SUPPLY',  2200, 500),
    ('Box',        'SUPPLY',   500, 100),
    ('Vat',        'SUPPLY',    12, 2),
    ('Tubing',     'SUPPLY',   250, 50),
    ('Merlot',     'PRODUCT',  850, NULL),
    ('Cabernet',   'PRODUCT',  720, NULL),
    ('Chablis',    'PRODUCT',  640, NULL),
    ('Chardonnay', 'PRODUCT',  910, NULL);


/* =========================================================
   SUPPLIER_ITEM

   Composite PK: SUPPLIER_ID + ITEM_ID

   Some items are intentionally available from more than
   one supplier to demonstrate the many-to-many relationship.
   ========================================================= */

INSERT INTO SUPPLIER_ITEM
    (SUPPLIER_ID, ITEM_ID, UNIT_COST)
VALUES
    (1, 1, 0.65),     -- Bottle
    (1, 2, 0.18),     -- Cork

    (2, 3, 0.12),     -- Label
    (2, 4, 1.25),     -- Box

    (3, 5, 850.00),   -- Vat
    (3, 6, 2.75);     -- Tubing


/* =========================================================
   PURCHASE_ORDER
   ========================================================= */

INSERT INTO PURCHASE_ORDER
    (SUPPLIER_ID, ORDER_DATE, STATUS)
VALUES
    (1, '2026-01-05', 'DELIVERED'),
    (2, '2026-01-15', 'DELIVERED'),
    (3, '2026-02-03', 'DELIVERED'),
    (1, '2026-02-20', 'DELIVERED'),
    (2, '2026-03-10', 'DELIVERED'),
    (3, '2026-04-01', 'DELIVERED');


/* =========================================================
   PURCHASE_ORDER_DETAIL
   ========================================================= */

INSERT INTO PURCHASE_ORDER_DETAIL
    (PURCHASE_ORDER_ID, ITEM_ID, QUANTITY)
VALUES
    (1, 1, 1000),     -- Bottles
    (2, 2, 1500),     -- Corks
    (3, 3, 1000),     -- Labels
    (4, 4, 250),      -- Boxes
    (5, 5, 2),        -- Vats
    (5, 6, 100),      -- Tubing
    (6, 1, 500),      -- Bottles
    (6, 2, 500),      -- Corks
    (6, 3, 500);      -- Labels


/* =========================================================
   PURCHASE_ORDER_DELIVERY

   Dates intentionally include both on-time and late
   deliveries so monthly supplier performance can be queried.
   ========================================================= */

INSERT INTO PURCHASE_ORDER_DELIVERY
    (PURCHASE_ORDER_ID, EXPECTED_DATE, ACTUAL_DATE)
VALUES
    (1, '2026-01-12', '2026-01-12'),
    (2, '2026-01-22', '2026-01-24'),
    (3, '2026-02-10', '2026-02-09'),
    (4, '2026-02-27', '2026-03-02'),
    (5, '2026-03-20', '2026-03-20'),
    (6, '2026-04-10', '2026-04-12');


/* =========================================================
   DISTRIBUTOR
   ========================================================= */

INSERT INTO DISTRIBUTOR
    (NAME, PHONE, EMAIL, ADDRESS)
VALUES
    ('Napa Wine Distribution',
     '707-555-0201',
     'orders@napawinedist.com',
     '100 Market St, Napa, CA'),

    ('Bay Area Wine Supply',
     '415-555-0202',
     'orders@bayareawine.com',
     '225 Mission St, San Francisco, CA'),

    ('Sacramento Beverage Company',
     '916-555-0203',
     'sales@sacbeverage.com',
     '310 Capitol Ave, Sacramento, CA'),

    ('Central Valley Distributors',
     '209-555-0204',
     'orders@cvdistributors.com',
     '455 Main St, Modesto, CA'),

    ('Southern California Wine Group',
     '213-555-0205',
     'orders@socalwine.com',
     '725 Spring St, Los Angeles, CA'),

    ('Pacific Coast Beverage',
     '619-555-0206',
     'sales@pacificbeverage.com',
     '810 Harbor Dr, San Diego, CA');


/* =========================================================
   DISTRIBUTOR_ITEM

   Only PRODUCT items are associated with distributors.

   Item IDs:
       7  = Merlot
       8  = Cabernet
       9  = Chablis
       10 = Chardonnay
   ========================================================= */

INSERT INTO DISTRIBUTOR_ITEM
    (DISTRIBUTOR_ID, ITEM_ID)
VALUES
    (1, 7),
    (1, 8),
    (1, 10),

    (2, 7),
    (2, 9),

    (3, 8),
    (3, 10),

    (4, 7),
    (4, 8),
    (4, 9),

    (5, 8),
    (5, 10),

    (6, 7),
    (6, 9),
    (6, 10);


/* =========================================================
   SALES_ORDER
   ========================================================= */

INSERT INTO SALES_ORDER
    (DISTRIBUTOR_ID, ORDER_DATE, STATUS)
VALUES
    (1, '2026-04-05', 'DELIVERED'),
    (2, '2026-04-12', 'DELIVERED'),
    (3, '2026-05-03', 'DELIVERED'),
    (4, '2026-05-18', 'DELIVERED'),
    (5, '2026-06-02', 'SHIPPED'),
    (6, '2026-06-15', 'PROCESSING');


/* =========================================================
   SALES_ORDER_DETAIL
   ========================================================= */

INSERT INTO SALES_ORDER_DETAIL
    (SALES_ORDER_ID, ITEM_ID, QUANTITY)
VALUES
    (1, 7, 120),      -- Merlot
    (1, 8, 80),       -- Cabernet

    (2, 7, 100),      -- Merlot
    (2, 9, 75),       -- Chablis

    (3, 8, 150),      -- Cabernet
    (3, 10, 100),     -- Chardonnay

    (4, 7, 90),       -- Merlot
    (4, 9, 110),      -- Chablis

    (5, 8, 125),      -- Cabernet
    (5, 10, 140),     -- Chardonnay

    (6, 7, 75),       -- Merlot
    (6, 10, 125);     -- Chardonnay


/* =========================================================
   SALES_ORDER_SHIPMENT

   NULL delivery dates represent shipments that have
   not yet been delivered.
   ========================================================= */

INSERT INTO SALES_ORDER_SHIPMENT
    (SALES_ORDER_ID, SHIPMENT_DATE, DELIVERY_DATE, STATUS)
VALUES
    (1, '2026-04-07', '2026-04-09', 'DELIVERED'),
    (2, '2026-04-14', '2026-04-17', 'DELIVERED'),
    (3, '2026-05-05', '2026-05-08', 'DELIVERED'),
    (4, '2026-05-20', '2026-05-23', 'DELIVERED'),
    (5, '2026-06-04', NULL, 'IN_TRANSIT'),
    (6, NULL, NULL, 'PENDING');


/* =========================================================
   EMPLOYEE
   ========================================================= */

INSERT INTO EMPLOYEE
    (FIRST_NAME, LAST_NAME, JOB_TITLE)
VALUES
    ('Stan', 'Bacchus', 'Co-Owner'),
    ('Davis', 'Bacchus', 'Co-Owner'),
    ('Janet', 'Collins', 'Finance and Payroll Manager'),
    ('Roz', 'Murphy', 'Marketing Manager'),
    ('Bob', 'Ulrich', 'Production Manager'),
    ('Henry', 'Doyle', 'Distribution Manager');


/* =========================================================
   TIME_ENTRY

   Multiple entries per employee demonstrate the
   one-to-many relationship.
   ========================================================= */

INSERT INTO TIME_ENTRY
    (EMPLOYEE_ID, WORK_DATE, HOURS_WORKED)
VALUES
    (1, '2026-03-31', 40.00),
    (2, '2026-03-31', 40.00),
    (3, '2026-03-31', 38.50),
    (4, '2026-03-31', 40.00),
    (5, '2026-03-31', 42.00),
    (6, '2026-03-31', 41.00),

    (1, '2026-06-30', 40.00),
    (2, '2026-06-30', 40.00),
    (3, '2026-06-30', 39.00),
    (4, '2026-06-30', 40.00),
    (5, '2026-06-30', 44.00),
    (6, '2026-06-30', 42.00);