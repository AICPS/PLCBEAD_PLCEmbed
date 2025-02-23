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
		tx :	TP;
		edge :	BOOL;
		cnt :	INT := INT#-1;
	END_VAR

	Q := FALSE;

	IF in AND NOT edge AND NOT tx.q THEN
		cnt := 0;
	ELSIF tx.Q AND NOT IN AND edge THEN
		cnt := cnt + 1;
	ELSIF NOT tx.Q THEN
		Q := cnt=N;
		cnt := -1;
	END_IF;
	edge := IN;
	tx(in := IN, pt := TC);
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : BOOl;
    LocalVar1 : INT;
	LocalVar2 : TIME;
	LocalOUT  : BOOL;
	func_block : CLICK_CNT;
  END_VAR
	func_block.IN  := LocalVar0;
	func_block.N := LocalVar1;
	func_block.TC  := LocalVar2;
	func_block();
	LocalOUT := func_block.Q;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION