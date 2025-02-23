TYPE
  bya_TN_CHAR:       	ARRAY [0..1919] OF BYTE;
  bya_TN_BACKUP:     	ARRAY [0..1919] OF BYTE;
  bya_TN_COLOR:      	ARRAY [0..1919] OF BYTE;
  bya_TN_Line_Update:	ARRAY [0..23]   OF BOOL;

  us_TN_SCREEN :
  STRUCT
		bya_CHAR:			bya_TN_CHAR;
		bya_COLOR:			bya_TN_COLOR;
		bya_BACKUP:			bya_TN_BACKUP;
		bya_Line_Update:	bya_TN_Line_Update;

		by_Input_Exten_Code:    BYTE;
		by_Input_ASCII_Code:    BYTE;
		bo_Input_ASCII_IsNum:   BOOL;
		in_Page_Number:        	INT;                
		in_Cursor_X:           	INT;               
		in_Cursor_Y:           	INT;                  
		in_EOS_Offset:         	INT;                
		by_Clear_Screen_Attr:  	BYTE;               
		bo_Clear_Screen:       	BOOL;              
		bo_Modal_Dialog:       	BOOL;              
		bo_Menue_Bar_Dialog:   	BOOL;               

  END_STRUCT;
END_TYPE

TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

  oscat_NETWORK_BUFFER :
  STRUCT
    SIZE   : UINT;	
    BUFFER : oscat_NW_BUF_LONG;
  END_STRUCT;
END_TYPE

FUNCTION ISC_NUM:BOOL

	VAR_INPUT
		IN :	BYTE;
	END_VAR

	ISC_NUM := IN > BYTE#47 AND IN < BYTE#58;

END_FUNCTION

FUNCTION_BLOCK TN_RECEIVE_Block

  VAR_IN_OUT
    R_BUF :	oscat_NETWORK_BUFFER;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR

  VAR
    REQ_Size :	UINT;
    REQ1 :	BYTE;
    REQ2 :	BYTE;
    REQ3 :	BYTE;
  END_VAR

  Xus_TN_SCREEN.by_Input_ASCII_Code := BYTE#00;
  Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;

  IF R_BUF.SIZE > UINT#0 THEN
    REQ_Size := R_BUF.SIZE;
    REQ1 := R_BUF.BUFFER[0];
    REQ2 := R_BUF.BUFFER[1];
    REQ3 := R_BUF.BUFFER[2];

    IF REQ1 = BYTE#27 AND REQ_Size >= UINT#3 THEN
      IF REQ2 = BYTE#91 THEN 
        IF (REQ3 >= BYTE#65 AND REQ3 <= BYTE#68) OR (REQ3 = BYTE#72) OR (REQ3 = BYTE#75) THEN 
          Xus_TN_SCREEN.by_Input_Exten_Code := REQ3;
        END_IF;
      ELSIF REQ2 = BYTE#79 THEN 
        IF REQ3 >= BYTE#80 AND REQ3 <= BYTE#83 THEN
          Xus_TN_SCREEN.by_Input_Exten_Code := REQ3; 
        END_IF;
      END_IF;    
    ELSIF REQ1 >= BYTE#32 AND REQ1 <= BYTE#126 THEN
    Xus_TN_SCREEN.by_Input_ASCII_Code := REQ1;
      Xus_TN_SCREEN.bo_Input_ASCII_IsNum := ISC_NUM(REQ1);
    ELSIF REQ1 = BYTE#8 OR REQ1 = BYTE#9 OR REQ1 = BYTE#13 OR REQ1 = BYTE#27 THEN 
    Xus_TN_SCREEN.by_Input_Exten_Code := REQ1;
    END_IF;

    R_BUF.SIZE := UINT#00;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		R_BUF :	oscat_NETWORK_BUFFER;
    Xus_TN_SCREEN :	us_TN_SCREEN;

		func_block : TN_RECEIVE_Block;
	END_VAR
	func_block.R_BUF := R_BUF;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
  R_BUF  := func_block.R_BUF;
	Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION