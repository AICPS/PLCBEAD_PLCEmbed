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
		T :	REAL;
	END_VAR

	T := EXP(X);
	COSH := (1.0 / T + T) * 0.5;
END_FUNCTION

FUNCTION SINH:REAL
	VAR_INPUT
		X :	REAL;
	END_VAR

	IF ABS(X) < 2.0E-3 THEN
		SINH := X;
	ELSE
		SINH := (EXP(X) - EXP(-X)) * 0.5;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK CCOSH_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CCOSH :	oscat_complex;
	END_VAR

	CCOSH.re := COSH(X.re) * COS(X.im);
	CCOSH.im := SINH(X.re) * SIN(X.im);
END_FUNCTION_BLOCK

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

FUNCTION_BLOCK CCOS_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CCOS :	oscat_complex;
	END_VAR

	VAR
		CSET :	CSET_Block;
		CCOSH :	CCOSH_Block;
	END_VAR

	CSET(RE:= -X.im,IM:=X.re);
	CCOSH(X:=CSET.CSET);
	CCOS := CCOSH.CCOSH;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CCOS_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CCOS;
END_PROGRAM

