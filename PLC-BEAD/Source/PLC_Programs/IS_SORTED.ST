TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION_BLOCK IS_SORTED_Block

	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		IS_SORTED :	BOOL;
	END_VAR

	VAR
		i :	INT;
		i2 :	INT;
		stop :	INT;
	END_VAR

	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
	stop := stop -1;
	FOR i := 1 TO stop DO
		i2 := i+1;
		IF pt[i] > pt[i2] THEN
			IS_SORTED := FALSE;
			RETURN;
		END_IF;
	END_FOR;

	IS_SORTED := TRUE;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		SIZE :	UINT;
		PT :	oscat_pt_ARRAY;
		IS_SORTED :	BOOL;
		func_block : IS_SORTED_Block;
	END_VAR
	func_block.SIZE := SIZE;
	func_block.PT := PT;
	func_block();
	PT := func_block.PT;
	IS_SORTED := func_block.IS_SORTED;


END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION