FUNCTION_BLOCK SH_Block

	VAR_INPUT
		IN :	REAL;
		CLK :	BOOL;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
		TRIG :	BOOL;
	END_VAR

	VAR
		edge :	BOOL;
	END_VAR

	IF CLK AND NOT edge THEN
		OUT := IN;
		TRIG := TRUE;
	ELSE
		TRIG := FALSE;
	END_IF;
	edge := CLK;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		IN :	REAL;
		CLK :	BOOL;
		OUT :	REAL;
		TRIG :	BOOL;
		func_block : SH_Block;
	END_VAR
		func_block.IN  :=IN;
		func_block.CLK  :=CLK;
		func_block();
		OUT := func_block.OUT;
		TRIG := func_block.TRIG;

END_PROGRAM

