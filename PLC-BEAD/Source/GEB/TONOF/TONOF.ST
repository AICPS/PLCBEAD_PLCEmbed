FUNCTION_BLOCK TONOF

	VAR_INPUT
		IN :	BOOL;
		T_ON :	TIME;
		T_OFF :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		X :	TON;
		old :	BOOL;
		MODE :	BOOL;
	END_VAR

	IF IN XOR old THEN
	X(IN := FALSE, PT := SEL_TIME(IN,T_OFF,T_ON));
	MODE := IN;
	old := IN;
	END_IF;
	X(IN := TRUE);
	IF X.Q THEN Q := MODE;END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	BOOL;
	T_ON :	TIME;
	T_OFF :	TIME;
	Q :	BOOL;
	func_block : TONOF;
  END_VAR
	func_block.IN  :=IN ;
	func_block.T_ON  :=T_ON ;
	func_block.T_OFF  :=T_OFF ;
	func_block();
	Q := func_block.Q;

END_PROGRAM

