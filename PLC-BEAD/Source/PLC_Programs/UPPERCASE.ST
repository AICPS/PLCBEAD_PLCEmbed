FUNCTION_BLOCK UPPERCASE_Block

	VAR_INPUT
		STR :	STRING;
	END_VAR

	VAR_OUTPUT
		UPPERCASE :	STRING;
	END_VAR

	VAR
		char :	BYTE;
		char2 :	BYTE;
		pos :	INT;
		l :	INT;
		str_temp :	STRING;
	END_VAR

	UPPERCASE := str;
	l := LEN(str);
	FOR pos := 1 TO l DO
		char := INT_TO_BYTE(GET_CHAR(str,pos));
		char2 := TO_UPPER(char);
		IF char <> char2 THEN
			str_temp := UPPERCASE;
			UPPERCASE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar1 : STRING;
		LocalOUT  : STRING;
		func_block : UPPERCASE_Block;
  	END_VAR
	func_block.STR := LocalVar1;
	func_block();
	LocalOUT := func_block.UPPERCASE;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION