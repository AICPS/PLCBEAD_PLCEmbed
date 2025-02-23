TYPE
	oscat_PT_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION_BLOCK _ARRAY_INIT_Block

	VAR_IN_OUT
		PT :	oscat_PT_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
		init :	REAL;
	END_VAR

	VAR_OUTPUT
		ARRAY_INIT:	BOOL;
	END_VAR

	VAR
		i :	INT;
		STOP :	INT;
	END_VAR

	STOP :=LIMIT_INT(1,UINT_TO_INT(SIZE),1000);

	FOR i := 1 TO STOP DO
		PT[i] := init;
	END_FOR;
	ARRAY_INIT := TRUE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_PT_ARRAY;
    LocalVaR1  : UINT;
	LocalVaR2 : REAL;
	LocalOUT  : BOOL;
	func_block: _ARRAY_INIT_Block;
  END_VAR
  
  func_block(PT := LocalVar0, SIZE := LocalVaR1 , init:= LocalVaR2);
  LocalOUT := func_block.ARRAY_INIT;
  
  
END_PROGRAM

