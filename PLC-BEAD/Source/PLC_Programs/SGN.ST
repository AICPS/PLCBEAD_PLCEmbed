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

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVar1 : INT;
    CEIL5_OUT : INT;
  END_VAR

  CEIL5_OUT := SGN(LocalVar0);
  LocalVar1 := CEIL5_OUT;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
