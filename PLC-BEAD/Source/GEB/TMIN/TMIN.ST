FUNCTION_BLOCK TMIN


	VAR_INPUT
		IN :	BOOL;
		PT :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		pm :	TP;
	END_VAR

	pm(IN := IN, PT := PT);
	Q := IN OR pm.Q;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	BOOL;
	PT :	TIME;
	Q :	BOOL;
	func_block : TMIN;
  END_VAR
	func_block.IN  :=IN;
	func_block.PT  :=PT;
	func_block();
	Q := func_block.Q;

END_PROGRAM

