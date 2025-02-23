FUNCTION_BLOCK LTCH_4_Block

	VAR_INPUT
		D0 :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;
		D3 :	BOOL;
		L :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR


	IF rst THEN			(* if asynchronous reset then Q=0 *)
		Q0 := FALSE;
		Q1 := FALSE;
		Q2 := FALSE;
		Q3 := FALSE;
	ELSIF L THEN			(* latch is transparent *)
		Q0 := D0;
		Q1 := D1;
		Q2 := D2;
		Q3 := D3;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		D0 :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;
		D3 :	BOOL;
		L :	BOOL;
		RST :	BOOL;
		
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;

		func_block : LTCH_4_Block;
	END_VAR
	func_block.D0 := D0;
	func_block.D1 := D1;
	func_block.D2 := D2;
	func_block.D3 := D3;
	func_block.L := L;
	func_block.RST := RST;

	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
