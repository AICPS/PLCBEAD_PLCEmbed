TYPE
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

FUNCTION_BLOCK _BUFFER_CLEAR
	VAR_IN_OUT
		PT :	oscat_arb_0_249;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		BUFFER_CLEAR :	BOOL;
	END_VAR

	VAR
		err :	INT;
		result :	WORD;
	END_VAR

	result := MEMSET(err,BYTE#00,UINT_TO_DINT(size),pt[0]);
	BUFFER_CLEAR := (err = 0);

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar1 : oscat_arb_0_249;
		LocalVar2 : UINT;
		LocalOUT  : BOOL;
		func_block : _BUFFER_CLEAR;
  	END_VAR
	func_block.PT := LocalVar1;
	func_block.SIZE := LocalVar2;
	func_block();
	LocalOUT := func_block.BUFFER_CLEAR;
END_PROGRAM

CONFIGURATION Config0
	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION