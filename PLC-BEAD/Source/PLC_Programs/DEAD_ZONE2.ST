FUNCTION_BLOCK DEAD_ZONE2
	VAR_INPUT
		X :	REAL;
		L :	REAL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
	END_VAR

	IF ABS(x) > L THEN
		Y := X;
	ELSIF Y > 0.0 THEN
		Y := L;
	ELSE
		Y := -L;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
    LocalVar0 : REAL;
	LocalVar1 : REAL;
	LocalOUT  : REAL;
	func_block : DEAD_ZONE2;
  END_VAR
	func_block.X  := LocalVar0;
	func_block.L  := LocalVar1;
	func_block();
	LocalOUT := func_block.Y;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION

