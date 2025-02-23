TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CINV_Block

	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CINV :	oscat_complex;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR

	temp := X.re * X.re + X.im * X.im;
	IF temp = 0.0 THEN CINV.re := 0.0;CINV.im := 0.0;RETURN;END_IF;
	CINV.re := X.re / temp;
	CINV.im := -X.im / temp;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CINV_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CINV;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
