FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION INC:INT
	VAR_INPUT
		X :	INT;
		D :	INT;
		M :	INT;
	END_VAR

	inc := (X + D + M + 1) MOD (M + 1);
END_FUNCTION

FUNCTION_BLOCK SELECT_8_Block

	VAR_INPUT
		E :	BOOL;
		SET :	BOOL;
		IN :	BYTE;
		UP :	BOOL;
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
		STATE :	INT;
	END_VAR

	VAR
		last_up :	BOOL;
		last_dn :	BOOL;
	END_VAR

	IF rst THEN
		state := 0;
	ELSIF set THEN
		state := _BYTE_TO_INT(IN);
	ELSIF up AND NOT last_up THEN
		state := inc(state,1,7);
	ELSIF dn AND NOT last_dn THEN
		state := inc(state,-1,7);
	END_IF;
	last_UP := UP;
	last_DN := DN;

	Q0 := FALSE;
	Q1 := FALSE;
	Q2 := FALSE;
	Q3 := FALSE;
	Q4 := FALSE;
	Q5 := FALSE;
	Q6 := FALSE;
	Q7 := FALSE;

	IF e THEN
		CASE state OF
			0: Q0 := TRUE;
			1: Q1 := TRUE;
			2: Q2 := TRUE;
			3: Q3 := TRUE;
			4: Q4 := TRUE;
			5: Q5 := TRUE;
			6: Q6 := TRUE;
			7: Q7 := TRUE;
		END_CASE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		E :	BOOL;
		SET :	BOOL;
		IN :	BYTE;
		UP :	BOOL;
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
		STATE :	INT;
		func_block : SELECT_8_Block;
  	END_VAR
	func_block.E  :=E;
	func_block.SET  :=SET;
	func_block.IN  :=IN;
	func_block.UP  :=UP;
	func_block.DN  :=DN;
	func_block.RST  :=RST;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
	Q4 := func_block.Q4;
	Q5 := func_block.Q5;
	Q6 := func_block.Q6;
	Q7 := func_block.Q7;
	STATE := func_block.STATE;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION