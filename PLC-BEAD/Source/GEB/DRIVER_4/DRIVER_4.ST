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

FUNCTION_BLOCK DRIVER_4

	VAR_INPUT
		SET :	BOOL;
		IN0 :	BOOL;
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		RST :	BOOL;
		TOGGLE_MODE :	BOOL;
		TIMEOUT :	TIME;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	VAR
		D0 :	DRIVER_1;
		D1 :	DRIVER_1;
		D2 :	DRIVER_1;
		D3 :	DRIVER_1;
	END_VAR


	D0(SET:=SET, IN:=IN0, RST:=RST, TOGGLE_MODE:=TOGGLE_MODE, TIMEOUT:=TIMEOUT);
	D1(SET:=SET, IN:=IN1, RST:=RST, TOGGLE_MODE:=TOGGLE_MODE, TIMEOUT:=TIMEOUT);
	D2(SET:=SET, IN:=IN2, RST:=RST, TOGGLE_MODE:=TOGGLE_MODE, TIMEOUT:=TIMEOUT);
	D3(SET:=SET, IN:=IN3, RST:=RST, TOGGLE_MODE:=TOGGLE_MODE, TIMEOUT:=TIMEOUT);
	Q0 := D0.Q;
	Q1 := D1.Q;
	Q2 := D2.Q;
	Q3 := D3.Q;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	SET         :	BOOL;
	IN0         :	BOOL;
	IN1         :	BOOL;
	IN2         :	BOOL;
	IN3         :	BOOL;
	RST         :	BOOL;
	TOGGLE_MODE :	BOOL;
	TIMEOUT     :	TIME;

	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	
	func_block : DRIVER_4;
  END_VAR
	func_block.SET         := SET        ;
	func_block.IN0         := IN0        ;
	func_block.IN1         := IN1        ;
	func_block.IN2         := IN2        ;
	func_block.IN3         := IN3        ;
	func_block.RST         := RST        ;
	func_block.TOGGLE_MODE := TOGGLE_MODE;
	func_block.TIMEOUT     := TIMEOUT    ;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
END_PROGRAM

