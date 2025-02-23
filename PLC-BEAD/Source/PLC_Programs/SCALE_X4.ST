FUNCTION SCALE_X4:REAL
	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		K :	REAL;
		O :	REAL;
		IN1_MIN :	REAL;
		IN1_MAX :	REAL;
		IN2_MIN :	REAL;
		IN2_MAX :	REAL;
		IN3_MIN :	REAL;
		IN3_MAX :	REAL;
		IN4_MIN :	REAL;
		IN4_MAX :	REAL;
	END_VAR
	IF NOT in1 THEN scale_X4 := in1_min; ELSE scale_X4 := in1_max; END_IF;
	IF NOT in2 THEN scale_x4 := scale_x4 + in2_min; ELSE scale_x4 := scale_x4 + in2_max; END_IF;
	IF NOT in3 THEN scale_x4 := scale_x4 + in3_min; ELSE scale_x4 := scale_x4 + in3_max; END_IF;
	IF NOT in4 THEN scale_x4 := scale_x4 + in4_min; ELSE scale_x4 := scale_x4 + in4_max; END_IF;
	scale_X4 := scale_X4 * k + O;
	END_FUNCTION

PROGRAM program0

  	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		K :	REAL;
		O :	REAL;
		IN1_MIN :	REAL;
		IN1_MAX :	REAL;
		IN2_MIN :	REAL;
		IN2_MAX :	REAL;
		IN3_MIN :	REAL;
		IN3_MAX :	REAL;
		IN4_MIN :	REAL;
		IN4_MAX :	REAL;
		CEIL5_OUT : REAL;
  	END_VAR

  	CEIL5_OUT := SCALE_X4(IN1, IN2, IN3, IN4, K, O, IN1_MIN, IN1_MAX, IN2_MIN, IN2_MAX, IN3_MIN, IN3_MAX, IN4_MIN, IN4_MAX);
END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION