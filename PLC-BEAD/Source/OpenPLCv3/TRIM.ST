FUNCTION_BLOCK TRIM



	VAR_INPUT
		STR :	STRING;
	END_VAR


	VAR_OUTPUT
		TRIM3 :	STRING;
	END_VAR


	VAR
		pos :	INT;
	END_VAR


	trim3 := str;
	REPEAT
		pos := FIND(trim3,' ');
		IF pos > 0 THEN trim3 := REPLACE(trim3,'',1,pos); END_IF;
	UNTIL pos = 0 END_REPEAT;

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

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION