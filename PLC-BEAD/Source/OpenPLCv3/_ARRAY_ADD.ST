TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION _ARRAY_ADD:	BOOL
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR
	VAR_INPUT
		SIZE :	UINT;
		X :	REAL;
	END_VAR
	VAR
		i :	INT;
		stop :	INT;
	END_VAR

	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
	FOR i := 1 TO stop DO
		pt[i] := pt[i] + X;
	END_FOR;
	_ARRAY_ADD := TRUE;

END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalVar2 : REAL;
	LocalOUT  : BOOL;
  END_VAR

  LocalOUT := _ARRAY_ADD(LocalVar0, LocalVar1, LocalVar2);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
