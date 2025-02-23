TYPE oscat_vector_3 :
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_XPRO_Block
	VAR_INPUT
		A :	oscat_vector_3;
		B :	oscat_vector_3;
	END_VAR


	VAR_OUTPUT
		V3_XPRO :	oscat_vector_3;
	END_VAR


	V3_XPRO.X := A.Y * B.Z - A.Z * B.Y;
	V3_XPRO.Y := A.Z * B.X - A.X * B.Z;
	V3_XPRO.Z := A.X * B.Y - A.Y * B.X;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		B :	oscat_vector_3;
		V3_XPRO :	oscat_vector_3;
		func_block : V3_XPRO_Block;
  	END_VAR
	func_block.A := A;
	func_block.B := B;
	func_block();
	V3_XPRO := func_block.V3_XPRO;
END_PROGRAM

