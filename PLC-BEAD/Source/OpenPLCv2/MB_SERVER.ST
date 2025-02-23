TYPE
	oscat_IP_FIFO128_DATA  : ARRAY [1..128] OF BYTE;
	oscat_Mailbox  : ARRAY [1..16] OF BYTE;
	
	oscat_NW_BUF_SHORT : ARRAY [0..1407] OF BYTE;
	oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

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

	oscat_NETWORK_BUFFER :
	STRUCT
		SIZE   : UINT;	
		BUFFER : oscat_NW_BUF_LONG;
	END_STRUCT;

	oscat_NETWORK_BUFFER_SHORT :
	STRUCT
	SIZE   : UINT;	
	BUFFER : oscat_NW_BUF_SHORT;
	END_STRUCT;

	oscat_aW0_255	: ARRAY [0..255] OF WORD;
	oscat_VMAP_DATA :
	STRUCT
		FC       : DWORD;
		V_ADR    : INT;	
		V_SIZE   : INT;
		P_ADR    : INT;
		TIME_OUT : TIME;
	END_STRUCT;

	oscat_MB_VMAP : ARRAY [1..10] OF oscat_VMAP_DATA;

	csv_parser_demo_col : ARRAY [1..4] OF REAL;
	csv_parser_demo     : ARRAY [1..2] OF csv_parser_demo_col;

END_TYPE

FUNCTION_BLOCK MB_VMAP_Block

	VAR_IN_OUT
		VMAP :	oscat_MB_VMAP;
	END_VAR


	VAR_INPUT
		FC :	INT;
		V_ADR :	INT;
		V_CNT :	INT;
		SIZE :	INT;
	END_VAR


	VAR_OUTPUT
		P_ADR :	INT;
		P_BIT :	INT;
		ERROR :	BYTE;
	END_VAR


	VAR
		i :	INT;
		vopt :	DWORD;
		vadr :	INT;
		padr :	INT;
		mask :	DWORD;
		vsize :	INT;
		w_tmp :	WORD;
		i_tmp :	INT;
		init :	BOOL;
	END_VAR

	IF init = FALSE THEN
		init := TRUE;
		IF VMAP[1].FC = DWORD#0 THEN
			VMAP[1].FC := DWORD#16#FFFF_FFFF;
			VMAP[1].V_ADR := 0;
			VMAP[1].V_SIZE := 256;
			VMAP[1].P_ADR := 0;
		END_IF;
	END_IF;

	ERROR := BYTE#02; 
	mask := SHL(DWORD#1,FC);

	IF (mask AND DWORD#2#00000000_01000000_00000000_01100000) <> DWORD#0 THEN 
		V_CNT := 1;
	ELSIF V_CNT = 0 THEN
		RETURN;
	END_IF;

	FOR i := 1 TO 10 DO
		vopt := VMAP[i].FC; 
		IF (vopt AND mask) <> DWORD#0 THEN
			vadr := VMAP[i].V_ADR;
			vsize := VMAP[i].V_SIZE;
			padr := VMAP[i].P_ADR;

			IF (mask AND DWORD#2#00000000_00000000_10000000_00100110) <> DWORD#0 THEN
				i_tmp := WORD_TO_INT(SHR(INT_TO_WORD(V_ADR + V_CNT -1),4))+1;
				IF i_tmp <= SIZE AND i_tmp <= vsize THEN
					w_tmp := INT_TO_WORD(V_ADR);
					P_ADR := WORD_TO_INT(SHR(w_tmp,4)) + padr; 
					P_BIT := WORD_TO_INT(w_tmp AND WORD#16#000F);
					ERROR := BYTE#0;
					EXIT;
				END_IF;
			ELSIF (mask AND DWORD#2#00000000_11000001_00000000_01011000) <> DWORD#0 THEN 
				IF V_ADR >= vadr AND V_ADR + V_CNT <= vadr + vsize THEN 
					P_ADR := V_ADR - vadr + padr;
					IF P_ADR + V_CNT <= SIZE THEN 
						ERROR := BYTE#0;
						EXIT;
					END_IF;
				END_IF;
			ELSE
				ERROR := BYTE#01;
				RETURN;
			END_IF;
		END_IF;
	END_FOR;

	IF ERROR = BYTE#0 THEN
		IF (mask AND DWORD#2#00000000_11000001_10000000_01100000) <> DWORD#0 THEN 
			VMAP[i].TIME_OUT := T#1ms;
		END_IF;
	END_IF;

END_FUNCTION_BLOCK

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

FUNCTION _UDINT_TO_TIME:TIME

	VAR_INPUT
		IN :	UDINT;
	END_VAR


	_UDINT_TO_TIME := DINT_TO_TIME(UDINT_TO_DINT(IN));

END_FUNCTION

FUNCTION_BLOCK T_PLC_MS_block
	
	VAR_OUTPUT
		T_PLC_MS :	UDINT;
	END_VAR

	VAR_EXTERNAL
		PLC_TICKS_PER_SEC :	INT;
		PLC_SYS_TICK_CNT :	DINT;
	END_VAR

	VAR
		debug :	BOOL;(*Debug-Mode ON / OFF*)
		N :	INT;(*Debug-Faktor*)
		Offset :	UDINT;(*Debug-Offset*)
		temp :	DWORD := DWORD#1;(*Debug-Offset*)
		mode :	BOOL;(*modus*)
		faktor :	UDINT;(*Systemtakt-Faktor*)
		init :	BOOL;
		v_plc_ticks_per_sec :	UDINT;
		base :	UDINT := UDINT#1000;
	END_VAR

	IF init = FALSE THEN
		v_plc_ticks_per_sec := INT_TO_UDINT(PLC_TICKS_PER_SEC);
		IF v_plc_ticks_per_sec = UDINT#1024 THEN
			faktor := UDINT#1;
			mode := FALSE;
		ELSIF v_plc_ticks_per_sec > UDINT#0 THEN
			IF v_plc_ticks_per_sec <= base THEN
				faktor := base / v_plc_ticks_per_sec;
				mode := FALSE;
			ELSE
				faktor := v_plc_ticks_per_sec / base;
				mode := TRUE;
			END_IF;
		ELSE
			faktor := UDINT#1;
		END_IF;
		init := TRUE;
	END_IF;

	IF mode THEN
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) / faktor;
	ELSE
		T_PLC_MS := DINT_TO_UDINT(PLC_SYS_TICK_CNT) * faktor;
	END_IF;

	IF debug THEN
		T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N)) - UDINT#1) + Offset;
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

FUNCTION_BLOCK MB_SERVER_Block

	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER_SHORT;
		R_BUF :	oscat_NETWORK_BUFFER_SHORT;
		VMAP :	oscat_MB_VMAP;
		DATA :	oscat_aW0_255;
	END_VAR


	VAR_INPUT
		DATA_SIZE :	INT;
		ENABLE :	BOOL;
		UDP :	BOOL;
	END_VAR


	VAR_OUTPUT
		ERROR :	DWORD;
	END_VAR


	VAR
		MB_VMAP :	MB_VMAP_Block;
		adr1 :	INT;
		adr2 :	INT;
		points :	INT;
		points2 :	INT;
		coils :	BYTE;
		mask :	BYTE;
		idx1 :	INT;
		idx2 :	INT;
		bit_pos :	INT;
		count :	INT;
		fc :	INT;
		i :	INT;
		state :	INT;
		IP_STATE :	BYTE;
		IP_ID :	BYTE;
		IP_FIFO :	IP_FIFO_Block;
		w_tmp :	WORD;
		last_cycle :	TIME;
		tx :	TIME;
		T_PLC_MS :	T_PLC_MS_Block;
		t :	TON;
		ip_error :	BOOL;
	END_VAR

	T_PLC_MS();
	tx := UDINT_TO_TIME(T_PLC_MS.T_PLC_MS);

	FOR i := 1 TO 10 DO
		IF VMAP[i].TIME_OUT > T#0s THEN
			VMAP[i].TIME_OUT := VMAP[i].TIME_OUT + tx - last_cycle;
		END_IF;
	END_FOR;
	last_cycle := tx;
	ip_error := IP_C.ERROR > DWORD#0;

	CASE state OF 

	00: 
		IF ENABLE THEN
			state := 10;
			IP_STATE := BYTE#1;
		END_IF;

	10: 
		IF IP_STATE = BYTE#3 THEN

			IP_C.C_PORT     := WORD#0;				
			IP_C.C_IP       := DWORD#0;					
			IP_C.C_MODE     := SEL(UDP,BYTE#4,BYTE#5);	
			IP_C.TIME_RESET := TRUE;					
			IP_C.C_ENABLE   := TRUE;				
			IP_C.R_OBSERVE  := FALSE;				
			state := 20;
		END_IF;

	20:	IF NOT ip_error THEN
			IF S_BUF.SIZE = UINT#0 AND R_BUF.SIZE > UINT#6 THEN	
				IF  R_BUF.SIZE = WORD_TO_UINT(WORD_OF_BYTE(R_BUF.BUFFER[4],R_BUF.BUFFER[5])) + UINT#6 THEN 
					ERROR := DWORD#00;	

					FOR i := 0 TO 13 DO
						S_BUF.BUFFER[i] := R_BUF.BUFFER[i];
					END_FOR;

					fc := _BYTE_TO_INT(R_BUF.BUFFER[7]);

					adr1 := WORD_TO_INT(WORD_OF_BYTE(R_BUF.BUFFER[8],R_BUF.BUFFER[9]));
					points := WORD_TO_INT(WORD_OF_BYTE(R_BUF.BUFFER[10],R_BUF.BUFFER[11]));

					MB_VMAP(VMAP:=VMAP,FC:=fc,V_ADR:=adr1,V_CNT:=points,SIZE:=DATA_SIZE);
					VMAP:=MB_VMAP.VMAP;
					adr1:=MB_VMAP.P_ADR;
					bit_pos:=MB_VMAP.P_BIT;
					ERROR:=BYTE_TO_DWORD(MB_VMAP.ERROR);

					IF ERROR = DWORD#0 THEN 
						CASE fc OF

						1..2 :
							count := 9; 
							coils := BYTE#0;
							mask := BYTE#1;
							FOR i := 1 TO points DO
								IF mask = BYTE#0 THEN 
									mask := BYTE#1;
									S_BUF.BUFFER[count] := coils;
									coils := BYTE#0;
									count := count + 1;
								END_IF;
								IF (DATA[adr1] AND SHL(WORD#1,bit_pos)) > WORD#0 THEN
									coils := coils OR mask;
								END_IF;

								bit_Pos := bit_Pos + 1;
								IF bit_pos > 15 THEN
									adr1 := adr1 + 1;
									bit_pos := 0;
								END_IF;

								mask := SHL(mask,1);
							END_FOR;
							S_BUF.BUFFER[Count] := coils;

							S_BUF.BUFFER[8] := INT_TO_BYTE(count - 8);  
							S_BUF.SIZE := INT_TO_UINT(count + 1);

						3..4 :
							idx1 := 07;
							count := adr1 + points - 1;
							FOR i := adr1 TO count DO
								idx1 := idx1 + 2;
								idx2 := idx1 + 1; 
								w_tmp := DATA[i];
								S_BUF.BUFFER[idx1] := WORD_TO_BYTE(SHR(w_tmp,8));
								S_BUF.BUFFER[idx2] := WORD_TO_BYTE(w_tmp);
							END_FOR;
							S_BUF.BUFFER[8] := SHL(INT_TO_BYTE(points),1); 
							S_BUF.SIZE := INT_TO_UINT(idx2 + 1);
						5 : 
							DATA[adr1]:=BIT_LOAD_W(DATA[adr1],R_BUF.BUFFER[10]>BYTE#0,bit_pos);
							S_BUF.SIZE := UINT#12;
						6 : 
							DATA[adr1] := WORD_OF_BYTE(R_BUF.BUFFER[10],R_BUF.BUFFER[11]);
							S_BUF.SIZE := UINT#12;
						15 : 
							mask := BYTE#1;
							idx1 := 13;
							FOR i := 1 TO points DO
								DATA[adr1]:=BIT_LOAD_W(DATA[adr1],(R_BUF.BUFFER[idx1] AND mask)>BYTE#0,bit_pos);
								bit_pos := bit_pos + 1;
								IF bit_pos > 15 THEN
									adr1 := adr1 + 1;
									bit_pos := 0;
								END_IF;
								mask := ROL(mask,1);
								IF mask = BYTE#1 THEN
									idx1 := idx1 +1;
								END_IF;
							END_FOR;
							S_BUF.SIZE := UINT#12;
						16 :
							idx1 := 11;
							count := adr1 + points -1;
							FOR i := adr1 TO Count DO
								idx1 := idx1 + 2;
								idx2 := idx1 + 1;
								Data[i] := WORD_OF_BYTE(R_BUF.BUFFER[idx1],R_BUF.BUFFER[idx2]);
							END_FOR;
							S_BUF.SIZE := UINT#12;
						22 :
							w_tmp := WORD_OF_BYTE(R_BUF.BUFFER[11],R_BUF.BUFFER[11]); 
							DATA[adr1] := (DATA[adr1] AND w_tmp) OR (WORD_OF_BYTE(R_BUF.BUFFER[12],R_BUF.BUFFER[13]) AND (NOT w_tmp));
							S_BUF.SIZE := UINT#14;
						23 :
							adr2 := WORD_TO_INT(WORD_OF_BYTE(R_BUF.BUFFER[12],R_BUF.BUFFER[13]));
							points2 := WORD_TO_INT(WORD_OF_BYTE(R_BUF.BUFFER[14],R_BUF.BUFFER[15]));

							MB_VMAP(VMAP:=VMAP,FC:=16,V_ADR:=adr2,V_CNT:=points2,SIZE:=DATA_SIZE);
							VMAP:=MB_VMAP.VMAP;
							adr2:=MB_VMAP.P_ADR;
							ERROR:=BYTE_TO_DWORD(MB_VMAP.ERROR);

							IF ERROR = DWORD#0 THEN 
								idx1 := 15;
								count := adr2 + points2 -1;
								FOR i := adr2 TO count DO
									idx1 := idx1 + 2;
									idx2 := idx1 + 1;
									Data[i] := WORD_OF_BYTE(R_BUF.BUFFER[idx1],R_BUF.BUFFER[idx2]);
								END_FOR;

								idx1 := 07;
								count := adr1 + points - 1;
								FOR i := adr1 TO count DO
									idx1 := idx1 + 2;
									idx2 := idx1 + 1;
									w_tmp := DATA[i];
									S_BUF.BUFFER[idx1] := WORD_TO_BYTE(SHR(w_tmp,8));
									S_BUF.BUFFER[idx2] := WORD_TO_BYTE(w_tmp);
								END_FOR;
								S_BUF.BUFFER[8] := SHL(INT_TO_BYTE(points),1); 
								S_BUF.SIZE := INT_TO_UINT(idx2 + 1);

							END_IF;

						ELSE
							ERROR := DWORD#01; 
						END_CASE;
					END_IF;
				END_IF;

				IF ERROR > DWORD#0 THEN
					S_BUF.BUFFER[7] := S_BUF.BUFFER[7] OR BYTE#2#1000_0000; 
					S_BUF.BUFFER[8] := DWORD_TO_BYTE(ERROR);
					S_BUF.SIZE := UINT#9;
				END_IF;

				S_BUF.BUFFER[4] := BYTE#0;
				S_BUF.BUFFER[5] := UINT_TO_BYTE(S_BUF.SIZE - UINT#6);

			END_IF;
		ELSE
			ERROR := IP_C.ERROR;
		END_IF;

		t(IN:= ip_error, PT:=T#5s);
		IF t.Q THEN
			IP_C.TIME_RESET := TRUE;
		END_IF;

		R_BUF.SIZE := UINT#0; 

		IF ENABLE = FALSE THEN
			IP_STATE := BYTE#4;
			state := 00;
		END_IF;
	END_CASE;

	IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
	IP_C.FIFO:=IP_FIFO.FIFO;
	IP_STATE := IP_FIFO.STATE;
	IP_ID:=IP_FIFO.ID;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER_SHORT;
		R_BUF :	oscat_NETWORK_BUFFER_SHORT;
		VMAP :	oscat_MB_VMAP;
		DATA :	oscat_aW0_255;
		DATA_SIZE :	INT;
		ENABLE :	BOOL;
		UDP :	BOOL;
		ERROR :	DWORD;

		func_block : MB_SERVER_Block;
	END_VAR
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;
	func_block.VMAP := VMAP;
	func_block.DATA := DATA;
	func_block.DATA_SIZE := DATA_SIZE;
	func_block.ENABLE := ENABLE;
	func_block.UDP := UDP;

	func_block();
  	IP_C  := func_block.IP_C;
	S_BUF  := func_block.S_BUF;
	R_BUF  := func_block.R_BUF;
	VMAP  := func_block.VMAP;
	DATA  := func_block.DATA;
	ERROR  := func_block.ERROR;

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
