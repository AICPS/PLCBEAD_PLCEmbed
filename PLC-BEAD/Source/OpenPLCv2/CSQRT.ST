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

	HYPOT := SQRT(x*x + y*y);
END_FUNCTION

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

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION