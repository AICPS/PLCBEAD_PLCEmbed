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

	Q := clk XOR edge;
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

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION