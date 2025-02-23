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

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    CEIL5_OUT : INT;
  END_VAR

  CEIL5_OUT := FLOOR(LocalVar0);
END_PROGRAM


