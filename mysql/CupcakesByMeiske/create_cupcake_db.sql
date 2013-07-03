/* ************************************************************************
* AUTHOR:  Craig W. Christensen
* DATE:    December 16, 2012
* CONTENT: CUPCAKE, FILLING, DECORATION, COLOR, PRICE, CLIENT,
* 					CUPCAKE_ORDER
* DESCRIPTION: Database structure for CupcakesByMeiske.cwcraigo.com.
************************************************************************ */
TEE create_cupcake_db.txt;

USE cupcakedb;

SET FOREIGN_KEY_CHECKS = 0;

-- SELECT "TABLES" AS "DROP";
DROP TABLE IF EXISTS system_user;
DROP TABLE IF EXISTS cupcake;
DROP TABLE IF EXISTS filling;
DROP TABLE IF EXISTS decoration;
DROP TABLE IF EXISTS color;
DROP TABLE IF EXISTS price;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS cupcake_order;
DROP TABLE IF EXISTS picture;

/* ********************************
*           SYSTEM_USER
* ******************************* */
-- SELECT 'TABLE' AS 'SYSTEM_USER';
CREATE TABLE system_user
( system_user_id        INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, system_user_name      VARCHAR(20)     NOT NULL
, system_user_password 	VARCHAR(60) 		NOT NULL
, system_user_group_id  INT UNSIGNED    NOT NULL);

-- SELECT 'SYSTEM_USER' AS 'INSERT';
INSERT INTO system_user VALUES
 (NULL, 'admin', 'admin', 0)
,(NULL, 'user', 'user', 1);

-- SELECT "CUPCAKE" AS "CREATE TABLE";
CREATE TABLE cupcake
( cupcake_id 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, cupcake_flavor 		VARCHAR(30)  NOT NULL
, active_flag     	VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE'
, date_removed    	DATE 				 DEFAULT NULL
, last_update_date  TIMESTAMP  	 ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL
, CONSTRAINT cupcake_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

-- SELECT 'CUPCAKE' AS 'INSERT';
INSERT INTO cupcake (cupcake_flavor) VALUES
('Vanilla'),('White'),('Yellow'),('German Chocolate')
,('Chocolate Fudge'),('Devil\'s Food'),('Red Velvet')
,('Spice'),('Carrot'),('Lemon'),('Strawberry'),('Rainbow Chip');

-- SELECT "FILLING" AS "CREATE TABLE";
CREATE TABLE filling
( filling_id 			INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, filling_flavor 	VARCHAR(30)  NOT NULL
, active_flag     VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE'
, date_removed    DATE 				 DEFAULT NULL
, last_update_date  TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL
, CONSTRAINT filling_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

-- SELECT 'FILLING' AS 'INSERT';
INSERT INTO filling (filling_flavor) VALUES
('Butter Cream'),('Cream Cheese'),('Bavarian Cream'),('Peach')
,('Blueberry'),('Raspberry'),('Strawberry'),('Cherry')
,('Lemon'),('Pineapple'),('Apple');

-- SELECT "DECORATION" AS "CREATE TABLE";
CREATE TABLE decoration
( decoration_id 	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, decoration 			VARCHAR(30)  NOT NULL
, extra_charge 		INT UNSIGNED
, active_flag     VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE'
, date_removed    DATE 				 DEFAULT NULL
, last_update_date  TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL
, CONSTRAINT decoration_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

-- SELECT 'DECORATION' AS 'INSERT';
INSERT INTO decoration (decoration) VALUES
('Sprinkles'),('Glitter'),('Edible Pearls'),('Peach')
,('Flowers'),('Candy'),('Fruit');

-- SELECT "COLOR" AS "CREATE TABLE";
CREATE TABLE color
( color_id 			INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, color  				VARCHAR(30)  	NOT NULL
, active_flag   VARCHAR(10)  	NOT NULL DEFAULT 'ACTIVE'
, date_removed  DATE 					DEFAULT NULL
, last_update_date  TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL
, CONSTRAINT color_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

-- SELECT 'COLOR' AS 'INSERT';
INSERT INTO color (color) VALUES
('Red'),('Orange'),('Yellow'),('Green'),('Blue')
,('Purple'),('Pink'),('Brown'),('White'),('Black');

-- SELECT "PRICE" AS "CREATE TABLE";
CREATE TABLE price
( price_id 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, quantity 					INT UNSIGNED NOT NULL
, with_out_filling  INT UNSIGNED NOT NULL
, with_filling 		 	INT UNSIGNED NOT NULL
, last_update_date  TIMESTAMP    ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL);

-- SELECT 'PRICE' AS 'INSERT';
INSERT INTO price (quantity,with_out_filling,with_filling)
VALUES (2,45,50),(3,65,70),(4,85,90);

-- SELECT "CLIENT" AS "CREATE TABLE";
CREATE TABLE client
( client_id         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, first_name        VARCHAR(20)  NOT NULL
, middle_name       VARCHAR(20)
, last_name         VARCHAR(40)  NOT NULL
, email             VARCHAR(60)
, phone 						VARCHAR(20)
, creation_date     DATE         NOT NULL
, last_update_date  TIMESTAMP    ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL);

-- SELECT "CUPCAKE_ORDER" AS "CREATE TABLE";
CREATE TABLE cupcake_order
( order_id 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, client_id 				INT UNSIGNED NOT NULL
, cupcake_id 				INT UNSIGNED NOT NULL
, filling_id 				INT UNSIGNED
, cupcake_color 		INT UNSIGNED
, frosting_color 		INT UNSIGNED
, decoration_id 		INT UNSIGNED
, price_id 					INT UNSIGNED NOT NULL
, order_status 			VARCHAR(10)  NOT NULL DEFAULT 'NO STATUS'
, creation_date     DATE         NOT NULL
, last_update_date  TIMESTAMP    ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL
, CONSTRAINT cupcake_order_cc1 CHECK (order_status IN ('NO STATUS','COMPLETED','CANCELED'))
, KEY cupcake_order_fk1 (client_id)
, CONSTRAINT cupcake_order_fk1 FOREIGN KEY (client_id) REFERENCES client (client_id)
, KEY cupcake_order_fk2 (cupcake_id)
, CONSTRAINT cupcake_order_fk2 FOREIGN KEY (cupcake_id) REFERENCES cupcake (cupcake_id)
, KEY cupcake_order_fk3 (filling_id)
, CONSTRAINT cupcake_order_fk3 FOREIGN KEY (filling_id) REFERENCES filling (filling_id)
, KEY cupcake_order_fk4 (cupcake_color)
, CONSTRAINT cupcake_order_fk4 FOREIGN KEY (cupcake_color) REFERENCES color (color_id)
, KEY cupcake_order_fk5 (frosting_color)
, CONSTRAINT cupcake_order_fk5 FOREIGN KEY (frosting_color) REFERENCES color (color_id)
, KEY cupcake_order_fk6 (decoration_id)
, CONSTRAINT cupcake_order_fk6 FOREIGN KEY (decoration_id) REFERENCES decoration (decoration_id)
, KEY cupcake_order_fk7 (price_id)
, CONSTRAINT cupcake_order_fk7 FOREIGN KEY (price_id) REFERENCES price (price_id));

-- SELECT "PICTURE" AS "CREATE TABLE";
CREATE TABLE picture
( picture_id        INT UNSIGNED 	PRIMARY KEY AUTO_INCREMENT
, path        			VARCHAR(255)  NOT NULL
, thumbnail        	VARCHAR(255)  NOT NULL
, description       VARCHAR(255)
, creation_date     DATE         	NOT NULL
, last_update_date  TIMESTAMP    	ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT NULL);


-- COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

NOTEE