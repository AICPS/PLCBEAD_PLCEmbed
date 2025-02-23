TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

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


FUNCTION SGN : INT
  VAR_INPUT
    x : REAL;
  END_VAR

  IF X > 0.0 THEN
  	sgn := 1;
  ELSIF X < 0.0 THEN
  	sgn := -1;
  ELSE
  	sgn := 0;
  END_IF;
END_FUNCTION

FUNCTION_BLOCK CSQRT_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CSQRT :	oscat_complex;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR

	temp := HYPOT(x.re, x.im);
	CSQRT.re :=  SQRT(0.5 * (temp + x.re));
	CSQRT.im :=  INT_TO_REAL(sgn(x.im)) * SQRT(0.5 * (temp - x.re));

END_FUNCTION_BLOCK

FUNCTION_BLOCK CASINH_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CASINH :	oscat_complex;
	END_VAR

	VAR
		Y :	oscat_complex;
		CLOG :	CLOG_Block;
		CSQRT :	CSQRT_Block;
	END_VAR

	y.re := (X.re - X.im)*(X.re + X.im) + 1.0;
	y.im := 2.0 * X.re * X.im;
	CSQRT(X:=y);
	y    := CSQRT.CSQRT;
	y.re := y.re + x.re;
	y.im := y.im + x.im;
	CLOG(X:=y);
	CASINH  := CLOG.CLOG;
END_FUNCTION_BLOCK

FUNCTION_BLOCK CASIN_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CASIN :	oscat_complex;
	END_VAR

	VAR
		Y :	oscat_complex;
		CASINH :	CASINH_Block;
	END_VAR

	y.re := -x.im;
	y.im := x.re;
	CASINH(X:=y);
	y := CASINH.CASINH;
	CASIN.re := y.im;
	CASIN.im := -y.re;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CASIN_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CASIN;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION