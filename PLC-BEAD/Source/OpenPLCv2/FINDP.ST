FUNCTION_BLOCK FINDP_Block

	VAR_INPUT
		STR :	STRING;
		SRC :	STRING;
		POS :	INT;
	END_VAR


	VAR_OUTPUT
		FINDP :	INT;
	END_VAR

	VAR
		i :	INT;
		ls :	INT;
		lx :	INT;
		stp :	INT;
		st_tmp :	STRING;
	END_VAR


	ls := LEN(str);
	lx := LEN(src);
	IF ls < lx OR lx = 0 THEN RETURN; END_IF;
	stp := ls - lx + 1;
	FOR i := MAX(pos,1) TO stp DO
		st_tmp := MID(str,lx,i);
		IF EQ_STRING(st_tmp,src) THEN
			FINDP := i;
			RETURN;
		END_IF;
	END_FOR;
	FINDP := 0;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		STR :	STRING;
		SRC :	STRING;
		POS :	INT;
		
        FINDP :	INT;
		func_block : FINDP_Block;
	END_VAR
		func_block.STR := STR;
		func_block.SRC := SRC;
		func_block.POS := POS;
		func_block();
		FINDP := func_block.FINDP;

END_PROGRAM


CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
