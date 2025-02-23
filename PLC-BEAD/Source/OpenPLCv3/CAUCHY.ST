FUNCTION CAUCHY:REAL
	VAR_INPUT
		X :	REAL;
		T :	REAL;
		U :	REAL;
	END_VAR

	VAR
		tmp :	REAL;
	END_VAR

	tmp := x - t;
	CAUCHY := 0.318309886183791 * U / (U*U + tmp*tmp);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVar1 : REAL;
	LocalVar2 : REAL;
    CEIL5_OUT : REAL;
  END_VAR

  CEIL5_OUT := CAUCHY(LocalVar0, LocalVar1, LocalVar2);
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION