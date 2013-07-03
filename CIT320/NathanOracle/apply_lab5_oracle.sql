-- --------------------------------------------------------------------------------
--  Program Name:   apply_lab5_oracle.sql
--  Program Author: Nathan Waters, Pete Martins, Curtis Lange
--  Creation Date:  21-MAY-2013
-- --------------------------------------------------------------------------------

start c:\data\oracle\lib\create_oracle_store.sql

start c:\data\oracle\lib\seed_oracle_store.sql

-- Open log file.
SPOOL c:\data\oracle\lab5\apply_lab5_oracle.txt


-- Deliverable 1
-- ------------------------------------------------------------------
-- Write INNER JOIN queries that use the USING subclause and return 
-- the following results:
-- ------------------------------------------------------------------

-- 1A
-- ------------------------------------------------------------------
-- Display the MEMBER_ID and CONTACT_ID in the SELECT clause from a 
-- join of the MEMBER and CONTACT tables. You should make the join 
-- with the USING subclause based on the MEMBER_ID column, which is 
-- the primary and foreign key of the respective tables.
-- ------------------------------------------------------------------

SELECT 
	member_id
,	c.contact_id 
FROM 
	member m 
INNER JOIN 
	contact c 
USING
	(member_id)
;

-- 1B
-- ------------------------------------------------------------------
-- Display the CONTACT_ID and ADDRESS_ID in the SELECT clause from a 
-- join of the CONTACT and ADDRESS tables. You should make the join 
-- between the tables with the USING subclause based on the 
-- CONTACT_ID column, which is the primary and foreign key of the 
-- respective tables.
-- ------------------------------------------------------------------

SELECT 
	contact_id
,	a.address_id
FROM 
	contact c
INNER JOIN 
	address a
USING
	(contact_id)
;

-- 1C
-- ------------------------------------------------------------------
-- Display the ADDRESS_ID and STREET_ADDRESS_ID in the SELECT clause 
-- from a join of the ADDRESS and STREET_ADDRESS tables. You should 
-- make the join between the tables with the USING subclause based 
-- on the ADDRESS_ID column, which is the primary and foreign key of 
-- the respect tables.
-- ------------------------------------------------------------------

SELECT 
	address_id
,	sa.street_address_id
FROM 
	address a
INNER JOIN 
	street_address sa
USING
	(address_id)
;

-- 1D
-- ------------------------------------------------------------------
-- Display the CONTACT_ID and TELEPHONE_ID in the SELECT clause from 
-- a join of the CONTACT and TELEPHONE tables. You should make the 
-- join between the tables with the USING subclause based on the 
-- CONTACT_ID column, which is the primary and foreign key of the 
-- respect tables.
-- ------------------------------------------------------------------

SELECT 
	contact_id
,	t.telephone_id
FROM 
	contact c
INNER JOIN 
	telephone t
USING
	(contact_id)
;

-- Deliverable 2
-- ------------------------------------------------------------------
-- Write INNER JOIN queries that use the ON subclause and return the 
-- following results:
-- ------------------------------------------------------------------

-- 2A
-- ------------------------------------------------------------------
-- Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT 
-- clause from a join of the CONTACT and SYSTEM_USER tables. You 
-- should make the join with the ON subclause based on the CREATED_BY 
-- and SYSTEM_USER_ID columns, which are the foreign and primary key 
-- respectively.
-- ------------------------------------------------------------------

SELECT
	c.contact_id
,	su.system_user_id
FROM
	contact c
INNER JOIN
	system_user su
ON
	c.created_by = su.system_user_id
;

-- 2B
-- ------------------------------------------------------------------
-- Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT 
-- clause from a join of the CONTACT and SYSTEM_USER tables. You 
-- should make the join with the ON subclause based on the 
-- LAST_UPDATED_BY and SYSTEM_USER_ID columns, which are the foreign 
-- and primary key respectively.
-- ------------------------------------------------------------------

SELECT
	c.contact_id
,	su.system_user_id
FROM
	contact c
INNER JOIN
	system_user su
ON
	c.last_updated_by = su.system_user_id
;

-- Deliverable 3
-- ------------------------------------------------------------------
-- Write INNER JOIN queries that use the ON subclause and return the 
-- following results:
-- ------------------------------------------------------------------

-- 3A
-- ------------------------------------------------------------------
-- Display the SYSTEM_USER_ID and CREATED_BY columns from one row, 
-- and the SYSTEM_USER_ID column from a row where it is also the 
-- primary key. You should make the join with the ON subclause based 
-- on the CREATED_BY and SYSTEM_USER_ID columns, which are the 
-- foreign and primary key respectively. In a self-join, these 
-- columns may be in the same or different rows in the table.
-- ------------------------------------------------------------------

SELECT
	su1.system_user_id
,	su1.created_by
,	su2.system_user_id
FROM
	system_user su1
INNER JOIN
	system_user su2
ON
	su1.created_by = su2.system_user_id
;

-- 3B
-- ------------------------------------------------------------------
-- Display the SYSTEM_USER_ID and LAST_UPDATED_BY columns from one 
-- row, and the SYSTEM_USER_ID column from a row where it is also the 
-- primary key. You should make the join with the ON subclause based 
-- on the LAST_UPDATED_BY and SYSTEM_USER_ID columns, which are the 
-- foreign and primary key respectively. In a self-join, these 
-- columns may be in the same or different rows in the table.
-- ------------------------------------------------------------------

SELECT
	su1.system_user_id
,	su1.last_updated_by
,	su2.system_user_id
FROM
	system_user su1
INNER JOIN
	system_user su2
ON
	su1.last_updated_by = su2.system_user_id
;

-- Deliverable 4
-- ------------------------------------------------------------------
-- Display the RENTAL_ID column from the RENTAL table, the RENTAL_ID 
-- and ITEM_ID from the RENTAL_ITEM table, and ITEM_ID column from 
-- the ITEM table. You should make a join from the RENTAL table to 
-- the RENTAL_ITEM table, and then the ITEM table. Join the tables 
-- based on their respective primary and foreign key values.
-- ------------------------------------------------------------------

SELECT
	r.rental_id
,	ri.rental_id
,	ri.item_id
,	i.item_id
FROM
	rental r
INNER JOIN
	rental_item ri
ON
	r.rental_id = ri.rental_id
INNER JOIN
	item i
ON
	ri.item_id = i.item_id
;

-- Deliverable 6
-- ------------------------------------------------------------------
-- The RENTAL table has a NOT NULL constraint on the RETURN_DATE 
-- column. You need to fix this because it violates a business 
-- rule. Please read the business rule and system logic to 
-- understand the issues.
-- ------------------------------------------------------------------

ALTER TABLE rental
	DROP CONSTRAINT NN_RENTAL_3
;

SPOOL OFF