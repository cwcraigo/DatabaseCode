-- --------------------------------------------------------------------------------
--  Program Name:   create_mysql_store_ri.sql
--  Lab Assignment: Lab #4
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
-- --------------------------------------------------------------------------------

-- Open log file.
TEE seed_mysql_store.txt

-- Echo to screen statement message.
SELECT 'INSERT INTO system_user' AS "Statement";
INSERT
INTO system_user
( system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('DBA', 2, 1,'Adams','Samuel', 1, UTC_DATE(), 1, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO system_user' AS "Statement";
INSERT
INTO system_user
( system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('DBA', 2, 1,'Henry','Patrick', 1, UTC_DATE(), 1, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO system_user' AS "Statement";
INSERT
INTO system_user
( system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('DBA', 2, 1,'Puri','Manmohan', 1, UTC_DATE(), 1, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO member' AS "Statement";
INSERT INTO member
( account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('B293-71445'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_member_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
(@lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Winn','Randi'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'10 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Winn','Brian'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'10 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO member' AS "Statement";
INSERT INTO member
( account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('B293-71446'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_member_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
(@lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Vizquel','Oscar'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'12 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Vizquel','Doreen'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'12 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO member' AS "Statement";
INSERT INTO member
( account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('B293-71447'
,'3333-4444-5555-6666'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_member_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Sweeney','Meaghan'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'14 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Sweeney','Matthew'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'14 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO contact' AS "Statement";
INSERT INTO contact
( member_id
, contact_type
, last_name
, first_name
, middle_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( @lv_member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Sweeney','Ian','M'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_contact_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO address' AS "Statement";
INSERT INTO address
( contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, UTC_DATE(), 2, UTC_DATE());

SET @lv_address_id := last_insert_id();

-- Echo to screen statement message.
SELECT 'INSERT INTO street_address' AS "Statement";
INSERT INTO street_address
( address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_address_id
,'14 El Camino Real'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO telephone' AS "Statement";
INSERT INTO telephone
( contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(@lv_contact_id
,@lv_address_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('9736-05640-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October','Special Collectornulls Edition','PG'
,'19900302'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('24543-02392'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars I','Phantom Menace','PG'
,'19990504'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('24543-5615'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'20020516'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('24543-05539'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'20020516'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('24543-20309'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars III','Revenge of the Sith','PG13'
,'20050519'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('86936-70380'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','PG'
,'20020516'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('91493-06475'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'RoboCop',null,'Mature','20030724'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('93155-11810'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean',null,'Teen','20030630'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('12725-00173'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','Everyone','20030630'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('45496-96128'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'NINTENDO_GAMECUBE')
,'MarioKart','Double Dash','Everyone','20031117'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('08888-32214'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Splinter Cell','Chaos Theory','Teen','20030408'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('14633-14821'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Need for Speed','Most Wanted','Everyone','20041115'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('10425-29944'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The DaVinci Code',null,'Teen','20060519'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('52919-52057'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Cars',null,'Everyone','20060428'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('9689-80547-3'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Beau Geste',null,'PG','19920301'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('53939-64103'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama',null,'NR','19980105'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('24543-01292'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Tora! Tora! Tora!','The Attack on Pearl Harbor','G','19991102'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('43396-60047'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'A Man for All Seasons',null,'G','19940628'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('43396-70603'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Hook',null,'PG','19911211'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('85391-13213'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Around the World in 80 Days',null,'G','19921204'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('85391-17843'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Harry Potter and the Sorcerer''s Stone',null,'PG','20020528'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('85391-10843'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Camelot',null,'G','19980515'
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental' AS "Statement";
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental' AS "Statement";
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental' AS "Statement";
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental' AS "Statement";
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental' AS "Statement";
INSERT INTO rental
( customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), DATE_ADD(DATE_SUB(UTC_DATE(),INTERVAL 8 DAY), INTERVAL 5 DAY)
, 3, UTC_DATE(), 3, UTC_DATE());

show warnings;

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
( rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
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
, 3, UTC_DATE(), 3, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO rental_item' AS "Statement";
INSERT INTO rental_item
(rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
((SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'The Hunt for Red October'
  AND      d.item_subtitle = 'Special Collectornulls Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, UTC_DATE(), 3, UTC_DATE());

-- Update all the NULL ALLOWED values in the MEMBER_TYPE column.
SELECT 'UPDATE member' AS "Statement";
UPDATE member
SET    member_type = (SELECT   common_lookup_id
                      FROM     common_lookup
                      WHERE    common_lookup_context = 'MEMBER'
                      AND      common_lookup_type = 'INDIVIDUAL');
                      
-- Modify the MEMBER table to add MEMBER_TYPE column.
SELECT 'ALTER TABLE member ADD CONSTRAINT FOREIGN KEY(member_type)' AS "Statement";
ALTER TABLE member ADD CONSTRAINT member_fk3 FOREIGN KEY(member_type) REFERENCES common_lookup(common_lookup_id);

SELECT 'DROP PROCEUDRE IF EXISTS contact_insert' AS "Statement";
DROP PROCEDURE IF EXISTS contact_insert;

-- Reset the delimiter so that a semicolon can be used as a statement and block terminator.
DELIMITER $$

SELECT 'CREATE PROCEDURE contact_insert' AS "Statement";
CREATE PROCEDURE contact_insert
( pv_member_type         CHAR(12)
, pv_account_number      CHAR(19)
, pv_credit_card_number  CHAR(19)
, pv_credit_card_type    CHAR(12)
, pv_first_name          CHAR(20)
, pv_middle_name         CHAR(20)
, pv_last_name           CHAR(20)
, pv_contact_type        CHAR(12)
, pv_address_type        CHAR(12)
, pv_city                CHAR(30)
, pv_state_province      CHAR(30)
, pv_postal_code         CHAR(20)
, pv_street_address      CHAR(30)
, pv_telephone_type      CHAR(12)
, pv_country_code        CHAR(3)
, pv_area_code           CHAR(6)
, pv_telephone_number    CHAR(10)) MODIFIES SQL DATA

BEGIN

  /* Declare variables to manipulate auto generated sequence values. */
  DECLARE member_id            int unsigned;
  DECLARE contact_id           int unsigned;
  DECLARE address_id           int unsigned;
  DECLARE street_address_id    int unsigned;
  DECLARE telephone_id         int unsigned;

  /* Declare local constants for who-audit columns. */
  DECLARE lv_created_by        int unsigned DEFAULT 1;
  DECLARE lv_creation_date     DATE         DEFAULT UTC_DATE();
  DECLARE lv_last_updated_by   int unsigned DEFAULT 1;
  DECLARE lv_last_update_date  DATE         DEFAULT UTC_DATE();

  /* Declare a locally scoped variable. */
  DECLARE duplicate_key INT DEFAULT 0;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
  
  /* Start the transaction context. */
  START TRANSACTION;
  
  /* Create a SAVEPOINT as a recovery point. */
  SAVEPOINT all_or_none;
  
  /* Insert into the first table in sequence based on inheritance of primary keys by foreign keys. */
  INSERT INTO member
  ( member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ((SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = pv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = pv_credit_card_type)
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );

  /* Preserve the sequence by a table related variable name. */
  SET member_id = last_insert_id();

  /* Insert into the first table in sequence based on inheritance of primary keys by foreign keys. */
  INSERT INTO contact
  VALUES
  ( null
  , member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = pv_contact_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  /* Preserve the sequence by a table related variable name. */
  SET contact_id = last_insert_id();

  /* Insert into the first table in sequence based on inheritance of primary keys by foreign keys. */
  INSERT INTO address
  VALUES
  ( null
  , contact_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  /* Preserve the sequence by a table related variable name. */
  SET address_id = last_insert_id();
  
  /* Insert into the first table in sequence based on inheritance of primary keys by foreign keys. */
  INSERT INTO street_address
  VALUES
  ( null
  , address_id
  , pv_street_address
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date );  

  /* Insert into the first table in sequence based on inheritance of primary keys by foreign keys. */
  INSERT INTO telephone
  VALUES
  ( null
  , contact_id
  , address_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = pv_telephone_type)
  , pv_country_code
  , pv_area_code
  , pv_telephone_number
  , lv_created_by
  , lv_creation_date
  , lv_last_updated_by
  , lv_last_update_date);

  /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;

  /* This commits the write when successful and is harmless otherwise. */
  COMMIT;
  
END;
$$

-- Reset the standard delimiter to let the semicolon work as an execution command.
DELIMITER ;

SELECT 'CALL contact_insert() PROCEDURE 5 times' AS "Statement";
CALL contact_insert('INDIVIDUAL','R11-514-34','1111-1111-1111-1111','VISA_CARD','Goeffrey','Ward','Clinton','CUSTOMER','HOME','Provo','Utah','84606','118 South 9th East','HOME','011','801','423\-1234');
CALL contact_insert('INDIVIDUAL','R11-514-35','1111-2222-1111-1111','VISA_CARD','Wendy',null,'Moss','CUSTOMER','HOME','Provo','Utah','84606','1218 South 10th East','HOME','011','801','423-1234');
CALL contact_insert('INDIVIDUAL','R11-514-36','1111-1111-2222-1111','VISA_CARD','Simon','Jonah','Gretelz','CUSTOMER','HOME','Provo','Utah','84606','2118 South 7th East','HOME','011','801','423-1234');
CALL contact_insert('INDIVIDUAL','R11-514-37','1111-1111-1111-2222','MASTER_CARD','Elizabeth','Jane','Royal','CUSTOMER','HOME','Provo','Utah','84606','2228 South 14th East','HOME','011','801','423-1234');
CALL contact_insert('INDIVIDUAL','R11-514-38','1111-1111-3333-1111','VISA_CARD','Brian','Nathan','Smith','CUSTOMER','HOME','Spanish Fork','Utah','84606','333 North 2nd East','HOME','011','801','423-1234');

SELECT 'CREATE OR REPLACE VIEW contacts' AS "Statement";
CREATE OR REPLACE VIEW contacts AS
  SELECT   m.account_number
  ,        CASE
             WHEN c.middle_name IS NOT NULL THEN
               CONCAT(c.first_name,' ',c.middle_name,' ',c.last_name)
             ELSE
               CONCAT(c.first_name,' ',c.last_name)
           END AS full_name
  ,        a.city
  ,        a.state_province
  FROM     member m JOIN contact c ON m.member_id = c.member_id JOIN address a ON c.contact_id = a.contact_id;

SELECT 'Query CONTACTS view' AS "Statement";  
SELECT * FROM contacts;
  
-- Create CURRENT_RENTAL view.
SELECT 'CREATE OR REPLACE VIEW current_rental' AS "Statement";  
CREATE OR REPLACE VIEW current_rental AS
  SELECT   m.account_number
  ,        CASE
             WHEN c.middle_name IS NOT NULL THEN
               CONCAT(c.first_name,' ',c.middle_name,' ',c.last_name)
             ELSE
               CONCAT(c.first_name,' ',c.last_name)
           END AS full_name
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

SELECT 'Query CURRENT_RENTAL view' AS "Statement";  
SELECT   cr.full_name
,        cr.title
,        cr.product
,        cr.check_out_date
,        cr.return_date
FROM     current_rental cr;
       
NOTEE