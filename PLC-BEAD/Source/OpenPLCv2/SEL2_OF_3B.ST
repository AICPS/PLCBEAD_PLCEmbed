FUNCTION_BLOCK SEL2_OF_3B_Block

	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		TD :	TIME;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
		W :	BOOL;
	END_VAR

	VAR
		TDEL :	TON;
	END_VAR


	Q := (IN1 AND IN2) OR (IN1 AND IN3) OR (IN2 AND IN3);
	TDEL(IN := (in1 XOR in2) OR (in1 XOR in3) OR (in2 XOR in3), PT := TD);
	W := TDEL.Q;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		TD :	TIME;
		Q :	BOOL;
		W :	BOOL;
		func_block : SEL2_OF_3B_Block;
  	END_VAR
	func_block.IN1  :=IN1;
	func_block.IN2  :=IN2;
	func_block.IN3  :=IN3;
	func_block.TD  :=TD;
	func_block();
	Q := func_block.Q;
	W := func_block.W;

END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION