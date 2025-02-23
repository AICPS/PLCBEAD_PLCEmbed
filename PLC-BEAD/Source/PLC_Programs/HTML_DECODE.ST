FUNCTION_BLOCK HTML_DECODE

	VAR_INPUT
		IN :	oscat_STRING250;
	END_VAR


	VAR_OUTPUT
		HTML_DECODE :	oscat_STRING250;
	END_VAR


	VAR
		pos :	INT;
		end :	INT;
		tmp :	oscat_STRING10;
		code :	BYTE;
		size :	INT;
		CHR_TO_STRING :	CHR_TO_STRING;
		CHARCODE :	CHARCODE;
		HEX_TO_DWORD :	HEX_TO_DWORD;
		FINDP :	FINDP;
	END_VAR

	HTML_DECODE := IN;

	pos := FIND(HTML_DECODE, '&');
	WHILE pos > 0 DO
		tmp := MID(HTML_DECODE, 2, pos + 1);
		IF EQ_STRING(tmp,'#x') OR EQ_STRING(tmp,'#X') THEN

			IF pos+13 > LEN(HTML_DECODE) THEN
			size := LEN(HTML_DECODE) - pos - 2;
			ELSE
			size := 10;
			END_IF; 

			tmp := MID(HTML_DECODE, size, pos + 3);
			end := FIND(tmp, ';');
			HEX_TO_DWORD(Hex:=LEFT(tmp, end - 1));
			CODE := DWORD_TO_BYTE(HEX_TO_DWORD.HEX_TO_DWORD);
			CHR_TO_STRING(C:=CODE);
			HTML_DECODE := REPLACE(HTML_DECODE, CHR_TO_STRING.CHR_TO_STRING, end + 3, pos);
		ELSE
			tmp := LEFT(tmp,1);
			IF EQ_STRING(tmp,'#') THEN

				IF pos+12 > LEN(HTML_DECODE) THEN
					size := LEN(HTML_DECODE) - pos - 1;
				ELSE
					size := 10;
				END_IF; 

				tmp := MID(HTML_DECODE, size, pos + 2);
				end := FIND(tmp, ';');
				tmp := LEFT(tmp, end - 1);
				CODE := INT_TO_BYTE(STRING_TO_INT(tmp));
				CHR_TO_STRING(C:=CODE);
				HTML_DECODE := REPLACE(HTML_DECODE, CHR_TO_STRING.CHR_TO_STRING, end + 2, pos);
			ELSE
				IF pos+11 > LEN(HTML_DECODE) THEN
					size := LEN(HTML_DECODE) - pos ;
				ELSE
					size := 10;
				END_IF; 

				tmp := MID(HTML_DECODE, size, pos + 1);
				end := FIND(tmp, ';');
				CHARCODE(STR:=LEFT(tmp, end - 1));
				CODE := CHARCODE.CHARCODE;
				CHR_TO_STRING(C:=CODE);
				HTML_DECODE := REPLACE(HTML_DECODE, CHR_TO_STRING.CHR_TO_STRING, end + 1, pos);
			END_IF;
		END_IF;
		FINDP(str:=HTML_DECODE,src:='&',pos:=pos + 1);
		pos := FINDP.FINDP;
	END_WHILE;

END_FUNCTION_BLOCK
