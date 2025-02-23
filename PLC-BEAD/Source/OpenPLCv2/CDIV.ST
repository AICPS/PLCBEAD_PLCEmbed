TYPE oscat_complex :
  STRUCT
	re : REAL;
	im : REAL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK CDIV_Block

	VAR_INPUT
		X :	oscat_complex;
		Y :	oscat_complex;
	END_VAR

	VAR_OUTPUT
		CDIV :	oscat_complex;
	END_VAR

	VAR
		temp :	REAL;
	END_VAR

	temp := Y.re * Y.re + Y.im * Y.im;
	IF temp = 0.0 THEN CDIV.re := 0.0;CDIV.im := 0.0;RETURN;END_IF;
	CDIV.re := (X.re * Y.re + X.im * Y.im) / temp;
	CDIV.im := (X.im * Y.re - X.re * Y.im) / temp;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	oscat_complex;
		Y :	oscat_complex;

		CDIV :	oscat_complex;

		func_block : CDIV_Block;
	END_VAR
	func_block.X := X;
	func_block.Y := Y;
	func_block();
	CDIV := func_block.CDIV;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION