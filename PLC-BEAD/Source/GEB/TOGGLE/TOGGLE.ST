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

	IF RST THEN
		Q := FALSE;
	ELSIF CLK AND NOT edge THEN
		Q := NOT Q;
	END_IF;
	edge := CLK;

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

