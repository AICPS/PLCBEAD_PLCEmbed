FUNCTION_BLOCK CTRL_OUT
	VAR_INPUT
		CI :	REAL;
		OFFSET :	REAL;
		MAN_IN :	REAL;
		LIM_L :	REAL;
		LIM_H :	REAL;
		MANUAL :	BOOL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		LIM :	BOOL;
	END_VAR

	Y := SEL(MANUAL, CI, MAN_IN) + OFFSET;

	IF Y >= LIM_H THEN
		Y := LIM_H;
		LIM := TRUE;
	ELSIF Y <= LIM_L THEN
		Y := LIM_L;
		LIM := TRUE;
	ELSE
		LIM := FALSE;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	CI :	REAL;
	OFFSET :	REAL;
	MAN_IN :	REAL;
	LIM_L :	REAL;
	LIM_H :	REAL;
	MANUAL :	BOOL;

	Y :	REAL;
	LIM :	BOOL;

	func_block : CTRL_OUT;
  END_VAR
	func_block.CI  := CI ;
	func_block.OFFSET   :=OFFSET ;
	func_block.MAN_IN   :=MAN_IN ;
	func_block.LIM_L   :=LIM_L ;
	func_block.LIM_H   :=LIM_H ;
	func_block.MANUAL   :=MANUAL ;
	func_block();
	Y := func_block.Y;
	LIM := func_block.LIM;
END_PROGRAM

