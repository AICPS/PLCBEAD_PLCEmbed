FUNCTION SGN : INT
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 0.0 THEN
  	SGN := 1;
  ELSIF X < 0.0 THEN
  	SGN := -1;
  ELSE
  	SGN := 0;
  END_IF;
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : INT;
    CEIL5_OUT : INT;
  END_VAR

  CEIL5_OUT := SGN(LocalVar0);
  LocalVaR1  := CEIL5_OUT;
END_PROGRAM


