TYPE oscat_vector_3:
	STRUCT
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK V3_REV_Block
	VAR_INPUT
		A :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_REV :	oscat_vector_3;
	END_VAR

	V3_REV.X := -A.X;
	V3_REV.Y := -A.Y;
	V3_REV.Z := -A.Z;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		V3_REV : oscat_vector_3;
		func_block : V3_REV_Block;
  	END_VAR
	func_block.A := A;
	func_block();
	V3_REV := func_block.V3_REV;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION