TYPE
	oscat_DELAY_buf             : ARRAY [0..31]   OF REAL;
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
		buf :	oscat_DELAY_buf;
		i :	INT;
		init :	BOOL;
		STOP :	INT;
	END_VAR

	STOP := LIMIT(0,N,32) - 1;
	IF RST OR NOT init THEN
		init := TRUE;
		FOR i := 0 TO STOP DO buf[i] := IN; END_FOR;
		OUT := IN;
		i := 0;
	ELSIF STOP < 0 THEN
		OUT := IN;
	ELSE
		OUT := buf[i];
		buf[i] := IN;
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
		_DELAY :	TP;
		rollOUT :	STRING;
		text_len :	INT;
		rollOUT_STEP :	INT;
		_STEP :	INT;
	END_VAR

	text_len := LEN(text);

	IF N < text_len THEN
		IF NOT _DELAY.Q THEN

			IF _STEP > text_len THEN
				rollOUT_STEP := 0;
				rollOUT := '';
				_STEP := 0;
			END_IF;

			IF _STEP + N > text_len THEN
				_STEP := _STEP + 1;
				rollOUT_STEP := rollOUT_STEP +1;
				display := MID(text, N - rollOUT_STEP, _STEP);
				rollOUT := CONCAT(rollOUT,'#'); 
				display := CONCAT(display,rollOUT);
			ELSE
				_STEP := _STEP + 1;
				display := MID(text, N, _STEP);
			END_IF;
			_DELAY(TRUE, PT);
		ELSE
			_DELAY(FALSE);
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

