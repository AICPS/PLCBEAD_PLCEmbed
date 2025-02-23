FUNCTION_BLOCK FINDB_Block

	VAR_INPUT
		STR1  :	STRING;
		STR2 :	STRING;
	END_VAR

	VAR_OUTPUT
		FINDB :	INT;
	END_VAR

	VAR
		POS :	INT;
		length :	INT;
		string_temp :	STRING;
	END_VAR

	length := LEN(STR2);
	POS := LEN(STR1 ) - length +1;
	WHILE (POS >= 1) DO
		string_temp := MID(STR1 ,length,POS);
		IF EQ_STRING(string_temp,STR2) THEN
			FINDB := POS;
			RETURN;
		END_IF;
	POS := POS -1;
	END_WHILE;
	FINDB := 0;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		STR1  :	STRING;
		STR2 :	STRING;

		FINDB :	INT;

	func_block : FINDB_Block;
  END_VAR
	func_block.STR1   := STR1 ;
	func_block.STR2  := STR2;
	func_block();
	FINDB := func_block.FINDB;
END_PROGRAM

