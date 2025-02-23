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

  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

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

FUNCTION DWORD_OF_BYTE:DWORD
	VAR_INPUT
		B3 :	BYTE;
		B2 :	BYTE;
		B1 :	BYTE;
		B0 :	BYTE;
	END_VAR

	DWORD_OF_BYTE := SHL(SHL(SHL(BYTE_TO_DWORD(B3),8) OR BYTE_TO_DWORD(B2),8) OR BYTE_TO_DWORD(B1),8) OR BYTE_TO_DWORD(B0);

END_FUNCTION

FUNCTION _WORD_TO_DINT:DINT
	VAR_INPUT
		IN :	WORD;
	END_VAR
	_WORD_TO_DINT := UINT_TO_DINT(WORD_TO_UINT(IN));
END_FUNCTION

FUNCTION WORD_OF_BYTE:WORD
	VAR_INPUT
		B1 :	BYTE;
		B0 :	BYTE;
	END_VAR
	WORD_OF_BYTE := SHL(BYTE_TO_WORD(B1),8) OR BYTE_TO_WORD(B0);
END_FUNCTION


FUNCTION _INT_TO_UDINT:UDINT
	VAR_INPUT
		IN :	INT;
	END_VAR

	_INT_TO_UDINT := DINT_TO_UDINT(INT_TO_DINT(IN));
END_FUNCTION

FUNCTION_BLOCK SNTP_CLIENT_Block

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
  END_VAR


  VAR_INPUT
    IP4 :	DWORD;
    ACTIVATE :	BOOL;
  END_VAR


  VAR_OUTPUT
    ERROR :	DWORD;
    DONE_P :	BOOL;
    UDT :	UDINT;
    XMS :	INT;
  END_VAR


  VAR
    IP_STATE :	BYTE;
    IP_ID :	BYTE;
    IP_FIFO :	IP_FIFO_Block;
    i :	INT;
    last :	UDINT;
    state :	INT;
    T_PLC_MS :	T_PLC_MS_Block;
    tx :	UDINT;
    ACTIVATE_LAST :	BOOL;
    IP4_STORED :	DWORD;
  END_VAR

  T_PLC_MS();
  tx := T_PLC_MS.T_PLC_MS;  

  CASE state OF 
  00: 
    DONE_P := FALSE;
    IF ACTIVATE AND NOT ACTIVATE_LAST THEN
      IP4_STORED := IP4; 
      state := 10;
      ERROR := DWORD#0;
      IP_STATE := BYTE#1; 
    END_IF;

  10: 
    IF IP_STATE = BYTE#3 THEN

      S_BUF.BUFFER[00] := BYTE#16#1B;
      FOR i := 1 TO 47 DO
        S_BUF.BUFFER[i] := BYTE#16#00;
      END_FOR;

      last := tx;     
      state := 30;

      IP_C.C_PORT     := WORD#123;  
      IP_C.C_IP       := IP4_STORED; 
      IP_C.C_MODE     := BYTE#1;     
      IP_C.C_ENABLE   := TRUE;      
      IP_C.TIME_RESET := TRUE;       
      IP_C.R_OBSERVE  := TRUE;      
      S_BUF.SIZE      := UINT#48;    
      R_BUF.SIZE      := UINT#0;     
    END_IF;

  30:
    IF IP_C.ERROR <> DWORD#00 THEN
      ERROR := IP_C.ERROR;
    S_BUF.SIZE := UINT#0;
    R_BUF.SIZE := UINT#0;
      state := 0;
    ELSIF S_BUF.SIZE = UINT#0 AND R_BUF.SIZE >= UINT#48 THEN
      UDT := DWORD_TO_UDINT(DWORD_OF_BYTE(R_BUF.BUFFER[40],R_BUF.BUFFER[41],R_BUF.BUFFER[42],R_BUF.BUFFER[43]))- UDINT#2208988800;

      XMS := DWORD_TO_INT(SHR(DINT_TO_DWORD(_WORD_TO_DINT(WORD_OF_BYTE(R_BUF.BUFFER[44],R_BUF.BUFFER[45])) * DINT#1000),16));
      XMS := XMS + DWORD_TO_INT(SHR(UDINT_TO_DWORD(tx - last),1));

      UDT := UDT + _INT_TO_UDINT(XMS / 1000); 
      XMS := XMS MOD 1000;  

      state := 0;
      DONE_P := TRUE;

    END_IF;

    IF state = 0 THEN
      IP_C.R_OBSERVE := FALSE;        
      IP_STATE := BYTE#4;
    END_IF;

  END_CASE;

  ACTIVATE_LAST := ACTIVATE; 

  IP_FIFO(FIFO:=IP_C.FIFO,STATE:=IP_STATE,ID:=IP_ID);
  IP_C.FIFO:=IP_FIFO.FIFO;
  IP_STATE := IP_FIFO.STATE;
  IP_ID:=IP_FIFO.ID;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
    IP4 :	DWORD;
    ACTIVATE :	BOOL;
    ERROR :	DWORD;
    DONE_P :	BOOL;
    UDT :	UDINT;
    XMS :	INT;

		func_block : SNTP_CLIENT_Block;
	END_VAR
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;
  func_block.IP4 := IP4;
	func_block.ACTIVATE := ACTIVATE;

	func_block();
  IP_C  := func_block.IP_C;
  S_BUF  := func_block.S_BUF;
  R_BUF  := func_block.R_BUF;
  ERROR  := func_block.ERROR;
  DONE_P  := func_block.DONE_P;
  UDT  := func_block.UDT;
  XMS  := func_block.XMS;
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
