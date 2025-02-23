FUNCTION F_QUAD:REAL

	VAR_INPUT
		X :	REAL;
		A :	REAL;
		B :	REAL;
		C :	REAL;
	END_VAR

	F_QUAD :=  (A * X + B) * X + C;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	LocalVar2 : REAL;
	LocalVar3 : REAL;
	LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_QUAD(LocalVar0, LocalVar1, LocalVar2, LocalVar3);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
