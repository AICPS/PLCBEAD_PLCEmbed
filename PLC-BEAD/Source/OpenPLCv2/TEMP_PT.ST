FUNCTION RES_PT:REAL
	VAR_INPUT
		T :	REAL;
		R0 :	REAL;
	END_VAR

	VAR
		T2 :	REAL;
	END_VAR

	T2 := T * T;

	IF T >= 0.0 THEN
		RES_PT := R0 * ( 1.0 + 3.90802E-3 * T + -5.802E-7 * T2);
	ELSE
		RES_PT := R0 * ( 1.0 + 3.90802E-3 * T + -5.802E-7 * T2 + -4.27350E-12 * (T - 100.0) * T2 * T);
	END_IF;

END_FUNCTION

FUNCTION TEMP_PT:REAL

	VAR_INPUT
		RES :	REAL;
		R0 :	REAL;
	END_VAR

	VAR
		step_var :	REAL := REAL#50.0;
		X :	REAL;
		Y :	REAL;
		t1 :	REAL;
	END_VAR

	X := 3.9083E-3 * R0;
	Y := -5.775E-7 * R0;
	IF Res >= R0 THEN
		t1 := X * X - 4.0 * Y * (R0 - Res);
		IF t1 < 0.0 THEN
			TEMP_PT := 10000.0;
		ELSE
			TEMP_PT := (-X + SQRT(t1)) / (2.0 * Y);
		END_IF;
	ELSE
		TEMP_PT := -100.0;
		WHILE step_var > 0.01 DO
			IF RES_PT(TEMP_PT, R0) < res THEN TEMP_PT := TEMP_PT + step_var; ELSE TEMP_PT := TEMP_PT - step_var; END_IF;
			step_var := step_var * 0.5;
		END_WHILE;
	END_IF;
END_FUNCTION

PROGRAM program0
	VAR
		RES :	REAL;
		R0 :	REAL;
		CEIL5_OUT : REAL;
	END_VAR

	CEIL5_OUT := TEMP_PT(RES, R0);
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION