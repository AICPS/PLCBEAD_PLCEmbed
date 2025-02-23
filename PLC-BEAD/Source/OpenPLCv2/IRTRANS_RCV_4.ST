FUNCTION_BLOCK IRTRANS_RCV_4_Block

	VAR_INPUT
		CMD :	BOOL;
	END_VAR


	VAR_IN_OUT
		DEV :	STRING;
		KEY :	STRING;
	END_VAR


	VAR_INPUT
		DEV_CODE :	STRING;
		KEY_CODE_0 :	STRING;
		KEY_CODE_1 :	STRING;
		KEY_CODE_2 :	STRING;
		KEY_CODE_3 :	STRING;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
	END_VAR


	VAR
		decode :	BOOL;
	END_VAR

	decode := cmd AND EQ_STRING(dev_code,dev);

	Q0 := EQ_STRING(key,key_code_0) AND decode;
	Q1 := EQ_STRING(key,key_code_1) AND decode;
	Q2 := EQ_STRING(key,key_code_2) AND decode;
	Q3 := EQ_STRING(key,key_code_3) AND decode;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		CMD :	BOOL;
		DEV :	STRING;
		KEY :	STRING;
		DEV_CODE :	STRING;
		KEY_CODE_0 :	STRING;
		KEY_CODE_1 :	STRING;
		KEY_CODE_2 :	STRING;
		KEY_CODE_3 :	STRING;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;

		func_block : IRTRANS_RCV_4_Block;
	END_VAR
	func_block.CMD := CMD;
	func_block.DEV := DEV;
	func_block.KEY := KEY;
	func_block.DEV_CODE := DEV_CODE;
	func_block.KEY_CODE_0 := KEY_CODE_0;
	func_block.KEY_CODE_1 := KEY_CODE_1;
	func_block.KEY_CODE_2 := KEY_CODE_2;
	func_block.KEY_CODE_3 := KEY_CODE_3;

	func_block();
	DEV  := func_block.DEV;
	KEY  := func_block.KEY;
	Q0  := func_block.Q0;
	Q1  := func_block.Q1;
	Q2  := func_block.Q2;
	Q3  := func_block.Q3;


END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION