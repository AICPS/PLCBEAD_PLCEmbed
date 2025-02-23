TYPE
  oscat_DRIVER_4C 			  : ARRAY [1..7] 	OF BYTE;
END_TYPE
FUNCTION_BLOCK DRIVER_4C

	VAR_INPUT
		IN :	BOOL;
		RST :	BOOL;
		TIMEOUT :	TIME;
		SX :	oscat_DRIVER_4C;
	END_VAR

	VAR_OUTPUT
		SN :	INT;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR

	VAR
		off :	TON;
		edge :	BOOL;
	END_VAR

	IF RST OR off.Q THEN
		SN := 0;
	ELSIF IN AND NOT edge THEN
		SN := SN + 1;
		IF SN > 7 OR SX[SN] = BYTE#0 THEN SN := 0; END_IF;
	END_IF;
	edge := in;
	IF SN > 0 THEN
		Q0 := (SX[SN] AND BYTE#1) > BYTE#0;
		Q1 := (SX[SN] AND BYTE#2) > BYTE#0;
		Q2 := (SX[SN] AND BYTE#4) > BYTE#0;
		Q3 := (SX[SN] AND BYTE#8) > BYTE#0;
	ELSE
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
	END_IF;

	IF timeout > t#0s THEN off(in := SN > 0, PT := Timeout); END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN      :	BOOL;
	RST     :	BOOL;
	TIMEOUT :	TIME;
	SX      :	oscat_DRIVER_4C;

	SN :	INT;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;

	func_block : DRIVER_4C;
  END_VAR
	func_block.IN       :=IN      ;
	func_block.RST      :=RST     ;
	func_block.TIMEOUT  :=TIMEOUT ;
	func_block.SX       :=SX      ;
	func_block();
	SN := func_block.SN;
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
