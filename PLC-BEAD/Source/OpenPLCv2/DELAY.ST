TYPE
	oscat_delay_buf             : ARRAY [0..31]   OF REAL;
END_TYPE

FUNCTION INC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X >= N - 1 THEN
		INC1 := 0;
	ELSE
		INC1 := X + 1;
	END_IF;
END_FUNCTION


FUNCTION_BLOCK DELAY

	VAR_INPUT
		IN :	REAL;
		N :	INT;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT :	REAL;
	END_VAR


	VAR
		buf :	oscat_delay_buf;
		i :	INT;
		init :	BOOL;
		stop :	INT;
	END_VAR

	stop := LIMIT(0,N,32) - 1;
	IF rst OR NOT init THEN
		init := TRUE;
		FOR i := 0 TO stop DO buf[i] := in; END_FOR;
		out := in;
		i := 0;
	ELSIF stop < 0 THEN
		out := in;
	ELSE
		out := buf[i];
		buf[i] := in;
		i := INC1(i, N);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	REAL;
	N :	INT;
	RST :	BOOL;
	OUT :	REAL;
	func_block : DELAY;
  END_VAR
	func_block.IN  :=IN;
	func_block.N  :=N;
	func_block.RST  :=RST;
	func_block();
	OUT := func_block.OUT;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION