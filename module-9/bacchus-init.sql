/*
    Bacchus Winery Database
    MySQL Schema
*/

DROP DATABASE IF EXISTS bacchus_winery;
CREATE DATABASE bacchus_winery;

USE bacchus_winery;


/* =========================================================
   SUPPLIER
   ========================================================= */

CREATE TABLE SUPPLIER (
                          SUPPLIER_ID INT NOT NULL AUTO_INCREMENT,
                          NAME VARCHAR(100) NOT NULL,
                          PHONE VARCHAR(20),
                          EMAIL VARCHAR(100),

                          PRIMARY KEY (SUPPLIER_ID)
);


/* =========================================================
   ITEM
   CATEGORY should be either SUPPLY or PRODUCT.
   PRODUCT represents wine sold by Bacchus Winery.
   ========================================================= */

CREATE TABLE ITEM (
                      ITEM_ID INT NOT NULL AUTO_INCREMENT,
                      NAME VARCHAR(100) NOT NULL,
                      CATEGORY VARCHAR(50) NOT NULL,
                      QUANTITY_ON_HAND INT NOT NULL DEFAULT 0,
                      REORDER_LEVEL INT NULL,

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
   Resolves many-to-many relationship between
   SUPPLIER and ITEM.
   ========================================================= */

CREATE TABLE SUPPLIER_ITEM (
                               SUPPLIER_ID INT NOT NULL,
                               ITEM_ID INT NOT NULL,
                               UNIT_COST DECIMAL(10,2) NOT NULL,

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
   ========================================================= */

CREATE TABLE PURCHASE_ORDER (
                                PURCHASE_ORDER_ID INT NOT NULL AUTO_INCREMENT,
                                SUPPLIER_ID INT NOT NULL,
                                ORDER_DATE DATE NOT NULL,
                                STATUS VARCHAR(30) NOT NULL,

                                PRIMARY KEY (PURCHASE_ORDER_ID),

                                CONSTRAINT FK_PURCHASE_ORDER_SUPPLIER
                                    FOREIGN KEY (SUPPLIER_ID)
                                        REFERENCES SUPPLIER (SUPPLIER_ID)
);


/* =========================================================
   PURCHASE_ORDER_DETAIL
   ========================================================= */

CREATE TABLE PURCHASE_ORDER_DETAIL (
                                       PURCHASE_ORDER_DETAIL_ID INT NOT NULL AUTO_INCREMENT,
                                       PURCHASE_ORDER_ID INT NOT NULL,
                                       ITEM_ID INT NOT NULL,
                                       QUANTITY INT NOT NULL,

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

CREATE TABLE PURCHASE_ORDER_DELIVERY (
                                         PURCHASE_ORDER_DELIVERY_ID INT NOT NULL AUTO_INCREMENT,
                                         PURCHASE_ORDER_ID INT NOT NULL,
                                         EXPECTED_DATE DATE NOT NULL,
                                         ACTUAL_DATE DATE NULL,

                                         PRIMARY KEY (PURCHASE_ORDER_DELIVERY_ID),

                                         CONSTRAINT FK_PURCHASE_ORDER_DELIVERY_ORDER
                                             FOREIGN KEY (PURCHASE_ORDER_ID)
                                                 REFERENCES PURCHASE_ORDER (PURCHASE_ORDER_ID)
);


/* =========================================================
   DISTRIBUTOR
   ========================================================= */

CREATE TABLE DISTRIBUTOR (
                             DISTRIBUTOR_ID INT NOT NULL AUTO_INCREMENT,
                             NAME VARCHAR(100) NOT NULL,
                             PHONE VARCHAR(20),
                             EMAIL VARCHAR(100),
                             ADDRESS VARCHAR(255),

                             PRIMARY KEY (DISTRIBUTOR_ID)
);


/* =========================================================
   DISTRIBUTOR_ITEM
   Resolves many-to-many relationship between
   DISTRIBUTOR and ITEM.
   Normally these ITEM records should be CATEGORY = PRODUCT.
   ========================================================= */

CREATE TABLE DISTRIBUTOR_ITEM (
                                  DISTRIBUTOR_ID INT NOT NULL,
                                  ITEM_ID INT NOT NULL,

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

CREATE TABLE SALES_ORDER (
                             SALES_ORDER_ID INT NOT NULL AUTO_INCREMENT,
                             DISTRIBUTOR_ID INT NOT NULL,
                             ORDER_DATE DATE NOT NULL,
                             STATUS VARCHAR(30) NOT NULL,

                             PRIMARY KEY (SALES_ORDER_ID),

                             CONSTRAINT FK_SALES_ORDER_DISTRIBUTOR
                                 FOREIGN KEY (DISTRIBUTOR_ID)
                                     REFERENCES DISTRIBUTOR (DISTRIBUTOR_ID)
);


/* =========================================================
   SALES_ORDER_DETAIL
   ========================================================= */

CREATE TABLE SALES_ORDER_DETAIL (
                                    SALES_ORDER_DETAIL_ID INT NOT NULL AUTO_INCREMENT,
                                    SALES_ORDER_ID INT NOT NULL,
                                    ITEM_ID INT NOT NULL,
                                    QUANTITY INT NOT NULL,

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

CREATE TABLE SALES_ORDER_SHIPMENT (
                                      SALES_ORDER_SHIPMENT_ID INT NOT NULL AUTO_INCREMENT,
                                      SALES_ORDER_ID INT NOT NULL,
                                      SHIPMENT_DATE DATE NULL,
                                      DELIVERY_DATE DATE NULL,
                                      STATUS VARCHAR(30) NOT NULL,

                                      PRIMARY KEY (SALES_ORDER_SHIPMENT_ID),

                                      CONSTRAINT FK_SALES_ORDER_SHIPMENT_ORDER
                                          FOREIGN KEY (SALES_ORDER_ID)
                                              REFERENCES SALES_ORDER (SALES_ORDER_ID)
);


/* =========================================================
   EMPLOYEE
   ========================================================= */

CREATE TABLE EMPLOYEE (
                          EMPLOYEE_ID INT NOT NULL AUTO_INCREMENT,
                          FIRST_NAME VARCHAR(50) NOT NULL,
                          LAST_NAME VARCHAR(50) NOT NULL,
                          JOB_TITLE VARCHAR(100) NOT NULL,

                          PRIMARY KEY (EMPLOYEE_ID)
);


/* =========================================================
   TIME_ENTRY
   ========================================================= */

CREATE TABLE TIME_ENTRY (
                            TIME_ENTRY_ID INT NOT NULL AUTO_INCREMENT,
                            EMPLOYEE_ID INT NOT NULL,
                            WORK_DATE DATE NOT NULL,
                            HOURS_WORKED DECIMAL(5,2) NOT NULL,

                            PRIMARY KEY (TIME_ENTRY_ID),

                            CONSTRAINT FK_TIME_ENTRY_EMPLOYEE
                                FOREIGN KEY (EMPLOYEE_ID)
                                    REFERENCES EMPLOYEE (EMPLOYEE_ID),

                            CONSTRAINT CHK_TIME_ENTRY_HOURS
                                CHECK (HOURS_WORKED >= 0)
);