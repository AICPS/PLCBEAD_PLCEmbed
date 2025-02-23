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

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalVaR1  : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CMUL_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.Y  := LocalVaR1 ;
	func_block();
	LocalOUT := func_block.CMUL;
END_PROGRAM

