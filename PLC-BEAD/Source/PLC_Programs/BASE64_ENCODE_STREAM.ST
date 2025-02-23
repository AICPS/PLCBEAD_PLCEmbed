TYPE
  oscat_aB0_47	: ARRAY [0..47]	OF BYTE;
  oscat_aB0_63	: ARRAY [0..63]	OF BYTE;
END_TYPE

FUNCTION_BLOCK BASE64_ENCODE_STREAM

	VAR_IN_OUT
		BUF1 :	oscat_aB0_47;
		BUF2 :	oscat_aB0_63;
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
		i :	INT;
		i2 :	INT;
		i3 :	INT;
		c :	INT;
		BASE64 :	STRING := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
	END_VAR

	IF SIZE1 <= 0 THEN
		SIZE2 := 0;
		RETURN;
	END_IF;
	c := SIZE1 - 1;
	i2 := 0;
	a := 0;
	b := WORD#0;
	FOR i := 0 TO c DO
		b := SHL(b,8) OR BYTE_TO_WORD(BUF1[i]);
		a := a + 8;
		WHILE a >= 6 DO
			a := a - 6;
			buf2[i2] := INT_TO_BYTE(GET_CHAR(BASE64,WORD_TO_INT(SHR(b,a)) + 1));
			i2 := i2 + 1;
			b := b AND NOT SHL(WORD#16#FFFF,a);
		END_WHILE;
	END_FOR;
	IF a > 0 THEN
		buf2[i2] := INT_TO_BYTE(GET_CHAR(BASE64,WORD_TO_INT(SHL(b,6 - a)) + 1));
		i2 := i2 + 1;
		i3 := i2 + WORD_TO_INT(NOT INT_TO_WORD(i2) AND WORD#2#11);
		FOR i := i2 TO i3 DO
			buf2[i] := BYTE#61;
		END_FOR;
		SIZE2 := i3 + 1;
	ELSE
		SIZE2 := i2;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
  VAR
	BUF1  :	oscat_aB0_63;
	BUF2  :	oscat_aB0_47;

	SIZE1 :	INT;

	SIZE2 :	INT;
	func_block : BASE64_ENCODE_STREAM;
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