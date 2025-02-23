TYPE
  oscat_STRING30              : STRING;
  oscat_STRING250             : STRING;
  oscat_STRING8               : STRING;
  oscat_STRING60               : STRING;
  oscat_STRING3               : STRING;
  oscat_STRING10               : STRING;
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

  oscat_XML_CONTROL:
  STRUCT
    COMMAND:             WORD;            (*W                 *)
    WATCHDOG:            TIME;            (*W                 *)
    START_POS:           UINT;            (*W                 *)
    STOP_POS:            UINT;            (*W                 *)
    COUNT:               UINT;            (*R                 *)
    TYP:                 INT;             (*R                 *)
    LEVEL:               UINT;            (*R                 *)
    PATH:                oscat_STRING250; (*R                 *)
    ELEMENT:             oscat_STRING250; (*R                 *)
    ATTRIBUTE:           oscat_STRING250; (*R                 *)
    VALUE:               oscat_STRING250; (*R                 *)
    BLOCK1_START:        UINT;            (*R                 *)
    BLOCK1_STOP:         UINT;            (*R                 *)
    BLOCK2_START:        UINT;            (*R                 *)
    BLOCK2_STOP:         UINT;            (*R                 *)
  END_STRUCT;

  (* --------- WORLD WEATHER --------- *)

  oscat_WORLD_WEATHER_CUR :
  STRUCT
	OBSERVATION_TIME : oscat_STRING8;
	TEMP_C           : INT;
	WEATHER_CODE     : INT;
	WEATHER_DESC 	 : oscat_STRING60;
	WEATHER_ICON     : INT;
	WIND_SPEED_MILES : INT;
	WIND_SPEED_KMPH  : INT;
	WIND_DIR_DEGREE  : INT;
	WIND_DIR16POINT  : oscat_STRING3;
	PRECIPMM         : REAL;
	HUMIDITY         : INT;
	VISIBILITY       : INT;
	PRESSURE         : INT;
	CLOUDOVER        : INT;
  END_STRUCT;

  oscat_WORLD_WEATHER_DAY :
  STRUCT
	DATE_OF_DAY      : oscat_STRING10;
	TEMP_MAX_C       : INT;
	TEMP_MAX_F       : INT;
	TEMP_MIN_C       : INT;
	TEMP_MIN_F       : INT;
	WIND_SPEED_MILES : INT;
	WIND_SPEED_KMPH  : INT;
	WIND_DIR_DEGREE  : INT;
	WIND_DIR16POINT  : oscat_STRING3;
	WEATHER_CODE     : INT;
	WEATHER_DESC     : oscat_STRING60;
	WEATHER_ICON     : INT;
	PRECIPMM         : REAL;
  END_STRUCT;

  oscat_WORLD_WEATHER_DAY_ARR : ARRAY [0..4] OF oscat_WORLD_WEATHER_DAY;

  oscat_WORLD_WEATHER_DATA :
  STRUCT
	CUR : oscat_WORLD_WEATHER_CUR;
	DAY : oscat_WORLD_WEATHER_DAY_ARR;
  END_STRUCT;

  oscat_WORLD_WEATHER_aI0_41 : ARRAY[0..41] OF INT;

END_TYPE

TYPE
  oscat_NW_BUF_LONG  : ARRAY [0..4095] OF BYTE;

  oscat_NETWORK_BUFFER :
  STRUCT
    SIZE   : UINT;	
    BUFFER : oscat_NW_BUF_LONG;
  END_STRUCT;

END_TYPE

FUNCTION_BLOCK WORLD_WEATHER_Block

	VAR_INPUT
		ACTIVATE :	BOOL;
		LATITUDE :	REAL;
		LONGITUDE :	REAL;
		KEY :	oscat_STRING30;
	END_VAR


	VAR_OUTPUT
		BUSY :	BOOL;
		DONE :	BOOL;
		ERROR_C :	DWORD;
		ERROR_T :	BYTE;
	END_VAR


	VAR_IN_OUT
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;
		WW :	oscat_WORLD_WEATHER_DATA;
	END_VAR

	VAR
		CHK_REAL :	CHK_REAL;
		REAL_TO_STRF :	REAL_TO_STRF;
		URL_DATA :	oscat_url;
		DNS_CLIENT :	DNS_CLIENT;
		HTTP_GET :	HTTP_GET;
		CPB :	CSV_PARSER_BUF;
		STRING_TO_URL :	STRING_TO_URL;
		FLOAT_TO_REAL :	FLOAT_TO_REAL;
		last_state :	BOOL;
		value_int :	INT;
		value_real :	REAL;
		v_real :	REAL;
		state :	INT;
		url_str :	oscat_STRING250;
		offset :	UDINT;
		size :	INT;
		sep :	BYTE;
		cnt :	INT;
		day :	INT;
		idx :	INT;
		run :	BYTE;
		result :	BYTE;
		value :	oscat_STRING250;
		DEC_TO_INT :	DEC_TO_INT;
		pos :	INT;
	END_VAR

	CASE state OF

	00:
		IF ACTIVATE AND NOT last_state THEN
			state := 20;
			DONE := FALSE;
			BUSY := TRUE;
			ERROR_C := DWORD#0;
			ERROR_T := BYTE#0;
		END_IF;

	20: 
		REAL_TO_STRF(IN:=LATITUDE,N:=6,D:='.');
		url_str := CONCAT('http://free.worldweatheronline.com/feed/weather.ashx?q=',REAL_TO_STRF.REAL_TO_STRF);
		url_str := CONCAT(url_str,',');
		REAL_TO_STRF(IN:=LONGITUDE,N:=6,D:='.');
		url_str := CONCAT(url_str,REAL_TO_STRF.REAL_TO_STRF);
		url_str := CONCAT(url_str,'&format=csv&num_of_days=5&key=');
		url_str := CONCAT(url_str,key);

		STRING_TO_URL(STR:=url_str, DEFAULT_PROTOCOL:='', DEFAULT_PATH:='' );
		URL_DATA:=STRING_TO_URL.STRING_TO_URL;

		state := 40;

	40:
		IF DNS_CLIENT.DONE THEN
			state := 60;
		ELSIF (DNS_CLIENT.ERROR > DWORD#00) THEN
			ERROR_C := DNS_CLIENT.ERROR;
			ERROR_T := BYTE#01;
			state   := 100;
		END_IF;

	60:
		IF HTTP_GET.DONE THEN
			sep := BYTE#0;
			idx := 0;
			day := 0;
			cnt := 0;
			OFFSET := UINT_TO_UDINT(HTTP_GET.BODY_START); 
			size := UINT_TO_INT(HTTP_GET.BODY_STOP);
			run := BYTE#1;
			state := 80;

		ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
			ERROR_C := HTTP_GET.ERROR;
			ERROR_T := BYTE#02;
			state := 100;
		END_IF;

	80:	IF run = BYTE#0 THEN 
			run := BYTE#1;
			IF result = BYTE#1 OR result = BYTE#2 THEN
				value_int := 0;
				value_real := 0.0;
				IF LEN(value) <= 20 THEN
					FLOAT_TO_REAL(FLT:=value);
					v_real := FLOAT_TO_REAL.FLOAT_TO_REAL;
					CHK_REAL(X := v_real);
					IF CHK_REAL.CHK_REAL = BYTE#0 THEN
						value_real := v_real;
						value_int := REAL_TO_INT(value_real);
					END_IF;
				END_IF;
				cnt := cnt + 1;
				IF cnt >=8 AND cnt <= 87 THEN
					IF cnt > 22 THEN
						CASE idx OF
						00:	WW.DAY[day].DATE_OF_DAY := value;
						01:	WW.DAY[day].TEMP_MAX_C := value_int;
						02:	WW.DAY[day].TEMP_MAX_F := value_int;
						03:	WW.DAY[day].TEMP_MIN_C := value_int;
						04:	WW.DAY[day].TEMP_MIN_F := value_int;
						05:	WW.DAY[day].WIND_SPEED_MILES := value_int;
						06:	WW.DAY[day].WIND_SPEED_KMPH := value_int;
						07:	WW.DAY[day].WIND_DIR_DEGREE := value_int;
						08:	WW.DAY[day].WIND_DIR16POINT := value;
						09:	WW.DAY[day].WEATHER_CODE := value_int;
						10:	pos := FIND(value, '/wsymbol_');
							IF pos > 0 AND LEN(value) > pos + 13 THEN
								DEC_TO_INT(DEC:=MID(value,4,pos + 9));
								WW.DAY[day].WEATHER_ICON := DEC_TO_INT.DEC_TO_INT;
							ELSE
								WW.DAY[day].WEATHER_ICON := 0;
							END_IF;
						11:	WW.DAY[day].WEATHER_DESC := value;
						12:	WW.DAY[day].PRECIPMM := value_real;
						END_CASE;
						idx := idx + 1;
						IF idx > 12 THEN
							idx := 0;
							day := day + 1;
						END_IF;
					ELSE
						CASE cnt OF
						08:	sep := BYTE#44;
						09:	WW.CUR.OBSERVATION_TIME := value;
						10:	WW.CUR.TEMP_C := value_int;
						11:	WW.CUR.WEATHER_CODE := value_int;
						12:	pos := FIND(value, '/wsymbol_');
							IF pos > 0 AND LEN(value) > pos + 13 THEN
								DEC_TO_INT(DEC:=MID(value,4,pos + 9));
								WW.CUR.WEATHER_ICON := DEC_TO_INT.DEC_TO_INT;
							ELSE
								WW.CUR.WEATHER_ICON := 0;
							END_IF;
						13:	WW.CUR.WEATHER_DESC := value;
						14:	WW.CUR.WIND_SPEED_MILES := value_int;
						15:	WW.CUR.WIND_SPEED_KMPH := value_int;
						16:	WW.CUR.WIND_DIR_DEGREE := value_int;
						17:	WW.CUR.WIND_DIR16POINT := value;
						18:	WW.CUR.PRECIPMM := value_real;
						19:	WW.CUR.HUMIDITY := value_int;
						20:	WW.CUR.VISIBILITY := value_int;
						21:	WW.CUR.PRESSURE := value_int;
						22:	WW.CUR.CLOUDOVER := value_int;
						END_CASE;
					END_IF;
				END_IF;
			ELSIF result = BYTE#10 THEN 
				DONE  := TRUE;
				run := BYTE#0; 
				state := 100;
			END_IF;
		END_IF;

	100:
		IF (NOT HTTP_GET.DONE) THEN
			state := 0;
			BUSY := FALSE;
			DONE := ERROR_T = BYTE#0;
		END_IF;

	END_CASE;

	DNS_CLIENT.IP_C     := IP_C;
	DNS_CLIENT.S_BUF    := S_BUF;
	DNS_CLIENT.R_BUF    := R_BUF;
	DNS_CLIENT.DOMAIN   := URL_DATA.DOMAIN;
	DNS_CLIENT.IP4_DNS  := DWORD#00;
	DNS_CLIENT.ACTIVATE := state=40;
	DNS_CLIENT();
	IP_C  := DNS_CLIENT.IP_C;
	S_BUF := DNS_CLIENT.S_BUF;
	R_BUF := DNS_CLIENT.R_BUF;


	HTTP_GET.IP_C        := IP_C;
	HTTP_GET.S_BUF       := S_BUF;
	HTTP_GET.R_BUF       := R_BUF;
	HTTP_GET.IP4         := DNS_CLIENT.IP4;
	HTTP_GET.GET         := state=60;
	HTTP_GET.MODE        := BYTE#2;  
	HTTP_GET.UNLOCK_BUF  := state=100; 
	HTTP_GET.URL_DATA    := URL_DATA;
	HTTP_GET();
	IP_C     := HTTP_GET.IP_C;
	S_BUF    := HTTP_GET.S_BUF;
	R_BUF    := HTTP_GET.R_BUF;
	URL_DATA := HTTP_GET.URL_DATA;


	CPB(SEP:=sep,RUN:=run,OFFSET:=offset,VALUE:=value,PT:=R_BUF); 
	run:=CPB.RUN;
	offset:=CPB.OFFSET;
	value:=CPB.VALUE;
	R_BUF:=CPB.PT;
	result:=CPB.RESULT;

	last_state := ACTIVATE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		ACTIVATE :	BOOL;
		LATITUDE :	REAL;
		LONGITUDE :	REAL;
		KEY :	oscat_STRING30;
		IP_C :	oscat_IP_C;
		S_BUF :	oscat_NETWORK_BUFFER;
		R_BUF :	oscat_NETWORK_BUFFER;
		WW :	oscat_WORLD_WEATHER_DATA;
		BUSY :	BOOL;
		DONE :	BOOL;
		ERROR_C :	DWORD;
		ERROR_T :	BYTE;

		func_block : WORLD_WEATHER_Block;
	END_VAR
	func_block.ACTIVATE := ACTIVATE;
	func_block.LATITUDE := LATITUDE;
	func_block.LONGITUDE := LONGITUDE;
	func_block.KEY := KEY;
	func_block.IP_C := IP_C;
	func_block.S_BUF := S_BUF;
	func_block.R_BUF := R_BUF;
	func_block.WW := WW;
	

	func_block();
	IP_C  := func_block.IP_C;
	S_BUF  := func_block.S_BUF;
	R_BUF  := func_block.R_BUF;
	WW  := func_block.WW;
	BUSY  := func_block.BUSY;
	DONE  := func_block.DONE;
	ERROR_C  := func_block.ERROR_C;
	ERROR_T  := func_block.ERROR_T;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION