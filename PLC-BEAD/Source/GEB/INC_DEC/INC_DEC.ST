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
		CLK :	BOOL;
		CLKa :	BOOL;
		CLKb :	BOOL;
		edgeb :	BOOL;
		axb :	BOOL;
	END_VAR

	axb := CHA XOR CHB;

	CLKa := CHA XOR edgea;
	edgea := CHA;

	CLKb := CHB XOR edgeb;
	edgeb := CHB;

	CLK := CLKa OR CLKb;

	IF axb AND CLKa THEN DIR := TRUE; END_IF;
	IF axb AND CLKb THEN DIR := FALSE; END_IF;

	IF CLK AND DIR THEN CNT := CNT + 1; END_IF;
	IF CLK AND NOT DIR THEN CNT := CNT -1; END_IF;

	IF RST THEN CNT := 0; END_IF;

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

