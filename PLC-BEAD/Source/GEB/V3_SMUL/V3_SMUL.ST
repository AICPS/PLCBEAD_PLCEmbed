TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_SMUL_Block
	VAR_INPUT
		A :	oscat_vector_3;
		M :	REAL;
	END_VAR

	VAR_OUTPUT
		V3_SMUL :	oscat_vector_3;
	END_VAR

	V3_SMUL.X := A.X * M;
	V3_SMUL.Y := A.Y * M;
	V3_SMUL.Z := A.Z * M;
END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		M :	REAL;
		V3_SMUL :	oscat_vector_3;
		func_block : V3_SMUL_Block;
  	END_VAR
	func_block.A := A;
	func_block.M := M;
	func_block();
	V3_SMUL := func_block.V3_SMUL;
END_PROGRAM

