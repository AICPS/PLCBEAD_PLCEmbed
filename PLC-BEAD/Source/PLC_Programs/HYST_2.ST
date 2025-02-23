FUNCTION_BLOCK HYST_2_Block

	VAR_INPUT
		IN :	REAL;
		VAL :	REAL;
		HYS :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		WIN :	BOOL;
	END_VAR


	VAR
		tmp :	REAL;
	END_VAR

	tmp := val - hys * 0.5;
	IF in < tmp THEN
		Q := FALSE;
		win := FALSE;
	ELSIF in > tmp + hys THEN
		Q := TRUE;
		win := FALSE;
	ELSE
		win := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		VAL :	REAL;
		HYS :	REAL;
		Q :	BOOL;
		WIN :	BOOL;
		func_block : HYST_2_Block;
	END_VAR
	func_block.IN := IN;
	func_block.VAL := VAL;
	func_block.HYS := HYS;
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