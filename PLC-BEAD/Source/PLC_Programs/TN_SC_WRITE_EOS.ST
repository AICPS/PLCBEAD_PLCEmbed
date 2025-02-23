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

FUNCTION_BLOCK TN_SC_WRITE_EOS_Block

	VAR
		TN_SC_WRITE :	TN_SC_WRITE;
	END_VAR

	VAR_INPUT
		Iby_ATTR :	BYTE;
		Ist_STRING :	STRING;
	END_VAR


	VAR_IN_OUT
		Xus_TN_SCREEN :	us_TN_SCREEN;
	END_VAR

	TN_SC_WRITE.Iin_Y			:= Xus_TN_SCREEN.us_SYS.in_EOS_Offset / 80;
	TN_SC_WRITE.Iin_X			:= Xus_TN_SCREEN.us_SYS.in_EOS_Offset MOD 80; 
	TN_SC_WRITE.Iby_ATTR		:= Iby_ATTR;
	TN_SC_WRITE.Ist_STRING		:= Ist_STRING;
	TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
	TN_SC_WRITE();
	Xus_TN_SCREEN := TN_SC_WRITE.Xus_TN_SCREEN;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Iby_ATTR :	BYTE;
		Ist_STRING :	STRING;

		func_block : TN_SC_WRITE_EOS_Block;
	END_VAR
	func_block.Iby_ATTR := Iby_ATTR;
	func_block.Ist_STRING := Ist_STRING;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
	URL_TO_STRING  := func_block.URL_TO_STRING;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION