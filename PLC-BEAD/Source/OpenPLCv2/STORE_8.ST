FUNCTION_BLOCK STORE_8_Block

	VAR_INPUT
		SET :	BOOL;
		D0 :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;
		D3 :	BOOL;
		D4 :	BOOL;
		D5 :	BOOL;
		D6 :	BOOL;
		D7 :	BOOL;
		CLR :	BOOL;
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
		edge :	BOOL;
	END_VAR


	IF rst OR set THEN
		q0 := NOT rst;
		q1 := q0;
		q2 := q0;
		q3 := q0;
		q4 := q0;
		q5 := q0;
		q6 := q0;
		q7 := q0;
	ELSE
		IF D0 THEN Q0 := TRUE; END_IF;
		IF D1 THEN Q1 := TRUE; END_IF;
		IF D2 THEN Q2 := TRUE; END_IF;
		IF D3 THEN Q3 := TRUE; END_IF;
		IF D4 THEN Q4 := TRUE; END_IF;
		IF D5 THEN Q5 := TRUE; END_IF;
		IF D6 THEN Q6 := TRUE; END_IF;
		IF D7 THEN Q7 := TRUE; END_IF;

		IF clr AND NOT edge THEN
			IF q0 THEN q0 := FALSE;
			ELSIF q1 THEN q1 := FALSE;
			ELSIF q2 THEN q2 := FALSE;
			ELSIF q3 THEN q3 := FALSE;
			ELSIF q4 THEN q4 := FALSE;
			ELSIF q5 THEN q5 := FALSE;
			ELSIF q6 THEN q6 := FALSE;
			ELSE q7 := FALSE;
			END_IF;
		END_IF;
		edge := clr;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		SET :	BOOL;
		D0 :	BOOL;
		D1 :	BOOL;
		D2 :	BOOL;
		D3 :	BOOL;
		D4 :	BOOL;
		D5 :	BOOL;
		D6 :	BOOL;
		D7 :	BOOL;
		CLR :	BOOL;
		RST :	BOOL;
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		Q4 :	BOOL;
		Q5 :	BOOL;
		Q6 :	BOOL;
		Q7 :	BOOL;
		func_block : STORE_8_Block;
	END_VAR
	func_block.SET  := SET;
	func_block.D0  := D0;
	func_block.D1  := D1;
	func_block.D2  := D2;
	func_block.D3  := D3;
	func_block.D4  := D4;
	func_block.D5  := D5;
	func_block.D6  := D6;
	func_block.D7  := D7;
	func_block.CLR  := CLR;
	func_block.RST  := RST;
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