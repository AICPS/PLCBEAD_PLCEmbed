TYPE
	oscat_STRING250             : STRING(250);
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

FUNCTION_BLOCK _STRING_TO_BUFFER_Block
	VAR_INPUT
		STR :	oscat_STRING250;
		POS :	INT;
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		_STRING_TO_BUFFER :	INT;
	END_VAR

	VAR_IN_OUT
		PT :	oscat_arb_0_249;
	END_VAR

	VAR
		i :	INT;
		end :	INT;
		x :	INT;
	END_VAR

	IF pos < 0 THEN RETURN; END_IF;
	end := MIN(pos + LEN(str), UINT_TO_INT(size)) - 1;
	x:= 1;
	FOR i := pos TO end DO
		pt[i] := INT_TO_BYTE(GET_CHAR(str,x));
		x := x + 1;
	END_FOR;

	_STRING_TO_BUFFER := i;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
	    LocalVar1 : oscat_STRING250;
        LocalVar2 : INT;
        LocalVar3 : UINT;
		LocalInOut : oscat_arb_0_249;
		LocalOUT  : INT;
		func_block : _STRING_TO_BUFFER_Block;
  	END_VAR
	func_block.STR := LocalVar1;
    func_block.POS := LocalVar2;
    func_block.SIZE := LocalVar3;
	func_block.PT := LocalInOut;
	func_block();
	LocalOUT := func_block._STRING_TO_BUFFER;
	LocalInOut := func_block.PT;
END_PROGRAM

CONFIGURATION Config0
  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE
END_CONFIGURATION