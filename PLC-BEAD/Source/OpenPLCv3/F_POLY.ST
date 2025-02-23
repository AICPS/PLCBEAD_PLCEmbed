TYPE
  oscat_arr_0_7               : ARRAY [0..7]    OF REAL;
END_TYPE

FUNCTION_BLOCK F_POLY_Block
	VAR_INPUT
		X :	REAL;
		C :	oscat_arr_0_7;
	END_VAR

	VAR_OUTPUT
		F_POLY :	REAL;
	END_VAR

	F_POLY := ((((((( c[7] * x + c[6] ) * x + c[5] ) * x + c[4] ) * x + c[3] ) * x + c[2] ) * x + c[1] ) * x + c[0] ) ;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		X :	REAL;
		C :	oscat_arr_0_7;

		F_POLY :	REAL;

		func_block : F_POLY_Block;
	END_VAR
	func_block.X := X;
	func_block.C := C;
	func_block();
	F_POLY  := func_block.F_POLY;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION