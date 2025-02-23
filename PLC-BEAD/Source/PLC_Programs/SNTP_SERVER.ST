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

FUNCTION_BLOCK SNTP_SERVER_Block

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
  END_VAR


  VAR_INPUT
    ENABLE :	BOOL;
    STRATUM :	BYTE := BYTE#1;
    UDT :	UDINT;
    XMS :	INT;
  END_VAR


  VAR
    IP_STATE :	BYTE;
    IP_ID :	BYTE;
    IP_FIFO :	IP_FIFO_Block;
    i2 :	INT;
    i :	INT;
    TIMESTAMP_INT :	DWORD;
    TIMESTAMP_SEK :	DWORD;
    TS_B :	BYTE;
    state :	INT;
    T_PLC_MS :	T_PLC_MS_Block;
    tx :	UDINT;
    t :	TON;
  END_VAR

  T_PLC_MS();
  tx := T_PLC_MS.T_PLC_MS;  

  CASE state OF 

  00: 
    IF ENABLE THEN
      state := 10;
      IP_STATE := BYTE#1; 
    END_IF;

  10: 
    IF IP_STATE = BYTE#3 THEN

      
      IP_C.C_PORT     := WORD#123; 
      IP_C.C_IP       := DWORD#00; 
      IP_C.C_MODE     := BYTE#5; 
      IP_C.C_ENABLE   := TRUE;    
      IP_C.TIME_RESET := TRUE;   
      IP_C.R_OBSERVE  := FALSE;    
      S_BUF.SIZE      := UINT#0;   
      R_BUF.SIZE      := UINT#0;   

      state := 20;
    END_IF;

  20:
    IF R_BUF.SIZE > UINT#0 THEN 
      state := 20;
      FOR i := 0 TO 47 DO
        IF INT_TO_UINT(i) > R_BUF.SIZE - UINT#1 THEN
          R_BUF.BUFFER[i] := BYTE#00;
      END_IF;
        S_BUF.BUFFER[i] := BYTE#00;
      END_FOR;

    R_BUF.SIZE := UINT#0;

      S_BUF.BUFFER[0] := BYTE#2#11100; 
      S_BUF.BUFFER[1] := STRATUM;      
      S_BUF.BUFFER[2] := BYTE#10;   
      S_BUF.BUFFER[3] := BYTE#16#FB;   

      TIMESTAMP_INT := UDINT_TO_DWORD(UDT + UDINT#2208988800);

    TIMESTAMP_SEK := DINT_TO_DWORD(DWORD_TO_DINT(SHL(INT_TO_DWORD(XMS),16))/DINT#1000);

      TS_B := TIMESTAMP_INT.B3; 
      S_BUF.BUFFER[16] := TS_B; 
      S_BUF.BUFFER[32] := TS_B; 
      S_BUF.BUFFER[40] := TS_B; 

      TS_B := TIMESTAMP_INT.B2;
      S_BUF.BUFFER[17] := TS_B; 
      S_BUF.BUFFER[33] := TS_B; 
      S_BUF.BUFFER[41] := TS_B; 

      TS_B := TIMESTAMP_INT.B1;
      S_BUF.BUFFER[18] := TS_B; 
      S_BUF.BUFFER[34] := TS_B; 
      S_BUF.BUFFER[42] := TS_B; 

      TS_B := TIMESTAMP_INT.B0;
      S_BUF.BUFFER[19] := TS_B;
      S_BUF.BUFFER[35] := TS_B; 
      S_BUF.BUFFER[43] := TS_B;

      TS_B := TIMESTAMP_SEK.B1; 
      S_BUF.BUFFER[20] := TS_B;
      S_BUF.BUFFER[36] := TS_B;
      S_BUF.BUFFER[44] := TS_B; 

      TS_B := TIMESTAMP_SEK.B0;
      S_BUF.BUFFER[21] := TS_B; 
      S_BUF.BUFFER[37] := TS_B;
      S_BUF.BUFFER[45] := TS_B;

      i2 := 40;
      FOR i := 24 TO 31 DO
        S_BUF.BUFFER[i] := R_BUF.BUFFER[i2];
        i2 := i2 +1;
      END_FOR;

      S_BUF.SIZE := UINT#48;

    ELSIF NOT ENABLE AND S_BUF.SIZE = UINT#0 THEN
      IP_STATE := BYTE#4; 
      state := 0;
    END_IF;

  END_CASE;

  t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
  IF t.Q THEN
    IP_C.TIME_RESET := TRUE;
  END_IF;

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
    ENABLE :	BOOL;
    STRATUM :	BYTE := BYTE#1;
    UDT :	UDINT;
    XMS :	INT;

		func_block : SNTP_SERVER_Block;
	END_VAR
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;
  func_block.ENABLE := ENABLE;
	func_block.STRATUM := STRATUM;
	func_block.UDT := UDT;
  func_block.XMS := XMS;

	func_block();
  IP_C  := func_block.IP_C;
  S_BUF  := func_block.S_BUF;
  R_BUF  := func_block.R_BUF;
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
