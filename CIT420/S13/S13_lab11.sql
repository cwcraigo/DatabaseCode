USE studentdb;

DELIMITER $$

DROP TRIGGER IF EXISTS insert_t1$$

CREATE TRIGGER insert_t1
BEFORE UPDATE ON item
FOR EACH ROW
BEGIN
  IF new.item_title REGEXP '(^|.*)(S|s)tar (W|w)ars(.*)' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdateTriggerError: No more Star Wars DVDs!';
  END IF;
END;
$$

DROP TRIGGER IF EXISTS insert_t2$$

CREATE TRIGGER insert_t2
BEFORE INSERT ON item
FOR EACH ROW
BEGIN
  IF new.item_title REGEXP '(^|.*)(S|s)tar (W|w)ars(.*)' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'InsertTriggerError: No more Star Wars DVDs!';
  END IF;
END;
$$

DELIMITER ;

UPDATE item
SET item_title = 'Star Wars XVI'
WHERE item_title = 'Hook';

INSERT INTO item
VALUES
(NULL
,'123'
,1
,'Star Wars XVI'
,NULL
,'R'
,NOW()
,1
,NOW()
,1
,NOW());

SELECT IF(i1.item_title='Hook','SUCCESS','FAILED') AS 'UPDATE TRIGGER'
,IF(i2.item_title='Star Wars XVI','FAILED','SUCCESS') AS 'INSERT TRIGGER'
FROM item i1 INNER JOIN item i2 USING (item_id)
WHERE i1.item_title = 'Hook' OR i2.item_title = 'Star Wars XVI';

-- DELETE FROM item WHERE item_title = 'Star Wars XVI';
-- UPDATE item SET item_title = 'Hook' WHERE item_title = 'Star Wars XVI';