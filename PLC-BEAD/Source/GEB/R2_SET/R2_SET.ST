TYPE REAL2 :
	
	STRUCT
		R1  : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

FUNCTION_BLOCK R2_SET_Block

	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_SET :	REAL2;
	END_VAR

	R2_SET.RX := X;
	R2_SET.R1  := 0.0;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	REAL;

        R2_SET :	REAL2;
		func_block : R2_SET_Block;
	END_VAR
	func_block.X := X;
	func_block();
	R2_SET := func_block.R2_SET;

	END_PROGRAM

