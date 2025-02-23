FUNCTION_BLOCK CLICK_CNT
	VAR_INPUT
		IN :	BOOL;
		N :	INT;
		TC :	TIME;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		TX :	TP;
		edge :	BOOL;
		CNT :	INT := INT#-1;
	END_VAR

	Q := FALSE;

	IF IN AND NOT edge AND NOT TX.Q THEN
		CNT := 0;
	ELSIF TX.Q AND NOT IN AND edge THEN
		CNT := CNT + 1;
	ELSIF NOT TX.Q THEN
		Q := CNT=N;
		CNT := -1;
	END_IF;
	edge := IN;
	TX(IN := IN, PT := TC);
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
    LocalVaR1  : INT;
	LocalVaR2 : TIME;
	LocalOUT  : BOOL;
	func_block : CLICK_CNT;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.N := LocalVaR1 ;
	func_block.TC  := LocalVaR2;
	func_block();
	LocalOUT := func_block.Q;

END_PROGRAM

