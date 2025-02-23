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
		in_Cursor_X:           	INT;                (* Cursor X-POSition              *)
		in_Cursor_Y:           	INT;                (* Cursor Y-POSition              *)    
		in_EOS_Offset:         	INT;                (* End of String Offset           *)
		by_Clear_Screen_Attr:  	BYTE;               (* Clear-Screen Attr              *)
		bo_Clear_Screen:       	BOOL;               (* Clear-Screen ausl�sen          *)
		bo_Modal_Dialog:       	BOOL;               (* Modaler Dialog ist aktiv       *)
		bo_Menue_Bar_Dialog:   	BOOL;               (* Menue Dialog ist aktiv         *)

  END_STRUCT;
END_TYPE

FUNCTION TN_SC_XY2_ERROR:BOOL

	VAR_INPUT
		X1 :	INT;
		Y1 :	INT;
		X2 :	INT;
		Y2 :	INT;
	END_VAR

	TN_SC_XY2_ERROR := Y1 < 0 OR X1 < 0 OR Y2 < 0 OR X2 < 0 OR Y1 > 23 OR X1 > 79 OR Y2 > 23 OR X2 > 79;

END_FUNCTION

FUNCTION_BLOCK TN_SC_LINE_Block

  VAR
    by_Connect_Left_CHAR :	BYTE;
    by_Connect_Right_CHAR :	BYTE;
    by_Connect_Top_CHAR :	BYTE;
    by_Connect_Bottom_CHAR :	BYTE;
    by_Connect_Cruz_CHAR :	BYTE;
    by_Vertikal_Line_CHAR :	BYTE;
    by_Horzontal_Line_CHAR :	BYTE;
    by_old_CHAR :	BYTE;
    in_Offset_1 :	INT;
    in_ROW_Index :	INT;
    in_COL_Index :	INT;
    by_CHAR :	BYTE;
  END_VAR

  VAR_INPUT
    Iin_X1 :	INT;
    Iin_Y1 :	INT;
    Iin_X2 :	INT;
    Iin_Y2 :	INT;
    Iby_ATTR :	BYTE;
    Iby_BORDER :	BYTE;
  END_VAR


  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR

  IF TN_SC_XY2_ERROR(Iin_X1,Iin_Y1,Iin_X2,Iin_Y2) THEN RETURN; END_IF;

  IF Iby_Border = BYTE#01 THEN

    by_Connect_Top_CHAR    := BYTE#16#C2;
    by_Connect_Bottom_CHAR := BYTE#16#C1;
    by_Connect_Left_CHAR   := BYTE#16#C3;
    by_Connect_Right_CHAR  := BYTE#16#B4;
    by_Horzontal_Line_CHAR := BYTE#16#C4;
    by_Vertikal_Line_CHAR  := BYTE#16#B3;
    by_Connect_Cruz_CHAR   := BYTE#16#C5;

  ELSIF Iby_Border = BYTE#02 THEN

    by_Connect_Top_CHAR    := BYTE#16#CB;
    by_Connect_Bottom_CHAR := BYTE#16#CA;
    by_Connect_Left_CHAR   := BYTE#16#CC;
    by_Connect_Right_CHAR  := BYTE#16#B9;
    by_Horzontal_Line_CHAR := BYTE#16#CD;
    by_Vertikal_Line_CHAR  := BYTE#16#BA;
    by_Connect_Cruz_CHAR   := BYTE#16#CE;

  ELSE
    by_Connect_Top_CHAR    := Iby_Border;
    by_Connect_Bottom_CHAR := Iby_Border;
    by_Connect_Left_CHAR   := Iby_Border;
    by_Connect_Right_CHAR  := Iby_Border;
    by_Horzontal_Line_CHAR := Iby_Border;
    by_Vertikal_Line_CHAR  := Iby_Border;
    by_Connect_Cruz_CHAR   := Iby_Border;

  END_IF;

  IF Iin_X1 = Iin_X2 THEN

    in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;

    FOR in_ROW_Index := Iin_Y1 TO Iin_Y2 DO

      by_old_CHAR := Xus_TN_SCREEN.bya_CHAR[in_Offset_1];

      by_CHAR := by_Vertikal_Line_CHAR;

      IF by_old_CHAR = by_Horzontal_Line_CHAR THEN

        IF in_ROW_Index = Iin_Y1 THEN
          by_CHAR := by_Connect_Top_CHAR;

        ELSIF in_ROW_Index = Iin_Y2 THEN
          by_CHAR := by_Connect_Bottom_CHAR; 

        ELSE 
          by_CHAR := by_Connect_Cruz_CHAR; 
        END_IF;

      END_IF;

      Xus_TN_SCREEN.bya_Line_Update[in_ROW_Index] := TRUE;

      Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_CHAR;
      Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

      in_Offset_1 := in_Offset_1 + 80;

    END_FOR;

  ELSIF Iin_Y1 = Iin_Y2 THEN

    Xus_TN_SCREEN.bya_Line_Update[Iin_Y1] := TRUE;

    in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;

    FOR in_COL_Index := Iin_X1 TO Iin_X2 DO

      by_old_CHAR := Xus_TN_SCREEN.bya_CHAR[in_Offset_1];

      by_CHAR := by_Horzontal_Line_CHAR;

      IF by_old_CHAR = by_Vertikal_Line_CHAR THEN

        IF in_COL_Index = Iin_X1 THEN
          by_CHAR := by_Connect_Left_CHAR;

        ELSIF in_COL_Index = Iin_X2 THEN
          by_CHAR := by_Connect_Right_CHAR; 

        ELSE 
          by_CHAR := by_Connect_Cruz_CHAR; 
        END_IF;

      END_IF;

      Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_CHAR;
      Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

      in_Offset_1 := in_Offset_1 + 1;

    END_FOR;
  END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
    Iin_X1 :	INT;
    Iin_Y1 :	INT;
    Iin_X2 :	INT;
    Iin_Y2 :	INT;
    Iby_ATTR :	BYTE;
    Iby_BORDER :	BYTE;
    Xus_TN_SCREEN :	us_TN_SCREEN;

    func_block : TN_SC_LINE_Block;
	END_VAR
	func_block.Iin_X1 := Iin_X1;
	func_block.Iin_Y1 := Iin_Y1;
  func_block.Iin_X2 := Iin_X2;
	func_block.Iin_Y2 := Iin_Y2;
  func_block.Iby_ATTR := Iby_ATTR;
	func_block.Iby_BORDER := Iby_BORDER;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
	Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

