FUNCTION_BLOCK SH_T_Block

	VAR_INPUT
		IN :	REAL;
		E :	BOOL;
	END_VAR

	VAR_OUTPUT
		OUT :	REAL;
	END_VAR

	IF E THEN OUT := IN; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		IN :	REAL;
		E :	BOOL;
		OUT :	REAL;
		func_block : SH_T_Block;
	END_VAR
	func_block.IN  :=IN;
	func_block.E  :=E;
	func_block();
	OUT := func_block.OUT;

END_PROGRAM

