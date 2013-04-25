/*
						COMMON_LOOKUP
 -----------------------------------------------------
| ID 	 | 	CL_TABLE 	  | 	CL_COLUMN 	| 	CL_TYPE 		|
|------|--------------|---------------|---------------|
| 1001 |	SANDWICH 		|		BREAD 			| WHITE					|
| 1002 |	SANDWICH 		|		BREAD				| WHEAT					|
| 1003 |	SANDWICH 		|		BREAD 			| RYE						|
| 1004 |	SANDWICH 		|		MEAT				| ROAST_BEEF		|
| 1005 |	SANDWICH 		|		MEAT 				| HAM						|
| 1006 |	SANDWICH 		|		MEAT				| TURKEY				|
| 1007 |	SANDWICH 		|		SPREAD 			| PEANUT_BUTTER	|
| 1008 |	SANDWICH 		|		SPREAD 			| JELLY					|
| 1009 |	SANDWICH 		|		SPREAD 			| HONEY					|
| 1010 |	SANDWICH 		|		VEGETABLE		| LETTUCE				|
| 1011 |	SANDWICH 		|		VEGETABLE 	| TOMATO				|
| 1012 |	SANDWICH 		|		VEGETABLE 	| ONION					|
| 1013 |	SANDWICH 		|		SPREAD 		  | MUSTARD				|
| 1014 |	SANDWICH 		|		SPREAD 		  | MAYO					|
| 1015 |	SANDWICH 		|		CONDIMENTS 	| SALT					|
| 1016 |	SANDWICH 		|		CONDIMENTS  | PEPPER				|
 -----------------------------------------------------

							SANDWICH TABLE
 -----------------------------------------------------------------------------
| ID 	 	| 	BREAD 	| 	MEAT 	| 	SPREAD_1 	| 	SPREAD_2 	| VEG_1 	| VEG_2 	|
|-------|-----------|---------|-------------|-------------|---------|---------|
| 1001 	| 1002 	 		| 1004 		| 1014 				| NULL 				| 1010 		| 1011 		|
| 1002 	| 1001 	 		| NULL 		| 1007 				| 1008 				| NULL 		| NULL 		|
| 1003 	| 1003 	 		| NULL 		| 1007 				| 1014 				| 1010 		| NULL 		|
 -----------------------------------------------------------------------------
*/













