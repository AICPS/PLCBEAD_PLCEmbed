FUNCTION_BLOCK URL_ENCODE_Block

	VAR_INPUT
		IN :	oscat_STRING250;
	END_VAR


	VAR_OUTPUT
		URL_ENCODE :	oscat_STRING250;
	END_VAR


	VAR
		pos_in :	INT;
		pos_out :	INT;
		stop :	INT;
		tb :	BYTE;
		pt_out :	oscat_aB1_255;
		char :	BYTE;
		BUF_TO_STRING :	BUF_TO_STRING;
		i :	INT;
	END_VAR

	pos_in := 1;
	stop := LEN(in);
	FOR pos_out := 1 TO 250 DO
		char := INT_TO_BYTE(GET_CHAR(IN,pos_in));
		IF pos_in > stop THEN
			EXIT;
		ELSIF IS_URLCHR(char) THEN
			pt_out[pos_out] := char;
			pos_in := pos_in + 1;
		ELSE
			IF pos_out > 248 THEN EXIT; END_IF;
			pt_out[pos_out] := BYTE#37;    
			pos_out := pos_out + 1;
			tb := SHR_BYTE(char,4);
			IF tb > BYTE#9 THEN
				pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#55);
			ELSE
				pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#48);
			END_IF;
			pos_out := pos_out + 1;
			tb := char AND BYTE#16#0F;
			IF tb > BYTE#9 THEN
				pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#55);
			ELSE
				pt_out[pos_out] := USINT_TO_BYTE(BYTE_TO_USINT(tb) + USINT#48);
			END_IF;
			pos_in := pos_in + 1;
		END_IF;
	END_FOR;

	pos_out := pos_out - 1;

	FOR i := 0 TO 1 DO
	BUF_TO_STRING.REQ        := i>0;
	BUF_TO_STRING.BUF_FORMAT := TRUE;
	BUF_TO_STRING.BUF_OFFS   := DINT#0;
	BUF_TO_STRING.BUF_CNT    := INT_TO_DINT(pos_out);
	BUF_TO_STRING.BUFFER     := pt_out;
	BUF_TO_STRING.DST        := URL_ENCODE;
	BUF_TO_STRING();
	pt_out  := BUF_TO_STRING.BUFFER;
	URL_ENCODE := BUF_TO_STRING.DST;
	END_FOR;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN :	oscat_STRING250;
		URL_ENCODE :	oscat_STRING250;

		func_block : URL_ENCODE_Block;
	END_VAR
	func_block.IN := IN;

	func_block();
	URL_ENCODE  := func_block.URL_ENCODE;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION