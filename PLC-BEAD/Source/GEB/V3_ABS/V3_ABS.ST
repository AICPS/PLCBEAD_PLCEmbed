TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_ABS_Block

	VAR_INPUT
		A :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_ABS :	REAL;
	END_VAR

	V3_ABS := SQRT(A.X * A.X + A.Y * A.Y + A.Z * A.Z);

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		V3_ABS :	REAL;
		func_block : V3_ABS_Block;
  	END_VAR
	func_block.A := A;
	func_block();
	V3_ABS := func_block.V3_ABS;
END_PROGRAM

