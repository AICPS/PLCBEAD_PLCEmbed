
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

	VAR RETAIN 
		offset :	REAL;
		Scale :	REAL := 1.0;
	END_VAR

	IF CO THEN
		OFFSET := Y_Offset - X;
	ELSIF CS THEN
		SCALE := Y_scale / (X + OFFSET);
	END_IF;
	Y := (X + OFFSET) * SCALE;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
    LocalVar1 : BOOL;
	LocalVar2 : BOOL;
	LocalVar3 : REAL;
	LocalVar4 : REAL;
	LocalOUT  : REAL;
	func_block : CALIBRATE;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.CO := LocalVar1;
	func_block.CS  := LocalVar2;
	func_block.Y_OFFSET := LocalVar3;
	func_block.Y_SCALE := LocalVar4;
	func_block();
	LocalOUT := func_block.Y;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION