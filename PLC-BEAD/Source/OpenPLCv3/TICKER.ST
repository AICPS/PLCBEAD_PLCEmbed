TYPE
	oscat_delay_buf             : ARRAY [0..31]   OF REAL;
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


FUNCTION_BLOCK DELAY

	VAR_INPUT
		IN :	REAL;
		N :	INT;
		RST :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT :	REAL;
	END_VAR


	VAR
		buf :	oscat_delay_buf;
		i :	INT;
		init :	BOOL;
		stop :	INT;
	END_VAR

	stop := LIMIT(0,N,32) - 1;
	IF rst OR NOT init THEN
		init := TRUE;
		FOR i := 0 TO stop DO buf[i] := in; END_FOR;
		out := in;
		i := 0;
	ELSIF stop < 0 THEN
		out := in;
	ELSE
		out := buf[i];
		buf[i] := in;
		i := INC1(i, N);
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK TICKER

	VAR_INPUT
		N :	INT;
		PT :	TIME;
		TEXT :	STRING;
	END_VAR


	VAR_OUTPUT
		DISPLAY :	STRING;
	END_VAR


	VAR
		_delay :	TP;
		rollout :	STRING;
		text_len :	INT;
		rollout_step :	INT;
		_step :	INT;
	END_VAR

	text_len := LEN(text);

	IF N < text_len THEN
		IF NOT _delay.Q THEN

			IF _step > text_len THEN
				rollout_step := 0;
				rollout := '';
				_step := 0;
			END_IF;

			IF _step + N > text_len THEN
				_step := _step + 1;
				rollout_step := rollout_step +1;
				display := MID(text, N - rollout_step, _step);
				rollout := CONCAT(rollout,'#'); 
				display := CONCAT(display,rollout);
			ELSE
				_step := _step + 1;
				display := MID(text, N, _step);
			END_IF;
			_delay(TRUE, PT);
		ELSE
			_delay(FALSE);
		END_IF;
	ELSE
		display := text;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		N :	INT;
		PT :	TIME;
		TEXT :	STRING;
		DISPLAY :	STRING;
		func_block : TICKER;
  	END_VAR
	func_block.N  :=N;
	func_block.PT  :=PT;
	func_block.TEXT  :=TEXT;
	func_block();
	DISPLAY := func_block.DISPLAY;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION