TYPE
	oscat_ardw_0_15             : ARRAY [0..15]   OF DWORD;
END_TYPE

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

FUNCTION_BLOCK FIFO_16
	VAR_INPUT
		DIN :	DWORD;
		E :	BOOL := TRUE;
		RD :	BOOL;
		WD :	BOOL;
		RST :	BOOL;
	END_VAR

	VAR_OUTPUT
		DOUT :	DWORD;
		EMPTY :	BOOL := TRUE;
		FULL :	BOOL;
	END_VAR

	VAR
		fifo :	oscat_ardw_0_15;
		pr :	INT;
		pw :	INT;
	END_VAR

	IF RST THEN
		pw := pr;
		FULL := FALSE;
		EMPTY := TRUE;
		Dout := DWORD#0;
	ELSIF E THEN
		IF NOT EMPTY AND RD THEN
			Dout := fifo[pr];
			pr := INC1(pr,16);
			EMPTY := pr = pw;
			FULL := FALSE;
		END_IF;
		IF NOT FULL AND WD THEN
			fifo[pw] := Din;
			pw := INC1(pw,16);
			FULL := pw = pr;
			EMPTY := FALSE;
		END_IF;
	END_IF;
END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	DIN :	DWORD;
	E   :	BOOL;
	RD  :	BOOL;
	WD  :	BOOL;
	RST :	BOOL;

	DOUT  :	DWORD;
	EMPTY :	BOOL;
	FULL  :	BOOL;

	func_block : FIFO_16;
  END_VAR
	func_block.DIN :=DIN;
	func_block.E   :=E  ;
	func_block.RD  :=RD ;
	func_block.WD  :=WD ;
	func_block.RST :=RST;
	func_block();
	DOUT := func_block.DOUT ;
	EMPTY:= func_block.EMPTY;
	FULL := func_block.FULL ;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION