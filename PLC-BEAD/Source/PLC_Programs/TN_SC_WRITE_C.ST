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

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK CHR_TO_STRING_Block
	VAR_INPUT
		C :	BYTE;
	END_VAR

	VAR_OUTPUT
		CHR_TO_STRING :	STRING;
	END_VAR

	CHR_TO_STRING := BYTE_TO_STRING(C);

END_FUNCTION_BLOCK

FUNCTION BIT_OF_DWORD : BOOL
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in,N) AND 16#00000001) > 0;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION

FUNCTION_BLOCK FILL_Block
	VAR_INPUT
		C :	BYTE;
		L :	INT;
	END_VAR

	VAR_OUTPUT
		FILL :	STRING;
	END_VAR

	VAR
		N :	BYTE;
		I :	INT;
		sx :	STRING;
		CHR_TO_STRING :	CHR_TO_STRING_Block;
		FILL_tmp :	STRING;
	END_VAR

	CHR_TO_STRING(C:=c);
	Sx:=CHR_TO_STRING.CHR_TO_STRING;
	(* create string *)
	N := INT_TO_BYTE(LIMIT(0,L,80));
	(* create a string of characters to be connected to str *)
	FILL := '';
	FOR i := 1 TO 8 DO
		FILL_tmp := FILL;
		FILL := CONCAT(FILL_tmp,FILL);
		IF BIT_OF_DWORD(BYTE_TO_DWORD(N),7) THEN FILL := CONCAT(FILL,Sx); END_IF;
		N := SHL(N,1);
	END_FOR;
END_FUNCTION_BLOCK

FUNCTION_BLOCK FIX_Block

	VAR_INPUT
		STR :	STRING;
		L :	INT;
		C :	BYTE;
		M :	INT;
	END_VAR

	VAR_OUTPUT
		FIX :	STRING;
	END_VAR

	VAR
		N :	INT;
		FILL :	FILL_Block;
	END_VAR

	N := LIMIT(0,L,255) - LEN(str);
	IF N <= 0 THEN
		(* truncate the string at length N *)
		IF M = 1 THEN
			FIX := RIGHT(str,L);
		ELSE
			FIX := LEFT(str,L);
		END_IF;
	ELSIF M = 1 THEN
		(* connect fill characters at the beginning *)
		FILL(C:=C,L:=N);
		FIX := CONCAT(FILL.FILL,str);
	ELSIF M = 2 THEN
		(* center str beween fill characters *)
		(* for an uneven number of fill characters, there is one more at the end *)
		FILL(C:=C,L:=_BYTE_TO_INT(SHR(INT_TO_BYTE(N+1),1)));
		FIX := CONCAT(str,FILL.FILL);
		FILL(C:=C,L:=_BYTE_TO_INT(SHR(INT_TO_BYTE(N),1)));
		FIX := CONCAT(FILL.FILL,FIX);
	ELSE
		(* connect fill characters at the end *)
		FILL(C:=C,L:=N);
		FIX := CONCAT(str,FILL.FILL);
	END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK TN_SC_WRITE_C_Block

	VAR
		FB_FIX :	FIX_Block;
		FB_TN_SC_WRITE :	TN_SC_WRITE;
	END_VAR

	VAR_INPUT
		Iin_Y :	INT;
		Iin_X :	INT;
		Iby_ATTR :	BYTE;
		Ist_STRING :	STRING;
		Iin_LENGTH :	INT;
		Iin_OPTION :	INT;
	END_VAR


	VAR_IN_OUT
		Xus_TN_SCREEN :	us_TN_SCREEN;
	END_VAR

	FB_FIX.str:=Ist_STRING;
	FB_FIX.L:=Iin_LENGTH;
	FB_FIX.C:=BYTE#32;
	FB_FIX.M:=Iin_OPTION;
	FB_FIX();

	FB_TN_SC_WRITE.Iin_Y			:= Iin_Y;
	FB_TN_SC_WRITE.Iin_X			:= Iin_X;
	FB_TN_SC_WRITE.Iby_ATTR			:= Iby_ATTR;
	FB_TN_SC_WRITE.Ist_STRING		:= FB_FIX.FIX;
	FB_TN_SC_WRITE.Xus_TN_SCREEN	:= Xus_TN_SCREEN;
	FB_TN_SC_WRITE();
	Xus_TN_SCREEN := FB_TN_SC_WRITE.Xus_TN_SCREEN;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		Iin_Y :	INT;
		Iin_X :	INT;
		Iby_CHAR :	BYTE;
		Xus_TN_SCREEN :	us_TN_SCREEN;

		func_block : TN_SC_WRITE_C_Block;
	END_VAR
	func_block.Iin_Y := Iin_Y;
	func_block.Iin_X := Iin_X;
	func_block.Iby_CHAR := Iby_CHAR;
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

