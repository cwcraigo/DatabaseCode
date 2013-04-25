-- ----------------------------------------
-- ----------------------------------------
-- INSERTION SIGNATURES & SUBQUERRIES
-- ----------------------------------------
-- ----------------------------------------

-- ----------------------------------------
-- DEFAULT SIGNATURE
-- ----------------------------------------
-- Describe the table to verify the column order and type the way it was created.
DESC member;

-- This is also an implicit signature. (meaning the columns you are inserting into is implied by the default structure.)
INSERT INTO member
VALUES
( contact_s1.NEXTVAL 	-- member_id
, 1001 								-- member_type
, '100-1000-10' 			-- account_number
, '1111-333-222' 			-- credit_card_number
, 1002 								-- credit_card_type
, 1 									-- created_by
, SYSDATE 						-- creation_date
, 1 									-- last_updated_by
, SYSDATE 						-- last_update_date
);

-- ???? FOR MYSQL, WHAT WOULD YOU PUT INSTEAD OF .NEXTVAL AND SYSDATE? ????

-- ----------------------------------------
-- EXPLICIT SIGNATURE
-- ----------------------------------------
-- This means you list the columns you are inserting into.
-- This reduces confusion when you are manually inserting the values.
INSERT INTO member
(member_id
,member_type
,account_number
,credit_card_number
,credit_card_type
,created_by
,creation_date
,last_updated_by
,last_update_date
)
VALUES
( contact_s1.NEXTVAL 	-- member_id
, 1001 								-- member_type
, '100-1000-10' 			-- account_number
, '1111-333-222' 			-- credit_card_number
, 1002 								-- credit_card_type
, 1 									-- created_by
, SYSDATE 						-- creation_date
, 1 									-- last_updated_by
, SYSDATE 						-- last_update_date
);

-- ----------------------------------------
-- OVERRIDE SIGNATURE
-- ----------------------------------------
-- This means you can define the order you insert into.
INSERT INTO member
(member_id
,created_by
,creation_date
,last_updated_by
,last_update_date
,member_type
,account_number
,credit_card_number
,credit_card_type
)
VALUES
( contact_s1.NEXTVAL 	-- member_id
, 1 									-- created_by
, SYSDATE 						-- creation_date
, 1 									-- last_updated_by
, SYSDATE 						-- last_update_date
, 1001 								-- member_type
, '100-1000-10' 			-- account_number
, '1111-333-222' 			-- credit_card_number
, 1002 								-- credit_card_type
);

-- ----------------------------------------
-- SCALAR SUBQUERIES
-- ----------------------------------------
-- A scalar sub-query is a SELECT statement that returns one and only one column from one row.
SELECT   first_name||' '||last_name
FROM     contact
WHERE    contact_id =
          (SELECT   a.contact_id
           FROM     address a
           WHERE    a.address_id =
            (SELECT   t.address_id
             FROM     telephone t
             WHERE    t.telephone_id = 1001));

-- ???? SCOPE OF THE NESTED SUBQUERY? ????

-- This is where you query a value from the database to insert into the specified column.
-- Are you going to memorize the common_lookup or system_user tables to hard code the values?
INSERT INTO member
VALUES
( contact_s1.NEXTVAL 												-- member_id
, (SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_context = "MEMBER"
		AND common_lookup_meaning = "INDIVIDUAL") -- member_type
, '100-1000-10' 														-- account_number
, '1111-333-222' 														-- credit_card_number
, (SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_context = "MEMBER"
		AND common_lookup_meaning = "INDIVIDUAL") -- credit_card_type
, (SELECT system_user_id
		FROM system_user
		WHERE system_user_name = "SYSADMIN") 	-- created_by
, SYSDATE 																	-- creation_date
, (SELECT system_user_id
		FROM system_user
		WHERE system_user_name = "SYSADMIN") 	-- last_updated_by
, SYSDATE 																	-- last_update_date
);