FUNCTION_BLOCK CHR_TO_STRING_Block
	VAR_INPUT
		C :	BYTE;
	END_VAR

	VAR_OUTPUT
		CHR_TO_STRING :	STRING;
	END_VAR

	CHR_TO_STRING := BYTE_TO_STRING(C);

END_FUNCTION_BLOCK

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

FUNCTION_BLOCK IRTRANS_DECODE_Block

	VAR_OUTPUT
		CMD :	BOOL;
		DEV :	STRING;
		KEY :	STRING;
		ERROR :	BOOL;
	END_VAR


	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		R_BUF :	oscat_NETWORK_BUFFER;
	END_VAR


	VAR
		i :	INT;
		stop :	INT;
		received_string :	STRING;
		char :	STRING;
		CHR_TO_STRING :	CHR_TO_STRING_Block;
		z :	BYTE;
	END_VAR

	i := UINT_TO_INT(R_BUF.SIZE);
	IF i >= 5 AND (i <= 82) AND IP_C.MAILBOX[1] <> z THEN
		error := TRUE;
		i := i - 1; 

		IF R_BUF.BUFFER[i] <> BYTE#10 THEN RETURN; END_IF;
		i := i - 1;
		IF R_BUF.BUFFER[i] <> BYTE#13 THEN RETURN; END_IF;
		i := i - 1;

		stop := 0;
		received_string := '';

		WHILE stop <= i DO
			CHR_TO_STRING(C:=R_BUF.BUFFER[stop]);
			char := CHR_TO_STRING.CHR_TO_STRING;
			received_string := CONCAT(received_string,char);
			stop := stop + INT#1;
		END_WHILE;

		stop := FIND(received_string,',');
		IF stop > 0 AND stop - 1 < i THEN
			DEV := LEFT(received_string,stop - 1);
			key := RIGHT(received_string,i - stop + 1);
			IF LEN(DEV) = 0 OR LEN(key) = 0 THEN RETURN; END_IF;
			cmd := TRUE;
			error := FALSE;
		END_IF;
	ELSE
		cmd := FALSE;
		error := FALSE;
	END_IF;

	z := IP_C.MAILBOX[1];

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		IP_C :	oscat_IP_C;
		R_BUF :	oscat_NETWORK_BUFFER;
		CMD :	BOOL;
		DEV :	STRING;
		KEY :	STRING;
		ERROR :	BOOL;

		func_block : IRTRANS_DECODE_Block;
	END_VAR
	func_block.IP_C := IP_C;
	func_block.R_BUF := R_BUF;

	func_block();
	IP_C  := func_block.IP_C;
	R_BUF  := func_block.R_BUF;
	CMD  := func_block.CMD;
	DEV  := func_block.DEV;
	KEY  := func_block.KEY;
	ERROR  := func_block.ERROR;



END_PROGRAM

CONFIGURATION Config0

  	RESOURCE Res0 ON PLC
    	TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    	PROGRAM instance0 WITH task0 : program0;
  	END_RESOURCE

END_CONFIGURATION
