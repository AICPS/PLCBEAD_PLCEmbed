TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CATANH_Block
	VAR_INPUT
		X :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CATANH :	oscat_complex;
	END_VAR

	VAR
		i2 :	REAL;
		num :	REAL;
		den :	REAL;
	END_VAR

	i2 := x.im * x.im;
	num := 1.0 + x.re;
	num := i2 + num * num;
	den := 1.0 - x.re;
	den := i2 + den * den;
	CATANH.re := 0.25 * (LN(num) - LN(den));
	den := 1.0 - x.re * x.re - i2;
	CATANH.im := 0.5 * ATAN(2.0 * x.im / den);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_complex;
	LocalOUT  : oscat_complex;
	func_block : CATANH_Block;
  END_VAR
	func_block.X  := LocalVar0;
	func_block();
	LocalOUT := func_block.CATANH;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
