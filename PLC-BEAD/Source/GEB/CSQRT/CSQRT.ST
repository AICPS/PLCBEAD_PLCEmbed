TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION HYPOT:REAL
	VAR_INPUT
		X :	REAL;
		Y :	REAL;
	END_VAR

	HYPOT := SQRT(X*X + Y*Y);
END_FUNCTION

FUNCTION SGN : INT
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 0.0 THEN
  	SGN := 1;
  ELSIF X < 0.0 THEN
  	SGN := -1;
  ELSE
  	SGN := 0;
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

	temp := HYPOT(X.re, X.im);
	CSQRT.re :=  SQRT(0.5 * (temp + X.re));
	CSQRT.im :=  INT_TO_REAL(SGN(X.im)) * SQRT(0.5 * (temp - X.re));

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CSQRT_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CSQRT;
END_PROGRAM

