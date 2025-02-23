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

FUNCTION_BLOCK V3_PAR_Block
	VAR_INPUT
		A :	oscat_vector_3;
		B :	oscat_vector_3;
	END_VAR

	VAR_OUTPUT
		V3_PAR :	BOOL;
	END_VAR

	VAR
		V3_XPRO :	V3_XPRO_Block;
		V3_ABS :	V3_ABS_Block;
	END_VAR


	V3_XPRO(A:=A,B:=B);
	V3_ABS(A:=V3_XPRO.V3_XPRO);

	V3_PAR := V3_ABS.V3_ABS = 0.0;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		B :	oscat_vector_3;
		V3_PAR :	BOOL;
		func_block : V3_PAR_Block;
  	END_VAR
	func_block.A := A;
	func_block.B := B;
	func_block();
	V3_PAR := func_block.V3_PAR;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION