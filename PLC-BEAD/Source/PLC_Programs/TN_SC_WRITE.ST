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

FUNCTION TN_SC_XY_ERROR:BOOL

	VAR_INPUT
		X :	INT;
		Y :	INT;
	END_VAR

	TN_SC_XY_ERROR := Y < 0 OR X < 0 OR Y > 23 OR X > 79;

END_FUNCTION

FUNCTION_BLOCK TN_SC_WRITE_Block

	VAR
		CODE :	CODE;
	END_VAR

	VAR
		bo_Color :	BOOL;
		in_Offset :	INT;
		in_Char_Index :	INT;
		in_String_Length :	INT;
	END_VAR

	VAR_INPUT
		Iin_Y :	INT;
		Iin_X :	INT;
		Iby_ATTR :	BYTE;
		Ist_STRING :	STRING;
	END_VAR


	VAR_IN_OUT
		Xus_TN_SCREEN :	us_TN_SCREEN;
	END_VAR

	in_String_Length := LEN(Ist_STRING);
	IF TN_SC_XY_ERROR(Iin_X + in_String_Length - 1,Iin_Y) THEN RETURN; END_IF;
	Xus_TN_SCREEN.bya_Line_Update[Iin_Y] := TRUE;
	in_Offset := (Iin_Y * 80) + Iin_X;
	bo_Color := Iby_ATTR <> BYTE#00;


	FOR in_Char_Index := 1 TO in_String_Length DO

	IF bo_Color THEN Xus_TN_SCREEN.bya_COLOR[in_Offset] := Iby_ATTR; END_IF;

	CODE(STR:=Ist_STRING,POS:=in_Char_Index);
	Xus_TN_SCREEN.bya_CHAR[in_Offset] := CODE.CODE;
	in_Offset := in_Offset + INT#1;

	END_FOR;

	Xus_TN_SCREEN.in_EOS_Offset := in_Offset;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Iin_Y :	INT;
		Iin_X :	INT;
		Iby_ATTR :	BYTE;
		Ist_STRING :	STRING;
		Xus_TN_SCREEN :	us_TN_SCREEN;

		func_block : TN_SC_WRITE_Block;
	END_VAR
	func_block.Iin_Y := Iin_Y;
	func_block.Iin_X := Iin_X;
	func_block.Iby_ATTR := Iby_ATTR;
	func_block.Ist_STRING := Ist_STRING;
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