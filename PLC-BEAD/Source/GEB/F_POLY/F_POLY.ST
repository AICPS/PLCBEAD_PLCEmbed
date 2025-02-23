TYPE
  oscat_arr_0_7               : ARRAY [0..7]    OF REAL;
END_TYPE

FUNCTION_BLOCK F_POLY_Block
	VAR_INPUT
		x :	REAL;
		C :	oscat_arr_0_7;
	END_VAR

	VAR_OUTPUT
		F_POLY :	REAL;
	END_VAR

	F_POLY := ((((((( C[7] * x + C[6] ) * x + C[5] ) * x + C[4] ) * x + C[3] ) * x + C[2] ) * x + C[1] ) * x + C[0] ) ;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		X :	REAL;
		C :	oscat_arr_0_7;

		F_POLY :	REAL;

		func_block : F_POLY_Block;
	END_VAR
	func_block.x := X;
	func_block.C := C;
	func_block();
	F_POLY  := func_block.F_POLY;
END_PROGRAM

