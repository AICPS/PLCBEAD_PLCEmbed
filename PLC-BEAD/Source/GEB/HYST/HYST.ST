FUNCTION_BLOCK HYST_Block

	VAR_INPUT
		IN :	REAL;
		ONN :	REAL;
		OFF :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		WIN :	BOOL;
	END_VAR

	IF ONN >= OFF THEN
		IF IN < OFF THEN
			Q := FALSE;
			WIN := FALSE;
		ELSIF  IN > ONN THEN
			Q := TRUE;
			WIN := FALSE;
		ELSE
			WIN := TRUE;
		END_IF;
	ELSE
		IF IN > OFF THEN
			Q := FALSE;
			WIN := FALSE;
		ELSIF  IN < ONN THEN
			Q := TRUE;
			WIN := FALSE;
		ELSE
			WIN := TRUE;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		ONN :	REAL;
		OFF :	REAL;
		Q :	BOOL;
		WIN :	BOOL;
		func_block : HYST_Block;
	END_VAR
	func_block.IN := IN;
	func_block.ONN := ONN;
	func_block.OFF := OFF ;
	func_block();
	Q  := func_block.Q;
	WIN  := func_block.WIN;
END_PROGRAM

