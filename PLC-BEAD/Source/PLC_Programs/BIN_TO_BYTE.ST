TYPE
  oscat_STRING12              : STRING(12);
END_TYPE

FUNCTION_BLOCK BIN_TO_BYTE_Block
	VAR_INPUT
		BIN :	oscat_STRING12;
	END_VAR

	VAR_OUTPUT
		BIN_TO_BYTE :	BYTE;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
		X :	INT;
	END_VAR

	BIN_TO_BYTE := BYTE#0;
	stop := LEN(bin);
	FOR I := 1 TO LEN(BIN) DO
		X := GET_CHAR(BIN,I);
		(* calculate the value of the digit *)
		IF X = 48 THEN
			BIN_TO_BYTE := SHL_BYTE(BIN_TO_BYTE,1);
		ELSIF X = 49 THEN
			BIN_TO_BYTE := SHL_BYTE(BIN_TO_BYTE,1) OR BYTE#1;
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_STRING12;
	LocalOUT  : BYTE;
	func_block : BIN_TO_BYTE_Block;
  END_VAR
	func_block.BIN := LocalVar0;
	func_block();
	LocalOUT := func_block.BIN_TO_BYTE;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION