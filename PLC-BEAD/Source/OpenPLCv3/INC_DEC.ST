FUNCTION_BLOCK INC_DEC_Block

	VAR_INPUT
		CHA :	BOOL;
		CHB :	BOOL;
		RST :	BOOL := 0;
	END_VAR


	VAR_OUTPUT
		DIR :	BOOL;
		CNT :	INT;
	END_VAR

	VAR
		edgea :	BOOL := 0;
		clk :	BOOL;
		clka :	BOOL;
		clkb :	BOOL;
		edgeb :	BOOL;
		axb :	BOOL;
	END_VAR

	axb := cha XOR chb;

	clka := cha XOR edgea;
	edgea := cha;

	clkb := chb XOR edgeb;
	edgeb := chb;

	clk := clka OR clkb;

	IF axb AND clka THEN dir := TRUE; END_IF;
	IF axb AND clkb THEN dir := FALSE; END_IF;

	IF clk AND dir THEN cnt := cnt + 1; END_IF;
	IF clk AND NOT dir THEN cnt := cnt -1; END_IF;

	IF rst THEN cnt := 0; END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		CHA :	BOOL;
		CHB :	BOOL;
		RST :	BOOL := 0;

		DIR :	BOOL;
		CNT :	INT;
		func_block : INC_DEC_Block;
	END_VAR
	func_block.CHA := CHA;
	func_block.CHB := CHB;
	func_block.RST := RST;
	func_block();
	DIR := func_block.DIR;
	CNT := func_block.CNT;

END_PROGRAM

CONFIGURATION Config0

	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION