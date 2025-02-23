FUNCTION_BLOCK HEAT_TEMP_Block

	VAR_INPUT
		T_EXT :	REAL;
		T_INT :	REAL;
		OFFSET :	REAL;
		T_REQ :	REAL;
		TY_MAX :	REAL := REAL#70.0;
		TY_MIN :	REAL := REAL#25.0;
		TY_CONFIG :	REAL := REAL#70.0;
		T_INT_CONFIG :	REAL := REAL#20.0;
		T_EXT_CONFIG :	REAL := REAL#-15.0;
		T_DIFF :	REAL := REAL#10.0;
		C :	REAL := REAL#1.33;
		H :	REAL := REAL#3.0;
	END_VAR


	VAR_OUTPUT
		TY :	REAL;
		HEAT :	BOOL;
	END_VAR


	VAR
		tr :	REAL;
		tx :	REAL;
	END_VAR

	tr := T_INT + OFFSET;
	tx := (tr - T_EXT) / (T_INT_CONFIG - T_EXT_CONFIG);

	IF T_EXT + H > tr THEN
		TY := 0.0;
	ELSE
		TY := LIMIT(TY_MIN, tr + T_DIFF * 0.5 * tx + (TY_CONFIG - T_DIFF * 0.5 - tr) * EXPT(tx, 1.0 / C), TY_MAX);
	END_IF;

	TY := MAX(TY, T_REQ);
	HEAT := TY > 0.0;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		T_EXT :	REAL;
		T_INT :	REAL;
		OFFSET :	REAL;
		T_REQ :	REAL;
		TY_MAX :	REAL := REAL#70.0;
		TY_MIN :	REAL := REAL#25.0;
		TY_CONFIG :	REAL := REAL#70.0;
		T_INT_CONFIG :	REAL := REAL#20.0;
		T_EXT_CONFIG :	REAL := REAL#-15.0;
		T_DIFF :	REAL := REAL#10.0;
		C :	REAL := REAL#1.33;
		H :	REAL := REAL#3.0;
		TY :	REAL;
		HEAT :	BOOL;

		func_block : HEAT_TEMP_Block;
	END_VAR
	func_block.T_EXT := T_EXT;
	func_block.T_INT := T_INT;
	func_block.OFFSET := OFFSET ;
	func_block.T_REQ    := T_REQ    ;
	func_block.TY_MAX := TY_MAX;
	func_block.TY_MIN := TY_MIN;
	func_block.TY_CONFIG := TY_CONFIG ;
	func_block.T_INT_CONFIG := T_INT_CONFIG ;
	func_block.T_EXT_CONFIG    := T_EXT_CONFIG    ;
	func_block.T_DIFF    := T_DIFF    ;
	func_block.C := C;
	func_block.H := H;

	func_block();
	TY  := func_block.TY;
	HEAT  := func_block.HEAT;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION