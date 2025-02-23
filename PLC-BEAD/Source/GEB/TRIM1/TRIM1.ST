FUNCTION_BLOCK TRIM1



	VAR_INPUT
		STR :	STRING;
	END_VAR


	VAR_OUTPUT
		TRIM3 :	STRING;
	END_VAR


	VAR
		POS :	INT;
		st_temp :	STRING;
	END_VAR


	trim3 := str;
	REPEAT
		POS := FIND(trim3,'  ');
		IF POS > 0 THEN
		st_temp := trim3;
		trim3 := REPLACE(trim3,' ',2,POS);
		END_IF;
	UNTIL POS = 0 END_REPEAT;
	st_temp := LEFT(trim3,1);
	IF EQ_STRING(st_temp,' ') THEN trim3 := DELETE(trim3,1,1); END_IF;
	st_temp := RIGHT(trim3,1);
	IF EQ_STRING(st_temp,' ') THEN trim3 := DELETE(trim3,1,LEN(trim3)); END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	STR :	STRING;

	TRIM3 :	STRING;
	func_block : TRIM1;
  END_VAR
	func_block.STR  :=STR ;
	func_block();
	TRIM3 := func_block.TRIM3;

END_PROGRAM

