FUNCTION_BLOCK B_TRIG
	VAR_INPUT
		CLK :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL := FALSE;
	END_VAR

	VAR
		edge :	BOOL := FALSE;
	END_VAR

	Q := CLK XOR edge;
	edge := CLK;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
	LocalOUT  : BOOL;
	func_block : B_TRIG;
  END_VAR
	func_block.CLK := LocalVar0;
	func_block();
	LocalOUT := func_block.Q;

END_PROGRAM

