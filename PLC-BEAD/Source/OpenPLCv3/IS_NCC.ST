FUNCTION_BLOCK IS_NCC_Block

	VAR_INPUT
		STR :	STRING;
		CMP :	STRING;
	END_VAR

	VAR_OUTPUT
		IS_NCC :	BOOL;
	END_VAR

	VAR
		L :	INT;
		pos :	INT;
		temp :	STRING;
	END_VAR

	L := LEN(str);
	FOR pos := 1 TO L DO
		temp := MID(str,1,pos);
		IF FIND(CMP,temp) > 0 THEN
			IS_NCC := FALSE;
			RETURN;
		END_IF;
	END_FOR;
	IS_NCC := TRUE;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		STR :	STRING;
		CMP :	STRING;
		IS_NCC :	BOOL;
		func_block : IS_NCC_Block;
	END_VAR
	func_block.STR := STR;
	func_block.CMP := CMP;
	func_block();
	IS_NCC := func_block.IS_NCC;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION