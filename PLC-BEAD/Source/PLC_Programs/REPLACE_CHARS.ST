FUNCTION_BLOCK REPLACE_CHARS_Block

	VAR_INPUT
		STR :	STRING;
		SRC :	STRING;
		REP :	STRING;
	END_VAR

	VAR_OUTPUT
		REPLACE_CHARS :	STRING;
	END_VAR

	VAR
		tmp :	STRING;
		a :	INT;
		b :	INT;
		c :	STRING;
		stp :	INT;
	END_VAR


	REPLACE_CHARS := STR;

	a := LEN(src);
	b := LEN(rep);
	IF a < b THEN
		rep := LEFT(rep, a);
	ELSIF b < a THEN
		src := LEFT(src, b);
	END_IF;

	stp := LEN(str);
	FOR a := 1 TO stp DO
		c := MID(REPLACE_CHARS, 1, a);
		b := FIND(src, c);
		IF b > 0 THEN
			tmp := MID(rep, 1, b);
			REPLACE_CHARS := REPLACE(REPLACE_CHARS, tmp, 1, a);
		END_IF;
	END_FOR;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		STR :	STRING;
		SRC :	STRING;
		REP :	STRING;
		
        REPLACE_CHARS :	STRING;
		func_block : REPLACE_CHARS_Block;
	END_VAR
		func_block.STR := STR;
		func_block.SRC := SRC;
		func_block.REP := REP;
		func_block();
		REPLACE_CHARS := func_block.REPLACE_CHARS;

END_PROGRAM


CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION