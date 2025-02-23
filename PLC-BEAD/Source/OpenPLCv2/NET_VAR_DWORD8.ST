TYPE
	oscat_nv_dw : ARRAY[1..8] OF DWORD;
END_TYPE

TYPE

	oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

	oscat_NETWORK_BUFFER :
	STRUCT
		SIZE   : UINT;	
		BUFFER : oscat_NW_BUF_LONG;
	END_STRUCT;

END_TYPE

TYPE oscat_NET_VAR_DATA :
	STRUCT
		CYCLE : UDINT;
		STATE : BYTE;
		INDEX : INT;
		ID_MAX : USINT;
		ERROR_ID : BYTE;
		BUF_SIZE : UINT;
		S_BUF : oscat_NETWORK_BUFFER;
		R_BUF : oscat_NETWORK_BUFFER;
	END_STRUCT;
END_TYPE

FUNCTION_BLOCK NET_VAR_DWORD8_Block

	VAR_INPUT
		IN1 :	DWORD;
		IN2 :	DWORD;
		IN3 :	DWORD;
		IN4 :	DWORD;
		IN5 :	DWORD;
		IN6 :	DWORD;
		IN7 :	DWORD;
		IN8 :	DWORD;
	END_VAR


	VAR_OUTPUT
		OUT1 :	DWORD;
		OUT2 :	DWORD;
		OUT3 :	DWORD;
		OUT4 :	DWORD;
		OUT5 :	DWORD;
		OUT6 :	DWORD;
		OUT7 :	DWORD;
		OUT8 :	DWORD;
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
		ra :	oscat_nv_dw;
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
				X.S_BUF.BUFFER[index] := BYTE#13; 
				index := index + 1;
				FOR i2 := 1 TO 8 DO
					FOR i := 1 TO 4 DO
						X.S_BUF.BUFFER[index] := DWORD_TO_BYTE(ra[i2]);
						ra[i2] := ROR(ra[i2],8);
						index := index + 1;
					END_FOR;
				END_FOR;

			ELSIF X.STATE = BYTE#2 THEN 
				index2 := index + 1; 
				IF X.R_BUF.BUFFER[index] <> ID OR X.R_BUF.BUFFER[index2] <> BYTE#13 THEN
					X.ERROR_ID := ID;
				ELSE
					index := index + 2;
					FOR i2 := 1 TO 8 DO
						ra[i2] := DWORD#0;
						FOR i := 1 TO 4 DO
							ra[i2] := ra[i2] OR BYTE_TO_DWORD(X.R_BUF.BUFFER[index]);
							ra[i2] := ROR(ra[i2],8);
							index := index + 1;
						END_FOR;
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

PROGRAM program0
	VAR
		IN1 :	DWORD;
		IN2 :	DWORD;
		IN3 :	DWORD;
		IN4 :	DWORD;
		IN5 :	DWORD;
		IN6 :	DWORD;
		IN7 :	DWORD;
		IN8 :	DWORD;
		OUT1 :	DWORD;
		OUT2 :	DWORD;
		OUT3 :	DWORD;
		OUT4 :	DWORD;
		OUT5 :	DWORD;
		OUT6 :	DWORD;
		OUT7 :	DWORD;
		OUT8 :	DWORD;
		ID :	BYTE;
		X :	oscat_NET_VAR_DATA;

		func_block : NET_VAR_DWORD8_Block;
	END_VAR
	func_block.IN1 := IN1;
	func_block.IN2 := IN2;
	func_block.IN3 := IN3;
	func_block.IN4 := IN4;
	func_block.IN5 := IN5;
	func_block.IN6 := IN6;
	func_block.IN7 := IN7;
	func_block.IN8 := IN8;
	func_block.X := X;

	func_block();
  	OUT1  := func_block.OUT1;
	OUT2  := func_block.OUT2;
	OUT3  := func_block.OUT3;
	OUT4  := func_block.OUT4;
	OUT5  := func_block.OUT5;
	OUT6  := func_block.OUT6;
	OUT7  := func_block.OUT7;
	OUT8  := func_block.OUT8;
	ID  := func_block.ID;
	X  := func_block.X;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION