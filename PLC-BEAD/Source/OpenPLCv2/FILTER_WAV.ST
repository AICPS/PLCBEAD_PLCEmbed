TYPE
  oscat_arr_0_15              : ARRAY [0..15]   OF REAL;
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

FUNCTION DEC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X = 0 THEN
		DEC1 := N - 1;
	ELSE
		DEC1 := X - 1;
	END_IF;

END_FUNCTION

FUNCTION_BLOCK FILTER_WAV
	VAR_INPUT
		X :	REAL;
		W :	oscat_arr_0_15;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR
		init :	BOOL;
		buffer :	oscat_arr_0_15;
		i :	INT;
		n :	INT;
	END_VAR

	IF NOT init OR rst THEN
		init := TRUE;
		FOR i := 0 TO 15 DO
			buffer[i] := X;
		END_FOR;
		i := 15;
		Y := X;
	ELSE
		i := INC1(i, 16);
		buffer[i] := X;
	END_IF;

	Y := 0.0;
	FOR n := 0 TO 15 DO
		Y := buffer[i] * W[n] + Y;
		i := DEC1(i, 16);
	END_FOR;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	REAL;
	W :	oscat_arr_0_15;
	RST :	BOOL;

	Y :	REAL;

	func_block : FILTER_WAV;
  END_VAR
	func_block.X  := X;
	func_block.W  := W;
	func_block.RST  := RST;
	func_block();
	Y := func_block.Y;
END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION