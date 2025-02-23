TYPE oscat_vector_3 :
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

FUNCTION_BLOCK V3_XANG_Block



	VAR_INPUT
		A :	oscat_vector_3;
	END_VAR


	VAR_OUTPUT
		V3_XANG :	REAL;
	END_VAR


	VAR
		la :	REAL;
		V3_ABS :	V3_ABS_Block;
	END_VAR



	V3_ABS(A:=A);
	la:=V3_ABS.V3_ABS;

	IF la > 0.0 THEN
		V3_XANG := ACOS(A.X / la);
	ELSE
		V3_XANG := 0.0;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		A :	oscat_vector_3;
		V3_XANG :	REAL;
		func_block : V3_XANG_Block;
  	END_VAR
	func_block.A := A;
	func_block();
	V3_XANG := func_block.V3_XANG;
END_PROGRAM

