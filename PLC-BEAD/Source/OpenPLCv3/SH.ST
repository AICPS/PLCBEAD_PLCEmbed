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

	IF clk AND NOT edge THEN
		out := in;
		trig := TRUE;
	ELSE
		trig := FALSE;
	END_IF;
	edge := clk;

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

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION