FUNCTION_BLOCK DNS_CLIENT

	VAR

	END_VAR


	VAR_EXTERNAL

	END_VAR

	VAR
		IP4_DECODE :	IP4_DECODE;
		IP_FIFO :	IP_FIFO;
		CODE :	CODE;
		ip_state :	BYTE;
		ip_id :	BYTE;
		i :	INT;
		i1 :	INT;
		i2 :	INT;
		i3 :	INT;
		state :	INT;
		domain_copy :	STRING;
		activate_last :	BOOL;
		url_length :	INT;
		char :	BYTE;
		char_count :	INT;
		tid :	BYTE;
		anc :	INT;
		x :	BYTE;
		rr_stop :	BOOL;
		ttl_last :	DWORD;
		ttl_tmp :	DWORD;
		z :	INT;
	END_VAR

	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;
	END_VAR


	VAR_INPUT
		ACTIVATE :	BOOL;
		DOMAIN :	STRING;
		IP4_DNS :	DWORD;
	END_VAR


	VAR_OUTPUT
		IP4 :	DWORD;
		DONE :	BOOL;
		ERROR :	DWORD;
	END_VAR

	CASE state OF

	00:	IF ACTIVATE AND NOT activate_last THEN 
			DONE := FALSE;
			ERROR := DWORD#0;
			state := 5;
		END_IF;

	05: 
		IP4_DECODE(str:=DOMAIN);
		IP4 := IP4_DECODE.IP4_DECODE; 
		IF IP4 > DWORD#00 THEN
			DONE := TRUE;
			state := 0;
		ELSE
			ip_state := BYTE#1;
			ttl_last := DWORD#0;
			domain_copy := DOMAIN; 
			state := 10;
		END_IF;

	10:	IF ip_state = BYTE#3 THEN 
			url_length := LEN(domain_copy);
			char_count := 17 + url_length; 
			FOR i := 0 TO char_count DO
				S_BUF.BUFFER[i] := BYTE#00;
			END_FOR;
			tid := UINT_TO_BYTE(BYTE_TO_UINT(tid) + UINT#1);
			S_BUF.BUFFER[01] := tid; 
			S_BUF.BUFFER[02] := BYTE#16#01; 
			S_BUF.BUFFER[05] := BYTE#16#01; 
			i := url_length + 12;
			char_count := 0;
			WHILE i > 12 DO
				CODE(STR:=domain_copy,POS:=i - 12);
				char := CODE.CODE;
				IF char = BYTE#46 THEN
					S_BUF.BUFFER[i] := INT_TO_BYTE(char_count); 
					char_count := 0;
				ELSE
					S_BUF.BUFFER[i] := char; 
					char_count := char_count + 1; 
				END_IF;
				i := i - 1;
			END_WHILE;
			S_BUF.BUFFER[i] := INT_TO_BYTE(char_count); 
			i := url_length + 15; 
			S_BUF.BUFFER[i] := BYTE#01; 
			i := i + 2;
			S_BUF.BUFFER[i] := BYTE#01;
			i := i + 1;
			IP_C.C_PORT := WORD#53;
			IP_C.C_IP := IP4_DNS;
			IP_C.C_MODE := BYTE#1; 
			IP_C.C_ENABLE := TRUE; 
			IP_C.TIME_RESET := TRUE; 
			IP_C.R_OBSERVE  := TRUE; 
			S_BUF.SIZE := INT_TO_UINT(i); 
			R_BUF.SIZE := UINT#0; 
			state := 30;
		END_IF;

	30:	IF IP_C.ERROR <> DWORD#00 THEN
			ERROR := IP_C.ERROR;
			state := 99;

		ELSIF (S_BUF.SIZE = UINT#0) AND (tid = R_BUF.BUFFER[1]) AND (R_BUF.SIZE >= INT_TO_UINT(34 + url_length)) THEN	
			ERROR := BYTE_TO_DWORD(R_BUF.BUFFER[3] AND BYTE#2#0000_1111);
			IF ERROR = DWORD#00 THEN
				anc := _BYTE_TO_INT(R_BUF.BUFFER[7]);
				IP_C.R_OBSERVE := FALSE; 
				state := 40;
			ELSE
				state := 99;
			END_IF;
		END_IF;

	40:	IF anc > 0 THEN
			anc := anc - 1;
			z := UINT_TO_INT(R_BUF.SIZE);
			WHILE i < z DO
				x := R_BUF.BUFFER[i];
				IF rr_stop = FALSE THEN
					IF x > BYTE#63 THEN 
						i := i + 1;
						rr_stop := TRUE;
					ELSIF x= BYTE#0 THEN 
						rr_stop := TRUE;
					ELSE
						i := i + _BYTE_TO_INT(x); 
					END_IF;
					i := i + 1;
				ELSE
					rr_stop := FALSE;
					i1 := i + 1;
					i3 := i + 3;
					IF R_BUF.BUFFER[i1] = BYTE#1 AND R_BUF.BUFFER[i3] = BYTE#1 THEN
						i := i + 4;
						i1 := i + 1;
						i2 := i + 2;
						i3 := i + 3;
						ttl_tmp := DWORD_OF_BYTE(R_BUF.BUFFER[i],R_BUF.BUFFER[i1],R_BUF.BUFFER[i2],R_BUF.BUFFER[i3]); 
						i := i + 6;
						IF ttl_tmp >= ttl_last THEN 
							ttl_last := ttl_tmp;
							i1 := i + 1;
							i2 := i + 2;
							i3 := i + 3;
							IP4 := DWORD_OF_BYTE(R_BUF.BUFFER[i],R_BUF.BUFFER[i1],R_BUF.BUFFER[i2],R_BUF.BUFFER[i3]); 
						END_IF;
						i := i + 4;
					ELSE
						i := i + 9;
						i := i + _BYTE_TO_INT(R_BUF.BUFFER[i]) + 1; 
					END_IF;
					EXIT;
				END_IF;
			END_WHILE;
		ELSE
			IF IP4 > DWORD#0 THEN 
				DONE := TRUE;
			ELSE
				ERROR := DWORD#255; 
			END_IF;
			state := 99;
		END_IF;

	99:	R_BUF.SIZE := UINT#0;
		ip_state := BYTE#4;
		state := 00;

	END_CASE;

	activate_last := ACTIVATE; 

	IP_FIFO(FIFO:=IP_C.FIFO,STATE:=ip_state,ID:=ip_id);
	IP_C.FIFO:=IP_FIFO.FIFO;
	ip_state := IP_FIFO.STATE;
	ip_id:=IP_FIFO.ID;

END_FUNCTION_BLOCK
