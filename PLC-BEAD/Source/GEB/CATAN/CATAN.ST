TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CATAN_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR


	VAR_OUTPUT
		CATAN :	oscat_complex;
	END_VAR

	VAR
		R2 :	REAL;
		num :	REAL;
		den :	REAL;
	END_VAR

	R2 := X.re * X.re;
	den := 1.0 - R2 - X.im * X.im;
	CATAN.re := 0.5 * ATAN(2.0 * X.re / den);
	num := X.im + 1.0;
	num := R2 + num * num;
	den := X.im - 1.0;
	den := R2 + den * den;
	CATAN.im := 0.25 * (LN(num)-LN(den));

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CATAN_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CATAN;
END_PROGRAM

