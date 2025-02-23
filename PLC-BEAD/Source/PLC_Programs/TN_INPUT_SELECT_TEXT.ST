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

FUNCTION_BLOCK TN_INPUT_SELECT_TEXT_Block

  VAR
    in_count :	INT;
    by_Attr :	BYTE;
    st_String :	STRING;
  END_VAR

  VAR
    FB_FIX :	FIX;
    FB_TN_SC_WRITE :	TN_SC_WRITE;
    ELEMENT_COUNT :	ELEMENT_COUNT;
    ELEMENT_GET :	ELEMENT_GET;
  END_VAR

  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
    Xus_TN_INPUT_CONTROL_DATA :	us_TN_INPUT_CONTROL_DATA;
  END_VAR

  IF Xus_TN_INPUT_CONTROL_DATA.bo_Focus = TRUE THEN

    IF Xus_TN_INPUT_CONTROL_DATA.by_Input_ASCII_Code = BYTE#32 THEN
      Xus_TN_INPUT_CONTROL_DATA.in_selected := Xus_TN_INPUT_CONTROL_DATA.in_selected + INT#01; 
      Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
    END_IF;

    IF Xus_TN_INPUT_CONTROL_DATA.by_Input_Exten_Code = BYTE#13 THEN
      Xus_TN_INPUT_CONTROL_DATA.bo_Input_Entered := TRUE;
    END_IF;

  END_IF;

  IF (Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input = TRUE) OR (Xus_TN_INPUT_CONTROL_DATA.bo_Update_All = TRUE) THEN

    IF Xus_TN_INPUT_CONTROL_DATA.bo_Update_All = TRUE THEN

      IF (Xus_TN_INPUT_CONTROL_DATA.in_Title_X_Offset = INT#00) AND (Xus_TN_INPUT_CONTROL_DATA.in_Title_Y_Offset = INT#00) THEN

        FB_TN_SC_WRITE.Iin_Y := Xus_TN_INPUT_CONTROL_DATA.in_Y;
        FB_TN_SC_WRITE.Iin_X := Xus_TN_INPUT_CONTROL_DATA.in_X - LEN(Xus_TN_INPUT_CONTROL_DATA.st_Title_String);

      ELSE
        FB_TN_SC_WRITE.Iin_Y := Xus_TN_INPUT_CONTROL_DATA.in_Y + Xus_TN_INPUT_CONTROL_DATA.in_Title_Y_Offset;
        FB_TN_SC_WRITE.Iin_X := Xus_TN_INPUT_CONTROL_DATA.in_X + Xus_TN_INPUT_CONTROL_DATA.in_Title_X_Offset;

      END_IF;

      FB_TN_SC_WRITE.Iby_ATTR      := Xus_TN_INPUT_CONTROL_DATA.by_Title_Attr;
      FB_TN_SC_WRITE.Ist_STRING    := Xus_TN_INPUT_CONTROL_DATA.st_Title_String;
      FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
      FB_TN_SC_WRITE();
      Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

    END_IF;

    ELEMENT_COUNT(ELEMENT:=Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,SEP:=BYTE#35);
    Xus_TN_INPUT_CONTROL_DATA.st_Input_Data:=ELEMENT_COUNT.ELEMENT;
    in_count:=ELEMENT_COUNT.ELEMENT_COUNT;

    IF in_Count > INT#00 THEN

      IF Xus_TN_INPUT_CONTROL_DATA.in_selected < INT#1 THEN
        Xus_TN_INPUT_CONTROL_DATA.in_selected := INT#01;
      END_IF;

      IF Xus_TN_INPUT_CONTROL_DATA.in_selected > in_count THEN
        Xus_TN_INPUT_CONTROL_DATA.in_selected := INT#01;
      END_IF;

      ELEMENT_GET(ELEMENT:=Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,SEP:=BYTE#35,POS:=Xus_TN_INPUT_CONTROL_DATA.in_selected-1);
      Xus_TN_INPUT_CONTROL_DATA.st_Input_Data := ELEMENT_GET.ELEMENT;
      st_String:=ELEMENT_GET.ELEMENT_GET;

      FB_FIX.str:=st_String;
    FB_FIX.L:=LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask);
    FB_FIX.C:=BYTE#32;
    FB_FIX.M:=Xus_TN_INPUT_CONTROL_DATA.in_Input_Option;
      FB_FIX();
      st_String:=FB_FIX.FIX;

      Xus_TN_INPUT_CONTROL_DATA.st_Input_String := st_String;

      IF Xus_TN_INPUT_CONTROL_DATA.bo_Focus = TRUE THEN
        by_Attr := Xus_TN_INPUT_CONTROL_DATA.by_Attr_mF;
      ELSE
        by_Attr := Xus_TN_INPUT_CONTROL_DATA.by_Attr_oF;
      END_IF;

      FB_TN_SC_WRITE.Iin_Y         := Xus_TN_INPUT_CONTROL_DATA.in_Y;
      FB_TN_SC_WRITE.Iin_X         := Xus_TN_INPUT_CONTROL_DATA.in_X;
      FB_TN_SC_WRITE.Iby_ATTR      := by_Attr;
      FB_TN_SC_WRITE.Ist_STRING    := st_String;
      FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
      FB_TN_SC_WRITE();
      Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

    END_IF;

    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Y := Xus_TN_INPUT_CONTROL_DATA.in_Y;
    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_X := Xus_TN_INPUT_CONTROL_DATA.in_X;

    Xus_TN_INPUT_CONTROL_DATA.bo_Update_All   := FALSE;
    Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := FALSE;

  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Xus_TN_SCREEN :	us_TN_SCREEN;
    Xus_TN_INPUT_CONTROL_DATA :	us_TN_INPUT_CONTROL_DATA;

		func_block : TN_INPUT_SELECT_TEXT_Block;
	END_VAR
	func_block.Xus_TN_INPUT_CONTROL_DATA := Xus_TN_INPUT_CONTROL_DATA;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
  Xus_TN_INPUT_CONTROL_DATA  := func_block.Xus_TN_INPUT_CONTROL_DATA;
	Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION