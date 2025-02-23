TYPE
	oscat_aB1_64 : ARRAY[1..64] OF BYTE;
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

FUNCTION_BLOCK NET_VAR_BUFFER_Block

	VAR_OUTPUT
		ID :	BYTE;
	END_VAR


	VAR_IN_OUT
		BUF_IN :	oscat_aB1_64;
		BUF_OUT :	oscat_aB1_64;
		X :	oscat_NET_VAR_DATA;
	END_VAR


	VAR
		size :	INT;
		init :	BOOL;
		index :	INT;
		index2 :	INT;
	END_VAR

	IF NOT init THEN
		init := TRUE;
		X.ID_MAX := X.ID_MAX + USINT#1;
		ID := USINT_TO_BYTE(X.ID_MAX);
	END_IF;

	IF X.STATE > BYTE#0 AND X.ERROR_ID = BYTE#0 THEN
		index := X.index; 
		IF X.STATE = BYTE#1 THEN 
			size := 64;
			IF INT_TO_UINT(index + 3 + size) > X.BUF_SIZE THEN
				X.ERROR_ID := ID;
			ELSE
				X.S_BUF.BUFFER[index] := ID; 
				index := index + 1;
				X.S_BUF.BUFFER[index] := BYTE#20; 
				index := index + 1;
				X.S_BUF.BUFFER[index] := INT_TO_BYTE(size); 
				index := index + 1;
				FOR index2 := 1 TO size DO
					X.S_BUF.BUFFER[index] := BUF_IN[index2];
					index := index + 1;
				END_FOR;
			END_IF;
		ELSIF X.STATE = BYTE#2 THEN
			index2 := index + 1;
			IF X.R_BUF.BUFFER[index] <> ID OR X.R_BUF.BUFFER[index2] <> BYTE#20 THEN
				X.ERROR_ID := ID;
			ELSE
				index := index + 2;
				size := BYTE_TO_INT(X.R_BUF.BUFFER[index]);
				index := index + 1;
				FOR index2 := 1 TO size DO
					BUF_OUT[index2] := X.R_BUF.BUFFER[index];
					index := index + 1;
				END_FOR;
			END_IF;
		END_IF;
		X.index := index;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		BUF_IN :	oscat_aB1_64;
		BUF_OUT :	oscat_aB1_64;
		X :	oscat_NET_VAR_DATA;
		ID :	BYTE;

		func_block : NET_VAR_BUFFER_Block;
	END_VAR
	func_block.BUF_IN := BUF_IN;
	func_block.BUF_OUT := BUF_OUT;
	func_block.X := X;

	func_block();
  	BUF_IN  := func_block.BUF_IN;
	BUF_OUT  := func_block.BUF_OUT;
	X  := func_block.X;
	ID  := func_block.ID;

END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION