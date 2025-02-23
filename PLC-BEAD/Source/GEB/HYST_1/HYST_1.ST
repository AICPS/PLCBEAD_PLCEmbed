FUNCTION_BLOCK HYST_1_Block

	VAR_INPUT
		IN :	REAL;
		HIGH :	REAL;
		LOW :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		WIN :	BOOL;
	END_VAR

	IF IN < LOW THEN
		Q := FALSE;
		WIN := FALSE;
	ELSIF IN > HIGH THEN
		Q := TRUE;
		WIN := FALSE;
	ELSE
		WIN := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		HIGH :	REAL;
		LOW :	REAL;
		Q :	BOOL;
		WIN :	BOOL;
		func_block : HYST_1_Block;
	END_VAR
	func_block.IN := IN;
	func_block.HIGH := HIGH;
	func_block.LOW := LOW;
	func_block();
	Q  := func_block.Q;
	WIN  := func_block.WIN;
END_PROGRAM

