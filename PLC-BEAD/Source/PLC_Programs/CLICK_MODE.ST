FUNCTION_BLOCK CLICK_MODE_Block

	VAR_INPUT
		IN :	BOOL;
		T_LONG :	TIME := T#500ms;
	END_VAR


	VAR_OUTPUT
		SINGLE :	BOOL;
		DOUBLE :	BOOL;
		LONG :	BOOL;
		TP_LONG :	BOOL;
	END_VAR


	VAR
		Timer :	TP;
		cnt :	INT;
		last :	BOOL;
	END_VAR

	timer(in := IN, PT := T_LONG);
	single := FALSE;
	double := FALSE;

	IF timer.Q THEN
		IF NOT in AND last THEN	cnt := cnt + 1; END_IF;
	ELSE
		CASE cnt OF
			1 : single := TRUE;
			2 : double := TRUE;
		END_CASE;
		cnt := 0;
	END_IF;
	last := in;
	TP_LONG := NOT timer.Q AND (NOT LONG) AND IN;
	LONG := NOT timer.Q AND in;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		T_LONG :	TIME := T#500ms;
		SINGLE :	BOOL;
		DOUBLE :	BOOL;
		LONG :	BOOL;
		TP_LONG :	BOOL;

		func_block : CLICK_MODE_Block;
	END_VAR
	func_block.IN := IN;
	func_block.T_LONG := T_LONG;

	func_block();
	SINGLE  := func_block.SINGLE;
	DOUBLE  := func_block.DOUBLE;
	LONG  := func_block.LONG;
	TP_LONG  := func_block.TP_LONG;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION