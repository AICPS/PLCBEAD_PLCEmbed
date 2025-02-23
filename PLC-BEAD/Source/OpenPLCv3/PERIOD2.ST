TYPE
	oscat_PERIOD2_Y             : ARRAY [0..1]    OF UDINT;
	oscat_PERIOD2_X             : ARRAY [0..3]    OF oscat_PERIOD2_Y := [0, 0, 0, 0];
END_TYPE

FUNCTION_BLOCK PERIOD2_Block

	VAR_INPUT
		DP :	oscat_PERIOD2_X;
		DX :	UDINT;
	END_VAR


	VAR_OUTPUT
		PERIOD2 :	BOOL;
	END_VAR


	(*@KEY@: WORKSHEET
	NAME: PERIOD2
	IEC_LANGUAGE: ST
	*)
	PERIOD2 := 	(DX >= DP[0][0] AND DX <= DP[0][1]) OR
				(DX >= DP[1][0] AND DX <= DP[1][1]) OR
				(DX >= DP[2][0] AND DX <= DP[2][1]) OR
				(DX >= DP[3][0] AND DX <= DP[3][1]);


END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		DP :	oscat_PERIOD2_X;
		DX :	UDINT;

		PERIOD2 :	BOOL;
		func_block : PERIOD2_Block;
  	END_VAR

	func_block.DP := DP;
	func_block.DX := DX;
	func_block();
	PERIOD2 := func_block.PERIOD2;

END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION