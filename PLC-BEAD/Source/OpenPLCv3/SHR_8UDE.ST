FUNCTION_BLOCK SHR_8UDE_Block

	VAR_INPUT
		SET :	BOOL;
		D0 :	BOOL;
		D7 :	BOOL;
		CLK :	BOOL;
		DN :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
	END_VAR

	VAR
		trig :	R_TRIG;
	END_VAR

	trig(clk := clk);

	IF set OR rst THEN
		Q0 := NOT RST;
		Q1 := Q0;
		Q2 := Q0;
		Q3 := Q0;
		Q4 := Q0;
		Q5 := Q0;
		Q6 := Q0;
		Q7 := Q0;
	ELSIF trig.Q THEN
		IF dn THEN
			Q0 := Q1;
			Q1 := Q2;
			Q2 := Q3;
			Q3 := Q4;
			Q4 := Q5;
			Q5 := Q6;
			Q6 := Q7;
			Q7 := D7;
		ELSE
			Q7 := Q6;
			Q6 := Q5;
			Q5 := Q4;
			Q4 := Q3;
			Q3 := Q2;
			Q2 := Q1;
			Q1 := Q0;
			Q0 := D0;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		SET :	BOOL;
		D0 :	BOOL;
		D7 :	BOOL;
		CLK :	BOOL;
		DN :	BOOL;
		RST :	BOOL;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
		func_block : SHR_8UDE_Block;
  	END_VAR
	func_block.SET  :=SET;
	func_block.D0  :=D0;
	func_block.D7  :=D7;
	func_block.CLK  :=CLK;
	func_block.DN  :=DN;
	func_block.RST  :=RST;
	func_block();
	Q0  := func_block.Q0;
	Q1  := func_block.Q1;
	Q2  := func_block.Q2;
	Q3  := func_block.Q3;
	Q4  := func_block.Q4;
	Q5  := func_block.Q5;
	Q6  := func_block.Q6;
	Q7  := func_block.Q7;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION