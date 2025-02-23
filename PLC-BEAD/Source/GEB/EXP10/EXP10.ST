FUNCTION EXP10 : REAL
  VAR_INPUT
    X : REAL;
  END_VAR

  EXP10 := EXP(X * 2.30258509299405);
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    CEIL5_OUT : REAL;
  END_VAR

  CEIL5_OUT := EXP10(LocalVar0);
END_PROGRAM


