FUNCTION_BLOCK OCT_TO_DWORD_Block

	VAR_INPUT
		OCT :	STRING;
	END_VAR

	VAR_OUTPUT
		OCT_TO_DWORD :	DWORD;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
		X :	INT;
	END_VAR

	OCT_TO_DWORD := DWORD#0;
	stop := LEN(oct);
	FOR I := 1 TO stop DO
		X := GET_CHAR(oct,I);
		(* calculate the value of the digit *)
		IF X > 47 AND x < 56 THEN
			OCT_TO_DWORD := SHL_DWORD(OCT_TO_DWORD,3) OR INT_TO_DWORD(X - 48);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK


PROGRAM program0
  VAR
    OCT : STRING;
    OCT_TO_DWORD : DWORD;
	func_block : OCT_TO_DWORD_Block;
  END_VAR

  	func_block.OCT := '125'; 
	func_block()
	OCT_TO_DWORD := func_block.OCT_TO_DWORD; 
END_PROGRAM


CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION