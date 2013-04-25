USE idmgmtdb

-- SELECT * FROM system_session\G

-- DESC system_session;

update system_session
	set last_update_date = date_add(last_update_date, interval 1 day);

SELECT DATEDIFF(DATE_ADD(NOW(), INTERVAL 5 MINUTE),NOW());