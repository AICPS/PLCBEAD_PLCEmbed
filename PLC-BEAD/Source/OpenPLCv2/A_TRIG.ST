FUNCTION_BLOCK A_TRIG

	VAR_INPUT
		IN :	REAL;
		RES :	REAL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
		D :	REAL;
	END_VAR

	VAR
		last_in :	REAL;
	END_VAR

	D := IN - LAST_IN;
	IF ABS(D) >= res THEN
		Q := TRUE;
		last_in := IN;
	ELSE
		Q := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar0 : REAL;
		LocalVar1 : REAL;
		LocalOUT1  : BOOL;
		LocalOUT2  : REAL;
		func_block : A_TRIG;
  	END_VAR
	func_block.IN := LocalVar0;
    func_block.RES := LocalVar1;
	func_block();
	LocalOUT1 := func_block.Q;
	LocalOUT2 := func_block.D;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION