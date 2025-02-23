FUNCTION_BLOCK MD5_STREAM

	VAR_IN_OUT
		MODE :	INT;
		BUF :	oscat_aB0_63;
		MD5 :	oscat_aB0_15;
		SIZE :	UDINT;
	END_VAR


	VAR_OUTPUT
		POS :	UDINT;
	END_VAR


	VAR
		hash :	oscat_aDW0_3;
		a :	DWORD;
		b :	DWORD;
		c :	DWORD;
		d :	DWORD;
		end :	UDINT;
		block :	UDINT;
		x :	oscat_aDW0_15;
		pad_1 :	BOOL;
		n :	INT;
		n1 :	INT;
		n2 :	INT;
		n3 :	INT;
		n4 :	INT;
	END_VAR

	CASE MODE OF

	1:	
		hash[0] := DWORD#16#67452301;
		hash[1] := DWORD#16#EFCDAB89;
		hash[2] := DWORD#16#98BADCFE;
		hash[3] := DWORD#16#10325476;

		block := DWORD_TO_UDINT(SHR_DWORD(UDINT_TO_DWORD(SIZE),6)) + BOOL_TO_UDINT((UDINT_TO_BYTE(SIZE) AND BYTE#16#3F) > BYTE#55);	
		pad_1 := FALSE;
		POS := UDINT#0;
		End := SIZE;
		SIZE := MIN(UDINT#64,end);
		MODE := 2;

	2:	
		FOR n := UDINT_TO_INT(SIZE) TO 63 DO
			BUF[n] := BYTE#0;
		END_FOR;

		IF SIZE < UDINT#64 AND NOT pad_1 THEN
			BUF[SIZE] := BYTE#2#1000_0000;
			pad_1 := TRUE;
		END_IF;

		POS := POS + SIZE;
		SIZE := MIN(UDINT#64,End - POS);

		n := 0;	
		FOR n4 := 0 TO 15 DO
			n1 := n + 1;
			n2 := n + 2;
			n3 := n + 3;
			x[n4] := DWORD_OF_BYTE(BUF[n3],BUF[n2],BUF[n1],BUF[n]);
			n := n + 4;
		END_FOR;

		IF block = UDINT#0 THEN 
			x[14] := SHL_DWORD(UDINT_TO_DWORD(End),3); 
			MODE := 3;
		ELSE
			block := block - UDINT#1;
		END_IF;

		a := hash[0];
		b := hash[1];
		c := hash[2];
		d := hash[3];

		a := MD5_AUX(1, a, b, c, d, X[00], 07, DWORD#16#D76AA478); 
		d := MD5_AUX(1, d, a, b, c, X[01], 12, DWORD#16#E8C7B756); 
		c := MD5_AUX(1, c, d, a, b, X[02], 17, DWORD#16#242070DB); 
		b := MD5_AUX(1, b, c, d, a, X[03], 22, DWORD#16#C1BDCEEE);
		a := MD5_AUX(1, a, b, c, d, X[04], 07, DWORD#16#F57C0FAF); 
		d := MD5_AUX(1, d, a, b, c, X[05], 12, DWORD#16#4787C62A); 
		c := MD5_AUX(1, c, d, a, b, X[06], 17, DWORD#16#A8304613); 
		b := MD5_AUX(1, b, c, d, a, X[07], 22, DWORD#16#FD469501); 
		a := MD5_AUX(1, a, b, c, d, X[08], 07, DWORD#16#698098D8); 
		d := MD5_AUX(1, d, a, b, c, X[09], 12, DWORD#16#8B44F7AF);
		c := MD5_AUX(1, c, d, a, b, X[10], 17, DWORD#16#FFFF5BB1); 
		b := MD5_AUX(1, b, c, d, a, X[11], 22, DWORD#16#895CD7BE); 
		a := MD5_AUX(1, a, b, c, d, X[12], 07, DWORD#16#6B901122); 
		d := MD5_AUX(1, d, a, b, c, X[13], 12, DWORD#16#FD987193); 
		c := MD5_AUX(1, c, d, a, b, X[14], 17, DWORD#16#A679438E); 
		b := MD5_AUX(1, b, c, d, a, X[15], 22, DWORD#16#49B40821); 

		a := MD5_AUX(2, a, b, c, d, X[01], 05, DWORD#16#F61E2562);
		d := MD5_AUX(2, d, a, b, c, X[06], 09, DWORD#16#C040B340);
		c := MD5_AUX(2, c, d, a, b, X[11], 14, DWORD#16#265E5A51); 
		b := MD5_AUX(2, b, c, d, a, X[00], 20, DWORD#16#E9B6C7AA); 
		a := MD5_AUX(2, a, b, c, d, X[05], 05, DWORD#16#D62F105D); 
		d := MD5_AUX(2, d, a, b, c, X[10], 09, DWORD#16#02441453); 
		c := MD5_AUX(2, c, d, a, b, X[15], 14, DWORD#16#D8A1E681); 
		b := MD5_AUX(2, b, c, d, a, X[04], 20, DWORD#16#E7D3FBC8); 
		a := MD5_AUX(2, a, b, c, d, X[09], 05, DWORD#16#21E1CDE6);
		d := MD5_AUX(2, d, a, b, c, X[14], 09, DWORD#16#C33707D6); 
		c := MD5_AUX(2, c, d, a, b, X[03], 14, DWORD#16#F4D50D87); 
		b := MD5_AUX(2, b, c, d, a, X[08], 20, DWORD#16#455A14ED); 
		a := MD5_AUX(2, a, b, c, d, X[13], 05, DWORD#16#A9E3E905); 
		d := MD5_AUX(2, d, a, b, c, X[02], 09, DWORD#16#FCEFA3F8);
		c := MD5_AUX(2, c, d, a, b, X[07], 14, DWORD#16#676F02D9); 
		b := MD5_AUX(2, b, c, d, a, X[12], 20, DWORD#16#8D2A4C8A);

		a := MD5_AUX(3, a, b, c, d, X[05], 04, DWORD#16#FFFA3942); 
		d := MD5_AUX(3, d, a, b, c, X[08], 11, DWORD#16#8771F681); 
		c := MD5_AUX(3, c, d, a, b, X[11], 16, DWORD#16#6D9D6122); 
		b := MD5_AUX(3, b, c, d, a, X[14], 23, DWORD#16#FDE5380C);
		a := MD5_AUX(3, a, b, c, d, X[01], 04, DWORD#16#A4BEEA44);
		d := MD5_AUX(3, d, a, b, c, X[04], 11, DWORD#16#4BDECFA9); 
		c := MD5_AUX(3, c, d, a, b, X[07], 16, DWORD#16#F6BB4B60); 
		b := MD5_AUX(3, b, c, d, a, X[10], 23, DWORD#16#BEBFBC70);
		a := MD5_AUX(3, a, b, c, d, X[13], 04, DWORD#16#289B7EC6); 
		d := MD5_AUX(3, d, a, b, c, X[00], 11, DWORD#16#EAA127FA); 
		c := MD5_AUX(3, c, d, a, b, X[03], 16, DWORD#16#D4EF3085);
		b := MD5_AUX(3, b, c, d, a, X[06], 23, DWORD#16#04881D05);
		a := MD5_AUX(3, a, b, c, d, X[09], 04, DWORD#16#D9D4D039);
		d := MD5_AUX(3, d, a, b, c, X[12], 11, DWORD#16#E6DB99E5);
		c := MD5_AUX(3, c, d, a, b, X[15], 16, DWORD#16#1FA27CF8); 
		b := MD5_AUX(3, b, c, d, a, X[02], 23, DWORD#16#C4AC5665); 

		a := MD5_AUX(4, a, b, c, d, X[00], 06, DWORD#16#F4292244); 
		d := MD5_AUX(4, d, a, b, c, X[07], 10, DWORD#16#432AFF97); 
		c := MD5_AUX(4, c, d, a, b, X[14], 15, DWORD#16#AB9423A7); 
		b := MD5_AUX(4, b, c, d, a, X[05], 21, DWORD#16#FC93A039); 
		a := MD5_AUX(4, a, b, c, d, X[12], 06, DWORD#16#655B59C3);
		d := MD5_AUX(4, d, a, b, c, X[03], 10, DWORD#16#8F0CCC92); 
		c := MD5_AUX(4, c, d, a, b, X[10], 15, DWORD#16#FFEFF47D); 
		b := MD5_AUX(4, b, c, d, a, X[01], 21, DWORD#16#85845DD1); 
		a := MD5_AUX(4, a, b, c, d, X[08], 06, DWORD#16#6FA87E4F); 
		d := MD5_AUX(4, d, a, b, c, X[15], 10, DWORD#16#FE2CE6E0);
		c := MD5_AUX(4, c, d, a, b, X[06], 15, DWORD#16#A3014314); 
		b := MD5_AUX(4, b, c, d, a, X[13], 21, DWORD#16#4E0811A1); 
		a := MD5_AUX(4, a, b, c, d, X[04], 06, DWORD#16#F7537E82); 
		d := MD5_AUX(4, d, a, b, c, X[11], 10, DWORD#16#BD3AF235);
		c := MD5_AUX(4, c, d, a, b, X[02], 15, DWORD#16#2AD7D2BB); 
		b := MD5_AUX(4, b, c, d, a, X[09], 21, DWORD#16#EB86D391); 

		hash[0] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[0]) + DWORD_TO_UDINT(a));
		hash[1] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[1]) + DWORD_TO_UDINT(b));
		hash[2] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[2]) + DWORD_TO_UDINT(c));
		hash[3] := UDINT_TO_DWORD(DWORD_TO_UDINT(hash[3]) + DWORD_TO_UDINT(d));

	END_CASE;

	IF MODE = 3 THEN
		n2 := 0;
		FOR n := 0 TO 3 DO 
			FOR n1 := 0 TO 3 DO
				MD5[n2] := DWORD_TO_BYTE(hash[n]);
				hash[n] := ROR_DWORD(hash[n],8);
				n2 := n2 + 1;
			END_FOR;
		END_FOR;
	END_IF;

END_FUNCTION_BLOCK
