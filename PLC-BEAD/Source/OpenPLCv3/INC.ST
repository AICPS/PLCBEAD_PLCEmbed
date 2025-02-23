FUNCTION INC:INT
	VAR_INPUT
		X :	INT;
		D :	INT;
		M :	INT;
	END_VAR

	inc := (X + D + M + 1) MOD (M + 1);
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : INT;
	LocalVar1 : INT;
	LocalVar2 : INT;
	LocalOUT  : INT;
  END_VAR
  	LocalOUT := INC(LocalVar0, LocalVar1,LocalVar2);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION