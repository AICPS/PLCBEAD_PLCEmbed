FUNCTION_BLOCK HYST_Block

	VAR_INPUT
		IN :	REAL;
		_ON :	REAL;
		OFF :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		WIN :	BOOL;
	END_VAR

	IF _ON >= OFF THEN
		IF IN < OFF THEN
			Q := FALSE;
			WIN := FALSE;
		ELSIF  IN > _ON THEN
			Q := TRUE;
			WIN := FALSE;
		ELSE
			WIN := TRUE;
		END_IF;
	ELSE
		IF IN > OFF THEN
			Q := FALSE;
			WIN := FALSE;
		ELSIF  IN < _ON THEN
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
		_ON :	REAL;
		OFF :	REAL;
		Q :	BOOL;
		WIN :	BOOL;
		func_block : HYST_Block;
	END_VAR
	func_block.IN := IN;
	func_block._ON := _ON;
	func_block.OFF := OFF ;
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