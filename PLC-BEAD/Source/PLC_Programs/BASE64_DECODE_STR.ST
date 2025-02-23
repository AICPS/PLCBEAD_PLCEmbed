TYPE
  oscat_aB0_47	: ARRAY [0..47]	OF BYTE;
  oscat_aB0_63	: ARRAY [0..63]	OF BYTE;
END_TYPE

FUNCTION_BLOCK BASE64_DECODE_STREAM
	VAR_IN_OUT
		BUF1 :	oscat_aB0_63;
		BUF2 :	oscat_aB0_47;
	END_VAR

	VAR_INPUT
		SIZE1 :	INT;
	END_VAR

	VAR_OUTPUT
		SIZE2 :	INT;
	END_VAR

	VAR
		a :	INT;
		b :	WORD;
		o :	INT;
		off :	INT;
		i1 :	INT;
		i2 :	INT;
		c :	INT;
	END_VAR

	IF SIZE1 <= 0 THEN SIZE2 := 0; RETURN; END_IF;
	c := SIZE1 - 1;
	i2 := 0;
	a := 0;
	b := WORD#0;
	FOR i1 := 0 TO c DO
		o := BYTE_TO_INT(BUF1[i1]);
		IF o = 61  (* = *) THEN EXIT;
		ELSIF o > 96 (* a-z *) THEN off := 71;
		ELSIF o > 64 (* A-Z *) THEN off := 65;
		ELSIF o > 47 (* 0-9 *) THEN off := -4;
		ELSIF o = 43 (* + *) THEN off := -19;
		ELSIF o = 47 (* / *) THEN off := -16;
		END_IF;
		b := SHL(b,6) OR INT_TO_WORD(o - off);
		a := a + 6;
		IF a >= 8 THEN
			a := a - 8;
			BUF2[i2] := WORD_TO_BYTE(SHR(b,a));
			i2 := i2 + 1;
			b := b AND NOT SHL(WORD#16#FFFF,a);
		END_IF;
	END_FOR;
	SIZE2 := i2;
END_FUNCTION_BLOCK

FUNCTION_BLOCK BASE64_DECODE_STR
	VAR_INPUT
		RUN :	BOOL;
	END_VAR

	VAR_OUTPUT
		DONE :	BOOL;
	END_VAR

	VAR_IN_OUT
		STR1 :	STRING;
		STR2 :	STRING;
	END_VAR

	VAR
		BASE64_DECODE_STREAM :	BASE64_DECODE_STREAM;
		run_last :	BOOL;
		buf1 :	oscat_aB0_63;
		buf2 :	oscat_aB0_47;
		mode :	INT;
		size1 :	INT;
		size2 :	INT;
		end :	INT;
		pos :	INT;
		i1 :	INT;
		i2 :	INT;
		i3 :	INT;
		STRx :	STRING;
		BTS :	BUF_TO_STRING;
	END_VAR


	(*@KEY@: WORKSHEET
	NAME: BASE64_DECODE_STR
	IEC_LANGUAGE: ST
	*)

	CASE mode OF
	0:	IF RUN AND NOT run_last THEN
			DONE := FALSE;
			mode := 1;
			end := LEN(STR1);
			pos := 0;
			STR2 := '';
		END_IF;
	1:
		SIZE1 := MIN(48,end - pos);
		IF SIZE1 > 0 THEN

			i2 := SIZE1 - 1;
			i3 := pos + 1;
			FOR i1 := 0 TO i2 DO
				buf1[i1] := INT_TO_BYTE(GET_CHAR(STR1,i3));
				i3 := i3 + 1;
			END_FOR;

			BASE64_DECODE_STREAM(BUF1:=BUF1 ,BUF2:=BUF2 ,SIZE1:=SIZE1);
			buf1  :=BASE64_DECODE_STREAM.BUF1;
			buf2  :=BASE64_DECODE_STREAM.BUF2;
			SIZE2 :=BASE64_DECODE_STREAM.SIZE2;

			FOR i1 := 0 TO 1 DO
				BTS.REQ := i1 > 0;
				BTS.BUF_FORMAT := TRUE;
				BTS.BUF_OFFS := DINT#0;
				BTS.BUF_CNT := INT_TO_DINT(SIZE2);
				BTS.BUFFER := buf2;
				BTS.DST := STRx;
				BTS();
				buf2 := BTS.BUFFER;
				STRx := BTS.DST;
			END_FOR;
			STR2 := CONCAT(STR2,STRx);
		ELSE
			mode := 0;
			DONE := TRUE;
		END_IF;
		pos := pos + size1;
	END_CASE;

	run_last := RUN;

END_FUNCTION_BLOCK
