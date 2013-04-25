
CREATE OR REPLACE PROCEDURE interview
(pv_adult_price 	NUMBER, pv_child_price 	NUMBER
,pv_total_revenue NUMBER, pv_tickets_sold NUMBER) IS
	total 			 NUMBER;
	lv_adult_num NUMBER;
	lv_child_num NUMBER;
	lv_tickets 	 NUMBER;
BEGIN
	total 				:= 0;
	lv_adult_num  := 0;
	lv_child_num  := 0;
	lv_tickets 		:= lv_adult_num + lv_child_num;

	<<adult_loop>>
 	LOOP
 		EXIT adult_loop WHEN total >= pv_total_revenue OR lv_tickets >= pv_tickets_sold;

	 	total := total + pv_adult_price;
		lv_adult_num := lv_adult_num + 1;
		lv_tickets := lv_tickets + 1;

		IF total = pv_total_revenue AND pv_tickets_sold = lv_tickets THEN
			dbms_output.put_line('Number of Adults: '		||lv_adult_num);
			dbms_output.put_line('Number of Children: '	||lv_child_num);
			dbms_output.put_line('Total Tickets Sold: '	||lv_tickets||'/'||pv_tickets_sold);
			dbms_output.put_line('Total Revenue: '			||total||'/'||pv_total_revenue);
			RETURN;
		END IF;

	END LOOP adult_loop;

 	WHILE total <> pv_total_revenue AND lv_tickets <> pv_tickets_sold LOOP

		IF total > pv_total_revenue THEN
			total := total - pv_adult_price;
			lv_adult_num := lv_adult_num - 1;
			lv_tickets := lv_tickets - 1;
		ELSE
			total := total + pv_child_price;
			lv_child_num := lv_child_num + 1;
			lv_tickets := lv_tickets + 1;
		END IF;

		IF lv_adult_num <= 0 THEN
			dbms_output.put_line('Could not reach exact number.');
			dbms_output.put_line('Number of Adults: '		||lv_adult_num);
			dbms_output.put_line('Number of Children: '	||lv_child_num);
			dbms_output.put_line('Total Tickets Sold: '	||lv_tickets||'/'||pv_tickets_sold);
			dbms_output.put_line('Total Revenue: '			||total||'/'||pv_total_revenue);
			RETURN;
		END IF;
	END LOOP;

	dbms_output.put_line('Number of Adults: '		||lv_adult_num);
	dbms_output.put_line('Number of Children: '	||lv_child_num);
	dbms_output.put_line('Total Tickets Sold: '	||lv_tickets||'/'||pv_tickets_sold);
	dbms_output.put_line('Total Revenue: '			||total||'/'||pv_total_revenue);
END;
/

-- LIST
-- SHOW ERRORS

DECLARE
	lv_adult_price 		NUMBER;
  lv_child_price 		NUMBER;
  lv_total_revenue 	NUMBER;
  lv_tickets_sold 	NUMBER;
BEGIN
	lv_adult_price 		:= 7;
	lv_child_price 		:= 5;
	lv_total_revenue 	:= 950;
	lv_tickets_sold 	:= 90;
	interview(lv_adult_price,lv_child_price,lv_total_revenue,lv_tickets_sold);
END;
/
