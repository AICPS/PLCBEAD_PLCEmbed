TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_NUL_Block

	VAR_INPUT
		A :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_NUL :	BOOL;
	END_VAR

	V3_NUL := A.X = 0.0 AND A.Y = 0.0 AND A.Z = 0.0;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		V3_NUL :	BOOL;
		func_block : V3_NUL_Block;
  	END_VAR
	func_block.A := A;
	func_block();
	V3_NUL := func_block.V3_NUL;
END_PROGRAM

