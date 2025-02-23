TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CEXP_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CEXP :	oscat_complex;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR

	temp := EXP(X.re);
	CEXP.re := temp * COS(X.im);
	CEXP.im := temp * SIN(X.im);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CEXP_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CEXP;
END_PROGRAM

