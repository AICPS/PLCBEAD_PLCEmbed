FUNCTION GAUSS:REAL

	VAR_INPUT
		X :	REAL;
		U :	REAL;
		SI :	REAL;
	END_VAR


	VAR
		temp :	REAL;
		si_inv :	REAL;
	END_VAR

	temp := X - U;
	si_inv := 1.0  / si;
	GAUSS := EXP(Temp * Temp * si_inv * SI_inv * - 0.5) * 0.39894228 * si_inv;

END_FUNCTION

PROGRAM program0
  VAR
    X :	REAL;
	U :	REAL;
	SI :	REAL;
    LocalOUT  : REAL;
  END_VAR

  LocalOUT := GAUSS(X, U, SI);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION