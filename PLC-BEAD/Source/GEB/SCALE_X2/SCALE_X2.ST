FUNCTION SCALE_X2:REAL
	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		K :	REAL;
		O :	REAL;
		IN1_MIN :	REAL;(*Standard = 0*)
		IN1_MAX :	REAL;(*Standard = 1000*)
		IN2_MIN :	REAL;(*Standard = 0*)
		IN2_MAX :	REAL;(*Standard = 1000*)
	END_VAR

	SCALE_X2 := (SEL(IN1,IN1_MIN, IN1_MAX)+ SEL(IN2,IN2_MIN, IN2_MAX))* k + o;

END_FUNCTION

PROGRAM program0

  	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		K :	REAL;
		O :	REAL;
		IN1_MIN :	REAL;(*Standard = 0*)
		IN1_MAX :	REAL;(*Standard = 1000*)
		IN2_MIN :	REAL;(*Standard = 0*)
		IN2_MAX :	REAL;(*Standard = 1000*)
		CEIL5_OUT : REAL;
  	END_VAR

  	CEIL5_OUT := SCALE_X2(IN1, IN2, K, O, IN1_MIN, IN1_MAX, IN2_MIN, IN2_MAX);
END_PROGRAM

