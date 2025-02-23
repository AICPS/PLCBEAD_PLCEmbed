TYPE
	oscat_pt_ARRAY: ARRAY [1..100] OF REAL;
END_TYPE

FUNCTION SQRTN:REAL
	VAR_INPUT
		X :	REAL;
		N :	INT;
	END_VAR

	IF N > 0 THEN
		SQRTN := EXP(LN(x) / INT_TO_REAL(n));
	ELSE
		SQRTN := 0.0;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK ARRAY_GAV_Block
	VAR_IN_OUT
		PT :	oscat_pt_ARRAY;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		ARRAY_GAV :	REAL;
	END_VAR

	VAR
		i :	INT;
		stop :	INT;
	END_VAR

	stop :=LIMIT_INT(1,UINT_TO_INT(size),1000);
	ARRAY_GAV := 1.0;
	FOR i := 1 TO stop DO
		IF pt[i] > 0.0 THEN
			ARRAY_GAV := ARRAY_GAV * pt[i];
		ELSE
			ARRAY_GAV := 0.0;
			RETURN;
		END_IF;
	END_FOR;
	ARRAY_GAV := SQRTN(ARRAY_GAV,stop);
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_pt_ARRAY;
    LocalVar1 : UINT;
	LocalOUT  : REAL;
	func_block : ARRAY_GAV_Block;
  END_VAR
	func_block.pt := LocalVar0;
	func_block.size := LocalVar1;
	func_block();
	LocalOUT := func_block.ARRAY_GAV;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION