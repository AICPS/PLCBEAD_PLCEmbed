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
	IF RST THEN
		Q := FALSE;
	ELSIF SET THEN
		Q := TRUE;
	ELSIF IN AND NOT edge THEN
		IF TOGGLE_MODE THEN Q := NOT Q; ELSE Q := TRUE; END_IF;
	END_IF;
	edge := IN;
	IF TIMEOUT > t#0s THEN off(IN := Q, PT := TIMEOUT); END_IF;

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

