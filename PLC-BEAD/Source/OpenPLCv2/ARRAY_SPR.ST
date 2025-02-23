TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION_BLOCK ARRAY_SPR_Block
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		ARRAY_SPR :	REAL;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
		array_max :	REAL;
		array_min :	REAL;
	END_VAR

	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);

	array_min := pt[1];
	array_max := pt[1];
	FOR i := 2 TO stop DO
		IF pt[i] > array_max THEN array_max := pt[i];
		ELSIF pt[i] < array_min THEN array_min := pt[i];
		END_IF;
	END_FOR;
	array_spr := array_max - array_min;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : REAL;
	func_block : ARRAY_SPR_Block;
  END_VAR
	func_block.pt := LocalVar0;
	func_block.size := LocalVar1;
	func_block();
	LocalOUT := func_block.ARRAY_SPR;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION