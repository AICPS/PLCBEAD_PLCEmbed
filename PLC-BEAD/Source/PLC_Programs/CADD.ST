TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CADD_Block

	VAR_INPUT
		X :	oscat_complex;
		Y :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CADD :	oscat_complex;
	END_VAR

	CADD.re := x.re + y.re;
	CADD.im := x.im + y.im;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalVar1 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CADD_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.Y  := LocalVar0;
	func_block();
	LocalOUT := func_block.CADD;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
