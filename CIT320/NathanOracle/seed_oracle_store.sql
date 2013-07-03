-- ------------------------------------------------------------------
--  Program Name:   seed_oracle_store.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
-- ------------------------------------------------------------------
-- This seeds data in the video store model. It requires that you run
-- the create_oracle_store.sql script.
-- ------------------------------------------------------------------

-- Open log file.
SPOOL c:\data\oracle\lib\seed_oracle_store.log

-- Set SQL*Plus environment variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Insert statement demonstrates a mandatory-only column override signature.
-- ------------------------------------------------------------------
-- TIP: When a comment ends the last line, you must use a forward slash on
--      on the next line to run the statement rather than a semicolon.
-- ------------------------------------------------------------------
INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 2                 -- system_user_id
,'DBA'              -- system_user_name
, 2                 -- system_user_group_id
, 2                 -- system_user_type
,'Adams'            -- last_name
,'Samuel'           -- middle_name
, 1                 -- created_by
, SYSDATE           -- creation_date
, 1                 -- last_updated_by
, SYSDATE)          -- last_update_date
/

-- A variation on the override signature.
-- ------------------------------------------------------------------
-- TIP: When omitting column names for values, you may use the semicolon
--      on the last line to execute the query.
-- ------------------------------------------------------------------
INSERT
INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 3,'DBA', 2, 2,'Henry','Patrick', 1, SYSDATE, 1, SYSDATE);

-- A default signatures must mirror the order of columns in the data catalog.
INSERT
INTO system_user
VALUES
( 4
,'DBA'
, 2
, 2
,'Manmohan'
, NULL              -- Optional parameters must be provided a null value in a default signature.
,'Puri'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ------------------------------------------------------------------
-- This seeds rows in a dependency chain, including the MEMBER, CONTACT
-- ADDRESS, and TELEPHONE tables.
-- ------------------------------------------------------------------
-- Insert record set #1.
-- ------------------------------------------------------------------
INSERT INTO member VALUES
( member_s1.nextval
, NULL
,'B293-71445'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Randi','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Brian','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #2.
-- ------------------------------------------------------------------
INSERT INTO member VALUES
( member_s1.nextval
, NULL
,'B293-71446'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Oscar','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Doreen','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #3.
-- ------------------------------------------------------------------
INSERT INTO member VALUES
( member_s1.nextval
, NULL
,'B293-71447'
,'3333-4444-5555-6666'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Meaghan','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Matthew','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ian','M','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 21 rows in the ITEM table.
-- ------------------------------------------------------------------
INSERT INTO item VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October','Special Collector''s Edition','PG'
,'02-MAR-90'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-02392'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars I','Phantom Menace','PG'
,'04-MAY-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-05539'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-20309'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars III','Revenge of the Sith','PG13'
,'19-MAY-05'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'86936-70380'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'91493-06475'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'RoboCop','','Mature'
,'24-JUL-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'93155-11810'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean','','Teen','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'12725-00173'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','Everyone','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'45496-96128'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'NINTENDO_GAMECUBE')
,'MarioKart','Double Dash','Everyone','17-NOV-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'08888-32214'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Splinter Cell','Chaos Theory','Teen','08-APR-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'14633-14821'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Need for Speed','Most Wanted','Everyone','15-NOV-04'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'10425-29944'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The DaVinci Code','','Teen','19-MAY-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'52919-52057'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Cars','','Everyone','28-APR-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'9689-80547-3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Beau Geste','','PG','01-MAR-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'53939-64103'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama','','NR','05-JAN-98'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'24543-01292'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Tora! Tora! Tora!','The Attack on Pearl Harbor','G','02-NOV-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'43396-60047'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'A Man for All Seasons','','G','28-JUN-94'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'43396-70603'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Hook','','PG','11-DEC-91'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'85391-13213'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Around the World in 80 Days','','G','04-DEC-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item VALUES
( item_s1.nextval
,'85391-10843'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Camelot','','G','15-MAY-98'
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Inserts 5 rentals with 9 dependent rental items.  This section inserts
-- 5 rows in the RENTAL table, then 9 rows in the RENTAL_ITEM table. The
-- inserts into the RENTAL_ITEM tables use scalar subqueries to find the
-- proper foreign key values by querying the RENTAL table primary keys. 
-- ------------------------------------------------------------------
-- Insert 5 records in the RENTAL table.
-- ------------------------------------------------------------------
INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 9 records in the RENTAL_ITEM table.
-- ------------------------------------------------------------------
INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Star Wars I'
  AND      i.item_subtitle = 'Phantom Menace'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r inner join contact c
  ON       r.customer_id = c.contact_id
  WHERE    c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item d join common_lookup cl
  ON       d.item_title = 'Star Wars II'
  WHERE    d.item_subtitle = 'Attack of the Clones'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Star Wars III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'I Remember Mama'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_SINGLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Camelot'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_DOUBLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Meaghan')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Hook'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_SINGLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Ian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Cars'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'RoboCop'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'The Hunt for Red October'
  AND      d.item_subtitle = 'Special Collector''s Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- These steps modify the MEMBER table created during Lab #2, by adding
-- a MEMBER_TYPE column and seeding an appropriate group or individual 
-- account on the basis of how many contacts belong to a member.
-- ------------------------------------------------------------------
-- Update all MEMBER_TYPE values based on number of dependent CONTACT rows.
UPDATE member m
SET    member_type = (SELECT   common_lookup_id
                      FROM     common_lookup
                      WHERE    common_lookup_context = 'MEMBER'
                      AND      common_lookup_type =
                                (SELECT  dt.member_type
                                 FROM   (SELECT   c.member_id
                                         ,        CASE
                                                    WHEN COUNT(c.member_id) > 1 THEN
                                                     'GROUP'
                                                    ELSE
                                                     'INDIVIDUAL'
                                                  END AS member_type
                                         FROM     contact c
                                         GROUP BY c.member_id) dt
                                 WHERE   dt.member_id = m.member_id));

-- Modify the MEMBER table to add a NOT NULL constraint to the MEMBER_TYPE column.
ALTER TABLE member
ADD CONSTRAINT nn_member_1 CHECK(member_type IS NOT NULL);

-- Use SQL*Plus report formatting commands.
COLUMN member_id          FORMAT 999999 HEADING "MEMBER|ID"
COLUMN members            FORMAT 999999 HEADING "MEMBER|QTY #"
COLUMN member_type        FORMAT 999999 HEADING "MEMBER|TYPE|ID #"
COLUMN common_lookup_id   FORMAT 999999 HEADING "MEMBER|LOOKUP|ID #"
COLUMN common_lookup_type FORMAT A12    HEADING "COMMON|LOOKUP|TYPE"
                                 
-- Verify MEMBER_TYPE values, confirms preceding UPDATE statement.
SELECT   m.member_id
,        COUNT(contact_id) AS MEMBERS
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN common_lookup cl
ON       m.member_type = cl.common_lookup_id
GROUP BY m.member_id
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
ORDER BY m.member_id;                            
                      
-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_insert
( pv_member_type         VARCHAR2
, pv_account_number      VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_address_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address      VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_created_by          NUMBER   := 1
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1
, pv_last_update_date    DATE     := SYSDATE) IS

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = lv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = lv_credit_card_type)
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = lv_contact_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , pv_street_address
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  
  dbms_output.put_line('c5');
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END contact_insert;
/

-- Display any compilation errors.
SHOW ERRORS

-- Insert complete contact information using stored procedure.
EXECUTE contact_insert('INDIVIDUAL','R11-514-34','1111-1111-1111-1111','VISA_CARD','Goeffrey','Ward','Clinton','CUSTOMER','HOME','Provo','Utah','84606','118 South 9th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-35','1111-2222-1111-1111','VISA_CARD','Wendy','','Moss','CUSTOMER','HOME','Provo','Utah','84606','1218 South 10th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-36','1111-1111-2222-1111','VISA_CARD','Simon','Jonah','Gretelz','CUSTOMER','HOME','Provo','Utah','84606','2118 South 7th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-37','1111-1111-1111-2222','MASTER_CARD','Elizabeth','Jane','Royal','CUSTOMER','HOME','Provo','Utah','84606','2228 South 14th East','HOME','011','801','423-1234');
EXECUTE contact_insert('INDIVIDUAL','R11-514-38','1111-1111-3333-1111','VISA_CARD','Brian','Nathan','Smith','CUSTOMER','HOME','Spanish Fork','Utah','84606','333 North 2nd East','HOME','011','801','423-1234');

-- Verify MEMBER_TYPE values.
SELECT   m.member_id
,        COUNT(contact_id) AS MEMBERS
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN common_lookup cl
ON       m.member_type = cl.common_lookup_id
GROUP BY m.member_id
,        m.member_type
,        cl.common_lookup_id
,        cl.common_lookup_type
ORDER BY m.member_id;

-- Create a transaction view.
CREATE OR REPLACE VIEW current_rental AS
  SELECT   m.account_number
  ,        c.first_name
  ||       DECODE(c.middle_name,NULL,' ',' '||c.middle_name||' ')
  ||       c.last_name FULL_NAME
  ,        i.item_title TITLE
  ,        i.item_subtitle SUBTITLE
  ,        SUBSTR(cl.common_lookup_meaning,1,3) PRODUCT
  ,        r.check_out_date
  ,        r.return_date
  FROM     common_lookup cl
  ,        contact c
  ,        item i
  ,        member m
  ,        rental r
  ,        rental_item ri
  WHERE    r.customer_id = c.contact_id
  AND      r.rental_id = ri.rental_id
  AND      ri.item_id = i.item_id
  AND      i.item_type = cl.common_lookup_id
  AND      c.member_id = m.member_id
  ORDER BY 1,2,3;

COL full_name FORMAT A16
COL title     FORMAT A30
COL subtitle  FORMAT A4

SELECT   cr.full_name
,        cr.title
,        cr.product
,        cr.check_out_date
,        cr.return_date
FROM     current_rental cr;
       
SPOOL OFF