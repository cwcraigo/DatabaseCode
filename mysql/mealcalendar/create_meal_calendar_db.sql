/* ************************************************************************
* AUTHOR:  Craig W. Christensen
* DATE:    December 9, 2012
* CONTENT: CLIENT, SYSTEM_USER, MEAL_SCHEDULE, COMMON_LOOKUP, RECIPE,
*           INGREDIENT, MEASUREMENT, PRODUCT.
* DESCRIPTION: Database structure for mealcalendar.cwcraigo.com.
************************************************************************ */

TEE mealcalendar/create_meal_calendar_db.txt;

USE mealcalendar;

SET FOREIGN_KEY_CHECKS = 0;

/* ********************************
*           SYSTEM_USER
* ******************************* */
SELECT 'TABLE' AS 'SYSTEM_USER';
DROP TABLE IF EXISTS system_user;
CREATE TABLE system_user
( system_user_id        INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, system_user_name      VARCHAR(20)     NOT NULL
, system_user_group_id  INT UNSIGNED    NOT NULL);

SELECT 'SYSTEM_USER' AS 'INSERT';
INSERT INTO system_user VALUES
 (NULL, 'administrator', 0)
,(NULL, 'user', 1);

/* ********************************
*           COMMON_LOOKUP
* ******************************* */
SELECT 'TABLE' AS 'COMMON_LOOKUP';
DROP TABLE IF EXISTS common_lookup;
CREATE TABLE common_lookup
( common_lookup_id      INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, common_lookup_context VARCHAR(30)     NOT NULL
, common_lookup_type    VARCHAR(30)     NOT NULL
, common_lookup_meaning VARCHAR(30));

SELECT 'COMMON_LOOKUP' AS 'INSERT';
INSERT INTO common_lookup VALUES
 (NULL, 'MONTH_NAME', 'January',            NULL)
,(NULL, 'MONTH_NAME', 'February',           NULL)
,(NULL, 'MONTH_NAME', 'March',              NULL)
,(NULL, 'MONTH_NAME', 'April',              NULL)
,(NULL, 'MONTH_NAME', 'May',                NULL)
,(NULL, 'MONTH_NAME', 'June',               NULL)
,(NULL, 'MONTH_NAME', 'July',               NULL)
,(NULL, 'MONTH_NAME', 'August',             NULL)
,(NULL, 'MONTH_NAME', 'September',          NULL)
,(NULL, 'MONTH_NAME', 'October',            NULL)
,(NULL, 'MONTH_NAME', 'November',           NULL)
,(NULL, 'MONTH_NAME', 'December',           NULL)
,(NULL, 'MEAL_TIME',  'Breakfast',          NULL)
,(NULL, 'MEAL_TIME',  'Lunch',              NULL)
,(NULL, 'MEAL_TIME',  'Dinner',             NULL)
,(NULL, 'MEAL_TIME',  'Snacks',             NULL)
,(NULL, 'CATEGORY',   'Appetizers/Drinks',  'Dips')
,(NULL, 'CATEGORY',   'Appetizers/Drinks',  'Hot Drinks')
,(NULL, 'CATEGORY',   'Appetizers/Drinks',  'Cold Drinks')
,(NULL, 'CATEGORY',   'Appetizers/Drinks',  'Snack')
,(NULL, 'CATEGORY',   'Appetizers/Drinks',  'Other Appetizers/Drinks')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Fruit Salads')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Gelatin Salads')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Salad Dressings')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Veggie Salads')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Meat Salads')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Pasta/Rice Salads')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Soups/Stews')
,(NULL, 'CATEGORY',   'Soups/Salads',       'Other Soups/Salads')
,(NULL, 'CATEGORY',   'Side Dishes',        'Rice/Beans')
,(NULL, 'CATEGORY',   'Side Dishes',        'Potatoes')
,(NULL, 'CATEGORY',   'Side Dishes',        'Stuffing')
,(NULL, 'CATEGORY',   'Side Dishes',        'Pasta/Noodle')
,(NULL, 'CATEGORY',   'Side Dishes',        'Veggie')
,(NULL, 'CATEGORY',   'Side Dishes',        'Other Side Dishes')
,(NULL, 'CATEGORY',   'Main Dishes',        'Beef')
,(NULL, 'CATEGORY',   'Main Dishes',        'Egg')
,(NULL, 'CATEGORY',   'Main Dishes',        'Vegetarian')
,(NULL, 'CATEGORY',   'Main Dishes',        'Pasta')
,(NULL, 'CATEGORY',   'Main Dishes',        'Pizza')
,(NULL, 'CATEGORY',   'Main Dishes',        'Pork')
,(NULL, 'CATEGORY',   'Main Dishes',        'Poultry')
,(NULL, 'CATEGORY',   'Main Dishes',        'Sandwiches')
,(NULL, 'CATEGORY',   'Main Dishes',        'Seafood')
,(NULL, 'CATEGORY',   'Main Dishes',        'Other Main Dishes')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Biscuits')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Muffins')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Quick Breads')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Rolls')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Waffle/Pancake/French Toast')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Yeast Breads')
,(NULL, 'CATEGORY',   'Breads/Rolls',       'Other Breads/Rolls')
,(NULL, 'CATEGORY',   'Desserts',           'Brownies/Bars')
,(NULL, 'CATEGORY',   'Desserts',           'Cakes')
,(NULL, 'CATEGORY',   'Desserts',           'Cupcakes')
,(NULL, 'CATEGORY',   'Desserts',           'Cobblers/Crumbcakes')
,(NULL, 'CATEGORY',   'Desserts',           'Toppings/Icings/Frostings')
,(NULL, 'CATEGORY',   'Desserts',           'Frozen Dessert')
,(NULL, 'CATEGORY',   'Desserts',           'Pies')
,(NULL, 'CATEGORY',   'Desserts',           'Pudding/Mousse')
,(NULL, 'CATEGORY',   'Desserts',           'Other Desserts')
,(NULL, 'CATEGORY',   'Cookies/Candy',      'Candy')
,(NULL, 'CATEGORY',   'Cookies/Candy',      'Cookies')
,(NULL, 'CATEGORY',   'Cookies/Candy',      'Snack')
,(NULL, 'CATEGORY',   'Cookies/Candy',      'Other Cookies/Candy')
,(NULL, 'CATEGORY',   'Misc',               'Baby Food')
,(NULL, 'CATEGORY',   'Misc',               'Perserves/Jams/Jellies')
,(NULL, 'CATEGORY',   'Misc',               'Salsa')
,(NULL, 'CATEGORY',   'Misc',               'Sausage/Jerky')
,(NULL, 'CATEGORY',   'Misc',               'Canning')
,(NULL, 'CATEGORY',   'Misc',               'Fruits')
,(NULL, 'CATEGORY',   'Misc',               'Marinades/Rubs/Spices')
,(NULL, 'CATEGORY',   'Misc',               'Pickles/Relish')
,(NULL, 'CATEGORY',   'Misc',               'Sauces/Spreads/Dressings')
,(NULL, 'CATEGORY',   'Misc',               'Other');

/* ********************************
*             CLIENT
* ******************************* */
SELECT 'TABLE' AS 'CLIENT';
DROP TABLE IF EXISTS client;

CREATE TABLE client
( client_id         INT UNSIGNED    PRIMARY KEY   AUTO_INCREMENT
, system_user_id    INT UNSIGNED    NOT NULL
, first_name        VARCHAR(20)     NOT NULL
, middle_name       VARCHAR(20)
, last_name         VARCHAR(40)     NOT NULL
, user_name         VARCHAR(50)     NOT NULL
, password          VARCHAR(60)     NOT NULL
, email             VARCHAR(60)     NOT NULL
, creation_date     DATE            NOT NULL
, last_update_date  TIMESTAMP       ON UPDATE CURRENT_TIMESTAMP
, active_flag       VARCHAR(10)     NOT NULL DEFAULT 'ACTIVE'
, date_removed      DATE
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE'))
, KEY client_fk1 (system_user_id)
, CONSTRAINT client_fk1 FOREIGN KEY (system_user_id) REFERENCES system_user (system_user_id)
);

-- ----------------------------------------------------------------------
-- hash_password_insert_trigger/hash_password_update_trigger TRIGGERS
-- ----------------------------------------------------------------------
-- authenticate_password(password, client_id) FUNCTION
-- ----------------------------------------------------------------------
DELIMITER $$
SELECT 'hash_password_insert_trigger' AS 'TRIGGER'$$
DROP TRIGGER IF EXISTS hash_password_insert_trigger$$
CREATE TRIGGER hash_password_insert_trigger
BEFORE INSERT ON client
FOR EACH ROW
BEGIN
  SET new.password = PASSWORD(new.password);
END;
$$
SELECT 'hash_password_update_trigger' AS 'TRIGGER'$$
DROP TRIGGER IF EXISTS hash_password_update_trigger$$
CREATE TRIGGER hash_password_update_trigger
BEFORE UPDATE ON client
FOR EACH ROW
BEGIN
  SET new.password = PASSWORD(new.password);
END;
$$

-- SELECT 'logInClient' AS 'PROCEDURE'$$
-- DROP PROCEDURE IF EXISTS logInClient$$
-- CREATE PROCEDURE logInClient
-- ( pv_user_name 					VARCHAR(60)
-- , pv_password 					VARCHAR(60))
-- BEGIN
-- 	DECLARE client_id 				INT UNSIGNED;
-- 	DECLARE system_user_id 		INT UNSIGNED;
-- 	DECLARE first_name 				VARCHAR(20);
-- 	DECLARE middle_name 			VARCHAR(20);
-- 	DECLARE last_name 				VARCHAR(40);
-- 	DECLARE user_name 				VARCHAR(50);
-- 	DECLARE password 					VARCHAR(60);
-- 	DECLARE email 						VARCHAR(60);
-- 	DECLARE creation_date 		DATE;
-- 	DECLARE last_update_date 	TIMESTAMP;
-- 	DECLARE active_flag 			VARCHAR(10);
-- 	DECLARE date_removed 			DATE;

--   DECLARE lv_fetched  INT UNSIGNED DEFAULT 0;
--   DECLARE c CURSOR FOR
--     SELECT *
--     FROM client c
--     WHERE c.user_name = pv_user_name
--     AND c.password = PASSWORD(pv_password);
--   DECLARE CONTINUE HANDLER FOR NOT FOUND SET lv_fetched = 1;
--   OPEN c;
--   FETCH c INTO client_id,system_user_id
--   						,first_name,middle_name,last_name
--   						,user_name,password,email
--   						,creation_date,last_update_date
--   						,active_flag,date_removed;
--   IF lv_fetched = 0 THEN
--   	SELECT client_id,system_user_id
-- 					,first_name,middle_name,last_name
-- 					,user_name,password,email
-- 					,creation_date,last_update_date
-- 					,active_flag,date_removed;
--   END IF;
--   CLOSE c;
-- END;
-- $$

DELIMITER ;

SELECT 'CLIENT' AS 'INSERT';
INSERT INTO client (system_user_id, first_name, middle_name, last_name
									 ,user_name, password, email, creation_date) VALUES
( (SELECT system_user_id FROM system_user WHERE system_user_name = 'administrator')
, 'Admin Craig', 'W', 'Christensen', 'administrator', 'administrator', 'cwcraigo@gmail.com', NOW()),
( (SELECT system_user_id FROM system_user WHERE system_user_name = 'user')
, 'User Craig', 'W', 'Christensen', 'user', 'user', 'cwcraigo@gmail.com', NOW());

/* ********************************
*           MEASUREMENT
* ******************************* */
SELECT 'TABLE' AS 'MEASUREMENT';
DROP TABLE IF EXISTS measurement;

CREATE TABLE measurement
( measurement_id      INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, measurement_name    VARCHAR(20)     NOT NULL
, measurement_symbol  VARCHAR(10)     NOT NULL
, active_flag         VARCHAR(10)     NOT NULL
, date_removed        DATE
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

/* ********************************
*            PRODUCT
* ******************************* */
SELECT 'TABLE' AS 'PRODUCT';
DROP TABLE IF EXISTS product;

CREATE TABLE product
( product_id    INT UNSIGNED    PRIMARY KEY AUTO_INCREMENT
, product_name  VARCHAR(30)     NOT NULL
, active_flag   VARCHAR(10)     NOT NULL
, date_removed  DATE
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

/* ********************************
*             RECIPE
* ******************************* */
SELECT 'TABLE' AS 'RECIPE';
DROP TABLE IF EXISTS recipe;

CREATE TABLE recipe
( recipe_id         INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, category          INT UNSIGNED  NOT NULL
, recipe_name       VARCHAR(60)   NOT NULL
, instructions      TEXT          NOT NULL
, recipe_author     VARCHAR(30)   NOT NULL
, created_by        INT UNSIGNED  NOT NULL
, creation_date     DATE          NOT NULL
, last_updated_by   INT UNSIGNED  NOT NULL
, last_update_date  TIMESTAMP     ON UPDATE CURRENT_TIMESTAMP
, active_flag       VARCHAR(10)   NOT NULL
, date_removed      DATE
, KEY recipe_fk1 (category)
, CONSTRAINT recipe_fk1 FOREIGN KEY (category) REFERENCES common_lookup (common_lookup_id)
, KEY recipe_fk2 (created_by)
, CONSTRAINT recipe_fk2 FOREIGN KEY (created_by) REFERENCES client (client_id)
, KEY recipe_fk3 (last_updated_by)
, CONSTRAINT recipe_fk3 FOREIGN KEY (last_updated_by) REFERENCES client (client_id)
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

/* ********************************
*           INGREDIENT
* ******************************* */
SELECT 'TABLE' AS 'INGREDIENT';
DROP TABLE IF EXISTS ingredient;

CREATE TABLE ingredient
( ingredient_id     INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, recipe_id         INT UNSIGNED  NOT NULL
, product_quantity  INT UNSIGNED  NOT NULL
, measurement_id    INT UNSIGNED  NOT NULL
, product_id        INT UNSIGNED  NOT NULL
, active_flag       VARCHAR(10)   NOT NULL
, date_removed      DATE
, KEY ingredient_fk1 (recipe_id)
, CONSTRAINT ingredient_fk1 FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id)
, KEY ingredient_fk2 (measurement_id)
, CONSTRAINT ingredient_fk2 FOREIGN KEY (measurement_id) REFERENCES measurement (measurement_id)
, KEY ingredient_fk3 (product_id)
, CONSTRAINT ingredient_fk3 FOREIGN KEY (product_id) REFERENCES product (product_id)
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

/* ********************************
*         MEAL_SCHEDULE
* ******************************* */
SELECT 'TABLE' AS 'MEAL_SCHEDULE';
DROP TABLE IF EXISTS meal_schedule;

CREATE TABLE meal_schedule
( meal_schedule_id  INT UNSIGNED  PRIMARY KEY AUTO_INCREMENT
, day               INT UNSIGNED  NOT NULL
, month             INT UNSIGNED  NOT NULL
, year              INT UNSIGNED  NOT NULL
, meal_time         INT UNSIGNED  NOT NULL
, recipe_id         INT UNSIGNED  NOT NULL
, client_id         INT UNSIGNED  NOT NULL
, active_flag       VARCHAR(10)   NOT NULL
, date_removed      DATE
, KEY meal_schedule_fk1 (month)
, CONSTRAINT meal_schedule_fk1 FOREIGN KEY (month) REFERENCES common_lookup (common_lookup_id)
, KEY meal_schedule_fk2 (meal_time)
, CONSTRAINT meal_schedule_fk2 FOREIGN KEY (meal_time) REFERENCES common_lookup (common_lookup_id)
, KEY meal_schedule_fk3 (recipe_id)
, CONSTRAINT meal_schedule_fk3 FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id)
, KEY meal_schedule_fk4 (client_id)
, CONSTRAINT meal_schedule_fk4 FOREIGN KEY (client_id) REFERENCES client (client_id)
, CONSTRAINT client_cc1 CHECK (active_flag IN ('ACTIVE','NOT_ACTIVE')));

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;

NOTEE
