FUNCTION FLOOR : INT
	VAR_INPUT
		x : REAL;
	END_VAR

	FLOOR := REAL_TO_INT(X);
	IF INT_TO_REAL(FLOOR) > X THEN
		floor := floor - 1;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK STAIR2_Block

	VAR_INPUT
		X :	REAL;
		D :	REAL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	IF D > 0.0 THEN
		IF X >= Y + D OR X <= Y - D THEN Y := INT_TO_REAL(FLOOR(X/D)) * D; END_IF;
	ELSE
		Y := X;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  
	VAR
		X :	REAL;
		D :	REAL;
		Y :	REAL;
		func_block : STAIR2_Block;
	END_VAR
	func_block.X := X;
	func_block.D := D;
	func_block();
	Y := func_block.Y;

END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION