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

FUNCTION TN_SC_XY2_ERROR:BOOL

	VAR_INPUT
		X1 :	INT;
		Y1 :	INT;
		X2 :	INT;
		Y2 :	INT;
	END_VAR

	TN_SC_XY2_ERROR := Y1 < 0 OR X1 < 0 OR Y2 < 0 OR X2 < 0 OR Y1 > 23 OR X1 > 79 OR Y2 > 23 OR X2 > 79;

END_FUNCTION

FUNCTION_BLOCK TN_SC_FILL_Block

	VAR
		in_X :	INT;
		in_Y :	INT;
		in_Offset :	INT;
	END_VAR

	VAR_INPUT
		Iin_Y1 :	INT;
		Iin_X1 :	INT;
		Iin_Y2 :	INT;
		Iin_X2 :	INT;
		Iby_CHAR :	BYTE;
		Iby_Attr :	BYTE;
	END_VAR


	VAR_IN_OUT
		Xus_TN_SCREEN :	us_TN_SCREEN;
	END_VAR

	IF TN_SC_XY2_ERROR(Iin_X1,Iin_Y1,Iin_X2,Iin_Y2) THEN RETURN; END_IF;

	FOR in_Y := Iin_Y1 TO Iin_Y2 DO
	Xus_TN_SCREEN.bya_Line_Update[in_Y] := TRUE; 
	in_Offset := (in_Y * 80) + Iin_X1;
	FOR in_X := Iin_X1 TO Iin_X2 DO
		Xus_TN_SCREEN.bya_CHAR[in_Offset]  := Iby_CHAR; 
		Xus_TN_SCREEN.bya_COLOR[in_Offset] := Iby_Attr; 
		in_Offset := in_Offset + 1;
	END_FOR;
	END_FOR;

END_FUNCTION_BLOCK

FUNCTION_BLOCK TN_SC_BOX_Block

  VAR
    FB_TN_SC_FILL :	TN_SC_FILL_Block;
  END_VAR

  VAR
    by_BorderChar_L_T :	BYTE;
    by_BorderChar_T :	BYTE;
    by_BorderChar_B :	BYTE;
    by_BorderChar_R_T :	BYTE;
    by_BorderChar_L :	BYTE;
    by_BorderChar_R :	BYTE;
    by_BorderChar_L_B :	BYTE;
    by_BorderChar_R_B :	BYTE;
    in_Y :	INT;
    in_X :	INT;
    in_Border_Offset :	INT;
    in_Offset_1 :	INT;
    in_Offset_2 :	INT;
  END_VAR

  VAR_INPUT
    Iin_Y1 :	INT;
    Iin_X1 :	INT;
    Iin_Y2 :	INT;
    Iin_X2 :	INT;
    Iby_FILL :	BYTE;
    Iby_ATTR :	BYTE;
    Iin_BORDER :	INT;
  END_VAR


  VAR_IN_OUT
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR


  IF TN_SC_XY2_ERROR(Iin_X1,Iin_Y1,Iin_X2,Iin_Y2) THEN RETURN; END_IF;

  CASE Iin_Border OF
  0:
    in_Border_Offset := 0;

  1:
    by_BorderChar_L_T := BYTE#218; 
    by_BorderChar_T   := BYTE#196; 
    by_BorderChar_R_T := BYTE#191; 
    by_BorderChar_L   := BYTE#179; 
    by_BorderChar_R   := BYTE#179; 
    by_BorderChar_B   := BYTE#196; 
    by_BorderChar_L_B := BYTE#217; 
    by_BorderChar_R_B := BYTE#192; 
    in_Border_Offset  := 1;

  2:
    by_BorderChar_L_T := BYTE#201;
    by_BorderChar_T   := BYTE#205;
    by_BorderChar_R_T := BYTE#187;
    by_BorderChar_L   := BYTE#186;
    by_BorderChar_R   := BYTE#186;
    by_BorderChar_B   := BYTE#205;
    by_BorderChar_L_B := BYTE#188;
    by_BorderChar_R_B := BYTE#200;
    in_Border_Offset  := 1;

  ELSE
    by_BorderChar_L_T := BYTE#32;
    by_BorderChar_T   := BYTE#32;
    by_BorderChar_R_T := BYTE#32;
    by_BorderChar_L   := BYTE#32;
    by_BorderChar_R   := BYTE#32;
    by_BorderChar_B   := BYTE#32;
    by_BorderChar_L_B := BYTE#32;
    by_BorderChar_R_B := BYTE#32;
    in_Border_Offset  := 1;

  END_CASE;


  IF Iby_FILL > BYTE#0 THEN 

    FB_TN_SC_FILL.Iin_Y1			:= Iin_Y1 + in_Border_Offset;
    FB_TN_SC_FILL.Iin_X1			:= Iin_X1 + in_Border_Offset;
    FB_TN_SC_FILL.Iin_Y2			:= Iin_Y2 - in_Border_Offset;
    FB_TN_SC_FILL.Iin_X2			:= Iin_X2 - in_Border_Offset;
    FB_TN_SC_FILL.Iby_CHAR		:= Iby_FILL;
    FB_TN_SC_FILL.Iby_Attr		:= Iby_ATTR;
    FB_TN_SC_FILL.Xus_TN_SCREEN := Xus_TN_SCREEN;
    FB_TN_SC_FILL();
    Xus_TN_SCREEN := FB_TN_SC_FILL.Xus_TN_SCREEN;

  END_IF;

  IF Iin_BORDER = 0 THEN RETURN; END_IF;

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;
  in_Offset_2 := (Iin_Y1 * 80) + Iin_X2;

  FOR in_Y := Iin_Y1 TO Iin_Y2 DO

    Xus_TN_SCREEN.bya_Line_Update[in_Y] := TRUE;

    Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_L;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

    Xus_TN_SCREEN.bya_CHAR[in_Offset_2]  := by_BorderChar_R;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_2] := Iby_Attr;

    in_Offset_1 := in_Offset_1 + 80;
    in_Offset_2 := in_Offset_2 + 80;

  END_FOR;

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;
  in_Offset_2 := (Iin_Y2 * 80) + Iin_X1;

  FOR in_X := Iin_X1 TO Iin_X2 DO

    Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_T;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

    Xus_TN_SCREEN.bya_CHAR[in_Offset_2]  := by_BorderChar_B;
    Xus_TN_SCREEN.bya_COLOR[in_Offset_2] := Iby_Attr;

    in_Offset_1 := in_Offset_1 + INT#1;
    in_Offset_2 := in_Offset_2 + INT#1;

  END_FOR;

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X1;
  Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_L_T;
  Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

  in_Offset_1 := (Iin_Y1 * 80) + Iin_X2;
  Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_R_T;
  Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

  in_Offset_1 := (Iin_Y2 * 80) + Iin_X1;
  Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_R_B;
  Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

  in_Offset_1 := (Iin_Y2 * 80) + Iin_X2;
  Xus_TN_SCREEN.bya_CHAR[in_Offset_1]  := by_BorderChar_L_B;
  Xus_TN_SCREEN.bya_COLOR[in_Offset_1] := Iby_Attr;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Iin_Y1 :	INT;
    Iin_X1 :	INT;
    Iin_Y2 :	INT;
    Iin_X2 :	INT;
    Iby_FILL :	BYTE;
    Iby_ATTR :	BYTE;
    Iin_BORDER :	INT;
		Xus_TN_SCREEN :	us_TN_SCREEN;

		func_block : TN_SC_BOX_Block;
	END_VAR
  func_block.Iin_X1 := Iin_X1;
  func_block.Iin_Y1 := Iin_Y1;
  func_block.Iin_X2 := Iin_X2;
  func_block.Iin_Y2 := Iin_Y2;
  func_block.Iby_FILL := Iby_FILL;
  func_block.Iby_ATTR := Iby_ATTR;
  func_block.Iin_BORDER := Iin_BORDER;
  func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
	Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION