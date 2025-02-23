FUNCTION_BLOCK HYST_3_Block

	VAR_INPUT
		IN :	REAL;
		HYST :	REAL;
		VAL1 :	REAL;
		VAL2 :	REAL;
	END_VAR


	VAR_OUTPUT
		Q1 :	BOOL;
		Q2 :	BOOL;
	END_VAR


	VAR
		X :	REAL;
	END_VAR

	X := hyst * 0.5;
	IF in < val1 - X THEN
		q1 := TRUE;
	ELSIF in > val1 + X THEN
		q1 := FALSE;
	END_IF;
	IF in < val2 - X THEN
		q2 := FALSE;
	ELSIF in > val2 + X THEN
		q2 := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	REAL;
		HYST :	REAL;
		VAL1 :	REAL;
		VAL2 :	REAL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		func_block : HYST_3_Block;
	END_VAR
	func_block.IN := IN;
	func_block.HYST := HYST;
	func_block.VAL1 := VAL1;
	func_block.VAL2 := VAL2;
	func_block();
	Q1  := func_block.Q1;
	Q2  := func_block.Q2;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION