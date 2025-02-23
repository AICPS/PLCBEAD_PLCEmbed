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
		r2 :	REAL;
		num :	REAL;
		den :	REAL;
	END_VAR

	r2 := x.re * x.re;
	den := 1.0 - r2 - x.im * x.im;
	CATAN.re := 0.5 * ATAN(2.0 * x.re / den);
	num := x.im + 1.0;
	num := r2 + num * num;
	den := x.im - 1.0;
	den := r2 + den * den;
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

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
