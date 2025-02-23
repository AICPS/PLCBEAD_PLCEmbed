FUNCTION_BLOCK INTERLOCK_Block

	VAR_INPUT
		I1 :	BOOL;
		I2 :	BOOL;
		TL :	TIME;
	END_VAR


	VAR_OUTPUT
		Q1 :	BOOL;
		Q2 :	BOOL;
	END_VAR


	VAR
		T1 :	TOF;
		T2 :	TOF;
	END_VAR

	T1(IN := I1, PT := TL);
	T2(IN := I2, PT := TL);

	Q1 := I1 AND NOT T2.Q;
	Q2 := I2 AND NOT T1.Q;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		I1 :	BOOL;
		I2 :	BOOL;
		TL :	TIME;
		Q1 :	BOOL;
		Q2 :	BOOL;
		func_block : INTERLOCK_Block;
  	END_VAR
	func_block.I1  :=I1;
	func_block.I2  :=I2;
	func_block.TL  :=TL;
	func_block();
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
END_PROGRAM

