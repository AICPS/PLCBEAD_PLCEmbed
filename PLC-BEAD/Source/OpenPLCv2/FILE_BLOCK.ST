TYPE
  oscat_FILE_SERVER_DATA : STRUCT
	FILE_OPEN	: BOOL;
    FILENAME 	: STRING;
    MODE	 	: BYTE;
    OFFSET   	: UDINT;
    FILE_SIZE   : UDINT;
    AUTO_CLOSE	: TIME;
    ERROR	 	: BYTE;
  END_STRUCT;

  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;
  oscat_NETWORK_BUFFER :
  STRUCT
    SIZE   : UINT;	
    BUFFER : oscat_NW_BUF_LONG;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK FILE_BLOCK

	VAR_IN_OUT
		MODE :	BYTE;
		FILENAME :	STRING;
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
	END_VAR

	VAR_INPUT
		POS :	UDINT;
	END_VAR

	VAR_OUTPUT
		ERROR :	BYTE;
		DATA :	BYTE;
	END_VAR

	VAR
		stepp :	INT;
		i :	INT;
		data_start :	UDINT;
		data_stop :	UDINT;
	END_VAR

	CASE stepp OF
	0:	IF MODE > BYTE#0 THEN
			ERROR := BYTE#0;
			IF FSD.FILE_OPEN AND (FSD.FILE_SIZE = UDINT#0 OR POS >= FSD.FILE_SIZE) THEN
				ERROR := BYTE#255;
				MODE := BYTE#0;
			ELSIF POS < data_start OR POS > data_stop OR NOT FSD.FILE_OPEN THEN 
				FSD.FILENAME := FILENAME;
				FSD.MODE := BYTE#1; 
				FSD.OFFSET := POS;
				PT.SIZE := UINT#65535; 
				data_start := UDINT#0;
				data_stop := UDINT#0;
				stepp := 10;
			ELSE 
				i := UDINT_TO_INT(POS - data_start); 
				DATA := PT.BUFFER[i];
				MODE := BYTE#0;
			END_IF;
		END_IF;

	10:	IF FSD.MODE = BYTE#0 THEN 
			IF FSD.ERROR > BYTE#0 THEN
				ERROR := FSD.ERROR; 
				MODE := BYTE#0;
			ELSE
				data_start := POS;
				data_stop := POS + UINT_TO_UDINT(PT.SIZE) - UDINT#1;
			END_IF;
			stepp := 0;
		END_IF;
	END_CASE;
END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		MODE :	BYTE;
		FILENAME :	STRING;
		FSD :	oscat_FILE_SERVER_DATA;
		PT :	oscat_NETWORK_BUFFER;
		POS :	UDINT;
		ERROR :	BYTE;
		DATA :	BYTE;

		func_block : FILE_BLOCK;
	END_VAR
	func_block.MODE    :=MODE    ;
	func_block.FILENAME:=FILENAME;
	func_block.FSD     :=FSD     ;
	func_block.PT      :=PT      ;
	func_block.POS     :=POS     ;
	func_block();
	MODE    := func_block.MODE    ;
	FILENAME:= func_block.FILENAME;
	FSD     := func_block.FSD     ;
	PT      := func_block.PT      ;
	ERROR   := func_block.ERROR;
	DATA    := func_block.DATA;

END_PROGRAM

CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION