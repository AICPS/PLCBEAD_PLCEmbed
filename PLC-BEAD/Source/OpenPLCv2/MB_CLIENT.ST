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

TYPE
	oscat_aW0_255	: ARRAY [0..255] OF WORD;
	oscat_NW_BUF_SHORT : ARRAY [0..1407] OF BYTE;
	oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

	oscat_NETWORK_BUFFER_SHORT :
	STRUCT
		SIZE   : UINT;	
		BUFFER : oscat_NW_BUF_SHORT;
	END_STRUCT;

	oscat_NETWORK_BUFFER :
	STRUCT
		SIZE   : UINT;	
		BUFFER : oscat_NW_BUF_LONG;
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

FUNCTION WORD_OF_BYTE:WORD
	VAR_INPUT
		B1 :	BYTE;
		B0 :	BYTE;
	END_VAR
	WORD_OF_BYTE := SHL(BYTE_TO_WORD(B1),8) OR BYTE_TO_WORD(B0);
END_FUNCTION

FUNCTION BIT_LOAD_W:WORD
	VAR_INPUT
		IN :	WORD;
		VAL :	BOOL;
		POS :	INT;
	END_VAR

	IF VAL THEN
		BIT_LOAD_W := in OR SHL(WORD#1,pos);
	ELSE
		BIT_LOAD_W := in AND (NOT SHL(WORD#1,pos));
	END_IF;
END_FUNCTION

FUNCTION_BLOCK MB_CLIENT_Block

	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER_SHORT;
		R_BUF :	oscat_NETWORK_BUFFER_SHORT;
		DATA :	oscat_aW0_255;
	END_VAR


	VAR_INPUT
		DATA_SIZE :	INT;
		ENABLE :	BOOL;
		UDP :	BOOL;
		FC :	INT;
		UNIT_ID :	BYTE;
		R_ADDR :	INT;
		R_POINTS :	INT;
		R_DATA_ADR :	INT;
		R_DATA_BITPOS :	INT;
		W_ADDR :	INT;
		W_POINTS :	INT;
		W_DATA_ADR :	INT;
		W_DATA_BITPOS :	INT;
		DELAY :	TIME;
	END_VAR


	VAR_OUTPUT
		ERROR :	DWORD;
		BUSY :	BOOL;
	END_VAR


	VAR
		IP_STATE :	BYTE;
		IP_ID :	BYTE;
		IP_FIFO :	IP_FIFO_Block;
		mask :	DWORD;
		w_tmp :	WORD;
		idx1 :	INT;
		idx2 :	INT;
		stop :	INT;
		i :	INT;
		bit_pos :	INT;
		w_mask :	WORD;
		b_mask :	BYTE;
		count :	INT;
		state :	INT;
		Transaction_ID :	INT;
		Response :	INT;
		comp :	INT;
		TON_1 :	TON;
	END_VAR

	CASE state OF 

	00:
		TON_1(IN:=ENABLE,PT:=DELAY);

		IF TON_1.Q OR DELAY = T#0s THEN
			TON_1(IN:=FALSE);
			state := 20;
			IP_STATE := BYTE#1;
		END_IF;

	20: 
		IF IP_STATE = BYTE#3 THEN
			IP_C.C_PORT     := WORD#0;			
			IP_C.C_IP       := DWORD#0;				
			IP_C.C_MODE     := BOOL_TO_BYTE(UDP);	
			IP_C.TIME_RESET := TRUE;				
			IP_C.C_ENABLE   := TRUE;				
			IP_C.R_OBSERVE  := TRUE;				

			ERROR := DWORD#00; 

			CASE FC OF

			1..2: 
				IF R_POINTS <= 2000 THEN
					w_tmp := INT_TO_WORD(R_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(R_POINTS);
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);
					S_BUF.SIZE := UINT#12;
					Response :=	WORD_TO_INT(SHR(INT_TO_WORD(R_POINTS + 7),3));
					comp := 7;
				ELSE
					ERROR := DWORD#2; 
				END_IF;
			3..4: 
				IF R_POINTS <= 125 THEN
					w_tmp := INT_TO_WORD(R_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(R_POINTS);
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);

					S_BUF.SIZE := UINT#12;
					Response :=	WORD_TO_INT(SHL(w_tmp,1));
					comp := 7;
				ELSE
					ERROR := DWORD#2; 
				END_IF;
			5:	
				IF W_DATA_ADR <= DATA_SIZE THEN
					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					S_BUF.BUFFER[10] := SEL((DATA[W_DATA_ADR] AND SHL(WORD#1,W_DATA_BITPOS))>WORD#00,BYTE#16#00,BYTE#16#FF);
					S_BUF.BUFFER[11] := BYTE#00;

					S_BUF.SIZE := UINT#12;
					Response :=	3;
					comp := 11;
				ELSE
					ERROR := DWORD#2;
				END_IF;
			6:	
				IF W_DATA_ADR <= DATA_SIZE THEN
					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := DATA[W_DATA_ADR];
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);

					S_BUF.SIZE := UINT#12;
					Response :=	3;
					comp := 11;
				ELSE
					ERROR := DWORD#2;
				END_IF;
			15:
				IF (WORD_TO_INT(SHR(INT_TO_WORD(WORD_TO_INT(SHL(INT_TO_WORD(W_DATA_ADR),4)) + W_POINTS + W_DATA_BITPOS + 15),4)) <= DATA_SIZE) AND W_POINTS <= 1968 THEN
					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(W_POINTS);
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);
					S_BUF.BUFFER[12] := WORD_TO_BYTE(SHR(INT_TO_WORD(W_POINTS + 7),3));

					w_mask := SHL(WORD#1,W_DATA_BITPOS);
					bit_pos := 0;
					w_tmp := WORD#00;
					idx1 := 12;
					idx2 := W_DATA_ADR;
					FOR i := 1 TO W_POINTS DO
						w_tmp :=BIT_LOAD_W(w_tmp,(DATA[idx2] AND w_mask)>WORD#0,bit_pos);
						bit_pos := bit_pos + 1;
						IF bit_pos > 7 OR i=W_POINTS THEN
							bit_pos := 0;
							idx1 := idx1 + 1;
							S_BUF.BUFFER[idx1] := WORD_TO_BYTE(w_tmp);
							w_tmp := WORD#0;
						END_IF;
						w_mask := ROL(w_mask,1);
						IF w_mask = WORD#1 THEN
							idx2 := idx2 + 1;
						END_IF;
					END_FOR;
					S_BUF.SIZE := INT_TO_UINT(idx1+1);
					Response :=	3;
					comp := 11;
				ELSE
					ERROR := DWORD#2; 
				END_IF;
			16:	
				IF W_DATA_ADR + W_POINTS <= DATA_SIZE AND W_POINTS <= 123 THEN
					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(W_POINTS);
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);
					S_BUF.BUFFER[12] := SHL(S_BUF.BUFFER[11],1);
				
					idx1 := 11;
					count := W_DATA_ADR + W_POINTS - 1;
					FOR i := W_DATA_ADR TO count DO
						idx1 := idx1 + 2;
						idx2 := idx1 + 1; 
						w_tmp := DATA[i];
						S_BUF.BUFFER[idx1] := WORD_TO_BYTE(SHR(w_tmp,8));
						S_BUF.BUFFER[idx2] := WORD_TO_BYTE(w_tmp);
					END_FOR;

					S_BUF.SIZE := INT_TO_UINT(idx2 + 1);
					Response := 3;
					comp := 11;
				ELSE
					ERROR := DWORD#2;
				END_IF;
			22:	
				IF W_DATA_ADR + 2 <= DATA_SIZE THEN
					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					idx1 := W_DATA_ADR;
					w_tmp := DATA[idx1];
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);
					idx1 := idx1 +1;
					w_tmp := DATA[idx1];
					S_BUF.BUFFER[12] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[13] := WORD_TO_BYTE(w_tmp);

					S_BUF.SIZE := UINT#14;
					Response :=	5;
					comp := 13;
				ELSE
					ERROR := DWORD#2; 
				END_IF;
			23:	
				IF W_DATA_ADR + W_POINTS <= DATA_SIZE AND W_POINTS <= 121 AND R_POINTS <= 125 THEN
					idx1 := 15;
					count := W_DATA_ADR + W_POINTS - 1;
					FOR i := W_DATA_ADR TO count DO
						idx1 := idx1 + 2;
						idx2 := idx1 + 1; 
						w_tmp := DATA[i];
						S_BUF.BUFFER[idx1] := WORD_TO_BYTE(SHR(w_tmp,8));
						S_BUF.BUFFER[idx2] := WORD_TO_BYTE(w_tmp);
					END_FOR;

					w_tmp := INT_TO_WORD(W_ADDR);
					S_BUF.BUFFER[12] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[13] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(W_POINTS);
					S_BUF.BUFFER[14] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[15] := WORD_TO_BYTE(w_tmp);
					S_BUF.BUFFER[16] := SHL(S_BUF.BUFFER[15],1);

					w_tmp := INT_TO_WORD(R_ADDR);
					S_BUF.BUFFER[08] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[09] := WORD_TO_BYTE(w_tmp);
					w_tmp := INT_TO_WORD(R_POINTS);
					S_BUF.BUFFER[10] := WORD_TO_BYTE(SHR(w_tmp,8));
					S_BUF.BUFFER[11] := WORD_TO_BYTE(w_tmp);

					S_BUF.SIZE := INT_TO_UINT(idx2+1);
					Response :=	WORD_TO_INT(SHL(w_tmp,1));
					comp := 7;
				ELSE
					ERROR := DWORD#2; 
				END_IF;

			ELSE
				ERROR := DWORD#00000001;	
			END_CASE;

			IF ERROR = DWORD#00 THEN
				Transaction_ID := Transaction_ID + 1;
				w_tmp := UINT_TO_WORD(S_BUF.SIZE - UINT#6);
				S_BUF.BUFFER[0] := IP_ID;							
				S_BUF.BUFFER[1] := INT_TO_BYTE(Transaction_ID);			
				S_BUF.BUFFER[2] := BYTE#00;							
				S_BUF.BUFFER[3] := BYTE#00;							
				S_BUF.BUFFER[4] := WORD_TO_BYTE(SHR(w_tmp,8));			
				S_BUF.BUFFER[5] := WORD_TO_BYTE(w_tmp);				
				S_BUF.BUFFER[6] := UNIT_ID;								
				S_BUF.BUFFER[7] := INT_TO_BYTE(FC);					
				R_BUF.SIZE := UINT#0;
				state := 30; 
			ELSE
				IP_STATE := BYTE#4;
				state := 00;
			END_IF;
		END_IF;

	30: 
		IF IP_C.ERROR <> DWORD#00 THEN
			ERROR := IP_C.ERROR;
			IP_STATE := BYTE#4; 
			state := 00;

		ELSIF S_BUF.SIZE = UINT#0 AND R_BUF.SIZE > UINT#0 THEN 

			w_tmp := INT_TO_WORD(Response + 3);
			S_BUF.BUFFER[4] := WORD_TO_BYTE(SHR(w_tmp,8));
			S_BUF.BUFFER[5] := WORD_TO_BYTE(w_tmp);

			FOR i := 0 TO comp DO
				IF S_BUF.BUFFER[i] <> R_BUF.BUFFER[i] THEN EXIT; END_IF;
			END_FOR;

			IF R_BUF.SIZE >= UINT#9 AND R_BUF.BUFFER[7] > BYTE#128 THEN 
				ERROR := BYTE_TO_DWORD(R_BUF.BUFFER[8]);
				IP_STATE := BYTE#4; 
				state := 00;

			ELSIF R_BUF.SIZE = INT_TO_UINT(Response + 9) AND i > comp THEN
				mask := SHL(DWORD#1,FC);

				IF (mask AND DWORD#2#00000000_00000000_00000000_00000110) <> DWORD#0 THEN
					IF WORD_TO_INT(SHR(INT_TO_WORD(WORD_TO_INT(SHL(INT_TO_WORD(R_DATA_ADR),4)) + R_POINTS + R_DATA_BITPOS + 15),4)) <= DATA_SIZE THEN
						b_mask := BYTE#1;
						idx1 := 09;
						idx2 := R_DATA_ADR;
						bit_pos := R_DATA_BITPOS;
						FOR i := 1 TO R_POINTS DO
							DATA[idx2]:=BIT_LOAD_W(DATA[idx2],(R_BUF.BUFFER[idx1] AND b_mask)>BYTE#0,bit_pos);
							bit_pos := bit_pos + 1;
							IF bit_pos > 15 THEN
								idx2 := idx2 + 1;
								bit_pos := 0;
							END_IF;
							b_mask := ROL(b_mask,1);
							IF b_mask = BYTE#1 THEN
								idx1 := idx1 +1;
							END_IF;
						END_FOR;
					ELSE
						ERROR := DWORD#2;
					END_IF;

				ELSIF (mask AND DWORD#2#00000000_10000000_00000000_00011000) <> DWORD#0 THEN
					IF R_DATA_ADR + R_POINTS <= DATA_SIZE THEN
						stop := R_DATA_ADR + R_POINTS -1 ; 
						idx1 := 07;
						FOR i := R_DATA_ADR TO stop DO
							idx1 := idx1 +2;
							idx2 := idx1 +1;
							DATA[i] := WORD_OF_BYTE(R_BUF.BUFFER[idx1],R_BUF.BUFFER[idx2]);
						END_FOR;
					ELSE
						ERROR := DWORD#2; 
					END_IF;
				ELSIF (mask AND DWORD#2#11111111_00111110_01111111_10000001) > DWORD#0 THEN 
					ERROR := DWORD#1;
				END_IF;
			ELSE
				ERROR := DWORD#3;
			END_IF;

			IP_STATE := BYTE#4; 
			state := 00;
			R_BUF.SIZE := UINT#0;

		END_IF;

	END_CASE;

	IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
	IP_C.FIFO:=IP_FIFO.FIFO;
	IP_STATE := IP_FIFO.STATE;
	IP_ID:=IP_FIFO.ID;

	BUSY := IP_STATE = BYTE#3;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER_SHORT;
		R_BUF :	oscat_NETWORK_BUFFER_SHORT;
		DATA :	oscat_aW0_255;
		DATA_SIZE :	INT;
		ENABLE :	BOOL;
		UDP :	BOOL;
		FC :	INT;
		UNIT_ID :	BYTE;
		R_ADDR :	INT;
		R_POINTS :	INT;
		R_DATA_ADR :	INT;
		R_DATA_BITPOS :	INT;
		W_POINTS :	INT;
		W_DATA_ADR :	INT;
		W_DATA_BITPOS :	INT;
		DELAY :	TIME;
		ERROR :	DWORD;
		BUSY :	BOOL;

		func_block : MB_CLIENT_Block;
	END_VAR
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;
	func_block.DATA := DATA;
	func_block.DATA_SIZE := DATA_SIZE;
	func_block.ENABLE := ENABLE;
	func_block.UDP := UDP;
	func_block.FC := FC;
	func_block.UNIT_ID := UNIT_ID;
	func_block.R_ADDR := R_ADDR;
	func_block.R_POINTS := R_POINTS;
	func_block.R_DATA_ADR := R_DATA_ADR;
	func_block.R_DATA_BITPOS := R_DATA_BITPOS;
	func_block.W_DATA_ADR := W_DATA_ADR;
	func_block.W_POINTS := W_POINTS;
	func_block.W_DATA_BITPOS := W_DATA_BITPOS;
	func_block.DELAY := DELAY;
	
	func_block();
  	IP_C  := func_block.IP_C;
	S_BUF  := func_block.S_BUF;
	R_BUF  := func_block.R_BUF;
	DATA  := func_block.DATA;
	ERROR  := func_block.ERROR;
	BUSY  := func_block.BUSY;

END_PROGRAM

CONFIGURATION Config0

	VAR_GLOBAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION
