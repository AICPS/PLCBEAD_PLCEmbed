TYPE

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

FUNCTION_BLOCK IRTRANS_SERVER_Block

	VAR_INPUT
		UDP_TCP :	BOOL;
	END_VAR


	VAR_OUTPUT
		S_ENABLE :	BOOL;
		R_ENABLE :	BOOL;
		ERROR :	DWORD;
	END_VAR


	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;
	END_VAR


	VAR
		t :	TON;
	END_VAR

	IF NOT IP_C.C_ENABLE THEN
		IP_C.C_PORT := WORD#0; 
		IP_C.C_IP := DWORD#00; 
		IP_C.C_MODE := SEL(UDP_TCP,BYTE#5,BYTE#4);
		IP_C.C_ENABLE := TRUE;
		IP_C.R_OBSERVE := FALSE; 
		IP_C.TIME_RESET := TRUE; 
		S_BUF.SIZE := UINT#0; 
		R_BUF.SIZE := UINT#0; 
	END_IF;

	R_ENABLE := IP_C.C_STATE > BYTE#127;
	S_ENABLE := R_ENABLE AND (IP_C.MAILBOX[1] > BYTE#0 OR IP_C.C_MODE <> BYTE#5);
	ERROR := IP_C.ERROR;

	t(IN:= IP_C.ERROR > DWORD#0, PT:=T#5s);
	IF t.Q THEN
		IP_C.TIME_RESET := TRUE;
	END_IF;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		UDP_TCP :	BOOL;
		S_ENABLE :	BOOL;
		R_ENABLE :	BOOL;
		ERROR :	DWORD;
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;

		func_block : IRTRANS_SERVER_Block;
	END_VAR
	func_block.UDP_TCP := UDP_TCP;
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;

	func_block();
	S_ENABLE  := func_block.S_ENABLE;
	R_ENABLE  := func_block.R_ENABLE;
	ERROR  := func_block.ERROR;
	IP_C  := func_block.IP_C;
	S_BUF  := func_block.S_BUF;
	R_BUF  := func_block.R_BUF;


END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION
