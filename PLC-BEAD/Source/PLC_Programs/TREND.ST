FUNCTION_BLOCK TREND



	VAR_INPUT
		X :	REAL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		TU :	BOOL;
		TD :	BOOL;
		D :	REAL;
	END_VAR


	VAR
		last_x :	REAL;
	END_VAR


	TU := X > last_X;
	TD := X < last_X;
	Q := TU OR TD;
	D := X - LAST_X;

	last_X := X;



END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	REAL;
	Q :	BOOL;
	TU :	BOOL;
	TD :	BOOL;
	D :	REAL;
	func_block : TREND;
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