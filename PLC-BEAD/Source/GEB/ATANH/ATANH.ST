FUNCTION ATANH:REAL
	VAR_INPUT
		X :	REAL;
	END_VAR

	ATANH := LN((1.0 + X)/(1.0 - X)) * 0.5;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalOUT  : REAL;
  END_VAR

  LocalOUT := ATANH(LocalVar0);
END_PROGRAM

