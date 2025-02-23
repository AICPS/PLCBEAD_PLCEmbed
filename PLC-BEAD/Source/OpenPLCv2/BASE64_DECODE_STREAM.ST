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

PROGRAM program0
  VAR
	BUF1  :	oscat_aB0_63;
	BUF2  :	oscat_aB0_47;

	SIZE1 :	INT;

	SIZE2 :	INT;
	func_block : BASE64_DECODE_STREAM;
  END_VAR
	func_block.BUF1 :=BUF1 ;
	func_block.BUF2 :=BUF2 ;
	func_block.SIZE1:=SIZE1;
	func_block();
	BUF1 := func_block.BUF1;
	BUF2 := func_block.BUF2;
	SIZE2 := func_block.SIZE2;
END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION