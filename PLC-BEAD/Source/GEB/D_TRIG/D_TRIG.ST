FUNCTION_BLOCK D_TRIG
	VAR_INPUT
		IN :	DWORD;
	END_VAR

	VAR_OUTPUT
		Q :	BOOL;
		X :	DWORD;
	END_VAR

	VAR
		LAST_IN :	DWORD;
	END_VAR

	Q := IN <> LAST_IN;
	X := UDINT_TO_DWORD(DWORD_TO_UDINT(IN) - DWORD_TO_UDINT(LAST_IN));
	LAST_IN := IN;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN :	DWORD;

	Q :	BOOL;
	X :	DWORD;

	func_block : D_TRIG;
  END_VAR
	func_block.IN  := IN;
	func_block();
	Q := func_block.Q;
	X := func_block.X;
END_PROGRAM

