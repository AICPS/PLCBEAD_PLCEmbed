FUNCTION F_POWER:REAL
	VAR_INPUT
		A :	REAL;
		X :	REAL;
		N :	REAL;
	END_VAR

	f_power := a * EXPT(X,N);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	LocalVar2 : REAL;
	  LocalOUT  : REAL;
  END_VAR
  	LocalOUT := F_POWER(LocalVar0, LocalVar1, LocalVar2);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION