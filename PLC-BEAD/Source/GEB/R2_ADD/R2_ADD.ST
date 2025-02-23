TYPE REAL2 :
	
	STRUCT
		R1  : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

FUNCTION_BLOCK R2_ADD_Block

	VAR_INPUT
		X :	REAL2;
		Y :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_ADD :	REAL2;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR


	temp := X.RX;
	R2_ADD.RX := Y + X.R1  + X.RX;
	R2_ADD.R1  := temp - R2_ADD.RX + Y + X.R1 ;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	REAL2;
		Y :	REAL;

        R2_ADD :	REAL2;
		func_block : R2_ADD_Block;
	END_VAR
	func_block.X := X;
	func_block.Y := Y;
	func_block();
	R2_ADD := func_block.R2_ADD;

END_PROGRAM

