FUNCTION_BLOCK NET_VAR_REAL8

	VAR_INPUT
		IN1 :	REAL;
		IN2 :	REAL;
		IN3 :	REAL;
		IN4 :	REAL;
		IN5 :	REAL;
		IN6 :	REAL;
		IN7 :	REAL;
		IN8 :	REAL;
	END_VAR


	VAR_OUTPUT
		OUT1 :	REAL;
		OUT2 :	REAL;
		OUT3 :	REAL;
		OUT4 :	REAL;
		OUT5 :	REAL;
		OUT6 :	REAL;
		OUT7 :	REAL;
		OUT8 :	REAL;
		ID :	BYTE;
	END_VAR


	VAR_IN_OUT
		X :	oscat_NET_VAR_DATA;
	END_VAR


	VAR
		init :	BOOL;
		i :	INT;
		i2 :	INT;
		index :	INT;
		index2 :	INT;
		r_dw :	DWORD;
		REAL_TO_DW :	REAL_TO_DW;
		DW_TO_REAL :	DW_TO_REAL;
		ra :	oscat_nv_ra;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		X.ID_MAX := X.ID_MAX + USINT#1;
		ID := USINT_TO_BYTE(X.ID_MAX);
	END_IF;

	IF X.STATE > BYTE#0 AND X.ERROR_ID = BYTE#0 THEN
		index := X.index;
		IF INT_TO_UINT(index + 34) > X.BUF_SIZE THEN 
			X.ERROR_ID := ID;
		ELSE
			IF X.STATE = BYTE#1 THEN 
				ra[1] := IN1;
				ra[2] := IN2;
				ra[3] := IN3;
				ra[4] := IN4;
				ra[5] := IN5;
				ra[6] := IN6;
				ra[7] := IN7;
				ra[8] := IN8;
				X.S_BUF.BUFFER[index] := ID;
				index := index + 1;
				X.S_BUF.BUFFER[index] := BYTE#15; 
				index := index + 1;
				FOR i2 := 1 TO 8 DO;
					REAL_TO_DW(X:=ra[i2]);
					r_dw:=REAL_TO_DW.REAL_TO_DW;
					FOR i := 1 TO 4 DO;
						X.S_BUF.BUFFER[index] := DWORD_TO_BYTE(r_dw);
						r_dw := ROR(r_dw,8);
						index := index + 1;
					END_FOR;
				END_FOR;

			ELSIF X.STATE = BYTE#2 THEN 
				index2 := index + 1; 
				IF X.R_BUF.BUFFER[index] <> ID OR X.R_BUF.BUFFER[index2] <> BYTE#15 THEN 
					X.ERROR_ID := ID;
				ELSE
					index := index + 2;
					FOR i2 := 1 TO 8 DO;
						r_dw := DWORD#0;
						FOR i := 1 TO 4 DO;
							r_dw := r_dw OR BYTE_TO_DWORD(X.R_BUF.BUFFER[index]);
							r_dw := ROR(r_dw,8);
							index := index + 1;
						END_FOR;
						DW_TO_REAL(X:=r_dw);
						ra[i2]:=DW_TO_REAL.DW_TO_REAL;
					END_FOR;
					OUT1 := ra[1];
					OUT2 := ra[2];
					OUT3 := ra[3];
					OUT4 := ra[4];
					OUT5 := ra[5];
					OUT6 := ra[6];
					OUT7 := ra[7];
					OUT8 := ra[8];
				END_IF;
			END_IF;
			X.index := index;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK
