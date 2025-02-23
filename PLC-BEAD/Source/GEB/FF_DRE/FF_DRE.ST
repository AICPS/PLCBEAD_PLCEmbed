FUNCTION_BLOCK FF_DRE
	VAR_INPUT
		SET :	BOOL;
		D :	BOOL;
		CLK :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		edge :	BOOL;
	END_VAR

	IF RST OR SET THEN
		Q := NOT RST;
	ELSIF CLK AND NOT edge THEN
		Q := D;
	END_IF;
	edge := CLK;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SET :	BOOL;
	D   :	BOOL;
	CLK :	BOOL;
	RST :	BOOL;

	Q :	BOOL;

	func_block : FF_DRE;
  END_VAR
	func_block.SET:=SET;
	func_block.D  :=D  ;
	func_block.CLK:=CLK;
	func_block.RST:=RST;
	func_block();
	Q:= func_block.Q;
END_PROGRAM

