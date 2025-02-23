TYPE
  oscat_FILTER_MAV_W          : ARRAY [0..31]   OF WORD;
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


FUNCTION_BLOCK FILTER_MAV_W
	VAR_INPUT
		X :	WORD;
		N :	UINT;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	WORD;
	END_VAR

	VAR
		init :	BOOL;
		buffer :	oscat_FILTER_MAV_W;
		i :	INT;
		sum :	UDINT;
		tmp :	INT;
		NN :	UINT;
	END_VAR

	NN := MIN(N, UINT#32);

	(* STARTup initialisation *)
	IF NOT init OR RST OR NN = UINT#0 THEN
		init := TRUE;
		tmp := UINT_TO_INT(NN) - 1;
		FOR i := 1 TO tmp DO
			buffer[i] := X;
		END_FOR;
		sum := UINT_TO_UDINT(WORD_TO_UINT(Y) * NN);
		Y := X;
	ELSE
		tmp := UINT_TO_INT(NN);
		i := INC1(i, tmp);
		sum := sum + WORD_TO_UDINT(X) - WORD_TO_UDINT(buffer[i]);
		Y := UDINT_TO_WORD(sum / UINT_TO_UDINT(NN));
		buffer[i] := X;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	WORD;
	N :	UINT;
	RST :	BOOL;

	Y :	WORD;

	func_block : FILTER_MAV_W;
  END_VAR
	func_block.X  := X;
	func_block.N  := N;
	func_block.RST  := RST;
	func_block();
	Y := func_block.Y;
END_PROGRAM

