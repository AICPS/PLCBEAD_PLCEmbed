FUNCTION F_LIN2:REAL
	VAR_INPUT
		X :	REAL;
		X1 :	REAL;
		Y1 :	REAL;
		X2 :	REAL;
		Y2 :	REAL;
	END_VAR

	F_LIN2 := (Y2 - Y1) / (X2 - X1) * (X - X1) + Y1;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	LocalVar2 : REAL;
	LocalVar3 : REAL;
	LocalVar4 : REAL;
	  LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_LIN2(LocalVar0, LocalVar1, LocalVar2, LocalVar3, LocalVar4);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION