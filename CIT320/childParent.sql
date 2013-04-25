DROP TABLE IF EXISTS grandparent;
CREATE TABLE grandparent
( grandparent_id 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, grandparent_name 	VARCHAR(20) NOT NULL);

DROP TABLE IF EXISTS parent;
CREATE TABLE parent
( parent_id 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, grandparent_id 		INT UNSIGNED NOT NULL
, parent_name 			VARCHAR(20) NOT NULL
, CONSTRAINT parent_fk1 FOREIGN KEY grandparent_id (grandparent));

DROP TABLE IF EXISTS child;
CREATE TABLE child
( child_id 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, parent_id 				INT UNSIGNED NOT NULL
, child_name 				VARCHAR(20) NOT NULL
, CONSTRAINT child_fk1 FOREIGN KEY parent_id (parent));