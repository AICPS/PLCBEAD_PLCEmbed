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
		PT :	INT;
		stack :	oscat_ardw_0_31;
	END_VAR


	IF RST THEN
		PT := 0;
		EMPTY := TRUE;
		FULL := FALSE;
		DOUT := DWORD#0;
	ELSIF E THEN
		IF NOT EMPTY AND RD THEN
			(* read one element *)
			PT := PT - 1;
			DOUT := stack[PT];
			EMPTY := PT = 0;
			FULL := FALSE;
		END_IF;
		IF NOT FULL AND WD THEN
			(* write one element *)
			stack[PT] := Din;
			PT := PT + 1;
			FULL := PT > 31;
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

