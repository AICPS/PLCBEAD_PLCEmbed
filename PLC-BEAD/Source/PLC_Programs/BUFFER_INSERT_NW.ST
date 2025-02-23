TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;
END_TYPE

FUNCTION_BLOCK _BUFFER_INSERT_NW
	VAR_INPUT
		STR :	STRING;
		POS :	INT;
	END_VAR

	VAR_IN_OUT
		PT :	oscat_NW_BUF_LONG;
	END_VAR

	VAR_INPUT
		SIZE :	UINT;
	END_VAR

	VAR_OUTPUT
		_BUFFER_INSERT :	INT;
	END_VAR

	VAR
		end :	INT;
		lx :	INT;
		i :	INT;
		i2 :	INT;
		_STRING_TO_BUFFER :	_STRING_TO_BUFFER;
	END_VAR

	i := UINT_TO_INT(size) - 1;
	pos := LIMIT_INT(0,pos,i);
	lx := LEN(str);
	end := pos + lx;
	(* first move the upper part of the buffer to make space for the string *)
	i2 := i - lx;
	WHILE i >= end DO					
	pt[i] := pt[i2]; 
	i  := i  - 1;
	i2 := i2 - 1;
	END_WHILE;

	_STRING_TO_BUFFER(str:=str, pos:=pos, size:=size, pt:=pt);
	_BUFFER_INSERT := _STRING_TO_BUFFER._STRING_TO_BUFFER;
	pt := _STRING_TO_BUFFER.pt;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	STR :	STRING;
	POS :	INT;

	PT :	oscat_NW_BUF_LONG;

	SIZE :	UINT;

	_BUFFER_INSERT :	INT;
	func_block : _BUFFER_INSERT_NW;
  END_VAR
	func_block.STR  :=STR ;
	func_block.POS  :=POS ;
	func_block.SIZE  :=SIZE ;
	func_block.PT  :=PT ;
	func_block();
	PT := func_block.PT;
	_BUFFER_INSERT := func_block._BUFFER_INSERT;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION