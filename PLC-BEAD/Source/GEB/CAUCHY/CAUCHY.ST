FUNCTION CAUCHY:REAL
	VAR_INPUT
		X :	REAL;
		T :	REAL;
		U :	REAL;
	END_VAR

	VAR
		tmp :	REAL;
	END_VAR

	tmp := X - T;
	CAUCHY := 0.318309886183791 * U / (U*U + tmp*tmp);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : REAL;
	LocalVaR2 : REAL;
    CEIL5_OUT : REAL;
  END_VAR

  CEIL5_OUT := CAUCHY(LocalVar0, LocalVaR1 , LocalVaR2);
END_PROGRAM


