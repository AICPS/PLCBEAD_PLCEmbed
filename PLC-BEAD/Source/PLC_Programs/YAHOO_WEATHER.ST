FUNCTION_BLOCK YAHOO_WEATHER

  VAR_IN_OUT
    IP_C :	oscat_IP_C;
    S_BUF :	oscat_NETWORK_BUFFER;
    R_BUF :	oscat_NETWORK_BUFFER;
    YW :	oscat_YAHOO_WEATHER_DATA;
  END_VAR


  VAR_INPUT
    ACTIVATE :	BOOL;
    UNITS :	BOOL;
    LOCATION :	oscat_STRING20;
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
    CHK_REAL :	CHK_REAL;
    last_state :	BOOL;
    value_int :	INT;
    value_real :	REAL;
    v_real :	REAL;
    state :	INT;
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
    STRING_TO_URL.STR:='http://weather.yahooapis.com/forecastrss';
    STRING_TO_URL.DEFAULT_PROTOCOL:='';
    STRING_TO_URL.DEFAULT_PATH:='';
    STRING_TO_URL();
    URL_DATA:=STRING_TO_URL.STRING_TO_URL;

    URL_DATA.QUERY := CONCAT('w=',LOCATION);

    IF UNITS THEN
      URL_DATA.QUERY := CONCAT(URL_DATA.QUERY,'&u=f'); 
    ELSE
      URL_DATA.QUERY := CONCAT(URL_DATA.QUERY,'&u=c'); 
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
        v_real:=FLOAT_TO_REAL.FLOAT_TO_REAL;
      CHK_REAL(X:= v_real); 
      IF CHK_REAL.CHK_REAL = BYTE#0 THEN
        value_real := v_real;
      value_int := REAL_TO_INT(value_real);
      END_IF;
    END_IF;

      IF CTRL.COUNT < UINT#52 THEN 
        CASE UINT_TO_INT(CTRL.COUNT) OF 
          027: YW.TimeToLive := value_int; 
          030: YW.location_city := CTRL.VALUE; 
          031: YW.location_region := CTRL.VALUE; 
          032: YW.location_country := CTRL.VALUE; 
          035: YW.unit_temperature := CTRL.VALUE; 
          036: YW.unit_distance := CTRL.VALUE; 
          037: YW.unit_pressure := CTRL.VALUE; 
          038: YW.unit_speed := CTRL.VALUE; 
          041: YW.wind_chill := value_int; 
          042: YW.wind_direction := value_int; 
          043: YW.wind_speed := value_real; 
          046: YW.atmosphere_humidity := value_int; 
          047: YW.atmosphere_visibility := value_real; 
          048: YW.atmosphere_pressure := value_int; 
          049: YW.atmosphere_rising := value_int; 
        END_CASE;
      ELSE
        CASE UINT_TO_INT(CTRL.COUNT) OF 
          052: YW.astronomy_sunrise := CTRL.VALUE; 
          053: YW.astronomy_sunset := CTRL.VALUE; 
          077: YW.geo_latitude := value_real; 
          080: YW.geo_longitude := value_real; 
          089: YW.cur_conditions_text := CTRL.VALUE; 
      090: YW.cur_conditions_code := value_int;
        YW.cur_conditions_icon := value_int;
          091: YW.cur_conditions_temp := value_int; 
          100: YW.forcast_today_low_temp := value_int; 
          101: YW.forcast_today_high_temp := value_int; 
          102: YW.forcast_today_text := CTRL.VALUE; 
      103: YW.forcast_today_code := value_int;
        YW.forcast_today_icon := value_int;
          108: YW.forcast_tomorrow_low_temp := value_int; 
          109: YW.forcast_tomorrow_high_temp := value_int; 
          110: YW.forcast_tomorrow_text := CTRL.VALUE; 
      111: YW.forcast_tomorrow_code := value_int;
        YW.forcast_tomorrow_icon := value_int;
        END_CASE;
      END_IF; 
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
