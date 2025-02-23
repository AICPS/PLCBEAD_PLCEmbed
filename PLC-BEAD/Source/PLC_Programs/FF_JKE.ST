FUNCTION_BLOCK FF_JKE
	VAR_INPUT
		SET :	BOOL;
		J :	BOOL;
		CLK :	BOOL;
		K :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		edge :	BOOL;
	END_VAR

	IF rst OR set THEN
		Q := NOT rst;
	ELSIF clk AND NOT edge THEN
		IF J XOR K THEN Q := J;
		ELSE Q := K XOR Q;
		END_IF;
	END_IF;
	edge := CLK;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		SET :	BOOL;
		J   :	BOOL;
		CLK :	BOOL;
		K   :	BOOL;
		RST :	BOOL;

		Q :	BOOL;

	func_block : FF_JKE;
  END_VAR
	func_block.SET :=SET;
	func_block.J   :=J  ;
	func_block.CLK :=CLK;
	func_block.K   :=K  ;
	func_block.RST :=RST;
	func_block();
	Q := func_block.Q;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION