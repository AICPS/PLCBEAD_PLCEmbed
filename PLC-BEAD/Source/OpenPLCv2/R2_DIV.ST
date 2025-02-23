TYPE REAL2 :
	
	STRUCT
		R1 : REAL;
		RX : REAL;
	END_STRUCT;

END_TYPE

FUNCTION_BLOCK R2_DIV_Block

	VAR_INPUT
		X :	REAL2;
		Y :	REAL;
	END_VAR

	VAR_OUTPUT
		R2_DIV :	REAL2;
	END_VAR


	R2_DIV.RX := X.RX / Y;
	R2_DIV.R1 := X.R1 / Y;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	REAL2;
		Y :	REAL;

        R2_DIV :	REAL2;
		func_block : R2_DIV_Block;
	END_VAR
	func_block.X := X;
	func_block.Y := Y;
	func_block();
	R2_DIV := func_block.R2_DIV;

END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
