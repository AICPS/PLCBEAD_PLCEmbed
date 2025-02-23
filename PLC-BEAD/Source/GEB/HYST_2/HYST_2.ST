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

	tmp := VAL - HYS * 0.5;
	IF IN < tmp THEN
		Q := FALSE;
		WIN := FALSE;
	ELSIF IN > tmp + HYS THEN
		Q := TRUE;
		WIN := FALSE;
	ELSE
		WIN := TRUE;
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

