FUNCTION EXP10 : REAL
  VAR_INPUT
    X : REAL;
  END_VAR

  EXP10 := EXP(X * 2.30258509299405);
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION FLOOR : INT
  VAR_INPUT
    X : REAL;
  END_VAR

  FLOOR := REAL_TO_INT(X);
  IF INT_TO_REAL(FLOOR) > X THEN
  	FLOOR := FLOOR - 1;
  END_IF;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION CMP:BOOL
	VAR_INPUT
		X :	REAL;
		Y :	REAL;
		N :	INT;
	END_VAR

	VAR
		tmp :	REAL;
	END_VAR

	tmp := ABS(X);
	IF tmp > 0.0 THEN
		tmp := EXP10(INT_TO_REAL(FLOOR(LOG(tmp))-N+1));
	ELSE
		tmp := EXP10(tmp);
	END_IF;
	CMP := ABS(X - Y) < tmp;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : REAL;
	LocalVaR2 : INT;
    CEIL5_OUT : BOOL;
  END_VAR

  CEIL5_OUT := CMP(LocalVar0, LocalVaR1 , LocalVaR2);
END_PROGRAM


