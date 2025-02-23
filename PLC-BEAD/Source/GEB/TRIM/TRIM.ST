FUNCTION_BLOCK TRIM



	VAR_INPUT
		STR :	STRING;
	END_VAR


	VAR_OUTPUT
		TRIM3 :	STRING;
	END_VAR


	VAR
		POS :	INT;
	END_VAR


	trim3 := str;
	REPEAT
		POS := FIND(trim3,' ');
		IF POS > 0 THEN trim3 := REPLACE(trim3,'',1,POS); END_IF;
	UNTIL POS = 0 END_REPEAT;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	STR :	STRING;

	TRIM3 :	STRING;
	func_block : TRIM;
  END_VAR
	func_block.STR  :=STR ;
	func_block();
	TRIM3 := func_block.TRIM3;

END_PROGRAM

