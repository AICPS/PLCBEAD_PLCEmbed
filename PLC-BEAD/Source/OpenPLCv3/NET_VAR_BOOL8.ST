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

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
END_FUNCTION


FUNCTION_BLOCK BYTE_TO_BITS_Block
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	VAR_OUTPUT
		B0 :	BOOL;
		B1 :	BOOL;
		B2 :	BOOL;
		B3 :	BOOL;
		B4 :	BOOL;
		B5 :	BOOL;
		B6 :	BOOL;
		B7 :	BOOL;
	END_VAR

	B0 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),0); (* IN.X0 *)
	B1 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),1); (* IN.X1 *)
	B2 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),2); (* IN.X2 *)
	B3 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),3); (* IN.X3 *)
	B4 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),4); (* IN.X4 *)
	B5 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),5); (* IN.X5 *)
	B6 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),6); (* IN.X6 *)
	B7 := BIT_OF_DWORD(BYTE_TO_DWORD(IN),7); (* IN.X7 *)
END_FUNCTION_BLOCK

FUNCTION BYTE_OF_BIT:BYTE
	VAR_INPUT
		B0 :	BOOL;
		B1 :	BOOL;
		B2 :	BOOL;
		B3 :	BOOL;
		B4 :	BOOL;
		B5 :	BOOL;
		B6 :	BOOL;
		B7 :	BOOL;
	END_VAR
	Byte_of_bit := SHL(SHL(SHL(SHL(SHL(SHL(SHL(BOOL_TO_BYTE(B7),1) OR BOOL_TO_BYTE(B6),1)
	OR BOOL_TO_BYTE(B5),1) OR BOOL_TO_BYTE(B4),1) OR BOOL_TO_BYTE(B3),1) OR BOOL_TO_BYTE(B2),1)
	OR BOOL_TO_BYTE(B1),1) OR BOOL_TO_BYTE(B0);
END_FUNCTION

FUNCTION_BLOCK NET_VAR_BOOL8_Block

	VAR_INPUT
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		IN5 :	BOOL;
		IN6 :	BOOL;
		IN7 :	BOOL;
		IN8 :	BOOL;
	END_VAR


	VAR_OUTPUT
		OUT1 :	BOOL;
		OUT2 :	BOOL;
		OUT3 :	BOOL;
		OUT4 :	BOOL;
		OUT5 :	BOOL;
		OUT6 :	BOOL;
		OUT7 :	BOOL;
		OUT8 :	BOOL;
		ID :	BYTE;
	END_VAR


	VAR_IN_OUT
		X :	oscat_NET_VAR_DATA;
	END_VAR


	VAR
		init :	BOOL;
		index :	INT;
		index2 :	INT;
		_BYTE_TO_BITS :	BYTE_TO_BITS_Block;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		X.ID_MAX := X.ID_MAX + USINT#1;
		ID := USINT_TO_BYTE(X.ID_MAX);
	END_IF;

	IF X.STATE > BYTE#0 AND X.ERROR_ID = BYTE#0 THEN
		index := X.index;
		IF INT_TO_UINT(index + 3) > X.BUF_SIZE THEN
			X.ERROR_ID := ID;
		ELSE
			IF X.STATE = BYTE#1 THEN 
				X.S_BUF.BUFFER[index] := ID; 
				index := index + 1;
				X.S_BUF.BUFFER[index] := BYTE#4; 
				index := index + 1;
				X.S_BUF.BUFFER[index] := BYTE_OF_BIT(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8);
				index := index + 1;

			ELSIF X.STATE = BYTE#2 THEN
				index2 := index + 1;
				IF X.R_BUF.BUFFER[index] <> ID OR X.R_BUF.BUFFER[index2] <> BYTE#4 THEN
					X.ERROR_ID := ID;
				ELSE
					index := index + 2;
					_BYTE_TO_BITS(IN:=X.R_BUF.BUFFER[index]);
					OUT1 := _BYTE_TO_BITS.B0;
					OUT2 := _BYTE_TO_BITS.B1;
					OUT3 := _BYTE_TO_BITS.B2;
					OUT4 := _BYTE_TO_BITS.B3;
					OUT5 := _BYTE_TO_BITS.B4;
					OUT6 := _BYTE_TO_BITS.B5;
					OUT7 := _BYTE_TO_BITS.B6;
					OUT8 := _BYTE_TO_BITS.B7;
					index := index + 1;
				END_IF;
			END_IF;
			X.index := index;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IN1 :	BOOL;
		IN2 :	BOOL;
		IN3 :	BOOL;
		IN4 :	BOOL;
		IN5 :	BOOL;
		IN6 :	BOOL;
		IN7 :	BOOL;
		IN8 :	BOOL;
		OUT1 :	BOOL;
		OUT2 :	BOOL;
		OUT3 :	BOOL;
		OUT4 :	BOOL;
		OUT5 :	BOOL;
		OUT6 :	BOOL;
		OUT7 :	BOOL;
		OUT8 :	BOOL;
		ID :	BYTE;
		X :	oscat_NET_VAR_DATA;

		func_block : NET_VAR_BOOL8_Block;
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