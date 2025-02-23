
FUNCTION_BLOCK CALIBRATE
	VAR_INPUT
		X :	REAL;
		CO :	BOOL;
		CS :	BOOL;
		Y_OFFSET :	REAL;
		Y_SCALE :	REAL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	VAR 
		OFFSET :	REAL;
		SCALE :	REAL := 1.0;
	END_VAR

	IF CO THEN
		OFFSET := Y_OFFSET - X;
	ELSIF CS THEN
		SCALE := Y_SCALE / (X + OFFSET);
	END_IF;
	Y := (X + OFFSET) * SCALE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVaR1  : BOOL;
	LocalVaR2 : BOOL;
	LocalVar3 : REAL;
	LocalVar4 : REAL;
	LocalOUT  : REAL;
	func_block : CALIBRATE;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.CO := LocalVaR1 ;
	func_block.CS  := LocalVaR2;
	func_block.Y_OFFSET := LocalVar3;
	func_block.Y_SCALE := LocalVar4;
	func_block();
	LocalOUT := func_block.Y;

END_PROGRAM

