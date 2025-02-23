TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION_BLOCK ARRAY_VAR_Block
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		ARRAY_VAR :	REAL;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
		avg :	REAL;
	END_VAR

	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
	avg := pt[1];
	FOR i := 2 TO stop DO
		avg := avg + pt[i];
	END_FOR;
	avg := avg / INT_TO_REAL(stop);

	array_var := EXPT(pt[1] - avg, 2.0);
	FOR i := 2 TO stop DO
		array_var := array_var + EXPT(pt[i] - avg, 2.0);
	END_FOR;
	array_var := array_var / INT_TO_REAL(stop-1);

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : REAL;
	func_block : ARRAY_VAR_Block;
  END_VAR
	func_block.pt := LocalVar0;
	func_block.size := LocalVar1;
	func_block();
	LocalOUT := func_block.ARRAY_VAR;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
