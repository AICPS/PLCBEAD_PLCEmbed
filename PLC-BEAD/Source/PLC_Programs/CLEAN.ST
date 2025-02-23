FUNCTION_BLOCK CLEAN_Block
	VAR_INPUT
		IN :	STRING;
		CX :	STRING;
	END_VAR

	VAR_OUTPUT
		CLEAN :	STRING;
	END_VAR

	VAR
		pos :	INT;
		stop :	INT;
		char :	STRING;
	END_VAR

	CLEAN := IN;
	stop := LEN(in);
	pos := 1;
	WHILE pos <= stop DO
		char := MID(CLEAN, 1, pos);
		IF FIND(cx,char) > 0 THEN
			pos := pos + 1;
		ELSE
			CLEAN := DELETE(CLEAN, 1, pos);
			stop := stop - 1;	
		END_IF;
	END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
    LocalVar1 : STRING;
	LocalOUT  : STRING;
	func_block : CLEAN_Block;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.CX := LocalVar1;
	func_block();
	LocalOUT := func_block.CLEAN;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION