FUNCTION_BLOCK TN_INPUT_MENU_BAR

  VAR
    FB_TN_INPUT_MENU_POPUP :	TN_INPUT_MENU_POPUP;
    us_TN_MENU_POPUP :	us_TN_MENU_POPUP;
    FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
    ELEMENT_COUNT :	ELEMENT_COUNT;
    ELEMENT_GET :	ELEMENT_GET;
  END_VAR

  VAR
    in_ROW :	INT;
    in_COL :	INT;
    in_TITLE_Length :	INT;
    st_MENU_BAR :	oscat_STRING250;
    st_MENU_TITLE :	STRING;
    in_Count :	INT;
    in_Index :	INT;
    by_New_KeyCode :	BYTE;
    in_Scroll_Offset :	INT;
    by_ATTR :	BYTE;
    bo_Reset_Position :	BOOL;
  END_VAR

  VAR_IN_OUT
    Xus_TN_MENU :	us_TN_MENU;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR

  IF (Xus_TN_MENU.in_State = INT#00) AND (Xus_TN_MENU.bo_Create = TRUE) THEN
    Xus_TN_MENU.in_State			:= INT#01;
    Xus_TN_MENU.bo_Create			:= FALSE;
    Xus_TN_MENU.in_Menu_Selected	:= INT#00;
    Xus_TN_MENU.bo_Update			:= TRUE;
    bo_Reset_Position				:= TRUE;

    ELEMENT_GET(ELEMENT:=Xus_TN_MENU.st_MENU_TEXT,SEP:=BYTE#37,POS:=0);
    Xus_TN_MENU.st_MENU_TEXT:=ELEMENT_GET.ELEMENT;
    st_MENU_BAR:=ELEMENT_GET.ELEMENT_GET;

    ELEMENT_COUNT(SEP:=BYTE#35,ELEMENT:=st_MENU_BAR);
    st_MENU_BAR:=ELEMENT_COUNT.ELEMENT;
    Xus_TN_MENU.in_Menu_E_Count:=ELEMENT_COUNT.ELEMENT_COUNT;

  END_IF;

  by_New_KeyCode := Xus_TN_SCREEN.by_Input_Exten_Code;

  IF (by_New_KeyCode = BYTE#65) OR (by_New_KeyCode = BYTE#66) THEN
    us_TN_MENU_POPUP.by_Input_Exten_Code := by_New_KeyCode;
  ELSE
    us_TN_MENU_POPUP.by_Input_Exten_Code := BYTE#00;
  END_IF;

  IF (by_New_KeyCode = BYTE#27) THEN
    IF (Xus_TN_MENU.in_State = INT#01) AND (Xus_TN_SCREEN.bo_Modal_Dialog = FALSE) THEN
      Xus_TN_MENU.in_State := INT#02;
      Xus_TN_MENU.bo_Update := TRUE;
      Xus_TN_MENU.in_Menu_Selected := INT#00;

      Xus_TN_SCREEN.bo_Menue_Bar_Dialog := TRUE;

    ELSIF (Xus_TN_MENU.in_State = INT#02) THEN
      us_TN_MENU_POPUP.bo_Destroy	:= TRUE;
      Xus_TN_MENU.bo_Update		:= TRUE;
      Xus_TN_MENU.in_State		:= INT#01;
      bo_Reset_Position			:= TRUE;

      Xus_TN_SCREEN.bo_Menue_Bar_Dialog := FALSE;

    END_IF;
  END_IF;

  IF (Xus_TN_MENU.in_State = INT#02) THEN

    IF (by_New_KeyCode = BYTE#13)  THEN
      us_TN_MENU_POPUP.bo_Destroy	:= TRUE;
      Xus_TN_MENU.bo_Update		:= TRUE;
      Xus_TN_MENU.in_State		:= INT#01;
      bo_Reset_Position			:= TRUE;
      Xus_TN_MENU.in_Menu_Selected := (Xus_TN_MENU.in_Cur_Menu_Item * INT#10) + Xus_TN_MENU.in_Cur_Sub_Item;
      Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;

      Xus_TN_SCREEN.bo_Menue_Bar_Dialog := FALSE;

    ELSIF (Xus_TN_MENU.bo_Destroy = TRUE) THEN
      us_TN_MENU_POPUP.bo_Destroy  := TRUE;
      Xus_TN_MENU.bo_Update        := TRUE;
      Xus_TN_MENU.in_State         := INT#01;
      bo_Reset_Position			 := TRUE;
      Xus_TN_MENU.in_Menu_Selected := INT#00;
      Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;

      Xus_TN_SCREEN.bo_Menue_Bar_Dialog := FALSE;

    END_IF;

    IF (by_New_KeyCode = BYTE#67) THEN 
      in_Scroll_Offset := INT#1;
      Xus_TN_MENU.bo_Update := TRUE;
      Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;

    ELSIF (by_New_KeyCode = BYTE#68) THEN  
      in_Scroll_Offset := INT#-1;
      Xus_TN_MENU.bo_Update := TRUE;
      Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;
    END_IF;

  END_IF;

  IF bo_Reset_Position = TRUE THEN
    bo_Reset_Position := FALSE;
    Xus_TN_MENU.in_X_SM_old := INT#-1;
    Xus_TN_MENU.in_Y_SM_old := INT#-1;
    Xus_TN_MENU.in_X_SM_new := INT#-1;
    Xus_TN_MENU.in_Y_SM_new := INT#-1;
  END_IF;

  IF (Xus_TN_MENU.in_State > INT#00) AND (Xus_TN_MENU.bo_Update = TRUE) THEN

    Xus_TN_MENU.bo_Update := FALSE; 

    in_ROW := Xus_TN_MENU.in_Y;
    in_COL := Xus_TN_MENU.in_X;

    IF in_Scroll_Offset <> INT#00 THEN
      Xus_TN_MENU.in_Cur_Menu_Item := INC2(Xus_TN_MENU.in_Cur_Menu_Item,in_Scroll_Offset,1,Xus_TN_MENU.in_Menu_E_Count);
      in_Scroll_Offset := INT#00;
    ELSE
      IF (Xus_TN_MENU.in_Cur_Menu_Item = INT#00) THEN
        Xus_TN_MENU.in_Cur_Menu_Item := INT#01;
      END_IF;
    END_IF;

    FOR in_Count := INT#01 TO Xus_TN_MENU.in_Menu_E_Count DO;

      IF (in_Count = Xus_TN_MENU.in_Cur_Menu_Item) AND (Xus_TN_MENU.in_State > INT#01 ) THEN
        by_ATTR := Xus_TN_MENU.by_Attr_mF;

        Xus_TN_MENU.in_Y_SM_new := in_ROW + INT#01;
        Xus_TN_MENU.in_X_SM_new := in_COL;

      ELSE
        by_ATTR := Xus_TN_MENU.by_Attr_oF;
      END_IF;

      ELEMENT_GET(ELEMENT:=st_MENU_BAR,SEP:=BYTE#35,POS:=in_Count-1);
    st_MENU_BAR:=ELEMENT_GET.ELEMENT;
      st_MENU_TITLE:=ELEMENT_GET.ELEMENT_GET;

      in_TITLE_Length := LEN(st_MENU_TITLE) + INT#02;

      FB_TN_SC_WRITE_C.Iin_Y         := in_ROW;
      FB_TN_SC_WRITE_C.Iin_X         := in_COL;
      FB_TN_SC_WRITE_C.Iby_ATTR      := by_ATTR;
      FB_TN_SC_WRITE_C.Iin_LENGTH    := in_TITLE_Length;
      FB_TN_SC_WRITE_C.Iin_OPTION    := INT#02;  
      FB_TN_SC_WRITE_C.Ist_STRING    := st_MENU_TITLE;
      FB_TN_SC_WRITE_C.Xus_TN_SCREEN := Xus_TN_SCREEN;
      FB_TN_SC_WRITE_C();
      Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

      in_COL := in_COL + in_TITLE_Length;

    END_FOR;

  END_IF;

  IF Xus_TN_MENU.in_X_SM_new <> Xus_TN_MENU.in_X_SM_old THEN

    IF us_TN_MENU_POPUP.bo_Activ = TRUE THEN
      us_TN_MENU_POPUP.bo_Destroy := TRUE;

      FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP := us_TN_MENU_POPUP;
      FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN     := Xus_TN_SCREEN;
      FB_TN_INPUT_MENU_POPUP();
      us_TN_MENU_POPUP := FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP;
      Xus_TN_SCREEN    := FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN;

    END_IF;

    IF us_TN_MENU_POPUP.bo_Activ = FALSE THEN
      in_Index := Xus_TN_MENU.in_Cur_Menu_Item;

      ELEMENT_GET(ELEMENT:=Xus_TN_MENU.st_MENU_TEXT,SEP:=BYTE#37,POS:=in_Index);
    Xus_TN_MENU.st_MENU_TEXT:=ELEMENT_GET.ELEMENT;

      us_TN_MENU_POPUP.in_Y         := Xus_TN_MENU.in_Y_SM_new;
      us_TN_MENU_POPUP.in_X         := Xus_TN_MENU.in_X_SM_new;
      us_TN_MENU_POPUP.by_Attr_mF   := Xus_TN_MENU.by_Attr_mF;
      us_TN_MENU_POPUP.by_Attr_oF   := Xus_TN_MENU.by_Attr_oF;
      us_TN_MENU_POPUP.st_Menu_Text := ELEMENT_GET.ELEMENT_GET;
      us_TN_MENU_POPUP.bo_Create    := TRUE;

      Xus_TN_MENU.in_X_SM_old := Xus_TN_MENU.in_X_SM_new;
      Xus_TN_MENU.in_Y_SM_old := Xus_TN_MENU.in_Y_SM_new;

    END_IF;

  END_IF;

  FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP := us_TN_MENU_POPUP;
  FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN     := Xus_TN_SCREEN;
  FB_TN_INPUT_MENU_POPUP();
  us_TN_MENU_POPUP := FB_TN_INPUT_MENU_POPUP.Xus_TN_MENU_POPUP;
  Xus_TN_SCREEN    := FB_TN_INPUT_MENU_POPUP.Xus_TN_SCREEN;

  Xus_TN_MENU.in_Cur_Sub_Item := us_TN_MENU_POPUP.in_Cur_Item;

  IF (Xus_TN_MENU.in_State = INT#01) THEN
    IF (Xus_TN_MENU.bo_Destroy = TRUE) THEN

      Xus_TN_MENU.in_State         := INT#00;
      Xus_TN_MENU.bo_Destroy       := FALSE;
      Xus_TN_MENU.in_Cur_Menu_Item := INT#00;
      Xus_TN_MENU.in_Cur_Sub_Item  := INT#00;

    END_IF;
  END_IF;

END_FUNCTION_BLOCK
