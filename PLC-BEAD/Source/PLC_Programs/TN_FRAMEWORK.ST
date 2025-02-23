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
		in_Page_Number:        	INT;                
		in_Cursor_X:           	INT;               
		in_Cursor_Y:           	INT;                  
		in_EOS_Offset:         	INT;                
		by_Clear_Screen_Attr:  	BYTE;               
		bo_Clear_Screen:       	BOOL;              
		bo_Modal_Dialog:       	BOOL;              
		bo_Menue_Bar_Dialog:   	BOOL;               

  END_STRUCT;
END_TYPE

TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

  oscat_NETWORK_BUFFER :
  STRUCT
    SIZE   : UINT;	
    BUFFER : oscat_NW_BUF_LONG;
  END_STRUCT;
END_TYPE

FUNCTION ISC_NUM:BOOL

	VAR_INPUT
		IN :	BYTE;
	END_VAR

	ISC_NUM := IN > BYTE#47 AND IN < BYTE#58;

END_FUNCTION

FUNCTION_BLOCK TN_RECEIVE_Block

  VAR_IN_OUT
    R_BUF :	oscat_NETWORK_BUFFER;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR

  VAR
    REQ_Size :	UINT;
    REQ1 :	BYTE;
    REQ2 :	BYTE;
    REQ3 :	BYTE;
  END_VAR

  Xus_TN_SCREEN.by_Input_ASCII_Code := BYTE#00;
  Xus_TN_SCREEN.by_Input_Exten_Code := BYTE#00;

  IF R_BUF.SIZE > UINT#0 THEN
    REQ_Size := R_BUF.SIZE;
    REQ1 := R_BUF.BUFFER[0];
    REQ2 := R_BUF.BUFFER[1];
    REQ3 := R_BUF.BUFFER[2];

    IF REQ1 = BYTE#27 AND REQ_Size >= UINT#3 THEN
      IF REQ2 = BYTE#91 THEN 
        IF (REQ3 >= BYTE#65 AND REQ3 <= BYTE#68) OR (REQ3 = BYTE#72) OR (REQ3 = BYTE#75) THEN 
          Xus_TN_SCREEN.by_Input_Exten_Code := REQ3;
        END_IF;
      ELSIF REQ2 = BYTE#79 THEN 
        IF REQ3 >= BYTE#80 AND REQ3 <= BYTE#83 THEN
          Xus_TN_SCREEN.by_Input_Exten_Code := REQ3; 
        END_IF;
      END_IF;    
    ELSIF REQ1 >= BYTE#32 AND REQ1 <= BYTE#126 THEN
    Xus_TN_SCREEN.by_Input_ASCII_Code := REQ1;
      Xus_TN_SCREEN.bo_Input_ASCII_IsNum := ISC_NUM(REQ1);
    ELSIF REQ1 = BYTE#8 OR REQ1 = BYTE#9 OR REQ1 = BYTE#13 OR REQ1 = BYTE#27 THEN 
    Xus_TN_SCREEN.by_Input_Exten_Code := REQ1;
    END_IF;

    R_BUF.SIZE := UINT#00;
  END_IF;

END_FUNCTION_BLOCK

TYPE
  oscat_IP_FIFO128_DATA  : ARRAY [1..128] OF BYTE;
  oscat_Mailbox  : ARRAY [1..16] OF BYTE;

  oscat_IP_FIFO_DATA :
  STRUCT
    X       : oscat_IP_FIFO128_DATA; (* IP_ID FIFO Speicher          *)
    Y       : oscat_IP_FIFO128_DATA; (* IP_ID Z�hler                 *)
    ID      : BYTE;                  (* h�chste vergabene id         *)
    MAX_ID  : BYTE;                  (* maximal Anmeldungen pro ID   *)
    INIT    : BOOL;                  (* Initialisierung durchgef�hrt *)
    EMPTY   : BOOL;                  (* FIFO leer                    *)
    FULL    : BOOL;                  (* FIFO voll                    *)
    TOP     : INT;                   (* maximale anzahl in FIFO      *)
    NW      : INT;                   (* Schreibzeiger                *)
    NR      : INT;                   (* Lesezeiger                   *)
  END_STRUCT;

  oscat_IP_C:
  STRUCT
    C_MODE:			BYTE;          		(*W Mode: TCP/UCP AKTIV/PASSIV                               *)
    C_PORT:         WORD;          		(*W Portnummer                                               *)
    C_IP:           DWORD;         		(*W IP-Adresse gepackt wwxxyyzz = www.xxx.yyy.zzz            *)
    C_STATE:        BYTE;          		(*R Verbindungsstatus ON/OFF + Flanke ON/OFF                 *)
    C_ENABLE:       BOOL;          		(*W Freigabe f�r Connect                                     *)
    R_OBSERVE:      BOOL;          		(*W Empfang ueberwachen                                      *)
    TIME_RESET:     BOOL;          		(*W Alle Timer ruecksetzen                                   *)
    ERROR:          DWORD;         		(*R vvwwxxyy (vv = CON_ERROR, ww = SEN_ERROR, xx = REC_ERROR *)
    FIFO:           oscat_IP_FIFO_DATA; (*I IP FIFO Struktur                                         *) 
    MAILBOX:		oscat_Mailbox;		(*I Mailbox: Datenbereich f�r Bausteindatenaustausch         *) 
    END_STRUCT;
END_TYPE

FUNCTION INT_TO_BCDC:BYTE

	VAR_INPUT
		IN :	INT;
	END_VAR

	INT_TO_BCDC := SHL(INT_TO_BYTE(IN / INT#10),4) OR INT_TO_BYTE(in MOD INT#10);

END_FUNCTION

FUNCTION_BLOCK TN_SEND_ROWS_Block

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    Xus_TN_SCREEN :	us_TN_SCREEN;
  END_VAR


  VAR_INPUT
    S_BUF_SIZE :	INT;
  END_VAR

  VAR
    in_Line_Count :	INT;
    in_Col_Count :	INT;
    in_Last_Row_Index :	INT;
    bo_Break_Loop :	BOOL;
    in_Row_Count :	INT;
    in_Offset :	INT;
    in_Write_Index :	INT;
    in_Write_Index_Backup :	INT;
    by_Cur_Color :	BYTE;
    by_last_Color :	BYTE;
    in_Write_Stop :	INT;
  END_VAR

  IF (IP_C.C_STATE < BYTE#127 OR S_BUF.SIZE > UINT#0) THEN
    RETURN;
  END_IF;

  in_Write_Index := UINT_TO_INT(S_BUF.SIZE) - 1;

  in_Write_Index_Backup := in_Write_Index;

  IF (IP_C.C_STATE = BYTE#254) OR (Xus_TN_SCREEN.bo_Clear_Screen) THEN

    Xus_TN_SCREEN.bo_Clear_Screen := FALSE;

    FOR in_Line_Count := INT#00 TO INT#23 DO
      Xus_TN_SCREEN.bya_Line_Update[in_Line_Count] := TRUE;
    END_FOR;

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#30;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#33; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := (SHR(Xus_TN_SCREEN.by_Clear_Screen_Attr,4) OR BYTE#16#30);

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#34;

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := ((Xus_TN_SCREEN.by_Clear_Screen_Attr AND BYTE#16#07) OR BYTE#16#30); 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#6D;

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#32;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#4A; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#3F; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#37;
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#6C; 

  END_IF;

  in_Last_Row_Index := INT#0;
  bo_Break_Loop := FALSE;
  in_Write_Stop := S_BUF_SIZE-20;

  FOR in_Line_Count := 0 TO 23 DO
    
    in_Offset := in_Row_Count * INT#80;

    IF (Xus_TN_SCREEN.bya_Line_Update[in_Row_Count] = TRUE) THEN

      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B; 
      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B;

      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := 
        SHR(INT_TO_BCDC(in_Row_Count + INT#1),INT#4) OR BYTE#16#30; 

      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := 
        (INT_TO_BCDC(in_Row_Count + INT#1) AND BYTE#16#0F) OR BYTE#16#30; 

      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B; 
      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := BYTE#16#31; 
      in_Write_Index := in_Write_Index + INT#1;
      S_BUF.BUFFER[in_Write_Index] := BYTE#16#48; 

      FOR in_Col_Count := 0 TO 79 DO

        by_Cur_Color := Xus_TN_SCREEN.bya_COLOR[in_Offset];
        IF (by_Cur_Color <> by_last_Color) OR (in_Col_Count = INT#00) THEN

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B;

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B; 


          IF  (((by_Cur_Color AND BYTE#2#10001000) XOR (by_last_Color AND BYTE#2#10001000)) <> BYTE#00) OR (in_Col_Count = 0) THEN 

            in_Write_Index := in_Write_Index + INT#1;
            S_BUF.BUFFER[in_Write_Index] := BYTE#16#30; 
            in_Write_Index := in_Write_Index + INT#1;
            S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B; 

            IF (by_Cur_Color AND BYTE#2#00001000) = BYTE#2#00000000 THEN 

              in_Write_Index := in_Write_Index + INT#1;
              S_BUF.BUFFER[in_Write_Index] := BYTE#16#31; 
              in_Write_Index := in_Write_Index + INT#1;
              S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B;

            END_IF;

            IF (by_Cur_Color AND BYTE#2#10000000) = BYTE#2#10000000 THEN 

              in_Write_Index := in_Write_Index + INT#1;
              S_BUF.BUFFER[in_Write_Index] := BYTE#16#35;
              in_Write_Index := in_Write_Index + INT#1;
              S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B; 

            END_IF;

          END_IF;

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#33;

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := ((SHR(by_Cur_Color,4) AND BYTE#2#00000111) OR BYTE#16#30);

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B;

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#34;

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := ((by_Cur_Color AND BYTE#2#00000111) OR BYTE#16#30); 

          in_Write_Index := in_Write_Index + INT#1;
          S_BUF.BUFFER[in_Write_Index] := BYTE#16#6D;

          by_last_Color := by_Cur_Color;

        END_IF;

        IF (in_Write_Index > in_Write_Stop) THEN

          bo_Break_Loop := TRUE;
          EXIT;

        END_IF;

        in_Write_Index := in_Write_Index + INT#1;
        S_BUF.BUFFER[in_Write_Index] := Xus_TN_SCREEN.bya_CHAR[in_Offset];

        in_Offset := in_Offset + INT#01;
      END_FOR;

      IF (bo_Break_Loop = TRUE) THEN

        in_Write_Index := in_Last_Row_Index;

        EXIT;
      END_IF;

      in_Last_Row_Index := in_Write_Index;
      Xus_TN_SCREEN.bya_Line_Update[in_Row_Count] := FALSE;
                            
    END_IF;

    in_Row_Count := in_Row_Count + INT#01;

    IF (in_Row_Count > INT#23) THEN
      in_Row_Count := INT#00;
    END_IF;
  
                                                    
  END_FOR;

  IF (bo_Break_Loop = FALSE) THEN

    in_Row_Count := INT#00;

  END_IF;

  IF (in_Write_Index <> in_Write_Index_Backup) THEN

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#1B; 
    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#5B; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := SHR(INT_TO_BCDC(Xus_TN_SCREEN.in_Cursor_Y + 1),INT#4) OR BYTE#16#30; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := (INT_TO_BCDC(Xus_TN_SCREEN.in_Cursor_Y + 1) AND BYTE#16#0F) OR BYTE#16#30; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#3B; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := SHR(INT_TO_BCDC(Xus_TN_SCREEN.in_Cursor_X + 1),INT#4) OR BYTE#16#30; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := (INT_TO_BCDC(Xus_TN_SCREEN.in_Cursor_X + 1) AND BYTE#16#0F) OR BYTE#16#30; 

    in_Write_Index := in_Write_Index + INT#1;
    S_BUF.BUFFER[in_Write_Index] := BYTE#16#48; 

  END_IF;

  S_BUF.SIZE := INT_TO_UINT(in_Write_Index + 1);

END_FUNCTION_BLOCK

FUNCTION_BLOCK TN_FRAMEWORK_Block

	VAR_IN_OUT
		us_TN_INPUT_CONTROL :	us_TN_INPUT_CONTROL;
		us_TN_SCREEN :	us_TN_SCREEN;
		us_TN_MENU :	us_TN_MENU;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;
		IP_C :	oscat_IP_C;
	END_VAR


	VAR
		FB_IP_CONTROL :	IP_CONTROL;
		FB_TN_INPUT_CONTROL :	TN_INPUT_CONTROL;
		FB_TN_INPUT_MENU_BAR :	TN_INPUT_MENU_BAR;
		FB_TN_RECEIVE :	TN_RECEIVE_Block;
		FB_TN_SEND_ROWS :	TN_SEND_ROWS_Block;
		t :	TON;
	END_VAR

	IF (NOT IP_C.C_ENABLE) THEN

	IP_C.C_PORT     := WORD#23;               
	IP_C.C_IP       := DWORD#00;               
	IP_C.C_MODE     := BYTE#4;                
	IP_C.TIME_RESET := TRUE;                   
	IP_C.C_ENABLE   := TRUE;                   
	IP_C.R_OBSERVE  := FALSE;                

	END_IF;

	t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
	IF t.Q THEN
		IP_C.TIME_RESET := TRUE; 
	END_IF;

	FB_TN_INPUT_MENU_BAR.Xus_TN_MENU    := us_TN_MENU;
	FB_TN_INPUT_MENU_BAR.Xus_TN_SCREEN  := us_TN_SCREEN;
	FB_TN_INPUT_MENU_BAR();
	us_TN_MENU   := FB_TN_INPUT_MENU_BAR.Xus_TN_MENU;
	us_TN_SCREEN := FB_TN_INPUT_MENU_BAR.Xus_TN_SCREEN;

	FB_TN_INPUT_CONTROL.Xus_TN_SCREEN        := us_TN_SCREEN;
	FB_TN_INPUT_CONTROL.Xus_TN_INPUT_CONTROL := us_TN_INPUT_CONTROL;
	FB_TN_INPUT_CONTROL();
	us_TN_SCREEN        := FB_TN_INPUT_CONTROL.Xus_TN_SCREEN;
	us_TN_INPUT_CONTROL := FB_TN_INPUT_CONTROL.Xus_TN_INPUT_CONTROL;

	FB_TN_SEND_ROWS.IP_C          := IP_C;
	FB_TN_SEND_ROWS.S_BUF         := S_BUF;
	FB_TN_SEND_ROWS.Xus_TN_SCREEN := us_TN_SCREEN;
	FB_TN_SEND_ROWS.S_BUF_SIZE    := 4096;
	FB_TN_SEND_ROWS();
	IP_C         := FB_TN_SEND_ROWS.IP_C;
	S_BUF        := FB_TN_SEND_ROWS.S_BUF;
	us_TN_SCREEN := FB_TN_SEND_ROWS.Xus_TN_SCREEN;

	FB_IP_CONTROL.IP_C     := IP_C;
	FB_IP_CONTROL.S_BUF    := S_BUF;
	FB_IP_CONTROL.R_BUF    := R_BUF;
	FB_IP_CONTROL.IP       := DWORD#00;
	FB_IP_CONTROL.PORT     := WORD#00;
	FB_IP_CONTROL.TIME_OUT := T#2s;
	FB_IP_CONTROL();
	IP_C  := FB_IP_CONTROL.IP_C;
	S_BUF := FB_IP_CONTROL.S_BUF;
	R_BUF := FB_IP_CONTROL.R_BUF;

	FB_TN_RECEIVE.R_BUF := R_BUF;
	FB_TN_RECEIVE.Xus_TN_SCREEN := us_TN_SCREEN;
	FB_TN_RECEIVE();
	R_BUF := FB_TN_RECEIVE.R_BUF;
	us_TN_SCREEN := FB_TN_RECEIVE.Xus_TN_SCREEN;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		R_BUF :	oscat_NETWORK_BUFFER;
    Xus_TN_SCREEN :	us_TN_SCREEN;

		func_block : TN_RECEIVE_Block;
	END_VAR
	func_block.R_BUF := R_BUF;
	func_block.Xus_TN_SCREEN := Xus_TN_SCREEN;

	func_block();
  R_BUF  := func_block.R_BUF;
	Xus_TN_SCREEN  := func_block.Xus_TN_SCREEN;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION