FUNCTION SGN : INT
  VAR_INPUT
    x : REAL;
  END_VAR

  IF X > 0.0 THEN
  	sgn := 1;
  ELSIF X < 0.0 THEN
  	sgn := -1;
  ELSE
  	sgn := 0;
  END_IF;
END_FUNCTION

FUNCTION ERF:REAL

	VAR_INPUT
		X :	REAL;
	END_VAR

	VAR
		x2 :	REAL;
		ax2 :	REAL;
	END_VAR

	x2 := X*X;
	ax2 := 0.147 * x2 + 1.0;
	ERF := SQRT(1.0 - EXP(-X2 * ((0.27323954473516 + aX2)/(ax2)))) * INT_TO_REAL(SGN(x));

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	  LocalOUT  : REAL;
  END_VAR
  	LocalOUT := ERF(LocalVar0);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION