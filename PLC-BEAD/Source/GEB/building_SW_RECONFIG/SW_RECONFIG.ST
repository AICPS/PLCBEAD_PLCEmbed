FUNCTION_BLOCK SW_RECONFIG_Block

	VAR_INPUT
		IN :	BOOL;
		TD :	TIME;
		TR :	TIME;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR
		T1 :	TON;
		T2 :	TON;
		INV :	BOOL;
	END_VAR

	t1(IN := IN, PT := TD);

	IF TR > t#0s THEN
		Q := t1.Q XOR inv;
		T2(IN := Q, PT := TR);
		IF T2.Q THEN INV := NOT INV; END_IF;
	ELSE
		Q := t1.Q;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	BOOL;
		TD :	TIME;
		TR :	TIME;
		Q :	BOOL;

		func_block : SW_RECONFIG_Block;
	END_VAR
	func_block.IN := IN;
	func_block.TD := TD;
	func_block.TR := TR ;

	func_block();
	Q  := func_block.Q;

END_PROGRAM

