FUNCTION_BLOCK CAPITALIZE_Block
	VAR_INPUT
		STR :	STRING;
	END_VAR

	VAR_OUTPUT
		CAPITALIZE :	STRING;
	END_VAR

	VAR
		char :	BYTE;
		char2 :	BYTE;
		pos :	INT;
		L :	INT;
		first :	BOOL;
		str_temp :	STRING;
	END_VAR

	CAPITALIZE := str;
	first := TRUE;
	L := LEN(str);
	FOR pos := 1 TO L DO
		char := INT_TO_BYTE(GET_CHAR(str,pos));
		IF first THEN
			char2 := TO_UPPER(char);
			IF char <> char2 THEN
				str_temp := CAPITALIZE;
				CAPITALIZE := REPLACE(str_temp,BYTE_TO_STRING(char2,'%c'),1,pos);
			END_IF;
		END_IF;
		first := char = BYTE#32;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalOUT  : STRING;
	func_block : CAPITALIZE_Block;
  END_VAR
	func_block.CAPITALIZE := LocalVar0;
	func_block();
	LocalOUT := func_block.CAPITALIZE;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
