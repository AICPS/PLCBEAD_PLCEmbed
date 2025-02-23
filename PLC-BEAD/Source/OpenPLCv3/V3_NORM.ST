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

FUNCTION_BLOCK V3_NORM_Block



	VAR_INPUT
		A :	oscat_vector_3;
	END_VAR


	VAR_OUTPUT
		V3_NORM :	oscat_vector_3;
	END_VAR


	VAR
		la :	REAL;
		V3_SMUL :	V3_SMUL_Block;
		V3_ABS :	V3_ABS_Block;
	END_VAR



	V3_ABS(A:=A);
	la:=V3_ABS.V3_ABS;

	IF la > 0.0 THEN
		V3_SMUL(A:=A,M:=1.0/la);
		V3_NORM:=V3_SMUL.V3_SMUL;
	ELSE
		V3_NORM.X := 0.0;
		V3_NORM.Y := 0.0;
		V3_NORM.Z := 0.0;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		V3_NORM :	oscat_vector_3;
		func_block : V3_NORM_Block;
  	END_VAR
	func_block.A := A;
	func_block();
	V3_NORM := func_block.V3_NORM;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION