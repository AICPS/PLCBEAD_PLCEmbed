
FUNCTION_BLOCK DEC_TO_BYTE_Block
	VAR_INPUT
		DEC :	STRING;
	END_VAR

	VAR_OUTPUT
		DEC_TO_BYTE :	BYTE;
	END_VAR

	VAR
		i :	INT;
		X :	INT;
		stop :	INT;
	END_VAR

	DEC_TO_BYTE := BYTE#0;
	stop := LEN(DEC);
	FOR I := 1 TO stop DO
		X := GET_CHAR(DEC,I);
		IF X > 47 AND X < 58 THEN
			DEC_TO_BYTE := INT_TO_BYTE(_BYTE_TO_INT(DEC_TO_BYTE) * 10 + X - 48);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalOUT  : BYTE;
	func_block : DEC_TO_BYTE_Block;
  END_VAR
	func_block.DEC  := LocalVar0;
	func_block();
	LocalOUT := func_block.DEC_TO_BYTE;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION