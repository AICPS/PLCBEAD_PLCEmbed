FUNCTION_BLOCK MD5_CRAM_AUTH

	VAR_IN_OUT
		RUN :	BOOL;
		USERNAME :	oscat_STRING64;
		PASSWORD :	oscat_STRING64;
		B64_TS :	oscat_STRING64;
		AUTH_KEY :	oscat_STRING192;
	END_VAR


	VAR
		BASE64_DECODE_STR :	BASE64_DECODE_STR;
		BASE64_ENCODE_STR :	BASE64_ENCODE_STR;
		MD5_STREAM :	MD5_STREAM;
		step :	INT;
		md5_mode :	INT;
		buf :	oscat_aB0_63;
		md5 :	oscat_aB0_15;
		md5_first :	oscat_aB0_15;
		md5_str1 :	oscat_STRING64;
		md5_str2 :	oscat_STRING64;
		size :	UDINT;
		n1 :	INT;
		n2 :	INT;
		pos :	UDINT;
		b64d_run :	BOOL;
		b64d_done :	BOOL;
		b64e_run :	BOOL;
		b64e_done :	BOOL;
		str_192 :	oscat_STRING192;
		str_144 :	oscat_STRING144;
		xpad :	BYTE;
		CODE :	CODE;
		MD5_TO_STRH :	MD5_TO_STRH;
	END_VAR

	CASE step OF

	0:	IF RUN THEN
			step := 5;
			str_192 := B64_TS;
			b64d_run := TRUE;
		END_IF;

	5: IF B64D_DONE THEN 
			b64d_run := FALSE;
			xpad := BYTE#16#36;
			md5_str1 := PASSWORD;
			md5_str2 := str_144;
			size := INT_TO_UDINT(64 + LEN(md5_str2));
			md5_mode := 1;
			step := 10;
		END_IF;

	10: IF md5_mode = 3 THEN
			md5_first := md5; 
			xpad := BYTE#16#5C;
			size := INT_TO_UDINT(64 + 16);
			md5_mode := 1;
			step := 20;
		END_IF;

	20: IF md5_mode = 3 THEN
			md5_mode := 0;
			MD5_TO_STRH(MD5:=md5);
			str_144 := CONCAT(USERNAME , ' ');
			str_144 := CONCAT(str_144 , MD5_TO_STRH.MD5_TO_STRH);
			b64e_run := TRUE;
			step := 30;
		END_IF;

	30: IF B64E_DONE THEN
			AUTH_KEY := str_192;
			b64e_run := FALSE;
			RUN := FALSE;
			step := 0;
		END_IF;

	END_CASE;

	CASE md5_mode OF

	1:	n2 := LEN(md5_str1) - 1;
		FOR n1 := 0 TO n2 DO 
			CODE(STR:=md5_str1,POS:=n1+1);
			buf[n1] := CODE.CODE XOR xpad;
		END_FOR;
		FOR n1 := n2 + 1 TO 63 DO
			buf[n1] := xpad;
		END_FOR;

	2:	
		IF size > UDINT#0 AND pos >= UDINT#64 THEN
			IF step = 20 THEN
				FOR n1 := 0 TO 15 DO
					buf[n1] := md5_first[n1];
				END_FOR;
			ELSE
				n2 := LEN(md5_str2) - 1;
				FOR n1 := 0 TO n2 DO 
					CODE(STR:=md5_str2,POS:=n1+1);
					buf[n1] := CODE.CODE;
				END_FOR;
			END_IF;
		END_IF;

	END_CASE;

	IF md5_mode > 0 THEN
		MD5_STREAM.MODE := md5_mode;
		MD5_STREAM.BUF 	:= buf;
		MD5_STREAM.MD5 	:= md5;
		MD5_STREAM.SIZE := size;
		MD5_STREAM();
		md5_mode := MD5_STREAM.MODE;
		buf 	 := MD5_STREAM.BUF;
		md5 	 := MD5_STREAM.MD5;
		size 	 := MD5_STREAM.SIZE;
		pos 	 := MD5_STREAM.POS;
	END_IF;

	BASE64_DECODE_STR.RUN  := b64d_run;
	BASE64_DECODE_STR.STR1 := str_192;
	BASE64_DECODE_STR.STR2 := str_144;
	BASE64_DECODE_STR();
	b64d_done	:= BASE64_DECODE_STR.DONE;
	str_192		:= BASE64_DECODE_STR.STR1;
	str_144		:= BASE64_DECODE_STR.STR2;

	BASE64_ENCODE_STR.RUN  := b64e_run;
	BASE64_ENCODE_STR.STR1 := str_144;
	BASE64_ENCODE_STR.STR2 := str_192;
	BASE64_ENCODE_STR();
	b64e_done	:= BASE64_ENCODE_STR.DONE;
	str_144		:= BASE64_ENCODE_STR.STR1;
	str_192		:= BASE64_ENCODE_STR.STR2;

END_FUNCTION_BLOCK
