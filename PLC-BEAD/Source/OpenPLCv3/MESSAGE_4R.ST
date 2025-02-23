FUNCTION INC1:INT

	VAR_INPUT
		X :	INT;
		N :	INT;
	END_VAR

	IF X >= N - 1 THEN
		INC1 := 0;
	ELSE
		INC1 := X + 1;
	END_IF;
END_FUNCTION

FUNCTION_BLOCK MESSAGE_4R_Block

	VAR_INPUT
		M0 :	STRING;
		M1 :	STRING;
		M2 :	STRING;
		M3 :	STRING;
		MM :	INT := 3;
		ENQ :	BOOL := TRUE;
		CLK :	BOOL := TRUE;
		T1 :	TIME := T#3s;
	END_VAR


	VAR_OUTPUT
		MX :	STRING;
		MN :	INT;
		TR :	BOOL;
	END_VAR


	VAR
		timer :	TON;
		edge :	BOOL;
	END_VAR

	TR := FALSE;
	IF ENQ THEN
		IF (NOT edge AND clk) OR timer.q THEN
				MN := INC1(MN, MM);
				TR := TRUE;
				timer(in := FALSE);
				CASE MN OF
					0 : MX := M0;
					1 : MX := M1;
					2 : MX := M2;
					3 : MX := M3;
				END_CASE;
		END_IF;
		edge := clk;
		timer( in := CLK, pt := T1);
	ELSE
		MX := '';
		MN := 0;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0

	VAR
		M0 :	STRING;
		M1 :	STRING;
		M2 :	STRING;
		M3 :	STRING;
		MM :	INT;
		ENQ :	BOOL;
		CLK :	BOOL;
		T1 :	TIME;

		MX :	STRING;
		MN :	INT;
		TR :	BOOL;

		func_block : MESSAGE_4R_Block;
	END_VAR

	func_block.M0 := M0;
	func_block.M1 := M1;
	func_block.M2 := M2;
	func_block.M3 := M3;
	func_block.MM := MM;
	func_block.ENQ := ENQ;
	func_block.CLK := CLK;
	func_block.T1 := T1;

	func_block();

	MX := func_block.MX;
	MN := func_block.MN;
	TR := func_block.TR;

END_PROGRAM

CONFIGURATION Config0
	
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE

END_CONFIGURATION
