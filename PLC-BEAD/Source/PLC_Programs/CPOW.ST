TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CMUL_Block

	VAR_INPUT
		X :	oscat_complex;
		Y :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CMUL :	oscat_complex;
	END_VAR

	CMUL.re := X.re * Y.re - X.im * Y.im;
	CMUL.im := X.re * Y.im + X.im * Y.re;
END_FUNCTION_BLOCK

FUNCTION_BLOCK CEXP_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CEXP :	oscat_complex;
	END_VAR

	VAR
		Temp :	REAL;
	END_VAR

	temp := EXP(X.re);
	CEXP.re := temp * COS(X.im);
	CEXP.im := temp * SIN(X.im);

END_FUNCTION_BLOCK

FUNCTION ATAN2:REAL
	VAR_INPUT
		X :	REAL;
		Y :	REAL;
	END_VAR

	IF X > 0.0 THEN
		ATAN2 := ATAN(Y/X);
	ELSIF X < 0.0 THEN
		IF Y >= 0.0 THEN
			ATAN2 := ATAN(Y/X) + 3.14159265358979323846264338327950288;
		ELSE
			ATAN2 := ATAN(Y/X) - 3.14159265358979323846264338327950288;
		END_IF;
	ELSIF Y > 0.0 THEN
		ATAN2 := 1.5707963267948965580;
	ELSIF Y < 0.0 THEN
		ATAN2 := -1.5707963267948965580;
	ELSE
		ATAN2 := 0.0;
	END_IF;

END_FUNCTION

FUNCTION HYPOT:REAL
	VAR_INPUT
		X :	REAL;
		Y :	REAL;
	END_VAR

	HYPOT := SQRT(x*x + y*y);
END_FUNCTION

FUNCTION_BLOCK CLOG_Block

	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CLOG :	oscat_complex;
	END_VAR

	CLOG.re := LN(HYPOT(X.re, X.im));
	CLOG.im := ATAN2(X.im, X.re);

END_FUNCTION_BLOCK

FUNCTION_BLOCK CPOW_Block
	VAR_INPUT
		X :	oscat_complex;
		Y :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CPOW :	oscat_complex;
	END_VAR

	VAR
		CLOG :	CLOG_Block;
		CEXP :	CEXP_Block;
		CMUL :	CMUL_Block;
	END_VAR


	CLOG(X:=X);
	CMUL(X:=Y,Y:=CLOG.CLOG);
	CEXP(X:=CMUL.CMUL);
	CPOW := CEXP.CEXP;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalVar1 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CPOW_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.Y  := LocalVar1;
	func_block();
	LocalOUT := func_block.CPOW;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION