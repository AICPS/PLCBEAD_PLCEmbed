FUNCTION_BLOCK LTCH_Block

	VAR_INPUT
		D :	BOOL;
		L :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	IF RST THEN				(* if asynchronous reset then Q=0 *)
		Q := FALSE;
	ELSIF L THEN			(* latch is transparent *)
		Q := D;
	END_IF;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		D :	BOOL;
		L :	BOOL;
		RST :	BOOL;

		Q :	BOOL;

		func_block : LTCH_Block;
	END_VAR
	func_block.D := D;
	func_block.L := L;
	func_block.RST := RST;

	func_block();
	Q := func_block.Q;

END_PROGRAM

