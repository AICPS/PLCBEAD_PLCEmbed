FUNCTION EXP10 : REAL
  VAR_INPUT
    x : REAL;
  END_VAR

  exp10 := EXP(X * 2.30258509299405);
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION FLOOR : INT
  VAR_INPUT
    x : REAL;
  END_VAR

  FLOOR := REAL_TO_INT(X);
  IF INT_TO_REAL(FLOOR) > X THEN
  	floor := floor - 1;
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

	tmp := ABS(x);
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
    LocalVar1 : REAL;
	LocalVar2 : INT;
    CEIL5_OUT : BOOL;
  END_VAR

  CEIL5_OUT := CMP(LocalVar0, LocalVar1, LocalVar2);
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION