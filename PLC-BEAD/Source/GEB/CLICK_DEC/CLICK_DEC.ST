FUNCTION_BLOCK CLICK_DEC

	VAR_INPUT
		IN :	BOOL;
		TC :	TIME;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	VAR
		TX :	TP;
		edge :	BOOL;
		CNT :	INT := INT#-1;
	END_VAR

	IF IN = FALSE THEN
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
	END_IF;

	IF IN AND NOT edge AND NOT TX.Q THEN
		CNT := 0;
	ELSIF TX.Q AND NOT IN AND edge THEN
		CNT := CNT + 1;
	ELSIF NOT TX.Q THEN
		CASE CNT OF
			0 : Q0 := TRUE;
			1 : Q1 := TRUE;
			2 : Q2 := TRUE;
			3 : Q3 := TRUE;
		END_CASE;
		CNT := -1;
	END_IF;

	edge := IN;
	TX(IN := IN, PT := TC);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
    LocalVaR1  : TIME;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	func_block : CLICK_DEC;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.TC := LocalVaR1 ;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
END_PROGRAM

