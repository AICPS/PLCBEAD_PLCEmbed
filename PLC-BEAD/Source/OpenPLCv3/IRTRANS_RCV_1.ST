FUNCTION_BLOCK IRTRANS_RCV_1_Block

	VAR_INPUT
		CMD :	BOOL;
		DEV_CODE :	STRING;
		KEY_CODE :	STRING;
	END_VAR


	VAR_OUTPUT
		Q :	BOOL;
	END_VAR


	VAR_IN_OUT
		DEV :	STRING;
		KEY :	STRING;
	END_VAR

	Q := cmd AND EQ_STRING(dev_code,dev) AND EQ_STRING(key_code,key);

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		CMD :	BOOL;
		DEV :	STRING;
		KEY :	STRING;
		DEV_CODE :	STRING;
		KEY_CODE :	STRING;
		Q :	BOOL;

		func_block : IRTRANS_RCV_1_Block;
	END_VAR
	func_block.CMD := CMD;
	func_block.DEV := DEV;
	func_block.KEY := KEY;
	func_block.DEV_CODE := DEV_CODE;
	func_block.KEY_CODE := KEY_CODE;

	func_block();
	DEV  := func_block.DEV;
	KEY  := func_block.KEY;
	Q  := func_block.Q;


END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION