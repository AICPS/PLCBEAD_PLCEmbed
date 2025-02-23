FUNCTION_BLOCK TN_INPUT_EDIT_LINE

  VAR
    in_count :	INT;
    in_Count_End :	INT;
    in_CursorOffset :	INT;
    by_Attr :	BYTE;
    st_String :	STRING;
    bo_Pos_Found :	BOOL;
    st_CHAR :	oscat_STRING1;
    in_old_charpos :	INT;
  END_VAR

  VAR
    FB_TN_SC_WRITE :	TN_SC_WRITE;
    CHR_TO_STRING :	CHR_TO_STRING;
    FB_TRIME :	TRIME;
  END_VAR

  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
    Xus_TN_INPUT_CONTROL_DATA :	us_TN_INPUT_CONTROL_DATA;
  END_VAR

  in_CursorOffset := INT#0;

  IF Xus_TN_INPUT_CONTROL_DATA.bo_Focus = TRUE THEN

    IF Xus_TN_INPUT_CONTROL_DATA.by_Input_ASCII_Code > BYTE#0 THEN

      IF (Xus_TN_INPUT_CONTROL_DATA.bo_Input_Only_Num = TRUE AND Xus_TN_INPUT_CONTROL_DATA.bo_Input_ASCII_IsNum = TRUE)
        OR (Xus_TN_INPUT_CONTROL_DATA.bo_Input_Only_Num = FALSE) THEN

        CHR_TO_STRING(C:=Xus_TN_INPUT_CONTROL_DATA.by_Input_ASCII_Code);
        st_CHAR:=CHR_TO_STRING.CHR_TO_STRING;

        Xus_TN_INPUT_CONTROL_DATA.st_Input_Data := REPLACE(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,
        st_CHAR,INT#1,Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos);

        in_CursorOffset := INT#1;
        Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
      END_IF;

    END_IF;

    CASE _BYTE_TO_INT(Xus_TN_INPUT_CONTROL_DATA.by_Input_Exten_Code) OF

    67: 
      in_CursorOffset := INT#1;

    68: 
      in_CursorOffset := INT#-1;  

    08: 
      Xus_TN_INPUT_CONTROL_DATA.st_Input_Data :=REPLACE(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,' ',INT#1,Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos);
      Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
      in_CursorOffset := INT#-1;

    13: 
      IF LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask) > INT#00 THEN
        Xus_TN_INPUT_CONTROL_DATA.st_Input_String := Xus_TN_INPUT_CONTROL_DATA.st_Input_Data;

        FB_TRIME(str:=Xus_TN_INPUT_CONTROL_DATA.st_Input_String);
        Xus_TN_INPUT_CONTROL_DATA.st_Input_String:=FB_TRIME.TRIME;

        Xus_TN_INPUT_CONTROL_DATA.bo_Input_Entered := TRUE;

        Xus_TN_INPUT_CONTROL_DATA.st_Input_Data := Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask;

        Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos := INT#1;
        Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;

        st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask,1,Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos);
        IF NE_STRING(st_CHAR,' ') THEN
          in_CursorOffset := INT#1;
        END_IF;
      END_IF;
    END_CASE;
  END_IF;

  IF (in_CursorOffset > INT#0) OR (Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos = INT#0) THEN
    bo_Pos_Found := FALSE;

    in_Count     := Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos + INT#1;
    in_Count_End := LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask);

    WHILE (in_count <= in_Count_End) AND (bo_Pos_Found = FALSE)  DO

      st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask,1,in_count);
      IF EQ_STRING(st_CHAR,' ') THEN
        Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos := in_count;
        Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
        bo_Pos_Found := TRUE;
      END_IF;

      in_count := in_count + INT#1;

    END_WHILE;

  END_IF;

  IF in_CursorOffset < INT#0 THEN
    bo_Pos_Found := FALSE;

    in_Count     := Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos - INT#01;
    in_Count_End := INT#1;

    WHILE (in_count >= in_Count_End) AND (bo_Pos_Found = FALSE) DO

      st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask,1,in_count);
      IF EQ_STRING(st_CHAR,' ') THEN
        Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos := in_count;
        Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
        bo_Pos_Found := TRUE;
      END_IF;

      in_count := in_count - INT#1;
    END_WHILE;

  END_IF;

  IF Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos > LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data) THEN
    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos := LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data);
    Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
  END_IF;

  IF Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos < INT#1 THEN
    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos := INT#1;
    Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := TRUE;
  END_IF;
  IF (Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input = TRUE) OR (Xus_TN_INPUT_CONTROL_DATA.bo_Update_All = TRUE) THEN

    IF (Xus_TN_INPUT_CONTROL_DATA.bo_Update_All = TRUE) THEN

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

    IF (Xus_TN_INPUT_CONTROL_DATA.bo_Input_Hidden = TRUE) THEN

      st_String := '';

      IF LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data) = LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask) THEN
        FOR in_count := 1 TO LEN(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data) DO

          st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Mask,1,in_count);

          IF EQ_STRING(st_CHAR,' ') THEN

            st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,1,in_count);

            IF EQ_STRING(st_CHAR,' ') THEN
              st_String := CONCAT(st_String,' ');

            ELSE
              st_String := CONCAT(st_String,'*');

            END_IF;

          ELSE
          st_CHAR := MID(Xus_TN_INPUT_CONTROL_DATA.st_Input_Data,1,in_count);
          st_String := CONCAT(st_String,st_CHAR);

          END_IF;
        END_FOR;
      END_IF;
    ELSE

      st_String := Xus_TN_INPUT_CONTROL_DATA.st_Input_Data;

    END_IF;
    
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

    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Y := Xus_TN_INPUT_CONTROL_DATA.in_Y;
    Xus_TN_INPUT_CONTROL_DATA.in_Cursor_X := Xus_TN_INPUT_CONTROL_DATA.in_X + Xus_TN_INPUT_CONTROL_DATA.in_Cursor_Pos - INT#1;

    in_old_charpos := INT#0;

    Xus_TN_INPUT_CONTROL_DATA.bo_Update_All   := FALSE;
    Xus_TN_INPUT_CONTROL_DATA.bo_Update_Input := FALSE;
  END_IF;

END_FUNCTION_BLOCK
