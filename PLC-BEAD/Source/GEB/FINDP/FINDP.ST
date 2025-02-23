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


	ls := LEN(STR);
	lx := LEN(SRC);
	IF ls < lx OR lx = 0 THEN RETURN; END_IF;
	stp := ls - lx + 1;
	FOR i := MAX(POS,1) TO stp DO
		st_tmp := MID(STR,lx,i);
		IF EQ_STRING(st_tmp,SRC) THEN
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


