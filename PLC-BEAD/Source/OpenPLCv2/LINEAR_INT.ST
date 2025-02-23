TYPE  
	oscat_ARRAY_X               : ARRAY [0..1]    OF REAL;
	oscat_XY                    : ARRAY [1..20]   OF oscat_ARRAY_X := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
END_TYPE

FUNCTION_BLOCK LINEAR_INT_Block

	VAR_INPUT
		X :	REAL;
		XY :	oscat_XY;
		PTS :	INT;
	END_VAR


	VAR_OUTPUT
		LINEAR_INT :	REAL;
	END_VAR


	VAR
		i :	INT;
		i2 :	INT;
	END_VAR


	pts := MIN(pts,20);

	i := 2;

	WHILE (i < pts) AND (XY[i][0] < X) DO
		i := i + 1;
	END_WHILE;

	i2 := i-1;

	LINEAR_INT := ((XY[i][1] - XY[i2][1]) * X - XY[i][1] * XY[i2][0] + XY[i2][1] * XY[i][0]) / (XY[i][0] - XY[i2][0]);

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		X :	REAL;
		XY :	oscat_XY;
		PTS :	INT;
		
		LINEAR_INT :	REAL;

		func_block : LINEAR_INT_Block;
	END_VAR
	func_block.X := X;
	func_block.XY := XY;
	func_block.PTS := PTS;

	func_block();
	LINEAR_INT := func_block.LINEAR_INT;


END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION