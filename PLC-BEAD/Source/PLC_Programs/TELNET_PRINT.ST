TYPE
  oscat_STRING250             : STRING;
END_TYPE

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

FUNCTION _BYTE_TO_INT:INT
	VAR_INPUT
		IN :	BYTE;
	END_VAR

	_BYTE_TO_INT := USINT_TO_INT(BYTE_TO_USINT(IN));
END_FUNCTION

FUNCTION_BLOCK IP_FIFO_Block

  VAR_IN_OUT
    FIFO :	oscat_IP_FIFO_DATA;
    ID :	BYTE;
    STATE :	BYTE;
  END_VAR


  VAR
    tmp :	INT;
  END_VAR

  IF NOT FIFO.INIT THEN
    FIFO.INIT		:= TRUE;
    FIFO.NW		:= 1;
    FIFO.NR		:= 1;
    FIFO.EMPTY	:= TRUE;
    FIFO.FULL		:= FALSE;
    FIFO.TOP		:= 128;    
    FIFO.MAX_ID	:= BYTE#1;
  END_IF;

  IF ID = BYTE#00 THEN
    IF FIFO.ID < INT_TO_BYTE(FIFO.TOP) THEN
      ID := USINT_TO_BYTE(BYTE_TO_USINT(FIFO.ID) + USINT#1); 
      FIFO.ID := ID ;  

    ELSIF STATE < BYTE#200 THEN
      STATE := BYTE#255;
    RETURN;
    END_IF;
  END_IF;

  IF STATE = BYTE#1 AND NOT FIFO.FULL THEN 
    tmp := _BYTE_TO_INT(ID);
    IF FIFO.Y[tmp] < FIFO.MAX_ID THEN
      FIFO.Y[tmp] := USINT_TO_BYTE(BYTE_TO_USINT(FIFO.Y[tmp]) + USINT#1);
      tmp := FIFO.NW;
      FIFO.X[tmp] := ID;
      IF FIFO.NW = FIFO.TOP THEN FIFO.NW := 1; ELSE FIFO.NW := FIFO.NW + 1; END_IF;
      FIFO.FULL := FIFO.NW = FIFO.NR;
    FIFO.EMPTY := FALSE;
      STATE := BYTE#2; 
    END_IF;
  END_IF;

  IF STATE = BYTE#2 AND NOT FIFO.EMPTY THEN 
    tmp := FIFO.NR; 
    IF ID = FIFO.X[tmp] THEN
      STATE := BYTE#3; 
    END_IF;
  END_IF;

  IF STATE = BYTE#4 AND NOT FIFO.EMPTY THEN 

    tmp := FIFO.NR; 
    IF ID = FIFO.X[tmp] THEN
      tmp := _BYTE_TO_INT(ID);
      FIFO.Y[tmp] := USINT_TO_BYTE(BYTE_TO_USINT(FIFO.Y[tmp]) - USINT#1); 

      IF FIFO.NR = FIFO.TOP THEN FIFO.NR := 1; ELSE FIFO.NR := FIFO.NR + 1; END_IF;
      FIFO.EMPTY := FIFO.NR = FIFO.NW;
    FIFO.FULL := FALSE;
    END_IF;
    STATE := BYTE#5; 
  END_IF;

END_FUNCTION_BLOCK

FUNCTION_BLOCK TELNET_PRINT_Block

	VAR_INPUT
		TEXT :	oscat_STRING250;
		ENABLE :	BOOL;
		SEND :	BOOL;
		OPTION :	BYTE;
		BACK_COLOR :	BYTE;
		FRONT_COLOR :	BYTE;
		X_POS :	BYTE;
		Y_POS :	BYTE;
		PORT :	WORD := WORD#23;
	END_VAR


	VAR_OUTPUT
		READY :	BOOL;
		DONE :	BOOL;
	END_VAR


	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
	END_VAR


	VAR
		_STRING_TO_BUFFER :	_STRING_TO_BUFFER_NW;
		last_fc :	BYTE;
		state :	INT;
		x :	INT := -1;
		ip_state :	BYTE;
		ip_id :	BYTE;
		IP_FIFO :	IP_FIFO_Block;
		s_buf_size :	UINT := uint#4096;
		init :	BOOL;
		b0_screen_clear :	BOOL;
		b1_autowrap :	BOOL;
		b2_color :	BOOL;
		b3_cr_lr :	BOOL;
		b7_no_flush :	BOOL;
	END_VAR

	READY := IP_C.C_STATE > BYTE#127;
	DONE := FALSE;

	CASE state OF

	00: 
		IF ENABLE THEN
			state := 10;
			ip_state := BYTE#1;
		END_IF;

	10:
		IF ip_state = BYTE#3 THEN

			IP_C.C_PORT := PORT; 
			IP_C.C_IP := DWORD#00; 
			IP_C.C_MODE := BYTE#4; 
			IP_C.TIME_RESET := TRUE; 
			IP_C.C_ENABLE := TRUE; 
			IP_C.R_OBSERVE := FALSE;
			state := 20;
		END_IF;

	20:	IF IP_C.ERROR > DWORD#0 THEN
			IP_C.TIME_RESET := TRUE; 
		END_IF;
		IF S_BUF.SIZE = UINT#0 THEN
			IF NOT ENABLE THEN
				ip_state := BYTE#4;
				IP_C.C_ENABLE := FALSE; 
				state := 0;
			END_IF;
			IF IP_C.C_STATE = BYTE#1 THEN 
				init := FALSE;
			ELSIF READY THEN 
				IF IP_C.C_STATE = BYTE#254 AND NOT INIT THEN 
					init := TRUE;
					b0_screen_clear := (OPTION AND BYTE#2#0000_0001) > BYTE#0;
					b1_autowrap := (OPTION AND BYTE#2#0000_0010) > BYTE#0;
					b2_color := (OPTION AND BYTE#2#0000_0100) > BYTE#0;
					b3_cr_lr := (OPTION AND BYTE#2#0000_1000) > BYTE#0;
					b7_no_flush := (OPTION AND BYTE#2#1000_0000) > BYTE#0;

					last_fc := NOT FRONT_COLOR; 
					x := 0;

					S_BUF.BUFFER[x] := BYTE#16#1B; 
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#5B;
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#3F;
					x := x +1;
					S_BUF.BUFFER[x] := BYTE#16#37; (
					x := x +1;
					S_BUF.BUFFER[x] := SEL(b1_autowrap, BYTE#16#6C, BYTE#16#68 );

					IF b0_screen_clear THEN
						IF b2_color THEN
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#1B; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#5B; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#30; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#3B; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#33;
							x := x +1;
							S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#3B; 
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#34; 
							x := x +1;
							S_BUF.BUFFER[x] := (BACK_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
							x := x +1;
							S_BUF.BUFFER[x] := BYTE#16#6D; 
						END_IF;
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#1B; 
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#5B; 
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#32; 
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#4A; 
					ELSE
						x := x +1;
						S_BUF.BUFFER[x] := BYTE#16#0A;
					END_IF;
				END_IF;

				IF (INT_TO_UINT(x + LEN(TEXT) + 21) > s_buf_size) OR (x >= 0 AND NOT SEND) THEN
					S_BUF.SIZE := INT_TO_UINT(x + 1); 
					x := -1;
				ELSIF SEND THEN

					IF b2_color AND FRONT_COLOR <> last_FC THEN
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#1B; 
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#5B; 
						IF ((FRONT_COLOR AND BYTE#2#0001_1000) XOR (last_FC AND BYTE#2#0001_1000)) <> BYTE#00 OR TRUE THEN
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#30; 
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#3B; 
							IF (FRONT_COLOR AND BYTE#2#00001000) = BYTE#0 THEN
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#31;
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#3B; 
							END_IF;
							IF (FRONT_COLOR AND BYTE#2#00010000) > BYTE#0 THEN
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#35;
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#3B; 
							END_IF;
						END_IF;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#33;
						x := x + 1;
						S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#6D;
						last_FC := FRONT_COLOR;
					END_IF;

					IF X_POS > BYTE#0 AND Y_POS > BYTE#0 THEN
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#1B;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#5B; 
						x := x + 1;
						S_BUF.BUFFER[x] := SHR(INT_TO_BCDC(BYTE_TO_INT(Y_POS)),4) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := (INT_TO_BCDC(BYTE_TO_INT(Y_POS)) AND BYTE#16#0F) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#3B; 
						x := x + 1;
						S_BUF.BUFFER[x] := SHR(INT_TO_BCDC(BYTE_TO_INT(X_POS)),4) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := (INT_TO_BCDC(BYTE_TO_INT(X_POS)) AND BYTE#16#0F) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#48; 
					END_IF;

					IF LEN(TEXT) > 0 THEN
						_STRING_TO_BUFFER(str:=TEXT,pos:=x + 1,size:=s_buf_size,pt:=S_BUF.BUFFER);
						S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
						x := x + LEN(TEXT);
					END_IF;

					IF b3_cr_lr THEN 
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#0D;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#0A;
					END_IF;

					DONE := TRUE; 

					IF b7_no_flush THEN
						S_BUF.SIZE := INT_TO_UINT(x + 1);
						x := -1;
					END_IF;
				END_IF;
			END_IF;
		END_IF;
	END_CASE;

	IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
	IP_C.FIFO:=IP_FIFO.FIFO;
	IP_STATE := IP_FIFO.STATE;
	IP_ID:=IP_FIFO.ID;

	READY := IP_C.C_STATE > BYTE#127;
	DONE := FALSE;

	CASE state OF 

	00:
		IF ENABLE THEN
			state := 10;
			IP_STATE := BYTE#1;
		END_IF;

	10: 
		IF IP_STATE = BYTE#3 THEN
			
			IP_C.C_PORT     := WORD#23;                  
			IP_C.C_IP       := DWORD#00;               
			IP_C.C_MODE     := BYTE#4;                  
			IP_C.TIME_RESET := TRUE;                   
			IP_C.C_ENABLE   := TRUE;                   
			IP_C.R_OBSERVE  := FALSE;                  
			state := 20;
		END_IF;

	20: IF IP_C.ERROR > DWORD#0 THEN
			IP_C.TIME_RESET := TRUE;
		END_IF;
		IF S_BUF.SIZE = UINT#0 THEN	
			IF NOT ENABLE THEN
				IP_STATE := BYTE#4; 
				IP_C.C_ENABLE := FALSE; 
				state := 0;
			END_IF;
			IF IP_C.C_STATE = BYTE#1  THEN  
				INIT := FALSE;
			ELSIF READY THEN
				IF IP_C.C_STATE = BYTE#254 AND NOT INIT THEN 
					INIT := TRUE;
					last_FC := NOT FRONT_COLOR;

					_STRING_TO_BUFFER(str:='#[?7h#[0;3#;4#m#[2J',pos:=0,size:=S_BUF_SIZE,pt:=S_BUF.BUFFER);
					S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;

					S_BUF.BUFFER[0] := BYTE#16#1B; 
					IF (OPTION AND BYTE#2#0000_0010) > BYTE#0 THEN
						S_BUF.BUFFER[4] := BYTE#16#6C;
					END_IF;
					x := 4; 
					IF (OPTION AND BYTE#2#0000_0001) > BYTE#0 THEN 

						S_BUF.BUFFER[05] := BYTE#16#1B; 
						S_BUF.BUFFER[10] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30; 
						S_BUF.BUFFER[13] := (BACK_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
						S_BUF.BUFFER[15] := BYTE#16#1B;
						x := 18; 
					ELSE
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#0A;
					END_IF;
				END_IF;

				IF (INT_TO_UINT(x + LEN(TEXT) + 21) > S_BUF_SIZE) OR (x >= 0 AND NOT SEND) THEN 
					S_BUF.SIZE := INT_TO_UINT(x + 1); 
					x := -1;
				ELSIF SEND THEN

					IF (OPTION AND BYTE#2#0000_0100) > BYTE#0 AND FRONT_COLOR <> last_FC THEN
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#1B;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#5B; 
						IF ((FRONT_COLOR AND BYTE#2#0001_1000) XOR (last_FC AND BYTE#2#0001_1000)) <> BYTE#00 OR TRUE THEN 
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#30;
							x := x + 1;
							S_BUF.BUFFER[x] := BYTE#16#3B;
							IF (FRONT_COLOR AND BYTE#2#00001000) = BYTE#0 THEN 
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#31;
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#3B; 
							END_IF;
							IF (FRONT_COLOR AND BYTE#2#00010000) > BYTE#0 THEN 
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#35; 
								x := x + 1;
								S_BUF.BUFFER[x] := BYTE#16#3B; 
							END_IF;
						END_IF;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#33; 
						x := x + 1;
						S_BUF.BUFFER[x] := (FRONT_COLOR AND BYTE#2#00000111) OR BYTE#16#30;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#6D;
						last_FC := FRONT_COLOR;
					END_IF;

					IF X_POS > BYTE#0 AND Y_POS > BYTE#0 THEN
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#1B; 
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#5B; 
						x := x + 1;
						S_BUF.BUFFER[x] := SHR_BYTE(INT_TO_BCDC(_BYTE_TO_INT(Y_POS)),4) OR BYTE#16#30; 
						x := x + 1;
						S_BUF.BUFFER[x] := (INT_TO_BCDC(_BYTE_TO_INT(Y_POS)) AND BYTE#16#0F) OR BYTE#16#30; 
						x := x + INT#1;
						S_BUF.BUFFER[x] := BYTE#16#3B; 
						x := x + 1;
						S_BUF.BUFFER[x] := SHR_BYTE(INT_TO_BCDC(_BYTE_TO_INT(X_POS)),4) OR BYTE#16#30; 
						x := x + 1;
						S_BUF.BUFFER[x] := (INT_TO_BCDC(_BYTE_TO_INT(X_POS)) AND BYTE#16#0F) OR BYTE#16#30; 
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#48; 
					END_IF;

					IF LEN(TEXT) > 0 THEN
			
						_STRING_TO_BUFFER(str:=TEXT,pos:=x + 1,size:=S_BUF_SIZE,pt:=S_BUF.BUFFER);
						S_BUF.BUFFER:=_STRING_TO_BUFFER.pt;
						x := x + LEN(TEXT);
					END_IF;

					IF (OPTION AND BYTE#2#0000_1000) > BYTE#0 THEN	
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#0D;
						x := x + 1;
						S_BUF.BUFFER[x] := BYTE#16#0A;
					END_IF;

					DONE := TRUE;	

					IF (OPTION AND BYTE#2#1000_0000) = BYTE#0 THEN
						S_BUF.SIZE := INT_TO_UINT(x + 1);
						x := -1;
					END_IF;
				END_IF;
			END_IF;
		END_IF;
	END_CASE;

	IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
	IP_C.FIFO:=IP_FIFO.FIFO;
	IP_STATE := IP_FIFO.STATE;
	IP_ID:=IP_FIFO.ID;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		TEXT :	oscat_STRING250;
		ENABLE :	BOOL;
		SEND :	BOOL;
		OPTION :	BYTE;
		BACK_COLOR :	BYTE;
		FRONT_COLOR :	BYTE;
		X_POS :	BYTE;
		Y_POS :	BYTE;
		PORT :	WORD := WORD#23;
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		READY :	BOOL;
		DONE :	BOOL;

		func_block : TELNET_PRINT_Block;
	END_VAR
	func_block.TEXT := TEXT;
	func_block.ENABLE := ENABLE;
	func_block.SEND := SEND;
	func_block.OPTION := OPTION;
	func_block.BACK_COLOR := BACK_COLOR;
	func_block.FRONT_COLOR := FRONT_COLOR;
	func_block.X_POS := X_POS;
	func_block.Y_POS := Y_POS;
	func_block.PORT := PORT;
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;

	func_block();
	IP_C  := func_block.IP_C;
	S_BUF  := func_block.S_BUF;
	READY  := func_block.READY;
	DONE  := func_block.DONE;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION