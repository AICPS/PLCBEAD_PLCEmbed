FUNCTION_BLOCK FINDB_NONUM_Block

	VAR_INPUT
		STR :	STRING;
	END_VAR

	VAR_OUTPUT
		FINDB_NONUM :	INT;
	END_VAR

	VAR
		pos :	INT;
		x :	INT;
	END_VAR

	pos := LEN(str);
	WHILE (pos >=1) DO
		x :=GET_CHAR(str,pos);
		IF (X < 48 AND X <> 46) OR X > 57 THEN
			findB_nonum := pos;
			RETURN;
		END_IF;
	pos := pos -1;
	END_WHILE;
	findB_nonum := 0;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		STR :	STRING;

		FINDB_NONUM :	INT;

		func_block : FINDB_NONUM_Block;
	END_VAR
	func_block.STR := STR;
	func_block();
	FINDB_NONUM  := func_block.FINDB_NONUM;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION