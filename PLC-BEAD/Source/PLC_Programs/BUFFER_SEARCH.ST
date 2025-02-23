TYPE
	oscat_arb_0_249 			  : ARRAY [0..249] 	OF BYTE;
END_TYPE

FUNCTION_BLOCK BUFFER_SEARCH_Block
	VAR_INPUT
		SIZE :	UINT;
		STR :	STRING;
		POS :	INT;
		IGN :	BOOL;
	END_VAR

	VAR_IN_OUT
		PT :	oscat_arb_0_249;
	END_VAR

	VAR_OUTPUT
		BUFFER_SEARCH :	INT;
	END_VAR

	VAR
		i :	INT;
		end :	INT;
		k :	INT;
		k2 :	INT;
		lx :	INT;
		char :	BYTE;
		chx :	BYTE;
	END_VAR

	lx := LEN(str);
	IF pos >= 0 AND lx > 0 THEN 
		end := UINT_TO_INT(size) - lx;
		lx := lx - 1;
		FOR i := pos TO end DO
			FOR k := 0 TO lx DO
				char := INT_TO_BYTE(GET_CHAR(str,k + 1));
				k2 := i + k;
				IF IGN THEN
					chx := TO_UPPER(pt[k2]);
				ELSE
					chx := pt[k2];
				END_IF;
				IF char <> chx THEN EXIT; END_IF;
			END_FOR;
			IF k > lx THEN
				BUFFER_SEARCH := i;
				RETURN;
			END_IF;
		END_FOR;
	END_IF;
	BUFFER_SEARCH := -1;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : UINT;
    LocalVar1 : STRING;
	LocalVar2 : INT;
	LocalVar3 : BOOL;
	LocalVar4 : oscat_arb_0_249;
	LocalOUT  : INT;
	func_block : BUFFER_COMP_Block;
  END_VAR
	func_block.SIZE  := LocalVar0;
	func_block.STR  := LocalVar1;
	func_block.POS   := LocalVar2;
	func_block.IGN  := LocalVar3;
	func_block.PT := LocalVar4;
	func_block();
	LocalOUT := func_block.BUFFER_COMP;
	LocalVar4 := func_block.PT;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION