FUNCTION_BLOCK SHR_4UDE_Block

	VAR_INPUT
		SET :	BOOL;
		D0 :	BOOL;
		D3 :	BOOL;
		CLK :	BOOL;
		DN :	BOOL;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
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
	ELSIF trig.Q THEN
		IF dn THEN
			Q0 := Q1;
			Q1 := Q2;
			Q2 := Q3;
			Q3 := D3;
		ELSE
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
		D3 :	BOOL;
		CLK :	BOOL;
		DN :	BOOL;
		RST :	BOOL;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		func_block : SHR_4UDE_Block;
	END_VAR
	func_block.SET  :=SET;
	func_block.D0  :=D0;
	func_block.D3  :=D3;
	func_block.CLK  :=CLK;
	func_block.DN  :=DN;
	func_block.RST  :=RST;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION