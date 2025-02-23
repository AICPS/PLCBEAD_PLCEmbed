FUNCTION_BLOCK DWORD_TO_STRF_Block

	VAR_INPUT
		IN :	DWORD;
		N :	INT;
	END_VAR

	VAR_OUTPUT
		DWORD_TO_STRF :	STRING;
	END_VAR

	VAR
		temp :	STRING;
		temp2 :	STRING;
		L : INT;
	END_VAR

	temp := DWORD_TO_STRING(in);
	L := LEN(temp);
	IF N < L THEN
		temp :=RIGHT(temp,N);
		L := N;
	END_IF;

	WHILE L < N DO
		temp2 := temp;
		temp := CONCAT('0', temp2);
		L := L + 1;
	END_WHILE;
	DWORD_TO_STRF := temp;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    IN :	DWORD;
	N :		INT;
	DWORD_TO_STRF :	STRING;
	func_block : DWORD_TO_STRF_Block;
  END_VAR
	func_block.IN  := IN;
	func_block.N  := N;
	func_block();
	DWORD_TO_STRF := func_block.DWORD_TO_STRF;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION