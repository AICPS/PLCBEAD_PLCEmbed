FUNCTION_BLOCK IP2GEO

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
    GEO :	oscat_IP2GEO_DATA;
  END_VAR


  VAR_INPUT
    IP :	DWORD;
    ACTIVATE :	BOOL;
  END_VAR


  VAR_OUTPUT
    BUSY :	BOOL;
    DONE :	BOOL;
    ERROR_C :	DWORD;
    ERROR_T :	BYTE;
  END_VAR

  VAR
    CTRL :	oscat_XML_CONTROL;
    XML_READER :	XML_READER;
    URL_DATA :	oscat_url;
    DNS_CLIENT :	DNS_CLIENT;
    STRING_TO_URL :	STRING_TO_URL;
    HTTP_GET :	HTTP_GET;
    FLOAT_TO_REAL :	FLOAT_TO_REAL;
    last_state :	BOOL;
    value_int :	INT;
    value_real :	REAL;
    v_real :	REAL;
    state :	INT;
    IP4_TO_STRING :	IP4_TO_STRING;
    IP4_DECODE :	IP4_DECODE;
    CHK_REAL :	CHK_REAL;
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
    STRING_TO_URL.STR:='http://ipinfodb.com/ip_query.php?timezone=true&IP=';
    STRING_TO_URL.DEFAULT_PROTOCOL:='';
    STRING_TO_URL.DEFAULT_PATH:='';
    STRING_TO_URL();
    URL_DATA:=STRING_TO_URL.STRING_TO_URL;

    IF IP > DWORD#0 THEN
      IP4_TO_STRING(IP4:=IP);
      URL_DATA.QUERY := CONCAT(URL_DATA.QUERY,IP4_TO_STRING.IP4_TO_STRING);
    END_IF;

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
      state := 80;
      CTRL.START_POS := HTTP_GET.BODY_START;
      CTRL.STOP_POS  := HTTP_GET.BODY_STOP;
      CTRL.COMMAND   := WORD#2#10000000_00011000; 
    CTRL.WATCHDOG  := T#1ms;

    ELSIF (HTTP_GET.ERROR > DWORD#00) THEN
      ERROR_C := HTTP_GET.ERROR;
      ERROR_T := BYTE#02;
      state   := 100;
    END_IF;

  80:
    XML_READER.CTRL := CTRL;
    XML_READER.BUF  := R_BUF.BUFFER;
    XML_READER();
    CTRL         := XML_READER.CTRL;
    R_BUF.BUFFER := XML_READER.BUF;

    IF CTRL.TYP < 98 THEN
      value_int := 0;
      value_real := 0.0;
      IF LEN(CTRL.VALUE) <= 20 THEN
            FLOAT_TO_REAL(FLT:=CTRL.VALUE);
        v_real :=FLOAT_TO_REAL.FLOAT_TO_REAL;
        CHK_REAL(X:= v_real);
        IF CHK_REAL.CHK_REAL = BYTE#0 THEN
          value_real := v_real;
          value_int := REAL_TO_INT(value_real);
        END_IF;
      END_IF;

      CASE UINT_TO_INT(CTRL.COUNT) OF 

        07: IP4_DECODE(STR:=CTRL.VALUE);
            GEO.IP4 := IP4_DECODE.IP4_DECODE; 
      10: GEO.STATE := EQ_STRING('OK',CTRL.VALUE);
      13: GEO.COUNTRY_CODE := CTRL.VALUE; 
      16: GEO.COUNTRY_NAME := CTRL.VALUE; 
      19: GEO.REGION_CODE := CTRL.VALUE;
      22: GEO.REGION_NAME := CTRL.VALUE;
      25: GEO.CITY := CTRL.VALUE; 
      31: GEO.GEO_LATITUDE := value_real;
      34: GEO.GEO_LONGITUDE := value_real; 
      37: GEO.TIME_ZONE_NAME := CTRL.VALUE;
      40: GEO.GMT_OFFSET := value_int; 
      43: GEO.IS_DST := value_int > 0; 
      END_CASE;

    ELSIF CTRL.TYP = 99 THEN
      DONE  := TRUE;
      state := 100;
    END_IF; 

  100:
    IF (NOT HTTP_GET.DONE) THEN
      state := 0;
      BUSY  := FALSE;
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

  last_state := ACTIVATE;

END_FUNCTION_BLOCK
