TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CCON_Block

	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CCON :	oscat_complex;
	END_VAR

	CCON.re := X.re;
	CCON.im := -X.im;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CCON_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CCON;
END_PROGRAM

