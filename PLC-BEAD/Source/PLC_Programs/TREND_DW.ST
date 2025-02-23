FUNCTION_BLOCK TREND_DW
	VAR_INPUT
		X :	DWORD;
	END_VAR
	VAR_OUTPUT
		Q :	BOOL;
		TU :	BOOL;
		TD :	BOOL;
		D :	DWORD;
	END_VAR

	VAR
		LAST_X :	DWORD;
	END_VAR

	IF X > last_X THEN
		TU := TRUE;
		TD := FALSE;
		D := UDINT_TO_DWORD(DWORD_TO_UDINT(X) - DWORD_TO_UDINT(last_X));
		Q := TRUE;
	ELSIF X < last_X THEN
		TD := TRUE;
		TU := FALSE;
		D := UDINT_TO_DWORD(DWORD_TO_UDINT(last_X) - DWORD_TO_UDINT(X));
		Q := FALSE;
	ELSE
		TU := FALSE;
		TD := FALSE;
		D := DWORD#0;
	END_IF;
	last_X := X;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	DWORD;
	Q :	BOOL;
	TU :	BOOL;
	TD :	BOOL;
	D :	DWORD;
	func_block : TREND_DW;
  END_VAR
	func_block.X  :=X ;
	func_block();
	Q := func_block.Q;
	TU := func_block.TU;
	TD := func_block.TD;
	D := func_block.D;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION