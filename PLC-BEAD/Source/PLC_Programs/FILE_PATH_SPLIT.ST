TYPE 
  oscat_STRING250             : STRING; 
  oscat_STRING1             : STRING;
  oscat_STRING80             : STRING;
  oscat_STRING3             : STRING;
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;
  PRINTF_DATA_250  	:  ARRAY [1..11]  OF oscat_STRING250;
  PRINTF_DATA_80 	:  ARRAY [1..11]  OF oscat_STRING80;
  LOG_250       	:  ARRAY [0..400] OF oscat_STRING250;
  LOG_80    		:  ARRAY [0..400] OF oscat_STRING80;
  LOG_OPTION		:  ARRAY [0..400] OF DWORD;

  us_LOG_CONTROL :
  STRUCT
    NEW_MSG              : oscat_STRING250;    (*W neue Nachricht f�r den Datenbuffer   *)
	NEW_MSG_OPTION 		 : DWORD;
    LEVEL                : BYTE;
	SIZE                 : INT;                (*R Anzahl der Strings im LOG_DATA       *)
	RESET                : BOOL;               (*W Nachrichtenbuffer l�schen            *)
    PRINTF               : PRINTF_DATA_250;    (*W Array PRINTF Parameter               *)
    MSG                  : LOG_250;            (*I Array Message                        *)
    MSG_OPTION           : LOG_OPTION;     	   (*I Array Message Option                 *) 
	UPDATE_COUNT         : UINT;               (*R Updatez�hler                         *)
    IDX                  : INT;                (*R aktueller Nachrichten-Index          *)
	RING_MODE            : BOOL;               (*I Buffer�berlauf erkannt               *)
  END_STRUCT;

  us_LOG_CONTROL_80 :
  STRUCT
    NEW_MSG              : oscat_STRING80;     (*W neue Nachricht f�r den Datenbuffer   *)
	NEW_MSG_OPTION 		 : DWORD;
    LEVEL                : BYTE;
	SIZE                 : INT;                (*R Anzahl der Strings im LOG_DATA       *)
	RESET                : BOOL;               (*W Nachrichtenbuffer l�schen            *)
    PRINTF               : PRINTF_DATA_80;     (*W Array PRINTF Parameter               *)
    MSG                  : LOG_80;             (*I Array Message                        *)
    MSG_OPTION           : LOG_OPTION;     	   (*I Array Message Option                 *) 
	UPDATE_COUNT         : UINT;               (*R Updatez�hler                         *)
    IDX                  : INT;                (*R aktueller Nachrichten-Index          *)
	RING_MODE            : BOOL;               (*I Buffer�berlauf erkannt               *)
  END_STRUCT;

  LINE_ARRAY 			: ARRAY [1..40] OF INT;

  us_LOG_VIEWPORT :
    STRUCT
     LINE_ARRAY          : LINE_ARRAY;
     COUNT               : INT;                (* Anzahl der sichtbaren Nachtrichten   *)
	 UPDATE_COUNT        : UINT;               (* Updatez�hler                         *)
     MOVE_TO_X           : INT;                (* Steuerung der Nachrichtenanzeige     *) 
     UPDATE              : BOOL;               (* Daten wurden ge�ndert -> neuzeichnen *)
  END_STRUCT;

  oscat_FILE_SERVER_DATA : STRUCT
	FILE_OPEN	: BOOL;
    FILENAME 	: STRING;
    MODE	 	: BYTE;
    OFFSET   	: UDINT;
    FILE_SIZE   : UDINT;
    AUTO_CLOSE	: TIME;
    ERROR	 	: BYTE;
  END_STRUCT;

  oscat_FILE_PATH_DATA : STRUCT
	DRIVE : oscat_string3;
	DIRECTORY : oscat_string250;
	FILENAME : STRING;
  END_STRUCT;

  oscat_UNI_CIRCULAR_BUFFER_DATA : STRUCT
	D_MODE : INT;
	D_HEAD : WORD;
	D_STRING : oscat_string250;
	D_REAL : REAL;
	D_DWORD : DWORD;
	BUF_SIZE : INT;
	BUF_COUNT : INT;
	BUF_USED : USINT;
	BUF : oscat_NW_BUF_LONG;
	_GetStart : INT;
	_GetEnd : INT;
	_Last : INT;
	_First : INT;
  END_STRUCT;

  oscat_DLOG_DATA : STRUCT
	STORE_TYPE : BYTE;
	ADD_HEADER : BOOL;
	ADD_DATA : BOOL;
	ADD_DATA_REQ : BOOL;
	CLOCK_TRIG : BOOL;
	ID_MAX : USINT;
	DTI : UDINT;
	UCB : oscat_UNI_CIRCULAR_BUFFER_DATA;
	NEW_FILE : STRING;
	NEW_FILE_RTRIG : BOOL;
  END_STRUCT;

END_TYPE

FUNCTION_BLOCK FILE_PATH_SPLIT_Block

	VAR_INPUT
		FILENAME :	oscat_STRING250;
	END_VAR


	VAR_OUTPUT
		FILE_PATH_SPLIT :	BOOL;
	END_VAR


	VAR_IN_OUT
		X :	oscat_FILE_PATH_DATA;
	END_VAR


	VAR
		b :	INT;
		c :	INT;
		d :	oscat_STRING1;
		p1 :	INT;
		p2 :	INT;
	END_VAR

	X.DRIVE := '';
	X.DIRECTORY := '';
	X.FILENAME := '';
	p1 := 0;
	p2 := 0;
	c := LEN(FILENAME);
	IF c = 0 THEN
		FILE_PATH_SPLIT := FALSE;
		RETURN;
	END_IF;

	FOR b := 1 TO c DO
		d := MID(FILENAME, 1, b);
		IF EQ_STRING(d,':') THEN
			p1 := b;
		ELSIF EQ_STRING(d,'/') OR EQ_STRING(d,'\') THEN
			p2 := b;
		END_IF;
	END_FOR;

	IF p1 = 2 THEN
		X.DRIVE := LEFT(FILENAME,p1);
	END_IF;

	IF p2 > 0 AND p2 > p1 THEN
		X.DIRECTORY := MID(FILENAME,p2-p1,p1+1); 
	END_IF;

	X.FILENAME := RIGHT(FILENAME,c - MAX (p1,p2));
	FILE_PATH_SPLIT := TRUE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		FILENAME :	oscat_STRING250;
		FILE_PATH_SPLIT :	BOOL;
		X :	oscat_FILE_PATH_DATA;

		func_block : FILE_PATH_SPLIT_Block;
	END_VAR
	func_block.FILENAME := FILENAME;
	func_block.X := X;

	func_block();
	FILE_PATH_SPLIT  := func_block.FILE_PATH_SPLIT;
	X  := func_block.X;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION