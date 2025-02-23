FUNCTION_BLOCK TN_INPUT_SELECT_POPUP

  VAR
    in_index :	INT;
    in_Element_Count :	INT;
    by_Cur_Key :	BYTE;
    by_Attr :	BYTE;
    st_String :	STRING;
  END_VAR

  VAR
    us_TN_MENU_POPUP :	us_TN_MENU_POPUP;
    FB_TN_INPUT_MENU_POPUP :	TN_INPUT_MENU_POPUP;
    FB_TN_SC_WRITE :	TN_SC_WRITE;
    FB_FIX :	FIX;
    ELEMENT_COUNT :	ELEMENT_COUNT;
    ELEMENT_GET :	ELEMENT_GET;
  END_VAR

  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
    Xus_TN_INPUT_CONTROL_DATA :	us_TN_INPUT_CONTROL_DATA;
  END_VAR

  IF (Xus_TN_INPUT_CONTROL_DATA.bo_Focus = TRUE) THEN

    by_Cur_Key := Xus_TN_INPUT_CONTROL_DATA.by_Input_Exten_Code;

    IF (us_TN_MENU_POPUP.bo_Activ = FALSE) THEN
      us_TN_MENU_POPUP.by_Input_Exten_Code := BYTE#00;

      IF (by_Cur_Key = BYTE#13) THEN
        us_TN_MENU_POPUP.in_Y         := Xus_TN_INPUT_CONTROL_DATA.in_Y;
        us_TN_MENU_POPUP.in_X         := Xus_TN_INPUT_CONTROL_DATA.in_X;
        us_TN_MENU_POPUP.by_Attr_mF   := Xus_TN_INPUT_CONTROL_DATA.by_Attr_mF;
        us_TN_MENU_POPUP.by_Attr_oF   := Xus_TN_INPUT_CONTROL_DATA.by_Attr_oF;
        us_TN_MENU_POPUP.st_Menu_Text := Xus_TN_INPUT_CONTROL_DATA.st_Input_Data;
        us_TN_MENU_POPUP.bo_Create    := TRUE;
        us_TN_MENU_POPUP.in_Cur_Item  := INT#00;
      END_IF;

      IF (us_TN_MENU_POPUP.in_Cur_Item > INT#00) THEN
        Xus_TN_INPUT_CONTROL_DATA.in_selected      := us_TN_MENU_POPUP.in_Cur_Item;
        Xus_TN_INPUT_CONTROL_DATA.bo_Input_Entered := TRUE;
        Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input  := TRUE;
        us_TN_MENU_POPUP.in_Cur_Item := INT#00;
      END_IF;

    ELSE
      us_TN_MENU_POPUP.by_Input_Exten_Code := by_Cur_Key;
    END_IF;

    FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP := us_TN_MENU_POPUP;
    FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN     := Xus_TN_SCREEN;
    FB_TN_INPUT_MENU_POPUP();
    us_TN_MENU_POPUP := FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP;
    Xus_TN_SCREEN    := FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN;

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

    ELEMENT_COUNT(SEP:=BYTE#35,ELEMENT:=Xus_TN_INPUT_CONTROL_DATA.st_Input_Data);
    Xus_TN_INPUT_CONTROL_DATA.st_Input_Data:=ELEMENT_COUNT.ELEMENT;
    in_Element_Count:=ELEMENT_COUNT.ELEMENT_COUNT;

    IF in_Element_Count > INT#00 THEN

      Xus_TN_INPUT_CONTROL_DATA.in_selected:=LIMIT_INT(1,Xus_TN_INPUT_CONTROL_DATA.in_selected,in_Element_Count);

      in_index := Xus_TN_INPUT_CONTROL_DATA.in_selected;

      ELEMENT_GET(ELEMENT:=Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,SEP:=BYTE#35,POS:=in_index-1);
      Xus_TN_INPUT_CONTROL_DATA.st_Input_Data:=ELEMENT_GET.ELEMENT;

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

      FB_TN_SC_WRITE.Iin_X         := Xus_TN_INPUT_CONTROL_DATA.in_X;
      FB_TN_SC_WRITE.Iin_Y         := Xus_TN_INPUT_CONTROL_DATA.in_Y;
      FB_TN_SC_WRITE.Iby_ATTR      := by_Attr;
      FB_TN_SC_WRITE.Ist_STRING    := st_String;
      FB_TN_SC_WRITE.Xus_TN_SCREEN := Xus_TN_SCREEN;
      FB_TN_SC_WRITE();
      Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

    END_IF;

    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_X := Xus_TN_INPUT_CONTROL_DATA.in_X;
    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Y := Xus_TN_INPUT_CONTROL_DATA.in_Y;

    Xus_TN_INPUT_CONTROL_DATA.bo_Update_All   := FALSE;
    Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := FALSE;

  END_IF;

END_FUNCTION_BLOCK
