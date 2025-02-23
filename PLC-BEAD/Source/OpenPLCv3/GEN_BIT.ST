FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION

FUNCTION_BLOCK GEN_BIT_Block

	VAR_INPUT
		IN0 :	DWORD;
		IN1 :	DWORD;
		IN2 :	DWORD;
		IN3 :	DWORD;
		CLK :	BOOL;
		STEPS :	INT;
		REP :	INT;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		Q0 :	BOOL;
		Q1 :	BOOL;
		Q2 :	BOOL;
		Q3 :	BOOL;
		CNT :	INT;
		RUN :	BOOL;
	END_VAR


	VAR
		r0 :	DWORD;
		r1 :	DWORD;
		r2 :	DWORD;
		r3 :	DWORD;
		rx :	INT := 1;
	END_VAR

	IF clk AND NOT rst THEN
		run := (rep = 0) OR (rx <= rep);
		IF run THEN
			IF cnt = steps THEN
				cnt := 0;
			END_IF;

			IF cnt = 0 THEN
				r0 := in0;
				r1 := in1;
				r2 := in2;
				r3 := in3;
			END_IF;

			IF (cnt < steps) THEN
				Q0 := BIT_OF_DWORD(r0,0);
				Q1 := BIT_OF_DWORD(r1,0);
				Q2 := BIT_OF_DWORD(r2,0); 
				Q3 := BIT_OF_DWORD(r3,0); 
				r0 := SHR(r0,1);
				r1 := SHR(r1,1);
				r2 := SHR(r2,1);
				r3 := SHR(r3,1);
			END_IF;

			cnt := cnt +1;
			IF (cnt = steps) AND (rep <> 0) THEN rx := rx +1; END_IF;
			IF (rx > rep) AND (rep <> 0) THEN run := FALSE; END_IF;
		END_IF;
	ELSE
		IF rst THEN
			run := FALSE;
			Q0 := FALSE;
			Q1 := FALSE;
			Q2 := FALSE;
			Q3 := FALSE;
			r0 := DWORD#0;
			r1 := DWORD#0;
			r2 := DWORD#0;
			r3 := DWORD#0;
			cnt := 0;
			rx := 1;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	IN0 :	DWORD;
	IN1 :	DWORD;
	IN2 :	DWORD;
	IN3 :	DWORD;
	CLK :	BOOL;
	STEPS :	INT;
	REP :	INT;
	RST :	BOOL;
	Q0 :	BOOL;
	Q1 :	BOOL;
	Q2 :	BOOL;
	Q3 :	BOOL;
	CNT :	INT;
	RUN :	BOOL;
	func_block : GEN_BIT_Block;
  END_VAR
	func_block.IN0  :=IN0;
	func_block.IN1  :=IN1;
	func_block.IN2  :=IN2;
	func_block.IN3  :=IN3;
	func_block.CLK  :=CLK;
	func_block.STEPS  :=STEPS;
	func_block.REP  :=REP;
	func_block.RST  :=RST;
	func_block();
	Q0 := func_block.Q0;
	Q1 := func_block.Q1;
	Q2 := func_block.Q2;
	Q3 := func_block.Q3;
	CNT := func_block.CNT;
	RUN := func_block.RUN;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION
