TYPE
  	oscat_ardw_0_31             : ARRAY [0..31]   OF DWORD;
END_TYPE

FUNCTION_BLOCK STACK_32_Block

	VAR_INPUT
		DIN :	DWORD;
		E :	BOOL := TRUE;
		RD :	BOOL;
		WD :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		DOUT :	DWORD;
		EMPTY :	BOOL := TRUE;
		FULL :	BOOL;
	END_VAR

	VAR
		pt :	INT;
		stack :	oscat_ardw_0_31;
	END_VAR


	IF RST THEN
		pt := 0;
		EMPTY := TRUE;
		FULL := FALSE;
		Dout := DWORD#0;
	ELSIF E THEN
		IF NOT EMPTY AND RD THEN
			(* read one element *)
			pt := pt - 1;
			Dout := stack[pt];
			EMPTY := pt = 0;
			FULL := FALSE;
		END_IF;
		IF NOT FULL AND WD THEN
			(* write one element *)
			stack[pt] := Din;
			pt := pt + 1;
			FULL := pt > 31;
			EMPTY := FALSE;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		DIN :	DWORD;
		E :	BOOL := TRUE;
		RD :	BOOL;
		WD :	BOOL;
		RST :	BOOL;
		DOUT :	DWORD;
		EMPTY :	BOOL := TRUE;
		FULL :	BOOL;
		func_block : STACK_32_Block;
	END_VAR
		func_block.DIN  := DIN;
		func_block.E  := E;
		func_block.RD  := RD;
		func_block.WD  := WD;
		func_block.RST  := RST;
		func_block();
		DOUT := func_block.DOUT;
		EMPTY := func_block.EMPTY;
		FULL := func_block.FULL;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION