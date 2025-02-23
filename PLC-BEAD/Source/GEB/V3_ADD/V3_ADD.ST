TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_ADD_Block
	VAR_INPUT
		A :	oscat_vector_3;
		B :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_ADD :	oscat_vector_3;
	END_VAR

	V3_ADD.X := A.X + B.X;
	V3_ADD.Y := A.Y + B.Y;
	V3_ADD.Z := A.Z + B.Z;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		B :	oscat_vector_3;
		V3_ADD :	oscat_vector_3;
		func_block : V3_ADD_Block;
  	END_VAR
	func_block.A := A;
	func_block.B := B;
	func_block();
	V3_ADD := func_block.V3_ADD;
END_PROGRAM

