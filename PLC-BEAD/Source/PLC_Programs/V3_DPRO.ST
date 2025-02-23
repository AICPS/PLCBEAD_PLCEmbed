TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_DPRO_Block

	VAR_INPUT
		A :	oscat_vector_3;
		B :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_DPRO :	REAL;
	END_VAR


	V3_DPRO := A.X * B.X + A.Y * B.Y + A.Z * B.Z;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		B :	oscat_vector_3;
		V3_DPRO : REAL;
		func_block : V3_DPRO_Block;
  	END_VAR
	func_block.A := A;
	func_block.B := B;
	func_block();
	V3_DPRO := func_block.V3_DPRO;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION