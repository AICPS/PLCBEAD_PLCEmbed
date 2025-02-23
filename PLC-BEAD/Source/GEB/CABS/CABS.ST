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

FUNCTION_BLOCK CABS_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CABS :	REAL;
	END_VAR

	CABS := HYPOT(X.re, X.im);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : REAL;
	func_block : CABS_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CABS;

END_PROGRAM

