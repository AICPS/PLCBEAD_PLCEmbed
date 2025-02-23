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

FUNCTION_BLOCK FT_AVG

	VAR_INPUT
		IN :	REAL;
		E :	BOOL := TRUE;
		N :	INT := INT#32;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		AVG :	REAL;
	END_VAR

	VAR
		buff :	delay;
		i :	INT;
		init :	BOOL;
	END_VAR


	buff.N := LIMIT(0, N, 32);

	IF NOT init OR rst THEN
		FOR i := 1 TO N DO
			buff(in := in);
		END_FOR;
		avg := in;
		init := TRUE;
	ELSIF E THEN
		buff(in := in);
		avg := avg + (in - buff.out ) / INT_TO_REAL(N);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
		IN  :	REAL;
		E   :	BOOL;
		N   :	INT;
		RST :	BOOL;

		AVG :	REAL;

	func_block : FT_AVG;
  END_VAR
	func_block.IN :=IN ;
	func_block.E  :=E  ;
	func_block.N  :=N  ;
	func_block.RST:=RST;
	func_block();
	AVG := func_block.AVG;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION