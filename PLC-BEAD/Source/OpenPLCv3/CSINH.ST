TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION COSH:REAL
	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR
		t :	REAL;
	END_VAR

	T := EXP(X);
	COSH := (1.0 / T + T) * 0.5;
END_FUNCTION

FUNCTION SINH:REAL
	VAR_INPUT
		X :	REAL;
	END_VAR

	IF ABS(x) < 2.0E-3 THEN
		SINH := X;
	ELSE
		SINH := (EXP(x) - EXP(-x)) * 0.5;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK CSINH_Block

	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CSINH :	oscat_complex;
	END_VAR

	CSINH.re := sinH(X.re) * COS(X.im);
	CSINH.im := cosH(X.re) * SIN(X.im);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CSINH_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CSINH;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION