FUNCTION_BLOCK MANUAL_1_Block

	VAR_INPUT
		_IN :	BOOL;
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

	IF NOT man THEN
		Q := _IN;
		STATUS := BYTE#100;
		edge := FALSE;
	ELSIF NOT s_edge AND set THEN
		Q := TRUE;
		edge := TRUE;
		status := BYTE#101;
	ELSIF NOT _r_edge AND rst THEN
		Q := FALSE;
		edge := TRUE;
		status := BYTE#102;
	ELSIF NOT edge THEN
		Q := M_I;
		status := BYTE#103;
	END_IF;

	(* remember levels of manual signals *)
	s_edge := SET;
	_r_edge := RST;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		_IN :	BOOL;
		MAN :	BOOL;
		M_I :	BOOL;
		SET :	BOOL;
		RST :	BOOL;

		Q :	BOOL;
		STATUS :	BYTE;
	
		func_block : MANUAL_1_Block;
	END_VAR
	func_block._IN := _IN;
	func_block.MAN := MAN;
	func_block.M_I := M_I;
	func_block.SET := SET;
	func_block.RST := RST;
	func_block();
	Q := func_block.Q;
	STATUS := func_block.STATUS;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION