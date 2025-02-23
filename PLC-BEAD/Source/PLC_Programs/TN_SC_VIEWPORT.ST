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
		in_Page_Number:        	INT;                (* aktive Seiten-Nr.              *)
		in_Cursor_X:           	INT;                (* Cursor X-Position              *)
		in_Cursor_Y:           	INT;                (* Cursor Y-Position              *)    
		in_EOS_Offset:         	INT;                (* End of String Offset           *)
		by_Clear_Screen_Attr:  	BYTE;               (* Clear-Screen Attr              *)
		bo_Clear_Screen:       	BOOL;               (* Clear-Screen ausl�sen          *)
		bo_Modal_Dialog:       	BOOL;               (* Modaler Dialog ist aktiv       *)
		bo_Menue_Bar_Dialog:   	BOOL;               (* Menue Dialog ist aktiv         *)

  END_STRUCT;
END_TYPE

FUNCTION_BLOCK TN_SC_VIEWPORT_Block

  VAR
    FB_TN_SC_WRITE :	TN_SC_WRITE;
    FB_FIX :	FIX;
    FB_TON :	TON;
  END_VAR

  VAR
    in_index :	INT;
    in_Color :	INT;
    by_Attr :	BYTE;
    in_count :	INT;
  END_VAR

  VAR_IN_OUT
    Xus_LOG_VIEWPORT :	us_LOG_VIEWPORT;
    Xus_LOG_CONTROL :	us_LOG_CONTROL_80;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR


  VAR_INPUT
    Iin_X :	INT;
    Iin_Y :	INT;
    Iin_Width :	INT;
    Idw_ATTR_1 :	DWORD;
    Idw_ATTR_2 :	DWORD;
    Iti_TIME :	TIME;
  END_VAR

  IF Xus_LOG_VIEWPORT.UPDATE AND FB_TON.Q THEN

    Xus_LOG_VIEWPORT.UPDATE := FALSE;

    FOR in_count := 1 TO Xus_LOG_VIEWPORT.COUNT DO

      in_index := Xus_LOG_VIEWPORT.LINE_ARRAY[in_count];

    in_Color := DWORD_TO_INT(Xus_LOG_CONTROL.MSG_OPTION[in_index] AND DWORD#2#1111);

      CASE in_Color OF
        0..3: by_Attr := BYTE_OF_DWORD(Idw_ATTR_1,INT_TO_BYTE(in_Color));
        4..7: by_Attr := BYTE_OF_DWORD(Idw_ATTR_2,INT_TO_BYTE(in_Color));
      ELSE
      by_Attr := BYTE_OF_DWORD(Idw_ATTR_1,BYTE#0);
      END_CASE;

      FB_FIX.str := Xus_LOG_CONTROL.MSG[in_index];
      FB_FIX.L   := Iin_Width;
      FB_FIX.C   := BYTE#32;
      FB_FIX.M   := INT#00;
      FB_FIX();

      FB_TN_SC_WRITE.Iin_Y			:= Iin_Y + in_count - INT#01;
      FB_TN_SC_WRITE.Iin_X			:= Iin_X;
      FB_TN_SC_WRITE.Iby_ATTR			:= by_Attr;
      FB_TN_SC_WRITE.Ist_STRING		:= FB_FIX.FIX;
      FB_TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
      FB_TN_SC_WRITE();
      Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

    END_FOR;

    FB_TON.IN := FALSE;
    FB_TON.PT := Iti_TIME;
    FB_TON();

  END_IF;

  FB_TON.IN := TRUE;
  FB_TON.PT := Iti_TIME;
  FB_TON();

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Xus_LOG_VIEWPORT :	us_LOG_VIEWPORT;
    Xus_LOG_CONTROL :	us_LOG_CONTROL_80;
    Xus_TN_SCREEN :	us_TN_SCREEN;
    Iin_X :	INT;
    Iin_Y :	INT;
    Iin_Width :	INT;
    Idw_ATTR_1 :	DWORD;
    Idw_ATTR_2 :	DWORD;
    Iti_TIME :	TIME;

		func_block : TN_SC_VIEWPORT_Block;
	END_VAR
	func_block.Xus_LOG_VIEWPORT := Xus_LOG_VIEWPORT;
	func_block.Xus_LOG_CONTROL := Xus_LOG_CONTROL;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;
	func_block.Iin_X := Iin_X;
  func_block.Iin_Y := Iin_Y;
	func_block.Iin_Width := Iin_Width;
	func_block.Idw_ATTR_1 := Idw_ATTR_1;
	func_block.Idw_ATTR_2 := Idw_ATTR_2;
  func_block.Iti_TIME := Iti_TIME;

	func_block();
	Xus_LOG_VIEWPORT  := func_block.Xus_LOG_VIEWPORT;
  Xus_LOG_CONTROL  := func_block.Xus_LOG_CONTROL;
  Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION