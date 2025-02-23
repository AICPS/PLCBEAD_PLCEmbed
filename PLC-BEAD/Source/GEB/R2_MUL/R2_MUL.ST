TYPE REAL2 :
	
	STRUCT
		R1  : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

FUNCTION_BLOCK R2_MUL_Block

	VAR_INPUT
		X :	REAL2;
		Y :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_MUL :	REAL2;
	END_VAR


	R2_MUL.RX := X.RX * Y;
	R2_MUL.R1  := X.R1  * Y;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	REAL2;
		Y :	REAL;

        R2_MUL :	REAL2;
		func_block : R2_MUL_Block;
	END_VAR
	func_block.X := X;
	func_block.Y := Y;
	func_block();
	R2_MUL := func_block.R2_MUL;

	END_PROGRAM

