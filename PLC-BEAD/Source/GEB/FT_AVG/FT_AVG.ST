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
		buff :	DELAY;
		i :	INT;
		init :	BOOL;
	END_VAR


	buff.N := LIMIT(0, N, 32);

	IF NOT init OR RST THEN
		FOR i := 1 TO N DO
			buff(IN := IN);
		END_FOR;
		AVG := IN;
		init := TRUE;
	ELSIF E THEN
		buff(IN := IN);
		AVG := AVG + (IN - buff.OUT ) / INT_TO_REAL(N);
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

