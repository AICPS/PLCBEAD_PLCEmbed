TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION _ARRAY_ABS : BOOL
	VAR_IN_OUT
		PT : oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
	END_VAR
	
	stop := LIMIT_INT(1,UINT_TO_INT(size),1000);
	FOR i := 1 TO stop DO
		pt[i] := ABS(pt[i]);
	END_FOR;

	_ARRAY_ABS := TRUE;
	
END_FUNCTION

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : BOOL;
  END_VAR

  LocalOUT := _ARRAY_ABS(LocalVar0, LocalVar1);
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
