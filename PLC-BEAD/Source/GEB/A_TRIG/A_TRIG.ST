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
		LAST_IN :	REAL;
	END_VAR

	D := IN - LAST_IN;
	IF ABS(D) >= RES THEN
		Q := TRUE;
		LAST_IN := IN;
	ELSE
		Q := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar0 : REAL;
		LocalVaR1  : REAL;
		LocalOUT1  : BOOL;
		LocalOUT2  : REAL;
		func_block : A_TRIG;
  	END_VAR
	func_block.IN := LocalVar0;
    func_block.RES := LocalVaR1 ;
	func_block();
	LocalOUT1 := func_block.Q;
	LocalOUT2 := func_block.D;
END_PROGRAM

