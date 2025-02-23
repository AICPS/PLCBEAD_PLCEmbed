FUNCTION_BLOCK MANUAL_2_Block

	VAR_INPUT
		_IN :	BOOL;
		ENA :	BOOL;
		_ON :	BOOL;
		OFF :	BOOL;
		MAN :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
		STATUS :	BYTE;
	END_VAR

	IF ena THEN
		IF NOT _ON AND NOT OFF THEN
			Q := _IN;
			STATUS := BYTE#100;
		ELSIF _on AND NOT off THEN
			Q := TRUE;
			STATUS := BYTE#101;
		ELSIF NOT _on AND off THEN
			q := FALSE;
			STATUS := BYTE#102;
		ELSE
			Q := MAN;
			STATUS := BYTE#103;
		END_IF;
	ELSE
		Q := FALSE;
		STATUS := BYTE#104;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		_IN :	BOOL;
		ENA :	BOOL;
		_ON :	BOOL;
		OFF :	BOOL;
		MAN :	BOOL;

		Q :	BOOL;
		STATUS :	BYTE;
	
		func_block : MANUAL_2_Block;
	END_VAR
	func_block._IN := _IN;
	func_block.ENA := ENA;
	func_block._ON := _ON;
	func_block.OFF := OFF;
	func_block.MAN := MAN;
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
