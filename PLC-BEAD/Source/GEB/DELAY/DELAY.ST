TYPE
	oscat_DELAY_buf             : ARRAY [0..31]   OF REAL;
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
		buf :	oscat_DELAY_buf;
		i :	INT;
		init :	BOOL;
		STOP :	INT;
	END_VAR

	STOP := LIMIT(0,N,32) - 1;
	IF RST OR NOT init THEN
		init := TRUE;
		FOR i := 0 TO STOP DO buf[i] := IN; END_FOR;
		OUT := IN;
		i := 0;
	ELSIF STOP < 0 THEN
		OUT := IN;
	ELSE
		OUT := buf[i];
		buf[i] := IN;
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

