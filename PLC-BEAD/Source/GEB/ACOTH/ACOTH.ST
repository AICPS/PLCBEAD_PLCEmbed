FUNCTION ACOTH:REAL
	VAR_INPUT
		x :	REAL;
	END_VAR

	ACOTH := LN((x+1.0)/(x-1.0))*0.5;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalOUT  : REAL;
  END_VAR

  LocalOUT := ACOTH(LocalVar0);
END_PROGRAM

