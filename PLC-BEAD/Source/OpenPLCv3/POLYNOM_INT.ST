TYPE
	oscat_Polynom_ARRAY_X       : ARRAY [0..1]    OF REAL;
END_TYPE

TYPE
	oscat_Polynom_XY            : ARRAY [1..5]  OF oscat_Polynom_ARRAY_X := [0, 0, 0, 0, 0];
END_TYPE

FUNCTION_BLOCK POLYNOM_INT_Block

	VAR_INPUT
		X :	REAL;
		XY :	oscat_Polynom_XY;
	END_VAR

	VAR_INPUT
		PTS :	INT;
	END_VAR


	VAR_OUTPUT
		POLYNOM_INT :	REAL;
	END_VAR

	VAR
		XY2 :	oscat_Polynom_XY;
	END_VAR


	VAR
		I :	INT;
		J :	INT;
		J_1 :	INT;
		J_I :	INT;
		INIT :	BOOL;
	END_VAR

	pts := MIN_INT(pts, 5);

	IF (init = FALSE) THEN
		init := TRUE;

		FOR i := 1 TO pts DO
			FOR j := 0 TO 1 DO
					XY2[i][j] := XY[i][j];
			END_FOR;
		END_FOR;

		FOR i := 1 TO pts DO
			J := pts;
			WHILE (J >= i+1) DO
			j_i := j-i;
			j_1 := J-1;
			XY2[j][1] := (XY2[j][1] - XY2[j_1][1]) / (XY2[j][0] - XY2[j_i][0]);
			j := j - 1;
			END_WHILE;
		END_FOR;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		X :	REAL;
		XY :	oscat_Polynom_XY;
		PTS :	INT;

		OUT :	REAL;
		func_block : POLYNOM_INT_Block;
  	END_VAR

	func_block.X := X;
	func_block.XY := XY;
	func_block.PTS := PTS;
	func_block();
	OUT := func_block.POLYNOM_INT;

END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION
