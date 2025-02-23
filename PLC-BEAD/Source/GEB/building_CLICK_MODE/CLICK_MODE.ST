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
		CNT :	INT;
		last :	BOOL;
	END_VAR

	timer(IN := IN, PT := T_LONG);
	single := FALSE;
	double := FALSE;

	IF timer.Q THEN
		IF NOT IN AND last THEN	CNT := CNT + 1; END_IF;
	ELSE
		CASE CNT OF
			1 : single := TRUE;
			2 : double := TRUE;
		END_CASE;
		CNT := 0;
	END_IF;
	last := IN;
	TP_LONG := NOT timer.Q AND (NOT LONG) AND IN;
	LONG := NOT timer.Q AND IN;

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

