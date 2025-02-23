FUNCTION_BLOCK TN_INPUT_MENU_POPUP

  VAR
    FB_TN_SC_AREA_SAVE :	TN_SC_AREA_SAVE;
    FB_TN_SC_AREA_RESTORE :	TN_SC_AREA_RESTORE;
    FB_TN_SC_LINE :	TN_SC_LINE;
    FB_TN_SC_ADD_SHADOW :	TN_SC_ADD_SHADOW;
    FB_TN_SC_BOX :	TN_SC_BOX;
    FB_TN_SC_WRITE_C :	TN_SC_WRITE_C;
    ELEMENT_COUNT :	ELEMENT_COUNT;
    ELEMENT_GET :	ELEMENT_GET;
  END_VAR

  VAR
    in_ROW :	INT;
    in_ROWS :	INT;
    in_COL :	INT;
    in_COLS :	INT;
    in_index :	INT;
    in_Count :	INT;
    in_Scroll_Offset :	INT;
    by_ATTR :	BYTE;
  END_VAR

  VAR_IN_OUT
    Xus_TN_MENU_POPUP :	us_TN_MENU_POPUP;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR

  IF (Xus_TN_MENU_POPUP.bo_Activ = FALSE) AND (Xus_TN_MENU_POPUP.bo_Create = TRUE) THEN
    Xus_TN_MENU_POPUP.bo_Activ         := TRUE;
    Xus_TN_MENU_POPUP.bo_Create        := FALSE;
    Xus_TN_MENU_POPUP.bo_Destroy       := FALSE;
    Xus_TN_MENU_POPUP.bo_Update        := TRUE;

    ELEMENT_COUNT(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35);
    Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_COUNT.ELEMENT;
    Xus_TN_MENU_POPUP.in_Menu_E_Count:=ELEMENT_COUNT.ELEMENT_COUNT;

    Xus_TN_MENU_POPUP.in_Rows := Xus_TN_MENU_POPUP.in_Menu_E_Count;

    Xus_TN_MENU_POPUP.in_Cols := INT#00;

    FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Rows DO;

      ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
      Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;
      Xus_TN_MENU_POPUP.in_Cols:=MAX_INT(LEN(ELEMENT_GET.ELEMENT_GET),Xus_TN_MENU_POPUP.in_Cols);

    END_FOR;

    IF (Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols) > INT#75 THEN
      Xus_TN_MENU_POPUP.in_X := INT#79 - Xus_TN_MENU_POPUP.in_Cols - INT#04;
    END_IF;

    IF (Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_ROWS) > INT#21 THEN
      Xus_TN_MENU_POPUP.in_Y := INT#23 - Xus_TN_MENU_POPUP.in_ROWS - INT#2;
    END_IF;

    Xus_TN_SCREEN.bo_Modal_Dialog := TRUE;

    FB_TN_SC_AREA_SAVE.Iin_X1        := Xus_TN_MENU_POPUP.in_X;
    FB_TN_SC_AREA_SAVE.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y;
    FB_TN_SC_AREA_SAVE.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#04;
    FB_TN_SC_AREA_SAVE.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#02;
    FB_TN_SC_AREA_SAVE.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_AREA_SAVE();
    Xus_TN_SCREEN := FB_TN_SC_AREA_SAVE.Xus_TN_SCREEN;

    FB_TN_SC_BOX.Iin_X1        := Xus_TN_MENU_POPUP.in_X;
    FB_TN_SC_BOX.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y;
    FB_TN_SC_BOX.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#03;
    FB_TN_SC_BOX.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#01;
    FB_TN_SC_BOX.Iby_FILL      := BYTE#32;         
    FB_TN_SC_BOX.Iin_BORDER    := INT#01;          
    FB_TN_SC_BOX.Iby_ATTR      := Xus_TN_MENU_POPUP.by_Attr_oF;
    FB_TN_SC_BOX.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_BOX();
    Xus_TN_SCREEN := FB_TN_SC_BOX.Xus_TN_SCREEN;

    FB_TN_SC_ADD_SHADOW.Iin_X1        := Xus_TN_MENU_POPUP.in_X + INT#1;
    FB_TN_SC_ADD_SHADOW.Iin_Y1        := Xus_TN_MENU_POPUP.in_Y + INT#1;
    FB_TN_SC_ADD_SHADOW.Iin_X2        := Xus_TN_MENU_POPUP.in_X + Xus_TN_MENU_POPUP.in_Cols + INT#04;
    FB_TN_SC_ADD_SHADOW.Iin_Y2        := Xus_TN_MENU_POPUP.in_Y + Xus_TN_MENU_POPUP.in_Rows + INT#02;
    FB_TN_SC_ADD_SHADOW.Iin_OPTION    := INT#00;
    FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_ADD_SHADOW();
    Xus_TN_SCREEN := FB_TN_SC_ADD_SHADOW.Xus_TN_SCREEN;

    in_COL  := Xus_TN_MENU_POPUP.in_X;
    in_ROW  := Xus_TN_MENU_POPUP.in_Y;
    in_ROWS := Xus_TN_MENU_POPUP.in_Rows;
    in_COLS := Xus_TN_MENU_POPUP.in_Cols;

    in_COLS := in_COLS + INT#02;   

    FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;
      in_ROW := in_ROW + INT#01;
    
      ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
    Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

      IF EQ_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN

        FB_TN_SC_LINE.Iin_Y1			:= in_ROW;
        FB_TN_SC_LINE.Iin_X1			:= in_COL;
        FB_TN_SC_LINE.Iin_Y2			:= in_ROW;
        FB_TN_SC_LINE.Iin_X2			:= in_COL + in_COLS + INT#01;
        FB_TN_SC_LINE.Iby_ATTR		:= Xus_TN_MENU_POPUP.by_Attr_oF;
        FB_TN_SC_LINE.Iby_BORDER		:= BYTE#01;
        FB_TN_SC_LINE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
        FB_TN_SC_LINE();
        Xus_TN_SCREEN := FB_TN_SC_LINE.Xus_TN_SCREEN;

      END_IF;
    END_FOR;
  END_IF;

  IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) THEN

    CASE _BYTE_TO_INT(Xus_TN_MENU_POPUP.by_Input_Exten_Code) OF

    65:
      in_Scroll_Offset := INT#-1;
      Xus_TN_MENU_POPUP.bo_Update := TRUE;

    66: 
      in_Scroll_Offset := INT#1;
      Xus_TN_MENU_POPUP.bo_Update := TRUE;

    13: 
      Xus_TN_MENU_POPUP.bo_Destroy := TRUE;

    27:  
      Xus_TN_MENU_POPUP.bo_Destroy := TRUE;
      Xus_TN_MENU_POPUP.in_Cur_Item := INT#00;

    67..68:  
      Xus_TN_MENU_POPUP.bo_Destroy := TRUE;
      Xus_TN_MENU_POPUP.in_Cur_Item := INT#00;

    END_CASE;

  END_IF;

  IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) AND (Xus_TN_MENU_POPUP.bo_Update = TRUE) THEN

    Xus_TN_MENU_POPUP.bo_Update := FALSE; 

    in_index := Xus_TN_MENU_POPUP.in_Cur_Item;

    IF (in_index < INT#01) OR (in_index > Xus_TN_MENU_POPUP.in_Menu_E_Count) THEN
      in_Scroll_Offset := INT#01;
      in_index := Xus_TN_MENU_POPUP.in_Menu_E_Count;
    END_IF;

    ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_index-1);
    Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

    IF EQ_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN
      in_Scroll_Offset := INT#01;
    END_IF;

    IF in_Scroll_Offset <> INT#00 THEN

      FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;

        in_index:=INC2(in_index,in_Scroll_Offset,1,Xus_TN_MENU_POPUP.in_Menu_E_Count);

        ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_index-1);
        Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

        IF NE_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN
          EXIT;
        END_IF;

      END_FOR;
    END_IF;

    Xus_TN_MENU_POPUP.in_Cur_Item := in_index;
    in_Scroll_Offset := INT#00;

    in_COL  := Xus_TN_MENU_POPUP.in_X;
    in_ROW  := Xus_TN_MENU_POPUP.in_Y;
    in_ROWS := Xus_TN_MENU_POPUP.in_Rows;
    in_COLS := Xus_TN_MENU_POPUP.in_Cols;

    in_COLS := in_COLS + INT#02;   

    FOR in_Count := INT#01 TO Xus_TN_MENU_POPUP.in_Menu_E_Count DO;

      in_ROW := in_ROW + INT#01;

      IF in_Count = Xus_TN_MENU_POPUP.in_Cur_Item THEN
        by_ATTR := Xus_TN_MENU_POPUP.by_Attr_mF;
      ELSE
        by_ATTR := Xus_TN_MENU_POPUP.by_Attr_oF;
      END_IF;

      ELEMENT_GET(ELEMENT:=Xus_TN_MENU_POPUP.st_Menu_Text,SEP:=BYTE#35,POS:=in_Count-1);
      Xus_TN_MENU_POPUP.st_Menu_Text:=ELEMENT_GET.ELEMENT;

      IF NE_STRING(ELEMENT_GET.ELEMENT_GET,'-') THEN

        FB_TN_SC_WRITE_C.Iin_Y         := in_ROW;
        FB_TN_SC_WRITE_C.Iin_X         := in_COL + INT#01;
        FB_TN_SC_WRITE_C.Iby_ATTR      := by_ATTR;
        FB_TN_SC_WRITE_C.Iin_LENGTH    := in_COLS;
        FB_TN_SC_WRITE_C.Iin_OPTION    := INT#02; 
        FB_TN_SC_WRITE_C.Ist_STRING    := ELEMENT_GET.ELEMENT_GET;
        FB_TN_SC_WRITE_C.Xus_TN_SCREEN := Xus_TN_SCREEN;
        FB_TN_SC_WRITE_C();
        Xus_TN_SCREEN := FB_TN_SC_WRITE_C.Xus_TN_SCREEN;

      END_IF;
    END_FOR;
  END_IF;

  IF (Xus_TN_MENU_POPUP.bo_Activ = TRUE) AND (Xus_TN_MENU_POPUP.bo_Destroy = TRUE) THEN

    Xus_TN_MENU_POPUP.bo_Destroy := FALSE;
    Xus_TN_MENU_POPUP.bo_Activ   := FALSE;

    FB_TN_SC_AREA_RESTORE.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_AREA_RESTORE();
    Xus_TN_SCREEN := FB_TN_SC_AREA_RESTORE.Xus_TN_SCREEN;
  
    Xus_TN_SCREEN.bo_Modal_Dialog := FALSE;
  END_IF;

END_FUNCTION_BLOCK
