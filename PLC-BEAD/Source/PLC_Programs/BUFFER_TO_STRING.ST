TYPE
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

FUNCTION_BLOCK BUFFER_TO_STRING_Block
	VAR_IN_OUT
		PT  :	oscat_arb_0_249;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
		START :	UINT;
		STOP :	UINT;
	END_VAR

	VAR_OUTPUT
		BUFFER_TO_STRING :	STRING;
	END_VAR

	VAR
		sta :	UINT;
		stp :	UINT;
		size2 :	UINT;
		i :	INT;
		BUF_TO_STRING :	BUF_TO_STRING;
	END_VAR

	sta := MIN(START, SIZE - UINT#1);
	stp := STOP;
	IF stp - sta + UINT#1 > UINT#250 THEN
		stp := sta + UINT#250 - UINT#1;
	END_IF;
	stp := MIN(stp, SIZE - UINT#1);
	size2 := stp - sta + UINT#1; 
	IF size2 > UINT#0 THEN
		FOR i := 0 TO 1 DO
			BUF_TO_STRING.REQ := i > 0;
			BUF_TO_STRING.BUF_FORMAT := TRUE;
			BUF_TO_STRING.BUF_OFFS := UINT_TO_DINT(START);
			BUF_TO_STRING.BUF_CNT := UINT_TO_DINT(size2);
			BUF_TO_STRING.BUFFER := pt;
			BUF_TO_STRING.DST := BUFFER_TO_STRING;
			BUF_TO_STRING();
			pt := BUF_TO_STRING.BUFFER;
			BUFFER_TO_STRING := BUF_TO_STRING.DST;
		END_FOR;
	ELSE
		BUFFER_TO_STRING :='';
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : oscat_arb_0_249;
    LocalVar1 : UINT;
	LocalVar2 : UINT;
	LocalVar3 : UINT;
	LocalOUT  : INT;
	func_block : BUFFER_TO_STRING_Block;
  END_VAR
	func_block.PT  := LocalVar0;
	func_block.SIZE := LocalVar1;
	func_block.START := LocalVar2;
	func_block.STOP := LocalVar3;
	func_block();
	LocalOUT := func_block.BUFFER_TO_STRING;
	LocalVar0 := func_block.PT;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION