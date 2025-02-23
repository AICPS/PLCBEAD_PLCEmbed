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

FUNCTION_BLOCK REPLACE_ALL_Block

	VAR_INPUT
		STR :	STRING;
		SRC :	STRING;
		REP :	STRING;
	END_VAR


	VAR_OUTPUT
		REPLACE_ALL :	STRING;
	END_VAR

	VAR
		pos :	INT;
		lp :	INT;
		lx :	INT;
		FINDP :	FINDP_Block;
		st_tmp :	STRING;
	END_VAR


	REPLACE_ALL := str;
	lx := LEN(src);
	lp := LEN(rep);

	FINDP.str := REPLACE_ALL;
	FINDP.src := src;
	FINDP.pos := 1;
	FINDP();
	pos := FINDP.FINDP;

	WHILE pos > 0 DO
		st_tmp := REPLACE_ALL;
		REPLACE_ALL := REPLACE(st_tmp,rep,lx,pos);

		FINDP.str := REPLACE_ALL;
		FINDP.src := src;
		FINDP.pos := pos + lp;
		FINDP();
		pos := FINDP.FINDP;

	END_WHILE;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		STR :	STRING;
		SRC :	STRING;
		REP :	STRING;
		
        REPLACE_ALL :	STRING;
		func_block : REPLACE_ALL_Block;
	END_VAR
		func_block.STR := STR;
		func_block.SRC := SRC;
		func_block.REP := REP;
		func_block();
		REPLACE_ALL := func_block.REPLACE_ALL;

END_PROGRAM


CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
