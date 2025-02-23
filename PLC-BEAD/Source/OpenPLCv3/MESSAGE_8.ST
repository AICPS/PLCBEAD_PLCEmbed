FUNCTION_BLOCK MESSAGE_8_Block

	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		IN5 :	BOOL;
		IN6 :	BOOL;
		IN7 :	BOOL;
		IN8 :	BOOL;
		S1 :	STRING;
		S2 :	STRING;
		S3 :	STRING;
		S4 :	STRING;
		S5 :	STRING;
		S6 :	STRING;
		S7 :	STRING;
		S8 :	STRING;
	END_VAR


	VAR_OUTPUT
		M :	STRING;
	END_VAR

	IF in1 THEN
		M := S1;
	ELSIF in2 THEN
		M := S2;
	ELSIF in3 THEN
		M := S3;
	ELSIF in4 THEN
		M := S4;
	ELSIF in5 THEN
		M := S5;
	ELSIF in6 THEN
		M := S6;
	ELSIF in7 THEN
		M := S7;
	ELSIF in8 THEN
		M := S8;
	ELSE
		M := '';
	END_IF;

END_FUNCTION_BLOCK


PROGRAM program0

	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		IN5 :	BOOL;
		IN6 :	BOOL;
		IN7 :	BOOL;
		IN8 :	BOOL;
		S1 :	STRING;
		S2 :	STRING;
		S3 :	STRING;
		S4 :	STRING;
		S5 :	STRING;
		S6 :	STRING;
		S7 :	STRING;
		S8 :	STRING;

		M :	STRING;

		func_block : MESSAGE_8_Block;
	END_VAR

	func_block.IN1 := IN1;
	func_block.IN2 := IN2;
	func_block.IN3 := IN3;
	func_block.IN4 := IN4;
	func_block.IN5 := IN5;
	func_block.IN6 := IN6;
	func_block.IN7 := IN7;
	func_block.IN8 := IN8;
	func_block.S1 := S1;
	func_block.S2 := S2;
	func_block.S3 := S3;
	func_block.S4 := S4;
	func_block.S5 := S5;
	func_block.S6 := S6;
	func_block.S7 := S7;
	func_block.S8 := S8;

	func_block();

	M  := func_block.M;

END_PROGRAM

CONFIGURATION Config0

	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION