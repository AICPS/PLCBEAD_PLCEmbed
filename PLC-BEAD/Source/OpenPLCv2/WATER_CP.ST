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

FUNCTION_BLOCK WATER_CP_Block

    VAR_INPUT
        T :	REAL;
    END_VAR


    VAR_OUTPUT
        CAP :	REAL;
    END_VAR


    VAR
        Pts :	INT;
        data :	oscat_XY;
        FB_LINEAR_INT :	LINEAR_INT_Block;
    END_VAR

    IF Pts = 0 THEN
        Pts := 10;

        data[01][0] := REAL#0.0;
        data[01][1] := REAL#4.228;
        data[02][0] := REAL#05.0;
        data[02][1] := REAL#4.200;
        data[03][0] := REAL#10.0;
        data[03][1] := REAL#4.188;
        data[04][0] := REAL#15.0;
        data[04][1] := REAL#4.184;
        data[05][0] := REAL#50.0;
        data[05][1] := REAL#4.181;
        data[06][0] := REAL#60.0;
        data[06][1] := REAL#4.183;
        data[07][0] := REAL#70.0;
        data[07][1] := REAL#4.187;
        data[08][0] := REAL#80.0;
        data[08][1] := REAL#4.194;
        data[09][0] := REAL#90.0;
        data[09][1] := REAL#4.204;
        data[10][0] := REAL#100.0;
        data[10][1] := REAL#4.220;

    END_IF;

    FB_LINEAR_INT(X:=T,XY:=Data,Pts:=Pts);
    cap:=FB_LINEAR_INT.LINEAR_INT;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		T :	REAL;
        CAP :	REAL;

		func_block : WATER_CP_Block;
	END_VAR
	func_block.T := T;

	func_block();
	CAP  := func_block.CAP;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION