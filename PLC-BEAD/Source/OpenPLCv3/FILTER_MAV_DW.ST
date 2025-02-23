TYPE
  oscat_ardw_0_31             : ARRAY [0..31]   OF DWORD;
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


FUNCTION_BLOCK FILTER_MAV_DW

	VAR_INPUT
		X :	DWORD;
		N :	UINT;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	DWORD;
	END_VAR

	VAR
		init :	BOOL;
		buffer :	oscat_ardw_0_31;
		i :	INT;
		tmp :	INT;
	END_VAR

	N := MIN(N, UINT#32);

	(* startup initialisation *)
	IF NOT init OR rst OR N = UINT#0 THEN
		init := TRUE;
		tmp := UINT_TO_INT(N)-1;
		FOR i := 0 TO tmp DO
			buffer[i] := X;
		END_FOR;
		Y := X;
	ELSE
		tmp := UINT_TO_INT(N);
		i := INC1(i, tmp);
		Y := UDINT_TO_DWORD(DWORD_TO_UDINT(Y) + (DWORD_TO_UDINT(X) - DWORD_TO_UDINT(buffer[i])) / UINT_TO_UDINT(N));
		buffer[i] := X;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	X :	DWORD;
	N :	UINT;
	RST :	BOOL;

	Y :	DWORD;

	func_block : FILTER_MAV_DW;
  END_VAR
	func_block.X  := X;
	func_block.N  := N;
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