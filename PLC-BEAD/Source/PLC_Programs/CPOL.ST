TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CPOL_Block
	VAR_INPUT
		L :	REAL;
		A :	REAL;
	END_VAR

	VAR_OUTPUT
		CPOL :	oscat_complex;
	END_VAR

	CPOL.re := L * COS(A);
	CPOL.im := L * SIN(A);
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	CPOL  : oscat_complex;
	func_block : CPOL_Block;
  END_VAR
	func_block.L  := LocalVar0;
	func_block.A  := LocalVar1;
	func_block();
	CPOL := func_block.CPOL;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION