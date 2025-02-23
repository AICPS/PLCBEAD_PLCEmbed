FUNCTION_BLOCK DEBOUNCE_Block

	VAR_INPUT
		IN :	BOOL;
		TD :	TIME;
		PM :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		deb :	TOF;
	END_VAR

	IF NOT deb.Q AND IN THEN
		Q := TRUE;
	ELSIF NOT PM THEN
		Q := deb.Q;
	ELSE
		Q := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		TD :	TIME;
		PM :	BOOL;
		Q :	BOOL;

		func_block : DEBOUNCE_Block;
	END_VAR
	func_block.IN := IN;
	func_block.TD := TD;
	func_block.PM := PM ;

	func_block();
	Q  := func_block.Q;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION