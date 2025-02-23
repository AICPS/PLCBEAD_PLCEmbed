FUNCTION_BLOCK RC4_CRYPT_STREAM

	VAR_IN_OUT
		MODE :	INT;
		KEY :	oscat_STRING40;
		BUF :	oscat_aB0_63;
		SIZE :	UDINT;
	END_VAR


	VAR_OUTPUT
		POS :	UDINT;
	END_VAR


	VAR
		sbox :	oscat_aB0_255;
		skey :	oscat_aB0_255;
		a :	INT;
		b :	INT;
		c :	INT;
		d :	USINT;
		e :	USINT;
		end :	UDINT;
		v :	BYTE;
		v_tmp :	INT;
		CODE :	CODE;
	END_VAR

	CASE MODE OF

	1:	
		b := LEN(KEY) - 1;
		IF b < 0 OR SIZE < UDINT#1 THEN
			MODE := 3;
			RETURN;
		END_IF;

		FOR a := 0 TO b DO
			CODE(STR:=KEY,POS:=a + 1);
			skey[a] := CODE.CODE;
			sbox[a] := INT_TO_BYTE(a);
		END_FOR;

		c := 0;
		FOR a := b + 1 TO 255 DO
			skey[a] := skey[c];
			sbox[a] := INT_TO_BYTE(a);
			c := c + 1;
			IF c > b THEN c := 0; END_IF;
		END_FOR;

		d := USINT#0;
		FOR a := 0 TO 255 DO
			d := d + BYTE_TO_USINT(sbox[a]) + BYTE_TO_USINT(skey[a]);
			v := sbox[a];
			sbox[a] := sbox[d];
			sbox[d] := v;
		END_FOR;

		POS := UDINT#0;
		end := SIZE;
		SIZE := MIN(UDINT#64,end);
		d := USINT#0;
		e := USINT#0;
		MODE := 2;

	2:	

		b := UDINT_TO_INT(SIZE) - 1;
		FOR a := 0 TO b DO
			d := d + USINT#1;
			e := e + BYTE_TO_USINT(sbox[d]);
			v := sbox[d];
			sbox[d] := sbox[e];
			sbox[e] := v;
			v := USINT_TO_BYTE(BYTE_TO_USINT(sbox[d]) + BYTE_TO_USINT(sbox[e]));
			v_tmp := _BYTE_TO_INT(v);
			BUF[a] :=BUF[a] XOR sbox[v_tmp];
		END_FOR;

		POS := POS + SIZE;
		SIZE := MIN(UDINT#64,end - POS);

		IF SIZE = UDINT#0 THEN
			MODE := 3;
		END_IF;
	END_CASE;

END_FUNCTION_BLOCK
