FUNCTION_BLOCK TN_INPUT_CONTROL

  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
    Xus_TN_INPUT_CONTROL :	us_TN_INPUT_CONTROL;
  END_VAR


  VAR
    FB_TN_INPUT_SELECT_POPUP :	TN_INPUT_SELECT_POPUP;
  END_VAR

  VAR
    FB_TN_INPUT_SELECT_TEXT :	TN_INPUT_SELECT_TEXT;
    FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
    FB_TN_INPUT_EDIT_LINE :	TN_INPUT_EDIT_LINE;
  END_VAR

  VAR
    in_index :	INT;
    in_Scroll_Offset :	INT;
    in_Focus_new :	INT;
    in_Focus_alt :	INT;
    bo_Tool_Tip_Update :	BOOL;
  END_VAR

  IF (Xus_TN_INPUT_CONTROL.bo_Enable = FALSE) OR (Xus_TN_SCREEN.bo_Menue_Bar_Dialog = TRUE) THEN
    RETURN;
  END_IF;

  IF (Xus_TN_INPUT_CONTROL.bo_Reset_Fokus = TRUE) THEN

    Xus_TN_INPUT_CONTROL.bo_Reset_Fokus := FALSE;

    FOR in_index := INT#01 TO Xus_TN_INPUT_CONTROL.in_Count DO
      Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].bo_Focus := FALSE;
    END_FOR;

    IF (Xus_TN_INPUT_CONTROL.in_Count >= INT#01) THEN

      Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[1].bo_Focus := TRUE;
      Xus_TN_INPUT_CONTROL.in_Focus_at := INT#01;

    END_IF;

    Xus_TN_INPUT_CONTROL.bo_Update_all := TRUE;

  END_IF;

  IF (Xus_TN_SCREEN.bo_Modal_Dialog = FALSE) THEN

    IF (Xus_TN_SCREEN.by_Input_Exten_Code = BYTE#09) THEN

      in_Scroll_Offset := INT#01;

    ELSIF (Xus_TN_SCREEN.by_Input_Exten_Code = BYTE#65) THEN

      in_Scroll_Offset := INT#-01;

    ELSIF (Xus_TN_SCREEN.by_Input_Exten_Code = BYTE#66) THEN

      in_Scroll_Offset := INT#01;

    END_IF;
  END_IF;

  IF (in_Scroll_Offset <> INT#00) THEN  

    Xus_TN_INPUT_CONTROL.in_Focus_at:=LIMIT_INT(INT#01,Xus_TN_INPUT_CONTROL.in_Focus_at,Xus_TN_INPUT_CONTROL.in_Count);

    in_Focus_new := Xus_TN_INPUT_CONTROL.in_Focus_at + in_Scroll_Offset;

    IF (in_Focus_new > Xus_TN_INPUT_CONTROL.in_Count) THEN
      in_Focus_new := INT#1;
    END_IF;

    IF (in_Focus_new < INT#01) THEN
      in_Focus_new := Xus_TN_INPUT_CONTROL.in_Count;
    END_IF;

    in_Focus_alt := Xus_TN_INPUT_CONTROL.in_Focus_at;

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_Focus_alt].bo_Focus := FALSE;
    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_Focus_alt].bo_Update_Input := TRUE;

    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_Focus_new].bo_Focus  := TRUE;
    Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_Focus_new].bo_Update_Input := TRUE;


    Xus_TN_INPUT_CONTROL.in_Focus_at := in_Focus_new;

    bo_Tool_Tip_Update := TRUE;
    in_Scroll_Offset := INT#00;

  END_IF;

  IF (Xus_TN_INPUT_CONTROL.bo_Update_all = TRUE) THEN
    FOR in_index := 1 TO Xus_TN_INPUT_CONTROL.in_Count DO
      Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].bo_Update_All := TRUE;
    END_FOR;
    Xus_TN_INPUT_CONTROL.bo_Update_all := FALSE;
    bo_Tool_Tip_Update := TRUE;
  END_IF;

  FOR in_index := 1 TO Xus_TN_INPUT_CONTROL.in_Count DO

    IF (Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].in_Type > INT#00) THEN
  
      IF (Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].bo_Focus = TRUE) THEN

        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].by_Input_ASCII_Code  := Xus_TN_SCREEN.by_Input_ASCII_Code;
        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].by_Input_Exten_Code  := Xus_TN_SCREEN.by_Input_Exten_Code;
        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].bo_Input_ASCII_IsNum := Xus_TN_SCREEN.bo_Input_ASCII_IsNum;

        IF (bo_Tool_Tip_Update = TRUE) THEN

          FB_TN_SC_WRITE_C.Iin_Y          := Xus_TN_INPUT_CONTROL.in_ToolTip_Y;
          FB_TN_SC_WRITE_C.Iin_X          := Xus_TN_INPUT_CONTROL.in_ToolTip_X;
          FB_TN_SC_WRITE_C.Iby_ATTR       := Xus_TN_INPUT_CONTROL.by_ToolTip_Attr;
          FB_TN_SC_WRITE_C.Iin_OPTION     := INT#02;  
          FB_TN_SC_WRITE_C.Iin_LENGTH     := Xus_TN_INPUT_CONTROL.in_ToolTip_Size;
          FB_TN_SC_WRITE_C.Ist_STRING     := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].st_Input_ToolTip;
          FB_TN_SC_WRITE_C.Xus_TN_SCREEN  := Xus_TN_SCREEN;
          FB_TN_SC_WRITE_C();
          Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

          bo_Tool_Tip_Update := FALSE;

        END_IF;

      END_IF;

      CASE Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].in_Type OF

      1:
        FB_TN_INPUT_EDIT_LINE.Xus_TN_INPUT_CONTROL_DATA := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index];
        FB_TN_INPUT_EDIT_LINE.Xus_TN_SCREEN             := Xus_TN_SCREEN;
        FB_TN_INPUT_EDIT_LINE();
        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index]  := FB_TN_INPUT_EDIT_LINE.Xus_TN_INPUT_CONTROL_DATA;
        Xus_TN_SCREEN                                             := FB_TN_INPUT_EDIT_LINE.Xus_TN_SCREEN;

      2: 
        FB_TN_INPUT_SELECT_TEXT.Xus_TN_INPUT_CONTROL_DATA := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index];
        FB_TN_INPUT_SELECT_TEXT.Xus_TN_SCREEN             := Xus_TN_SCREEN;
        FB_TN_INPUT_SELECT_TEXT();
        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index] := FB_TN_INPUT_SELECT_TEXT.Xus_TN_INPUT_CONTROL_DATA;
        Xus_TN_SCREEN                                            := FB_TN_INPUT_SELECT_TEXT.Xus_TN_SCREEN;
      3: 
        FB_TN_INPUT_SELECT_POPUP.Xus_TN_INPUT_CONTROL_DATA := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index];
        FB_TN_INPUT_SELECT_POPUP.Xus_TN_SCREEN             := Xus_TN_SCREEN;
        FB_TN_INPUT_SELECT_POPUP();
        Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index] := FB_TN_INPUT_SELECT_POPUP.Xus_TN_INPUT_CONTROL_DATA;
        Xus_TN_SCREEN                                            := FB_TN_INPUT_SELECT_POPUP.Xus_TN_SCREEN;

      END_CASE;

      IF (Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].bo_Focus = TRUE) THEN

        Xus_TN_SCREEN.in_Cursor_X := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].in_Cursor_X;
        Xus_TN_SCREEN.in_Cursor_Y := Xus_TN_INPUT_CONTROL.usa_TN_INPUT_CONTROL_DATA[in_index].in_Cursor_Y;

      END_IF;
    END_IF;
  END_FOR;

END_FUNCTION_BLOCK
