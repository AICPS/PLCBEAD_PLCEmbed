FUNCTION_BLOCK MD5_STR

	VAR_INPUT
		RUN :	BOOL;
	END_VAR


	VAR_OUTPUT
		DONE :	BOOL;
	END_VAR


	VAR_IN_OUT
		STR :	oscat_STRING250;
		MD5 :	oscat_aB0_15;
	END_VAR


	VAR
		run_last :	BOOL;
		buf :	oscat_aB0_63;
		mode :	INT;
		size :	UDINT;
		pos :	UDINT;
		i :	INT;
		i2 :	INT;
		MD5_STREAM :	MD5_STREAM;
		CODE :	CODE;
	END_VAR

	CASE mode OF
	0:	
		IF RUN AND NOT run_last THEN
			DONE := FALSE;
			mode := 1;
			size := INT_TO_UDINT(LEN(STR));
		END_IF;

	2:	
		IF size > UDINT#0 THEN
			i2 := 0;
			FOR i := 1 TO UDINT_TO_INT(SIZE) DO
				CODE(STR:=MID(STR,1,UDINT_TO_INT(POS) + i),POS:=1);
				buf[i2] := CODE.CODE;
				i2 := i2 + 1;
			END_FOR;
		END_IF;

	3:	DONE := TRUE;
		mode := 0; 

	END_CASE;

	IF mode > 0 THEN
		MD5_STREAM(SIZE:=size, MODE:=mode, BUF:=buf, MD5:=MD5);
		mode := MD5_STREAM.MODE;
		buf := MD5_STREAM.BUF;
		MD5 := MD5_STREAM.MD5;
		size := MD5_STREAM.SIZE;
		pos := MD5_STREAM.POS;
	END_IF;

	run_last := RUN;

END_FUNCTION_BLOCK
