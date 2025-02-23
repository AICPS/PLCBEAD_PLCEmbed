FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION


FUNCTION_BLOCK BYTE_TO_BITS
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	VAR_OUTPUT
		B0 :	BOOL;
		B1 :	BOOL;
		B2 :	BOOL;
		B3 :	BOOL;
		B4 :	BOOL;
		B5 :	BOOL;
		B6 :	BOOL;
		B7 :	BOOL;
	END_VAR

	B0 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),0); (* IN.X0 *)
	B1 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),1); (* IN.X1 *)
	B2 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),2); (* IN.X2 *)
	B3 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),3); (* IN.X3 *)
	B4 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),4); (* IN.X4 *)
	B5 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),5); (* IN.X5 *)
	B6 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),6); (* IN.X6 *)
	B7 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),7); (* IN.X7 *)
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	LocalVar0  : BYTE;
	B0 :	BOOL;
	B1 :	BOOL;
	B2 :	BOOL;
	B3 :	BOOL;
	B4 :	BOOL;
	B5 :	BOOL;
	B6 :	BOOL;
	B7 :	BOOL;
	func_block: BYTE_TO_BITS;
  END_VAR
	
	func_block.IN  := LocalVar0;
	func_block();
	B0 := func_block.B0;
	B1 := func_block.B1;
	B2 := func_block.B2;
	B3 := func_block.B3;
	B4 := func_block.B4;
	B5 := func_block.B5;
	B6 := func_block.B6;
	B7 := func_block.B7;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
