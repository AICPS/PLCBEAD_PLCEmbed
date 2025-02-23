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
	i := LEN(STR);
	WHILE i > 0 DO
	st_temp := MID(STR,1,i);
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

