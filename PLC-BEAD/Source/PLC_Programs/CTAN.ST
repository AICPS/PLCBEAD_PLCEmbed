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

FUNCTION_BLOCK CTAN_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CTAN :	oscat_complex;
	END_VAR

	VAR
		temp :	REAL;
		xi2 :	REAL;
		xr2 :	REAL;
	END_VAR

	xi2 := 2.0 * x.im;
	xr2 := 2.0 * x.re;
	temp := 1.0 / (COS(xr2) + COSH( xi2));
	CTAN.re := temp * SIN(xr2);
	CTAN.im := temp * SINH(xi2);
END_FUNCTION_BLOCK


PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CTAN_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CTAN;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION