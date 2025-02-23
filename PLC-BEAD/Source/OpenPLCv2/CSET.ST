TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CSET_Block
	VAR_INPUT
		RE :	REAL;
		IM :	REAL;
	END_VAR

	VAR_OUTPUT
		CSET :	oscat_complex;
	END_VAR

	CSET.re := RE;
	CSET.im := IM;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	LocalOUT  : oscat_complex;
	func_block : CSET_Block;
  END_VAR
	func_block.RE  := LocalVar0;
	func_block.IM  := LocalVar1;
	func_block();
	LocalOUT := func_block.CSET;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
