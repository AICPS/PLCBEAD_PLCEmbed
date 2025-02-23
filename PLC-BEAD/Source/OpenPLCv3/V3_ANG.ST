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
		V3_ABS : REAL;
	END_VAR

	V3_ABS := SQRT(A.X * A.X + A.Y * A.Y + A.Z * A.Z);

END_FUNCTION_BLOCK

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

FUNCTION_BLOCK V3_ANG_Block

	VAR_INPUT
		A :	oscat_vector_3;
		B :	oscat_vector_3;
	END_VAR


	VAR_OUTPUT
		V3_ANG :	REAL;
	END_VAR


	VAR
		d :	REAL;
		V3_ABS :	V3_ABS_Block;
		V3_DPRO :	V3_DPRO_Block;
	END_VAR

	V3_ABS(A:=A);
	d :=V3_ABS.V3_ABS;

	V3_ABS(A:=B);
	d := d * V3_ABS.V3_ABS;

	IF d > 0.0 THEN
		V3_DPRO(A:=A,B:=B);
		V3_ANG := ACOS(LIMIT(-1.0, V3_DPRO.V3_DPRO / d,1.0));
	ELSE
		V3_ANG := 0.0;

	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		B :	oscat_vector_3;
		V3_ANG :	REAL;
		func_block : V3_ANG_Block;
  	END_VAR
	func_block.A := A;
	func_block.B := B;
	func_block();
	V3_ANG := func_block.V3_ANG;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION