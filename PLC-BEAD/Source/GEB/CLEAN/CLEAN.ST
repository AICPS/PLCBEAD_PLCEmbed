FUNCTION_BLOCK CLEAN_Block
	VAR_INPUT
		IN :	STRING;
		CX :	STRING;
	END_VAR

	VAR_OUTPUT
		CLEAN :	STRING;
	END_VAR

	VAR
		POS :	INT;
		STOP :	INT;
		CHAR :	STRING;
	END_VAR

	CLEAN := IN;
	STOP := LEN(IN);
	POS := 1;
	WHILE POS <= STOP DO
		CHAR := MID(CLEAN, 1, POS);
		IF FIND(CX,CHAR) > 0 THEN
			POS := POS + 1;
		ELSE
			CLEAN := DELETE(CLEAN, 1, POS);
			STOP := STOP - 1;	
		END_IF;
	END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
    LocalVaR1  : STRING;
	LocalOUT  : STRING;
	func_block : CLEAN_Block;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.CX := LocalVaR1 ;
	func_block();
	LocalOUT := func_block.CLEAN;

END_PROGRAM

