FUNCTION_BLOCK MANUAL_1_Block

	VAR_INPUT
		INN:	BOOL;
		MAN :	BOOL;
		M_I :	BOOL;
		SET :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STATUS :	BYTE;
	END_VAR


	VAR
		S_edge :	BOOL;
		_r_edge :	BOOL;
		edge :	BOOL;
	END_VAR

	IF NOT MAN THEN
		Q := INN;
		STATUS := BYTE#100;
		edge := FALSE;
	ELSIF NOT s_edge AND SET THEN
		Q := TRUE;
		edge := TRUE;
		STATUS := BYTE#101;
	ELSIF NOT _r_edge AND RST THEN
		Q := FALSE;
		edge := TRUE;
		STATUS := BYTE#102;
	ELSIF NOT edge THEN
		Q := M_I;
		STATUS := BYTE#103;
	END_IF;

	(* remember levels of MANUAL SIGNals *)
	s_edge := SET;
	_r_edge := RST;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		INN:	BOOL;
		MAN :	BOOL;
		M_I :	BOOL;
		SET :	BOOL;
		RST :	BOOL;

		Q :	BOOL;
		STATUS :	BYTE;
	
		func_block : MANUAL_1_Block;
	END_VAR
	func_block.INN:= INN;
	func_block.MAN := MAN;
	func_block.M_I := M_I;
	func_block.SET := SET;
	func_block.RST := RST;
	func_block();
	Q := func_block.Q;
	STATUS := func_block.STATUS;

END_PROGRAM

