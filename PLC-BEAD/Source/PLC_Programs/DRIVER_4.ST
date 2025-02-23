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
		d0 :	DRIVER_1;
		d1 :	DRIVER_1;
		d2 :	DRIVER_1;
		d3 :	DRIVER_1;
	END_VAR


	D0(Set:=set, in:=in0, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
	D1(Set:=set, in:=in1, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
	D2(Set:=set, in:=in2, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
	D3(Set:=set, in:=in3, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
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

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION