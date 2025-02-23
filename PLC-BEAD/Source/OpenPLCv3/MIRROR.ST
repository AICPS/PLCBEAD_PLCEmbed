FUNCTION_BLOCK MIRROR_Block

	VAR_INPUT
		STR :	STRING;
	END_VAR


	VAR_OUTPUT
		MIRROR :	STRING;
	END_VAR


	VAR
		i :	INT;
		st_temp :	STRING;
	END_VAR


	mirror := '';
	i := LEN(str);
	WHILE i > 0 DO
	st_temp := MID(str,1,i);
	mirror := CONCAT(mirror,st_temp);
	i := i -1;
	END_WHILE;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		STR :	STRING;
		MIRROR :	STRING;
		func_block : MIRROR_Block;
	END_VAR
	func_block.STR := STR;
	func_block();
	MIRROR  := func_block.MIRROR;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION