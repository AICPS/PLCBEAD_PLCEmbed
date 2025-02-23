FUNCTION_BLOCK IS_CC_Block

	VAR_INPUT
		STR :	STRING;
		CMP :	STRING;
	END_VAR

	VAR_OUTPUT
		IS_CC :	BOOL;
	END_VAR

	VAR
		L :	INT;
		POS :	INT;
		temp :	STRING;
	END_VAR

	L := LEN(STR);
	FOR POS := 1 TO L DO
		temp := MID(STR,1,POS);
		IF FIND(CMP,temp) = 0 THEN
			IS_CC := FALSE;
			RETURN;
		END_IF;
	END_FOR;
	IS_CC := L > 0;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		STR :	STRING;
		CMP :	STRING;

		IS_CC :	BOOL;
		
		func_block : IS_CC_Block;
	END_VAR
	func_block.STR := STR;
	func_block.CMP := CMP;
	func_block();
	IS_CC := func_block.IS_CC;

END_PROGRAM

