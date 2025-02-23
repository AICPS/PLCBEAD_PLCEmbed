FUNCTION_BLOCK LOWERCASE_Block

	VAR_INPUT
		STR :	STRING;
	END_VAR


	VAR_OUTPUT
		LOWERCASE :	STRING;
	END_VAR


	VAR
		char :	BYTE;
		char2 :	BYTE;
		pos :	INT;
		l :	INT;
		str_temp :	STRING;
	END_VAR


	LOWERCASE := str;
	l := LEN(str);
	FOR pos := 1 TO l DO
		char := INT_TO_BYTE(GET_CHAR(str,pos));
		char2 := TO_LOWER(char);
		IF char <> char2 THEN
			str_temp := LOWERCASE;
			LOWERCASE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    OCT : STRING;
    LOWERCASE : STRING;
	func_block : LOWERCASE_Block;
  END_VAR

  	func_block.OCT := '125'; 
	func_block()
	LOWERCASE := func_block.LOWERCASE; 
END_PROGRAM


CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION
