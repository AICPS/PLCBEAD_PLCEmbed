TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CSUB_Block
	VAR_INPUT
		X :	oscat_complex;
		Y :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CSUB :	oscat_complex;
	END_VAR

	CSUB.re := X.re - Y.re;
	CSUB.im := X.im - Y.im;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalVaR1  : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CSUB_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.Y  := LocalVar0;
	func_block();
	LocalOUT := func_block.CSUB;
END_PROGRAM

