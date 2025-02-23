FUNCTION_BLOCK SEL2_OF_3_Block

	VAR_INPUT
		IN1 :	REAL;
		IN2 :	REAL;
		IN3 :	REAL;
		D :	REAL;
	END_VAR

	VAR_OUTPUT
		Y :	REAL;
		W :	INT;
		E :	BOOL;
	END_VAR

	VAR
		D12 :	BOOL;
		D23 :	BOOL;
		D31 :	BOOL;
	END_VAR

	D12 := ABS(IN1-IN2) <= D;
	D23 := ABS(IN2-IN3) <= D;
	D31 := ABS(IN3-IN1) <= D;

	IF (D12 AND D23) OR (D12 AND D31) OR (D23 AND D31) THEN
		Y := (IN1 + IN2 + IN3) * 0.333333333333;
		E := FALSE;
		W := 0;
	ELSIF D12 THEN
		Y := (In1 + IN2) * 0.5;
		E := FALSE;
		W := 3;
	ELSIF D23 THEN
		Y := (In2 + IN3) * 0.5;
		E := FALSE;
		W := 1;
	ELSIF D31 THEN
		Y := (In3 + IN1) * 0.5;
		E := FALSE;
		W := 2;
	ELSE
		E := TRUE;
		W := 4;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	
	VAR
		IN1 :	REAL;
		IN2 :	REAL;
		IN3 :	REAL;
		D :	REAL;
		Y :	REAL;
		W :	INT;
		E :	BOOL;
		func_block : SEL2_OF_3_Block;
  	END_VAR
	func_block.IN1  :=IN1;
	func_block.IN2  :=IN2;
	func_block.IN3  :=IN3;
	func_block.D  :=D;
	func_block();
	Y := func_block.Y;
	W := func_block.W;
	E := func_block.E;

END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION