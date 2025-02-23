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
		tx :	TP;
		edge :	BOOL;
		cnt :	INT := INT#-1;
	END_VAR

	IF in = FALSE THEN
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
	END_IF;

	IF in AND NOT edge AND NOT tx.q THEN
		cnt := 0;
	ELSIF tx.Q AND NOT IN AND edge THEN
		cnt := cnt + 1;
	ELSIF NOT tx.Q THEN
		CASE cnt OF
			0 : Q0 := TRUE;
			1 : Q1 := TRUE;
			2 : Q2 := TRUE;
			3 : Q3 := TRUE;
		END_CASE;
		cnt := -1;
	END_IF;

	edge := IN;
	tx(in := IN, pt := TC);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOL;
    LocalVar1 : TIME;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	func_block : CLICK_DEC;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.TC := LocalVar1;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION