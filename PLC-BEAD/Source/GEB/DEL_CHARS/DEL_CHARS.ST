FUNCTION_BLOCK DEL_CHARS_Block
	VAR_INPUT
		IN :	STRING;
		CX :	STRING;
	END_VAR

	VAR_OUTPUT
		DEL_CHARS :	STRING;
	END_VAR

	VAR
		POS :	INT;
		STOP :	INT;
		CHAR :	STRING;
	END_VAR

	DEL_CHARS := IN;
	STOP := LEN(IN);
	POS := 1;
	WHILE POS <= STOP DO
		CHAR := MID(DEL_CHARS, 1, POS);
		IF FIND(CX,CHAR) > 0 THEN
			DEL_CHARS := DELETE(DEL_CHARS, 1, POS);
			STOP := STOP - 1;	
		ELSE
			POS := POS + 1;
		END_IF;
	END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : STRING;
	LocalVaR1  : STRING;
	LocalOUT  : STRING;
	func_block : DEL_CHARS_Block;
  END_VAR
	func_block.IN := LocalVar0;
	func_block.CX  := LocalVaR1 ;
	func_block();
	LocalOUT := func_block.DEL_CHARS;
END_PROGRAM

