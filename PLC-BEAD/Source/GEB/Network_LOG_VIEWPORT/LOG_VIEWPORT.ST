TYPE  
  oscat_STRING80             : STRING;
  oscat_STRING250             : STRING;
END_TYPE

TYPE  
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
    MSG_OPTION           : LOG_OPTION;     	   (*I Array Message OPTion                 *) 
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
    MSG_OPTION           : LOG_OPTION;     	   (*I Array Message OPTion                 *) 
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

END_TYPE

FUNCTION_BLOCK LOG_VIEWPORT_Block

  VAR_IN_OUT
    LC :	us_LOG_CONTROL_80;
    LV :	us_LOG_VIEWPORT;
  END_VAR

  VAR
    POS :	INT;
    count :	INT;
    idx :	INT;
    base :	INT;
    update_POS :	BOOL;
  END_VAR

  IF LV.MOVE_TO_X <> 0 THEN
    CASE LV.MOVE_TO_X OF
    30000:
      POS := 1 ;
    30001:
      POS := LC.SIZE; 
    30002:
      POS := POS + LV.COUNT;
    30003:
      POS := POS - LV.COUNT; 
    ELSE
      POS := POS + LV.MOVE_TO_X;
    END_CASE;
    update_POS := TRUE;
    LV.MOVE_TO_X := 0;
  END_IF;

  IF (LV.UPDATE_COUNT <> LC.UPDATE_COUNT) OR update_POS THEN 
    LV.UPDATE := TRUE;
    LV.UPDATE_COUNT := LC.UPDATE_COUNT;
    update_POS := FALSE;  

    IF LC.RING_MODE THEN
      POS := LIMIT(1,POS,LC.SIZE - LV.COUNT + 1);
    ELSE
      IF LC.IDX > LV.COUNT THEN
        POS := LIMIT(1,POS,LC.IDX - LV.COUNT + 1);
      ELSE
        POS := 1;
      END_IF;
    END_IF;

    base := LC.IDX - POS - LV.COUNT + 1;
    IF LC.RING_MODE THEN 
      FOR count:= 1 TO LV.COUNT DO
        idx := base + count;
        IF idx < 1 THEN
          idx := idx + LC.SIZE;
        END_IF;
      END_FOR;
    ELSE
      FOR count:= 1 TO LV.COUNT DO
        idx := base + count;
        IF idx < 1 THEN
          LV.LINE_ARRAY[count] := 0;
        ELSE
          LV.LINE_ARRAY[count] := idx;
        END_IF;
      END_FOR;
    END_IF;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		LC :	us_LOG_CONTROL_80;
    LV :	us_LOG_VIEWPORT;

		func_block : LOG_VIEWPORT_Block;
	END_VAR
	func_block.LC := LC;
	func_block.LV := LV;

	func_block();
  LC  := func_block.LC;
  LV  := func_block.LV;


END_PROGRAM

