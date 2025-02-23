FUNCTION_BLOCK CHR_TO_STRING_Block
	VAR_INPUT
		C :	BYTE;
	END_VAR

	VAR_OUTPUT
		CHR_TO_STRING :	STRING;
	END_VAR

	CHR_TO_STRING := BYTE_TO_STRING(C);

END_FUNCTION_BLOCK

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION_BLOCK FILL_Block
	VAR_INPUT
		C :	BYTE;
		L :	INT;
	END_VAR

	VAR_OUTPUT
		FILL :	STRING;
	END_VAR

	VAR
		N :	BYTE;
		I :	INT;
		sx :	STRING;
		CHR_TO_STRING :	CHR_TO_STRING_Block;
		FILL_tmp :	STRING;
	END_VAR

	CHR_TO_STRING(C:=c);
	Sx:=CHR_TO_STRING.CHR_TO_STRING;
	(* create string *)
	N := INT_TO_BYTE(LIMIT(0,L,80));
	(* create a string of characters to be connected to str *)
	FILL := '';
	FOR i := 1 TO 8 DO
		FILL_tmp := FILL;
		FILL := CONCAT(FILL_tmp,FILL);
		IF BIT_OF_DWORD(BYTE_TO_DWORD(N),7) THEN FILL := CONCAT(FILL,Sx); END_IF;
		N := SHL(N,1);
	END_FOR;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	C :	BYTE;
	L :	INT;

	FILL :	STRING;

	func_block : FILL_Block;
  END_VAR
	func_block.C  :=C ;
	func_block.L  :=L ;
	func_block();
	FILL := func_block.FILL;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION