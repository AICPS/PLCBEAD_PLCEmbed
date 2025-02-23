TYPE
  oscat_STRING1               : STRING;
  oscat_STRING2               : STRING;
  oscat_STRING3               : STRING;
  oscat_STRING4               : STRING;
  oscat_STRING5               : STRING;
  oscat_STRING8               : STRING;
  oscat_STRING10              : STRING;
  oscat_STRING12            : STRING;
  oscat_STRING15            : STRING;
  oscat_STRING20            : STRING;
  oscat_STRING27            : STRING;
  oscat_STRING30            : STRING;
  oscat_STRING32            : STRING;
  oscat_STRING40            : STRING;
  oscat_STRING48            : STRING;
  oscat_STRING50            : STRING;
  oscat_STRING60            : STRING;
  oscat_STRING64            : STRING;
  oscat_STRING80            : STRING;
  oscat_STRING120            : STRING;
  oscat_STRING140            : STRING;
  oscat_STRING160            : STRING;
  oscat_STRING180            : STRING;
  oscat_STRING190            : STRING;
  oscat_STRING250            : STRING;
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

  (* --------- WEATHER CHANNEL --------- *)
  oscat_YAHOO_WEATHER_DATA:
  STRUCT
    TIMETOLIVE:                 INT;              (* TIME TO LIVE: HOW LONG IN MINUTES THIS FEED SHOULD BE CACHED         *)    
    LOCATION_CITY:              OSCAT_STRING40;   (* THE LOCATION OF THIS FORECAST: CITY: CITY NAME  *)
    LOCATION_REGION:            OSCAT_STRING20;   (* THE LOCATION OF THIS FORECAST: REGION: STATE, TERRITORY, OR REGION, IF GIVEN *)
    LOCATION_COUNTRY:           OSCAT_STRING20;    (* THE LOCATION OF THIS FORECAST: COUNTRY: TWO-CHARACTER COUNTRY CODE *)
    UNIT_TEMPERATURE:           OSCAT_STRING1;    (* TEMPERATURE: DEGREE UNITS, F FOR FAHRENHEIT OR C FOR CELSIUS *)  
    UNIT_DISTANCE:              OSCAT_STRING2;    (* DISTANCE: UNITS FOR DISTANCE, MI FOR MILES OR KM FOR KILOMETERS *)  
    UNIT_PRESSURE:              OSCAT_STRING2;    (* PRESSURE: UNITS OF BAROMETRIC PRESSURE, IN FOR POUNDS PER SQUARE INCH OR MB FOR MILLIBARS *)  
    UNIT_SPEED:                 OSCAT_STRING4;    (* SPEED: UNITS OF SPEED, MPH FOR MILES PER HOUR OR KPH FOR KILOMETERS PER HOUR *)  
    WIND_CHILL:                 INT;              (* FORECAST INFORMATION ABOUT WIND CHILL IN DEGREES *)
    WIND_DIRECTION:             INT;              (* FORECAST INFORMATION ABOUT WIND DIRECTION, IN DEGREES *)
    WIND_SPEED:                 REAL;             (* FORECAST INFORMATION ABOUT WIND SPEED, IN THE UNITS (MPH OR KPH)*)
    ATMOSPHERE_HUMIDITY:        INT;              (* FORECAST INFORMATION ABOUT CURRENT ATMOSPHERIC HUMIDITY: HUMIDITY, IN PERCENT  *)
    ATMOSPHERE_PRESSURE:        INT;              (* FORECAST INFORMATION ABOUT CURRENT ATMOSPHERIC PRESSURE: BAROMETRIC PRESSURE, IN THE UNITS (IN OR MB) *)
	ATMOSPHERE_VISIBILITY:      REAL;             (* FORECAST INFORMATION ABOUT CURRENT ATMOSPHERIC VISIBILITY, IN THE UNITS (MI OR KM) *)
	ATMOSPHERE_RISING:          INT;              (* FORECAST INFORMATION ABOUT RISING: STATE OF THE BAROMETRIC PRESSURE: STEADY (0), RISING (1), OR FALLING (2). (INTEGER: 0, 1, 2) *)
    ASTRONOMY_SUNRISE:          OSCAT_STRING10;   (* SUNRISE: TODAY'S SUNRISE TIME. THE TIME IS A STRING IN A LOCAL TIME FORMAT OF "H:MM AM/PM" *)
    ASTRONOMY_SUNSET:           OSCAT_STRING10;   (* SUNSET: TODAY'S SUNSET TIME. THE TIME IS A STRING IN A LOCAL TIME FORMAT OF "H:MM AM/PM", *)
    GEO_LATITUDE:               REAL;             (* THE LATITUDE OF THE LOCATION *)
    GEO_LONGITUDE:              REAL;             (* THE LONGITUDE OF THE LOCATION *)
    CUR_CONDITIONS_TEMP:        INT;              (* THE CURRENT WEATHER CONDITIONS: TEMP: THE CURRENT TEMPERATURE, IN THE UNITS (F OR C) *)
    CUR_CONDITIONS_TEXT:        OSCAT_STRING40;   (* THE CURRENT WEATHER CONDITIONS: TEXT: A TEXTUAL DESCRIPTION OF CONDITIONS *)
    CUR_CONDITIONS_CODE:        INT;              (* THE CURRENT WEATHER CONDITIONS: CODE: THE CONDITION CODE FOR THIS FORECAST *)
	CUR_CONDITIONS_ICON:        INT;			  (* THE CURRENT WEATHER CONDITIONS: ICON: THE CONDITION ICON FOR THIS FORECAST *)
    FORCAST_TODAY_LOW_TEMP:     INT;              (* THE FORCAST TODAY WEATHER CONDITIONS: THE FORECASTED LOW TEMPERATURE FOR THIS DAY IN THE UNITS (F OR C) *)
    FORCAST_TODAY_HIGH_TEMP:    INT;              (* THE FORCAST TODAY WEATHER CONDITIONS: THE FORECASTED HIGH TEMPERATURE FOR THIS DAY IN THE UNITS (F OR C) *)
    FORCAST_TODAY_TEXT:         OSCAT_STRING40;   (* THE FORCAST TODAY WEATHER CONDITIONS: TEXT: A TEXTUAL DESCRIPTION OF CONDITIONS *)
    FORCAST_TODAY_CODE:         INT;              (* THE CURRENT WEATHER CONDITIONS: CODE: THE CONDITION CODE FOR THIS FORECAST *)
	FORCAST_TODAY_ICON:         INT;			  (* THE CURRENT WEATHER CONDITIONS: ICON: THE CONDITION ICON FOR THIS FORECAST *)
    FORCAST_TOMORROW_LOW_TEMP:  INT;              (* THE FORCAST TOMORROW WEATHER CONDITIONS: THE FORECASTED LOW TEMPERATURE FOR THIS DAY IN THE UNITS (F OR C) *)
    FORCAST_TOMORROW_HIGH_TEMP: INT;              (* THE FORCAST TOMORROW WEATHER CONDITIONS: THE FORECASTED HIGH TEMPERATURE FOR THIS DAY IN THE UNITS (F OR C) *)
    FORCAST_TOMORROW_TEXT:      OSCAT_STRING40;   (* THE FORCAST TOMORROW WEATHER CONDITIONS: TEXT: A TEXTUAL DESCRIPTION OF CONDITIONS *)
    FORCAST_TOMORROW_CODE:      INT;              (* THE CURRENT WEATHER CONDITIONS: CODE: THE CONDITION CODE FOR THIS FORECAST *)
	FORCAST_TOMORROW_ICON:      INT;			  (* THE CURRENT WEATHER CONDITIONS: ICON: THE CONDITION ICON FOR THIS FORECAST *)
  END_STRUCT;

  oscat_YAHOO_WEATHER_aI0_48 : ARRAY[0..48] OF INT;

  oscat_IP2GEO_DATA:
  STRUCT
	STATE :				BOOL;			  (* STATE *)
	IP4 :				DWORD;			  (* IP-Adresse *)
    COUNTRY_CODE :		oscat_STRING2;    (*   *)
    COUNTRY_NAME :		oscat_STRING20;   (*   *)
    REGION_CODE :		oscat_STRING2;    (*   *)
    REGION_NAME :		oscat_STRING20;   (*   *)
    CITY :				oscat_STRING20;   (*   *)
    GEO_LATITUDE :		REAL;             (*   *)
    GEO_LONGITUDE :		REAL;             (*   *)
	TIME_ZONE_NAME :	oscat_STRING20;
	GMT_OFFSET :		INT;
	IS_DST :			BOOL;
  END_STRUCT;
END_TYPE

FUNCTION_BLOCK YAHOO_WEATHER_ICON_OSCAT_Block

	VAR_INPUT
		ACTIVATE :	BOOL;
	END_VAR


	VAR_IN_OUT
		YW :	oscat_YAHOO_WEATHER_DATA;
	END_VAR


	VAR
		act_last :	BOOL;
		x :	INT;
		init :	BOOL;
		dat :	oscat_YAHOO_WEATHER_aI0_48;
	END_VAR

	IF not init THEN
		init := TRUE;

		dat[00] := 4;
		dat[01] := 2;
		dat[02] := 2;
		dat[03] := 4;
		dat[04] := 17;
		dat[05] := 1;
		dat[06] := 3;
		dat[07] := 1;
		dat[08] := 2;
		dat[09] := 2;
		dat[10] := 2;
		dat[11] := 2;
		dat[12] := 2;
		dat[13] := 3;
		dat[14] := 3;
		dat[15] := 3;
		dat[16] := 3;
		dat[17] := 5;
		dat[18] := 3;
		dat[19] := 6;
		dat[20] := 7;
		dat[21] := 14;
		dat[22] := 8;
		dat[23] := 9;
		dat[24] := 9;
		dat[25] := 10;
		dat[26] := 9;
		dat[27] := 11;
		dat[28] := 12;
		dat[29] := 11;
		dat[30] := 12;
		dat[31] := 13;
		dat[32] := 14;
		dat[33] := 15;
		dat[34] := 16;
		dat[35] := 4;
		dat[36] := 14;
		dat[37] := 4;
		dat[38] := 17;
		dat[39] := 2;
		dat[40] := 2;
		dat[41] := 3;
		dat[42] := 3;
		dat[43] := 3;
		dat[44] := 12;
		dat[45] := 2;
		dat[46] := 3;
		dat[47] := 4;
		dat[48] := 0;
	END_IF;

	IF ACTIVATE AND act_last = FALSE THEN
		x := MIN(YW.CUR_CONDITIONS_CODE,48);
		YW.CUR_CONDITIONS_ICON := dat[x];
		x := MIN(YW.FORCAST_TODAY_CODE,48);
		YW.FORCAST_TODAY_ICON := dat[x];
		x := MIN(YW.FORCAST_TOMORROW_CODE,48);
		YW.FORCAST_TOMORROW_ICON := dat[x];
	END_IF;
	act_last := ACTIVATE;

END_FUNCTION_BLOCK

PROGRAM program0
	VAR
		ACTIVATE :	BOOL;
		YW :	oscat_YAHOO_WEATHER_DATA;

		func_block : YAHOO_WEATHER_ICON_OSCAT_Block;
	END_VAR
	func_block.ACTIVATE := ACTIVATE;
	func_block.YW := YW;

	func_block();
	YW  := func_block.YW;
END_PROGRAM

CONFIGURATION Config0
	RESOURCE Res0 ON PLC
		TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
		PROGRAM instance0 WITH task0 : program0;
	END_RESOURCE
END_CONFIGURATION