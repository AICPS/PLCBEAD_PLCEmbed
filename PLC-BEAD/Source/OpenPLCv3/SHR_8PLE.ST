FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION BIT_LOAD_B:BYTE
	VAR_INPUT
		IN :	BYTE;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_B := in OR SHL(BYTE#1,pos);
	ELSE
		BIT_LOAD_B := in AND (NOT SHL(BYTE#1,pos));
	END_IF;
END_FUNCTION

FUNCTION_BLOCK SHR_8PLE_Block

	VAR_INPUT
		DIN :	BOOL;
		DLOAD :	BYTE;
		CLK :	BOOL;
		UP :	BOOL := TRUE;
		LOAD :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		DOUT :	BOOL;
	END_VAR

	VAR
		edge :	BOOL := TRUE;
		register :	BYTE;
	END_VAR


	IF CLK AND edge AND NOT rst THEN
		edge := FALSE;
		IF UP THEN
			register := SHL(register,1);
			register := BIT_LOAD_B(register,Din,0);
			Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),7); 
		ELSE
			register := SHR(register,1);
			register := BIT_LOAD_B(register,Din,7); 
			Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),0);
		END_IF;
		IF load THEN
			register := Dload;
			IF up THEN
				Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),7);
			ELSE
				Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),0);
			END_IF;
		END_IF;
	END_IF;
	IF NOT clk THEN edge := TRUE; END_IF;
	IF rst THEN
		register := BYTE#0;
		Dout := FALSE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  	VAR
		DIN :	BOOL;
		DLOAD :	BYTE;
		CLK :	BOOL;
		UP :	BOOL := TRUE;
		LOAD :	BOOL;
		RST :	BOOL;
		DOUT :	BOOL;
		func_block : SHR_8PLE_Block;
	END_VAR
	func_block.DIN  :=DIN;
	func_block.DLOAD  :=DLOAD;
	func_block.CLK  :=CLK;
	func_block.UP  :=UP;
	func_block.LOAD  :=LOAD;
	func_block.RST  :=RST;
	func_block();
	DOUT := func_block.DOUT;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION