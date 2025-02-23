FUNCTION_BLOCK FF_RSE
	VAR_INPUT
		CS :	BOOL;
		CR :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		es :	BOOL;
		er :	BOOL;
	END_VAR

	IF rst THEN
		(* asynchronous reset *)
		Q := FALSE;
	ELSIF CR AND NOT er THEN
		(* rising edge on CR *)
		Q := FALSE;
	ELSIF CS AND NOT es THEN
		(* rising edge on CS *)
		Q := TRUE;
	END_IF;

	es := CS;
	er := CR;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	CS  :	BOOL;
	CR  :	BOOL;
	RST :	BOOL;

	Q :	BOOL;

	func_block : FF_RSE;
  END_VAR
	func_block.CS  :=CS ;
	func_block.CR  :=CR ;
	func_block.RST :=RST;
	func_block();
	Q := func_block.Q;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION