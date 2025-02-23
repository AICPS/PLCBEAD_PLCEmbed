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

	IF in < low THEN
		Q := FALSE;
		win := FALSE;
	ELSIF in > high THEN
		Q := TRUE;
		win := FALSE;
	ELSE
		win := TRUE;
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

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION