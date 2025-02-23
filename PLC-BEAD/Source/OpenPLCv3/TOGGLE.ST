FUNCTION_BLOCK TOGGLE


	VAR_INPUT
		CLK :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		edge :	BOOL;
	END_VAR

	IF rst THEN
		Q := FALSE;
	ELSIF clk AND NOT edge THEN
		Q := NOT Q;
	END_IF;
	edge := clk;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	CLK :	BOOL;
	RST :	BOOL;
	Q :	BOOL;
	func_block : TOGGLE;
  END_VAR
	func_block.CLK  :=CLK;
	func_block.RST  :=RST;
	func_block();
	Q := func_block.Q;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION