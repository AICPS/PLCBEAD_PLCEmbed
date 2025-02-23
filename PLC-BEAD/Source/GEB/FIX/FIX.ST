FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

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

  BIT_OF_DWORD := (SHR(IN,N) AND 16#00000001) > 0;
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

	CHR_TO_STRING(C:=C);
	sx:=CHR_TO_STRING.CHR_TO_STRING;
	(* create string *)
	N := INT_TO_BYTE(LIMIT(0,L,80));
	(* create a string of CHARacters to be connected to str *)
	FILL := '';
	FOR I := 1 TO 8 DO
		FILL_tmp := FILL;
		FILL := CONCAT(FILL_tmp,FILL);
		IF BIT_OF_DWORD(BYTE_TO_DWORD(N),7) THEN FILL := CONCAT(FILL,sx); END_IF;
		N := SHL(N,1);
	END_FOR;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FIX_Block

	VAR_INPUT
		STR :	STRING;
		L :	INT;
		C :	BYTE;
		M :	INT;
	END_VAR

	VAR_OUTPUT
		FIX :	STRING;
	END_VAR

	VAR
		N :	INT;
		FILL :	FILL_Block;
	END_VAR

	N := LIMIT(0,L,255) - LEN(STR);
	IF N <= 0 THEN
		(* truncate the string at length N *)
		IF M = 1 THEN
			FIX := RIGHT(STR,L);
		ELSE
			FIX := LEFT(STR,L);
		END_IF;
	ELSIF M = 1 THEN
		(* connect fill CHARacters at the beginning *)
		FILL(C:=C,L:=N);
		FIX := CONCAT(FILL.FILL,STR);
	ELSIF M = 2 THEN
		(* center str beween fill CHARacters *)
		(* for an unEVEN number of fill CHARacters, there is one more at the end *)
		FILL(C:=C,L:=_BYTE_TO_INT(SHR(INT_TO_BYTE(N+1),1)));
		FIX := CONCAT(STR,FILL.FILL);
		FILL(C:=C,L:=_BYTE_TO_INT(SHR(INT_TO_BYTE(N),1)));
		FIX := CONCAT(FILL.FILL,FIX);
	ELSE
		(* connect fill CHARacters at the end *)
		FILL(C:=C,L:=N);
		FIX := CONCAT(STR,FILL.FILL);
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	STR :	STRING;
	L   :	INT;
	C   :	BYTE;
	M   :	INT;

	FIX :	STRING;

	func_block : FIX_Block;
  END_VAR
	func_block.STR:=STR;
	func_block.L  :=L  ;
	func_block.C  :=C  ;
	func_block.M  :=M  ;
	func_block();
	FIX := func_block.FIX;
END_PROGRAM

