-- --------------------------------------------------------------------------------
--  Program Name:   seed_mysql_store_ri2.sql
--  Program Author: Michael McLaughlin
--  Creation Date:  12-FEB-2013
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
('DBA', 2, 1,'Henry','Patrick', 1001, UTC_DATE(), 1001, UTC_DATE());

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
('DBA', 2, 1,'Puri','Manmohan', 1001, UTC_DATE(), 1001, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

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
, 1002, UTC_DATE(), 1002, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item "The Hunt for Red October"' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000QUA4PF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October','Special Collectornulls Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'1990-03-02'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000WAS3IL'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars I','Phantom Menace'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'1999-05-04'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000NOP4JH'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars II','Attack of the Clones'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-16'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000PMN4GT'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars II','Attack of the Clones'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-16'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MEN4PI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars III','Revenge of the Sith'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2005-05-19'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item "The Chronicles of Narnia: The Lion, the Witch and the Wardrobe"' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000QAR3OL'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-16'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000SCX3ML'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'RoboCop',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'M'
  AND      rating_agency = 'ESRB')
,'2003-07-24'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000NMI3IK'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'T'
  AND      rating_agency = 'ESRB')
,'2003-06-30'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000WSE2HJ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'E'
  AND      rating_agency = 'ESRB')
,'2003-06-30'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000KJI3RE'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'NINTENDO_GAMECUBE')
,'MarioKart','Double Dash'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'E'
  AND      rating_agency = 'ESRB')
,'2003-11-17'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000REE2VC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Splinter Cell','Chaos Theory'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'T'
  AND      rating_agency = 'ESRB')
,'2003-04-08'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000TGB2JK'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Need for Speed','Most Wanted'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'E'
  AND      rating_agency = 'ESRB')
,'2004-11-15'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MUR2DS'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'The DaVinci Code',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'T'
  AND      rating_agency = 'ESRB')
,'2006-05-19'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MER2AS'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'XBOX')
,'Cars',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'E'
  AND      rating_agency = 'ESRB')
,'2006-04-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MZQ2PI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Beau Geste',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'1992-03-01'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000QYR2LK'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'NR'
  AND      rating_agency = 'MPAA')
,'1998-01-05'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNV3BN'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Tora! Tora! Tora!','The Attack on Pearl Harbor'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'1999-11-02'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item "A Man for All Seasons"' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00YUIP3PF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'A Man for All Seasons',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'1994-06-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MOQ4DT'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Hook',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'19911211'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNP3GR'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Around the World in 80 Days',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'1992-12-04'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNP2TT'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Harry Potter and the Sorcerer''s Stone',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Echo to screen statement message.
SELECT 'INSERT INTO item' AS "Statement";
INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNP2GT'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Camelot',null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'1998-05-15'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNP2KI'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Casino Royale'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2007-03-13'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000MNP2K8'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Casino Royale'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2007-03-13'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00005JLBE'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Die Another Day'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-06-03'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00008S2SF'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Die Another Day'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-06-03'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00005JLBE'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Die Another Day'
,'2-Disc Ultimate Version'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-06-03'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00000K0E5'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Golden Eye'
,'Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-06-03'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000M53GM2'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Golden Eye'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-06-03'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: 6304916558'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tomorrow Never Dies'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'1998-05-13'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00000K0EA'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tomorrow Never Dies'
,'Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2000-05-16'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000NIBURQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The World Is Not Enough'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2007-05-22'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00003CX95'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Brave Heart'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'R'
  AND      rating_agency = 'MPAA')
,'2000-08-29'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00000K3CJ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Christmas Carol'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'1999-10-05'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B0000AQS5D'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Scrooge'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'1998-10-21'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: 6305127719'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Clear and Present Danger'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'1998-10-21'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00008K76V'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Clear and Present Danger'
,'Special Collector''s Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2003-05-06'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00003CXI1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Sorcer''s Stone'
,'Two-Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000062TU1'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Sorcer''s Stone'
,'Full Screen Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00008DDXC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Chamber of Secrets'
,'Two-Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00008DDXC'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Chamber of Secrets'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2002-05-28'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B00005JMAH'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Prisoner of Azkaban'
,'Two-Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2004-10-23'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B0002TT0NW'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Prisoner of Azkaban'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2004-10-23'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E6EK2Y'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Goblet of Fire'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2006-03-07'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E6EK2Y'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Goblet of Fire'
,'Widescreen Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2006-03-07'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E6EK38'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Harry Potter and the Goblet of Fire'
,'Two Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2006-03-07'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E6EZ3Z'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Order of the Phoenix'
,'Two Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2007-12-11'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E6E2FQ'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Half Blood Prince'
,'Two Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
,'2009-12-08'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E54369'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Deathly Hallows, Part 1'
,'Two Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2011-10-15'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000E5Q2RS'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Harry Potter and the Deathly Hallows, Part 2'
,'Two Disc Special Edition'
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG-13'
  AND      rating_agency = 'MPAA')
,'2011-11-11'
, 1003, UTC_DATE(), 1003, UTC_DATE());

INSERT INTO item
( item_barcode
, item_type
, item_title
, item_subtitle
, item_rating_id
, item_release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
('ASIN: B000EHYKRS'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama'
, null
,(SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'G'
  AND      rating_agency = 'MPAA')
,'2011-11-11'
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

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
, 1003, UTC_DATE(), 1003, UTC_DATE());

-- Update all the NULL ALLOWED values in the MEMBER_TYPE column.
SELECT 'UPDATE member' AS "Statement";
UPDATE member
SET    member_type = (SELECT   common_lookup_id
                      FROM     common_lookup
                      WHERE    common_lookup_context = 'MEMBER'
                      AND      common_lookup_type = 'INDIVIDUAL');

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
  DECLARE lv_created_by        int unsigned DEFAULT 1001;
  DECLARE lv_creation_date     DATE         DEFAULT UTC_DATE();
  DECLARE lv_last_updated_by   int unsigned DEFAULT 1001;
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
  , last_insert_id()
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
  , last_insert_id()
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