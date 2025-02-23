FUNCTION_BLOCK CODE_250
	VAR_INPUT
		STR :	STRING;
		POS :	INT;
	END_VAR

	VAR_OUTPUT
		CODE :	BYTE;
	END_VAR

	IF pos < 1 OR pos > LEN(str) THEN
		CODE := BYTE#0;
		RETURN;
	ELSE
		CODE := INT_TO_BYTE(GET_CHAR(STR,POS));
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalVar1 : INT;
	LocalOUT  : BYTE;
	func_block : CODE_250;
  END_VAR
	func_block.STR  := LocalVar0;
	func_block.POS  := LocalVar1;
	func_block();
	LocalOUT := func_block.CODE;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION