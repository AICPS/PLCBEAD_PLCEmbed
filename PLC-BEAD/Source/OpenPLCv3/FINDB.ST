FUNCTION_BLOCK FINDB_Block

	VAR_INPUT
		STR1 :	STRING;
		STR2 :	STRING;
	END_VAR

	VAR_OUTPUT
		FINDB :	INT;
	END_VAR

	VAR
		pos :	INT;
		length :	INT;
		string_temp :	STRING;
	END_VAR

	length := LEN(str2);
	pos := LEN(str1) - length +1;
	WHILE (pos >= 1) DO
		string_temp := MID(str1,length,pos);
		IF EQ_STRING(string_temp,str2) THEN
			FindB := pos;
			RETURN;
		END_IF;
	pos := pos -1;
	END_WHILE;
	FindB := 0;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		STR1 :	STRING;
		STR2 :	STRING;

		FINDB :	INT;

	func_block : FINDB_Block;
  END_VAR
	func_block.STR1  := STR1;
	func_block.STR2  := STR2;
	func_block();
	FINDB := func_block.FINDB;
END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION