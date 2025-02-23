FUNCTION_BLOCK DRIVER_1
	VAR_INPUT
		SET :	BOOL;
		IN :	BOOL;
		RST :	BOOL;
		TOGGLE_MODE :	BOOL;
		TIMEOUT :	TIME;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR

	VAR
		off :	TON;
		edge :	BOOL;
	END_VAR

	IF off.Q THEN Q := FALSE; END_IF;
	IF rst THEN
		Q := FALSE;
	ELSIF set THEN
		Q := TRUE;
	ELSIF IN AND NOT edge THEN
		IF toggle_mode THEN q := NOT Q; ELSE q := TRUE; END_IF;
	END_IF;
	edge := in;
	IF timeout > t#0s THEN off(in := Q, PT := Timeout); END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SET         :	BOOL;
	IN          :	BOOL;
	RST         :	BOOL;
	TOGGLE_MODE :	BOOL;
	TIMEOUT     :	TIME;

	Q :	BOOL;

	func_block : DRIVER_1;
  END_VAR
	func_block.SET         :=SET        ;
	func_block.IN          :=IN         ;
	func_block.RST         :=RST        ;
	func_block.TOGGLE_MODE :=TOGGLE_MODE;
	func_block.TIMEOUT     :=TIMEOUT    ;
	func_block();
	Q := func_block.Q;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION